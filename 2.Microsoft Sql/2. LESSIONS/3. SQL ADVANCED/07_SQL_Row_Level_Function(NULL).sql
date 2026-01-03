/********************************************************************
SQL SERVER: COMPLETE NOTES ON NULL FUNCTIONS
Topic: NULL Functions
Author: ChatGPT
Purpose: Beginner-to-Hero guide on handling NULLs in SQL Server
********************************************************************/

------------------------------------------------------------
1. WHAT NULL FUNCTIONS ARE
------------------------------------------------------------
-- In SQL Server, NULL represents "unknown" or "missing" data.
-- A NULL is different from 0, empty string, or spaces.
-- NULL Functions are special functions used to handle, test, or replace NULL values.

-- Common SQL Server NULL Functions include:
-- 1. ISNULL()     -> Replaces NULL with a specified value
-- 2. COALESCE()   -> Returns the first non-NULL value from a list
-- 3. NULLIF()     -> Returns NULL if two expressions are equal
-- 4. ISNULL / CAST / CONVERT (sometimes used to handle NULLs in expressions)

------------------------------------------------------------
2. WHY NULL FUNCTIONS ARE NEEDED
------------------------------------------------------------
-- Real-life use cases:
-- 1. Calculating total sales, where some sales values may be missing (NULL)
-- 2. Displaying default values in reports instead of blanks
-- 3. Avoiding errors in aggregate functions like SUM() or AVG() caused by NULLs
-- 4. Comparing values safely when NULLs exist

------------------------------------------------------------
3. SYNTAX
------------------------------------------------------------

-- 3.1 ISNULL
-- Replaces NULL with a specified value
-- Syntax:
-- ISNULL(expression, replacement_value)

-- 3.2 COALESCE
-- Returns the first non-NULL value in the list
-- Syntax:
-- COALESCE(expression1, expression2, ..., expressionN)

-- 3.3 NULLIF
-- Returns NULL if two expressions are equal; otherwise returns the first expression
-- Syntax:
-- NULLIF(expression1, expression2)

------------------------------------------------------------
4. STEP-BY-STEP EXAMPLES
------------------------------------------------------------

-- Example Table: Employees
CREATE TABLE Employees (
    EmployeeID INT,
    Name NVARCHAR(50),
    Salary DECIMAL(10,2),
    Bonus DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO Employees (EmployeeID, Name, Salary, Bonus) VALUES
(1, 'Alice', 5000, 500),
(2, 'Bob', 6000, NULL),
(3, 'Charlie', NULL, 300),
(4, 'David', NULL, NULL);

------------------------------------------------------------
-- 4.1 Using ISNULL
------------------------------------------------------------
-- Goal: Replace NULL Salary with 0
SELECT 
    Name,
    ISNULL(Salary, 0) AS Salary
FROM Employees;

-- Step 1: SQL scans the table
-- Step 2: Checks each row's Salary for NULL
-- Step 3: Replaces NULL with 0
-- Final Output:
-- Name      Salary
-- Alice     5000
-- Bob       6000
-- Charlie   0
-- David     0

------------------------------------------------------------
-- 4.2 Using COALESCE
------------------------------------------------------------
-- Goal: Get Salary or Bonus if Salary is NULL
SELECT 
    Name,
    COALESCE(Salary, Bonus, 0) AS EffectivePay
FROM Employees;

-- Step 1: SQL scans each row
-- Step 2: Checks Salary; if NULL, checks Bonus; if NULL, uses 0
-- Step 3: Returns first non-NULL value
-- Output:
-- Name      EffectivePay
-- Alice     5000
-- Bob       6000
-- Charlie   300
-- David     0

------------------------------------------------------------
-- 4.3 Using NULLIF
------------------------------------------------------------
-- Goal: Avoid divide-by-zero errors
-- Formula: Bonus / NULLIF(Salary, 0)
SELECT
    Name,
    Bonus / NULLIF(Salary, 0) AS BonusPercent
FROM Employees;

-- Step 1: SQL compares Salary with 0 using NULLIF
-- Step 2: If Salary = 0, it returns NULL to prevent division by zero
-- Step 3: Performs division only when Salary is not zero
-- Output:
-- Name      BonusPercent
-- Alice     0.10
-- Bob       NULL
-- Charlie   NULL
-- David     NULL

------------------------------------------------------------
5. MULTIPLE EXAMPLES & VARIATIONS
------------------------------------------------------------

-- 5.1 COUNT ignores NULLs
SELECT COUNT(Salary) AS CountOfSalaries
FROM Employees;
-- Output: 2 (Alice & Bob only, NULLs ignored)

-- 5.2 SUM ignores NULLs
SELECT SUM(Bonus) AS TotalBonus
FROM Employees;
-- Output: 800 (500+300; NULLs ignored)

-- 5.3 AVG ignores NULLs
SELECT AVG(Salary) AS AvgSalary
FROM Employees;
-- Output: 5500 ((5000+6000)/2)

-- 5.4 MAX & MIN ignore NULLs
SELECT MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary
FROM Employees;
-- Output: MaxSalary = 6000, MinSalary = 5000

-- 5.5 Multi-column COALESCE
SELECT
    Name,
    COALESCE(Salary, Bonus, 1000) AS Pay
FROM Employees;
-- Replaces Salary with Bonus if Salary is NULL; otherwise with 1000 if both are NULL

------------------------------------------------------------
6. IMPORTANT TIPS AND NOTES
------------------------------------------------------------
-- 1. NULL is NOT equal to anything, not even NULL: Use IS NULL / IS NOT NULL
-- 2. Use ISNULL or COALESCE to provide default values
-- 3. COUNT(expression) ignores NULL, COUNT(*) counts rows including NULL
-- 4. SUM, AVG, MAX, MIN ignore NULLs automatically
-- 5. COALESCE can take multiple arguments; ISNULL only takes 2
-- 6. NULLIF is useful to avoid divide-by-zero errors
-- 7. When combining NULLs with arithmetic operations, the result is usually NULL
--    e.g., NULL + 100 = NULL

------------------------------------------------------------
7. SQL QUERY EXECUTION ORDER (WITH NULL FUNCTIONS)
------------------------------------------------------------
-- SQL executes queries internally in this order:
-- 1. FROM      -> identify tables
-- 2. WHERE     -> filter rows
-- 3. GROUP BY  -> group rows
-- 4. HAVING    -> filter groups
-- 5. SELECT    -> calculate expressions, apply ISNULL/COALESCE/NULLIF
-- 6. ORDER BY  -> sort result
-- 7. LIMIT / TOP -> restrict rows

-- Example:
-- SELECT ISNULL(SUM(Bonus),0) AS TotalBonus
-- FROM Employees
-- WHERE Salary > 4000
-- ORDER BY TotalBonus DESC;

-- Execution:
-- Step 1: FROM Employees
-- Step 2: WHERE Salary > 4000 => Alice & Bob
-- Step 3: SUM(Bonus) => 500 + NULL = 500
-- Step 4: ISNULL(SUM(Bonus),0) => 500
-- Step 5: ORDER BY TotalBonus DESC => Only 1 row
-- Step 6: Return result

------------------------------------------------------------
8. SUMMARY
------------------------------------------------------------
-- NULL Functions in SQL Server:
-- 1. ISNULL(expr, value)      -> Replace NULL with a value
-- 2. COALESCE(expr1, ..., n) -> First non-NULL value
-- 3. NULLIF(expr1, expr2)    -> Returns NULL if expr1 = expr2
-- 4. Aggregate functions ignore NULLs automatically
-- 5. Use NULL functions to avoid errors and display defaults
-- 6. SQL execution order matters; SELECT expressions like ISNULL/COALESCE are applied late

------------------------------------------------------------
-- End of SQL NULL Functions Notes
------------------------------------------------------------
