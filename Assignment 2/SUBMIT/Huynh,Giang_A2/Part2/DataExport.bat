@ECHO OFF
REM ******************************************************************
REM * Run an SQL Script to export some data to csv file
REM * Author: Giang Huynh
REM * Date:   Oct 27, 2019
REM ******************************************************************

SQLPLUS /nolog @DataExport.sql

PAUSE