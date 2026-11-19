#!/usr/bin/env bash
# Testa migrações + seed + RLS num Postgres local descartável (sem Supabase CLI).
# Requer: initdb, pg_ctl e psql (Postgres 15+) no PATH.
# Com o Supabase CLI instalado, prefira: supabase db reset && psql ... -f supabase/tests/rls_test.sql
set -euo pipefail

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
DADOS="$(mktemp -d)"
PORTA="${PORTA:-54329}"

cleanup() { pg_ctl -D "$DADOS" -m fast stop >/dev/null 2>&1 || true; rm -rf "$DADOS"; }
trap cleanup EXIT

initdb -D "$DADOS" -U postgres -A trust >/dev/null
pg_ctl -D "$DADOS" -o "-p $PORTA -k /tmp" -l "$DADOS/log" start >/dev/null
sleep 2

PSQL=(psql -h /tmp -p "$PORTA" -U postgres -d postgres -v ON_ERROR_STOP=1 -q)

"${PSQL[@]}" -f "$RAIZ/supabase/tests/stub_auth_supabase.sql"
for m in "$RAIZ"/supabase/migrations/*.sql; do
  echo "Aplicando $(basename "$m")"
  "${PSQL[@]}" -f "$m"
done
echo "Aplicando seed.sql"
"${PSQL[@]}" -f "$RAIZ/supabase/seed.sql"
echo "Rodando seed de novo (deve ser idempotente)"
"${PSQL[@]}" -f "$RAIZ/supabase/seed.sql"
"${PSQL[@]}" -t -c "select 'disciplinas=' || count(*) from public.disciplina; select 'topicos=' || count(*) from public.topico;"
echo "Rodando rls_test.sql"
"${PSQL[@]}" -t -f "$RAIZ/supabase/tests/rls_test.sql"
