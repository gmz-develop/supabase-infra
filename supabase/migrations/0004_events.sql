create table if not exists app.domain_events(
  id bigserial primary key,
  kind text not null,
  payload jsonb not null,
  created_at timestamptz default now(),
  processed_at timestamptz
);
create index if not exists domain_events_processed_idx on app.domain_events (processed_at);
