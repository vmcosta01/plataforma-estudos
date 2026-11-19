# AGENTS.md — Regras para a IA neste projeto

> Conceito #4. Vale para qualquer agente (Claude, Codex, etc.) que escreva, revise ou audite código ou documentos aqui.

## Contexto

Plataforma de estudos com IA para concursos. Piloto: Banestes Técnico Bancário, prova em 24/01/2027. Dono do produto: Victor Costa.

## Antes de qualquer tarefa (obrigatório)

1. Ler `CONCEITOS-DESENVOLVIMENTO-IA.md` (manifesto, todas as camadas).
2. Ler `docs/MEMORY.md`, `docs/TASKS.md` e o `HANDOFF_*.md` mais recente.
3. Ler os docs ligados à tarefa: `PRD.md`, `ARCHITECTURE.md`, `APP_FLOW.md`, `DESIGN_SYSTEM.md`, `SECURITY.md`.
4. Ter uma spec aprovada da tarefa em `docs/specs/` (conceito #5). Sem spec, não codar.

## Loop obrigatório

READ → UNDERSTAND → PLAN → IMPLEMENT → TEST → REVIEW → FIX → COMMIT → UPDATE DOCS

## Convenções de código

- TypeScript estrito em todo o monorepo; sem `any` sem justificativa.
- Regras de negócio (plano, nota, compensação) em `packages/core`, como funções puras com testes.
- Nomes de domínio em português (`matricula`, `blocoPlano`, `simulado`); código e comentários técnicos podem ser em inglês.
- Commits pequenos, mensagem descritiva, um assunto por commit; branch por feature (`feat/…`, `fix/…`); nunca commit direto na `main`.
- Testes junto da feature (TDD); teste de borda e "mordida" (reverter o conserto e ver o teste falhar).

## Segurança (camada zero)

- Nunca escrever segredos em código, docs ou commits; usar `.env` (não versionado) e `.env.example`.
- Toda autorização é verificada no servidor (RLS + Edge Functions), nunca só no app.
- Validar todo input no servidor.

## Conteúdo e direitos

- Não copiar texto, exercícios ou estrutura da apostila ou de cursos comerciais para dentro do app. A apostila serve só para calibrar tópicos.
- Questão só vai ao aluno com status `publicada` e revisor registrado.

## Boundaries — não mudar sem aprovação do dono

- `CONCEITOS-DESENVOLVIMENTO-IA.md`
- Escopo e Out of Scope do `PRD.md`
- Fórmula da nota e pesos do edital
- Stack definida em `ARCHITECTURE.md` / `DECISIONS.md`
- Políticas de `SECURITY.md`
- Qualquer coisa em produção

## Revisão

Juiz ≠ gerador: quem escreveu não aprova. Toda entrega passa por revisão independente (outro agente ou o dono) usando os prompts da camada 6 do manifesto.

## Comandos

| Comando | Faz |
| --- | --- |
| `pnpm install` | Instala dependências |
| `pnpm test` | Roda todos os testes |
| `pnpm lint` | Typecheck de pacotes e scripts |
| `pnpm seed:gerar` | Regenera `supabase/seed.sql` (nunca editar o seed à mão) |
| `pnpm edital:conferir` | Confere estrutura e fórmula do edital |
| `bash scripts/testar-banco-local.sh` | Migrações + seed + testes de RLS em Postgres local |
| `pnpm dev` | (Fase 2) sobe app e site em modo local |
