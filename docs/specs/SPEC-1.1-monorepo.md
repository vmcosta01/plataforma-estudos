# SPEC 1.1 — Monorepo, TypeScript e lint

- **Fase:** 1 · **Conceitos:** #5, #15, #21 · **Status:** aprovada para execução (ordem do dono em 18/11/2026, 23:01)

## Contexto
Base de código única para app (Expo), site (Next.js) e regras compartilhadas, conforme ADR-1 e `PROJECT_STRUCTURE.md`.

## Tarefa
Criar a raiz do monorepo com pnpm workspaces e Turborepo, TypeScript estrito compartilhado e scripts padrão.

## Arquivos
`package.json`, `pnpm-workspace.yaml`, `turbo.json`, `tsconfig.base.json`, `.gitignore`, `.editorconfig`, `.nvmrc`, `apps/*/LEIA-ME.md`, `packages/types/`, `packages/ui/LEIA-ME.md`.

## Constraints
- Node 22 LTS, pnpm 9.
- `strict: true`, `noUncheckedIndexedAccess: true`.
- Nenhum segredo; `.env*` ignorado, exceto `.env.example`.
- `apps/mobile` e `apps/web` ficam como pastas reservadas (geradas na Fase 2 com os geradores oficiais).

## Critérios de aceitação (testáveis)
1. `pnpm install` conclui sem erro.
2. `pnpm test` roda os testes de todos os pacotes e termina com código 0.
3. `pnpm typecheck` termina com código 0.
4. `git check-ignore .env` retorna `.env`.

## Testes esperados
Os testes de `packages/core` (SPEC 1.5) rodam via `pnpm test` na raiz.

## Out of scope
Gerar apps Expo/Next, design system em código, deploy.
