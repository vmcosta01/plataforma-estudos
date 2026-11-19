# HANDOFF — Fase 0 (planejamento)

> Conceito #8 · 18/11/2026 · De: Claude (sessão de planejamento) · Para: dono (Victor Costa) e próximo agente.

## 1. Contexto aprovado

- Produto: tutor de estudos com IA para concursos, com plano vivo, sessão guiada, questões, simulados, notificações e compensação de horas; celular, site e desktop sincronizados.
- Piloto: Banestes Técnico Bancário (FCC), prova em 24/01/2027 — aprovado pelo dono.
- Método: manifesto `CONCEITOS-DESENVOLVIMENTO-IA.md` v3.1 — documentos obrigatórios antes de código.

## 2. Artefatos gerados

| Caminho | Status |
| --- | --- |
| `README.md`, `AGENTS.md`, `.env.example` | Rascunho v0.1 |
| `docs/PRD.md` | Rascunho v0.1 — aguarda aprovação |
| `docs/ARCHITECTURE.md` | Proposta v0.1 — aguarda aprovação da stack |
| `docs/DESIGN_SYSTEM.md` | v0.1, extraído das telas |
| `docs/APP_FLOW.md` | v0.1, 1 GAP |
| `docs/IMPLEMENTATION_PLAN.md` | v0.1, datas propostas |
| `docs/SECURITY.md`, `docs/TESTING.md`, `docs/EVALUATION.md`, `docs/PROJECT_STRUCTURE.md` | v0.1 |
| `docs/DECISIONS.md`, `docs/MEMORY.md`, `docs/TASKS.md` | Iniciados |
| `docs/referencia/ESPECIFICACAO_PRODUTO.md` | Cópia da especificação online |
| `docs/referencia/CONCURSOS_PREVISTOS_2027.csv` | 55 concursos (separador `;`, UTF-8) |
| `docs/referencia/telas/*.dc.html` + `LEIA-ME.md` | Fontes das 4 telas |

## 3. Revisão com os prompts da camada 6

> Atenção: esta revisão foi feita pelo mesmo agente que escreveu os documentos. Ela **não** cumpre "juiz ≠ gerador"; uma auditoria independente continua pendente (item 5).

**Review de PRD**
1. Problema real e específico? Sim: falta de direção e de replanejamento, não de acervo.
2. Usuários com nome e dor? Sim, 3 personas, mas **hipotéticas** — validar com entrevistas.
3. Escopo negativo explícito? Sim (seção 7, 9 itens).
4. Critérios de sucesso mensuráveis? Sim (6 métricas com meta).
5. O que falta para codar: aprovação do PRD e da stack; quem desenvolve; provedor do modelo; mapa de tópicos do Anexo IV no seed.

**APP_FLOW → checklist de telas:** 12 telas, 6 estados cada. GAP: T8 sem questões publicadas para o tópico.

**Plano de fases:** riscos — (a) 14/12 exige Fases 2 e 3 em paralelo, ou seja, pelo menos 2 pessoas desenvolvendo; (b) 300 questões revisadas em ~2 semanas exigem um revisor dedicado; (c) distribuição do app no iPhone depende de conta Apple Developer.

**Gaps em relação ao manifesto:**
- As ferramentas da camada 8 (hooks, `proof.mjs`, `panel.mjs`, skills Hermes) não existem neste projeto. Proposta: equivalentes no CI (GitHub Actions) na Fase 1 — lint, testes, varredura de segredos e bloqueio de PR sem review.
- Conceito #11 (monitoramento contínuo) e #14 (dashboard vivo) só entram na Fase 7; para o piloto, um painel simples de saúde basta.
- Nenhum documento foi conferido contra a apostila, como pedido.

## 4. Blockers conhecidos

- Aprovação do PRD e da stack (gate da Fase 0).
- Definição de quem vai desenvolver (afeta todo o cronograma).

## 5. Próximo passo esperado

1. Dono revisa `docs/PRD.md` e `docs/DECISIONS.md` e aprova ou pede mudanças.
2. Auditoria isolada dos documentos por um agente que não os escreveu (juiz ≠ gerador).
3. Montar o mapa de tópicos do Anexo IV (seed) e resolver os 2 GAPs.
4. Só então: Fase 1 (fundação + edital).

## 6. Perguntas abertas

- Quem desenvolve (equipe própria, freelancer, sócio técnico)? Quantas pessoas?
- Já existe conta Apple Developer e Google Play?
- Qual provedor de modelo via API prefere testar primeiro?
- Quem revisa as questões (o próprio dono, professores contratados)?
- O piloto será gratuito para todos os alunos?
