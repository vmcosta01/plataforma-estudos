# PRD — Plataforma de estudos com IA

> Versão 0.1 · 18/11/2026 · Fase 0 (planejamento) · Dono: Victor Costa
> Conceitos #1 e #20 do manifesto. Nenhum código antes deste PRD aprovado.

## 1. Visão do produto e problema

**Visão:** um tutor de estudos com IA que diz ao concurseiro exatamente o que estudar hoje, conduz a sessão, testa, corrige e reorganiza o plano sozinho até o dia da prova.

**Problema:** as plataformas de concurso vendem acervo (questões, videoaulas, PDFs), mas não vendem *direção*. O aluno decide sozinho o que estudar, em que ordem e por quanto tempo; quando falta um dia, ninguém refaz o plano; e ele só descobre se está pronto no dia da prova.

## 2. Usuários-alvo (personas do piloto)

> Personas hipotéticas, a validar com entrevistas com inscritos no Banestes durante o recrutamento (ver `TASKS.md`).

| Persona | Perfil | Dor principal | Comportamento atual |
| --- | --- | --- | --- |
| **Juliana, 27, Vitória** | Inscrita no Banestes (polo Vitória), trabalha 8 h/dia no comércio, estuda à noite | Não sabe por onde começar com 9 disciplinas e 9 semanas; desanima quando atrasa | Baixa PDFs grátis, assiste aulas soltas no YouTube, resolve questões sem critério |
| **Rafael, 34, Cachoeiro de Itapemirim** | Inscrito no Banestes, pai de dois filhos, ~1 h livre por dia | Pouco tempo; precisa que cada minuto conte nas disciplinas de maior peso | Estuda pelo celular em intervalos, sem acompanhar progresso |
| **Marina, 22, Serra** | Recém-formada no ensino médio técnico, primeiro concurso | Não conhece o estilo FCC nem como a nota é calculada | Faz simulados aleatórios e não entende por que erra |

Fora do piloto (fase 2 em diante): concurseiros de carreiras federais, jurídicas e bancárias nacionais.

## 3. Features core (MVP do piloto)

Fluxos detalhados em `APP_FLOW.md`.

| # | Feature | Descrição | Prioridade |
| --- | --- | --- | --- |
| F1 | Cadastro e objetivo | Conta, escolha do concurso (só Banestes no piloto), polo, horas por dia da semana, horários de estudo | P0 |
| F2 | Diagnóstico | Simulado curto (20 questões) que estima o nível por disciplina | P0 |
| F3 | Plano de estudos vivo | Cronograma diário até 24/01/2027, ponderado pelos pesos do edital e pelo diagnóstico; recalculado ao faltar ou errar | P0 |
| F4 | Sessão guiada | Conversa com IA: explicação do tópico, perguntas de checagem no meio, avanço só com entendimento | P0 |
| F5 | Questões | Questões no estilo FCC, revisadas antes de liberar, com correção comentada por alternativa | P0 |
| F6 | Simulado completo | 70 questões, 4 h, nota pela regra do edital (Gerais ×1, Específicos ×2, mínimo 6,00) | P0 |
| F7 | Notificações | Hora de estudar, sessão perdida, compensação, revisão, simulado, contagem regressiva | P0 |
| F8 | Compensação de horas | Redistribuição do tempo perdido com limite diário e proposta de corte quando não couber | P0 |
| F9 | Progresso | Edital coberto, domínio por tópico, horas, dívida de horas, nota estimada, previsão de término | P0 |
| F10 | Revisão espaçada | Erros voltam em cartões curtos nos dias certos | P1 |
| F11 | Resumo semanal | Domingo à noite, por notificação e e-mail | P1 |

## 4. Research summary

O que foi investigado antes de definir (18/11/2026):

- **Mercado:** EstudaIA, Alice (alice.tech), Qconcursos Elite, GoConcursos e Estuda.com já combinam plano e questões; nenhum dos analisados conduz a sessão como conversa nem faz compensação automática de horas explícita. (Fontes na conversa de origem; revalidar antes do lançamento.)
- **Edital Banestes 01/2026:** FCC; 916 vagas de cadastro de reserva em 34 polos; prova em 24/01/2027; 70 questões, sem discursiva; nota ponderada. Detalhe em `docs/referencia/ESPECIFICACAO_PRODUTO.md`.
- **Modelos pequenos para agente em CPU:** Gemma 4 E4B, Qwen 3.5 4B, LFM2.5 2.6B são candidatos com chamada de ferramentas (benchmarks públicos de maio/2026). Ver `EVALUATION.md`.
- **Mapa de concursos até 2027:** 55 concursos levantados em `docs/referencia/CONCURSOS_PREVISTOS_2027.csv`, para os núcleos pós-piloto.
- **A fazer:** entrevistar 5 a 10 inscritos no Banestes; ler a apostila (`apostila-completa-tecnico-bancario-banestes-2026.pdf`) só para calibrar o mapa de tópicos.

## 5. Requisitos funcionais, de UX e de performance

**Funcionais**
- RF1. O plano cobre 100% dos tópicos do Anexo IV do edital até a véspera da prova, ou informa explicitamente o que foi cortado.
- RF2. Toda questão liberada ao aluno tem gabarito revisado e registro de quem revisou.
- RF3. A nota do simulado segue exatamente a fórmula do edital.
- RF4. Uma sessão perdida gera aviso de sessão perdida (1 h depois) e de compensação (manhã seguinte), salvo se o aluno pausou o dia.
- RF5. O progresso é o mesmo no celular e no site (mesma conta, sincronizado).

**UX**
- UX1. A tela inicial mostra um único próximo passo com botão "Começar".
- UX2. Toda tela tem os 6 estados do `DESIGN_SYSTEM.md` (loading, empty, error, success, validation, disabled).
- UX3. Português do Brasil, linguagem simples, sem jargão técnico.
- UX4. Acessível: alvos de toque ≥ 44 px, contraste AA, leitores de tela.

**Performance**
- P1. Tela "Hoje" carrega em < 2 s em 4G (p95).
- P2. Primeira resposta da IA na sessão guiada começa a aparecer em < 3 s (p95).
- P3. Notificação de horário chega com atraso < 2 min (p95).

## 6. Definition of Done (piloto)

O piloto está pronto para alunos quando **todos** forem verdadeiros e comprovados por artefato (teste, log ou screenshot):

1. Edital Banestes carregado com as 9 disciplinas e todos os tópicos do Anexo IV, conferidos contra o PDF oficial.
2. Um aluno de teste completa F1→F2→F3 e recebe um plano até 24/01/2027 que soma as horas que ele declarou (±5%).
3. Pelo menos 300 questões FCC-like revisadas, cobrindo as 9 disciplinas na proporção do edital.
4. Simulado de 70 questões calcula a nota igual a uma planilha de conferência em 10 casos de teste.
5. As 6 notificações de F7 disparam em teste de ponta a ponta no Android, no iPhone e no navegador.
6. Faltar 1 sessão gera compensação correta em 5 cenários de teste documentados em `TESTING.md`.
7. Checklist de `TESTING.md` 100% verde e `SECURITY.md` sem pendência crítica.
8. Política de privacidade e termos de uso publicados.
9. App disponível para os alunos do piloto (loja ou distribuição de teste) e site no ar em produção.

## 7. Out of Scope (versão piloto)

Não será feito até o fim do piloto (24/01/2027):

- Outros concursos além do Banestes Técnico Bancário (inclusive Técnico em Segurança do Trabalho).
- Agente local de busca de editais e radar de concursos.
- App de desktop (o site cobre o uso no computador).
- Correção de discursivas, redação ou peças.
- Videoaulas, PDFs próprios ou reprodução de apostilas de terceiros.
- Ranking entre alunos, comunidade, chat entre alunos.
- Modo offline.
- Pagamento e assinatura (piloto gratuito).
- Painel para professores ou cursinhos.

## 8. Métricas de sucesso

| Métrica | Meta do piloto | Como medir |
| --- | --- | --- |
| Alunos ativos | ≥ 30 alunos com ≥ 1 sessão/semana por 5 semanas | Eventos de sessão |
| Aderência ao plano | ≥ 60% das horas planejadas cumpridas (mediana) | Horas feitas ÷ planejadas |
| Retenção semana 4 | ≥ 50% dos que começaram | Coorte semanal |
| Precisão da nota estimada | Erro médio ≤ 1,0 ponto (escala 0–10) vs. nota real | Questionário após gabarito de 25/01 |
| Qualidade das questões | ≤ 2% de questões com gabarito contestado procedente | Botão "reportar questão" |
| Satisfação | NPS ≥ 40 | Pesquisa no fim do piloto |

## 9. Riscos principais

| Risco | Impacto | Mitigação |
| --- | --- | --- |
| Prazo: 9 semanas até a prova | Alto | Escopo mínimo (seção 7); vertical slices em `IMPLEMENTATION_PLAN.md` |
| Questões geradas com gabarito errado | Alto | Revisão obrigatória (RF2) antes de liberar |
| Poucos alunos no piloto | Médio | Recrutamento a partir de 01/12 (grupos de estudo ES) |
| Custo de API por aluno | Médio | Cache de explicações e questões; medir em `EVALUATION.md` |
| Direitos autorais de material de terceiros | Médio | Conteúdo próprio; apostila só como referência interna |
