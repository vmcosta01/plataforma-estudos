# TESTING — Checklist de testes

> Versão 0.1 · 18/11/2026 · Conceito #6. Testes escritos antes ou junto do código. Caminho feliz não basta: bordas, regressão e "mordida" (reverter o conserto e ver o teste falhar).

## 1. Checklist por tipo

| Tipo | Checklist | Status |
| --- | --- | --- |
| Happy Path | Cadastro → objetivo → diagnóstico → plano → Hoje → sessão → questões → simulado | ☐ |
| Validação | Inputs inválidos em T1, T2, T12 tratados no app e no servidor | ☐ |
| Erro | Sem conexão, IA indisponível, push falhou, plano não gerado: mensagens e recuperação | ☐ |
| Permissões | Aluno A não lê dados de B; aluno não vê questão em rascunho; só revisor publica | ☐ |
| Responsividade | Celular (360–430 px), tablet, desktop (≥ 1024 px) | ☐ |
| Acessibilidade | Navegação por teclado no site; leitor de tela (TalkBack/VoiceOver); contraste AA | ☐ |
| Regressão | Suíte completa no CI a cada PR; features antigas intactas | ☐ |
| Performance | Hoje < 2 s (p95, 4G); 1ª resposta da IA < 3 s (p95); push < 2 min | ☐ |

## 2. Casos obrigatórios do domínio

### 2.1 Nota do simulado (10 casos, contra planilha de conferência)
Gerais = acertos/30 × 10; Específicos = acertos/40 × 10; Final = (G + 2E) ÷ 3; habilitado se Final ≥ 6,00. Cada prova e a média com duas casas, arredondando para cima quando a 3ª casa for ≥ 5 (item 14.2 do edital); não há nota mínima por prova, só na média (item 10.3). Cálculo em inteiros, sem erro de ponto flutuante.

| Caso | Acertos G | Acertos E | Final esperada | Habilitado |
| --- | --- | --- | --- | --- |
| 1 | 30 | 40 | 10,00 | sim |
| 2 | 0 | 0 | 0,00 | não |
| 3 | 18 | 24 | 6,00 | sim (borda) |
| 4 | 17 | 24 | 5,89 | não |
| 5 | 30 | 18 | 6,33 | sim |
| 6 | 15 | 30 | 6,67 | sim |
| 7 | 21 | 20 | 5,67 | não |
| 8 | 24 | 26 | 7,00 | sim |
| 9 | 9 | 36 | 7,00 | sim |
| 10 | 27 | 21 | 6,50 | sim |

### 2.2 Compensação de horas (5 cenários)
1. Perde 40 min, limite extra 20 min/dia → 20 + 20 nos dois dias seguintes.
2. Perde sessão e estuda no mesmo dia fora do horário → dívida zera, sem aviso de compensação.
3. "Pausar por hoje" → sem aviso de sessão perdida; tempo vai para compensação.
4. Dívida maior do que cabe até a prova → app propõe cortar tópicos de menor peso e pede confirmação.
5. Véspera da prova → não agenda compensação depois de 24/01/2027.

### 2.3 Plano
- Soma de minutos = horas declaradas até a prova (±5%).
- Todos os tópicos do Anexo IV aparecem, ou estão listados como cortados.
- Específicos recebem mais tempo que Gerais na proporção dos pesos, ajustado pelo diagnóstico.

### 2.4 Questões
- Questão sem revisor nunca é retornada pela API do aluno.
- Questão `suspensa` some do app e dos simulados em andamento.

## 3. Ferramentas (a confirmar na Fase 1)

Vitest (`packages/core` e funções), Playwright (site), Maestro ou Detox (app), testes de RLS com usuários de teste.
