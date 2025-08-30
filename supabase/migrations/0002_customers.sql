create table if not exists app.customers (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  full_name text default '',
  avatar_url text default '',
  phone text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(email)
);
create index if not exists customers_email_idx on app.customers (email);
