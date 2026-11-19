-- SPEC 1.4 — Testes de RLS. Rodar contra um banco com as migrações e o seed aplicados:
--   psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/tests/rls_test.sql
-- Tudo roda numa transação e é desfeito no final. Qualquer falha aborta com erro.

begin;

-- Usuários de teste
insert into auth.users (id, raw_user_meta_data) values
  ('00000000-0000-0000-0000-00000000000a', '{"nome":"Aluno A"}'),
  ('00000000-0000-0000-0000-00000000000b', '{"nome":"Aluno B"}'),
  ('00000000-0000-0000-0000-00000000000c', '{"nome":"Revisor"}');
update public.perfil set papel = 'revisor' where id = '00000000-0000-0000-0000-00000000000c';

-- Critério SPEC 1.3: perfil criado pelo trigger com papel aluno
do $$ begin
  if (select papel from public.perfil where id = '00000000-0000-0000-0000-00000000000a') <> 'aluno' then
    raise exception 'FALHA: perfil do aluno A não foi criado com papel aluno';
  end if;
end $$;

-- Dados: matrícula e bloco do aluno B; uma questão em rascunho e uma publicada
insert into public.matricula (id, usuario_id, concurso_id)
  select '10000000-0000-0000-0000-00000000000b', '00000000-0000-0000-0000-00000000000b', id
  from public.concurso where slug = 'banestes-2026-tecnico-bancario';
insert into public.bloco_plano (matricula_id, data, tipo, minutos)
  values ('10000000-0000-0000-0000-00000000000b', '2026-12-15', 'teoria', 40);
insert into public.questao (id, topico_id, enunciado, alternativas, gabarito, status)
  select '20000000-0000-0000-0000-000000000001', id, 'Rascunho', '[]', 'A', 'rascunho' from public.topico limit 1;
insert into public.questao (id, topico_id, enunciado, alternativas, gabarito, status, revisor_id)
  select '20000000-0000-0000-0000-000000000002', id, 'Publicada', '[]', 'B', 'publicada',
         '00000000-0000-0000-0000-00000000000c' from public.topico limit 1;

-- Critério RF2: não publica sem revisor
do $$ begin
  begin
    insert into public.questao (topico_id, enunciado, alternativas, gabarito, status)
      select id, 'Sem revisor', '[]', 'C', 'publicada' from public.topico limit 1;
    raise exception 'FALHA: questão publicada sem revisor foi aceita';
  exception when check_violation then null;
  end;
end $$;

-- ===== Como aluno A =====
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-00000000000a","role":"authenticated"}', true);

do $$ begin
  -- 1. Não lê dados do aluno B
  if (select count(*) from public.matricula) <> 0 then raise exception 'FALHA 1: aluno A vê matrícula de B'; end if;
  if (select count(*) from public.bloco_plano) <> 0 then raise exception 'FALHA 1: aluno A vê plano de B'; end if;
  -- 2. Só vê questão publicada
  if exists (select 1 from public.questao where status <> 'publicada') then raise exception 'FALHA 2: aluno vê questão não publicada'; end if;
  if (select count(*) from public.questao) <> 1 then raise exception 'FALHA 2: aluno deveria ver exatamente 1 questão publicada'; end if;
  -- catálogo legível
  if (select count(*) from public.disciplina) <> 9 then raise exception 'FALHA: aluno deveria ler as 9 disciplinas'; end if;
end $$;

-- 3. Não troca o próprio papel
do $$ begin
  begin
    update public.perfil set papel = 'admin' where id = '00000000-0000-0000-0000-00000000000a';
    raise exception 'FALHA 3: aluno conseguiu alterar o próprio papel';
  exception when insufficient_privilege then null;
  end;
end $$;

-- 5. Não insere no catálogo
do $$ begin
  begin
    insert into public.concurso (slug, nome, cargo, banca, data_prova, alternativas_por_questao, duracao_minutos,
      questoes_gerais, peso_gerais, questoes_especificos, peso_especificos, nota_minima, fonte)
      values ('x', 'x', 'x', 'x', '2027-01-01', 5, 60, 1, 1, 1, 1, 6, 'x');
    raise exception 'FALHA 5: aluno inseriu concurso';
  exception when insufficient_privilege then null;
  end;
end $$;

-- Aluno A não cria matrícula em nome de B
do $$ begin
  begin
    insert into public.matricula (usuario_id, concurso_id)
      select '00000000-0000-0000-0000-00000000000b', id from public.concurso limit 1;
    raise exception 'FALHA: aluno A criou matrícula para B';
  exception when insufficient_privilege then null;
  end;
end $$;

-- ===== Como revisor =====
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-00000000000c","role":"authenticated"}', true);
do $$
declare n int;
begin
  -- 4. Revisor publica questão
  update public.questao
     set status = 'publicada', revisor_id = '00000000-0000-0000-0000-00000000000c', revisada_em = now()
   where id = '20000000-0000-0000-0000-000000000001';
  get diagnostics n = row_count;
  if n <> 1 then raise exception 'FALHA 4: revisor não conseguiu publicar'; end if;
end $$;

reset role;
select 'RLS: todos os testes passaram' as resultado;
rollback;
