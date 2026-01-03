/* 
========================================================
SQL NUMBER & DATE/TIME FUNCTIONS - Microsoft SQL Server
Author: ChatGPT
Date: 2026-01-03
Purpose: Complete beginner-to-advanced notes with examples
========================================================
*/

/* ===========================================
1. WHAT NUMBER & DATE/TIME FUNCTIONS ARE
================================================
- NUMBER FUNCTIONS: Functions that let you perform calculations, rounding, aggregation, or manipulation on numeric data.
  Examples: SUM(), AVG(), COUNT(), ROUND(), CEILING(), FLOOR(), ABS()

- DATE/TIME FUNCTIONS: Functions that let you work with dates and times, like extracting parts of a date, adding/subtracting time, formatting, etc.
  Examples: GETDATE(), DATEADD(), DATEDIFF(), YEAR(), MONTH(), DAY(), FORMAT()

They allow SQL queries to calculate results dynamically without manually computing them.
*/

/* ===========================================
2. WHY NUMBER & DATE/TIME FUNCTIONS ARE NEEDED
================================================
- Real-life examples:

1. NUMBER FUNCTIONS
   - Calculate total sales, average score, or maximum profit.
   - Generate statistics like number of students, highest/lowest grades.

2. DATE/TIME FUNCTIONS
   - Track registration dates, deadlines, or subscription expiry.
   - Compute age from birthdate, or number of days since last login.
*/

/* ===========================================
3. SYNTAX
================================================
-- Number Functions
SELECT 
    SUM(column_name)      -- Adds up all numeric values
    , AVG(column_name)    -- Calculates average
    , COUNT(column_name)  -- Counts rows (non-null)
    , MAX(column_name)    -- Maximum value
    , MIN(column_name)    -- Minimum value
    , ROUND(column_name, decimals)  -- Round to given decimals
    , CEILING(column_name) -- Round up
    , FLOOR(column_name)   -- Round down
    , ABS(column_name)     -- Absolute value
FROM table_name;

-- Date/Time Functions
SELECT
    GETDATE()             -- Current date & time
    , CURRENT_TIMESTAMP   -- Same as GETDATE()
    , DATEADD(day, 5, column_date)  -- Add 5 days
    , DATEDIFF(day, column_date1, column_date2) -- Difference in days
    , YEAR(column_date)   -- Extract year
    , MONTH(column_date)  -- Extract month
    , DAY(column_date)    -- Extract day
    , FORMAT(column_date, 'yyyy-MM-dd') -- Format date
FROM table_name;
*/

/* ===========================================
4. EXAMPLES WITH TABLES
================================================
*/

/* ---------- Example 1: NUMBER FUNCTIONS ---------- */
-- Step 0: Drop table if exists
IF OBJECT_ID('Sales') IS NOT NULL
    DROP TABLE Sales;

-- Step 1: Create table
CREATE TABLE Sales (
    SaleID INT,
    Product VARCHAR(50),
    Quantity INT,
    Price DECIMAL(10,2)
);

-- Step 2: Insert data
INSERT INTO Sales VALUES
(1, 'Laptop', 2, 1200.50),
(2, 'Mouse', 5, 25.75),
(3, 'Keyboard', 3, 45.00),
(4, 'Monitor', 1, 350.00),
(5, 'Laptop', 1, 1200.50);

-- Step 3: Query examples
-- Example A: SUM & AVG
SELECT 
    SUM(Price * Quantity) AS TotalRevenue,
    AVG(Price) AS AvgPrice,
    COUNT(SaleID) AS TotalSales,
    MAX(Price) AS MaxPrice,
    MIN(Price) AS MinPrice
FROM Sales;

/* Step-by-step explanation:
   Initial table: Sales
   Step 1: SQL reads FROM Sales
   Step 2: Calculates SUM(Price*Quantity), AVG(Price), etc.
   Step 3: Returns one row with all aggregates
*/

/* ---------- Example 2: ROUND, CEILING, FLOOR, ABS ---------- */
SELECT 
    ROUND(Price, 0) AS RoundedPrice,
    CEILING(Price) AS CeilPrice,
    FLOOR(Price) AS FloorPrice,
    ABS(-Quantity) AS AbsQuantity
FROM Sales;

/* ===========================================
Example 3: DATE/TIME FUNCTIONS
================================================
*/

/* Step 0: Drop table if exists */
IF OBJECT_ID('Employee') IS NOT NULL
    DROP TABLE Employee;

-- Step 1: Create table
CREATE TABLE Employee (
    EmpID INT,
    Name VARCHAR(50),
    BirthDate DATE,
    JoiningDate DATETIME
);

-- Step 2: Insert data
INSERT INTO Employee VALUES
(1, 'Alice', '1990-05-15', '2015-06-01 09:30:00'),
(2, 'Bob', '1985-11-23', '2018-01-15 10:00:00'),
(3, 'Charlie', '1992-07-10', '2020-03-20 08:45:00');

-- Step 3: Query examples
-- Example A: GETDATE(), YEAR(), MONTH(), DAY()
SELECT 
    Name,
    BirthDate,
    YEAR(BirthDate) AS BirthYear,
    MONTH(BirthDate) AS BirthMonth,
    DAY(BirthDate) AS BirthDay,
    GETDATE() AS Today
FROM Employee;

-- Example B: DATEADD & DATEDIFF
SELECT 
    Name,
    JoiningDate,
    DATEADD(year, 5, JoiningDate) AS FiveYearsLater,
    DATEDIFF(day, JoiningDate, GETDATE()) AS DaysWorked
FROM Employee;

-- Example C: FORMAT
SELECT 
    Name,
    FORMAT(BirthDate, 'dd-MM-yyyy') AS FormattedBirthDate,
    FORMAT(JoiningDate, 'MMMM yyyy') AS JoiningMonthYear
FROM Employee;

/* ===========================================
5. MULTIPLE VARIATIONS / EDGE CASES
================================================
-- Multiple-column aggregation
SELECT 
    Product,
    SUM(Quantity) AS TotalQty,
    AVG(Price) AS AvgPrice
FROM Sales
GROUP BY Product;

-- Counting non-null vs all rows
SELECT COUNT(Price) AS NonNullPrices,
       COUNT(*) AS TotalRows
FROM Sales;

-- Edge case: Division by zero
SELECT 
    Quantity,
    CASE WHEN Quantity = 0 THEN NULL ELSE Price/Quantity END AS PricePerUnit
FROM Sales;

/* ===========================================
6. IMPORTANT TIPS & NOTES
================================================
1. Aggregates ignore NULL values (except COUNT(*)).
2. ROUND rounds normally, CEILING always up, FLOOR always down.
3. GETDATE() returns current server datetime.
4. DATEADD allows negative values to subtract time.
5. DATEDIFF returns integer difference between dates (unit can be day, month, year).
6. Grouped queries must GROUP BY all non-aggregated columns.
7. Always drop table before creating in practice scripts to avoid errors.
*/

/* ===========================================
7. SQL QUERY EXECUTION ORDER
================================================
Internal processing order:

1. FROM       → Tables are read first
2. WHERE      → Filter rows
3. GROUP BY   → Group rows if aggregation is used
4. HAVING     → Filter groups
5. SELECT     → Compute columns and functions
6. ORDER BY   → Sort results
7. LIMIT/TOP  → Return subset (TOP in SQL Server)
*/

/* ===========================================
8. SUMMARY
================================================
- NUMBER FUNCTIONS: SUM, AVG, COUNT, MAX, MIN, ROUND, CEILING, FLOOR, ABS
- DATE FUNCTIONS: GETDATE, DATEADD, DATEDIFF, YEAR, MONTH, DAY, FORMAT
- Always handle NULLs carefully.
- Use GROUP BY for multi-row aggregation.
- SQL execution order matters for WHERE vs HAVING vs SELECT.
- Practice with step-by-step examples to understand data flow.
*/

/* =================== END OF NOTES =================== */
