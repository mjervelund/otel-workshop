# FastAPI Library

This project is a FastAPI application that manages a library system with a SQLite3 database. It allows users to list books, check them out, and return them.

## Project Structure

```diagram
fastapi-library/
├── .env                 # Environment variables for the application
├── app
│   ├── main.py          # Entry point of the FastAPI application
│   ├── database.py      # Database connection and session management
│   ├── models.py        # SQLAlchemy models for the application
│   ├── schemas.py       # Pydantic schemas for data validation
│   ├── crud.py          # CRUD operations for the Book model
│   └── routers
│       └── books.py     # API routes related to books
├── tests
│   └── test_books.py    # Unit tests for book-related functionality
├── requirements.txt      # Project dependencies
├── .gitignore            # Files and directories to ignore by Git
└── README.md             # Project documentation
```

## Setup Instructions

1. **Install dependencies:**

   ```shell
   pip install -r requirements.txt
   ```

2. **Run the application:**

   ```shell
   uvicorn app.main:app --reload
   ```

3. **Access the API:**
   Open your browser and navigate to `http://127.0.0.1:8000/docs` to view the interactive API documentation.
