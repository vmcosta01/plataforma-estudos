# IMPLEMENTATION_PLAN — Fases do piloto

> Versão 0.1 · 18/11/2026 · Conceitos #19 e #20. Uma fase por vez; a próxima só começa com o gate verde da anterior. Fatias verticais (do banco à tela) em vez de camadas.
> Datas são proposta e dependem de quem vai desenvolver (questão em aberto no `PRD.md`).

| Fase | Período proposto | Entregável verificável |
| --- | --- | --- |
| 0. Planejamento | 18/11 a 22/11/2026 | Documentos obrigatórios aprovados pelo dono |
| 1. Fundação + edital | 23/11 a 27/11 | Monorepo, Supabase, auth, edital Banestes carregado |
| 2. Fatia: objetivo → plano → Hoje | 28/11 a 04/12 | Aluno de teste cria conta e vê o plano na tela Hoje |
| 3. Fatia: sessão guiada + questões | 28/11 a 08/12 (paralela à 2) | Sessão completa de 1 tópico com questões revisadas |
| 4. Fatia: notificações + compensação | 05/12 a 10/12 | 6 avisos funcionando de ponta a ponta |
| 5. Fatia: simulado + progresso | 05/12 a 11/12 | Simulado de 70 questões com nota correta |
| 6. QA, segurança e lançamento | 11/12 a 14/12 | Checklist `TESTING.md` verde; piloto no ar |
| 7. Operação do piloto | 14/12/2026 a 25/01/2027 | Monitoramento diário; comparação de notas |

---

## Fase 0 — Planejamento
- **Tarefas:** 0.1 PRD · 0.2 ARCHITECTURE · 0.3 DESIGN_SYSTEM · 0.4 APP_FLOW · 0.5 AGENTS · 0.6 SECURITY · 0.7 TESTING · 0.8 EVALUATION · 0.9 PROJECT_STRUCTURE · 0.10 MEMORY/DECISIONS/TASKS · 0.11 HANDOFF.
- **Gate:** dono aprova PRD (incluindo DoD e Out of Scope) e stack; GAPs do APP_FLOW resolvidos.
- **Out of scope:** qualquer código.

## Fase 1 — Fundação + edital
- **Tarefas:** 1.1 monorepo (pnpm, Turborepo, TypeScript, lint) · 1.2 projeto Supabase com estágios (local, preview, produção) · 1.3 migrações do modelo de dados · 1.4 RLS por usuário · 1.5 auth (e-mail e Google) · 1.6 seed do edital Banestes (9 disciplinas, tópicos do Anexo IV, pesos, fórmula) conferido contra o PDF oficial · 1.7 CI com testes e lint.
- **Dependências:** Fase 0.
- **Aceite:** `pnpm test` verde; script de conferência mostra 9 disciplinas, 70 questões no total e fórmula correta; usuário A não lê dados do usuário B (teste de RLS).
- **Out of scope:** telas além de login.

## Fase 2 — Objetivo → plano → Hoje (T1–T6)
- **Tarefas:** 2.1 motor do plano em `packages/core` (função pura) com testes · 2.2 telas T1–T3, T5, T6 no app e no site · 2.3 diagnóstico simples (T4) com questões seed · 2.4 recálculo diário.
- **Dependências:** Fase 1.
- **Aceite:** plano soma as horas declaradas (±5%); cobre todos os tópicos ou lista cortes; 6 estados de cada tela implementados.
- **Out of scope:** notificações, sessão guiada.

## Fase 3 — Sessão guiada + questões (T7–T8)
- **Tarefas:** 3.1 Edge Function de sessão com streaming do modelo · 3.2 prompt do tutor versionado em `src/agents/` · 3.3 pipeline de questões: gerar → revisar → publicar, com painel simples de revisão · 3.4 300 questões revisadas · 3.5 telas T7–T8.
- **Dependências:** Fase 1 (pode correr em paralelo à 2).
- **Aceite:** benchmark do tutor em `EVALUATION.md` acima do limiar; nenhuma questão sem revisor chega ao app (teste).
- **Out of scope:** voz (flag desligada), agente de editais.

## Fase 4 — Notificações + compensação
- **Tarefas:** 4.1 registro de dispositivos e tokens · 4.2 agendador pg_cron · 4.3 regras de compensação em `packages/core` com testes · 4.4 preferências em T12 · 4.5 web push.
- **Dependências:** Fase 2.
- **Aceite:** os 5 cenários de compensação de `TESTING.md` passam; avisos chegam em Android, iPhone e navegador com atraso < 2 min.
- **Out of scope:** resumo semanal por e-mail (P1).

## Fase 5 — Simulado + progresso (T9–T11)
- **Tarefas:** 5.1 montagem do simulado na proporção do edital · 5.2 cálculo da nota em `packages/core` · 5.3 telas T9–T11 · 5.4 métricas de progresso.
- **Dependências:** Fases 2 e 3.
- **Aceite:** nota bate com a planilha de conferência em 10 casos.
- **Out of scope:** ranking.

## Fase 6 — QA, segurança e lançamento
- **Tarefas:** 6.1 checklist completo de `TESTING.md` · 6.2 revisão de `SECURITY.md` · 6.3 auditoria isolada (juiz ≠ gerador) · 6.4 termos e privacidade publicados · 6.5 distribuição de teste do app (TestFlight / teste interno do Google Play) · 6.6 deploy em produção.
- **Aceite:** Definition of Done do `PRD.md` 100% comprovada.

## Fase 7 — Operação do piloto
- Monitoramento diário (app no ar, backup, falhas de push, questões reportadas, custo de API).
- Resumo semanal para o dono.
- Após 25/01/2027: questionário de nota real e relatório de métricas do PRD.
