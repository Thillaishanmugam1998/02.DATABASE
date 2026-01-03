/*==============================================================
  FILE  : 08_sequence_practice_clean.sql
  TOPIC : SQL Server SEQUENCE
  PURPOSE:
    - Understand SEQUENCE in SQL Server
    - Compare SEQUENCE vs IDENTITY
    - Real-time use cases
    - Create and use SEQUENCE
    - Generate numbers manually and during INSERT
==============================================================*/

/*==============================================================
  1) WHAT IS SEQUENCE?
--------------------------------------------------------------
- SEQUENCE is a **database object** that generates sequential numbers.
- Unlike IDENTITY, SEQUENCE is **independent of any table**.
- You can get numbers **before inserting into a table**, and use the same sequence in **multiple tables**.
- Think of it like a “number machine” that gives the next number whenever you ask for it.
==============================================================*/

/*==============================================================
  2) IDENTITY vs SEQUENCE (FOR BEGINNERS)
--------------------------------------------------------------
FEATURE                     | IDENTITY           | SEQUENCE
----------------------------|--------------------|------------------------
Object Type                 | Column property    | Database object
Table Dependency            | Depends on table   | Independent object
Value Generation            | On INSERT only     | On demand (NEXT VALUE FOR)
Multiple Table Usage        | ❌ Not possible    | ✅ Possible
Manual Control              | ❌ Limited         | ✅ Full control
Insert Explicit Value       | ❌ Default only    | ✅ Always allowed
Reset Value                 | DBCC / TRUNCATE     | ALTER SEQUENCE
Delete Impact               | Gaps remain         | Gaps remain
Cycle Support               | ❌ No              | ✅ Yes
Cache Support               | ❌ No              | ✅ Yes
Generate Before Insert      | ❌ No				 |✅ Yes
Performance                 | Good               | Better (with CACHE)
Use Case                    | Simple PK          | Complex numbering
==============================================================*/

/*==============================================================
  3) REAL-TIME SCENARIOS / CHOOSING BETWEEN IDENTITY AND SEQUENCE
==============================================================*/

/*
CASE 1: SIMPLE EMPLOYEE TABLE
- Only one table
- Auto-increment primary key
- Gaps are okay
→ Use IDENTITY
*/

/*
CASE 2: MULTIPLE TABLES NEED SAME NUMBER SERIES
- sales_order, purchase_order, return_order
- Same running number across tables
- Number needed before INSERT
→ Use SEQUENCE
*/

/*
CASE 3: BUSINESS DOCUMENT NUMBER
- Invoice numbers restarting every year
- Number can be reused in multiple tables
- Controlled reset
→ Use SEQUENCE
*/

/*==============================================================
  4) QUICK IDENTITY EXAMPLE
==============================================================*/

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

/*
NOTE:
- empid is generated automatically
- Cannot control value before insert
- Simple and fast for one-table use
*/

/*==============================================================
  5) CREATE AND USE SEQUENCE
==============================================================*/

-- Step 1: Drop sequence if exists
IF OBJECT_ID('EMP_SEQ', 'SO') IS NOT NULL
    DROP SEQUENCE EMP_SEQ;

-- Step 2: Create sequence
CREATE SEQUENCE EMP_SEQ
AS INT
START WITH 1
INCREMENT BY 1
NO CACHE; -- cache improves speed but can skip numbers

-- Step 3: Create table
IF OBJECT_ID('emp_sequence') IS NOT NULL
    DROP TABLE emp_sequence;

CREATE TABLE emp_sequence
(
    empid INT PRIMARY KEY,
    empname VARCHAR(30)
);

-- Step 4: Use NEXT VALUE FOR to insert numbers
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

/*
NOTE:
- You can get the next number BEFORE inserting
- Same sequence can be used in other tables
- You can insert explicit numbers if needed
*/

/*==============================================================
  6) MANUAL NEXT VALUE FOR (BEFORE INSERT)
==============================================================*/

-- Get next number without inserting into table
SELECT NEXT VALUE FOR EMP_SEQ AS NextNumber;

/*
OUTPUT:
NextNumber
-----------
4

NOTE:
- Useful for business documents, invoice numbers
- Gives number before inserting row
*/

/*==============================================================
  7) RESET OR ALTER SEQUENCE
==============================================================*/

-- Change the next number manually
ALTER SEQUENCE EMP_SEQ RESTART WITH 100;

SELECT NEXT VALUE FOR EMP_SEQ AS NextNumberAfterReset;

/*
OUTPUT:
NextNumberAfterReset
--------------------
100
*/

/*==============================================================
  8) CYCLE AND CACHE (ADVANCED)
==============================================================*/

-- Cycle: Sequence restarts automatically when maximum reached
-- Cache: Preload numbers in memory for performance

CREATE SEQUENCE SEQ_TEST
AS INT
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 5
CYCLE -- Restarts after 5
CACHE 2; -- Preload 2 numbers

-- Next 7 calls:
SELECT NEXT VALUE FOR SEQ_TEST AS N; -- 1,2,3,4,5,1,2

/*==============================================================
  9) INTERVIEW ONE-LINERS
==============================================================*/

/*
1) IDENTITY = automatic, simple, table-specific
2) SEQUENCE = manual, flexible, reusable across tables
3) Use IDENTITY for one-table auto increment
4) Use SEQUENCE for shared numbering or business documents
5) SEQUENCE supports CYCLE and CACHE
6) NEXT VALUE FOR generates number on demand
7) SEQUENCE can be reset anytime with ALTER SEQUENCE
*/

/*==============================================================
  10) END OF FILE
==============================================================*/
