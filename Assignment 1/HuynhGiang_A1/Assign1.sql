/********************************************************************
 * Movie Rental Details for Client report
 * Author: GIANG TRUONG, HUYNH
 * Date:   Sep 12, 2019
 ********************************************************************/

CONN T218/giang123456@DBMSDBII
SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET PAGESIZE 30
SET LINESIZE 120
-- SET NEWPAGE NONE to skip the first empty line
SET NEWPAGE NONE

ACCEPT CustomerID NUMBER FORMAT '999' PROMPT 'Customer ID: ' 

-- Top title: Show title, Customer ID and Page number
TTITLE CENTER 'Movie Rental Details for Client ' TAB 8 &CustomerID  -
  RIGHT  'Page: ' FORMAT 9 SQL.PNO SKIP 2

-- Column formating
COLUMN AgreementID FORMAT 999999999 HEADING 'Agreement'
COLUMN FName FORMAT A15 HEADING 'First Name'
COLUMN LName FORMAT A15 HEADING 'Last Name'
COLUMN AgreementDate FORMAT A12 HEADING 'Date'
COLUMN Name FORMAT A55 HEADING 'Movie Name'
COLUMN RentalAmount FORMAT $990.00 HEADING 'Paid'

-- Bottome title
BTITLE LEFT 'Run by:' SQL.USER

-- Grouping for report
BREAK ON AgreementID  ON FName ON LName -
 ON REPORT SKIP 1
COMPUTE SUM LABEL 'Total' OF RentalAmount ON REPORT

SPOOL C:\DBMSDBII\A1\Reports\Huynh_G.txt
SELECT  ra.AgreementId , 
	SUBSTR(TRIM(c.FName),1,15) FName, 
	SUBSTR(c.LName,1,15) LName, 
	TO_CHAR(ra.AgreementDate,'YYYY-MM-DD') AgreementDate, 
	SUBSTR(m.Name,1,55) Name, 
	mr.RentalAmount
FROM MovieRented mr
JOIN RentalAgreement ra ON mr.AgreementID = ra.AgreementID
JOIN Movie m ON mr.MovieID = m.MovieID
JOIN Customer c ON ra.CustID = c.CustID
WHERE c.CustID = &CustomerID
ORDER BY ra.AgreementId;

SPOOL OFF
CLEAR COLUMN
CLEAR BREAK
EXIT
