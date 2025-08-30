create or replace function public.log_audit(
  actor uuid,
  action text,
  entity text,
  entity_id text,
  payload jsonb
)
returns void
language sql
security definer
set search_path = public, app, auth as $$
  insert into app.audit_logs(actor, action, entity, entity_id, payload)
  values (actor, action, entity, entity_id, coalesce(payload, '{}'::jsonb));
$$;

-- Restrict execution to service_role only
revoke all on function public.log_audit(uuid, text, text, text, jsonb) from public;
grant execute on function public.log_audit(uuid, text, text, text, jsonb) to service_role;

