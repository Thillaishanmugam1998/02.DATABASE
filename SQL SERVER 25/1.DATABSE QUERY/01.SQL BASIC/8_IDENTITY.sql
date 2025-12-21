/*========================================================
  FILE  : 07_identity_practice.sql
  TOPIC : SQL Server IDENTITY
  PURPOSE:
    - Understand IDENTITY
    - Auto increment behavior
    - Manual insert using IDENTITY_INSERT
    - Delete vs Truncate
    - Reset (RESEED)
    - Check identity values
========================================================*/


/*========================================================
  WHAT IS IDENTITY?
  --------------------------------------------------------
  IDENTITY is used to auto-generate sequential numeric
  values for a column.
========================================================*/

/*
  SYNTAX:
  IDENTITY(seed, increment)

  seed      -> starting value
  increment -> step value

  Default: IDENTITY(1,1)
*/


/*========================================================
  CREATE TABLE WITH IDENTITY
========================================================*/

IF OBJECT_ID('employee') IS NOT NULL
    DROP TABLE employee;

CREATE TABLE employee
(
    empid   INT IDENTITY(1,1) PRIMARY KEY,
    empname VARCHAR(30)
);

--NOTE: IF ALREADY EXIST COLOUMN WAS NOT AN IDENTITY NOW WE WANT TO ADD IDENTITY 
--THEN DROP THAT COLOUMN THEN ONLY ADD NEW COLOUMN WITH IDENTITY.

/*========================================================
  INSERT DATA (AUTO GENERATED ID)
========================================================*/

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


/*========================================================
  MANUAL INSERT INTO IDENTITY (ERROR)
========================================================*/

-- ERROR: Cannot insert explicit value for identity column
--INSERT INTO employee VALUES (5,'Dharshini');

--INSERT INTO employee(empid, empname)
--VALUES (5,'Dharshini');


/*========================================================
  DELETE RECORD AND CHECK IDENTITY GAP
========================================================*/

DELETE FROM employee WHERE empname = 'Senthil';

SELECT * FROM employee;

/*
OUTPUT:
empid | empname
-----------------
1     | Thillai
3     | Shanmugam
4     | Tamil
*/


/*========================================================
  INSERT AFTER DELETE (IDENTITY NOT REUSED)
========================================================*/

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
*/


/*========================================================
  ENABLE MANUAL IDENTITY INSERT
========================================================*/

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


/*========================================================
  DUPLICATE IDENTITY VALUE (PRIMARY KEY ERROR)
========================================================*/

-- ERROR: Violation of PRIMARY KEY constraint
--INSERT INTO employee (empid, empname)
--VALUES (2,'Duplicate');

SET IDENTITY_INSERT employee OFF;


/*========================================================
  DELETE VS IDENTITY RESET
========================================================*/

DELETE FROM employee;

INSERT INTO employee VALUES ('ABI');

SELECT * FROM employee;

/*
OUTPUT:
empid | empname
-----------------
6     | ABI
NOTE:
DELETE does NOT reset IDENTITY
*/


/*========================================================
  RESET IDENTITY USING DBCC CHECKIDENT
========================================================*/

DBCC CHECKIDENT (employee, RESEED, 0);

INSERT INTO employee VALUES ('DHARSHI');

SELECT * FROM employee;

/*
OUTPUT:
empid | empname
-----------------
1     | DHARSHI
*/


/*========================================================
  TRUNCATE TABLE (BEST WAY TO RESET IDENTITY)
========================================================*/

TRUNCATE TABLE employee;

INSERT INTO employee VALUES ('ARUN');

SELECT * FROM employee;

/*
OUTPUT:
empid | empname
-----------------
1     | ARUN
*/


/*========================================================
  CHECK IDENTITY VALUES
========================================================*/

-- Last identity value in current scope (SAME TABLE, SAME PROCEDURE..) (SAFE)
SELECT SCOPE_IDENTITY() AS ScopeIdentity;

-- Last identity value in current session (NOT SAFE)
SELECT @@IDENTITY AS SessionIdentity;

-- Current identity value of table
-- DANGEOURS WHEN TWO PEPOPLE ARE INSERT ON SAME TIME
SELECT IDENT_CURRENT('employee') AS CurrentIdentity;


/*========================================================
  INTERVIEW NOTES
  --------------------------------------------------------
  1) IDENTITY values are not reused
  2) DELETE does NOT reset identity
  3) TRUNCATE resets identity
  4) SCOPE_IDENTITY() is recommended
  5) IDENTITY_INSERT can be ON for only one table
========================================================*/
