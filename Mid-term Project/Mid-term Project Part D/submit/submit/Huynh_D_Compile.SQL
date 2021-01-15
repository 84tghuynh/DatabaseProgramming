/********************************************************************
 * Midterm Part D - This script is used for compiling two store procedures
 * Author: GIANG TRUONG, HUYNH
 * Version: V4.0
 * Date:   Sep 30th, 2019
 ********************************************************************/

CONN T218/giang123456@DBMSDBII


CREATE OR REPLACE FUNCTION Get_Constraint_Columns(
/*
 * GIANG HUYNH
 * Oct 9th, 2019
 * Midterm Part D
 * Return the columns associated with Primary Key or Unique constraints.
 * by using User_Cons_Columns table in System Catalog
 */

  iTableName IN User_Constraints.Table_Name%TYPE,
  iConstraintName IN User_Constraints.Constraint_Name%TYPE
)
RETURN VARCHAR2
AS
   CURSOR ConstraintColumns IS
      SELECT Column_Name
      FROM User_Cons_Columns
      WHERE Table_Name = iTableName AND
            Constraint_Name = iConstraintName
      ORDER BY Position;
   CurrentRow ConstraintColumns%ROWTYPE;
   wColumnsResult VARCHAR2(50) :='';
BEGIN

    FOR CurrentRow IN ConstraintColumns LOOP
       IF (ConstraintColumns%ROWCOUNT = 1) THEN
         wColumnsResult := CurrentRow.Column_Name;
       ELSE
          wColumnsResult :=  wColumnsResult || ' , ' || CurrentRow.Column_Name;
       END IF;
    END LOOP;

   RETURN wColumnsResult;
END;
/
SHOW ERRORS;

CREATE OR REPLACE PROCEDURE Extract_Check_Constraints(
/*
 * GIANG HUYNH
 * Oct 9th, 2019
 * Midterm Part D
 * Extract CHECK Constraints in each table is passed to the store procedure
 * by using User_Constraints table in System Catalog
 *
 */
 iTableName IN  User_Constraints.Table_Name%TYPE
)
AS
  CURSOR CheckConstraintNames IS
    SELECT Constraint_Name, Search_Condition
    FROM User_Constraints
    WHERE Table_Name = iTableName AND
          Constraint_Type = 'C';

  CurrentRow CheckConstraintNames%ROWTYPE;

BEGIN
  FOR CurrentRow IN CheckConstraintNames LOOP
      IF (INSTR(CurrentRow.Search_Condition,'" IS NOT NULL') = 0 ) THEN
        DBMS_OUTPUT.PUT_LINE(', ' || 'CONSTRAINT ' || CurrentRow.Constraint_Name );
        DBMS_OUTPUT.PUT_LINE('  ' || '   CHECK (' || CurrentRow.Search_Condition || ')');
      END IF;
  END LOOP;
END;

/
SHOW ERRORS;

CREATE OR REPLACE PROCEDURE Extract_Columns(
/*
 * GIANG HUYNH
 * Oct 9th, 2019
 * Midterm Part D
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
  wColumnNameSpace NUMBER(2) := 22;
  wDataTypeSpace NUMBER (2) := 18;
  wInValidDataTypeSpace NUMBER (2) := 40;
  wDefaultValueSpace NUMBER (2) := 25;
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
                       RPAD(CurrentRow.Data_Type ,wDataTypeSpace,' ');
         -----------------------------
         -- Print the result        --
         -----------------------------
         IF (TableColumns%ROWCOUNT = 1) THEN
            DBMS_OUTPUT.PUT_LINE('  ' || wRowResult );
         ELSE
            DBMS_OUTPUT.PUT_LINE(', ' || wRowResult);
         END IF;


        -- RAISE INVALID_COLUMN_TYPE;
         RAISE_APPLICATION_ERROR(-20100, '***Unknown data type ' || CurrentRow.Data_Type || ' ***');
         ---------------------------------------------------------------------
         -- Stop processing the statements below                            --
         -- Propagation the Exception to the Extract_Tables store procedure --
         ---------------------------------------------------------------------
         wRowResult := RPAD(CurrentRow.Column_Name,wColumnNameSpace,' ') ||
                       RPAD('*** Unknown data type ' || CurrentRow.Data_Type || ' ***',wInValidDataTypeSpace,' ');
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
     IF (TableColumns%ROWCOUNT = 1) THEN
        DBMS_OUTPUT.PUT_LINE('  ' || wRowResult );
     ELSE
        DBMS_OUTPUT.PUT_LINE(', ' || wRowResult);
     END IF;
  END LOOP;
END;

/
SHOW ERRORS;

CREATE OR REPLACE PROCEDURE Extract_FK_Constraint(
/*
 * GIANG HUYNH
 * Oct 9th, 2019
 * Midterm Part D
 * Extract column names of Foreign Key Constraint in each table is passed to the store procedure
 * by using User_Constraints table in System Catalog and call Get_Constraint_Columns function
 *
 */
 iTableName IN  User_Constraints.Table_Name%TYPE
)
AS
  CURSOR ForeignKeyConstraints IS
    SELECT Constraint_Name, R_Constraint_name, Delete_Rule
    FROM User_Constraints
    WHERE Table_Name = iTableName AND 
           Constraint_Type = 'R';
  
  CurrentRow ForeignKeyConstraints%ROWTYPE;
  wParent_Table_Name User_Constraints.Table_Name%TYPE := ' ';
  wCount NUMBER(2) := 0;
BEGIN
    SELECT COUNT(*)
    INTO wCount
    FROM User_Constraints
    WHERE Table_Name = iTableName AND 
          Constraint_Type = 'R';
            
    IF(  wCount  > 0) THEN
        DBMS_OUTPUT.PUT_LINE('--');
        DBMS_OUTPUT.PUT_LINE('--');
        DBMS_OUTPUT.PUT_LINE('--' || ' Start Alter of Table ' || iTableName );
          
        FOR CurrentRow IN ForeignKeyConstraints LOOP
            SELECT Table_Name
            INTO wParent_Table_Name
            FROM User_Constraints
            WHERE Constraint_Name = CurrentRow.R_Constraint_name;
            
            IF (CurrentRow.Delete_Rule = 'CASCADE') THEN
               DBMS_OUTPUT.PUT_LINE('ALTER TABLE ' || iTableName );
               DBMS_OUTPUT.PUT_LINE('   ADD CONSTRAINT ' || CurrentRow.Constraint_name );
               DBMS_OUTPUT.PUT_LINE('       FOREIGN KEY (' || Get_Constraint_Columns(iTableName,CurrentRow.Constraint_name) || ' )');
               DBMS_OUTPUT.PUT_LINE('       REFERENCES ' ||  wParent_Table_Name);
               DBMS_OUTPUT.PUT_LINE('       ON DELETE CASCADE;');
            ELSE 
               DBMS_OUTPUT.PUT_LINE('ALTER TABLE ' || iTableName );
               DBMS_OUTPUT.PUT_LINE('   ADD CONSTRAINT ' || CurrentRow.Constraint_name );
               DBMS_OUTPUT.PUT_LINE('       FOREIGN KEY (' || Get_Constraint_Columns(iTableName,CurrentRow.Constraint_name) || ' )');
               DBMS_OUTPUT.PUT_LINE('       REFERENCES ' ||  wParent_Table_Name || ';');
            END IF;
            DBMS_OUTPUT.PUT_LINE('--');
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('--' || ' End Alter of Table ' || iTableName );
    END IF;
END;

/
SHOW ERRORS;

CREATE OR REPLACE PROCEDURE Extract_PK_Constraint(
/*
 * GIANG HUYNH
 * Oct 9th, 2019
 * Midterm Part D
 * Extract column names of Primary Key Constraint in each table is passed to the store procedure
 * by using User_Constraints table in System Catalog and call Get_Constraint_Columns function
 *
 */
 iTableName IN  User_Constraints.Table_Name%TYPE
)
AS
  wConstraintName User_Constraints.Constraint_Name%TYPE := ' ';
  wCount NUMBER(2) := 0;
  NO_PK_DEFINED EXCEPTION;
BEGIN
    SELECT count(*)
    INTO wCount
    FROM User_Constraints
    WHERE Table_Name = iTableName AND
          Constraint_Type = 'P';
     
    IF( wCount = 0) THEN
        RAISE NO_PK_DEFINED;
    END IF;
    SELECT Constraint_Name
    INTO wConstraintName
    FROM User_Constraints
    WHERE Table_Name = iTableName AND
          Constraint_Type = 'P';

    IF (wConstraintName != ' ') THEN
       DBMS_OUTPUT.PUT_LINE(', ' || 'CONSTRAINT ' || wConstraintName );
       DBMS_OUTPUT.PUT_LINE('  ' || '   PRIMARY KEY(' || Get_Constraint_Columns(iTableName,wConstraintName) || ' )');
    END IF;
    
    
EXCEPTION
    WHEN NO_PK_DEFINED THEN
         DBMS_OUTPUT.PUT_LINE('-- *** WARNING *** No Primary Key Defined');          
END;

/
SHOW ERRORS;

CREATE OR REPLACE PROCEDURE Extract_Unique_Constraints(
/*
 * GIANG HUYNH
 * Oct 9th, 2019
 * Midterm Part D
 * Extract UNIQUE Constraints in each table is passed to the store procedure
 * by using User_Constraints table in System Catalog and call Get_Constraint_Columns function
 *
 */
 iTableName IN  User_Constraints.Table_Name%TYPE
)
AS
  CURSOR UniqueConstraintNames IS
    SELECT Constraint_Name
    FROM User_Constraints
    WHERE Table_Name = iTableName AND
          Constraint_Type = 'U';
  CurrentRow UniqueConstraintNames%ROWTYPE;

BEGIN
  FOR CurrentRow IN UniqueConstraintNames LOOP
    DBMS_OUTPUT.PUT_LINE(', ' || 'CONSTRAINT ' || CurrentRow.Constraint_Name );
    DBMS_OUTPUT.PUT_LINE('  ' || '   UNIQUE (' || Get_Constraint_Columns(iTableName,CurrentRow.Constraint_Name) || ')');
  END LOOP;
END;

/
SHOW ERRORS;

CREATE OR REPLACE PROCEDURE Extract_Tables(
/*
 * GIANG HUYNH
 * Oct 9th, 2019
 * Midterm Part D
 * Extract table name in the user's schema from User_Tables table
 * in System Catalog.
 */
  iTableName IN  User_Tables.Table_Name%TYPE :='%'
)
AS
  wVersion CHAR(4) :='V4.0';
  CURSOR UserTables IS
    SELECT Table_Name
    FROM User_Tables
    WHERE UPPER(Table_Name) LIKE UPPER(iTableName)
    ORDER BY Table_Name;
  CurrentRow UserTables%ROWTYPE;
  wRowSpace NUMBER (2) := 80;
  wRowResult VARCHAR2(250);

  INVALID_COLUMN_TYPE EXCEPTION;
  PRAGMA EXCEPTION_INIT(INVALID_COLUMN_TYPE, -20100);
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
     BEGIN
         Extract_Columns(CurrentRow.Table_Name);
         Extract_PK_Constraint(CurrentRow.Table_Name);
         Extract_Unique_Constraints(CurrentRow.Table_Name);
         Extract_Check_Constraints(CurrentRow.Table_Name);
         -- LPAD for string ' );' . This length of the string (' );' is 3.
         DBMS_OUTPUT.PUT_LINE(LPAD(' );',LENGTH('CREATE TABLE ' || CurrentRow.Table_Name) + 3 ,' ') || ' -- END of Table ' || CurrentRow.Table_Name || ' creation' );
         DBMS_OUTPUT.PUT_LINE('--');
         DBMS_OUTPUT.PUT_LINE('--');
     EXCEPTION
         WHEN INVALID_COLUMN_TYPE THEN
             DBMS_OUTPUT.PUT_LINE(RPAD('=',wRowSpace,'='));
             DBMS_OUTPUT.PUT_LINE('=== '|| 'EXCEPTION ' || SQLCODE || ' Raised - ' || SQLERRM);
             DBMS_OUTPUT.PUT_LINE('=== '|| 'Unable to complete table generation for ' || CurrentRow.Table_Name);
             DBMS_OUTPUT.PUT_LINE(RPAD('=',wRowSpace,'='));
             DBMS_OUTPUT.PUT_LINE(LPAD(' );',LENGTH('CREATE TABLE ' || CurrentRow.Table_Name) + 3 ,' ') || ' -- END of Table ' || CurrentRow.Table_Name || ' creation' );
             DBMS_OUTPUT.PUT_LINE('--');
             DBMS_OUTPUT.PUT_LINE('--');

     END;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('----' || ' T A B L E  C R E A T E  C O M P L E T E D');
  DBMS_OUTPUT.PUT_LINE('----');
  DBMS_OUTPUT.PUT_LINE('----');
  DBMS_OUTPUT.PUT_LINE('----' || ' S T A R T I N G  T A B L E  A L T E R');
  
    FOR CurrentRow IN UserTables LOOP
       Extract_FK_Constraint( CurrentRow.Table_Name);
    END LOOP;
 
  DBMS_OUTPUT.PUT_LINE('----');
  DBMS_OUTPUT.PUT_LINE('----' || ' T A B L E  A L T E R  C O M P L E T E D');
  DBMS_OUTPUT.PUT_LINE('----');
  DBMS_OUTPUT.PUT_LINE('---- Oracle Catalog Extract Utility ' || wVersion || ' ----'  );
  DBMS_OUTPUT.put_line('----' || ' Run Completed on ' || TO_CHAR(CURRENT_DATE, 'Mon DD, YYYY') || ' at ' || TO_CHAR(CURRENT_DATE, 'HH24:MI'));

END;

/
SHOW ERRORS;
EXIT;