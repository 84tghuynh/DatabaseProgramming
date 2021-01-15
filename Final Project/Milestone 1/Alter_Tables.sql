/********************************************************************
 * Database Management Systems II (DBMS-2004)
 * Final Project Milestone 1
 * Author: GIANG TRUONG, HUYNH
 * Date:   Nov 18, 2019
 ********************************************************************/

 /** Drop tables */
DROP TABLE BookAuthor CASCADE CONSTRAINTS;
DROP TABLE BookRented CASCADE CONSTRAINTS;
DROP TABLE eBook CASCADE CONSTRAINTS;


/** Create tables */
CREATE TABLE eBook (
  BookID NUMBER(5) NOT NULL,
  ISBN CHAR(13),
  Title VARCHAR2(100) NOT NULL,
  Publisher VARCHAR2(100),
  Published DATE,
  NoOfPages NUMBER(4),
  RentalCost NUMBER(5,2) NOT NULL,
  CONSTRAINT BooksPK
    PRIMARY KEY (BookID),
  CONSTRAINT RentalCostCK
    CHECK (RentalCost > 0),
  CONSTRAINT ISBNUnique 
      UNIQUE (ISBN)
);

CREATE TABLE BookAuthor (
  BookID NUMBER(5) NOT NULL,
  ContributorID NUMBER(5) NOT NULL
);

CREATE TABLE BookRented (
  AgreementID NUMBER(5) NOT NULL,
  BookID NUMBER(5) NOT NULL,
  RentalAmount NUMBER(5,2) NOT NULL,
  RentalExpiry DATE NOT NULL
);

/** Add Foreign key for tables */
ALTER TABLE BookAuthor 
  ADD CONSTRAINT eBookAuthorFK 
  FOREIGN KEY(BookID)
  REFERENCES eBook(BookID);
  
ALTER TABLE BookAuthor 
  ADD CONSTRAINT ContributorEBookFK 
  FOREIGN KEY(ContributorID)
  REFERENCES Contributor(ContributorID);

ALTER TABLE BookRented 
  ADD CONSTRAINT AgreementBookRentedFK 
  FOREIGN KEY(AgreementID)
  REFERENCES RentalAgreement(AgreementID);

ALTER TABLE BookRented 
  ADD CONSTRAINT eBookRentedFK
  FOREIGN KEY(BookID)
  REFERENCES eBook(BookID);

/** Rename name of column */
ALTER TABLE RentalAgreement
   RENAME COLUMN MovieCount TO ItemCount;

/** Add column RentalType to table with NULLABLE first */
ALTER TABLE RentalAgreement 
    ADD RentalType CHAR(1); 

/** Update the value of RentalType */ 
UPDATE RentalAgreement 
SET RentalType='M';

/** The RentalType has value, changes its properties to NOT NULL */
ALTER TABLE RentalAgreement 
    MODIFY RentalType NOT NULL;






