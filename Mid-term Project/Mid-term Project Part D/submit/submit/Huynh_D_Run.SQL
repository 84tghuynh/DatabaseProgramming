/***********************************************************************************
 * Midterm Part D - This script is used to create the file Create_Tables_Huynh.SQL
 * 		  - This script will call the Extract_Tables store procedures
 * Author: GIANG TRUONG, HUYNH
 * Version: V4.0
 * Date:   Sep 30th, 2019
 ***********************************************************************************/

CONN T218/giang123456@DBMSDBII

SET FEEDBACK OFF

SET SERVEROUTPUT ON SIZE 10000 FORMAT WRAPPED;

SPOOL Create_Tables_Huynh.SQL
	  
BEGIN
  
   Extract_Tables;
 
END;
/
SPOOL OFF

SHOW ERRORS
EXIT







