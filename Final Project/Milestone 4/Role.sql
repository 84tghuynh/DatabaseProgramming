/********************************************************************
 * GIANG HUYNH
 * Final Project Milestone 4
 * Version: V4.0
 * Date:   Dec 03th, 2019
 ********************************************************************/
 
 /**
  *  Deliverable 1
  *  Create a role named Book_Manager_Role (prefix the role name with your userid).
  *  This role needs full permissions (Select, Insert, Update, Delete) on
  *  + RentalAgreement
  *  + BookRented
  *  + BookAuthor
  */ 
 CREATE ROLE T218_Book_Manager_Role;
 
 GRANT CREATE SESSION 
       TO T218_Book_Manager_Role;
       
 GRANT SELECT, INSERT, UPDATE, DELETE
       ON RentalAgreement
       TO T218_Book_Manager_Role;
 
 GRANT SELECT, INSERT, UPDATE, DELETE
       ON BookRented
       TO T218_Book_Manager_Role;
       
 GRANT SELECT, INSERT, UPDATE, DELETE
       ON BookAuthor
       TO T218_Book_Manager_Role;



/**
 *  Deliverable 2
 *  Create a role named Book_Salesperson_Role (prefix the role name with your userid)
 *  This role needs SELECT on 
 *  + RentalAgreement
 *  + BookRented
 *  + BookAuthor
 *  + Contributor
 *
 *  This role also needs INSERT and UPDATE on
 *  + RentalAgreement
 *  + BookRented
 */

CREATE ROLE T218_Book_Salesperson_Role;
 
GRANT CREATE SESSION 
       TO T218_Book_Salesperson_Role;

GRANT SELECT, INSERT, UPDATE
       ON RentalAgreement
       TO T218_Book_Salesperson_Role;
 
GRANT SELECT, INSERT, UPDATE
       ON BookRented
       TO T218_Book_Salesperson_Role;

GRANT SELECT
       ON BookAuthor
       TO T218_Book_Salesperson_Role;
  
GRANT SELECT
       ON Contributor
       TO T218_Book_Salesperson_Role;
       


/**
 *  Deliverable 3
 *  To create the user accounts/passwords and grant the necessary roles to the user below
 *  Their new database names will be the first letter of their first and middle name
 *  followed by their last name (prefix the user name with your userid)
 *  Book Manager:
 *    Brent R. Longstaffe       T218_BRLongstaffe
 *  Book Salesperson:
 *    Tina Doreen Wiznowski     T218_TDWiznowski
 *    Douglas A. Armstrong      T218_DAArmstrong
 */
 
CREATE USER T218_BRLongstaffe
	IDENTIFIED BY userol;

CREATE USER T218_TDWiznowski
	IDENTIFIED BY userol;

CREATE USER T218_DAArmstrong
	IDENTIFIED BY userol;

GRANT T218_Book_Manager_Role
	TO T218_BRLongstaffe; 

GRANT T218_Book_Salesperson_Role
	TO T218_TDWiznowski,T218_DAArmstrong; 