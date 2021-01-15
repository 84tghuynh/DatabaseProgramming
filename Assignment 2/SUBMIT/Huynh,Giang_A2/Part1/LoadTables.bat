@ECHO OFF
REM ******************************************************************
REM * Run an SQL Script to import some data to Customer, RentalAgreement and MovieRented
REM * Author: Giang Huynh
REM * Date:   Oct 27, 2019
REM ******************************************************************

REM Load data to Customer table
ECHO --------------------------------
ECHO Load data to Customer table...
SQLLDR T218/giang123456@DBMSDBII CONTROL=Customer.ctl

REM Load data to RentalAgreement table
ECHO --------------------------------
ECHO Load data to RentalAgreement table...
SQLLDR T218/giang123456@DBMSDBII CONTROL=RentalAgreement.ctl

REM Load data to MovieRented table
ECHO --------------------------------
ECHO Load data to MovieRented table...
SQLLDR T218/giang123456@DBMSDBII CONTROL=MovieRented.ctl


PAUSE