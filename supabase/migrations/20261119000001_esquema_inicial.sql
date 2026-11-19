-- SPEC 1.3 — Esquema inicial da Plataforma de estudos com IA
-- Modelo: docs/ARCHITECTURE.md §4. Tipos espelhados em packages/types/src/index.ts.

create extension if not exists pgcrypto;

-- ---------- Tipos ----------
create type public.papel as enum ('aluno', 'revisor', 'admin');
create type public.bloco as enum ('gerais', 'especificos');
create type public.tipo_bloco_plano as enum ('teoria', 'questoes', 'revisao', 'simulado');
create type public.status_bloco_plano as enum ('previsto', 'feito', 'perdido', 'compensado', 'cortado');
create type public.status_questao as enum ('rascunho', 'revisada', 'publicada', 'suspensa');
create type public.origem_questao as enum ('gerada', 'real');
create type public.plataforma as enum ('android', 'ios', 'web', 'desktop');
create type public.tipo_notificacao as enum (
  'hora_de_estudar', 'sessao_perdida', 'compensacao', 'revisao',
  'simulado', 'contagem_regressiva', 'resumo_semanal'
);

-- ---------- Utilitário: updated_at ----------
create or replace function public.tocar_updated_at() returns trigger
language plpgsql as $$
begin
  new.updated_at := now();
  return new;
end $$;

-- ---------- Usuários ----------
create table public.perfil (
  id uuid primary key references auth.users (id) on delete cascade,
  nome text,
  papel public.papel not null default 'aluno',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.criar_perfil_para_novo_usuario() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.perfil (id, nome) values (new.id, new.raw_user_meta_data ->> 'nome');
  return new;
end $$;

create trigger ao_criar_usuario
  after insert on auth.users
  for each row execute function public.criar_perfil_para_novo_usuario();

-- ---------- Catálogo do edital ----------
create table public.concurso (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  nome text not null,
  cargo text not null,
  banca text not null,
  data_prova date not null,
  alternativas_por_questao smallint not null check (alternativas_por_questao between 2 and 5),
  duracao_minutos integer not null check (duracao_minutos > 0),
  questoes_gerais integer not null check (questoes_gerais >= 0),
  peso_gerais numeric(4,2) not null check (peso_gerais > 0),
  questoes_especificos integer not null check (questoes_especificos >= 0),
  peso_especificos numeric(4,2) not null check (peso_especificos > 0),
  nota_minima numeric(4,2) not null check (nota_minima between 0 and 10),
  fonte text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.disciplina (
  id uuid primary key default gen_random_uuid(),
  concurso_id uuid not null references public.concurso (id) on delete cascade,
  nome text not null,
  bloco public.bloco not null,
  questoes integer not null check (questoes > 0),
  ordem integer not null,
  unique (concurso_id, nome)
);

create table public.topico (
  id uuid primary key default gen_random_uuid(),
  disciplina_id uuid not null references public.disciplina (id) on delete cascade,
  nome text not null,
  ordem integer not null,
  a_conferir boolean not null default true,
  unique (disciplina_id, nome)
);

-- ---------- Matrícula e plano ----------
create table public.matricula (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid not null references auth.users (id) on delete cascade,
  concurso_id uuid not null references public.concurso (id) on delete restrict,
  polo text,
  -- minutos disponíveis por dia da semana: {"seg":120,"ter":60,...}
  minutos_por_dia jsonb not null default '{}'::jsonb,
  -- horários preferidos: {"seg":"19:00",...}
  horarios jsonb not null default '{}'::jsonb,
  limite_extra_minutos_dia integer not null default 30 check (limite_extra_minutos_dia >= 0),
  silencio_inicio time,
  silencio_fim time,
  pausado_em date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (usuario_id, concurso_id)
);

create table public.bloco_plano (
  id uuid primary key default gen_random_uuid(),
  matricula_id uuid not null references public.matricula (id) on delete cascade,
  data date not null,
  inicio time,
  topico_id uuid references public.topico (id) on delete set null,
  tipo public.tipo_bloco_plano not null,
  minutos integer not null check (minutos > 0),
  status public.status_bloco_plano not null default 'previsto',
  origem_compensacao uuid references public.bloco_plano (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index bloco_plano_matricula_data on public.bloco_plano (matricula_id, data);
create index bloco_plano_status_data on public.bloco_plano (status, data);

-- ---------- Questões ----------
create table public.questao (
  id uuid primary key default gen_random_uuid(),
  topico_id uuid not null references public.topico (id) on delete restrict,
  enunciado text not null,
  alternativas jsonb not null, -- [{"letra":"A","texto":"..."}, ...]
  gabarito char(1) not null check (gabarito in ('A','B','C','D','E')),
  comentario jsonb,            -- {"A":"por que está errada", ...}
  origem public.origem_questao not null default 'gerada',
  fonte text,                  -- para questões reais: prova, ano, banca
  status public.status_questao not null default 'rascunho',
  autor_id uuid references auth.users (id) on delete set null,
  revisor_id uuid references auth.users (id) on delete set null,
  revisada_em timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  -- RF2 do PRD: nada é publicado sem revisor registrado
  constraint publicada_exige_revisor check (status <> 'publicada' or revisor_id is not null)
);
create index questao_topico_status on public.questao (topico_id, status);

-- ---------- Sessões, respostas, simulados ----------
create table public.sessao (
  id uuid primary key default gen_random_uuid(),
  matricula_id uuid not null references public.matricula (id) on delete cascade,
  bloco_plano_id uuid references public.bloco_plano (id) on delete set null,
  topico_id uuid references public.topico (id) on delete set null,
  iniciada_em timestamptz not null default now(),
  concluida_em timestamptz,
  minutos_estudados integer not null default 0 check (minutos_estudados >= 0),
  etapa_atual integer not null default 0
);
create index sessao_matricula on public.sessao (matricula_id, iniciada_em desc);

create table public.simulado (
  id uuid primary key default gen_random_uuid(),
  matricula_id uuid not null references public.matricula (id) on delete cascade,
  tipo text not null default 'completo' check (tipo in ('completo', 'disciplina', 'diagnostico')),
  iniciado_em timestamptz not null default now(),
  entregue_em timestamptz,
  acertos_gerais integer,
  acertos_especificos integer,
  nota_final numeric(5,2)
);

create table public.resposta (
  id uuid primary key default gen_random_uuid(),
  matricula_id uuid not null references public.matricula (id) on delete cascade,
  questao_id uuid not null references public.questao (id) on delete restrict,
  sessao_id uuid references public.sessao (id) on delete cascade,
  simulado_id uuid references public.simulado (id) on delete cascade,
  escolhida char(1) check (escolhida in ('A','B','C','D','E')),
  correta boolean,
  respondida_em timestamptz not null default now(),
  chave_idempotencia text,
  unique (matricula_id, chave_idempotencia)
);
create index resposta_matricula on public.resposta (matricula_id, respondida_em desc);

-- ---------- Notificações e dispositivos ----------
create table public.dispositivo (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid not null references auth.users (id) on delete cascade,
  plataforma public.plataforma not null,
  push_token text not null,
  created_at timestamptz not null default now(),
  unique (usuario_id, push_token)
);

create table public.notificacao (
  id uuid primary key default gen_random_uuid(),
  matricula_id uuid not null references public.matricula (id) on delete cascade,
  tipo public.tipo_notificacao not null,
  bloco_plano_id uuid references public.bloco_plano (id) on delete set null,
  titulo text not null,
  corpo text not null,
  agendada_para timestamptz not null,
  enviada_em timestamptz,
  lida_em timestamptz,
  created_at timestamptz not null default now()
);
create index notificacao_pendente on public.notificacao (agendada_para) where enviada_em is null;

-- ---------- Feature flags ----------
create table public.feature_flag (
  chave text primary key,
  ativo boolean not null default false,
  descricao text not null
);
insert into public.feature_flag (chave, ativo, descricao) values
  ('revisao_espacada', false, 'Cartões de revisão espaçada (P1)'),
  ('resumo_semanal', false, 'Resumo semanal por notificação e e-mail (P1)'),
  ('voz_na_sessao', false, 'Perguntas por voz na sessão guiada'),
  ('agente_editais', false, 'Agente local de busca de editais (pós-piloto)');

-- ---------- updated_at automático ----------
create trigger tocar_perfil before update on public.perfil for each row execute function public.tocar_updated_at();
create trigger tocar_concurso before update on public.concurso for each row execute function public.tocar_updated_at();
create trigger tocar_matricula before update on public.matricula for each row execute function public.tocar_updated_at();
create trigger tocar_bloco_plano before update on public.bloco_plano for each row execute function public.tocar_updated_at();
create trigger tocar_questao before update on public.questao for each row execute function public.tocar_updated_at();
