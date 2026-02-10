/***********************************************************************
SQL NOTES: JOINS
Author: ChatGPT
Level: Beginner to Advanced
DB: SQL Server
Purpose:
  - Understand different types of SQL joins
  - Learn how to combine data from multiple tables
  - Practice real-time and interview-oriented examples
************************************************************************/

/*========================================================
1) WHAT IS A JOIN?
========================================================*/
/*
A JOIN in SQL is used to combine rows from two or more tables
based on a related column between them.

Why it's important:
- Data is often stored in multiple tables for normalization.
- JOINs help retrieve meaningful combined data for reports, dashboards, etc.
*/

/*========================================================
2) WHY JOINS ARE NEEDED?
========================================================*/
/*
Real-life use cases:
- Employee table + Department table: Get employee names with department names
- Orders table + Customers table: Get order details along with customer info
- Sales + Products: Calculate revenue per product
*/

/*========================================================
3) CREATE SAMPLE TABLES
========================================================*/
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;
GO

CREATE TABLE Department
(
    DeptID INT PRIMARY KEY,
    DeptName NVARCHAR(50)
);
GO

CREATE TABLE Employee
(
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(50),
    DeptID INT,
    Salary INT
);
GO

-- Insert sample data
INSERT INTO Department VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Admin');
GO

INSERT INTO Employee VALUES
(101, 'Arun', 1, 25000),
(102, 'Bala', 2, 18000),
(103, 'Charan', 1, 30000),
(104, 'Deepak', 3, 15000),
(105, 'Ezhil', NULL, 22000); -- Employee without department
GO

/*========================================================
4) INNER JOIN
========================================================*/
/*
Returns rows that have matching values in both tables
Syntax:
SELECT columns
FROM Table1
INNER JOIN Table2
ON Table1.Column = Table2.Column;
*/

SELECT E.EmpID, E.EmpName, D.DeptName, E.Salary
FROM Employee E
INNER JOIN Department D
ON E.DeptID = D.DeptID;
GO

/*
OUTPUT:
EmpID | EmpName | DeptName | Salary
-----------------------------------
101   | Arun    | IT       | 25000
102   | Bala    | HR       | 18000
103   | Charan  | IT       | 30000
104   | Deepak  | Admin    | 15000
*/

/*========================================================
5) LEFT JOIN (LEFT OUTER JOIN)
========================================================*/
/*
Returns all rows from left table + matched rows from right table
Unmatched right table columns are NULL
*/

SELECT E.EmpID, E.EmpName, D.DeptName, E.Salary
FROM Employee E
LEFT JOIN Department D
ON E.DeptID = D.DeptID;
GO

/*
OUTPUT: includes Ezhil with NULL DeptName
*/

/*========================================================
6) RIGHT JOIN (RIGHT OUTER JOIN)
========================================================*/
/*
Returns all rows from right table + matched rows from left table
Unmatched left table columns are NULL
*/

SELECT E.EmpID, E.EmpName, D.DeptName, E.Salary
FROM Employee E
RIGHT JOIN Department D
ON E.DeptID = D.DeptID;
GO

/*
OUTPUT: All departments shown, including any dept without employees (if existed)
*/

/*========================================================
7) FULL OUTER JOIN
========================================================*/
/*
Returns all rows from both tables. Non-matching rows get NULLs
*/

SELECT *
FROM Employee E
FULL OUTER JOIN Department D
ON E.DeptID = D.DeptID;
GO

/*
OUTPUT: Includes all employees + all departments
Ezhil will have NULL DeptName
Any dept with no employees will have NULL EmpID/EmpName
*/

/*========================================================
8) CROSS JOIN
========================================================*/
/*
Returns Cartesian product of both tables
Every row from left table joins with every row from right table
*/

SELECT E.EmpName, D.DeptName
FROM Employee E
CROSS JOIN Department D;
GO

/*
OUTPUT: Total rows = Employee count * Department count
*/

/*========================================================
9) SELF JOIN
========================================================*/
/*
Join a table with itself
Useful for hierarchical data like managers and subordinates
*/

-- Add ManagerID column for demo
ALTER TABLE Employee
ADD ManagerID INT NULL;
GO

-- Sample hierarchy
UPDATE Employee SET ManagerID = 101 WHERE EmpID IN (102,103);
UPDATE Employee SET ManagerID = 104 WHERE EmpID = 105;
GO

-- Self join example: Employee with Manager Name
SELECT E.EmpName AS Employee, M.EmpName AS Manager
FROM Employee E
LEFT JOIN Employee M
ON E.ManagerID = M.EmpID;
GO

/*
OUTPUT:
Employee | Manager
-----------------
Arun     | NULL
Bala     | Arun
Charan   | Arun
Deepak   | NULL
Ezhil    | Deepak
*/

/*========================================================
10) IMPORTANT TIPS AND NOTES
========================================================*/
/*
1) Always specify join condition using ON to avoid Cartesian products (except CROSS JOIN).
2) Use table aliases (E, D, etc.) for readability.
3) INNER JOIN returns only matched rows.
4) LEFT/RIGHT OUTER JOIN returns unmatched rows as NULLs.
5) FULL OUTER JOIN combines all rows with NULLs for unmatched data.
6) SELF JOIN is useful for hierarchy or comparing rows in same table.
7) CROSS JOIN can generate huge results; use cautiously.
8) Filter using WHERE or HAVING after JOIN for performance.
*/

/*========================================================
11) SUMMARY
========================================================*/
/*
- INNER JOIN: Only matching rows
- LEFT JOIN: All left rows + matched right rows
- RIGHT JOIN: All right rows + matched left rows
- FULL OUTER JOIN: All rows from both tables
- CROSS JOIN: Cartesian product
- SELF JOIN: Join table with itself
- Always use ON clause to define relationship
- Aliases improve readability
*/

--=========================================================
-- END OF FILE: JOINS
--=========================================================
