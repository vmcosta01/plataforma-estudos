# supabase — Banco, regras de acesso e carga do edital

| Caminho | Conteúdo |
| --- | --- |
| `migrations/20261119000001_esquema_inicial.sql` | Tabelas, tipos, índices, trigger de perfil (SPEC 1.3) |
| `migrations/20261119000002_rls.sql` | Regras de acesso por papel (SPEC 1.4) |
| `seed.sql` | Edital Banestes — **gerado** por `pnpm seed:gerar`, não editar à mão (SPEC 1.6) |
| `tests/rls_test.sql` | Testes de acesso (aluno A × B, questões, papel) |
| `tests/stub_auth_supabase.sql` | Simulação mínima do Supabase para testar em Postgres puro |

## Como testar

- Sem Supabase CLI: `bash scripts/testar-banco-local.sh` (precisa de Postgres 15+ instalado).
- Com Supabase CLI: `supabase init` (gera `config.toml`), `supabase start`, `supabase db reset`, depois `psql "$DATABASE_URL" -f supabase/tests/rls_test.sql`.

O `config.toml` será criado pelo `supabase init` na Fase 1 (tarefa 1.2), junto com o projeto no painel do Supabase.
