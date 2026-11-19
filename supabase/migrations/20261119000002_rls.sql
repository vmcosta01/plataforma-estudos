-- SPEC 1.4 — Regras de acesso (RLS). Papéis: docs/SECURITY.md §1.

-- Papel do usuário logado (lido do banco, nunca do cliente).
create or replace function public.papel_atual() returns public.papel
language sql stable security definer set search_path = public as $$
  select papel from public.perfil where id = auth.uid()
$$;

create or replace function public.eh_dono_da_matricula(m uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.matricula where id = m and usuario_id = auth.uid())
$$;

revoke all on function public.papel_atual() from public;
revoke all on function public.eh_dono_da_matricula(uuid) from public;
grant execute on function public.papel_atual() to authenticated;
grant execute on function public.eh_dono_da_matricula(uuid) to authenticated;

-- Ativa RLS em todas as tabelas
alter table public.perfil enable row level security;
alter table public.concurso enable row level security;
alter table public.disciplina enable row level security;
alter table public.topico enable row level security;
alter table public.matricula enable row level security;
alter table public.bloco_plano enable row level security;
alter table public.questao enable row level security;
alter table public.sessao enable row level security;
alter table public.simulado enable row level security;
alter table public.resposta enable row level security;
alter table public.dispositivo enable row level security;
alter table public.notificacao enable row level security;
alter table public.feature_flag enable row level security;

-- ---------- perfil ----------
create policy perfil_ler_proprio on public.perfil for select to authenticated
  using (id = auth.uid() or public.papel_atual() = 'admin');
create policy perfil_editar_proprio on public.perfil for update to authenticated
  using (id = auth.uid()) with check (id = auth.uid());
-- O aluno não pode trocar o próprio papel: só a coluna nome é editável pelo cliente.
revoke update on public.perfil from authenticated;
grant update (nome) on public.perfil to authenticated;
create policy perfil_admin on public.perfil for all to authenticated
  using (public.papel_atual() = 'admin') with check (public.papel_atual() = 'admin');

-- ---------- catálogo (leitura para logados, escrita só admin) ----------
create policy concurso_ler on public.concurso for select to authenticated using (true);
create policy concurso_admin on public.concurso for all to authenticated
  using (public.papel_atual() = 'admin') with check (public.papel_atual() = 'admin');
create policy disciplina_ler on public.disciplina for select to authenticated using (true);
create policy disciplina_admin on public.disciplina for all to authenticated
  using (public.papel_atual() = 'admin') with check (public.papel_atual() = 'admin');
create policy topico_ler on public.topico for select to authenticated using (true);
create policy topico_admin on public.topico for all to authenticated
  using (public.papel_atual() = 'admin') with check (public.papel_atual() = 'admin');
create policy flag_ler on public.feature_flag for select to authenticated using (true);
create policy flag_admin on public.feature_flag for all to authenticated
  using (public.papel_atual() = 'admin') with check (public.papel_atual() = 'admin');

-- ---------- dados do aluno ----------
create policy matricula_dono on public.matricula for all to authenticated
  using (usuario_id = auth.uid()) with check (usuario_id = auth.uid());

create policy bloco_plano_dono on public.bloco_plano for all to authenticated
  using (public.eh_dono_da_matricula(matricula_id)) with check (public.eh_dono_da_matricula(matricula_id));
create policy sessao_dono on public.sessao for all to authenticated
  using (public.eh_dono_da_matricula(matricula_id)) with check (public.eh_dono_da_matricula(matricula_id));
create policy simulado_dono on public.simulado for all to authenticated
  using (public.eh_dono_da_matricula(matricula_id)) with check (public.eh_dono_da_matricula(matricula_id));
create policy resposta_dono on public.resposta for all to authenticated
  using (public.eh_dono_da_matricula(matricula_id)) with check (public.eh_dono_da_matricula(matricula_id));
-- notificações: o aluno lê e marca como lida; quem cria é o servidor (service_role, ignora RLS)
create policy notificacao_ler on public.notificacao for select to authenticated
  using (public.eh_dono_da_matricula(matricula_id));
create policy notificacao_marcar_lida on public.notificacao for update to authenticated
  using (public.eh_dono_da_matricula(matricula_id)) with check (public.eh_dono_da_matricula(matricula_id));
revoke update on public.notificacao from authenticated;
grant update (lida_em) on public.notificacao to authenticated;

create policy dispositivo_dono on public.dispositivo for all to authenticated
  using (usuario_id = auth.uid()) with check (usuario_id = auth.uid());

-- ---------- questões ----------
create policy questao_aluno_ler_publicada on public.questao for select to authenticated
  using (status = 'publicada' or public.papel_atual() in ('revisor', 'admin'));
create policy questao_revisor_escrever on public.questao for all to authenticated
  using (public.papel_atual() in ('revisor', 'admin'))
  with check (public.papel_atual() in ('revisor', 'admin'));
