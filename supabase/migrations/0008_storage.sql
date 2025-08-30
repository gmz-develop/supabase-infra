-- Bucket avatars y políticas mínimas
insert into storage.buckets (id, name, public) values ('avatars','avatars', false)
  on conflict (id) do nothing;

-- Solo el dueño puede escribir; lectura mediante signed URL
drop policy if exists "avatars read own" on storage.objects;
create policy "avatars read own" on storage.objects
  for select using (
    bucket_id = 'avatars' and auth.uid() = owner
  );

drop policy if exists "avatars write own" on storage.objects;
create policy "avatars write own" on storage.objects
  for insert with check (
    bucket_id = 'avatars' and auth.uid() = owner
  );
