# Infra Supabase
Infraestructura sin front. Requiere Docker. No necesitas instalar la Supabase CLI globalmente: usamos `npx supabase@latest`.

## Requisitos
- Docker Desktop
- Node 18+ (Edge Functions y para usar `npx`)

## Uso rápido
```bash
# Arrancar servicios locales de Supabase
npx -y supabase@latest start

# Aplicar migraciones y seeds
npx -y supabase@latest db reset --local --yes

# Scripts adicionales (requiere psql y DB_URL en .env)
psql $DB_URL -f scripts/create_buckets.sql || true
psql $DB_URL -f scripts/test_rls.sql
```

Despliegue Edge Function
```bash
npx -y supabase@latest functions deploy customer_sync --project-ref <REF>
```

## Makefile
Atajos que usan `npx`:
```bash
make up        # npx supabase start
make down      # npx supabase stop
make migrate   # npx supabase db reset --local --yes
make seed      # psql $DB_URL -f scripts/create_buckets.sql
make test-db   # psql $DB_URL -f scripts/test_rls.sql
make serve-fn NAME=customer_sync              # sirve una función con .env
make deploy-fn NAME=customer_sync REF=<REF>   # deploy de una función
make deploy-all-fns REF=<REF>                 # deploy de todas las funciones
```

## Flujo IaC y CI/CD
- Migrations: agrega SQL en `supabase/migrations/*.sql` (puedes generar con `npx supabase@latest db diff --linked --file 00xx_desc.sql`).
- Seeds: en `supabase/seeds/seed.sql`.
- Edge Functions: en `supabase/edge/<name>/index.ts`.

Al hacer push/PR, el workflow `infra-ci` valida las migraciones en local y corre pruebas SQL.

Al mergear en `main`, el workflow `deploy-supabase`:
- Empuja migraciones al proyecto remoto (`supabase db push`).
- Setea los secrets de Edge Functions (SUPABASE_URL y SUPABASE_SERVICE_ROLE_KEY).
- Despliega todas las Edge Functions en `supabase/edge/*` automáticamente.

Configura estos GitHub Secrets en el repo:
- `SUPABASE_PROJECT_REF`: Project reference (Dashboard → Settings → General).
- `SUPABASE_DB_PASSWORD`: Database password (Dashboard → Settings → Database → Connection string).
- `SUPABASE_ACCESS_TOKEN`: Access Token (Dashboard → Account → Access Tokens) para deploy de funciones.
- `SUPABASE_SERVICE_ROLE_KEY`: Service role key (Dashboard → Settings → API).
- `SUPABASE_POOLER_HOST` (opcional): Host del Pooler (IPv4), útil si el runner no tiene IPv6. Lo ves en Settings → Database → Connection string → Pooling (ej.: `aws-0-us-east-1.pooler.supabase.com`).
- `SUPABASE_POOLER_PORT` (opcional): Puerto del Pooler, por defecto `6543`.
 - `SUPABASE_POOLER_USER` (opcional): Usuario del Pooler. Si no lo configuras, el workflow usa `postgres.<PROJECT_REF>` automáticamente (formato típico que muestra Studio en la cadena del Pooler).

Comandos útiles para generar migraciones:
```bash
# Vincular proyecto una vez en tu máquina
npx -y supabase@latest link --project-ref <REF>

# Generar migration a partir de cambios locales
npx -y supabase@latest db diff --linked --file 00xx_descripcion.sql
```
