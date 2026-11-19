# HANDOFF — Fase 1 (fundação), parcial

> Conceito #8 · 19/11/2026 · De: Claude · Para: dono (Victor Costa) e próximo agente.

## 1. Contexto aprovado

- Fase 0 entregue (`HANDOFF_fase0-planejamento.md`).
- Dono ordenou continuar até criar os arquivos iniciais (ADR-6): Fase 1 iniciada com a stack provisória.

## 2. Artefatos gerados

| Caminho | O que é | Prova |
| --- | --- | --- |
| `docs/specs/SPEC-1.1 … 1.7` | Specs das tarefas da Fase 1 | — |
| `docs/specs/CONFERENCIA-EDITAL.md` | Checklist de 91 itens para conferir o edital | Pendente |
| `package.json`, `pnpm-workspace.yaml`, `turbo.json`, `tsconfig.base.json`, `pnpm-lock.yaml`, `.gitignore`, `.editorconfig`, `.nvmrc` | Monorepo | `pnpm install --frozen-lockfile` ok |
| `packages/core` | Edital Banestes + `validarEdital` + `calcularNota` | 23 testes verdes; 3 mordidas confirmadas |
| `packages/types` | Tipos compartilhados (espelham os enums do banco) | Typecheck ok |
| `supabase/migrations/*` | Esquema (13 tabelas) e RLS | Aplicadas em Postgres 16 |
| `supabase/seed.sql` | Edital gerado (9 disciplinas, 76 tópicos), idempotente | Rodado 2× sem erro |
| `supabase/tests/*` | Testes de RLS + simulação mínima do Supabase | `RLS: todos os testes passaram` |
| `scripts/*` | Gerar seed, conferir edital, testar banco local | Rodados |
| `.github/*` | CI (testes, seed, banco, gitleaks, TODO), template de PR, CODEOWNERS | Roda no PR desta branch |
| `apps/*`, `packages/ui`, `src/*`, `config/` | Pastas reservadas com LEIA-ME | — |
| `docs/provas/2026-11-19-fase1-fundacao.md` | Saídas dos testes e mordidas | — |

## 3. Blockers conhecidos

- Supabase em nuvem e repositório GitHub dependem de contas do dono.
- 76 tópicos do edital marcados "a conferir" até comparação com o PDF oficial.
- Auditoria independente (juiz ≠ gerador) não feita.

## 4. Próximo passo esperado

1. Conferir o edital (`docs/specs/CONFERENCIA-EDITAL.md`) e marcar `aConferir: false` no que bater; rodar `pnpm seed:gerar`.
2. Criar repositório no GitHub, subir o código numa branch, abrir PR e ver o CI verde.
3. Tarefa 1.2: projeto Supabase (região no Brasil, se disponível), `supabase init`, `supabase db push`.
4. Spec e implementação da autenticação (1.5).
5. Gate da Fase 1 → Fase 2 (objetivo → plano → Hoje).

## 5. Perguntas abertas

- Quem confere o edital: você ou um revisor?
- Conta GitHub e organização onde o repositório vai ficar?
- Região do Supabase e quem será o dono da conta?
- Mantemos login com Google além de e-mail?
