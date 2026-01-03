/*==============================================================
  FILE  : 07_identity_practice_clean.sql
  TOPIC : SQL SERVER IDENTITY
  PURPOSE:
    - Understand IDENTITY
    - Auto increment behavior
    - Manual insert using IDENTITY_INSERT
    - Delete vs Truncate
    - Reset (RESEED)
    - Check identity values
==============================================================*/

/*==============================================================
  1) WHAT IS IDENTITY?
--------------------------------------------------------------
- IDENTITY is a property of a column in SQL Server.
- It automatically generates sequential numbers for new rows.
- Think of it like a counter that increases automatically every time you add a row.
- Example: EmpID 1, 2, 3, 4 …
==============================================================*/

/*==============================================================
  2) SYNTAX
--------------------------------------------------------------
IDENTITY(seed, increment)
- seed      → starting value (default 1)
- increment → step value (default 1)
- Example: IDENTITY(1,1) → starts at 1 and increases by 1 each row
==============================================================*/

/*==============================================================
  3) CREATE TABLE WITH IDENTITY
==============================================================*/

IF OBJECT_ID('employee') IS NOT NULL
    DROP TABLE employee;

CREATE TABLE employee
(
    empid   INT IDENTITY(1,1) PRIMARY KEY, -- Auto-increment ID
    empname VARCHAR(30)
);

/*
NOTE:
- If a column already exists without IDENTITY, you cannot just "add" IDENTITY.
- You must create a new column with IDENTITY or recreate the table.
*/

/*==============================================================
  4) INSERT DATA (AUTO-GENERATED ID)
==============================================================*/

INSERT INTO employee VALUES
('Thillai'),
('Senthil'),
('Shanmugam'),
('Tamil');

SELECT * FROM employee;

/*
OUTPUT:
empid | empname
-----------------
1     | Thillai
2     | Senthil
3     | Shanmugam
4     | Tamil
*/

/*==============================================================
  5) MANUAL INSERT INTO IDENTITY (ERROR)
==============================================================*/

-- ERROR: Cannot insert explicit value without enabling IDENTITY_INSERT
--INSERT INTO employee VALUES (5,'Dharshini');

--INSERT INTO employee(empid, empname)
--VALUES (5,'Dharshini');

/*==============================================================
  6) DELETE RECORD AND CHECK IDENTITY GAP
==============================================================*/

DELETE FROM employee WHERE empname = 'Senthil';

SELECT * FROM employee;

/*
OUTPUT:
empid | empname
-----------------
1     | Thillai
3     | Shanmugam
4     | Tamil

NOTE: The deleted empid (2) is NOT reused automatically.
*/

/*==============================================================
  7) INSERT AFTER DELETE (IDENTITY NOT REUSED)
==============================================================*/

INSERT INTO employee VALUES ('Dharshini');

SELECT * FROM employee;

/*
OUTPUT:
empid | empname
-----------------
1     | Thillai
3     | Shanmugam
4     | Tamil
5     | Dharshini

NOTE: IDENTITY continues from the last value (4 → 5)
*/

/*==============================================================
  8) ENABLE MANUAL IDENTITY INSERT
==============================================================*/

SET IDENTITY_INSERT employee ON;

INSERT INTO employee (empid, empname)
VALUES (2,'Senthil');

SELECT * FROM employee;

/*
OUTPUT:
empid | empname
-----------------
1     | Thillai
2     | Senthil
3     | Shanmugam
4     | Tamil
5     | Dharshini
*/

/*==============================================================
  9) DUPLICATE IDENTITY VALUE (PRIMARY KEY ERROR)
==============================================================*/

-- ERROR: Cannot insert duplicate primary key
--INSERT INTO employee (empid, empname)
--VALUES (2,'Duplicate');

SET IDENTITY_INSERT employee OFF;

/*==============================================================
 10) DELETE VS IDENTITY RESET
==============================================================*/

DELETE FROM employee;

INSERT INTO employee VALUES ('ABI');

SELECT * FROM employee;

/*
OUTPUT:
empid | empname
-----------------
6     | ABI

NOTE:
- DELETE removes rows but DOES NOT reset the IDENTITY counter.
- Next inserted ID continues from last number.
*/

/*==============================================================
 11) RESET IDENTITY USING DBCC CHECKIDENT
==============================================================*/

DBCC CHECKIDENT (employee, RESEED, 0); -- Reset identity to 0

INSERT INTO employee VALUES ('DHARSHI');

SELECT * FROM employee;

/*
OUTPUT:
empid | empname
-----------------
1     | DHARSHI

NOTE: Now IDENTITY starts again from 1
*/

/*==============================================================
 12) TRUNCATE TABLE (BEST WAY TO RESET IDENTITY)
==============================================================*/

TRUNCATE TABLE employee; -- Removes all rows and resets identity

INSERT INTO employee VALUES ('ARUN');

SELECT * FROM employee;

/*
OUTPUT:
empid | empname
-----------------
1     | ARUN

NOTE:
- TRUNCATE is faster than DELETE and also resets IDENTITY.
*/

/*==============================================================
 13) CHECK IDENTITY VALUES
==============================================================*/

-- Last identity value generated in current scope
SELECT SCOPE_IDENTITY() AS ScopeIdentity;

-- Last identity value generated in current session (all tables)
SELECT @@IDENTITY AS SessionIdentity;

-- Current identity value of a table
SELECT IDENT_CURRENT('employee') AS CurrentIdentity;

/*
NOTE:
- SCOPE_IDENTITY() → safe for single table/process
- @@IDENTITY → may include triggers/other tables
- IDENT_CURRENT → table-specific but not safe in multi-user insert
*/

/*==============================================================
 14) INTERVIEW NOTES / KEY POINTS
--------------------------------------------------------------
1) IDENTITY automatically generates sequential numbers.
2) Deleted IDENTITY values are NOT reused.
3) DELETE does NOT reset IDENTITY; TRUNCATE does.
4) You can insert manual values only when IDENTITY_INSERT is ON.
5) SCOPE_IDENTITY() is safest to get last inserted value.
6) Only one table can have IDENTITY_INSERT ON at a time.
==============================================================*/
