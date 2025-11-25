-- Core graph structures: nodes, edges, facts scoped to a knowledge base.

create table if not exists public.nodes (
  id uuid primary key default gen_random_uuid(),
  knowledge_base_id uuid not null references public.knowledge_bases(id) on delete cascade,
  type text not null,
  label text not null,
  data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (id, knowledge_base_id)
);
create index if not exists idx_nodes_kb on public.nodes (knowledge_base_id);

do $$
begin
  if exists (
    select 1 from pg_trigger
    where tgname = 'set_updated_at_nodes'
      and tgrelid = 'public.nodes'::regclass
  ) then
    drop trigger set_updated_at_nodes on public.nodes;
  end if;
end;
$$;
create trigger set_updated_at_nodes
before update on public.nodes
for each row
execute procedure public.set_updated_at();

create table if not exists public.edges (
  id uuid primary key default gen_random_uuid(),
  knowledge_base_id uuid not null references public.knowledge_bases(id) on delete cascade,
  type text not null,
  from_id uuid not null,
  to_id uuid not null,
  data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  constraint edges_from_same_kb foreign key (from_id, knowledge_base_id) references public.nodes(id, knowledge_base_id) on delete cascade,
  constraint edges_to_same_kb foreign key (to_id, knowledge_base_id) references public.nodes(id, knowledge_base_id) on delete cascade
);
create index if not exists idx_edges_kb on public.edges (knowledge_base_id);
create index if not exists idx_edges_from on public.edges (from_id);
create index if not exists idx_edges_to on public.edges (to_id);

create table if not exists public.facts (
  id uuid primary key default gen_random_uuid(),
  knowledge_base_id uuid not null references public.knowledge_bases(id) on delete cascade,
  subject_id uuid references public.nodes(id) on delete cascade,
  predicate text not null,
  object_id uuid references public.nodes(id) on delete cascade,
  value text,
  value_type text,
  source text,
  confidence real,
  created_at timestamptz not null default now(),
  constraint facts_require_object_or_value check (object_id is not null or value is not null),
  constraint facts_value_type_valid check (value_type is null or value_type in ('string','date','int','bool','json')),
  constraint facts_confidence_range check (confidence is null or (confidence >= 0 and confidence <= 1)),
  constraint facts_subject_same_kb foreign key (subject_id, knowledge_base_id) references public.nodes(id, knowledge_base_id) on delete cascade,
  constraint facts_object_same_kb foreign key (object_id, knowledge_base_id) references public.nodes(id, knowledge_base_id) on delete cascade
);
create index if not exists idx_facts_kb on public.facts (knowledge_base_id);
create index if not exists idx_facts_subject on public.facts (subject_id);
create index if not exists idx_facts_object on public.facts (object_id);

alter table public.nodes enable row level security;
alter table public.edges enable row level security;
alter table public.facts enable row level security;

-- Members/owners can operate within their knowledge bases.
create policy "Members access nodes"
  on public.nodes
  for select
  using (
    exists (
      select 1 from public.knowledge_bases kb
      where kb.id = nodes.knowledge_base_id
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

create policy "Members modify nodes"
  on public.nodes
  for all
  using (
    exists (
      select 1 from public.knowledge_bases kb
      where kb.id = nodes.knowledge_base_id
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
  with check (
    exists (
      select 1 from public.knowledge_bases kb
      where kb.id = nodes.knowledge_base_id
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

create policy "Members access edges"
  on public.edges
  for select
  using (
    exists (
      select 1 from public.knowledge_bases kb
      where kb.id = edges.knowledge_base_id
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

create policy "Members modify edges"
  on public.edges
  for all
  using (
    exists (
      select 1 from public.knowledge_bases kb
      where kb.id = edges.knowledge_base_id
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
  with check (
    exists (
      select 1 from public.knowledge_bases kb
      where kb.id = edges.knowledge_base_id
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

create policy "Members access facts"
  on public.facts
  for select
  using (
    exists (
      select 1 from public.knowledge_bases kb
      where kb.id = facts.knowledge_base_id
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

create policy "Members modify facts"
  on public.facts
  for all
  using (
    exists (
      select 1 from public.knowledge_bases kb
      where kb.id = facts.knowledge_base_id
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
  with check (
    exists (
      select 1 from public.knowledge_bases kb
      where kb.id = facts.knowledge_base_id
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
