-- Type registries for nodes and edges plus their field definitions.

create table if not exists public.node_types (
  id uuid primary key default gen_random_uuid(),
  knowledge_base_id uuid references public.knowledge_bases(id) on delete cascade,
  name text not null,
  label text not null,
  description text,
  is_builtin boolean not null default false,
  created_at timestamptz not null default now(),
  unique (knowledge_base_id, name)
);
create index if not exists idx_node_types_kb on public.node_types (knowledge_base_id);

create table if not exists public.node_type_fields (
  id uuid primary key default gen_random_uuid(),
  node_type_id uuid not null references public.node_types(id) on delete cascade,
  key text not null,
  value_type text not null,
  required boolean not null default false,
  allowed_values jsonb,
  description text,
  created_at timestamptz not null default now(),
  unique (node_type_id, key),
  constraint node_type_fields_value_type_valid check (value_type in ('string','date','int','bool','json','string_array'))
);
create index if not exists idx_node_type_fields_type on public.node_type_fields (node_type_id);

create table if not exists public.edge_types (
  id uuid primary key default gen_random_uuid(),
  knowledge_base_id uuid references public.knowledge_bases(id) on delete cascade,
  name text not null,
  label text not null,
  description text,
  from_node_type text,
  to_node_type text,
  is_symmetric boolean not null default false,
  created_at timestamptz not null default now(),
  unique (knowledge_base_id, name)
);
create index if not exists idx_edge_types_kb on public.edge_types (knowledge_base_id);

create table if not exists public.edge_type_fields (
  id uuid primary key default gen_random_uuid(),
  edge_type_id uuid not null references public.edge_types(id) on delete cascade,
  key text not null,
  value_type text not null,
  required boolean not null default false,
  allowed_values jsonb,
  description text,
  created_at timestamptz not null default now(),
  unique (edge_type_id, key),
  constraint edge_type_fields_value_type_valid check (value_type in ('string','date','int','bool','json','string_array'))
);
create index if not exists idx_edge_type_fields_type on public.edge_type_fields (edge_type_id);

alter table public.node_types enable row level security;
alter table public.node_type_fields enable row level security;
alter table public.edge_types enable row level security;
alter table public.edge_type_fields enable row level security;

-- Read allowed for members of a KB; global definitions (knowledge_base_id is null) are visible to all.
create policy "Members read node types"
  on public.node_types
  for select
  using (
    knowledge_base_id is null
    or exists (
      select 1 from public.knowledge_bases kb
      where kb.id = node_types.knowledge_base_id
        and (
          kb.owner_id = auth.uid()
          or exists (
            select 1 from public.knowledge_base_users kbu
            where kbu.knowledge_base_id = kb.id
              and kbu.user_id = auth.uid()
          )
        )
    )
  );

create policy "Owners manage node types"
  on public.node_types
  for all
  using (
    knowledge_base_id is not null
    and exists (
      select 1 from public.knowledge_bases kb
      where kb.id = node_types.knowledge_base_id
        and kb.owner_id = auth.uid()
    )
  )
  with check (
    knowledge_base_id is not null
    and exists (
      select 1 from public.knowledge_bases kb
      where kb.id = node_types.knowledge_base_id
        and kb.owner_id = auth.uid()
    )
  );

create policy "Members read node type fields"
  on public.node_type_fields
  for select
  using (
    exists (
      select 1
      from public.node_types nt
      where nt.id = node_type_fields.node_type_id
        and (
          nt.knowledge_base_id is null
          or exists (
            select 1 from public.knowledge_bases kb
            where kb.id = nt.knowledge_base_id
              and (
                kb.owner_id = auth.uid()
                or exists (
                  select 1 from public.knowledge_base_users kbu
                  where kbu.knowledge_base_id = kb.id
                    and kbu.user_id = auth.uid()
                )
              )
          )
        )
    )
  );

create policy "Owners manage node type fields"
  on public.node_type_fields
  for all
  using (
    exists (
      select 1
      from public.node_types nt
      join public.knowledge_bases kb on kb.id = nt.knowledge_base_id
      where nt.id = node_type_fields.node_type_id
        and kb.owner_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from public.node_types nt
      join public.knowledge_bases kb on kb.id = nt.knowledge_base_id
      where nt.id = node_type_fields.node_type_id
        and kb.owner_id = auth.uid()
    )
  );

create policy "Members read edge types"
  on public.edge_types
  for select
  using (
    knowledge_base_id is null
    or exists (
      select 1 from public.knowledge_bases kb
      where kb.id = edge_types.knowledge_base_id
        and (
          kb.owner_id = auth.uid()
          or exists (
            select 1 from public.knowledge_base_users kbu
            where kbu.knowledge_base_id = kb.id
              and kbu.user_id = auth.uid()
          )
        )
    )
  );

create policy "Owners manage edge types"
  on public.edge_types
  for all
  using (
    knowledge_base_id is not null
    and exists (
      select 1 from public.knowledge_bases kb
      where kb.id = edge_types.knowledge_base_id
        and kb.owner_id = auth.uid()
    )
  )
  with check (
    knowledge_base_id is not null
    and exists (
      select 1 from public.knowledge_bases kb
      where kb.id = edge_types.knowledge_base_id
        and kb.owner_id = auth.uid()
    )
  );

create policy "Members read edge type fields"
  on public.edge_type_fields
  for select
  using (
    exists (
      select 1
      from public.edge_types et
      where et.id = edge_type_fields.edge_type_id
        and (
          et.knowledge_base_id is null
          or exists (
            select 1 from public.knowledge_bases kb
            where kb.id = et.knowledge_base_id
              and (
                kb.owner_id = auth.uid()
                or exists (
                  select 1 from public.knowledge_base_users kbu
                  where kbu.knowledge_base_id = kb.id
                    and kbu.user_id = auth.uid()
                  )
              )
          )
        )
    )
  );

create policy "Owners manage edge type fields"
  on public.edge_type_fields
  for all
  using (
    exists (
      select 1
      from public.edge_types et
      join public.knowledge_bases kb on kb.id = et.knowledge_base_id
      where et.id = edge_type_fields.edge_type_id
        and kb.owner_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from public.edge_types et
      join public.knowledge_bases kb on kb.id = et.knowledge_base_id
      where et.id = edge_type_fields.edge_type_id
        and kb.owner_id = auth.uid()
    )
  );
