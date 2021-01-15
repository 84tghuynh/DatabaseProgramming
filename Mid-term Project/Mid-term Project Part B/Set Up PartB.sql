ACCEPT userid PROMPT "Please enter your user id: "
conn &userid@DBMSDBII
--=================================================
-- This script cleans up your schema and 
-- creates three tables that can be used
-- to test the second part of assignment 6.
--
-- When this script your schema will be empty
-- except for the three tables listed below.
--=================================================
PURGE RECYCLEBIN;

EXEC CleanUp;

CREATE TABLE Products
( Mfr         CHAR(3)	NOT NULL         
 ,Product     CHAR(5)	NOT NULL         
 ,Description VARCHAR2(100) DEFAULT 'N/A'
 ,Price       NUMBER(5,2)     
 ,QtyOnHand   NUMBER(5) DEFAULT 0
);
--
--
CREATE TABLE Orders
( OrderNum    NUMBER(7)	NOT NULL
 ,OrderDate   DATE DEFAULT CURRENT_DATE            
 ,Cust        Number(3)
 ,Rep         Number(3)
 ,Manuf       CHAR(3)         
 ,Prod        CHAR(5)         
 ,Qty         NUMBER(5)       
 ,Amount      NUMBER(5,2)     
);

CREATE TABLE IMAGE
( Mfr         CHAR(3)	NOT NULL         
 ,Product     CHAR(5)	NOT NULL         
 ,Image       BLOB
 ,TechSpecs   BFILE);
 
 
EXIT; 
 