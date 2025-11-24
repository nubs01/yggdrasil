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
    SUPABASE_URL: str = Field(..., env="SUPABASE_URL")
    SUPABASE_KEY: str = Field(..., env="SUPABASE_KEY")

    # Data
    S3_ACCESS_KEY: str = Field(..., env="S3_ACCESS_KEY")
    S3_SECRET_KEY: str = Field(..., env="S3_SECRET_KEY")
    S3_REGION: str = Field(..., env="S3_REGION")
    S3_BUCKET_NAME: str = Field(..., env="S3_BUCKET_NAME")

    # DEBUG
    DEBUG: bool = Field(False, env="DEBUG")


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
