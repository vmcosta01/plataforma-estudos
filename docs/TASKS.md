# TASKS — Quadro do projeto

> Conceito #7. Em andamento: máximo 3 itens. Atualizado em 19/11/2026, 23h.

## Next
1. **Dono:** confirmar no Supabase a migração 3 (endurecimento de segurança) — a confirmação expirou sem resposta.
2. **Dono:** revisar e aprovar o PR `feat/fase1-fundacao` no GitHub (juiz ≠ gerador) e ativar a proteção da `main`.
3. **Dono:** configurar o Google OAuth (passo a passo em `docs/specs/SPEC-1.5-autenticacao.md`).
4. Conferência humana por amostragem do edital (`docs/specs/CONFERENCIA-EDITAL.md` §3).
5. Aprovar formalmente PRD e ADR-1 a ADR-3; definir quem desenvolve.
6. Resolver GAP do APP_FLOW: T8 sem questões publicadas.

## In Progress
- Fase 1 — Fundação + edital: falta aplicar a migração 3 no Supabase, criar o repositório e configurar o Google.

## Completed
- Fase 0 — documentos obrigatórios → `docs/`, `HANDOFF_fase0-planejamento.md`
- 1.1 Monorepo (pnpm, Turborepo, TS estrito) → raiz, `packages/`
- 1.3 Modelo de dados → `supabase/migrations/20261119000001_esquema_inicial.sql`
- 1.4 RLS + testes → `supabase/migrations/20261119000002_rls.sql`, `supabase/tests/rls_test.sql`
- Núcleo: edital e nota com 23 testes e mordida → `packages/core/`, `docs/provas/2026-11-19-fase1-fundacao.md`
- 1.6 Seed gerado + conferência automática → `scripts/`, `supabase/seed.sql`
- 1.7 CI e template de PR → `.github/`
- 1.2 Projeto Supabase `plataforma-estudos` (São Paulo) com migrações 1–2 e seed; RLS testada na nuvem → `docs/provas/`
- Edital conferido contra o PDF oficial: 106 tópicos, arredondamento do item 14.2 → `docs/specs/CONFERENCIA-EDITAL.md`
- 1.5 Spec de autenticação (e-mail + Google) → `docs/specs/SPEC-1.5-autenticacao.md`

## Blocked
- CI rodando de verdade — precisa do repositório no GitHub.
- Fase 2 — bloqueada até o gate da Fase 1 (itens 1–4 de Next).

## Backlog
- Recrutar 30+ alunos do piloto e entrevistar 5–10 (a partir de 01/12/2026).
- Termos de uso e política de privacidade.
- Nome e marca da plataforma.
- Provedor do modelo via API e benchmark inicial.
- Modelo de cobrança pós-piloto.
- Agente de editais em CPU (pós-piloto).
- Núcleos seguintes: federais/jurídico, bancário Cesgranrio, policial.
