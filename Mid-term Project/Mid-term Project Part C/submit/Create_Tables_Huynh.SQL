---- Oracle Catalog Extract Utility V3.0 ----                                   
----                                                                            
---- Run on Oct 04, 2019 at 11:47                                               
----                                                                            
---- S T A R T I N G  T A B L E  D R O P S                                      
----                                                                            
DROP TABLE IMAGE;                                                               
DROP TABLE ORDERS;                                                              
DROP TABLE PRODUCTS;                                                            
----                                                                            
---- T A B L E  D R O P S  C O M P L E T E D                                    
----                                                                            
----                                                                            
---- S T A R T I N G  T A B L E  C R E A T E                                    
----                                                                            
--   Start extracting table IMAGE                                               
CREATE TABLE IMAGE (                                                            
  MFR                   CHAR(3)                                    NOT NULL     
, PRODUCT               CHAR(5)                                    NOT NULL     
, IMAGE                 BLOB                                                    
================================================================================
=== EXCEPTION -20100 Raised - ORA-20100: ***Unknown data type BLOB ***          
=== Unable to complete table generation for IMAGE                               
================================================================================
                   ); -- END of Table IMAGE creation                            
--                                                                              
--                                                                              
--   Start extracting table ORDERS                                              
CREATE TABLE ORDERS (                                                           
  ORDERNUM              NUMBER(7)                                  NOT NULL     
, ORDERDATE             DATE              DEFAULT CURRENT_DATE                  
, CUST                  NUMBER(3)                                               
, REP                   NUMBER(3)                                               
, MANUF                 CHAR(3)                                                 
, PROD                  CHAR(5)                                                 
, QTY                   NUMBER(5)                                               
, AMOUNT                NUMBER(5,2)                                             
, CONSTRAINT ORDERSPK                                                           
     PRIMARY KEY(ORDERNUM )                                                     
                    ); -- END of Table ORDERS creation                          
--                                                                              
--                                                                              
--   Start extracting table PRODUCTS                                            
CREATE TABLE PRODUCTS (                                                         
  MFR                   CHAR(3)                                    NOT NULL     
, PRODUCT               CHAR(5)                                    NOT NULL     
, DESCRIPTION           VARCHAR2(100)     DEFAULT 'N/A'                         
, PRICE                 NUMBER(5,2)                                             
, QTYONHAND             NUMBER(5)         DEFAULT 0                             
, CONSTRAINT PRODUCTSPK                                                         
     PRIMARY KEY(MFR , PRODUCT )                                                
, CONSTRAINT UNIQUEDESCRIPTION                                                  
     UNIQUE (DESCRIPTION)                                                       
, CONSTRAINT UNIQUEPRODUCT                                                      
     UNIQUE (PRODUCT)                                                           
, CONSTRAINT CHECKPRICE                                                         
     CHECK (Price BETWEEN .01 AND 87.98)                                        
, CONSTRAINT CHECKQUANTITY                                                      
     CHECK (QtyOnHand >= 0)                                                     
                      ); -- END of Table PRODUCTS creation                      
--                                                                              
--                                                                              
---- T A B L E  C R E A T E  C O M P L E T E D                                  
----                                                                            
---- Oracle Catalog Extract Utility V3.0 ----                                   
---- Run Completed on Oct 04, 2019 at 11:47                                     
