/***********************************************************************
SQL NOTES: COMPARISON OPERATORS IN SQL SERVER
Author: ChatGPT
Level: Beginner to Advanced
DB: SQL Server
Purpose:
  - Understand comparison operators
  - Learn usage with variables and table data
  - Practice real-time and interview-oriented examples
************************************************************************/

-- ===============================================================
-- 1) WHAT ARE COMPARISON OPERATORS?
-- ===============================================================
/*
Comparison operators are used to compare two values.
They always return TRUE or FALSE logically.
In SQL queries, they determine whether a row is included in the result set.

SQL Server Comparison Operators:

=    Equal to
<>   Not equal to
!=   Not equal to (same as <>)
>    Greater than
<    Less than
>=   Greater than or equal to
<=   Less than or equal to

Notes:
- Usually used in WHERE and HAVING clauses
- Can be used with numeric, string, date, and variable values
*/

-- ===============================================================
-- 2) CREATE SAMPLE TABLE
-- ===============================================================
DROP TABLE IF EXISTS Employees;
GO

CREATE TABLE Employees
(
    EmpId     INT,
    EmpName   NVARCHAR(50),
    Salary    INT,
    Dept      NVARCHAR(20)
);
GO

INSERT INTO Employees VALUES
(1, 'Arun',   25000, 'IT'),
(2, 'Bala',   18000, 'HR'),
(3, 'Charan', 30000, 'IT'),
(4, 'Deepak', 15000, 'Admin'),
(5, 'Ezhil',  22000, 'HR');
GO

-- View table
SELECT * FROM Employees;
GO

-- ===============================================================
-- 3) EQUAL TO OPERATOR (=)
-- ===============================================================
SELECT *
FROM Employees
WHERE Dept = 'IT';
GO
/*
 OUTPUT: Employees in IT department
*/

-- ===============================================================
-- 4) NOT EQUAL TO OPERATOR (<>)
-- ===============================================================
SELECT *
FROM Employees
WHERE Dept <> 'HR';
GO
/*
 OUTPUT: All employees except HR department
*/

-- ===============================================================
-- 5) NOT EQUAL TO OPERATOR (!=)
-- ===============================================================
SELECT *
FROM Employees
WHERE Salary != 25000;
GO
/*
 OUTPUT: All employees except Salary = 25000
*/

-- ===============================================================
-- 6) GREATER THAN OPERATOR (>)
-- ===============================================================
SELECT *
FROM Employees
WHERE Salary > 20000;
GO
/*
 Employees earning more than 20000
*/

-- ===============================================================
-- 7) LESS THAN OPERATOR (<)
-- ===============================================================
SELECT *
FROM Employees
WHERE Salary < 20000;
GO
/*
 Employees earning less than 20000
*/

-- ===============================================================
-- 8) GREATER THAN OR EQUAL TO (>=)
-- ===============================================================
SELECT *
FROM Employees
WHERE Salary >= 22000;
GO
/*
 Salary 22000 and above
*/

-- ===============================================================
-- 9) LESS THAN OR EQUAL TO (<=)
-- ===============================================================
SELECT *
FROM Employees
WHERE Salary <= 18000;
GO
/*
 Salary 18000 and below
*/

-- ===============================================================
-- 10) COMPARISON OPERATORS WITH VARIABLES
-- ===============================================================
DECLARE @MinSalary INT = 20000;

SELECT *
FROM Employees
WHERE Salary >= @MinSalary;
GO
/*
 Filters employees earning >= 20000 using variable
*/

-- ===============================================================
-- 11) REAL-TIME USE CASES
-- ===============================================================
/*
1) Salary filtering
2) Age eligibility checks
3) Date range comparisons (e.g., joining date, expiry)
4) Stock availability (quantity > 0)
5) Access control rules (role = 'Admin')
*/

-- ===============================================================
-- 12) COMPARISON OPERATORS WITH AGGREGATE (HAVING)
-- ===============================================================
SELECT Dept, COUNT(*) AS EmpCount
FROM Employees
GROUP BY Dept
HAVING COUNT(*) > 1;
GO
/*
 Filters departments with more than 1 employee
*/

-- ===============================================================
-- 13) INTERVIEW KEY QUESTIONS
-- ===============================================================
/*
Q1: Difference between <> and != ?
A1: No difference in SQL Server; both mean NOT EQUAL

Q2: Can comparison operators be used with WHERE?
A2: Yes, very commonly.

Q3: Can comparison operators be used with HAVING?
A3: Yes, usually with aggregate functions.
*/

-- ===============================================================
-- 14) IMPORTANT TIPS AND NOTES
-- ===============================================================
/*
1) Comparison operators return logical TRUE/FALSE.
2) Use in WHERE to filter rows.
3) Use in HAVING for aggregated results.
4) Works with variables, table columns, numbers, strings, and dates.
5) For strings, SQL Server comparison is case-insensitive by default.
6) Always test boundary conditions with >=, <= operators.
*/

-- ===============================================================
-- 15) KEY POINTS SUMMARY
-- ===============================================================
/*
=   : Equal to
<>  : Not equal to
!=  : Not equal to
>   : Greater than
<   : Less than
>=  : Greater than or equal to
<=  : Less than or equal to

- Mainly used in WHERE and HAVING
- Core for filtering and conditional logic in SQL
- Works with numeric, string, date, and variable comparisons
*/

-- ===============================================================
-- END OF FILE: COMPARISON OPERATORS
-- ===============================================================
