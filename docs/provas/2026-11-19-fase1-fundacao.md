# Prova — Fase 1 (fundação), 19/11/2026

> Anti-slop #1: prova = artefato verificável. Comandos rodados num ambiente Linux limpo (Node 22.23, pnpm 9.15.9, Postgres 16).
> Autor = gerador destes arquivos. **Auditoria independente (juiz ≠ gerador) ainda pendente.**

## 1. Testes do núcleo (`pnpm test`)

```
✓ test/edital.test.ts (7 tests)
✓ test/nota.test.ts (16 tests)
Test Files  2 passed (2)
     Tests  23 passed (23)
```

## 2. Mordida (reverter e exigir vermelho)

| Mutação | Resultado esperado | Resultado obtido |
| --- | --- | --- |
| Peso de Específicos 2 → 1 no edital | Testes falham | 8 falharam (1 em edital, 7 em nota) |
| Restaurado (sha256 igual ao original `592293e8…dc82`) | Verde | 23 passaram |
| Habilitação `>=` → `>` (borda 6,00) | Testes falham | 2 falharam |
| Restaurado | Verde | 23 passaram |
| RLS: aluno lendo qualquer questão (`using (true)`) | `rls_test.sql` falha | `FALHA 2: aluno vê questão não publicada` |
| Restaurado | Verde | `RLS: todos os testes passaram` |

## 3. Conferência do edital (`pnpm edital:conferir`)

```
Disciplinas: 9
Gerais: 30 (peso 1) · Específicos: 40 (peso 2) · Total: 70
Fórmula: (Gerais × 1 + Específicos × 2) ÷ 3 · mínimo 6.00
Teste de borda (18/30 e 24/40): final 6.00, habilitado = true
Estrutura consistente.
AVISO: 76 tópicos ainda a conferir contra o Anexo IV oficial
```

## 4. Banco (`scripts/testar-banco-local.sh`)

```
Aplicando 20261119000001_esquema_inicial.sql
Aplicando 20261119000002_rls.sql
Aplicando seed.sql
Rodando seed de novo (deve ser idempotente)
disciplinas=9
topicos=76
RLS: todos os testes passaram
```

## 5. Typecheck

`tsc --noEmit` sem erros em `packages/core` e `scripts`.

## Não comprovado ainda

- CI no GitHub (o repositório ainda não existe).
- Migrações no Supabase real (projeto ainda não criado; tarefa 1.2).
- Tópicos do edital conferidos contra o PDF oficial (`docs/specs/CONFERENCIA-EDITAL.md`).

---

## Atualização — 19/11/2026, 23h (Supabase, edital oficial, arredondamento)

### 6. Edital conferido contra o PDF oficial
- Estrutura (item 8.1), nota (itens 10.1–10.3) e arredondamento (item 14.2) conferidos.
- Tópicos: 76 → 106, a partir do texto do Anexo IV (`docs/specs/CONFERENCIA-EDITAL.md`).

### 7. Núcleo após o arredondamento do item 14.2
```
✓ test/edital.test.ts (7 tests)
✓ test/arredondar.test.ts (8 tests)
✓ test/nota.test.ts (17 tests)
Tests  32 passed (32)
```
Mordidas: habilitação `>=` → `>` derruba 2 testes; regra "3ª casa ≥ 5" → "> 5" derruba 2 testes; restaurados, 32 verdes.

### 8. Supabase em nuvem (projeto `plataforma-estudos`, São Paulo)
- Migrações 1 (esquema) e 2 (RLS) aplicadas.
- Seed aplicado: 9 disciplinas, 106 tópicos, 70 questões; hash dos tópicos `27fbf3a515b488e44fee49af135f7ec7` igual ao do banco local (mesmos IDs).
- `rls_test.sql` rodado no Supabase real (em transação desfeita): **RLS: todos os testes passaram**; depois disso, 0 usuários, 0 questões, 0 matrículas (nada ficou para trás).
- Migração 3 (endurecimento pedido pelo Security Advisor) testada localmente com mordida; **aguardando confirmação do dono para aplicar no Supabase**.
