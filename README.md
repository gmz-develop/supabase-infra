# supabase-infra

Infraestructura de Supabase versionada con Supabase CLI.

**Requisitos (WSL Ubuntu 22.04)**
- **CLI vía `npx`**: evita `npm i -g supabase`.
- **Docker (opcional para local)**: Docker Desktop en Windows con "WSL integration" activada para Ubuntu.

**Pasos Iniciales**
- **Login**: `npx supabase@latest login` (pega tu Access Token).
- **Init**: `npx supabase@latest init` (crea `supabase/config.toml`).
- **Listar proyectos**: `npx supabase@latest projects list`.
- **Vincular**: `npx supabase@latest link --project-ref <REFERENCE_ID>`.
- **Snapshot remoto**: `npx supabase@latest db pull` (crea/actualiza `supabase/migrations/*` o `schema.sql`).

**Flujo recomendado**
- Cambios en SQL (esquema `public`).
- Generar migración: `npx supabase@latest db diff -f <nombre_migracion>`.
- Aplicar a remoto: `npx supabase@latest db push`.
- Commit habitual: `git add supabase/ && git commit -m "chore: update infra"`.

**Notas**
- Por defecto se excluyen `auth` y `storage` en diffs; es intencional.
- Para uso frecuente, puedes crear un alias: `echo 'alias supabase="npx supabase@latest"' >> ~/.bashrc && source ~/.bashrc`.
