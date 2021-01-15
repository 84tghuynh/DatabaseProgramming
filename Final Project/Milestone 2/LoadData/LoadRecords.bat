@ECHO OFF
REM ******************************************************************
REM * Run an SQL Script to import some data to Customer, RentalAgreement and MovieRented
REM * Author: Giang Huynh
REM * Date:   11 21th, 2019
REM ******************************************************************

REM Load data to eBook table
ECHO --------------------------------
ECHO Load data to eBook table...
SQLLDR T218/giang123456@DBMSDBII CONTROL=eBook.ctl

REM Load data to Contributor table
ECHO --------------------------------
ECHO Load data to Contributor table...
SQLLDR T218/giang123456@DBMSDBII CONTROL=Author.ctl

REM Load data to BookAuthor table
ECHO --------------------------------
ECHO Load data to BookAuthor table...
SQLLDR T218/giang123456@DBMSDBII CONTROL=BookAuthor.ctl


PAUSE