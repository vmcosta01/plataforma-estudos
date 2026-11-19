# SPEC 1.4 — Regras de acesso (RLS)

- **Fase:** 1 · **Conceitos:** #12, #13 · **Status:** aprovada para execução

## Contexto
Papéis e permissões de `SECURITY.md` §1, aplicados no banco.

## Tarefa
Ativar RLS em todas as tabelas e criar políticas por papel.

## Arquivos
`supabase/migrations/20261119000002_rls.sql`, `supabase/tests/rls_test.sql`

## Constraints
- Função `public.papel_atual()` lê o papel do usuário logado em `perfil` (security definer, `search_path` fixo).
- Aluno: só linhas onde a matrícula é dele (`matricula.usuario_id = auth.uid()`), e `perfil`/`dispositivo` próprios.
- Catálogo (`concurso`, `disciplina`, `topico`): leitura para usuários logados; escrita só `admin`.
- `questao`: aluno lê só `status = 'publicada'`; `revisor` e `admin` leem e escrevem tudo.
- `feature_flag`: leitura para logados; escrita só `admin`.
- Aluno não pode alterar o próprio `papel`.

## Critérios de aceitação (testáveis em `rls_test.sql`)
1. Aluno A não lê matrícula, plano, sessões ou simulados do aluno B (0 linhas).
2. Aluno não lê questão em `rascunho` ou `revisada`.
3. Aluno não consegue mudar `perfil.papel` (update falha ou altera 0 linhas).
4. Revisor consegue mudar questão para `publicada`.
5. Aluno não insere em `concurso`.

## Out of scope
Autorização de Edge Functions (Fase 2+).
