/**
 * Tipos compartilhados entre app, site e Edge Functions.
 * Espelham os enums da migração `supabase/migrations/20261119000001_esquema_inicial.sql`.
 */
export type Papel = 'aluno' | 'revisor' | 'admin';
export type TipoBlocoPlano = 'teoria' | 'questoes' | 'revisao' | 'simulado';
export type StatusBlocoPlano = 'previsto' | 'feito' | 'perdido' | 'compensado' | 'cortado';
export type StatusQuestao = 'rascunho' | 'revisada' | 'publicada' | 'suspensa';
export type OrigemQuestao = 'gerada' | 'real';
export type Plataforma = 'android' | 'ios' | 'web' | 'desktop';
export type TipoNotificacao =
  | 'hora_de_estudar'
  | 'sessao_perdida'
  | 'compensacao'
  | 'revisao'
  | 'simulado'
  | 'contagem_regressiva'
  | 'resumo_semanal';
