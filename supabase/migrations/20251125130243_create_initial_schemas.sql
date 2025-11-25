create type "public"."knowledge_base_role" as enum ('owner', 'editor', 'viewer');


  create table "public"."edge_type_fields" (
    "id" uuid not null default gen_random_uuid(),
    "edge_type_id" uuid not null,
    "key" text not null,
    "value_type" text not null,
    "required" boolean not null default false,
    "allowed_values" jsonb,
    "description" text,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."edge_type_fields" enable row level security;


  create table "public"."edge_types" (
    "id" uuid not null default gen_random_uuid(),
    "knowledge_base_id" uuid,
    "name" text not null,
    "label" text not null,
    "description" text,
    "from_node_type" text,
    "to_node_type" text,
    "is_symmetric" boolean not null default false,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."edge_types" enable row level security;


  create table "public"."edges" (
    "id" uuid not null default gen_random_uuid(),
    "knowledge_base_id" uuid not null,
    "type" text not null,
    "from_id" uuid not null,
    "to_id" uuid not null,
    "data" jsonb not null default '{}'::jsonb,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."edges" enable row level security;


  create table "public"."facts" (
    "id" uuid not null default gen_random_uuid(),
    "knowledge_base_id" uuid not null,
    "subject_id" uuid,
    "predicate" text not null,
    "object_id" uuid,
    "value" text,
    "value_type" text,
    "source" text,
    "confidence" real,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."facts" enable row level security;


  create table "public"."knowledge_base_users" (
    "knowledge_base_id" uuid not null,
    "user_id" uuid not null,
    "role" public.knowledge_base_role not null default 'viewer'::public.knowledge_base_role,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."knowledge_base_users" enable row level security;


  create table "public"."knowledge_bases" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "slug" text,
    "description" text,
    "owner_id" uuid default auth.uid(),
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."knowledge_bases" enable row level security;


  create table "public"."node_type_fields" (
    "id" uuid not null default gen_random_uuid(),
    "node_type_id" uuid not null,
    "key" text not null,
    "value_type" text not null,
    "required" boolean not null default false,
    "allowed_values" jsonb,
    "description" text,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."node_type_fields" enable row level security;


  create table "public"."node_types" (
    "id" uuid not null default gen_random_uuid(),
    "knowledge_base_id" uuid,
    "name" text not null,
    "label" text not null,
    "description" text,
    "is_builtin" boolean not null default false,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."node_types" enable row level security;


  create table "public"."nodes" (
    "id" uuid not null default gen_random_uuid(),
    "knowledge_base_id" uuid not null,
    "type" text not null,
    "label" text not null,
    "data" jsonb not null default '{}'::jsonb,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."nodes" enable row level security;


  create table "public"."user_profiles" (
    "user_id" uuid not null,
    "display_name" text,
    "settings" jsonb not null default '{}'::jsonb,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."user_profiles" enable row level security;

CREATE UNIQUE INDEX edge_type_fields_edge_type_id_key_key ON public.edge_type_fields USING btree (edge_type_id, key);

CREATE UNIQUE INDEX edge_type_fields_pkey ON public.edge_type_fields USING btree (id);

CREATE UNIQUE INDEX edge_types_knowledge_base_id_name_key ON public.edge_types USING btree (knowledge_base_id, name);

CREATE UNIQUE INDEX edge_types_pkey ON public.edge_types USING btree (id);

CREATE UNIQUE INDEX edges_pkey ON public.edges USING btree (id);

CREATE UNIQUE INDEX facts_pkey ON public.facts USING btree (id);

CREATE INDEX idx_edge_type_fields_type ON public.edge_type_fields USING btree (edge_type_id);

CREATE INDEX idx_edge_types_kb ON public.edge_types USING btree (knowledge_base_id);

CREATE INDEX idx_edges_from ON public.edges USING btree (from_id);

CREATE INDEX idx_edges_kb ON public.edges USING btree (knowledge_base_id);

CREATE INDEX idx_edges_to ON public.edges USING btree (to_id);

CREATE INDEX idx_facts_kb ON public.facts USING btree (knowledge_base_id);

CREATE INDEX idx_facts_object ON public.facts USING btree (object_id);

CREATE INDEX idx_facts_subject ON public.facts USING btree (subject_id);

CREATE INDEX idx_kb_users_user ON public.knowledge_base_users USING btree (user_id);

CREATE INDEX idx_node_type_fields_type ON public.node_type_fields USING btree (node_type_id);

CREATE INDEX idx_node_types_kb ON public.node_types USING btree (knowledge_base_id);

CREATE INDEX idx_nodes_kb ON public.nodes USING btree (knowledge_base_id);

CREATE UNIQUE INDEX knowledge_base_users_pkey ON public.knowledge_base_users USING btree (knowledge_base_id, user_id);

CREATE UNIQUE INDEX knowledge_bases_owner_id_slug_key ON public.knowledge_bases USING btree (owner_id, slug);

CREATE UNIQUE INDEX knowledge_bases_pkey ON public.knowledge_bases USING btree (id);

CREATE UNIQUE INDEX node_type_fields_node_type_id_key_key ON public.node_type_fields USING btree (node_type_id, key);

CREATE UNIQUE INDEX node_type_fields_pkey ON public.node_type_fields USING btree (id);

CREATE UNIQUE INDEX node_types_knowledge_base_id_name_key ON public.node_types USING btree (knowledge_base_id, name);

CREATE UNIQUE INDEX node_types_pkey ON public.node_types USING btree (id);

CREATE UNIQUE INDEX nodes_id_knowledge_base_id_key ON public.nodes USING btree (id, knowledge_base_id);

CREATE UNIQUE INDEX nodes_pkey ON public.nodes USING btree (id);

CREATE UNIQUE INDEX user_profiles_pkey ON public.user_profiles USING btree (user_id);

alter table "public"."edge_type_fields" add constraint "edge_type_fields_pkey" PRIMARY KEY using index "edge_type_fields_pkey";

alter table "public"."edge_types" add constraint "edge_types_pkey" PRIMARY KEY using index "edge_types_pkey";

alter table "public"."edges" add constraint "edges_pkey" PRIMARY KEY using index "edges_pkey";

alter table "public"."facts" add constraint "facts_pkey" PRIMARY KEY using index "facts_pkey";

alter table "public"."knowledge_base_users" add constraint "knowledge_base_users_pkey" PRIMARY KEY using index "knowledge_base_users_pkey";

alter table "public"."knowledge_bases" add constraint "knowledge_bases_pkey" PRIMARY KEY using index "knowledge_bases_pkey";

alter table "public"."node_type_fields" add constraint "node_type_fields_pkey" PRIMARY KEY using index "node_type_fields_pkey";

alter table "public"."node_types" add constraint "node_types_pkey" PRIMARY KEY using index "node_types_pkey";

alter table "public"."nodes" add constraint "nodes_pkey" PRIMARY KEY using index "nodes_pkey";

alter table "public"."user_profiles" add constraint "user_profiles_pkey" PRIMARY KEY using index "user_profiles_pkey";

alter table "public"."edge_type_fields" add constraint "edge_type_fields_edge_type_id_fkey" FOREIGN KEY (edge_type_id) REFERENCES public.edge_types(id) ON DELETE CASCADE not valid;

alter table "public"."edge_type_fields" validate constraint "edge_type_fields_edge_type_id_fkey";

alter table "public"."edge_type_fields" add constraint "edge_type_fields_edge_type_id_key_key" UNIQUE using index "edge_type_fields_edge_type_id_key_key";

alter table "public"."edge_type_fields" add constraint "edge_type_fields_value_type_valid" CHECK ((value_type = ANY (ARRAY['string'::text, 'date'::text, 'int'::text, 'bool'::text, 'json'::text, 'string_array'::text]))) not valid;

alter table "public"."edge_type_fields" validate constraint "edge_type_fields_value_type_valid";

alter table "public"."edge_types" add constraint "edge_types_knowledge_base_id_fkey" FOREIGN KEY (knowledge_base_id) REFERENCES public.knowledge_bases(id) ON DELETE CASCADE not valid;

alter table "public"."edge_types" validate constraint "edge_types_knowledge_base_id_fkey";

alter table "public"."edge_types" add constraint "edge_types_knowledge_base_id_name_key" UNIQUE using index "edge_types_knowledge_base_id_name_key";

alter table "public"."edges" add constraint "edges_from_same_kb" FOREIGN KEY (from_id, knowledge_base_id) REFERENCES public.nodes(id, knowledge_base_id) ON DELETE CASCADE not valid;

alter table "public"."edges" validate constraint "edges_from_same_kb";

alter table "public"."edges" add constraint "edges_knowledge_base_id_fkey" FOREIGN KEY (knowledge_base_id) REFERENCES public.knowledge_bases(id) ON DELETE CASCADE not valid;

alter table "public"."edges" validate constraint "edges_knowledge_base_id_fkey";

alter table "public"."edges" add constraint "edges_to_same_kb" FOREIGN KEY (to_id, knowledge_base_id) REFERENCES public.nodes(id, knowledge_base_id) ON DELETE CASCADE not valid;

alter table "public"."edges" validate constraint "edges_to_same_kb";

alter table "public"."facts" add constraint "facts_confidence_range" CHECK (((confidence IS NULL) OR ((confidence >= (0)::double precision) AND (confidence <= (1)::double precision)))) not valid;

alter table "public"."facts" validate constraint "facts_confidence_range";

alter table "public"."facts" add constraint "facts_knowledge_base_id_fkey" FOREIGN KEY (knowledge_base_id) REFERENCES public.knowledge_bases(id) ON DELETE CASCADE not valid;

alter table "public"."facts" validate constraint "facts_knowledge_base_id_fkey";

alter table "public"."facts" add constraint "facts_object_id_fkey" FOREIGN KEY (object_id) REFERENCES public.nodes(id) ON DELETE CASCADE not valid;

alter table "public"."facts" validate constraint "facts_object_id_fkey";

alter table "public"."facts" add constraint "facts_object_same_kb" FOREIGN KEY (object_id, knowledge_base_id) REFERENCES public.nodes(id, knowledge_base_id) ON DELETE CASCADE not valid;

alter table "public"."facts" validate constraint "facts_object_same_kb";

alter table "public"."facts" add constraint "facts_require_object_or_value" CHECK (((object_id IS NOT NULL) OR (value IS NOT NULL))) not valid;

alter table "public"."facts" validate constraint "facts_require_object_or_value";

alter table "public"."facts" add constraint "facts_subject_id_fkey" FOREIGN KEY (subject_id) REFERENCES public.nodes(id) ON DELETE CASCADE not valid;

alter table "public"."facts" validate constraint "facts_subject_id_fkey";

alter table "public"."facts" add constraint "facts_subject_same_kb" FOREIGN KEY (subject_id, knowledge_base_id) REFERENCES public.nodes(id, knowledge_base_id) ON DELETE CASCADE not valid;

alter table "public"."facts" validate constraint "facts_subject_same_kb";

alter table "public"."facts" add constraint "facts_value_type_valid" CHECK (((value_type IS NULL) OR (value_type = ANY (ARRAY['string'::text, 'date'::text, 'int'::text, 'bool'::text, 'json'::text])))) not valid;

alter table "public"."facts" validate constraint "facts_value_type_valid";

alter table "public"."knowledge_base_users" add constraint "knowledge_base_users_knowledge_base_id_fkey" FOREIGN KEY (knowledge_base_id) REFERENCES public.knowledge_bases(id) ON DELETE CASCADE not valid;

alter table "public"."knowledge_base_users" validate constraint "knowledge_base_users_knowledge_base_id_fkey";

alter table "public"."knowledge_base_users" add constraint "knowledge_base_users_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."knowledge_base_users" validate constraint "knowledge_base_users_user_id_fkey";

alter table "public"."knowledge_bases" add constraint "knowledge_bases_owner_id_fkey" FOREIGN KEY (owner_id) REFERENCES auth.users(id) ON DELETE SET NULL not valid;

alter table "public"."knowledge_bases" validate constraint "knowledge_bases_owner_id_fkey";

alter table "public"."knowledge_bases" add constraint "knowledge_bases_owner_id_slug_key" UNIQUE using index "knowledge_bases_owner_id_slug_key";

alter table "public"."node_type_fields" add constraint "node_type_fields_node_type_id_fkey" FOREIGN KEY (node_type_id) REFERENCES public.node_types(id) ON DELETE CASCADE not valid;

alter table "public"."node_type_fields" validate constraint "node_type_fields_node_type_id_fkey";

alter table "public"."node_type_fields" add constraint "node_type_fields_node_type_id_key_key" UNIQUE using index "node_type_fields_node_type_id_key_key";

alter table "public"."node_type_fields" add constraint "node_type_fields_value_type_valid" CHECK ((value_type = ANY (ARRAY['string'::text, 'date'::text, 'int'::text, 'bool'::text, 'json'::text, 'string_array'::text]))) not valid;

alter table "public"."node_type_fields" validate constraint "node_type_fields_value_type_valid";

alter table "public"."node_types" add constraint "node_types_knowledge_base_id_fkey" FOREIGN KEY (knowledge_base_id) REFERENCES public.knowledge_bases(id) ON DELETE CASCADE not valid;

alter table "public"."node_types" validate constraint "node_types_knowledge_base_id_fkey";

alter table "public"."node_types" add constraint "node_types_knowledge_base_id_name_key" UNIQUE using index "node_types_knowledge_base_id_name_key";

alter table "public"."nodes" add constraint "nodes_id_knowledge_base_id_key" UNIQUE using index "nodes_id_knowledge_base_id_key";

alter table "public"."nodes" add constraint "nodes_knowledge_base_id_fkey" FOREIGN KEY (knowledge_base_id) REFERENCES public.knowledge_bases(id) ON DELETE CASCADE not valid;

alter table "public"."nodes" validate constraint "nodes_knowledge_base_id_fkey";

alter table "public"."user_profiles" add constraint "user_profiles_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."user_profiles" validate constraint "user_profiles_user_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.set_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
  new.updated_at = now();
  return new;
end;
$function$
;

grant delete on table "public"."edge_type_fields" to "anon";

grant insert on table "public"."edge_type_fields" to "anon";

grant references on table "public"."edge_type_fields" to "anon";

grant select on table "public"."edge_type_fields" to "anon";

grant trigger on table "public"."edge_type_fields" to "anon";

grant truncate on table "public"."edge_type_fields" to "anon";

grant update on table "public"."edge_type_fields" to "anon";

grant delete on table "public"."edge_type_fields" to "authenticated";

grant insert on table "public"."edge_type_fields" to "authenticated";

grant references on table "public"."edge_type_fields" to "authenticated";

grant select on table "public"."edge_type_fields" to "authenticated";

grant trigger on table "public"."edge_type_fields" to "authenticated";

grant truncate on table "public"."edge_type_fields" to "authenticated";

grant update on table "public"."edge_type_fields" to "authenticated";

grant delete on table "public"."edge_type_fields" to "service_role";

grant insert on table "public"."edge_type_fields" to "service_role";

grant references on table "public"."edge_type_fields" to "service_role";

grant select on table "public"."edge_type_fields" to "service_role";

grant trigger on table "public"."edge_type_fields" to "service_role";

grant truncate on table "public"."edge_type_fields" to "service_role";

grant update on table "public"."edge_type_fields" to "service_role";

grant delete on table "public"."edge_types" to "anon";

grant insert on table "public"."edge_types" to "anon";

grant references on table "public"."edge_types" to "anon";

grant select on table "public"."edge_types" to "anon";

grant trigger on table "public"."edge_types" to "anon";

grant truncate on table "public"."edge_types" to "anon";

grant update on table "public"."edge_types" to "anon";

grant delete on table "public"."edge_types" to "authenticated";

grant insert on table "public"."edge_types" to "authenticated";

grant references on table "public"."edge_types" to "authenticated";

grant select on table "public"."edge_types" to "authenticated";

grant trigger on table "public"."edge_types" to "authenticated";

grant truncate on table "public"."edge_types" to "authenticated";

grant update on table "public"."edge_types" to "authenticated";

grant delete on table "public"."edge_types" to "service_role";

grant insert on table "public"."edge_types" to "service_role";

grant references on table "public"."edge_types" to "service_role";

grant select on table "public"."edge_types" to "service_role";

grant trigger on table "public"."edge_types" to "service_role";

grant truncate on table "public"."edge_types" to "service_role";

grant update on table "public"."edge_types" to "service_role";

grant delete on table "public"."edges" to "anon";

grant insert on table "public"."edges" to "anon";

grant references on table "public"."edges" to "anon";

grant select on table "public"."edges" to "anon";

grant trigger on table "public"."edges" to "anon";

grant truncate on table "public"."edges" to "anon";

grant update on table "public"."edges" to "anon";

grant delete on table "public"."edges" to "authenticated";

grant insert on table "public"."edges" to "authenticated";

grant references on table "public"."edges" to "authenticated";

grant select on table "public"."edges" to "authenticated";

grant trigger on table "public"."edges" to "authenticated";

grant truncate on table "public"."edges" to "authenticated";

grant update on table "public"."edges" to "authenticated";

grant delete on table "public"."edges" to "service_role";

grant insert on table "public"."edges" to "service_role";

grant references on table "public"."edges" to "service_role";

grant select on table "public"."edges" to "service_role";

grant trigger on table "public"."edges" to "service_role";

grant truncate on table "public"."edges" to "service_role";

grant update on table "public"."edges" to "service_role";

grant delete on table "public"."facts" to "anon";

grant insert on table "public"."facts" to "anon";

grant references on table "public"."facts" to "anon";

grant select on table "public"."facts" to "anon";

grant trigger on table "public"."facts" to "anon";

grant truncate on table "public"."facts" to "anon";

grant update on table "public"."facts" to "anon";

grant delete on table "public"."facts" to "authenticated";

grant insert on table "public"."facts" to "authenticated";

grant references on table "public"."facts" to "authenticated";

grant select on table "public"."facts" to "authenticated";

grant trigger on table "public"."facts" to "authenticated";

grant truncate on table "public"."facts" to "authenticated";

grant update on table "public"."facts" to "authenticated";

grant delete on table "public"."facts" to "service_role";

grant insert on table "public"."facts" to "service_role";

grant references on table "public"."facts" to "service_role";

grant select on table "public"."facts" to "service_role";

grant trigger on table "public"."facts" to "service_role";

grant truncate on table "public"."facts" to "service_role";

grant update on table "public"."facts" to "service_role";

grant delete on table "public"."knowledge_base_users" to "anon";

grant insert on table "public"."knowledge_base_users" to "anon";

grant references on table "public"."knowledge_base_users" to "anon";

grant select on table "public"."knowledge_base_users" to "anon";

grant trigger on table "public"."knowledge_base_users" to "anon";

grant truncate on table "public"."knowledge_base_users" to "anon";

grant update on table "public"."knowledge_base_users" to "anon";

grant delete on table "public"."knowledge_base_users" to "authenticated";

grant insert on table "public"."knowledge_base_users" to "authenticated";

grant references on table "public"."knowledge_base_users" to "authenticated";

grant select on table "public"."knowledge_base_users" to "authenticated";

grant trigger on table "public"."knowledge_base_users" to "authenticated";

grant truncate on table "public"."knowledge_base_users" to "authenticated";

grant update on table "public"."knowledge_base_users" to "authenticated";

grant delete on table "public"."knowledge_base_users" to "service_role";

grant insert on table "public"."knowledge_base_users" to "service_role";

grant references on table "public"."knowledge_base_users" to "service_role";

grant select on table "public"."knowledge_base_users" to "service_role";

grant trigger on table "public"."knowledge_base_users" to "service_role";

grant truncate on table "public"."knowledge_base_users" to "service_role";

grant update on table "public"."knowledge_base_users" to "service_role";

grant delete on table "public"."knowledge_bases" to "anon";

grant insert on table "public"."knowledge_bases" to "anon";

grant references on table "public"."knowledge_bases" to "anon";

grant select on table "public"."knowledge_bases" to "anon";

grant trigger on table "public"."knowledge_bases" to "anon";

grant truncate on table "public"."knowledge_bases" to "anon";

grant update on table "public"."knowledge_bases" to "anon";

grant delete on table "public"."knowledge_bases" to "authenticated";

grant insert on table "public"."knowledge_bases" to "authenticated";

grant references on table "public"."knowledge_bases" to "authenticated";

grant select on table "public"."knowledge_bases" to "authenticated";

grant trigger on table "public"."knowledge_bases" to "authenticated";

grant truncate on table "public"."knowledge_bases" to "authenticated";

grant update on table "public"."knowledge_bases" to "authenticated";

grant delete on table "public"."knowledge_bases" to "service_role";

grant insert on table "public"."knowledge_bases" to "service_role";

grant references on table "public"."knowledge_bases" to "service_role";

grant select on table "public"."knowledge_bases" to "service_role";

grant trigger on table "public"."knowledge_bases" to "service_role";

grant truncate on table "public"."knowledge_bases" to "service_role";

grant update on table "public"."knowledge_bases" to "service_role";

grant delete on table "public"."node_type_fields" to "anon";

grant insert on table "public"."node_type_fields" to "anon";

grant references on table "public"."node_type_fields" to "anon";

grant select on table "public"."node_type_fields" to "anon";

grant trigger on table "public"."node_type_fields" to "anon";

grant truncate on table "public"."node_type_fields" to "anon";

grant update on table "public"."node_type_fields" to "anon";

grant delete on table "public"."node_type_fields" to "authenticated";

grant insert on table "public"."node_type_fields" to "authenticated";

grant references on table "public"."node_type_fields" to "authenticated";

grant select on table "public"."node_type_fields" to "authenticated";

grant trigger on table "public"."node_type_fields" to "authenticated";

grant truncate on table "public"."node_type_fields" to "authenticated";

grant update on table "public"."node_type_fields" to "authenticated";

grant delete on table "public"."node_type_fields" to "service_role";

grant insert on table "public"."node_type_fields" to "service_role";

grant references on table "public"."node_type_fields" to "service_role";

grant select on table "public"."node_type_fields" to "service_role";

grant trigger on table "public"."node_type_fields" to "service_role";

grant truncate on table "public"."node_type_fields" to "service_role";

grant update on table "public"."node_type_fields" to "service_role";

grant delete on table "public"."node_types" to "anon";

grant insert on table "public"."node_types" to "anon";

grant references on table "public"."node_types" to "anon";

grant select on table "public"."node_types" to "anon";

grant trigger on table "public"."node_types" to "anon";

grant truncate on table "public"."node_types" to "anon";

grant update on table "public"."node_types" to "anon";

grant delete on table "public"."node_types" to "authenticated";

grant insert on table "public"."node_types" to "authenticated";

grant references on table "public"."node_types" to "authenticated";

grant select on table "public"."node_types" to "authenticated";

grant trigger on table "public"."node_types" to "authenticated";

grant truncate on table "public"."node_types" to "authenticated";

grant update on table "public"."node_types" to "authenticated";

grant delete on table "public"."node_types" to "service_role";

grant insert on table "public"."node_types" to "service_role";

grant references on table "public"."node_types" to "service_role";

grant select on table "public"."node_types" to "service_role";

grant trigger on table "public"."node_types" to "service_role";

grant truncate on table "public"."node_types" to "service_role";

grant update on table "public"."node_types" to "service_role";

grant delete on table "public"."nodes" to "anon";

grant insert on table "public"."nodes" to "anon";

grant references on table "public"."nodes" to "anon";

grant select on table "public"."nodes" to "anon";

grant trigger on table "public"."nodes" to "anon";

grant truncate on table "public"."nodes" to "anon";

grant update on table "public"."nodes" to "anon";

grant delete on table "public"."nodes" to "authenticated";

grant insert on table "public"."nodes" to "authenticated";

grant references on table "public"."nodes" to "authenticated";

grant select on table "public"."nodes" to "authenticated";

grant trigger on table "public"."nodes" to "authenticated";

grant truncate on table "public"."nodes" to "authenticated";

grant update on table "public"."nodes" to "authenticated";

grant delete on table "public"."nodes" to "service_role";

grant insert on table "public"."nodes" to "service_role";

grant references on table "public"."nodes" to "service_role";

grant select on table "public"."nodes" to "service_role";

grant trigger on table "public"."nodes" to "service_role";

grant truncate on table "public"."nodes" to "service_role";

grant update on table "public"."nodes" to "service_role";

grant delete on table "public"."user_profiles" to "anon";

grant insert on table "public"."user_profiles" to "anon";

grant references on table "public"."user_profiles" to "anon";

grant select on table "public"."user_profiles" to "anon";

grant trigger on table "public"."user_profiles" to "anon";

grant truncate on table "public"."user_profiles" to "anon";

grant update on table "public"."user_profiles" to "anon";

grant delete on table "public"."user_profiles" to "authenticated";

grant insert on table "public"."user_profiles" to "authenticated";

grant references on table "public"."user_profiles" to "authenticated";

grant select on table "public"."user_profiles" to "authenticated";

grant trigger on table "public"."user_profiles" to "authenticated";

grant truncate on table "public"."user_profiles" to "authenticated";

grant update on table "public"."user_profiles" to "authenticated";

grant delete on table "public"."user_profiles" to "service_role";

grant insert on table "public"."user_profiles" to "service_role";

grant references on table "public"."user_profiles" to "service_role";

grant select on table "public"."user_profiles" to "service_role";

grant trigger on table "public"."user_profiles" to "service_role";

grant truncate on table "public"."user_profiles" to "service_role";

grant update on table "public"."user_profiles" to "service_role";


  create policy "Members read edge type fields"
  on "public"."edge_type_fields"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.edge_types et
  WHERE ((et.id = edge_type_fields.edge_type_id) AND ((et.knowledge_base_id IS NULL) OR (EXISTS ( SELECT 1
           FROM public.knowledge_bases kb
          WHERE ((kb.id = et.knowledge_base_id) AND ((kb.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
                   FROM public.knowledge_base_users kbu
                  WHERE ((kbu.knowledge_base_id = kb.id) AND (kbu.user_id = auth.uid())))))))))))));



  create policy "Owners manage edge type fields"
  on "public"."edge_type_fields"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM (public.edge_types et
     JOIN public.knowledge_bases kb ON ((kb.id = et.knowledge_base_id)))
  WHERE ((et.id = edge_type_fields.edge_type_id) AND (kb.owner_id = auth.uid())))))
with check ((EXISTS ( SELECT 1
   FROM (public.edge_types et
     JOIN public.knowledge_bases kb ON ((kb.id = et.knowledge_base_id)))
  WHERE ((et.id = edge_type_fields.edge_type_id) AND (kb.owner_id = auth.uid())))));



  create policy "Members read edge types"
  on "public"."edge_types"
  as permissive
  for select
  to public
using (((knowledge_base_id IS NULL) OR (EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = edge_types.knowledge_base_id) AND ((kb.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.knowledge_base_users kbu
          WHERE ((kbu.knowledge_base_id = kb.id) AND (kbu.user_id = auth.uid()))))))))));



  create policy "Owners manage edge types"
  on "public"."edge_types"
  as permissive
  for all
  to public
using (((knowledge_base_id IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = edge_types.knowledge_base_id) AND (kb.owner_id = auth.uid()))))))
with check (((knowledge_base_id IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = edge_types.knowledge_base_id) AND (kb.owner_id = auth.uid()))))));



  create policy "Members access edges"
  on "public"."edges"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = edges.knowledge_base_id) AND ((kb.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.knowledge_base_users kbu
          WHERE ((kbu.knowledge_base_id = kb.id) AND (kbu.user_id = auth.uid())))))))));



  create policy "Members modify edges"
  on "public"."edges"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = edges.knowledge_base_id) AND ((kb.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.knowledge_base_users kbu
          WHERE ((kbu.knowledge_base_id = kb.id) AND (kbu.user_id = auth.uid())))))))))
with check ((EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = edges.knowledge_base_id) AND ((kb.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.knowledge_base_users kbu
          WHERE ((kbu.knowledge_base_id = kb.id) AND (kbu.user_id = auth.uid())))))))));



  create policy "Members access facts"
  on "public"."facts"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = facts.knowledge_base_id) AND ((kb.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.knowledge_base_users kbu
          WHERE ((kbu.knowledge_base_id = kb.id) AND (kbu.user_id = auth.uid())))))))));



  create policy "Members modify facts"
  on "public"."facts"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = facts.knowledge_base_id) AND ((kb.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.knowledge_base_users kbu
          WHERE ((kbu.knowledge_base_id = kb.id) AND (kbu.user_id = auth.uid())))))))))
with check ((EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = facts.knowledge_base_id) AND ((kb.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.knowledge_base_users kbu
          WHERE ((kbu.knowledge_base_id = kb.id) AND (kbu.user_id = auth.uid())))))))));



  create policy "Owners manage memberships"
  on "public"."knowledge_base_users"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = knowledge_base_users.knowledge_base_id) AND (kb.owner_id = auth.uid())))))
with check ((EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = knowledge_base_users.knowledge_base_id) AND (kb.owner_id = auth.uid())))));



  create policy "Select memberships for participant or owner"
  on "public"."knowledge_base_users"
  as permissive
  for select
  to public
using (((user_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = knowledge_base_users.knowledge_base_id) AND (kb.owner_id = auth.uid()))))));



  create policy "Delete own knowledge bases"
  on "public"."knowledge_bases"
  as permissive
  for delete
  to public
using ((owner_id = auth.uid()));



  create policy "Insert knowledge bases as owner"
  on "public"."knowledge_bases"
  as permissive
  for insert
  to public
with check ((owner_id = auth.uid()));



  create policy "Manage own knowledge bases"
  on "public"."knowledge_bases"
  as permissive
  for update
  to public
using ((owner_id = auth.uid()))
with check ((owner_id = auth.uid()));



  create policy "Select knowledge bases as member"
  on "public"."knowledge_bases"
  as permissive
  for select
  to public
using (((owner_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.knowledge_base_users kbu
  WHERE ((kbu.knowledge_base_id = knowledge_bases.id) AND (kbu.user_id = auth.uid()))))));



  create policy "Members read node type fields"
  on "public"."node_type_fields"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.node_types nt
  WHERE ((nt.id = node_type_fields.node_type_id) AND ((nt.knowledge_base_id IS NULL) OR (EXISTS ( SELECT 1
           FROM public.knowledge_bases kb
          WHERE ((kb.id = nt.knowledge_base_id) AND ((kb.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
                   FROM public.knowledge_base_users kbu
                  WHERE ((kbu.knowledge_base_id = kb.id) AND (kbu.user_id = auth.uid())))))))))))));



  create policy "Owners manage node type fields"
  on "public"."node_type_fields"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM (public.node_types nt
     JOIN public.knowledge_bases kb ON ((kb.id = nt.knowledge_base_id)))
  WHERE ((nt.id = node_type_fields.node_type_id) AND (kb.owner_id = auth.uid())))))
with check ((EXISTS ( SELECT 1
   FROM (public.node_types nt
     JOIN public.knowledge_bases kb ON ((kb.id = nt.knowledge_base_id)))
  WHERE ((nt.id = node_type_fields.node_type_id) AND (kb.owner_id = auth.uid())))));



  create policy "Members read node types"
  on "public"."node_types"
  as permissive
  for select
  to public
using (((knowledge_base_id IS NULL) OR (EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = node_types.knowledge_base_id) AND ((kb.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.knowledge_base_users kbu
          WHERE ((kbu.knowledge_base_id = kb.id) AND (kbu.user_id = auth.uid()))))))))));



  create policy "Owners manage node types"
  on "public"."node_types"
  as permissive
  for all
  to public
using (((knowledge_base_id IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = node_types.knowledge_base_id) AND (kb.owner_id = auth.uid()))))))
with check (((knowledge_base_id IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = node_types.knowledge_base_id) AND (kb.owner_id = auth.uid()))))));



  create policy "Members access nodes"
  on "public"."nodes"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = nodes.knowledge_base_id) AND ((kb.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.knowledge_base_users kbu
          WHERE ((kbu.knowledge_base_id = kb.id) AND (kbu.user_id = auth.uid())))))))));



  create policy "Members modify nodes"
  on "public"."nodes"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = nodes.knowledge_base_id) AND ((kb.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.knowledge_base_users kbu
          WHERE ((kbu.knowledge_base_id = kb.id) AND (kbu.user_id = auth.uid())))))))))
with check ((EXISTS ( SELECT 1
   FROM public.knowledge_bases kb
  WHERE ((kb.id = nodes.knowledge_base_id) AND ((kb.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.knowledge_base_users kbu
          WHERE ((kbu.knowledge_base_id = kb.id) AND (kbu.user_id = auth.uid())))))))));



  create policy "Select own profile"
  on "public"."user_profiles"
  as permissive
  for select
  to public
using ((auth.uid() = user_id));



  create policy "Upsert own profile"
  on "public"."user_profiles"
  as permissive
  for all
  to public
using ((auth.uid() = user_id))
with check ((auth.uid() = user_id));


CREATE TRIGGER set_updated_at_knowledge_bases BEFORE UPDATE ON public.knowledge_bases FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_updated_at_nodes BEFORE UPDATE ON public.nodes FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_updated_at_user_profiles BEFORE UPDATE ON public.user_profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
