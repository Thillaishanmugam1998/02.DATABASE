/*========================================================
  FILE  : 08_sequence_practice.sql
  TOPIC : SQL Server SEQUENCE
========================================================*/


/*========================================================
  IDENTITY vs SEQUENCE (DETAILED COMPARISON)
========================================================*/

/*
----------------------------------------------------------
FEATURE                    IDENTITY                SEQUENCE
----------------------------------------------------------
Object Type                 Column Property         Database Object
----------------------------------------------------------
Table Dependency             Dependent on table      Independent object
----------------------------------------------------------
Value Generation             On INSERT only          On demand (NEXT VALUE)
----------------------------------------------------------
Multiple Table Usage         ❌ Not possible         ✅ Possible
----------------------------------------------------------
Manual Control               ❌ Limited              ✅ Full control
----------------------------------------------------------
Insert Explicit Value        ❌ (Default)             ✅ Always allowed
----------------------------------------------------------
Reset Value                  DBCC / TRUNCATE         ALTER SEQUENCE
----------------------------------------------------------
Delete Impact                Gaps remain             Gaps remain
----------------------------------------------------------
Cycle Support                ❌ No                   ✅ Yes
----------------------------------------------------------
Cache Support                ❌ No                   ✅ Yes
----------------------------------------------------------
Generate Before Insert       ❌ No                   ✅ Yes
----------------------------------------------------------
Performance                  Good                    Better (with CACHE)
----------------------------------------------------------
Use Case                     Simple PK               Complex numbering
----------------------------------------------------------
*/


/*========================================================
  REAL-TIME SCENARIO COMPARISON
========================================================*/

/*
CASE 1: SIMPLE EMPLOYEE TABLE
----------------------------
Requirement:
- Only one table
- Auto increment primary key
- No reuse needed

Best Choice: IDENTITY


CASE 2: MULTIPLE TABLES NEED SAME NUMBER SERIES
-----------------------------------------------
Tables:
- sales_order
- purchase_order
- return_order

Requirement:
- One common running number
- Generated before insert
- Full control

Best Choice: SEQUENCE


CASE 3: BUSINESS DOCUMENT NUMBER
--------------------------------
Requirement:
- Invoice number should restart every year
- Controlled reset
- Can be reused in many tables

Best Choice: SEQUENCE
*/


/*========================================================
  IDENTITY EXAMPLE (QUICK)
========================================================*/

IF OBJECT_ID('emp_identity') IS NOT NULL
    DROP TABLE emp_identity;

CREATE TABLE emp_identity
(
    empid INT IDENTITY(1,1) PRIMARY KEY,
    empname VARCHAR(30)
);

INSERT INTO emp_identity VALUES ('A'), ('B'), ('C');

SELECT * FROM emp_identity;

/*
OUTPUT:
empid | empname
----------------
1     | A
2     | B
3     | C
*/


/*========================================================
  SEQUENCE EXAMPLE (QUICK)
========================================================*/

IF OBJECT_ID('EMP_SEQ', 'SO') IS NOT NULL
    DROP SEQUENCE EMP_SEQ;

CREATE SEQUENCE EMP_SEQ
AS INT
START WITH 1
INCREMENT BY 1
NO CACHE;

IF OBJECT_ID('emp_sequence') IS NOT NULL
    DROP TABLE emp_sequence;

CREATE TABLE emp_sequence
(
    empid INT PRIMARY KEY,
    empname VARCHAR(30)
);

INSERT INTO emp_sequence
VALUES (NEXT VALUE FOR EMP_SEQ, 'A'),
       (NEXT VALUE FOR EMP_SEQ, 'B'),
       (NEXT VALUE FOR EMP_SEQ, 'C');

SELECT * FROM emp_sequence;

/*
OUTPUT:
empid | empname
----------------
1     | A
2     | B
3     | C
*/


/*========================================================
  INTERVIEW ONE-LINERS
========================================================*/

/*
1) IDENTITY is automatic but inflexible
2) SEQUENCE is manual but powerful
3) Use IDENTITY for simple tables
4) Use SEQUENCE for business numbering
5) SEQUENCE works outside INSERT also
6) SEQUENCE supports CACHE and CYCLE
*/


/*========================================================
  END OF FILE
========================================================*/
