ACCEPT userid PROMPT "Please enter your user id: "
conn &userid@DBMSDBII
--=================================================
-- This script cleans up your schema and 
-- creates a pair of tables that can be 
-- used to test the first part of assignment 6.
--
-- When this script your schema will be empty
-- except for the two tables listed below.
--=================================================
SET SERVEROUTPUT ON

EXEC CleanUp;

CREATE TABLE Products
( Mfr         CHAR         
 ,Product     CHAR         
 ,Description CHAR    
 ,Price       CHAR     
 ,QtyOnHand   CHAR
);
--
--
CREATE TABLE Orders
( OrderNum    CHAR      
 ,OrderCHAR   CHAR            
 ,Cust        CHAR
 ,Rep         CHAR
 ,Manuf       CHAR         
 ,Prod        CHAR         
 ,Qty         CHAR       
 ,Amount      CHAR     
);

exit