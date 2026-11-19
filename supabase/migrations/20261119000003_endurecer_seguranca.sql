-- Ajustes apontados pelo Security/Performance Advisor do Supabase em 19/11/2026.
-- 1) Funções SECURITY DEFINER saem da API pública (schema privado, sem acesso anon).
-- 2) search_path fixo em todas as funções.
-- 3) auth.uid() avaliado uma vez por consulta: (select auth.uid()).
-- 4) Uma política permissiva por ação (sem sobreposição admin × leitura).
-- 5) Índices para chaves estrangeiras.

create schema if not exists privado;
revoke all on schema privado from public;
grant usage on schema privado to authenticated;

create or replace function privado.papel_atual() returns public.papel
language sql stable security definer set search_path = '' as $$
  select papel from public.perfil where id = (select auth.uid())
$$;

create or replace function privado.eh_dono_da_matricula(m uuid) returns boolean
language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.matricula where id = m and usuario_id = (select auth.uid()))
$$;

revoke all on function privado.papel_atual() from public;
revoke all on function privado.eh_dono_da_matricula(uuid) from public;
grant execute on function privado.papel_atual() to authenticated;
grant execute on function privado.eh_dono_da_matricula(uuid) to authenticated;

-- Trigger de perfil: ninguém chama pela API
revoke all on function public.criar_perfil_para_novo_usuario() from public;
do $$ begin
  if exists (select 1 from pg_roles where rolname = 'anon') then
    execute 'revoke all on function public.criar_perfil_para_novo_usuario() from anon';
  end if;
  execute 'revoke all on function public.criar_perfil_para_novo_usuario() from authenticated';
end $$;

alter function public.tocar_updated_at() set search_path = '';

-- ---------- Recria as políticas ----------
drop policy if exists perfil_ler_proprio on public.perfil;
drop policy if exists perfil_editar_proprio on public.perfil;
drop policy if exists perfil_admin on public.perfil;
drop policy if exists concurso_ler on public.concurso;
drop policy if exists concurso_admin on public.concurso;
drop policy if exists disciplina_ler on public.disciplina;
drop policy if exists disciplina_admin on public.disciplina;
drop policy if exists topico_ler on public.topico;
drop policy if exists topico_admin on public.topico;
drop policy if exists flag_ler on public.feature_flag;
drop policy if exists flag_admin on public.feature_flag;
drop policy if exists matricula_dono on public.matricula;
drop policy if exists bloco_plano_dono on public.bloco_plano;
drop policy if exists sessao_dono on public.sessao;
drop policy if exists simulado_dono on public.simulado;
drop policy if exists resposta_dono on public.resposta;
drop policy if exists notificacao_ler on public.notificacao;
drop policy if exists notificacao_marcar_lida on public.notificacao;
drop policy if exists dispositivo_dono on public.dispositivo;
drop policy if exists questao_aluno_ler_publicada on public.questao;
drop policy if exists questao_revisor_escrever on public.questao;

drop function if exists public.papel_atual();
drop function if exists public.eh_dono_da_matricula(uuid);

-- perfil: lê o próprio (admin lê todos); edita só o próprio nome (grant de coluna da migração 2)
create policy perfil_ler on public.perfil for select to authenticated
  using (id = (select auth.uid()) or (select privado.papel_atual()) = 'admin');
create policy perfil_editar on public.perfil for update to authenticated
  using (id = (select auth.uid())) with check (id = (select auth.uid()));

-- catálogo: leitura para logados; escrita só admin (uma política por ação)
create policy concurso_ler on public.concurso for select to authenticated using (true);
create policy concurso_inserir on public.concurso for insert to authenticated with check ((select privado.papel_atual()) = 'admin');
create policy concurso_alterar on public.concurso for update to authenticated using ((select privado.papel_atual()) = 'admin') with check ((select privado.papel_atual()) = 'admin');
create policy concurso_excluir on public.concurso for delete to authenticated using ((select privado.papel_atual()) = 'admin');

create policy disciplina_ler on public.disciplina for select to authenticated using (true);
create policy disciplina_inserir on public.disciplina for insert to authenticated with check ((select privado.papel_atual()) = 'admin');
create policy disciplina_alterar on public.disciplina for update to authenticated using ((select privado.papel_atual()) = 'admin') with check ((select privado.papel_atual()) = 'admin');
create policy disciplina_excluir on public.disciplina for delete to authenticated using ((select privado.papel_atual()) = 'admin');

create policy topico_ler on public.topico for select to authenticated using (true);
create policy topico_inserir on public.topico for insert to authenticated with check ((select privado.papel_atual()) = 'admin');
create policy topico_alterar on public.topico for update to authenticated using ((select privado.papel_atual()) = 'admin') with check ((select privado.papel_atual()) = 'admin');
create policy topico_excluir on public.topico for delete to authenticated using ((select privado.papel_atual()) = 'admin');

create policy flag_ler on public.feature_flag for select to authenticated using (true);
create policy flag_inserir on public.feature_flag for insert to authenticated with check ((select privado.papel_atual()) = 'admin');
create policy flag_alterar on public.feature_flag for update to authenticated using ((select privado.papel_atual()) = 'admin') with check ((select privado.papel_atual()) = 'admin');
create policy flag_excluir on public.feature_flag for delete to authenticated using ((select privado.papel_atual()) = 'admin');

-- dados do aluno
create policy matricula_dono on public.matricula for all to authenticated
  using (usuario_id = (select auth.uid())) with check (usuario_id = (select auth.uid()));
create policy bloco_plano_dono on public.bloco_plano for all to authenticated
  using ((select privado.eh_dono_da_matricula(matricula_id))) with check ((select privado.eh_dono_da_matricula(matricula_id)));
create policy sessao_dono on public.sessao for all to authenticated
  using ((select privado.eh_dono_da_matricula(matricula_id))) with check ((select privado.eh_dono_da_matricula(matricula_id)));
create policy simulado_dono on public.simulado for all to authenticated
  using ((select privado.eh_dono_da_matricula(matricula_id))) with check ((select privado.eh_dono_da_matricula(matricula_id)));
create policy resposta_dono on public.resposta for all to authenticated
  using ((select privado.eh_dono_da_matricula(matricula_id))) with check ((select privado.eh_dono_da_matricula(matricula_id)));
create policy notificacao_ler on public.notificacao for select to authenticated
  using ((select privado.eh_dono_da_matricula(matricula_id)));
create policy notificacao_marcar_lida on public.notificacao for update to authenticated
  using ((select privado.eh_dono_da_matricula(matricula_id))) with check ((select privado.eh_dono_da_matricula(matricula_id)));
create policy dispositivo_dono on public.dispositivo for all to authenticated
  using (usuario_id = (select auth.uid())) with check (usuario_id = (select auth.uid()));

-- questões: aluno lê publicadas; revisor/admin leem tudo e escrevem
create policy questao_ler on public.questao for select to authenticated
  using (status = 'publicada' or (select privado.papel_atual()) in ('revisor', 'admin'));
create policy questao_inserir on public.questao for insert to authenticated
  with check ((select privado.papel_atual()) in ('revisor', 'admin'));
create policy questao_alterar on public.questao for update to authenticated
  using ((select privado.papel_atual()) in ('revisor', 'admin')) with check ((select privado.papel_atual()) in ('revisor', 'admin'));
create policy questao_excluir on public.questao for delete to authenticated
  using ((select privado.papel_atual()) in ('revisor', 'admin'));

-- ---------- Índices de chaves estrangeiras ----------
create index if not exists bloco_plano_origem_compensacao on public.bloco_plano (origem_compensacao);
create index if not exists bloco_plano_topico on public.bloco_plano (topico_id);
create index if not exists matricula_concurso on public.matricula (concurso_id);
create index if not exists notificacao_bloco_plano on public.notificacao (bloco_plano_id);
create index if not exists notificacao_matricula on public.notificacao (matricula_id);
create index if not exists questao_autor on public.questao (autor_id);
create index if not exists questao_revisor on public.questao (revisor_id);
create index if not exists resposta_questao on public.resposta (questao_id);
create index if not exists resposta_sessao on public.resposta (sessao_id);
create index if not exists resposta_simulado on public.resposta (simulado_id);
create index if not exists sessao_bloco_plano on public.sessao (bloco_plano_id);
create index if not exists sessao_topico on public.sessao (topico_id);
create index if not exists simulado_matricula on public.simulado (matricula_id);
