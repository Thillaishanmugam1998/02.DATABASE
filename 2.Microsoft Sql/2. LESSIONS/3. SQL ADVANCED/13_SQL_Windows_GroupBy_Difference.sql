/********************************************************************************************
 FILE NAME   : Aggregate_GroupBy_Window_With_Output.sql
 DATABASE    : Microsoft SQL Server
 TOPIC       : NORMAL AGGREGATE vs GROUP BY vs WINDOW AGGREGATE (WITH OUTPUT)
 LEVEL       : ZERO TO HERO

 PURPOSE:
 Understand the difference clearly by:
 - Using SAME DATA
 - SAME QUESTION
 - SHOWING OUTPUT TABLE FORMAT
********************************************************************************************/


/********************************************************************************************
 1. BASE DATA SETUP
********************************************************************************************/

DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees
(
    EmployeeID   INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    Department   VARCHAR(50),
    Salary       INT
);

INSERT INTO Employees VALUES
(1, 'Alice',   'IT',     60000),
(2, 'Bob',     'IT',     55000),
(3, 'Charlie', 'HR',     45000),
(4, 'David',   'HR',     40000),
(5, 'Eva',     'Sales',  70000),
(6, 'Frank',   'Sales',  65000),
(7, 'Grace',   'IT',     60000);

SELECT * FROM Employees;

/*
OUTPUT:
+------------+--------------+------------+--------+
| EmployeeID | EmployeeName | Department | Salary |
+------------+--------------+------------+--------+
| 1          | Alice        | IT         | 60000  |
| 2          | Bob          | IT         | 55000  |
| 3          | Charlie      | HR         | 45000  |
| 4          | David        | HR         | 40000  |
| 5          | Eva          | Sales      | 70000  |
| 6          | Frank        | Sales      | 65000  |
| 7          | Grace        | IT         | 60000  |
+------------+--------------+------------+--------+
*/


/********************************************************************************************
 2. NORMAL AGGREGATE FUNCTION
 QUESTION: What is the average salary of ALL employees?
********************************************************************************************/

SELECT
    AVG(Salary) AS CompanyAverageSalary
FROM Employees;

/*
OUTPUT:
+----------------------+
| CompanyAverageSalary |
+----------------------+
| 56428                |
+----------------------+

KEY POINT:
✔ Only ONE ROW
✔ No employee details
*/


/********************************************************************************************
 3. GROUP BY AGGREGATE
 QUESTION: What is the average salary PER DEPARTMENT?
********************************************************************************************/

SELECT
    Department,
    AVG(Salary) AS DepartmentAverageSalary
FROM Employees
GROUP BY Department;

/*
OUTPUT:
+------------+--------------------------+
| Department | DepartmentAverageSalary  |
+------------+--------------------------+
| HR         | 42500                    |
| IT         | 58333                    |
| Sales      | 67500                    |
+------------+--------------------------+

KEY POINT:
✔ One row per department
✔ Employee-level data is LOST
*/


/********************************************************************************************
 4. WINDOW AGGREGATE
 QUESTION: Show EACH employee with their department average salary
********************************************************************************************/

SELECT
    EmployeeName,
    Department,
    Salary,
    AVG(Salary) OVER (PARTITION BY Department) AS DepartmentAverageSalary
FROM Employees;

/*
OUTPUT:
+--------------+------------+--------+--------------------------+
| EmployeeName | Department | Salary | DepartmentAverageSalary  |
+--------------+------------+--------+--------------------------+
| Alice        | IT         | 60000  | 58333                    |
| Bob          | IT         | 55000  | 58333                    |
| Grace        | IT         | 60000  | 58333                    |
| Charlie      | HR         | 45000  | 42500                    |
| David        | HR         | 40000  | 42500                    |
| Eva          | Sales      | 70000  | 67500                    |
| Frank        | Sales      | 65000  | 67500                    |
+--------------+------------+--------+--------------------------+

KEY POINT:
✔ ALL rows are kept
✔ Aggregate value is repeated per row
✔ Best for analysis and comparison
*/


/********************************************************************************************
 5. SAME COMPARISON: TOTAL SALARY
********************************************************************************************/

-- NORMAL AGGREGATE
SELECT SUM(Salary) AS TotalCompanySalary FROM Employees;

/*
OUTPUT:
+---------------------+
| TotalCompanySalary  |
+---------------------+
| 395000              |
+---------------------+
*/

-- GROUP BY
SELECT Department, SUM(Salary) AS TotalSalaryPerDept
FROM Employees
GROUP BY Department;

/*
OUTPUT:
+------------+--------------------+
| Department | TotalSalaryPerDept |
+------------+--------------------+
| HR         | 85000              |
| IT         | 175000             |
| Sales      | 135000             |
+------------+--------------------+
*/

-- WINDOW AGGREGATE
SELECT
    EmployeeName,
    Department,
    Salary,
    SUM(Salary) OVER (PARTITION BY Department) AS TotalSalaryPerDept
FROM Employees;

/*
OUTPUT:
+--------------+------------+--------+--------------------+
| EmployeeName | Department | Salary | TotalSalaryPerDept |
+--------------+------------+--------+--------------------+
| Alice        | IT         | 60000  | 175000             |
| Bob          | IT         | 55000  | 175000             |
| Grace        | IT         | 60000  | 175000             |
| Charlie      | HR         | 45000  | 85000              |
| David        | HR         | 40000  | 85000              |
| Eva          | Sales      | 70000  | 135000             |
| Frank        | Sales      | 65000  | 135000             |
+--------------+------------+--------+--------------------+
*/


/********************************************************************************************
 6. SAME COMPARISON: COUNT
********************************************************************************************/

-- NORMAL AGGREGATE
SELECT COUNT(*) AS TotalEmployees FROM Employees;

/*
OUTPUT:
+----------------+
| TotalEmployees |
+----------------+
| 7              |
+----------------+
*/

-- GROUP BY
SELECT Department, COUNT(*) AS EmployeesPerDept
FROM Employees
GROUP BY Department;

/*
OUTPUT:
+------------+------------------+
| Department | EmployeesPerDept |
+------------+------------------+
| HR         | 2                |
| IT         | 3                |
| Sales      | 2                |
+------------+------------------+
*/

-- WINDOW AGGREGATE
SELECT
    EmployeeName,
    Department,
    COUNT(*) OVER (PARTITION BY Department) AS EmployeesInDept
FROM Employees;

/*
OUTPUT:
+--------------+------------+------------------+
| EmployeeName | Department | EmployeesInDept |
+--------------+------------+------------------+
| Alice        | IT         | 3                |
| Bob          | IT         | 3                |
| Grace        | IT         | 3                |
| Charlie      | HR         | 2                |
| David        | HR         | 2                |
| Eva          | Sales      | 2                |
| Frank        | Sales      | 2                |
+--------------+------------+------------------+
*/


/********************************************************************************************
 7. FINAL VISUAL SUMMARY

 NORMAL AGGREGATE
 ----------------
 ✔ One row
 ✔ Overall summary

 GROUP BY
 --------
 ✔ One row per group
 ✔ Summary per category

 WINDOW AGGREGATE
 ----------------
 ✔ Keeps all rows
 ✔ Adds analytics to each row

 GOLDEN RULE:
 GROUP BY REDUCES ROWS
 WINDOW FUNCTIONS DO NOT
********************************************************************************************/
