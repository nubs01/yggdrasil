from __future__ import annotations

import os
from functools import cache
from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict
from pathlib import Path


class Settings(BaseSettings):
    # Config
    model_config = SettingsConfigDict(
        env_file=None,
        env_file_encoding="utf-8",
        extra="ignore",
    )

    # Database
    POSTGRES_USER: str = Field(..., env="POSTGRES_USER")
    POSTGRES_PASSWORD: str = Field(..., env="POSTGRES_PASSWORD")
    POSTGRES_HOST: str = Field(..., env="POSTGRES_HOST")
    POSTGRES_PORT: str = Field(..., env="POSTGRES_PORT")
    POSTGRES_DB: str = Field(..., env="POSTGRES_DB")

    # DEBUG
    DEBUG: bool = Field(False, env="DEBUG")

    @property
    def database_url(self) -> str:
        return (
            f"postgresql+asyncpg://{self.POSTGRES_USER}:"
            f"{self.POSTGRES_PASSWORD}@{self.POSTGRES_HOST}:"
            f"{self.POSTGRES_PORT}/{self.POSTGRES_DB}"
        )


@cache
def get_settings() -> Settings:
    ROOT_DIR = Path(__file__).resolve().parents[1]
    env_files = {
        "base": ROOT_DIR / ".env",
        "local": ROOT_DIR / ".env.local",
        "production": ROOT_DIR / ".env.production",
    }
    env = os.getenv("APP_ENV", "base")
    if env in env_files and env_files[env].exists():
        return Settings(_env_file=env_files[env])

    return Settings()
