/********************************************************************
 * Database Management Systems II (DBMS-2004)
 * Assignment #4 – Users and Roles
 * Author: GIANG TRUONG, HUYNH
 * Date:   Nov 11, 2019
 ********************************************************************/
--1
CREATE USER T218_JGarnet
	IDENTIFIED BY userol;

CREATE USER T218_PBlat
	IDENTIFIED BY userol;

CREATE USER T218_RSeymore
	IDENTIFIED BY userol;

--2
CREATE ROLE T218_Receptionist_Role;

--3
GRANT CREATE SESSION 
	TO T218_Receptionist_Role; 

--4
GRANT SELECT
	ON Customer
	TO T218_Receptionist_Role;

GRANT SELECT
	ON RentalAgreement
	TO T218_Receptionist_Role;

GRANT SELECT
	ON MovieRented
	TO T218_Receptionist_Role;

GRANT SELECT
	ON Movie
	TO T218_Receptionist_Role;

--5
GRANT T218_Receptionist_Role
	TO T218_JGarnet;

--6
CREATE ROLE T218_Salesperson_Role;

--7
GRANT CREATE SESSION 
	TO T218_Salesperson_Role; 

--8
GRANT T218_Receptionist_Role
	TO T218_Salesperson_Role;
  
GRANT INSERT
	ON RentalAgreement
	TO T218_Salesperson_Role;

GRANT INSERT
	ON MovieRented
	TO T218_Salesperson_Role;

--9
GRANT T218_Salesperson_Role
	TO T218_PBlat; 

--10
CREATE ROLE T218_SaleManager_Role;

--11
ALTER ROLE T218_SaleManager_Role 
      IDENTIFIED BY pasrol;

--12
GRANT CREATE SESSION 
	TO T218_SaleManager_Role; 

--13
GRANT SELECT,INSERT,UPDATE,DELETE
	ON Customer
	TO T218_SaleManager_Role; 

GRANT SELECT,INSERT,UPDATE,DELETE
	ON RentalAgreement
	TO T218_SaleManager_Role; 

GRANT SELECT,INSERT,UPDATE,DELETE
	ON MovieRented
	TO T218_SaleManager_Role; 

GRANT SELECT,INSERT,UPDATE,DELETE
	ON Movie
	TO T218_SaleManager_Role; 

--14
GRANT T218_Salesperson_Role, T218_SaleManager_Role
	TO T218_RSeymore; 

--15
ALTER USER T218_RSeymore DEFAULT ROLE ALL EXCEPT T218_SaleManager_Role;


--16
SET ROLE T218_SaleManager_Role IDENTIFIED BY pasrol, 
        T218_Salesperson_Role;

--17 
SET ROLE T218_Salesperson_Role;










