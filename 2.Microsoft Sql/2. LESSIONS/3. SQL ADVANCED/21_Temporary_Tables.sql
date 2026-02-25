-- ============================================================
--              SQL SERVER - COMPLETE BEGINNER NOTES
-- ============================================================

-- DATA BASE ENGINE:
    --  it is the brain of the databse, executing multiple operations 
    -- such as storing, retrieving and managing data within the database.

-- DISK STORAGE:
    -- Long-term memory, where data is stored permanently.
    -- Capacity - Can hold a large amount of data
    -- Speed - slow to read and write

-- CACHE STORAGE:
    -- Fase short-term memory where data is stored temporarily
    -- Speed - Extremely fast to read and to write
    -- Capacity - Can hold smaller amount of data 

-- USER DATA STORAGE:
    -- It is main content of the database this is where the actual data that users care about is stored.
    -- Example(our created tables)

-- SYSTEM CATALOG:
    -- Database is internal storage for its own information.
    -- A blueprint that keeps track of everything about the database itself, not the user data
    -- It holds the metadata information about the database

-- META DATA:
    -- DATA About DATA
    -- If example have one table (that have 3 row and 5 columns)
    -- Meta data only sotre (tablename,column name,column data type,constraint) not store actaul data

-- INFORMATION SCHEMA
    -- A system-defined schema with buit in views  that provide info about the database like tables,columns..

    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    SELECT * FROM INFORMATION_SCHEMA.TABLES
-- ============================================================
--              SQL SERVER - COMPLETE BEGINNER NOTES
-- ============================================================

-- SQL SERVER HIERARCHY
-- -------------------------------------------------------
--   SQL Server
--       └── Database
--               └── Schema
--                       ├── Table
--                       │     └── Columns
--                       │           ├── Column Name
--                       │           └── Data Type
--                       └── View
--                             └── Columns (virtual)
-- -------------------------------------------------------


-- ============================================================
-- SECTION 1: DDL (Data Definition Language)
-- ============================================================
-- DDL commands define and manage the STRUCTURE of database objects.
-- They do NOT deal with the actual data inside tables.

-- 1. CREATE  → Creates a new object (table, view, index, etc.)
-- 2. ALTER   → Modifies an existing object (add/remove columns, etc.)
-- 3. DROP    → Permanently deletes an object


-- ============================================================
-- SECTION 2: WHAT IS A TABLE?
-- ============================================================
-- A table is a structured collection of data,
-- similar to a spreadsheet or Excel grid.
-- It has ROWS (records) and COLUMNS (fields).

-- TABLE TYPES:
-- 1. Permanent Table   → Stored permanently in the database
-- 2. Temporary Table   → Lives only during the session (#TableName)


-- ============================================================
-- SECTION 3: CREATE TABLE (Traditional Method)
-- ============================================================
-- STEP 1 → Create an empty table with structure
-- STEP 2 → Insert data into it separately

-- SYNTAX:
-- -------------------------------------------------------
CREATE TABLE Employees
(
    EmployeeID   INT,
    EmployeeName VARCHAR(50),
    Department   VARCHAR(50),
    Salary       DECIMAL(10,2)
);

-- STEP 2: Insert data row by row
INSERT INTO Employees VALUES (1, 'Alice',   'HR',      55000.00);
INSERT INTO Employees VALUES (2, 'Bob',     'Finance', 62000.00);
INSERT INTO Employees VALUES (3, 'Charlie', 'IT',      70000.00);

-- Result in Employees table:
-- ┌────────────┬──────────────┬────────────┬──────────┐
-- │ EmployeeID │ EmployeeName │ Department │  Salary  │
-- ├────────────┼──────────────┼────────────┼──────────┤
-- │     1      │    Alice     │    HR      │ 55000.00 │
-- │     2      │    Bob       │   Finance  │ 62000.00 │
-- │     3      │    Charlie   │    IT      │ 70000.00 │
-- └────────────┴──────────────┴────────────┴──────────┘


-- ============================================================
-- SECTION 4: CTAS (Create Table As Select)
-- ============================================================
-- Creates a NEW table and fills it with data in ONE step
-- using the result of a SELECT query.
-- No need for a separate INSERT statement.

-- STEP 1 → Write a SELECT query
-- STEP 2 → The result is stored directly as a new table

-- SYNTAX (MySQL / PostgreSQL / Oracle):
-- -------------------------------------------------------
--  CREATE TABLE new_table_name AS
--  (
--      SELECT column1, column2, ...
--      FROM   existing_table
--      WHERE  condition
--  );

-- SYNTAX (SQL Server — uses SELECT INTO):
-- -------------------------------------------------------
SELECT EmployeeID, EmployeeName, Department, Salary
INTO   IT_Employees                  -- new table is created here
FROM   Employees
WHERE  Department = 'IT';

-- Result: A brand new table IT_Employees is created
-- and already contains Charlie's record from Employees.


-- ============================================================
-- SECTION 5: VIEW
-- ============================================================
-- A VIEW is a VIRTUAL table.
-- It stores only a QUERY definition, NOT the actual data.
-- Every time you SELECT from a view, the query runs FRESH.

-- SYNTAX:
-- -------------------------------------------------------
CREATE VIEW vw_Employees AS
    SELECT EmployeeID, EmployeeName, Department, Salary
    FROM   Employees;

-- When you run:
SELECT * FROM vw_Employees;
-- The SELECT query inside the view executes NOW and returns live data.


-- ============================================================
-- SECTION 6: CTAS vs VIEW — KEY DIFFERENCES
-- ============================================================

-- Setup: Main table has 3 rows: Row1, Row2, Row3

-- ┌─────────────────────┬──────────────────────────┬─────────────────────────┐
-- │      Feature        │  VIEW                    │  CTAS (SELECT INTO)     │
-- ├─────────────────────┼──────────────────────────┼─────────────────────────┤
-- │ When is query run?  │ At SELECT time (lazy)    │ At creation time (eager)│
-- │ Data stored?        │ NO — only query stored   │ YES — data is copied    │
-- │ Speed               │ Slower (reruns query)    │ Faster (pre-stored data)│
-- │ Reflects updates?   │ YES — always live data   │ NO — snapshot in time   │
-- │ Storage used?       │ Minimal                  │ Full copy of data       │
-- └─────────────────────┴──────────────────────────┴─────────────────────────┘

-- EXAMPLE: Main table has rows: 1, 2, 3
-- Now UPDATE main table: row 1 → 4, row 2 → 5 (row 3 stays)

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │  After update: Main table = { 4, 5, 3 }                                 │
-- │                                                                          │
-- │  SELECT * FROM vw_Employees;  → Returns { 4, 5, 3 }  ✅ (live/fresh)   │
-- │                                                                          │
-- │  SELECT * FROM IT_Employees;  → Returns { 1, 2, 3 }  ❌ (old snapshot) │
-- └──────────────────────────────────────────────────────────────────────────┘

-- USE VIEW   when you always need the LATEST data
-- USE CTAS   when you need a FAST, fixed snapshot for reporting/processing


-- ============================================================
-- SECTION 7: REAL-WORLD EXAMPLE SCENARIO
-- ============================================================

-- PROBLEM:
-- -------------------------------------------------------
-- Your organization has 2 large tables that need to be JOINed.
-- The JOIN query is complex and takes time to write.
-- Now 3 different departments use this combined data every day:
--
--   1. Financial Analyst  → wants RANK of orders
--   2. Budget Team        → wants MAX / MIN values
--   3. Risk Analyst       → wants to COMPARE figures
--
-- WITHOUT CTAS / VIEW:
--   Each person writes the full JOIN query EVERY TIME,
--   then adds their own calculation on top.
--   → Time-consuming, repetitive, and error-prone ❌

-- SOLUTION WITH CTAS:
-- -------------------------------------------------------
-- Create the joined/aggregated result ONCE as a CTAS table.
-- Now all 3 teams simply query THAT ONE TABLE.
-- No one needs to rewrite the JOIN ever again. ✅

-- Step 1: Create the CTAS table ONCE
SELECT
    DATENAME(MONTH, OrderDate)  AS OrderMonth,
    COUNT(OrderID)              AS TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate);

-- Step 2: Each team queries it directly — fast and simple
SELECT * FROM Sales.MonthlyOrders;                                   -- Financial Analyst: see all data
SELECT MAX(TotalOrders), MIN(TotalOrders) FROM Sales.MonthlyOrders;  -- Budget Team: max/min
SELECT OrderMonth, TotalOrders FROM Sales.MonthlyOrders              -- Risk Analyst: compare by month
ORDER BY TotalOrders DESC;

-- IMPORTANT NOTE:
-- CTAS stores data as a SNAPSHOT at creation time.
-- If new orders are added to Sales.Orders, the CTAS table
-- will NOT update automatically — it still holds OLD data.
-- You must DROP and recreate it to get fresh results.


-- ============================================================
-- SECTION 8: HOW TO REFRESH A CTAS TABLE
-- ============================================================

-- PROBLEM:
-- CTAS holds old data. New records added to the source table
-- are NOT reflected in the CTAS table automatically.

-- SOLUTION: Drop the old table and recreate it.

-- SAFE REFRESH PATTERN (always use this approach):
-- -------------------------------------------------------
IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
    DROP TABLE Sales.MonthlyOrders;
GO

SELECT
    DATENAME(MONTH, OrderDate)  AS OrderMonth,
    COUNT(OrderID)              AS TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate);
GO

-- HOW IT WORKS:
-- OBJECT_ID('Sales.MonthlyOrders', 'U') checks if the table exists.
--   'U' means User table.
-- If table EXISTS   → DROP it first, then recreate it fresh ✅
-- If table MISSING  → Skip DROP, just create it directly  ✅
-- This prevents errors when running the same script multiple times.


-- ============================================================
-- SECTION 9: QUICK SYNTAX REFERENCE
-- ============================================================

-- 1. CREATE TABLE (Manual — 2 steps)
-- -------------------------------------------------------
-- CREATE TABLE TableName
-- (
--     column1  datatype,
--     column2  datatype,
--     columnN  datatype
-- );
--
-- INSERT INTO TableName
-- VALUES (value1, value2, ..., valueN);


-- 2. CTAS — SQL Server (SELECT INTO)
-- -------------------------------------------------------
-- SELECT column1, column2, ...
-- INTO   NewTableName
-- FROM   SourceTable
-- WHERE  condition;


-- 3. CTAS — MySQL / PostgreSQL / Oracle
-- -------------------------------------------------------
-- CREATE TABLE NewTableName AS
-- (
--     SELECT column1, column2, ...
--     FROM   SourceTable
--     WHERE  condition
-- );


-- 4. CREATE VIEW
-- -------------------------------------------------------
-- CREATE VIEW ViewName AS
--     SELECT column1, column2, ...
--     FROM   SourceTable
--     WHERE  condition;


-- 5. SAFE CTAS REFRESH (Drop & Recreate)
-- -------------------------------------------------------
-- IF OBJECT_ID('SchemaName.TableName', 'U') IS NOT NULL
--     DROP TABLE SchemaName.TableName;
-- GO
-- SELECT column1, column2, ...
-- INTO   SchemaName.TableName
-- FROM   SourceTable
-- WHERE  condition;
-- GO


-- 6. ALTER TABLE (add a new column)
-- -------------------------------------------------------
-- ALTER TABLE TableName
-- ADD NewColumn datatype;


-- 7. DROP TABLE / DROP VIEW
-- -------------------------------------------------------
-- DROP TABLE TableName;
-- DROP VIEW  ViewName;


-- ============================================================
-- SECTION 10: TEMPORARY TABLES
-- ============================================================
-- A Temporary Table stores intermediate results in temporary
-- storage (tempdb) during a session.
-- SQL Server automatically drops all temp tables when the
-- session ends — no manual cleanup needed.

-- SESSION = The time between connecting to and disconnecting
--           from the database.

-- WHERE IS TEMPDB?
-- -------------------------------------------------------
-- SQL Server → System Databases → tempdb → Temporary Tables

-- HOW SQL SERVER PROCESSES A QUERY (background):
-- -------------------------------------------------------
--   1. You run:  SELECT * FROM Sales.Orders
--   2. Query is sent to the SQL Server Engine
--   3. Engine checks the System Cache first (fast memory)
--   4. If NOT in cache → reads from Disk (slower)
--   5. Data is returned to the client
--
-- Temporary tables live in tempdb (on disk + cache),
-- acting as a staging area between steps.

-- NAMING RULE:
-- -------------------------------------------------------
--   #TableName   → Local temp table  (visible to current session only)
--   ##TableName  → Global temp table (visible to ALL sessions)

-- ============================================================
-- SECTION 10A: PRACTICAL EXAMPLE — 3-STEP ETL PATTERN
-- ============================================================
-- A common real-world pattern:
--   Step 1 → Load raw data into a temp table
--   Step 2 → Clean / filter the data in the temp table
--   Step 3 → Push clean data into a permanent table
--
-- WHY use a temp table in the middle?
--   → Avoid modifying the original source table
--   → Test/validate data before writing it permanently
--   → Break a complex task into safe, manageable steps

-- -------------------------------------------------------
-- STEP 1: Load raw data into a temporary table (#Orders)
-- -------------------------------------------------------
SELECT *
INTO #Orders
FROM Sales.Orders;
-- A temp table #Orders is created in tempdb with ALL orders.
-- This is just a working copy — Sales.Orders is untouched.

-- -------------------------------------------------------
-- STEP 2: Clean the data inside the temp table
-- -------------------------------------------------------
DELETE FROM #Orders
WHERE OrderStatus = 'Delivered';
-- Delivered records are removed from #Orders.
-- Sales.Orders (the real table) is still unchanged.

-- -------------------------------------------------------
-- STEP 3: Push clean data into a permanent table
-- -------------------------------------------------------
SELECT *
INTO Sales.OrdersTest
FROM #Orders;
-- Only the non-Delivered orders are saved to Sales.OrdersTest.
-- This is now a real permanent table in the database.

-- ┌──────────────────────────────────────────────────────────────────────┐
-- │  FLOW SUMMARY                                                        │
-- │                                                                      │
-- │  Sales.Orders (source, untouched)                                   │
-- │       │                                                              │
-- │       │  SELECT * INTO #Orders                                       │
-- │       ▼                                                              │
-- │  #Orders in tempdb  ──── DELETE WHERE Status = 'Delivered'          │
-- │       │                                                              │
-- │       │  SELECT * INTO Sales.OrdersTest                             │
-- │       ▼                                                              │
-- │  Sales.OrdersTest (clean permanent table) ✅                        │
-- └──────────────────────────────────────────────────────────────────────┘


-- ============================================================
-- SECTION 10B: TEMPORARY TABLE vs CTAS vs VIEW
-- ============================================================

-- ┌──────────────────┬──────────────────┬──────────────────┬──────────────────┐
-- │    Feature       │  Temp Table (#)  │  CTAS            │  VIEW            │
-- ├──────────────────┼──────────────────┼──────────────────┼──────────────────┤
-- │ Where stored?    │ tempdb (system)  │ Your schema      │ No storage       │
-- │ Data stored?     │ YES              │ YES              │ NO (query only)  │
-- │ Auto deleted?    │ YES (on logout)  │ NO (permanent)   │ NO (permanent)   │
-- │ Reflects source? │ NO (snapshot)    │ NO (snapshot)    │ YES (live)       │
-- │ Best used for    │ Staging/cleaning │ Reporting copy   │ Live data access │
-- └──────────────────┴──────────────────┴──────────────────┴──────────────────┘


-- ============================================================
-- UPDATED QUICK SYNTAX REFERENCE
-- ============================================================

-- 1. CREATE TABLE (Manual — 2 steps)
-- -------------------------------------------------------
-- CREATE TABLE TableName
-- (
--     column1  datatype,
--     column2  datatype,
--     columnN  datatype
-- );
-- INSERT INTO TableName VALUES (value1, value2, ..., valueN);


-- 2. CTAS — SQL Server (SELECT INTO)
-- -------------------------------------------------------
-- SELECT column1, column2, ...
-- INTO   NewTableName
-- FROM   SourceTable
-- WHERE  condition;


-- 3. CTAS — MySQL / PostgreSQL / Oracle
-- -------------------------------------------------------
-- CREATE TABLE NewTableName AS
-- (
--     SELECT column1, column2, ...
--     FROM   SourceTable
--     WHERE  condition
-- );


-- 4. CREATE VIEW
-- -------------------------------------------------------
-- CREATE VIEW ViewName AS
--     SELECT column1, column2, ...
--     FROM   SourceTable
--     WHERE  condition;


-- 5. SAFE CTAS REFRESH (Drop & Recreate)
-- -------------------------------------------------------
-- IF OBJECT_ID('SchemaName.TableName', 'U') IS NOT NULL
--     DROP TABLE SchemaName.TableName;
-- GO
-- SELECT column1, column2, ...
-- INTO   SchemaName.TableName
-- FROM   SourceTable
-- WHERE  condition;
-- GO


-- 6. TEMPORARY TABLE — Load → Clean → Promote pattern
-- -------------------------------------------------------
-- SELECT * INTO #TempTable FROM SourceTable;          -- Step 1: Load
-- DELETE FROM #TempTable WHERE condition;             -- Step 2: Clean
-- SELECT * INTO Schema.PermanentTable FROM #TempTable;-- Step 3: Promote


-- 7. ALTER TABLE (add a new column)
-- -------------------------------------------------------
-- ALTER TABLE TableName
-- ADD NewColumn datatype;


-- 8. DROP TABLE / DROP VIEW
-- -------------------------------------------------------
-- DROP TABLE TableName;
-- DROP VIEW  ViewName;
-- (Temp tables drop automatically when session ends)

-- ============================================================
--                        END OF NOTES
-- ============================================================

-- SQL SERVER HIERARCHY
-- -------------------------------------------------------
--   SQL Server
--       └── Database
--               └── Schema
--                       ├── Table
--                       │     └── Columns
--                       │           ├── Column Name
--                       │           └── Data Type
--                       └── View
--                             └── Columns (virtual)
-- -------------------------------------------------------


-- ============================================================
-- SECTION 1: DDL (Data Definition Language)
-- ============================================================
-- DDL commands define and manage the STRUCTURE of database objects.
-- They do NOT deal with the actual data inside tables.

-- 1. CREATE  → Creates a new object (table, view, index, etc.)
-- 2. ALTER   → Modifies an existing object (add/remove columns, etc.)
-- 3. DROP    → Permanently deletes an object


-- ============================================================
-- SECTION 2: WHAT IS A TABLE?
-- ============================================================
-- A table is a structured collection of data,
-- similar to a spreadsheet or Excel grid.
-- It has ROWS (records) and COLUMNS (fields).

-- TABLE TYPES:
-- 1. Permanent Table   → Stored permanently in the database
-- 2. Temporary Table   → Lives only during the session (#TableName)


-- ============================================================
-- SECTION 3: CREATE TABLE (Traditional Method)
-- ============================================================
-- STEP 1 → Create an empty table with structure
-- STEP 2 → Insert data into it separately

-- SYNTAX:
-- -------------------------------------------------------
CREATE TABLE Employees
(
    EmployeeID   INT,
    EmployeeName VARCHAR(50),
    Department   VARCHAR(50),
    Salary       DECIMAL(10,2)
);

-- STEP 2: Insert data row by row
INSERT INTO Employees VALUES (1, 'Alice',   'HR',      55000.00);
INSERT INTO Employees VALUES (2, 'Bob',     'Finance', 62000.00);
INSERT INTO Employees VALUES (3, 'Charlie', 'IT',      70000.00);

-- Result in Employees table:
-- ┌────────────┬──────────────┬────────────┬──────────┐
-- │ EmployeeID │ EmployeeName │ Department │  Salary  │
-- ├────────────┼──────────────┼────────────┼──────────┤
-- │     1      │    Alice     │    HR      │ 55000.00 │
-- │     2      │    Bob       │   Finance  │ 62000.00 │
-- │     3      │    Charlie   │    IT      │ 70000.00 │
-- └────────────┴──────────────┴────────────┴──────────┘


-- ============================================================
-- SECTION 4: CTAS (Create Table As Select)
-- ============================================================
-- Creates a NEW table and fills it with data in ONE step
-- using the result of a SELECT query.
-- No need for a separate INSERT statement.

-- STEP 1 → Write a SELECT query
-- STEP 2 → The result is stored directly as a new table

-- SYNTAX (MySQL / PostgreSQL / Oracle):
-- -------------------------------------------------------
--  CREATE TABLE new_table_name AS
--  (
--      SELECT column1, column2, ...
--      FROM   existing_table
--      WHERE  condition
--  );

-- SYNTAX (SQL Server — uses SELECT INTO):
-- -------------------------------------------------------
SELECT EmployeeID, EmployeeName, Department, Salary
INTO   IT_Employees                  -- new table is created here
FROM   Employees
WHERE  Department = 'IT';

-- Result: A brand new table IT_Employees is created
-- and already contains Charlie's record from Employees.


-- ============================================================
-- SECTION 5: VIEW
-- ============================================================
-- A VIEW is a VIRTUAL table.
-- It stores only a QUERY definition, NOT the actual data.
-- Every time you SELECT from a view, the query runs FRESH.

-- SYNTAX:
-- -------------------------------------------------------
CREATE VIEW vw_Employees AS
    SELECT EmployeeID, EmployeeName, Department, Salary
    FROM   Employees;

-- When you run:
SELECT * FROM vw_Employees;
-- The SELECT query inside the view executes NOW and returns live data.


-- ============================================================
-- SECTION 6: CTAS vs VIEW — KEY DIFFERENCES
-- ============================================================

-- Setup: Main table has 3 rows: Row1, Row2, Row3

-- ┌─────────────────────┬──────────────────────────┬─────────────────────────┐
-- │      Feature        │  VIEW                    │  CTAS (SELECT INTO)     │
-- ├─────────────────────┼──────────────────────────┼─────────────────────────┤
-- │ When is query run?  │ At SELECT time (lazy)    │ At creation time (eager)│
-- │ Data stored?        │ NO — only query stored   │ YES — data is copied    │
-- │ Speed               │ Slower (reruns query)    │ Faster (pre-stored data)│
-- │ Reflects updates?   │ YES — always live data   │ NO — snapshot in time   │
-- │ Storage used?       │ Minimal                  │ Full copy of data       │
-- └─────────────────────┴──────────────────────────┴─────────────────────────┘

-- EXAMPLE: Main table has rows: 1, 2, 3
-- Now UPDATE main table: row 1 → 4, row 2 → 5 (row 3 stays)

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │  After update: Main table = { 4, 5, 3 }                                 │
-- │                                                                          │
-- │  SELECT * FROM vw_Employees;  → Returns { 4, 5, 3 }  ✅ (live/fresh)   │
-- │                                                                          │
-- │  SELECT * FROM IT_Employees;  → Returns { 1, 2, 3 }  ❌ (old snapshot) │
-- └──────────────────────────────────────────────────────────────────────────┘

-- USE VIEW   when you always need the LATEST data
-- USE CTAS   when you need a FAST, fixed snapshot for reporting/processing


-- ============================================================
-- SECTION 7: REAL-WORLD EXAMPLE SCENARIO
-- ============================================================

-- PROBLEM:
-- -------------------------------------------------------
-- Your organization has 2 large tables that need to be JOINed.
-- The JOIN query is complex and takes time to write.
-- Now 3 different departments use this combined data every day:
--
--   1. Financial Analyst  → wants RANK of orders
--   2. Budget Team        → wants MAX / MIN values
--   3. Risk Analyst       → wants to COMPARE figures
--
-- WITHOUT CTAS / VIEW:
--   Each person writes the full JOIN query EVERY TIME,
--   then adds their own calculation on top.
--   → Time-consuming, repetitive, and error-prone ❌

-- SOLUTION WITH CTAS:
-- -------------------------------------------------------
-- Create the joined/aggregated result ONCE as a CTAS table.
-- Now all 3 teams simply query THAT ONE TABLE.
-- No one needs to rewrite the JOIN ever again. ✅

-- Step 1: Create the CTAS table ONCE
SELECT
    DATENAME(MONTH, OrderDate)  AS OrderMonth,
    COUNT(OrderID)              AS TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate);

-- Step 2: Each team queries it directly — fast and simple
SELECT * FROM Sales.MonthlyOrders;                                   -- Financial Analyst: see all data
SELECT MAX(TotalOrders), MIN(TotalOrders) FROM Sales.MonthlyOrders;  -- Budget Team: max/min
SELECT OrderMonth, TotalOrders FROM Sales.MonthlyOrders              -- Risk Analyst: compare by month
ORDER BY TotalOrders DESC;

-- IMPORTANT NOTE:
-- CTAS stores data as a SNAPSHOT at creation time.
-- If new orders are added to Sales.Orders, the CTAS table
-- will NOT update automatically — it still holds OLD data.
-- You must DROP and recreate it to get fresh results.


-- ============================================================
-- SECTION 8: HOW TO REFRESH A CTAS TABLE
-- ============================================================

-- PROBLEM:
-- CTAS holds old data. New records added to the source table
-- are NOT reflected in the CTAS table automatically.

-- SOLUTION: Drop the old table and recreate it.

-- SAFE REFRESH PATTERN (always use this approach):
-- -------------------------------------------------------
IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
    DROP TABLE Sales.MonthlyOrders;
GO

SELECT
    DATENAME(MONTH, OrderDate)  AS OrderMonth,
    COUNT(OrderID)              AS TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate);
GO

-- HOW IT WORKS:
-- OBJECT_ID('Sales.MonthlyOrders', 'U') checks if the table exists.
--   'U' means User table.
-- If table EXISTS   → DROP it first, then recreate it fresh ✅
-- If table MISSING  → Skip DROP, just create it directly  ✅
-- This prevents errors when running the same script multiple times.


-- ============================================================
-- SECTION 9: QUICK SYNTAX REFERENCE
-- ============================================================

-- 1. CREATE TABLE (Manual — 2 steps)
-- -------------------------------------------------------
-- CREATE TABLE TableName
-- (
--     column1  datatype,
--     column2  datatype,
--     columnN  datatype
-- );
--
-- INSERT INTO TableName
-- VALUES (value1, value2, ..., valueN);


-- 2. CTAS — SQL Server (SELECT INTO)
-- -------------------------------------------------------
-- SELECT column1, column2, ...
-- INTO   NewTableName
-- FROM   SourceTable
-- WHERE  condition;


-- 3. CTAS — MySQL / PostgreSQL / Oracle
-- -------------------------------------------------------
-- CREATE TABLE NewTableName AS
-- (
--     SELECT column1, column2, ...
--     FROM   SourceTable
--     WHERE  condition
-- );


-- 4. CREATE VIEW
-- -------------------------------------------------------
-- CREATE VIEW ViewName AS
--     SELECT column1, column2, ...
--     FROM   SourceTable
--     WHERE  condition;


-- 5. SAFE CTAS REFRESH (Drop & Recreate)
-- -------------------------------------------------------
-- IF OBJECT_ID('SchemaName.TableName', 'U') IS NOT NULL
--     DROP TABLE SchemaName.TableName;
-- GO
-- SELECT column1, column2, ...
-- INTO   SchemaName.TableName
-- FROM   SourceTable
-- WHERE  condition;
-- GO


-- 6. ALTER TABLE (add a new column)
-- -------------------------------------------------------
-- ALTER TABLE TableName
-- ADD NewColumn datatype;


-- 7. DROP TABLE / DROP VIEW
-- -------------------------------------------------------
-- DROP TABLE TableName;
-- DROP VIEW  ViewName;


-- ============================================================
-- SECTION 10: TEMPORARY TABLES
-- ============================================================
-- A Temporary Table stores intermediate results in temporary
-- storage (tempdb) during a session.
-- SQL Server automatically drops all temp tables when the
-- session ends — no manual cleanup needed.

-- SESSION = The time between connecting to and disconnecting
--           from the database.

-- WHERE IS TEMPDB?
-- -------------------------------------------------------
-- SQL Server → System Databases → tempdb → Temporary Tables

-- HOW SQL SERVER PROCESSES A QUERY (background):
-- -------------------------------------------------------
--   1. You run:  SELECT * FROM Sales.Orders
--   2. Query is sent to the SQL Server Engine
--   3. Engine checks the System Cache first (fast memory)
--   4. If NOT in cache → reads from Disk (slower)
--   5. Data is returned to the client
--
-- Temporary tables live in tempdb (on disk + cache),
-- acting as a staging area between steps.

-- NAMING RULE:
-- -------------------------------------------------------
--   #TableName   → Local temp table  (visible to current session only)
--   ##TableName  → Global temp table (visible to ALL sessions)

-- ============================================================
-- SECTION 10A: PRACTICAL EXAMPLE — 3-STEP ETL PATTERN
-- ============================================================
-- A common real-world pattern:
--   Step 1 → Load raw data into a temp table
--   Step 2 → Clean / filter the data in the temp table
--   Step 3 → Push clean data into a permanent table
--
-- WHY use a temp table in the middle?
--   → Avoid modifying the original source table
--   → Test/validate data before writing it permanently
--   → Break a complex task into safe, manageable steps

-- -------------------------------------------------------
-- STEP 1: Load raw data into a temporary table (#Orders)
-- -------------------------------------------------------
SELECT *
INTO #Orders
FROM Sales.Orders;
-- A temp table #Orders is created in tempdb with ALL orders.
-- This is just a working copy — Sales.Orders is untouched.

-- -------------------------------------------------------
-- STEP 2: Clean the data inside the temp table
-- -------------------------------------------------------
DELETE FROM #Orders
WHERE OrderStatus = 'Delivered';
-- Delivered records are removed from #Orders.
-- Sales.Orders (the real table) is still unchanged.

-- -------------------------------------------------------
-- STEP 3: Push clean data into a permanent table
-- -------------------------------------------------------
SELECT *
INTO Sales.OrdersTest
FROM #Orders;
-- Only the non-Delivered orders are saved to Sales.OrdersTest.
-- This is now a real permanent table in the database.

-- ┌──────────────────────────────────────────────────────────────────────┐
-- │  FLOW SUMMARY                                                        │
-- │                                                                      │
-- │  Sales.Orders (source, untouched)                                   │
-- │       │                                                              │
-- │       │  SELECT * INTO #Orders                                       │
-- │       ▼                                                              │
-- │  #Orders in tempdb  ──── DELETE WHERE Status = 'Delivered'          │
-- │       │                                                              │
-- │       │  SELECT * INTO Sales.OrdersTest                             │
-- │       ▼                                                              │
-- │  Sales.OrdersTest (clean permanent table) ✅                        │
-- └──────────────────────────────────────────────────────────────────────┘


-- ============================================================
-- SECTION 10B: TEMPORARY TABLE vs CTAS vs VIEW
-- ============================================================

-- ┌──────────────────┬──────────────────┬──────────────────┬──────────────────┐
-- │    Feature       │  Temp Table (#)  │  CTAS            │  VIEW            │
-- ├──────────────────┼──────────────────┼──────────────────┼──────────────────┤
-- │ Where stored?    │ tempdb (system)  │ Your schema      │ No storage       │
-- │ Data stored?     │ YES              │ YES              │ NO (query only)  │
-- │ Auto deleted?    │ YES (on logout)  │ NO (permanent)   │ NO (permanent)   │
-- │ Reflects source? │ NO (snapshot)    │ NO (snapshot)    │ YES (live)       │
-- │ Best used for    │ Staging/cleaning │ Reporting copy   │ Live data access │
-- └──────────────────┴──────────────────┴──────────────────┴──────────────────┘


-- ============================================================
-- UPDATED QUICK SYNTAX REFERENCE
-- ============================================================

-- 1. CREATE TABLE (Manual — 2 steps)
-- -------------------------------------------------------
-- CREATE TABLE TableName
-- (
--     column1  datatype,
--     column2  datatype,
--     columnN  datatype
-- );
-- INSERT INTO TableName VALUES (value1, value2, ..., valueN);


-- 2. CTAS — SQL Server (SELECT INTO)
-- -------------------------------------------------------
-- SELECT column1, column2, ...
-- INTO   NewTableName
-- FROM   SourceTable
-- WHERE  condition;


-- 3. CTAS — MySQL / PostgreSQL / Oracle
-- -------------------------------------------------------
-- CREATE TABLE NewTableName AS
-- (
--     SELECT column1, column2, ...
--     FROM   SourceTable
--     WHERE  condition
-- );


-- 4. CREATE VIEW
-- -------------------------------------------------------
-- CREATE VIEW ViewName AS
--     SELECT column1, column2, ...
--     FROM   SourceTable
--     WHERE  condition;


-- 5. SAFE CTAS REFRESH (Drop & Recreate)
-- -------------------------------------------------------
-- IF OBJECT_ID('SchemaName.TableName', 'U') IS NOT NULL
--     DROP TABLE SchemaName.TableName;
-- GO
-- SELECT column1, column2, ...
-- INTO   SchemaName.TableName
-- FROM   SourceTable
-- WHERE  condition;
-- GO


-- 6. TEMPORARY TABLE — Load → Clean → Promote pattern
-- -------------------------------------------------------
-- SELECT * INTO #TempTable FROM SourceTable;          -- Step 1: Load
-- DELETE FROM #TempTable WHERE condition;             -- Step 2: Clean
-- SELECT * INTO Schema.PermanentTable FROM #TempTable;-- Step 3: Promote


-- 7. ALTER TABLE (add a new column)
-- -------------------------------------------------------
-- ALTER TABLE TableName
-- ADD NewColumn datatype;


-- 8. DROP TABLE / DROP VIEW
-- -------------------------------------------------------
-- DROP TABLE TableName;
-- DROP VIEW  ViewName;
-- (Temp tables drop automatically when session ends)

-- ============================================================
--                        END OF NOTES
-- ============================================================