-- Core setup: extensions, helpers, knowledge bases, memberships, user profiles.

do $$
begin
  if not exists (select 1 from pg_extension where extname = 'pgcrypto') then
    create extension "pgcrypto";
  end if;
end;
$$;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Knowledge bases are the root container for all graph data.
create table if not exists public.knowledge_bases (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text,
  description text,
  owner_id uuid default auth.uid() references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (owner_id, slug)
);

do $$
begin
  if exists (
    select 1 from pg_trigger
    where tgname = 'set_updated_at_knowledge_bases'
      and tgrelid = 'public.knowledge_bases'::regclass
  ) then
    drop trigger set_updated_at_knowledge_bases on public.knowledge_bases;
  end if;
end;
$$;
create trigger set_updated_at_knowledge_bases
before update on public.knowledge_bases
for each row
execute procedure public.set_updated_at();

-- Membership mapping between users and knowledge bases.
do $$
begin
  if not exists (select 1 from pg_type where typname = 'knowledge_base_role') then
    create type public.knowledge_base_role as enum ('owner', 'editor', 'viewer');
  end if;
end;
$$;

create table if not exists public.knowledge_base_users (
  knowledge_base_id uuid not null references public.knowledge_bases(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role public.knowledge_base_role not null default 'viewer',
  created_at timestamptz not null default now(),
  primary key (knowledge_base_id, user_id)
);
create index if not exists idx_kb_users_user on public.knowledge_base_users (user_id);

-- User profiles tied to auth.users with customizable settings.
create table if not exists public.user_profiles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  settings jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

do $$
begin
  if exists (
    select 1 from pg_trigger
    where tgname = 'set_updated_at_user_profiles'
      and tgrelid = 'public.user_profiles'::regclass
  ) then
    drop trigger set_updated_at_user_profiles on public.user_profiles;
  end if;
end;
$$;
create trigger set_updated_at_user_profiles
before update on public.user_profiles
for each row
execute procedure public.set_updated_at();

-- RLS: only members/owners can see KBs; only owners manage memberships; users manage their profile.
alter table public.knowledge_bases enable row level security;
alter table public.knowledge_base_users enable row level security;
alter table public.user_profiles enable row level security;

create policy "Select knowledge bases as member"
  on public.knowledge_bases
  for select
  using (
    owner_id = auth.uid()
    or exists (
      select 1 from public.knowledge_base_users kbu
      where kbu.knowledge_base_id = knowledge_bases.id
        and kbu.user_id = auth.uid()
    )
  );

create policy "Insert knowledge bases as owner"
  on public.knowledge_bases
  for insert
  with check (owner_id = auth.uid());

create policy "Manage own knowledge bases"
  on public.knowledge_bases
  for update
  using (owner_id = auth.uid())
  with check (owner_id = auth.uid());

create policy "Delete own knowledge bases"
  on public.knowledge_bases
  for delete
  using (owner_id = auth.uid());

create policy "Select memberships for participant or owner"
  on public.knowledge_base_users
  for select
  using (
    user_id = auth.uid()
    or exists (
      select 1 from public.knowledge_bases kb
      where kb.id = knowledge_base_users.knowledge_base_id
        and kb.owner_id = auth.uid()
    )
  );

create policy "Owners manage memberships"
  on public.knowledge_base_users
  for all
  using (
    exists (
      select 1 from public.knowledge_bases kb
      where kb.id = knowledge_base_users.knowledge_base_id
        and kb.owner_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.knowledge_bases kb
      where kb.id = knowledge_base_users.knowledge_base_id
        and kb.owner_id = auth.uid()
    )
  );

create policy "Select own profile"
  on public.user_profiles
  for select
  using (auth.uid() = user_id);

create policy "Upsert own profile"
  on public.user_profiles
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
