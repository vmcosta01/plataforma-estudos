# DESIGN_SYSTEM — Contrato visual

> Versão 0.1 · 18/11/2026 · Conceito #3. Extraído das telas do protótipo (`docs/referencia/telas/`). O agente segue estes tokens; nunca inventa estilo.

## 1. Tokens

### Cores

| Token | Valor | Uso |
| --- | --- | --- |
| `color.primary` | #2F5BEA | Botão principal, cartão "Próximo passo", links, destaque |
| `color.primary-hover` | #1E40AF | Hover/pressionado do primário |
| `color.primary-soft` | #EEF2FF | Fundo de item ativo no menu |
| `color.bg` | #F6F7F9 | Fundo das telas |
| `color.surface` | #FFFFFF | Cartões, barras |
| `color.border` | #E3E6EC | Bordas de cartões e divisórias |
| `color.border-strong` | #D5DAE3 | Campos de texto |
| `color.track` | #EEF1F6 | Trilho de barras de progresso |
| `color.text` | #14171F | Texto principal |
| `color.text-muted` | #5B6170 | Texto secundário (contraste ≥ 4,5:1 sobre branco) |
| `color.success` | #15803D / fundo #F0FDF4 / borda #BBF7D0 | Acerto, domínio forte |
| `color.warning` | #A16207 / fundo #FEF3C7 | Domínio médio |
| `color.danger` | #C2410C / fundo #FFF7ED / borda #FED7AA | Erro, domínio fraco, alertas do radar |

Regra: fraco/médio/forte nunca é indicado só por cor; sempre há o rótulo em texto.

### Tipografia

| Token | Valor | Uso |
| --- | --- | --- |
| `font.display` | Space Grotesk 600–700 | Títulos, números grandes |
| `font.body` | Inter 400–600 | Texto corrido, botões |
| `size.xs` | 11 px | Rótulos de gráfico, legendas |
| `size.sm` | 12–13 px | Texto secundário |
| `size.md` | 14–15 px | Corpo, botões |
| `size.lg` | 20–22 px | Título de cartão |
| `size.xl` | 26–32 px | Título de tela |
| `size.2xl` | 48 px | Nota do simulado |

### Espaçamento, raio, sombra, breakpoints

| Token | Valor | Uso |
| --- | --- | --- |
| `space` | 4 · 8 · 12 · 16 · 20 · 24 · 32 px | Escala modular |
| `radius.sm` | 8 px | Barras internas |
| `radius.md` | 12 px | Botões, campos |
| `radius.lg` | 16 px | Cartões |
| `radius.xl` | 20 px | Cartão principal |
| `radius.pill` | 999 px | Chips, barras de progresso |
| `shadow` | nenhuma (estilo plano com bordas) | — |
| `bp.mobile` | < 640 px | Barra inferior de navegação |
| `bp.tablet` | 640–1023 px | Uma coluna larga |
| `bp.desktop` | ≥ 1024 px | Menu lateral + grade de cartões |

## 2. Componentes base

| Componente | Variantes | Observação |
| --- | --- | --- |
| Botão | primário, secundário (branco com borda), texto | Altura mínima 44 px |
| Cartão | padrão, destaque (fundo primário), alerta | Raio `lg` |
| Chip | neutro, sucesso, aviso, perigo | Sempre com texto |
| Barra de progresso | linear, por dia (semana) | Mostra valor em texto ao lado |
| Bolha de chat | IA (branca, à esquerda), aluno (primária, à direita), feedback (sucesso/perigo) | — |
| Alternativa de questão | normal, selecionada, correta, incorreta, desabilitada | Letra em círculo |
| Navegação | barra inferior (4 itens), menu lateral | Ícone + rótulo sempre |
| Campo de texto | padrão, foco, erro | `label` visível ou acessível |

## 3. Estados obrigatórios por componente/tela

| Estado | Padrão visual |
| --- | --- |
| **Loading** | Skeleton nas formas do conteúdo (cartões cinza `color.track`); na sessão, "digitando…" na bolha da IA |
| **Empty** | Ilustração simples + frase + ação ("Você ainda não fez nenhum simulado. Fazer o primeiro") |
| **Error** | Mensagem clara do que falhou + botão "Tentar de novo"; nunca tela branca |
| **Success** | Feedback curto em verde ("Sessão concluída: +40 min") |
| **Validation** | Erro inline abaixo do campo, em `color.danger`, com o motivo |
| **Disabled** | Opacidade 50% + motivo visível (ex.: "Disponível após o diagnóstico") |

## 4. Acessibilidade (não é feature futura)

- Todo elemento interativo é `<button>`/`<a>`/`<input>` real com rótulo; ícones sozinhos têm `aria-label`.
- Contraste mínimo AA (4,5:1 texto, 3:1 texto ≥ 24 px).
- Alvos de toque ≥ 44 × 44 px.
- Tamanho de fonte respeita a configuração do sistema.
- Tooltips em ações não óbvias.
