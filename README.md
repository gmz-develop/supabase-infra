# Infra Supabase
Infraestructura sin front. Requiere Supabase CLI y Docker.

## Requisitos
- Docker Desktop
- Supabase CLI
- Node 18+ para Edge Functions

## Uso rápido
```bash
supabase start
supabase db reset --no-backup
psql $DB_URL -f scripts/create_buckets.sql
psql $DB_URL -f scripts/test_rls.sql
```

Despliegue Edge Function
```bash
supabase functions deploy customer_sync --project-ref <REF>
```
