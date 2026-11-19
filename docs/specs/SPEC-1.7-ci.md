# SPEC 1.7 — Integração contínua (gate de merge)

- **Fase:** 1 · **Conceitos:** #9, #12, #15 · **Status:** aprovada para execução

## Contexto
O manifesto exige gate automático e juiz ≠ gerador. As ferramentas do harness (hooks, `proof.mjs`) não existem neste projeto; o CI cumpre esse papel aqui.

## Tarefa
Workflow do GitHub Actions que roda em todo PR e push na `main`.

## Arquivos
`.github/workflows/ci.yml`, `.github/pull_request_template.md`, `.github/CODEOWNERS`

## Etapas do CI
1. Instalar (pnpm, cache).
2. `pnpm typecheck` e `pnpm lint`.
3. `pnpm test`.
4. Seed sincronizado: `pnpm seed:gerar` e falhar se `supabase/seed.sql` mudar.
5. Varredura de segredos (gitleaks).
6. Bloqueio de TODO/FIXME novos em `packages/core` (gate contra "pronto" com pendência).

## Critérios de aceitação
1. Um PR com teste vermelho fica bloqueado.
2. Um PR com uma chave falsa no código é bloqueado pelo gitleaks.
3. Template de PR pede: spec ligada, testes, prova (log/screenshot), docs atualizados.
4. Proteção da `main` exige 1 aprovação de alguém que não é o autor (configurar no GitHub: ver `LEIA-ME`).

## Out of scope
Deploy automático (Fase 6), testes de RLS no CI (precisam de Supabase local no runner: Fase 2).
