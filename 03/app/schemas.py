from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

# -------- books ----------
class BookBase(BaseModel):
    title: str
    author: str

class BookCreate(BookBase):
    pass

class Book(BookBase):
    id: int
    checked_out: bool

    class Config:
        orm_mode = True

class BookList(BaseModel):
    books: List[Book]

# -------- loans ----------
class LoanBase(BaseModel):
    borrower: str

class LoanCreate(LoanBase):
    pass                       # only borrower is needed on checkout

class Loan(LoanBase):
    id: int
    book_id: int
    checkout_time: datetime
    return_time: datetime | None

    class Config:
        orm_mode = True