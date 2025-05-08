from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from ..database import SessionLocal
from .. import crud, schemas

router = APIRouter(prefix="/books", tags=["books"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[schemas.Book])
def list_books(db: Session = Depends(get_db)):
    return crud.get_books(db)

@router.post("/", response_model=schemas.Book)
async def create_book(book: schemas.BookCreate, db: Session = Depends(get_db)):
    return crud.create_book(db=db, book=book)

@router.post("/{book_id}/checkout", response_model=schemas.Book)
def checkout(
    book_id: int,
    loan: schemas.LoanCreate,                 # borrower supplied in body
    db: Session = Depends(get_db)
):
    book = crud.checkout_book(db, book_id, borrower=loan.borrower)
    if book is None:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail="Book does not exist or already checked out")
    return book

@router.post("/{book_id}/return", response_model=schemas.Book)
def do_return(book_id: int, db: Session = Depends(get_db)):
    book = crud.return_book(db, book_id)
    if book is None:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail="Book does not exist or is not checked out")
    return book

@router.get("/{book_id}/loans", response_model=list[schemas.Loan])
def loan_history(book_id: int, db: Session = Depends(get_db)):
    """
    Full loan / return history for this book (most-recent first).
    """
    return crud.get_loans_for_book(db, book_id)