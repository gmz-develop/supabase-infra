-- Bucket avatars y políticas mínimas
insert into storage.buckets (id, name, public) values ('avatars','avatars', false)
  on conflict (id) do nothing;

-- Solo el dueño puede escribir; lectura mediante signed URL
create policy if not exists "avatars read own" on storage.objects
  for select using (
    bucket_id = 'avatars' and auth.uid() = owner
  );

create policy if not exists "avatars write own" on storage.objects
  for insert with check (
    bucket_id = 'avatars' and auth.uid() = owner
  );
