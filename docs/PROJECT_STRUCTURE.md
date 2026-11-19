# PROJECT_STRUCTURE — Estrutura do projeto

> Versão 0.1 · 18/11/2026 · Conceito #21. Estrutura modular de projeto de agente IA, adaptada a um monorepo com app, site e backend. Criada na Fase 1 (tarefa 1.1).

```
PLATAFORMA DE ESTUDOS/
├── CONCEITOS-DESENVOLVIMENTO-IA.md   # Manifesto (inviolável)
├── AGENTS.md                         # Regras para a IA
├── README.md                         # Visão rápida e como rodar
├── .env.example
├── apostila-...banestes-2026.pdf     # Referência interna (não versionar no git público)
├── docs/
│   ├── PRD.md  ARCHITECTURE.md  DESIGN_SYSTEM.md  APP_FLOW.md
│   ├── IMPLEMENTATION_PLAN.md  TASKS.md  DECISIONS.md  MEMORY.md
│   ├── TESTING.md  SECURITY.md  EVALUATION.md  PROJECT_STRUCTURE.md
│   ├── HANDOFF_<fase>.md
│   ├── specs/                        # Uma spec por tarefa (conceito #5)
│   └── referencia/                   # Especificação original, concursos, telas
├── apps/
│   ├── mobile/                       # Expo (Android/iPhone)
│   ├── web/                          # Next.js (site/PWA)
│   └── desktop/                      # Tauri (pós-piloto)
├── packages/
│   ├── core/                         # Regras puras: plano, nota, compensação
│   ├── ui/                           # Componentes e tokens do design system
│   └── types/                        # Tipos compartilhados
├── src/
│   ├── agents/                       # Prompts e definições: tutor, gerador, revisor
│   ├── memory/                       # Contexto do aluno (erros recentes, nível)
│   ├── workflows/                    # Pipeline gerar → revisar → publicar questões
│   ├── tools/                        # Ferramentas dos agentes (busca, leitura de PDF)
│   └── evaluation/                   # Datasets e resultados de benchmark
├── supabase/
│   ├── migrations/                   # Esquema do banco
│   ├── functions/                    # Edge Functions (API do domínio)
│   └── seed/                         # Edital Banestes
├── config/                           # Configurações por estágio
└── scripts/                          # Automações (conferir edital, rodar benchmark)
```

Regras: memória do aluno separada da lógica dos agentes; regras de negócio só em `packages/core`; nenhum segredo em nenhuma pasta.
