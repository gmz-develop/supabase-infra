insert into storage.buckets (id, name, public) values ('avatars','avatars', false)
  on conflict (id) do nothing;
