# MEMORY — Estado do projeto

> Conceito #7. Atualizado a cada sessão. Última atualização: 19/11/2026, 23h (Fase 1: Supabase em nuvem, edital oficial).

## Decisions
- [18/11/2026] Piloto = Banestes Técnico Bancário, prova 24/01/2027 (ADR-0).
- [18/11/2026] Plataformas: celular, site e desktop sincronizados; desktop só após o piloto.
- [18/11/2026] Requisitos do dono: plano de estudos, notificações de hora de estudar, compensação de horas perdidas, mostrar o que já estudou e o que falta.
- [19/11/2026] Dono ordenou seguir; Fase 1 iniciada com stack provisória (ADR-6).
- [19/11/2026] Edital com fonte única em `packages/core`; seed gerado (ADR-7).
- [19/11/2026] Arredondamento pelo item 14.2 (ADR-8); Supabase `plataforma-estudos`, ref `syaijialseosppxhgfqp`, São Paulo (ADR-9); login e-mail + Google (ADR-10).

## Current State
- Funcionando localmente (com prova em `docs/provas/2026-11-19-fase1-fundacao.md`): monorepo, núcleo `@plataforma/core` (edital + nota, 23 testes), migrações com RLS testada, seed idempotente do edital, conferência automática, workflow de CI.
- Supabase em nuvem com migrações 1–3 e seed (106 tópicos), RLS testada, Security Advisor limpo.
- Repositório privado github.com/vmcosta01/plataforma-estudos; PR #1 (branch feat/fase1-fundacao) aberto; CI bloqueado por cobrança da conta GitHub.
- Não existe ainda: apps Expo/Next, Google OAuth configurado.
- Artefatos online: especificação (https://claude.ai/artifact/MzMJUvh5BgrAyDGoJpz2XF), planilha de concursos (https://claude.ai/artifact/54xPhtR9V2KXUs1jnkDmRT), telas (https://claude.ai/artifact/LRzVsubmL8kPLPXTaa5Dwh).

## Known Issues
- Edital conferido por Claude contra o PDF oficial; falta conferência humana por amostragem.
- GAP no APP_FLOW: T8 sem questões publicadas para o tópico.
- Personas do PRD são hipotéticas; faltam entrevistas.
- Admin não altera `perfil.papel` pelo cliente (só pelo painel/service_role) — intencional, revisar se precisar de tela de admin.
- Nenhuma auditoria independente (juiz ≠ gerador) feita ainda.

## Lessons Learned
- Pasta do computador precisa estar conectada à conversa específica, não só ao projeto.
- `pnpm install` falha em pastas que não aceitam links simbólicos (ENOSYS); instale e rode em pasta local comum.
- Habilitação na borda (6,00) exige conta em frações inteiras, não em ponto flutuante.

- Apple Sign In pode ser exigido pela App Store quando há login com Google: avaliar antes do iOS.

## Failed Approaches
- `pnpm install` dentro de pasta montada sem suporte a symlink → erro ENOSYS.

## Useful Commands
- `pnpm install` · `pnpm test` · `pnpm lint`
- `pnpm seed:gerar` (regenera `supabase/seed.sql`) · `pnpm edital:conferir`
- `bash scripts/testar-banco-local.sh` (migrações + seed + RLS em Postgres local)
