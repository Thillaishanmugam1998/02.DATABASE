/***********************************************************************
SQL NOTES: DDL QUERIES (Data Definition Language)
Author: ChatGPT
Level: Beginner to Advanced
DB: SQL Server
Purpose:
  - Understand DDL commands for managing database objects
  - Learn to create, alter, drop, truncate, and rename tables
  - Practice real-time and interview-oriented examples
************************************************************************/

/*========================================================
1) WHAT IS DDL?
========================================================*/
/*
DDL (Data Definition Language) is a subset of SQL commands
used to define and manage database objects such as tables, 
views, indexes, schemas, etc.

Key DDL Commands:
1) CREATE  : Create new database objects
2) ALTER   : Modify existing database objects
3) DROP    : Delete database objects permanently
4) TRUNCATE: Delete all rows from a table (faster than DELETE)
5) RENAME  : Rename an existing database object
*/

/*========================================================
2) WHY DDL IS NEEDED?
========================================================*/
/*
Real-life use cases:
- CREATE: Define new tables for employee, product, or sales data
- ALTER: Add a new column to store additional information
- DROP: Remove obsolete tables to save storage
- TRUNCATE: Clear all data from a table without removing its structure
- RENAME: Rename tables or columns for better naming conventions
*/

/*========================================================
3) CREATE TABLE
========================================================*/
-- Syntax:
-- CREATE TABLE TableName
-- (
--    Column1 DataType [Constraints],
--    Column2 DataType [Constraints],
--    ...
-- );

-- Example: Create Employee table
DROP TABLE IF EXISTS Employee;
GO

CREATE TABLE Employee
(
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(50) NOT NULL,
    Dept NVARCHAR(20),
    Salary INT CHECK (Salary >= 0)
);
GO

-- Check table structure
SELECT * FROM Employee;
GO
/*
 OUTPUT:
 Employee table created with columns EmpID, EmpName, Dept, Salary
*/

/*========================================================
4) INSERT SAMPLE DATA
========================================================*/
INSERT INTO Employee VALUES
(1, 'Arun', 'IT', 25000),
(2, 'Bala', 'HR', 18000),
(3, 'Charan', 'IT', 30000);
GO

SELECT * FROM Employee;
GO

/*========================================================
5) ALTER TABLE
========================================================*/
-- Syntax:
-- ALTER TABLE TableName
-- ADD|MODIFY|DROP ColumnName DataType;

-- Example 1: Add a new column "JoiningDate"
ALTER TABLE Employee
ADD JoiningDate DATE;
GO

-- Update sample dates
UPDATE Employee
SET JoiningDate = '2023-01-01'
WHERE EmpID = 1;

UPDATE Employee
SET JoiningDate = '2023-02-15'
WHERE EmpID = 2;

UPDATE Employee
SET JoiningDate = '2023-03-10'
WHERE EmpID = 3;

SELECT * FROM Employee;
GO

-- Example 2: Modify column (SQL Server uses ALTER COLUMN)
ALTER TABLE Employee
ALTER COLUMN Dept NVARCHAR(30);
GO

-- Example 3: Drop a column
ALTER TABLE Employee
DROP COLUMN JoiningDate;
GO

SELECT * FROM Employee;
GO

/*========================================================
6) DROP TABLE
========================================================*/
-- Syntax:
-- DROP TABLE TableName;

-- Example: Drop Employee table
-- DROP TABLE Employee;
-- GO
-- Use carefully; table and data are permanently deleted

/*========================================================
7) TRUNCATE TABLE
========================================================*/
-- Syntax:
-- TRUNCATE TABLE TableName;

-- Example: Clear all rows without deleting table structure
TRUNCATE TABLE Employee;
GO

SELECT * FROM Employee; -- Table exists, but no rows
GO

/*========================================================
8) RENAME TABLE OR COLUMN
========================================================*/
-- SQL Server uses sp_rename
-- Syntax:
-- EXEC sp_rename 'OldName', 'NewName', 'OBJECT' | 'COLUMN';

-- Example 1: Rename table
-- EXEC sp_rename 'Employee', 'EmployeeDetails';
-- GO

-- Example 2: Rename column
-- EXEC sp_rename 'EmployeeDetails.Salary', 'BasicSalary', 'COLUMN';
-- GO

/*========================================================
9) IMPORTANT TIPS AND NOTES
========================================================*/
/*
1) DDL commands affect the structure of database objects, not data (except TRUNCATE).
2) DROP permanently deletes the table and all data.
3) TRUNCATE is faster than DELETE but cannot have a WHERE clause.
4) ALTER TABLE is used to add, modify, or drop columns.
5) RENAME is optional but helps maintain meaningful table and column names.
6) Always take backups before running DROP or TRUNCATE in production.
*/

/*========================================================
10) SUMMARY
========================================================*/
/*
DDL COMMANDS:
- CREATE  : Define new table, view, index, etc.
- ALTER   : Modify structure (add, drop, change column)
- DROP    : Remove table, view, or index permanently
- TRUNCATE: Remove all rows quickly, table structure remains
- RENAME  : Change name of table or column
Rules:
- DDL changes structure, not content (except TRUNCATE)
- Use constraints (PRIMARY KEY, NOT NULL, CHECK) for data integrity
- Always confirm before DROP or TRUNCATE
*/

--=========================================================
-- END OF FILE: DDL QUERIES
--=========================================================
