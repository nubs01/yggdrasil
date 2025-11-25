# Repository Guidelines

## Project Structure & Module Organization
- App code and scripts live under project root; Supabase config/migrations in `supabase/` (`schemas/`, `seeds/`, `migrations/`), docs in `docs/`.
- Graph data model: core schema SQL in `supabase/schemas/001_core.sql`, graph tables in `002_graph.sql`, type registry in `003_type_registry.sql`; ontology reference in `docs/ontology.md`.

## Build, Test, and Development Commands
- `supabase db reset` – reset local stack (drops, migrates, seeds). Ensure Docker is running.
- `supabase db seed` – apply seeds only (after schema is in place).
- `supabase db diff -f <name>` – generate migration from local DB; free shadow port (`shadow_port` in config) if needed.
- `supabase start/stop --project-id midguardian_knowledge` – manage local Supabase containers.

## Coding Style & Naming Conventions
- SQL is Postgres/Supabase-flavored; keep statements idempotent where possible (guards, `on conflict`).
- Use snake_case for table/column names; plural table names for entities; RLS policies in quoted Title Case.
- Prefer JSONB for flexible fields (`data`, `settings`) per ontology.

## Testing Guidelines
- Primary verification is via Supabase CLI: run `supabase db reset` then `supabase db seed` to ensure schemas and seeds apply cleanly.
- When adding migrations, run `supabase db diff` against a clean reset to confirm reproducibility.

## Commit & Pull Request Guidelines
- Write concise, present-tense commit messages (e.g., “add kb seed defaults”, “fix RLS for edges”).
- For PRs: describe changes, include affected paths (e.g., `supabase/schemas/*.sql`, `supabase/seeds/*.sql`), note any Supabase commands run (`db reset`, `db seed`), and call out breaking changes (new enums, RLS adjustments).

## Security & Configuration Tips
- Auth-bound tables reference `auth.users`; avoid hardcoding secrets—use env vars in `supabase/config.toml`.
- RLS is enabled on user data, graph entities, and registries; ensure new tables enforce KB scoping and member/owner access patterns.
