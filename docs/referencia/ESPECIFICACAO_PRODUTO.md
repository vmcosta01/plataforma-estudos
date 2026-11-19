# Especificação do produto — Plataforma de estudos com IA

> Cópia local de 18/11/2026 do documento online: https://claude.ai/artifact/MzMJUvh5BgrAyDGoJpz2XF
> Os dois diagramas do original (arquitetura e cronograma) estão descritos em texto aqui. A partir da Fase 0, os documentos em `docs/` (PRD, ARCHITECTURE etc.) são a fonte oficial; este arquivo fica como referência histórica.

## Visão geral

A plataforma é um tutor de estudos com IA: o aluno informa o concurso ou a matéria, e o app monta o plano, conduz cada sessão, aplica questões e simulados e cobra a rotina. O piloto será o concurso Banestes, Técnico Bancário, com prova em 24/01/2027.

**O problema.** As plataformas atuais vendem bancos de questões e videoaulas, mas deixam o aluno sozinho para decidir o que estudar, quando e em que ordem. Quem atrasa não tem quem reorganize o plano.

**A proposta.** Em vez de um painel cheio de menus, o app mostra sempre o próximo passo. A IA explica o conteúdo, testa no meio da explicação, registra os erros e refaz o plano sozinha.

**O que diferencia:**

- Plano vivo, que se ajusta a faltas e ao desempenho, com compensação de horas.
- Sessão guiada em formato de conversa, no lugar de vídeo e PDF soltos.
- Agente que acompanha editais, retificações e provas anteriores do concurso escolhido.
- Nota estimada pela regra do próprio edital, a cada simulado.
- Mesma conta no celular, no site e no desktop.

## Público inicial e piloto Banestes

O piloto é o Técnico Bancário do Banestes. Depois dele, a plataforma cresce por núcleos de disciplinas em comum. Levantamento completo: `CONCURSOS_PREVISTOS_2027.csv`.

**Núcleos depois do piloto:**

1. Português, Constitucional e Administrativo: federais (Receita, Bacen, AGU, INSS, CNU), tribunais e carreiras jurídicas.
2. Núcleo bancário Cesgranrio: Banco do Brasil, Caixa e BNB.
3. Núcleo policial: PM e PC estaduais, PRF.

**Edital do piloto (Banestes 01/2026):**

| Item | Dado |
| --- | --- |
| Banca | Fundação Carlos Chagas (FCC) |
| Cargo | Técnico Bancário, nível médio |
| Vagas | 916 de cadastro de reserva em 34 polos, 400 em Vitória |
| Salário inicial | R$ 4.552,43, jornada de 30 h semanais |
| Inscrições | Encerradas em 17/11/2026 |
| Prova objetiva | 24/01/2027, manhã, em Vitória, São Mateus e Cachoeiro |
| Formato | 70 questões de 5 alternativas, 4 horas, sem redação |
| Nota final | (Gerais × 1 + Específicos × 2) ÷ 3, mínimo 6,00 |
| Gabarito | 25/01/2027 |
| Resultado preliminar | 01/03/2027 |

**Disciplinas e peso:**

| Bloco | Disciplina | Questões |
| --- | --- | --- |
| Específicos (peso 2) | Conhecimentos Bancários | 15 |
| Específicos (peso 2) | Vendas, Negociação e Atendimento | 10 |
| Específicos (peso 2) | Matemática Financeira | 5 |
| Específicos (peso 2) | Noções de Probabilidade e Estatística | 5 |
| Específicos (peso 2) | Noções de Informática e Comportamentos Digitais | 5 |
| Gerais (peso 1) | Língua Portuguesa | 10 |
| Gerais (peso 1) | Matemática/Raciocínio Lógico e Quantitativo | 10 |
| Gerais (peso 1) | Atualidades do Mercado Financeiro | 5 |
| Gerais (peso 1) | Ética, Compliance e ESG | 5 |

**Metas do piloto:** alunos usando o app por pelo menos 5 semanas antes da prova; comparar a nota estimada com a nota real após o gabarito; medir quantos seguem o plano até o fim.

## Funcionalidades

1. **Objetivo e diagnóstico.** Concurso, data da prova, horas por dia; simulado curto inicial.
2. **Plano de estudos vivo.** Blocos diários (teoria, questões, revisão), prioridade por peso e desempenho, refeito sozinho.
3. **Sessão guiada.** Conversa com a IA que explica, pergunta no meio e só avança quando o aluno entende. Texto e voz.
4. **Questões e simulados.** Reais quando houver, geradas no estilo da banca com revisão, correção comentada, simulado completo com nota pela regra do edital.
5. **Revisão espaçada.** Erros voltam nos dias certos.

**Depois do piloto:** radar de editais, discursivas e peças, modo 15 minutos, áudio, offline, flashcards, ranking, relatório semanal.

## Notificações e compensação de horas

| Aviso | Quando dispara | Exemplo |
| --- | --- | --- |
| Hora de estudar | No horário escolhido pelo aluno | "19h: 40 min de Conhecimentos Bancários" |
| Sessão perdida | 1 hora depois do horário, sem sessão aberta | "Ainda dá tempo: 20 min hoje já ajudam" |
| Compensação | Manhã seguinte a uma sessão perdida | "Ontem ficaram 40 min; distribuí nos próximos 3 dias" |
| Revisão | Cartões vencidos no dia | "12 cartões para revisar, cerca de 10 min" |
| Simulado | Véspera e manhã do simulado | "Simulado de 70 questões amanhã, 8h" |
| Contagem regressiva | 60, 30, 15, 7 e 1 dia | "Faltam 30 dias para a prova do Banestes" |
| Resumo semanal | Domingo à noite | Horas, temas fortes e fracos, plano da semana |

Regras da compensação: redistribuição com limite diário; maior peso primeiro; se não couber até a prova, propor cortes com confirmação; sessões fora do horário abatem a dívida. Controle do aluno: silêncio, frequência, tipos, "pausar por hoje"; permissão pedida no início.

## Progresso

| Métrica | Como é calculada | Onde aparece |
| --- | --- | --- |
| Edital coberto | Tópicos estudados ÷ tópicos do edital | Mapa do edital |
| Domínio por tópico | Acertos recentes: fraco, médio, forte | Mapa do edital |
| Horas | Planejadas contra feitas | Hoje |
| Dívida de horas | Horas perdidas não compensadas | Hoje |
| Nota estimada | Último simulado pela regra do edital | Simulados |
| Previsão de término | Ritmo das últimas 2 semanas | Hoje |
| Sequência | Dias seguidos com sessão | Hoje |

## Interface e plataformas

Telas: Hoje, Sessão guiada, Mapa do edital, Simulados, Perfil. Protótipo: https://claude.ai/artifact/LRzVsubmL8kPLPXTaa5Dwh (fontes em `telas/`). Celular com barra inferior; site/desktop com coluna lateral. Piloto: celular e site.

## Arquitetura técnica (diagrama descrito)

Três clientes (app de celular, site, app de desktop) falam com o **servidor da plataforma**, que contém: sincronização, **motor do plano** (centro do sistema), agendador de avisos e banco de dados. Abaixo do servidor: **agente local em CPU** (modelo de 3 a 4B via llama.cpp; busca editais e provas, lê PDFs), **modelo maior via API** (explicações e questões, com revisão) e **serviços de push** (Firebase, APNs, web push).

## Conteúdo, direitos autorais e LGPD

Conteúdo próprio gerado e revisado; apostilas e cursos só como referência interna; provas anteriores sujeitas a avaliação de direitos; revisão registrada das questões; consentimento, política de privacidade e exclusão de dados; nota estimada sem garantia de aprovação.

## Cronograma do piloto (diagrama descrito)

| Etapa | Período proposto |
| --- | --- |
| Mapa do edital e plano | 19/11 a 25/11/2026 |
| Desenvolvimento do MVP | 23/11 a 13/12/2026 |
| Banco de questões FCC | 26/11 a 13/12/2026 |
| Recrutar alunos | 01/12 a 13/12/2026 |
| Piloto no ar | 14/12/2026 |
| Uso e simulados | 14/12/2026 a 23/01/2027 |
| Prova Banestes | 24/01/2027 |
| Gabarito e comparação | 25/01/2027 |

## Questões em aberto

- [ ] Nome da plataforma e marca.
- [ ] Quem desenvolve.
- [ ] Modelo de cobrança.
- [ ] Recrutamento dos alunos do piloto.
- [ ] Modelo maior via API e custo por aluno.
- [ ] Quem revisa as questões geradas.
- [ ] O que a apostila acrescenta ao mapa de tópicos.
