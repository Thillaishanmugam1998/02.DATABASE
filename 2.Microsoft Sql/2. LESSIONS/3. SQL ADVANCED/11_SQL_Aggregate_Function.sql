/********************************************************************************************
 FILE NAME   : AggregateFunctions.sql
 DATABASE    : Microsoft SQL Server
 TOPIC       : AGGREGATE FUNCTIONS
 LEVEL       : ZERO TO HERO (BEGINNER FRIENDLY)

 DESCRIPTION :
 Aggregate functions perform calculations on multiple rows
 and return a single summarized value.

 COMMON AGGREGATE FUNCTIONS:
   COUNT()  -> Counts rows
   SUM()    -> Adds values
   AVG()    -> Calculates average
   MAX()    -> Finds highest value
   MIN()    -> Finds lowest value
********************************************************************************************/


/********************************************************************************************
 1. WHAT ARE AGGREGATE FUNCTIONS?

 Aggregate functions calculate a single result from many rows.
 Example:
   - Total number of employees
   - Average salary
   - Maximum salary
********************************************************************************************/


/********************************************************************************************
 2. WHY AGGREGATE FUNCTIONS ARE NEEDED?

 REAL-LIFE USE CASES:
   - Business: Total sales, average revenue
   - School: Average marks, highest score
   - HR: Employee count, salary statistics
********************************************************************************************/


/********************************************************************************************
 3. QUERY EXECUTION ORDER (VERY IMPORTANT)

 SQL Server internally executes queries in this order:

   1. FROM
   2. JOIN
   3. WHERE
   4. GROUP BY
   5. HAVING
   6. SELECT
   7. ORDER BY
   8. TOP

 NOTE:
   This is NOT the order we write queries, but how SQL executes them.
********************************************************************************************/


/********************************************************************************************
 4. TABLE SETUP (USED FOR ALL EXAMPLES)
********************************************************************************************/

-- Always clean up first to avoid errors
DROP TABLE IF EXISTS Employees;

-- Create Employees table
CREATE TABLE Employees
(
    EmployeeID   INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    Department   VARCHAR(50),
    Salary       INT,
    Bonus        INT
);

-- Insert sample data
INSERT INTO Employees VALUES
(1, 'Alice',   'IT',     60000, 5000),
(2, 'Bob',     'IT',     55000, NULL),
(3, 'Charlie', 'HR',     45000, 3000),
(4, 'David',   'HR',     40000, NULL),
(5, 'Eva',     'Sales',  70000, 7000),
(6, 'Frank',   'Sales',  65000, 6000),
(7, 'Grace',   'IT',     60000, 5000);

-- View initial table data
SELECT * FROM Employees;


/********************************************************************************************
 5. COUNT() FUNCTION
********************************************************************************************/

-- COUNT(*) counts all rows including duplicates and NULL values
SELECT 
    COUNT(*) AS TotalEmployees
FROM Employees;

-- COUNT(column_name) ignores NULL values
SELECT 
    COUNT(Bonus) AS EmployeesWithBonus
FROM Employees;


/********************************************************************************************
 6. SUM() FUNCTION
********************************************************************************************/

-- SUM calculates total of a numeric column
SELECT 
    SUM(Salary) AS TotalSalary
FROM Employees;


/********************************************************************************************
 7. AVG() FUNCTION
********************************************************************************************/

-- AVG calculates average value (NULL values are ignored)
SELECT 
    AVG(Salary) AS AverageSalary
FROM Employees;


/********************************************************************************************
 8. MAX() AND MIN() FUNCTIONS
********************************************************************************************/

-- MAX returns the highest value
-- MIN returns the lowest value
SELECT 
    MAX(Salary) AS HighestSalary,
    MIN(Salary) AS LowestSalary
FROM Employees;


/********************************************************************************************
 9. GROUP BY WITH AGGREGATE FUNCTIONS
********************************************************************************************/

-- Average salary per department
SELECT 
    Department,
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department;

-- Count employees per department
SELECT 
    Department,
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department;


/********************************************************************************************
 10. WHERE VS HAVING (VERY IMPORTANT)
********************************************************************************************/

-- WHERE filters ROWS before grouping
SELECT 
    Department,
    AVG(Salary) AS AverageSalary
FROM Employees
WHERE Salary > 50000
GROUP BY Department;

-- HAVING filters GROUPS after aggregation
SELECT 
    Department,
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 55000;


/********************************************************************************************
 11. ORDER BY WITH AGGREGATE FUNCTIONS
********************************************************************************************/

-- Sort departments by total salary (highest first)
SELECT 
    Department,
    SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department
ORDER BY TotalSalary DESC;


/********************************************************************************************
 12. NULL VALUE BEHAVIOR (EDGE CASES)
********************************************************************************************/

-- AVG ignores NULL values
SELECT 
    AVG(Bonus) AS AverageBonus
FROM Employees;

-- COUNT(column) ignores NULL values
SELECT 
    COUNT(Bonus) AS BonusCount
FROM Employees;


/********************************************************************************************
 13. COMMON MISTAKES (DO NOT RUN - FOR LEARNING ONLY)
********************************************************************************************/

-- ❌ WRONG: Column not in GROUP BY
-- SELECT EmployeeName, AVG(Salary)
-- FROM Employees
-- GROUP BY Department;

-- ✅ CORRECT:
SELECT 
    Department,
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department;


/********************************************************************************************
 14. BEST PRACTICES
********************************************************************************************/

-- ✔ Use GROUP BY when mixing aggregates and columns
-- ✔ Use HAVING for aggregate filtering
-- ✔ Use WHERE for row-level filtering
-- ✔ Handle NULL values carefully
-- ✔ Use meaningful aliases
-- ✔ Understand execution order


/********************************************************************************************
 15. SUMMARY (QUICK REVISION)

 - Aggregate functions summarize multiple rows
 - Common functions: COUNT, SUM, AVG, MAX, MIN
 - WHERE filters rows
 - HAVING filters groups
 - GROUP BY is mandatory when using aggregates with columns
 - NULL values are ignored by most aggregates
 - SQL execution order matters

 YOU ARE NOW CONFIDENT WITH AGGREGATE FUNCTIONS IN SQL SERVER 🎯
********************************************************************************************/
