create table if not exists app.audit_logs (
  id bigserial primary key,
  at timestamptz not null default now(),
  actor uuid,
  action text not null,
  entity text not null,
  entity_id text not null,
  payload jsonb not null default '{}'
);
