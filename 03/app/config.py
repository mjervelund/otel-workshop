from functools import lru_cache
from pydantic import Field
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """
    Application-wide configuration pulled from environment variables
    (with safe defaults for local development).
    """

    env: str = Field("dev", env="ENV")
    app_name: str = Field("FastAPI Library", env="APP_NAME")
    api_version: str = Field("1.0.0", env="API_VERSION")
    database_url: str = Field("sqlite:///./library.db", env="DATABASE_URL")
    log_level: str = Field("INFO", env="LOG_LEVEL")

    class Config:
        case_sensitive = False  # ENV / env both work


@lru_cache
def get_settings() -> Settings:
    # lru_cache guarantees we create the object once and reuse it
    return Settings()