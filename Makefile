# Use Supabase CLI via npx (no global install needed)
SUPABASE?=npx -y supabase@latest

up:
	$(SUPABASE) start

down:
	$(SUPABASE) stop

migrate:
	$(SUPABASE) db reset --local --yes

push-remote:
	$(SUPABASE) db push
	@echo "Migraciones locales aplicadas en la base remota."

seed:
	psql $$DB_URL -f scripts/create_buckets.sql || true

test-db:
	psql $$DB_URL -f scripts/test_rls.sql

# Serve a single Edge Function locally
# Usage: make serve-fn NAME=customer_sync
serve-fn:
	@if [ -z "$(NAME)" ]; then echo "NAME is required, e.g. make serve-fn NAME=customer_sync"; exit 1; fi
	$(SUPABASE) functions serve $(NAME) --env-file .env

# Deploy a single Edge Function to a remote project
# Usage: make deploy-fn NAME=customer_sync REF=qsanepjjesywcmijocrl
deploy-fn:
	@if [ -z "$(NAME)" ]; then echo "NAME is required, e.g. make deploy-fn NAME=customer_sync REF=qsan..."; exit 1; fi
	@if [ -z "$(REF)" ]; then echo "REF is required, e.g. make deploy-fn NAME=customer_sync REF=qsan..."; exit 1; fi
	$(SUPABASE) functions deploy $(NAME) --project-ref $(REF)

# Deploy all Edge Functions found in supabase/edge/* to a remote project
# Usage: make deploy-all-fns REF=qsanepjjesywcmijocrl
deploy-all-fns:
	@if [ -z "$(REF)" ]; then echo "REF is required, e.g. make deploy-all-fns REF=qsan..."; exit 1; fi
	@for d in supabase/edge/*; do \
		[ -d "$$d" ] || continue; \
		name=$$(basename "$$d"); \
		echo "Deploying $$name"; \
		$(SUPABASE) functions deploy $$name --project-ref $(REF); \
	done

supabase-repair:
	@echo "Reparando historial de migraciones Supabase..."
	git pull
	$(SUPABASE) migration repair --status reverted 20250830143937
	$(SUPABASE) db pull
	@echo "Listo. Migraciones reparadas y sincronizadas."

