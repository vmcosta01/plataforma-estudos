# Plataforma de estudos com IA

Tutor de estudos com IA para concursos: monta o plano, conduz a sessão, aplica questões e simulados, avisa a hora de estudar e compensa horas perdidas. Piloto: Banestes Técnico Bancário (prova em 24/01/2027).

**Status:** Fase 1 — fundação em andamento (núcleo, banco, regras de acesso, carga do edital e CI prontos localmente; faltam Supabase em nuvem e autenticação).

## Por onde começar

1. `CONCEITOS-DESENVOLVIMENTO-IA.md` — manifesto de desenvolvimento (obrigatório).
2. `AGENTS.md` — regras para qualquer IA que trabalhe aqui.
3. `docs/PRD.md` — o que e por quê.
4. `docs/IMPLEMENTATION_PLAN.md` — fases e gates.
5. `docs/TASKS.md` e `docs/MEMORY.md` — onde estamos.
6. `docs/HANDOFF_fase0-planejamento.md` — último handoff.

## Documentos

| Documento | Conteúdo |
| --- | --- |
| `docs/PRD.md` | Produto, personas, features, DoD, Out of Scope, métricas |
| `docs/ARCHITECTURE.md` | Stack, diagramas, modelo de dados, fluxos |
| `docs/DESIGN_SYSTEM.md` | Tokens, componentes, 6 estados de UI |
| `docs/APP_FLOW.md` | Telas, ações e estados |
| `docs/IMPLEMENTATION_PLAN.md` | Fases 0–7 com gates |
| `docs/SECURITY.md` | Papéis, segredos, LGPD |
| `docs/TESTING.md` | Checklist e casos do domínio |
| `docs/EVALUATION.md` | Métricas dos agentes de IA |
| `docs/PROJECT_STRUCTURE.md` | Estrutura de pastas |
| `docs/DECISIONS.md` · `MEMORY.md` · `TASKS.md` | Decisões, estado, quadro |
| `docs/referencia/` | Especificação original, concursos 2027, telas |

## Como rodar

Requisitos: Node 22 e pnpm 9 (`npm i -g pnpm@9`). Para os testes do banco, Postgres 15+.

```bash
pnpm install            # instala dependências
pnpm test               # testes do núcleo (edital e nota)
pnpm lint               # typecheck
pnpm edital:conferir    # confere a estrutura do edital Banestes
pnpm seed:gerar         # regenera supabase/seed.sql a partir de packages/core
bash scripts/testar-banco-local.sh   # migrações + seed + testes de acesso (RLS)
```

## Código

| Pasta | Conteúdo |
| --- | --- |
| `packages/core` | Regras puras: edital, cálculo da nota (com testes) |
| `packages/types` | Tipos compartilhados |
| `supabase/` | Migrações, regras de acesso, seed do edital, testes |
| `scripts/` | Gerar seed, conferir edital, testar banco |
| `apps/` | App, site e desktop (reservados para a Fase 2) |
| `src/` | Agentes de IA, memória, workflows, ferramentas, avaliação (Fase 3) |
| `.github/` | CI, template de PR, CODEOWNERS |
| `docs/specs/` | Uma spec por tarefa |
| `docs/provas/` | Provas por artefato de cada fase |
