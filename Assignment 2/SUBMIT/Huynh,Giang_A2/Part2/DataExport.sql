/******************************************************************
 * SQL Script to export some data to csv file
 * Author: Giang Huynh
 * Date:   Oct 27, 2019
******************************************************************/
CONN T218/giang123456@DBMSDBII 
SET ECHO OFF
SET PAGESIZE 0
SET LINESIZE 150
SET FEEDBACK OFF
SET VERIFY OFF

SPOOL 'DataExport.dat' 
/******************************************************************
 * Get data of the last 30 days based on the maximum agreement date in tables.
 * 
******************************************************************/
SELECT  ra.CustID || ',' ||
	TO_CHAR(ra.AgreementDate,'YYYY-MM-DD') || ',' ||
	mr.RentalAmount || ',' ||
	COALESCE(mr.PercentReductionApplied,0) || ',' ||
	m.MovieID || ',' ||
	m.Name || ',' ||
	COALESCE(TO_CHAR(m.Released,'YYYY-MM-DD'),'Unknown')
FROM MovieRented mr
JOIN RentalAgreement ra ON mr.AgreementID = ra.AgreementID
JOIN Movie m ON mr.MovieID = m.MovieID
JOIN Customer c ON ra.CustID = c.CustID
WHERE ra.AgreementDate > 
	(SELECT MAX(AgreementDate) - 30
	 FROM RentalAgreement )
ORDER BY ra.CustId, ra.AgreementDate, mr.MovieID;

SPOOL OFF
EXIT
