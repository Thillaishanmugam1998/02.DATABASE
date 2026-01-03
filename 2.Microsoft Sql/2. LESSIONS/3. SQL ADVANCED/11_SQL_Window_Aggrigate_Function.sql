/********************************************************************************************
 FILE NAME   : WindowFunctions.sql
 DATABASE    : Microsoft SQL Server
 TOPIC       : WINDOW FUNCTIONS (BASICS TO ADVANCED)
 LEVEL       : ZERO TO HERO (BEGINNER FRIENDLY)

 DESCRIPTION :
 Window Functions perform calculations across a set of rows
 related to the current row WITHOUT collapsing rows.

 IMPORTANT:
 - Rows are NOT grouped into one row
 - Each row keeps its identity
********************************************************************************************/


/********************************************************************************************
 1. WHAT ARE WINDOW FUNCTIONS? (BASICS)

 SIMPLE EXPLANATION:
 A window function calculates a value for each row
 by looking at other related rows (called a "window").

 DIFFERENCE:
 - GROUP BY → reduces rows
 - WINDOW FUNCTION → keeps rows
********************************************************************************************/


/********************************************************************************************
 2. WHY WINDOW FUNCTIONS ARE NEEDED?

 REAL-LIFE USE CASES:
 - Running totals
 - Ranking employees
 - Comparing salary with department average
 - Finding previous or next row values
********************************************************************************************/


/********************************************************************************************
 3. BASIC WINDOW FUNCTION SYNTAX

 FUNCTION_NAME (expression)
 OVER (
       PARTITION BY column
       ORDER BY column
       ROWS / RANGE
     )

 PARTITION BY → divides data into groups
 ORDER BY     → defines row order inside the group
********************************************************************************************/


/********************************************************************************************
 4. QUERY EXECUTION ORDER (IMPORTANT)

 1. FROM
 2. JOIN
 3. WHERE
 4. GROUP BY
 5. HAVING
 6. SELECT
      -> WINDOW FUNCTIONS ARE CALCULATED HERE
 7. ORDER BY
 8. TOP
********************************************************************************************/


/********************************************************************************************
 5. TABLE SETUP (USED FOR ALL EXAMPLES)
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
 6. WINDOW AGGREGATE FUNCTIONS
********************************************************************************************/

-- Average salary across ALL employees (no grouping)
SELECT
    EmployeeName,
    Salary,
    AVG(Salary) OVER () AS CompanyAverageSalary
FROM Employees;

/*
OUTPUT:
+--------------+--------+----------------------+
| EmployeeName | Salary | CompanyAverageSalary |
+--------------+--------+----------------------+
| Alice        | 60000  | 56428.57             |
| Bob          | 55000  | 56428.57             |
| Charlie      | 45000  | 56428.57             |
| David        | 40000  | 56428.57             |
| Eva          | 70000  | 56428.57             |
| Frank        | 65000  | 56428.57             |
| Grace        | 60000  | 56428.57             |
+--------------+--------+----------------------+
*/


-- Average salary per department
SELECT
    EmployeeName,
    Department,
    Salary,
    AVG(Salary) OVER (PARTITION BY Department) AS DeptAverageSalary
FROM Employees;

/*
OUTPUT:
+--------------+------------+--------+-------------------+
| EmployeeName | Department | Salary | DeptAverageSalary |
+--------------+------------+--------+-------------------+
| Alice        | IT         | 60000  | 58333.33          |
| Bob          | IT         | 55000  | 58333.33          |
| Grace        | IT         | 60000  | 58333.33          |
| Charlie      | HR         | 45000  | 42500             |
| David        | HR         | 40000  | 42500             |
| Eva          | Sales      | 70000  | 67500             |
| Frank        | Sales      | 65000  | 67500             |
+--------------+------------+--------+-------------------+
*/

-- Running total of salary by department
SELECT
    EmployeeName,
    Department,
    Salary,
    SUM(Salary) OVER (
        PARTITION BY Department
        ORDER BY Salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotalSalary
FROM Employees;

-- Running total of salary by department
SELECT
    EmployeeName,
    Department,
    Salary,
    SUM(Salary) OVER (
        PARTITION BY Department
        ORDER BY Salary
        --ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotalSalary
FROM Employees;

/*
OUTPUT:
+--------------+------------+--------+---------------------+
| EmployeeName | Department | Salary | RunningTotalSalary |
+--------------+------------+--------+---------------------+
| Bob          | IT         | 55000  | 55000               |
| Alice        | IT         | 60000  | 115000              |
| Grace        | IT         | 60000  | 175000              |
| David        | HR         | 40000  | 40000               |
| Charlie      | HR         | 45000  | 85000               |
| Frank        | Sales      | 65000  | 65000               |
| Eva          | Sales      | 70000  | 135000              |
+--------------+------------+--------+---------------------+
*/


/********************************************************************************************
 7. WINDOW RANKING FUNCTIONS
********************************************************************************************/

-- ROW_NUMBER: unique row number (no ties)
SELECT
    EmployeeName,
    Department,
    Salary,
    ROW_NUMBER() OVER (
        PARTITION BY Department
        ORDER BY Salary DESC
    ) AS RowNum
FROM Employees;

/*
OUTPUT:
+--------------+------------+--------+--------+
| EmployeeName | Department | Salary | RowNum |
+--------------+------------+--------+--------+
| Alice        | IT         | 60000  | 1      |
| Grace        | IT         | 60000  | 2      |
| Bob          | IT         | 55000  | 3      |
| Eva          | Sales      | 70000  | 1      |
| Frank        | Sales      | 65000  | 2      |
| Charlie      | HR         | 45000  | 1      |
| David        | HR         | 40000  | 2      |
+--------------+------------+--------+--------+
*/


-- RANK: same rank for ties, gaps allowed
SELECT
    EmployeeName,
    Department,
    Salary,
    RANK() OVER (
        PARTITION BY Department
        ORDER BY Salary DESC
    ) AS SalaryRank
FROM Employees;

/*
OUTPUT:
+--------------+------------+--------+------------+
| EmployeeName | Department | Salary | SalaryRank |
+--------------+------------+--------+------------+
| Alice        | IT         | 60000  | 1          |
| Grace        | IT         | 60000  | 1          |
| Bob          | IT         | 55000  | 3          |
| Eva          | Sales      | 70000  | 1          |
| Frank        | Sales      | 65000  | 2          |
| Charlie      | HR         | 45000  | 1          |
| David        | HR         | 40000  | 2          |
+--------------+------------+--------+------------+
*/


-- DENSE_RANK: same rank for ties, NO gaps
SELECT
    EmployeeName,
    Department,
    Salary,
    DENSE_RANK() OVER (
        PARTITION BY Department
        ORDER BY Salary DESC
    ) AS DenseSalaryRank
FROM Employees;

/*
OUTPUT:
+--------------+------------+--------+------------------+
| EmployeeName | Department | Salary | DenseSalaryRank |
+--------------+------------+--------+------------------+
| Alice        | IT         | 60000  | 1                |
| Grace        | IT         | 60000  | 1                |
| Bob          | IT         | 55000  | 2                |
| Eva          | Sales      | 70000  | 1                |
| Frank        | Sales      | 65000  | 2                |
| Charlie      | HR         | 45000  | 1                |
| David        | HR         | 40000  | 2                |
+--------------+------------+--------+------------------+
*/


/********************************************************************************************
 8. WINDOW VALUE FUNCTIONS
********************************************************************************************/

-- LAG: previous row value
SELECT
    EmployeeName,
    Department,
    Salary,
    LAG(Salary) OVER (
        PARTITION BY Department
        ORDER BY Salary
    ) AS PreviousSalary
FROM Employees;

/*
OUTPUT:
+--------------+------------+--------+----------------+
| EmployeeName | Department | Salary | PreviousSalary|
+--------------+------------+--------+----------------+
| Bob          | IT         | 55000  | NULL           |
| Alice        | IT         | 60000  | 55000          |
| Grace        | IT         | 60000  | 60000          |
| David        | HR         | 40000  | NULL           |
| Charlie      | HR         | 45000  | 40000          |
| Frank        | Sales      | 65000  | NULL           |
| Eva          | Sales      | 70000  | 65000          |
+--------------+------------+--------+----------------+
*/


-- LEAD: next row value
SELECT
    EmployeeName,
    Department,
    Salary,
    LEAD(Salary) OVER (
        PARTITION BY Department
        ORDER BY Salary
    ) AS NextSalary
FROM Employees;

/*
OUTPUT:
+--------------+------------+--------+------------+
| EmployeeName | Department | Salary | NextSalary|
+--------------+------------+--------+------------+
| Bob          | IT         | 55000  | 60000     |
| Alice        | IT         | 60000  | 60000     |
| Grace        | IT         | 60000  | NULL      |
| David        | HR         | 40000  | 45000     |
| Charlie      | HR         | 45000  | NULL      |
| Frank        | Sales      | 65000  | 70000     |
| Eva          | Sales      | 70000  | NULL      |
+--------------+------------+--------+------------+
*/


/********************************************************************************************
 11. SUMMARY (QUICK REVISION)

 WINDOW FUNCTIONS:
 - Perform calculations across related rows
 - Do NOT collapse rows

 TYPES:
 1. Window Aggregate  → SUM, AVG, COUNT
 2. Window Ranking    → ROW_NUMBER, RANK, DENSE_RANK
 3. Window Value      → LAG, LEAD, FIRST_VALUE, LAST_VALUE

 YOU ARE NOW CONFIDENT WITH WINDOW FUNCTIONS IN SQL SERVER 🚀
********************************************************************************************/
