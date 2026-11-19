# ARCHITECTURE — Plataforma de estudos com IA

> Versão 0.1 · 18/11/2026 · Conceito #2. Decisões marcadas **[ADR-n]** estão justificadas em `DECISIONS.md`.
> Status: **proposta**, aguardando aprovação do dono antes da Fase 1.

## 1. Visão de alto nível

```mermaid
flowchart TB
  subgraph Clientes
    M[App celular<br/>Expo / React Native]
    W[Site / PWA<br/>Next.js]
    D[Desktop<br/>Tauri - pós-piloto]
  end
  subgraph Servidor["Servidor da plataforma (Supabase)"]
    A[Auth + RLS]
    DB[(Postgres)]
    EF[Edge Functions<br/>API do domínio]
    PL[Motor do plano]
    SC[Agendador<br/>pg_cron]
  end
  subgraph IA
    LLM[Modelo maior via API<br/>explicação e questões]
    AG[Agente local CPU<br/>pós-piloto]
  end
  PUSH[Push<br/>Expo/FCM/APNs + Web Push]

  M & W & D --> A
  M & W & D --> EF
  EF --> PL --> DB
  SC --> PL
  SC --> PUSH --> M & W
  EF --> LLM
  AG -.-> DB
```

## 2. Tech stack

| Camada | Escolha | Motivo | ADR |
| --- | --- | --- | --- |
| App celular | Expo (React Native) + TypeScript | Um código para Android e iPhone; push nativo via Expo Notifications | ADR-1 |
| Site | Next.js (App Router) + TypeScript, PWA | Mesmo idioma do app; deploy simples na Vercel; web push | ADR-1 |
| Desktop (pós-piloto) | Tauri sobre o site | Leve; reaproveita o site | ADR-1 |
| Backend | Supabase: Postgres, Auth, RLS, Edge Functions, pg_cron, Storage | Multiusuário com regras no banco; cron nativo para avisos | ADR-2 |
| Deploy | Vercel (site), EAS (app), Supabase (backend) | Estágios preview/produção prontos | ADR-2 |
| IA de conteúdo | Modelo maior via API (provedor a escolher em `EVALUATION.md`) | Qualidade em português e explicações | ADR-3 |
| Agente local | Modelo de 3–4B via llama.cpp, em CPU, no servidor | Busca e organização baratas; pós-piloto | ADR-4 |
| Monorepo | pnpm + Turborepo | Tipos e regras compartilhados entre app e site | ADR-1 |

## 3. Estrutura de pastas

Ver `PROJECT_STRUCTURE.md`.

## 4. Modelo de dados (núcleo)

```mermaid
erDiagram
  USUARIO ||--o{ MATRICULA : tem
  CONCURSO ||--o{ MATRICULA : recebe
  CONCURSO ||--o{ DISCIPLINA : contem
  DISCIPLINA ||--o{ TOPICO : contem
  MATRICULA ||--o{ BLOCO_PLANO : gera
  TOPICO ||--o{ BLOCO_PLANO : agenda
  TOPICO ||--o{ QUESTAO : cobre
  MATRICULA ||--o{ SESSAO : registra
  SESSAO ||--o{ RESPOSTA : contem
  QUESTAO ||--o{ RESPOSTA : respondida
  MATRICULA ||--o{ SIMULADO : faz
  MATRICULA ||--o{ NOTIFICACAO : recebe
  USUARIO ||--o{ DISPOSITIVO : usa
```

| Tabela | Campos-chave |
| --- | --- |
| `concurso` | id, nome, banca, data_prova, formula_nota (json), nota_minima |
| `disciplina` | id, concurso_id, nome, bloco (gerais/especificos), peso, n_questoes |
| `topico` | id, disciplina_id, nome, ordem, fonte (anexo IV) |
| `matricula` | id, usuario_id, concurso_id, polo, horas_semana (json), horarios, limite_extra_dia |
| `bloco_plano` | id, matricula_id, data, topico_id, tipo (teoria/questoes/revisao), minutos, status (previsto/feito/perdido/compensado) |
| `questao` | id, topico_id, enunciado, alternativas (json), gabarito, comentario, origem (gerada/real), status (rascunho/revisada/publicada/suspensa), revisor_id |
| `sessao` / `resposta` | progresso da sessão guiada e de cada questão |
| `simulado` | id, matricula_id, nota_gerais, nota_especificos, nota_final |
| `notificacao` | id, matricula_id, tipo, agendada_para, enviada_em, lida_em |
| `dispositivo` | id, usuario_id, plataforma, push_token |

## 5. Fluxos de dados críticos

**5.1 Geração e recálculo do plano** (motor do plano, função pura testável)

```mermaid
sequenceDiagram
  participant App
  participant API as Edge Function
  participant Plano as Motor do plano
  participant DB
  App->>API: salvar objetivo / diagnóstico
  API->>Plano: gerar(matricula, tópicos, pesos, domínio, horas)
  Plano->>DB: grava blocos até data_prova
  Note over Plano: prioridade = peso_bloco × n_questões × (1 − domínio)
  App->>API: sessão concluída / perdida
  API->>Plano: recalcular(a partir de hoje)
```

**5.2 Notificações e compensação**

```mermaid
sequenceDiagram
  participant Cron as pg_cron (a cada 5 min)
  participant Plano as Motor do plano
  participant Push
  Cron->>Plano: blocos com horário em ≤ 5 min
  Plano->>Push: "Hora de estudar"
  Cron->>Plano: blocos vencidos há 60 min sem sessão
  Plano->>Push: "Sessão perdida"
  Cron->>Plano: 07h — perdidos de ontem
  Plano->>Plano: redistribuir (limite_extra_dia, maior peso primeiro)
  Plano->>Push: "Compensação"
```

**5.3 Sessão guiada:** app → Edge Function → monta contexto (tópico, nível, erros recentes, material aprovado) → modelo via API em streaming → resposta para o app; questões só saem do banco com status `publicada`.

## 6. Padrões de API

- REST via Edge Functions, JSON, versão no caminho (`/v1/...`).
- Paginação por cursor em listas (questões, histórico).
- Leituras simples direto do Supabase com RLS; regras de negócio sempre em Edge Function.
- Cache de explicações por (tópico, nível) e de questões geradas, para reduzir custo de API.
- Idempotência em "concluir sessão" e "responder questão" (chave por requisição).

## 7. Feature flags

Tabela `feature_flag` (chave, ativo, público). Flags previstas: `revisao_espacada`, `resumo_semanal`, `voz_na_sessao`, `agente_editais`. Toda flag nova é registrada aqui e em `DECISIONS.md`.

## 8. Estágios e deploy

LOCAL → PREVIEW (cada branch: Vercel preview + Supabase branch) → QA → PRODUÇÃO. Detalhe em `IMPLEMENTATION_PLAN.md` e `SECURITY.md` (variáveis separadas por estágio).

## 9. Escalabilidade

Piloto: ~30–100 alunos; plano gratuito/básico do Supabase e da Vercel atende. Gargalos esperados: custo de API do modelo (mitigar com cache) e cron de notificações (indexar `bloco_plano(data, status)`).
