/***********************************************************************
SQL NOTES: SELECT, FROM, WHERE, ORDER BY, TOP, DISTINCT
Author: ChatGPT
Level: Beginner to Advanced
DB: SQL Server
Purpose:
  - Understand core SQL SELECT statement clauses
  - Learn filtering, sorting, limiting, and unique selection
  - Practice real-time and interview-oriented examples
************************************************************************/

/*========================================================
1) WHAT ARE SELECT, FROM, WHERE, ORDER BY, TOP, DISTINCT?
========================================================*/
/*
1) SELECT: Specifies the columns to retrieve from the table.
2) FROM  : Specifies the table(s) from which to retrieve data.
3) WHERE : Filters rows based on conditions.
4) ORDER BY : Sorts results in ascending (ASC) or descending (DESC) order.
5) TOP   : Limits the number of rows returned.
6) DISTINCT : Returns only unique values (removes duplicates).
*/

/*========================================================
2) WHY THESE CLAUSES ARE NEEDED?
========================================================*/
/*
Real-life use cases:
- SELECT + FROM: Get specific columns from a table.
- WHERE: Filter employees with salary > 20000.
- ORDER BY: Sort products by price descending.
- TOP: Show top 5 best-selling products.
- DISTINCT: List unique department names.
*/

/*========================================================
3) CREATE SAMPLE TABLE
========================================================*/
DROP TABLE IF EXISTS Employees;
GO

CREATE TABLE Employees
(
    EmpID INT,
    EmpName NVARCHAR(50),
    Dept NVARCHAR(20),
    Salary INT
);
GO

INSERT INTO Employees VALUES
(1, 'Arun', 'IT', 25000),
(2, 'Bala', 'HR', 18000),
(3, 'Charan', 'IT', 30000),
(4, 'Deepak', 'Admin', 15000),
(5, 'Ezhil', 'HR', 22000),
(6, 'Faisal', 'IT', 25000);
GO

/*========================================================
4) SELECT & FROM
========================================================*/
-- Retrieve all columns
SELECT * FROM Employees;
GO

-- Retrieve specific columns
SELECT EmpName, Dept, Salary
FROM Employees;
GO

/*========================================================
5) WHERE CLAUSE
========================================================*/
-- Filter employees with salary > 20000
SELECT EmpName, Dept, Salary
FROM Employees
WHERE Salary > 20000;
GO

-- Filter employees in IT department
SELECT EmpName, Salary
FROM Employees
WHERE Dept = 'IT';
GO

-- Filter with multiple conditions
SELECT EmpName, Dept, Salary
FROM Employees
WHERE Dept = 'IT' AND Salary >= 25000;
GO

-- Using OR
SELECT EmpName, Dept
FROM Employees
WHERE Dept = 'HR' OR Salary < 20000;
GO

/*========================================================
6) ORDER BY CLAUSE
========================================================*/
-- Sort by Salary ascending
SELECT EmpName, Dept, Salary
FROM Employees
ORDER BY Salary ASC;
GO

-- Sort by Salary descending
SELECT EmpName, Dept, Salary
FROM Employees
ORDER BY Salary DESC;
GO

-- Sort by multiple columns: Dept ascending, Salary descending
SELECT EmpName, Dept, Salary
FROM Employees
ORDER BY Dept ASC, Salary DESC;
GO

/*========================================================
7) TOP CLAUSE
========================================================*/
-- Retrieve top 3 highest paid employees
SELECT TOP 3 EmpName, Dept, Salary
FROM Employees
ORDER BY Salary DESC;
GO

-- Retrieve top 2 lowest paid employees
SELECT TOP 2 EmpName, Dept, Salary
FROM Employees
ORDER BY Salary ASC;
GO

/*========================================================
8) DISTINCT CLAUSE
========================================================*/
-- List unique departments
SELECT DISTINCT Dept
FROM Employees;
GO

-- Combine DISTINCT with ORDER BY
SELECT DISTINCT Dept
FROM Employees
ORDER BY Dept ASC;
GO

/*========================================================
9) COMBINED EXAMPLES
========================================================*/
-- Top 2 highest paid employees in IT
SELECT TOP 2 EmpName, Salary
FROM Employees
WHERE Dept = 'IT'
ORDER BY Salary DESC;
GO

-- List unique departments with salary > 20000
SELECT DISTINCT Dept
FROM Employees
WHERE Salary > 20000
ORDER BY Dept ASC;
GO

/*========================================================
10) IMPORTANT TIPS AND NOTES
========================================================*/
/*
1) SELECT * retrieves all columns; use specific columns for efficiency.
2) WHERE clause filters rows; always comes after FROM.
3) ORDER BY sorts results; default is ASC.
4) TOP limits rows; use ORDER BY to control which rows are returned.
5) DISTINCT removes duplicates; applies to all selected columns.
6) Multiple clauses can be combined in one query:
   SELECT ... FROM ... WHERE ... ORDER BY ...
7) WHERE cannot filter aggregated results directly (use HAVING for that).
8) SQL keywords are case-insensitive, but table/column names depend on DB settings.
*/

/*========================================================
11) SUMMARY
========================================================*/
/*
SELECT   : Columns to retrieve
FROM     : Table(s) to retrieve data from
WHERE    : Filter rows with conditions
ORDER BY : Sort rows ASC or DESC
TOP      : Limit number of rows returned
DISTINCT : Remove duplicate rows
*/

--=========================================================
-- END OF FILE: SELECT, FROM, WHERE, ORDER BY, TOP, DISTINCT
--=========================================================
