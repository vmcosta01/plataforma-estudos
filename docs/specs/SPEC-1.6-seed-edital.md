# SPEC 1.6 — Carga (seed) do edital Banestes

- **Fase:** 1 · **Conceitos:** #5 · **Status:** aprovada para execução, com conferência pendente

## Contexto
O plano e as questões dependem do edital carregado no banco. Fonte: edital 01/2026, Anexo IV (conteúdo programático) e quadro de provas.

## Tarefa
Gerar `supabase/seed.sql` a partir dos dados de `packages/core` (fonte única) com o script `scripts/gerar-seed.ts`, e conferir com `scripts/conferir-edital.ts`.

## Arquivos
`scripts/gerar-seed.ts`, `scripts/conferir-edital.ts`, `supabase/seed.sql`

## Constraints
- Os dados vêm de um único lugar (`packages/core/src/editais/...`); o SQL é gerado, nunca editado à mão.
- IDs determinísticos (uuid v5 a partir do nome) para o seed poder rodar de novo sem duplicar.
- Tópicos foram transcritos de um resumo do Anexo IV: **marcados como "a conferir"** até alguém comparar com o PDF oficial do edital (não com a apostila).

## Critérios de aceitação
1. `pnpm seed:gerar` gera `supabase/seed.sql` idêntico ao versionado (o CI falha se divergir).
2. `pnpm edital:conferir` imprime 9 disciplinas, 30 + 40 = 70 questões e a fórmula, e termina com código 0.
3. `supabase db reset` carrega o seed sem erro.
4. Checklist de conferência manual contra o PDF oficial preenchido em `docs/specs/CONFERENCIA-EDITAL.md`.

## Out of scope
Outros concursos; Técnico em Segurança do Trabalho.
