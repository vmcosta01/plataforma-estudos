# EVALUATION — Métricas e benchmarks dos agentes

> Versão 0.1 · 18/11/2026 · Conceito #22. Nenhum agente vai para produção sem benchmark registrado aqui. Datasets versionados em `src/evaluation/datasets/`.

## 1. Agentes do produto

| Agente | Função | Fase | Modelo |
| --- | --- | --- | --- |
| **Tutor** | Conduz a sessão guiada (explica, checa entendimento, responde dúvidas) | Piloto | Modelo maior via API (a escolher) |
| **Gerador de questões** | Cria questões estilo FCC por tópico, com gabarito e comentário | Piloto | Modelo maior via API |
| **Revisor automático** | Segunda checagem de gabarito antes da revisão humana (juiz ≠ gerador: modelo ou prompt diferente do gerador) | Piloto | Modelo diferente do gerador |
| **Agente de editais** | Busca editais, retificações e provas; extrai tópicos de PDFs | Pós-piloto | Modelo de 3–4B em CPU |

## 2. Métricas e limiares de promoção

| Agente | Métrica | Limiar para produção |
| --- | --- | --- |
| Tutor | Correção factual (avaliada por revisor humano em 50 respostas) | ≥ 95% |
| Tutor | Segue o tópico e o nível (rubrica 1–5) | média ≥ 4,0 |
| Tutor | Latência da 1ª resposta | p95 < 3 s |
| Tutor | Custo por sessão de 40 min | a definir após medição (meta: compatível com assinatura futura) |
| Gerador | Gabarito correto (conferido por humano) | ≥ 97% antes da revisão |
| Gerador | Aderência ao estilo FCC (rubrica) | média ≥ 4,0 |
| Gerador | Questões duplicadas ou quase iguais | ≤ 3% |
| Revisor automático | Detecta gabaritos errados plantados | ≥ 90% de recall |
| Agente de editais | Extração de tópicos vs. Anexo IV conferido | ≥ 95% dos tópicos, 0 inventados |
| Agente de editais | Chamada de ferramenta válida | ≥ 95% |

## 3. Datasets (a criar na Fase 3)

| Dataset | Conteúdo | Tamanho inicial |
| --- | --- | --- |
| `tutor-v1` | Perguntas reais de aluno por tópico do Banestes + respostas de referência | 50 |
| `questoes-v1` | Tópicos do Anexo IV + questões de referência escritas por humano | 90 (10 por disciplina) |
| `gabaritos-errados-v1` | Questões com erro plantado para testar o revisor | 30 |
| `editais-v1` | PDFs de editais com tópicos conferidos | 5 |

## 4. Candidatos a modelo

- **Modelo maior via API:** comparar 2–3 provedores no `tutor-v1` e no `questoes-v1` (qualidade em português, custo, latência, termos de uso de dados). Escolha registrada em `DECISIONS.md`.
- **Agente local (pós-piloto):** Gemma 4 E4B, Qwen 3.5 4B, LFM2.5 2.6B via llama.cpp em CPU; medir chamada de ferramentas e extração no `editais-v1`.

## 5. Processo de benchmark

Rodar o dataset → registrar taxa de sucesso, latência p95, custo médio, falhas por categoria → comparar com a versão anterior → se regressão > 5%, bloquear promoção. Resultados em `src/evaluation/resultados/AAAA-MM-DD-agente.md`.
