@ECHO OFF
REM ************************************************
REM Midterm Part B
REM Purpose: + To compile two store procedures 
REM 	     + Or to Run a script call two complied store procedures above
REM Requirement:  Run Compile at least one time before run the script to call two store procedures.
REM
REM Author: GIANG TRUONG, HUYNH
REM Version: V2.0
REM Update: Sep 30th, 2019
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
ECHO Midterm Part B
ECHO.
ECHO 'C'ompile
ECHO 'R'un
ECHO e'X'it
ECHO.

SET input=
SET /P input=Enter your choice: 

IF /I '%input%'=='C' (
    ECHO.
    SQLPLUS /nolog @Huynh_B_Compile.SQL
    PAUSE
    EXIT

) ELSE IF /I '%input%'=='R' (
    ECHO.
    SQLPLUS /nolog @Huynh_B_Run.SQL
    EXIT
) ELSE IF /I '%input%'=='X' (
    ECHO.
    EXIT
) ELSE (
    ECHO.
    ECHO Error - Invalid choice entered. Please choose a valid option.
    ECHO.
    PAUSE
    GOTO BEGIN
)


PAUSE