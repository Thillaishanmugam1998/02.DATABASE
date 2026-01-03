/***********************************************************************
SQL NOTES: DML QUERIES (Data Manipulation Language)
Author: ChatGPT
Level: Beginner to Advanced
DB: SQL Server
Purpose:
  - Understand DML commands for manipulating table data
  - Learn how to insert, update, delete, and merge records
  - Practice real-time and interview-oriented examples
************************************************************************/

/*========================================================
1) WHAT IS DML?
========================================================*/
/*
DML (Data Manipulation Language) is a subset of SQL commands
used to manage data stored in database tables.

Key DML Commands:
1) INSERT : Add new records to a table
2) UPDATE : Modify existing records
3) DELETE : Remove records
4) MERGE  : Insert or update data conditionally
*/

/*========================================================
2) WHY DML IS NEEDED?
========================================================*/
/*
Real-life use cases:
- INSERT: Add new employees, products, or transactions
- UPDATE: Correct salary, address, or product price
- DELETE: Remove outdated or incorrect records
- MERGE: Sync data between staging and production tables
*/

/*========================================================
3) CREATE SAMPLE TABLE
========================================================*/
DROP TABLE IF EXISTS Employee;
GO

CREATE TABLE Employee
(
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(50) NOT NULL,
    Dept NVARCHAR(20),
    Salary INT
);
GO

/*========================================================
4) INSERT COMMAND
========================================================*/
-- Syntax:
-- INSERT INTO TableName (Column1, Column2, ...)
-- VALUES (Value1, Value2, ...);

-- Example 1: Insert single row
INSERT INTO Employee (EmpID, EmpName, Dept, Salary)
VALUES (1, 'Arun', 'IT', 25000);
GO

-- Example 2: Insert multiple rows
INSERT INTO Employee (EmpID, EmpName, Dept, Salary)
VALUES 
(2, 'Bala', 'HR', 18000),
(3, 'Charan', 'IT', 30000),
(4, 'Deepak', 'Admin', 15000);
GO

-- View data
SELECT * FROM Employee;
GO

/*========================================================
5) UPDATE COMMAND
========================================================*/
-- Syntax:
-- UPDATE TableName
-- SET Column1 = Value1, Column2 = Value2, ...
-- WHERE condition;

-- Example 1: Update salary of EmpID = 2
UPDATE Employee
SET Salary = 20000
WHERE EmpID = 2;
GO

-- Example 2: Give 10% raise to all IT employees
UPDATE Employee
SET Salary = Salary * 1.10
WHERE Dept = 'IT';
GO

-- Check updated table
SELECT * FROM Employee;
GO

/*========================================================
6) DELETE COMMAND
========================================================*/
-- Syntax:
-- DELETE FROM TableName
-- WHERE condition;

-- Example 1: Delete employee with EmpID = 4
DELETE FROM Employee
WHERE EmpID = 4;
GO

-- Example 2: Delete all HR employees
DELETE FROM Employee
WHERE Dept = 'HR';
GO

-- View remaining data
SELECT * FROM Employee;
GO

/*========================================================
7) MERGE COMMAND (UPSERT)
========================================================*/
/*
MERGE allows conditional insert or update
based on whether a matching record exists.
*/

-- Create staging table
DROP TABLE IF EXISTS StagingEmployee;
GO

CREATE TABLE StagingEmployee
(
    EmpID INT,
    EmpName NVARCHAR(50),
    Dept NVARCHAR(20),
    Salary INT
);
GO

-- Insert data into staging
INSERT INTO StagingEmployee VALUES
(1, 'Arun', 'IT', 27000),   -- Existing employee, updated salary
(5, 'Ezhil', 'HR', 22000);  -- New employee
GO

-- Merge staging into Employee
MERGE Employee AS Target
USING StagingEmployee AS Source
ON Target.EmpID = Source.EmpID
WHEN MATCHED THEN 
    UPDATE SET Target.Salary = Source.Salary
WHEN NOT MATCHED THEN
    INSERT (EmpID, EmpName, Dept, Salary)
    VALUES (Source.EmpID, Source.EmpName, Source.Dept, Source.Salary);
GO

-- Check final Employee table
SELECT * FROM Employee;
GO

/*========================================================
8) IMPORTANT TIPS AND NOTES
========================================================*/
/*
1) Always use WHERE clause with UPDATE and DELETE to avoid affecting all rows.
2) INSERT INTO ... VALUES adds rows; you can insert multiple rows at once.
3) MERGE is useful for syncing tables or performing UPSERT operations.
4) Transactions can be used to ensure DML operations are safe:
   BEGIN TRANSACTION ... COMMIT/ROLLBACK
5) DML changes data but does NOT change table structure (that's DDL).
*/

/*========================================================
9) SUMMARY
========================================================*/
/*
DML COMMANDS:
- INSERT  : Add new records
- UPDATE  : Modify existing records
- DELETE  : Remove records
- MERGE   : Insert or update conditionally

Rules:
- Always use WHERE to prevent unintentional updates/deletes
- Check data after operations using SELECT
- Combine with transactions for safety
*/

--=========================================================
-- END OF FILE: DML QUERIES
--=========================================================
