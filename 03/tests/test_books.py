from fastapi.testclient import TestClient
from app.main import app
from app.database import get_db
from app.models import Book
from sqlalchemy.orm import Session
from fastapi import status

client = TestClient(app)

def override_get_db():
    db = next(get_db())
    try:
        yield db
    finally:
        db.close()

app.dependency_overrides[get_db] = override_get_db

def test_list_books():
    response = client.get("/books/")
    assert response.status_code == status.HTTP_200_OK
    assert isinstance(response.json(), list)

def test_checkout_book():
    book_data = {"title": "Test Book", "author": "Test Author", "is_checked_out": False}
    response = client.post("/books/", json=book_data)
    assert response.status_code == status.HTTP_201_CREATED

    book_id = response.json()["id"]
    response = client.post(f"/books/{book_id}/checkout")
    assert response.status_code == status.HTTP_200_OK
    assert response.json()["is_checked_out"] is True

def test_return_book():
    book_data = {"title": "Test Book", "author": "Test Author", "is_checked_out": True}
    response = client.post("/books/", json=book_data)
    assert response.status_code == status.HTTP_201_CREATED

    book_id = response.json()["id"]
    response = client.post(f"/books/{book_id}/return")
    assert response.status_code == status.HTTP_200_OK
    assert response.json()["is_checked_out"] is False