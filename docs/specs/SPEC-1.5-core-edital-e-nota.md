# SPEC 1.5 — Núcleo: edital e cálculo da nota

- **Fase:** 1 · **Conceitos:** #5, #6 · **Status:** aprovada para execução

## Contexto
A fórmula da nota e a estrutura do edital são usadas pelo plano (pesos), pelo simulado e pela conferência do seed. Ficam em `packages/core` como funções puras (`AGENTS.md`).

## Tarefa
1. Tipos do edital (`Concurso`, `Disciplina`, `Topico`, `Bloco`).
2. Dados do edital Banestes 01/2026 Técnico Bancário (`editais/banestes-2026-tecnico-bancario.ts`).
3. `validarEdital(concurso)`: confere total de questões por bloco, soma total, nomes únicos, ao menos 1 tópico por disciplina.
4. `calcularNota(concurso, acertosPorBloco)`: nota por bloco (0–10), nota final ponderada e habilitação, em frações exatas.

## Arquivos
`packages/core/src/edital/tipos.ts`, `packages/core/src/edital/validar.ts`, `packages/core/src/editais/banestes-2026-tecnico-bancario.ts`, `packages/core/src/nota/calcular.ts`, `packages/core/src/index.ts`, testes em `packages/core/test/`.

## Constraints
- Sem dependências de runtime.
- Comparação de habilitação sem ponto flutuante: usar numerador/denominador inteiros.
- Acertos fora de 0..n (ou não inteiros) lançam erro com mensagem clara.
- Arredondamento só na apresentação (2 casas); a decisão de habilitação usa o valor exato. **GAP:** regra oficial de arredondamento a confirmar no edital.

## Critérios de aceitação
1. Os 10 casos de `TESTING.md` §2.1 passam.
2. `validarEdital(banestes)` retorna sem erros; 30 questões em Gerais, 40 em Específicos, 70 no total, 9 disciplinas.
3. Entradas inválidas (−1, 31 em Gerais, 2,5) lançam erro.
4. Mordida: trocar o peso de Específicos para 1 faz pelo menos um teste falhar.

## Out of scope
Motor do plano (Fase 2), montagem do simulado (Fase 5).
