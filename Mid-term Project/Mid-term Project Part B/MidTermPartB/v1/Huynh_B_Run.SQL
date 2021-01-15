/***********************************************************************************
 * Midterm Part B - This script is used to create the file Create_Tables_Huynh.SQL
 * 		  - This script will call the Extract_Tables store procedures
 * Author: GIANG TRUONG, HUYNH
 * Date:   Sep 30th, 2019
 ***********************************************************************************/

CONN T218/giang123456@DBMSDBII

SET FEEDBACK OFF
SET VERIFY OFF
SET PAGESIZE 30
SET LINESIZE 120

SET SERVEROUTPUT ON SIZE 10000 FORMAT WRAPPED;

SPOOL Create_Tables_Huynh.SQL
	  
BEGIN
  
   Extract_Tables;
 
END;
/
SPOOL OFF

SHOW ERRORS
EXIT







