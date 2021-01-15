@ECHO OFF
REM ************************************************
REM Assigment 1 - Batch files and SQL Report
REM GIANG TRUONG, HUYNH
REM Sep 12th, 2019
REM ************************************************

REM ************************************************
REM Begin process
REM ************************************************

:BEGIN
CLS

REM ************************************************
REM Title & Menu
REM ************************************************
ECHO.
ECHO Giang Huynh Movie Rentals
ECHO.
ECHO 1. Generate Report
ECHO 2. Exit
ECHO.

SET input=
SET /P input=Enter your choice: 

IF '%input%'=='' (
    ECHO.
    ECHO Error - No choice entered. Please choose an option displayed.
    ECHO.
    PAUSE
    GOTO BEGIN  
) ELSE IF '%input%'=='1' (
    ECHO.
    IF NOT EXIST C:\DBMSDBII\A1\Reports (
       MKDIR C:\DBMSDBII\A1\Reports
    )
    SQLPLUS /nolog @assign1.sql
    PAUSE
    GOTO BEGIN  
) ELSE IF '%input%'=='2' (
    EXIT
) ELSE (
    ECHO.
    ECHO Error - Invalid choice entered. Please choose a valid option.
    ECHO.
    PAUSE
    GOTO BEGIN
)

PAUSE