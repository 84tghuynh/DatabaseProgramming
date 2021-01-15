/********************************************************************
 * Midterm Part B - This script is used for compiling two store procedures
 * Author: GIANG TRUONG, HUYNH
 * Date:   Sep 30th, 2019
 ********************************************************************/

CONN T218/giang123456@DBMSDBII


CREATE OR REPLACE PROCEDURE Extract_Columns(
/*
 * GIANG HUYNH
 * Sep 30th, 2019
 * Midterm Part B
 * Extract column name of each table is passed to the store procedure
 * by using User_Tab_Columns table in System Catalog
 */
 iTableName IN  User_Tab_Columns.Table_Name%TYPE
)
AS
  CURSOR TableColumns IS
    SELECT Column_ID, Column_Name, Data_Type, Data_Length, Data_Precision, Data_Scale, Data_Default, Nullable
    FROM User_Tab_Columns
    WHERE Table_Name = iTableName
    ORDER BY Column_ID;
  CurrentRow TableColumns%ROWTYPE;
  wColumnNameSpace NUMBER(2) := 30;
  wDataTypeSpace NUMBER (2) := 20;
  wValidDataTypeSpace NUMBER (2) := 40;
  wDefaultValueSpace NUMBER (2) := 30;
  wRowResult VARCHAR2(250);
  wValidType CHAR(1) :='Y';
BEGIN
 
  FOR CurrentRow IN TableColumns LOOP
     --------------------------------
     -- ColumnName And Type        --
     --------------------------------
     IF(CurrentRow.Data_Type = 'CHAR') THEN
        wRowResult := RPAD(CurrentRow.Column_Name,wColumnNameSpace,' ') ||
                     RPAD(CurrentRow.Data_Type || '(' ||  CurrentRow.Data_Length || ')',wDataTypeSpace,' ');
      
     ELSIF(CurrentRow.Data_Type = 'VARCHAR2') THEN
        wRowResult := RPAD(CurrentRow.Column_Name,wColumnNameSpace,' ') ||
                      RPAD(CurrentRow.Data_Type || '(' ||  CurrentRow.Data_Length || ')',wDataTypeSpace,' ');
     ELSIF(CurrentRow.Data_Type= 'DATE') THEN
         wRowResult := RPAD(CurrentRow.Column_Name,wColumnNameSpace,' ') ||
                       RPAD(CurrentRow.Data_Type ,wDataTypeSpace,' ');
     
     ELSIF(CurrentRow.Data_Type = 'NUMBER') THEN
        
        IF(CurrentRow.Data_Scale = 0 ) THEN
           wRowResult := RPAD(CurrentRow.Column_Name,wColumnNameSpace,' ') ||
                       RPAD(CurrentRow.Data_Type || '(' ||  CurrentRow.Data_Precision || ')',wDataTypeSpace,' '); 
        ELSE
            wRowResult := RPAD(CurrentRow.Column_Name,wColumnNameSpace,' ') ||
                       RPAD(CurrentRow.Data_Type || '(' ||  CurrentRow.Data_Precision || ',' || CurrentRow.Data_Scale  ||')',wDataTypeSpace,' ');
        END IF;
          
     ELSE
         wRowResult := RPAD(CurrentRow.Column_Name,wColumnNameSpace,' ') ||
                       RPAD('*** Unknown data type ' || CurrentRow.Data_Type || ' ***',wValidDataTypeSpace,' ');
         wValidType := 'N';
     END IF;
     --------------------------------
     -- Default value AND NOT NULL --
     --------------------------------
     IF (wValidType = 'Y') THEN
          IF(CurrentRow.Data_Default IS NOT NULL) THEN   
            wRowResult :=  wRowResult || RPAD('DEFAULT ' || trim(translate(CurrentRow.Data_Default,chr(10), ' ')),wDefaultValueSpace,' ');
            
          ELSE 
            wRowResult := wRowResult|| RPAD(' ',wDefaultValueSpace,' ');
          END IF;
          
          IF (CurrentRow.Nullable = 'N') THEN
            wRowResult := wRowResult || 'NOT NULL';
          END IF;
     END IF;
     
     
     -----------------------------
     -- Print the result        --
     -----------------------------
     IF (CurrentRow.Column_ID = 1) THEN
        
        DBMS_OUTPUT.PUT_LINE('  ' || wRowResult );
     ELSE
        DBMS_OUTPUT.PUT_LINE(', ' || wRowResult);
     END IF;
  END LOOP;
END;
/
SHOW ERRORS


CREATE OR REPLACE PROCEDURE Extract_Tables
/*
 * GIANG HUYNH
 * Sep 30th, 2019
 * Midterm Part B
 * Extract table name in the user's schema from User_Tables table
 * in System Catalog.
 */
AS
  wVersion CHAR(4) :='V2.0';
  CURSOR UserTables IS
    SELECT Table_Name
    FROM User_Tables
    ORDER BY Table_Name;
  CurrentRow UserTables%ROWTYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('---- Oracle Catalog Extract Utility ' || wVersion || ' ----'  );
  DBMS_OUTPUT.PUT_LINE('----');
  DBMS_OUTPUT.put_line('----' || ' Run on ' || TO_CHAR(CURRENT_DATE, 'Mon DD, YYYY') || ' at ' || TO_CHAR(CURRENT_DATE, 'HH24:MI'));
  DBMS_OUTPUT.PUT_LINE('----');
  DBMS_OUTPUT.PUT_LINE('----' || ' S T A R T I N G  T A B L E  D R O P S');
  DBMS_OUTPUT.PUT_LINE('----');
  
  FOR CurrentRow IN UserTables LOOP
    DBMS_OUTPUT.PUT_LINE('DROP TABLE ' || CurrentRow.Table_Name || ';');
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('----');
  DBMS_OUTPUT.PUT_LINE('----' || ' T A B L E  D R O P S  C O M P L E T E D');
  DBMS_OUTPUT.PUT_LINE('----');
  DBMS_OUTPUT.PUT_LINE('----');
  DBMS_OUTPUT.PUT_LINE('----' || ' S T A R T I N G  T A B L E  C R E A T E');
  DBMS_OUTPUT.PUT_LINE('----');

  FOR CurrentRow IN UserTables LOOP
     DBMS_OUTPUT.PUT_LINE('--   Start extracting table ' || CurrentRow.Table_Name );
     DBMS_OUTPUT.PUT_LINE('CREATE TABLE ' || CurrentRow.Table_Name || ' (');

     EXTRACT_COLUMNS(CurrentRow.Table_Name);
     -- LPAD for string ' );' . This length of the string (' );' is 3.
     DBMS_OUTPUT.PUT_LINE(LPAD(' );',LENGTH('CREATE TABLE ' || CurrentRow.Table_Name) + 3 ,' ') || ' -- END of Table ' || CurrentRow.Table_Name || ' creation' );
     DBMS_OUTPUT.PUT_LINE('--');
     DBMS_OUTPUT.PUT_LINE('--');
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('----' || ' T A B L E  C R E A T E  C O M P L E T E D');
  DBMS_OUTPUT.PUT_LINE('----');
  DBMS_OUTPUT.PUT_LINE('---- Oracle Catalog Extract Utility ' || wVersion || ' ----'  );
  DBMS_OUTPUT.put_line('----' || ' Run Completed on ' || TO_CHAR(CURRENT_DATE, 'Mon DD, YYYY') || ' at ' || TO_CHAR(CURRENT_DATE, 'HH24:MI'));

END;

/
SHOW ERRORS

EXIT

