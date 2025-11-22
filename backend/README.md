## Midguardian Knowledge Graph

A Streamlit application backed by PostgreSQL, SQLAlchemy models, and Alembic
migrations. Use it to capture and browse entities that make up your knowledge
graph.

### Prerequisites

- [uv](https://docs.astral.sh/uv/) for dependency management
- Docker (for the local PostgreSQL service)

### Getting started

1. Configure the database variables in `.env` (defaults match `docker-compose.yml`).
2. Start PostgreSQL: `docker compose up -d postgres`.
3. Install dependencies: `uv sync`.
4. Run migrations: `uv run alembic upgrade head`.
5. Launch the Streamlit UI: `uv run streamlit run streamlit_app.py`.

### Creating new migrations

Use Alembic to track schema changes as your models evolve:

```bash
uv run alembic revision --autogenerate -m "describe change"
uv run alembic upgrade head
```

Ensure new models inherit from `midguardian_kg.database.Base` so Alembic can pick
them up automatically.
