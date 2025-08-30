create or replace function app.handle_auth_user_insert()
returns trigger language plpgsql security definer as $$
begin
  insert into app.customers (id, email, full_name, avatar_url)
  values (
    new.id,
    coalesce(new.email,''),
    coalesce(new.raw_user_meta_data->>'name',''),
    coalesce(new.raw_user_meta_data->>'picture','')
  )
  on conflict (id) do update set
    email = excluded.email,
    full_name = excluded.full_name,
    avatar_url = excluded.avatar_url,
    updated_at = now();

  insert into app.audit_logs(actor, action, entity, entity_id, payload)
  values (new.id, 'customer.upserted', 'app.customers', new.id::text, to_jsonb(new));
  return new;
end; $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure app.handle_auth_user_insert();
