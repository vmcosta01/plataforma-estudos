# src/evaluation — Benchmarks dos agentes

- `datasets/`: conjuntos versionados (`tutor-v1`, `questoes-v1`, `gabaritos-errados-v1`, `editais-v1`), definidos em `docs/EVALUATION.md` §3.
- `resultados/`: um arquivo por rodada, `AAAA-MM-DD-agente.md`, com taxa de sucesso, latência p95, custo e falhas.
Regra: regressão > 5% bloqueia a promoção.
