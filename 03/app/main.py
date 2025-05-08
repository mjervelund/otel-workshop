from fastapi import FastAPI
from .database import engine
from .routers import books
from . import crud, schemas
import json
from pathlib import Path
import os
from dotenv import load_dotenv
from .config import get_settings

load_dotenv()                             # reads .env into the process
settings = get_settings()                 # validated config object

app = FastAPI(
    title=settings.app_name,
    version=settings.api_version
)

app.include_router(books.router)

@app.on_event("startup")
async def startup_event():
    import app.models  # noqa: F401
    app.models.Base.metadata.create_all(bind=engine)

    # ---- seed on first run ----
    data_file = Path(__file__).parent.parent / "data" / "books.json"
    if not data_file.exists():
        return
    from .database import SessionLocal
    db = SessionLocal()
    try:
        if crud.get_books_count(db) == 0:
            with data_file.open(encoding="utf-8") as f:
                for item in json.load(f):
                    crud.create_book(db, schemas.BookCreate(**item))
    finally:
        db.close()

@app.get("/")
async def root():
    return {"message": "Welcome to the FastAPI Library"}