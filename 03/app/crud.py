from sqlalchemy.orm import Session
from datetime import datetime
from . import models, schemas

def get_book(db: Session, book_id: int):
    return db.query(models.Book).filter(models.Book.id == book_id).first()

def get_books(db: Session):
    return db.query(models.Book).all()

def get_books_count(db: Session):
    return db.query(models.Book).count()

def create_book(db: Session, book: schemas.BookCreate):
    db_book = models.Book(**book.dict())
    db.add(db_book)
    db.commit()
    db.refresh(db_book)
    return db_book

def checkout_book(db: Session, book_id: int, borrower: str):
    book = get_book(db, book_id)
    if not book or book.checked_out:
        return None
    book.checked_out = True
    loan = models.Loan(book_id=book_id, borrower=borrower)
    db.add(loan)
    db.commit()
    db.refresh(book)
    return book

def return_book(db: Session, book_id: int):
    book = get_book(db, book_id)
    if not book or not book.checked_out:
        return None
    # mark the active loan as returned
    loan = (
        db.query(models.Loan)
        .filter(models.Loan.book_id == book_id, models.Loan.return_time.is_(None))
        .order_by(models.Loan.checkout_time.desc())
        .first()
    )
    if loan:
        loan.return_time = datetime.utcnow()
    book.checked_out = False
    db.commit()
    db.refresh(book)
    return book

def get_loans_for_book(db: Session, book_id: int):
    return (
        db.query(models.Loan)
        .filter(models.Loan.book_id == book_id)
        .order_by(models.Loan.checkout_time.desc())
        .all()
    )