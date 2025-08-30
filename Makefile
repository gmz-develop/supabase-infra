SUPABASE?=supabase

up:
	$(SUPABASE) start

down:
	$(SUPABASE) stop

migrate:
	$(SUPABASE) db reset --no-backup

seed:
	psql $$DB_URL -f scripts/create_buckets.sql || true

test-db:
	psql $$DB_URL -f scripts/test_rls.sql
