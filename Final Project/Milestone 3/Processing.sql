/********************************************************************
*  GIANG HUYNH
 * Nov 28th, 2019
 * Final Project Milestone 3
 * Version: V4.0
 * Date:   Nov 28th, 2019
 ********************************************************************/


CREATE OR REPLACE TRIGGER Validate_Type
BEFORE INSERT OR UPDATE ON RentalAgreement
FOR EACH ROW
WHEN (NEW.RentalType NOT IN ('M','B') )
BEGIN
     IF :NEW.RentalType = 'm' THEN
        :NEW.RentalType := 'M';
     ELSIF :NEW.RentalType = 'b' THEN
        :NEW.RentalType := 'B';
     ELSE
       RAISE_APPLICATION_ERROR(-20750, 'Invalid Rental Type ' || :NEW.RentalType || ' specified');
     END IF;
END;
/
SHOW ERRORS;

CREATE OR REPLACE FUNCTION Calculate_Rental_Amount(
/*
 * GIANG HUYNH
 * Nov 28th, 2019
 * Final Project Milestone 3
 * To determine the rental cost of a book.
 * The function is passed the Book ID.
 * Retrieve the Book and return the rental cost.
 * Make sure the Book ID passed in exists.
 * If it does not, raise application error number -20850 with the error message �No such
 * book�.
 */
  iBookID IN eBook.BookID%TYPE
)
RETURN NUMBER
AS
   wRentalCost NUMBER(5,2) :='';
BEGIN
    SELECT RentalCost
    INTO wRentalCost
    FROM eBook
    WHERE BookID = iBookID;

    RETURN wRentalCost;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20850,'No such book');
END;
/
SHOW ERRORS;

CREATE OR REPLACE PROCEDURE Add_Rental_Agreement(
/*
 * GIANG HUYNH
 * Nov 28th, 2019
 * Final Project Milestone 3
 * Be passed the ID of the customer placing the order, and
 * The type of the rental order. 
 * RentalType entered is �m� or �M�, raise the exception �-20950� with the message �*** ERROR procedure
 * does not support creation of movie rentals� and terminate.
 * The RentalType is anything other than �M�, �m�, �B�, or �b� then do nothing (the trigger created above catches this).
 * INSERT: NEW RENTALAGREEMENT
 * 1. The AgreementID is the highest agreement value on the RentalAgreement table plus 1;
 * 2. The Customer ID is the value passed in;
 * 3. The Agreement Date is today (the date the stored procedure runs);
 * 4. The ItemCount is null;
 * 5. The Duration ID is always 4 (7 days);
 * 6. The RentalType is the value passed in.
 */
 iCustID IN  RentalAgreement.CustID%TYPE,
 iRentalType IN RentalAgreement.RentalType%TYPE
)
AS
 wAgreementID NUMBER(5) :=''; 
 wCurrentDate DATE := TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD');
BEGIN
  IF(iRentalType = 'm' OR iRentalType = 'M') THEN
    RAISE_APPLICATION_ERROR(-20950,'*** ERROR procedure does not support creation of movie rentals');
  END IF;
  
  SELECT MAX(AgreementID) + 1
  INTO wAgreementID
  FROM RentalAgreement;
  
  INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, ItemCount, DurationID,RentalType)
  VALUES (wAgreementID,iCustID,wCurrentDate,'',4,iRentalType);
END;
/
SHOW ERRORS;

CREATE OR REPLACE PROCEDURE Add_Book_Rented(
/*
 * GIANG HUYNH
 * Nov 28th, 2019
 * Final Project Milestone 3
 * Be passed the ID of the book rented
 * The Agreement ID this rental is associated with and the date of the rental.
 * Add a new Book Rented record to the table as follows
 * 1. The BookID is the value passed in
 * 2. The AgreementID is the value passed in
 * 3. Use the function created above to determine the rental amount for the book rented
 * 4. The Rental Expiry is 7 days after the date the book was rented (which is passed in)
 */
 iBookID IN  BookRented.BookID%TYPE,
 iAgreementID IN BookRented.AgreementID%TYPE,
 iRentalDate IN BookRented.RentalExpiry%TYPE
)
AS
  wRentalAmount NUMBER(5,2) := '';
BEGIN
  wRentalAmount := Calculate_Rental_Amount(iBookID);
  
  INSERT INTO BookRented(AgreementID,BookID,RentalAmount,RentalExpiry)
  VALUES (iAgreementID,iBookID,wRentalAmount,TO_CHAR(iRentalDate +7, 'YYYY-MM-DD'));
END;
/
SHOW ERRORS;
