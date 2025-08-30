alter table app.customers enable row level security;

create policy "me leo" on app.customers
for select using (auth.uid() = id);

create policy "me actualizo" on app.customers
for update using (auth.uid() = id)
with check (auth.uid() = id);
