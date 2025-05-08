from datetime import datetime
from sqlalchemy import Boolean, Column, ForeignKey, DateTime, Integer, String
from sqlalchemy.orm import relationship

from .database import Base


class Book(Base):
    __tablename__ = "books"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    author = Column(String, nullable=False)
    checked_out = Column(Boolean, default=False)

    loans = relationship("Loan", back_populates="book", cascade="all, delete-orphan")


class Loan(Base):
    __tablename__ = "loans"

    id = Column(Integer, primary_key=True, index=True)
    book_id = Column(Integer, ForeignKey("books.id"), nullable=False)
    borrower = Column(String, nullable=False)
    checkout_time = Column(DateTime, default=datetime.utcnow, nullable=False)
    return_time = Column(DateTime, nullable=True)

    book = relationship("Book", back_populates="loans")