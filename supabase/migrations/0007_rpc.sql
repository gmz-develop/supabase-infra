create or replace function app.v1_me()
returns app.customers
language sql
security definer
stable
set search_path = public, app, auth as $$
  select c.* from app.customers c where c.id = auth.uid();
$$;

revoke all on function app.v1_me() from public;
grant execute on function app.v1_me() to authenticated;
