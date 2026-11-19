# SPEC 1.3 — Modelo de dados (migrações Supabase)

- **Fase:** 1 · **Conceitos:** #2, #5 · **Status:** aprovada para execução

## Contexto
Implementa o modelo de `ARCHITECTURE.md` §4 em Postgres (Supabase).

## Tarefa
Escrever a migração inicial com as tabelas `perfil`, `concurso`, `disciplina`, `topico`, `matricula`, `bloco_plano`, `questao`, `sessao`, `resposta`, `simulado`, `notificacao`, `dispositivo`, `feature_flag`.

## Arquivos
`supabase/migrations/20261119000001_esquema_inicial.sql`

## Constraints
- Chaves `uuid` com `gen_random_uuid()`; `created_at`/`updated_at` em `timestamptz`.
- Tipos enumerados para: bloco (`gerais`, `especificos`), tipo de bloco do plano, status do bloco, status da questão, origem da questão, papel do usuário, plataforma do dispositivo, tipo de notificação.
- Índices: `bloco_plano(matricula_id, data)`, `bloco_plano(status, data)`, `questao(topico_id, status)`, `notificacao(agendada_para) where enviada_em is null`.
- `perfil.papel` padrão `aluno`; perfil criado por trigger ao criar usuário em `auth.users`.
- Fuso: datas do plano em `date` no fuso `America/Sao_Paulo`; instantes em `timestamptz`.

## Critérios de aceitação
1. `supabase db reset` aplica a migração sem erro.
2. Todas as FKs têm `on delete` explícito (cascade para dados do aluno).
3. Criar um usuário em `auth.users` cria a linha em `perfil` com papel `aluno`.

## Out of scope
Funções de negócio (plano, nota) no banco; Edge Functions.
