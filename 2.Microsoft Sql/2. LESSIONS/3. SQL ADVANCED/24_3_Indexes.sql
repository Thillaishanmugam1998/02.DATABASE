/* ==============================================================================
   SQL Indexing
-------------------------------------------------------------------------------
   This script demonstrates various index types in SQL Server including clustered,
   non-clustered, columnstore, unique, and filtered indexes. It provides examples 
   of creating a heap table, applying different index types, and testing their 
   usage with sample queries.

   Table of Contents:
	   Index Types:
			 - Clustered and Non-Clustered Indexes
			 - Leftmost Prefix Rule Explanation
			 - Columnstore Indexes
			 - Unique Indexes
			 - Filtered Indexes
		Index Monitoring:
			 - Monitor Index Usage
			 - Monitor Missing Indexes
			 - Monitor Duplicate Indexes
			 - Update Statistics
			 - Fragmentations
=================================================================================
*/



/* =================================================================================================
SECTION 1 — WHAT IS AN INDEX?
----------------------------------------------------------------------------------------------------
An Index is a database object that improves the speed of data retrieval operations on a table.

Without Index:
    SQL Server performs a TABLE SCAN (reads the entire table).

With Index:
    SQL Server performs an INDEX SEEK (directly finds required rows).

Real Life Example:
    Think about a BOOK.
    If you want to find "SQL Server" in a 500-page book:

    Without index → read page by page.
    With index → go to index page → jump to the correct page instantly.

This is exactly how database indexing works.
================================================================================================= */


/* =================================================================================================
SECTION 2 — HOW INDEX STRUCTURE WORKS (B-TREE STRUCTURE)
----------------------------------------------------------------------------------------------------

SQL Server uses a B-Tree structure for indexes.

Structure:

        Root Node
            ↓
     Intermediate Nodes
            ↓
        Leaf Nodes

Root Node:
    Entry point of the index.

Intermediate Nodes:
    Helps navigate to correct data location.

Leaf Nodes:
    Clustered Index → contains actual data rows
    Non‑Clustered Index → contains key + pointer to data

This structure allows SQL Server to locate rows very quickly.
================================================================================================= */


/* =================================================================================================
SECTION 3 — INDEX STORAGE TYPES
----------------------------------------------------------------------------------------------------

SQL Server mainly uses two storage types.

1. ROWSTORE INDEX
   Data stored row-by-row.

   Example:

   ID | Name  | Salary
   --------------------
   1  | John  | 50000
   2  | Maria | 60000


2. COLUMNSTORE INDEX
   Data stored column-by-column.

   ID Column:
   1
   2

   Name Column:
   John
   Maria

Columnstore indexes are used mainly for analytics and reporting systems.
================================================================================================= */


/* =================================================================================================
SECTION 4 — CLUSTERED INDEX (Structure)
----------------------------------------------------------------------------------------------------

Definition:
A Clustered Index sorts and stores the actual table data based on the index key.

Important Rule:
    Only ONE clustered index per table.

Why?
    Because the table rows themselves are stored in sorted order.

Example:
================================================================================================= */

CREATE CLUSTERED INDEX IX_Employees_EmployeeID
ON Employees(EmployeeID);
GO


/* Example Table After Clustered Index */

-- EmployeeID | Name
-- 1          | John
-- 2          | Maria
-- 3          | David

/* Leaf nodes contain the actual table data */


/* =================================================================================================
SECTION 5 — NON-CLUSTERED INDEX (Structure)
----------------------------------------------------------------------------------------------------

Definition:
A Non-Clustered Index is a separate structure that stores:

    Index Key + Pointer to actual row

Example:
================================================================================================= */

CREATE NONCLUSTERED INDEX IX_Employees_Department
ON Employees(Department);
GO

/* Example Structure */

-- Department | Row Pointer
-- HR         | Row 2
-- IT         | Row 1
-- IT         | Row 3

/* SQL Server first finds the row in index then fetches actual data */


/* =================================================================================================
SECTION 6 — COLUMNSTORE INDEX   (Storage)
----------------------------------------------------------------------------------------------------

Used for data warehouse / analytics queries.

Instead of storing rows:

Row Storage:
1 John 50000
2 Maria 60000

Column Storage:

ID column
1
2

Name column
John
Maria

Salary column
50000
60000
================================================================================================= */

CREATE CLUSTERED COLUMNSTORE INDEX IX_Sales_ColumnStore
ON Sales;
GO


/* =================================================================================================
SECTION 7 — OTHER IMPORTANT INDEX TYPES
----------------------------------------------------------------------------------------------------

1. COMPOSITE INDEX
   Index on multiple columns
================================================================================================= */

CREATE INDEX IX_Orders_Customer_OrderDate
ON Orders(CustomerID, OrderDate);
GO


/* UNIQUE INDEX
Ensures column values are unique */

CREATE UNIQUE INDEX IX_Users_Email
ON Users(Email);
GO


/* FILTERED INDEX
Index only part of a table */

CREATE INDEX IX_Users_Active
ON Users(Status)
WHERE Status = 'Active';
GO


/* =================================================================================================
SECTION 8 — FUNCTIONS OF INDEXES
----------------------------------------------------------------------------------------------------

Indexes improve performance of:

1. WHERE clause
2. JOIN operations
3. ORDER BY
4. GROUP BY

Example:
================================================================================================= */

SELECT *
FROM Employees
WHERE EmployeeID = 10;
GO


/* =================================================================================================
SECTION 9 — REAL TIME EXAMPLE (E-COMMERCE SYSTEM)
----------------------------------------------------------------------------------------------------

Table:
Orders

Query used thousands of times:

SELECT *
FROM Orders
WHERE CustomerID = 100

To improve performance we create index:
================================================================================================= */

CREATE INDEX IX_Orders_CustomerID
ON Orders(CustomerID);
GO


/* =================================================================================================
SECTION 10 — WHEN NOT TO USE INDEXES
----------------------------------------------------------------------------------------------------

Avoid indexes on:

• Small tables
• Frequently updated columns
• Low cardinality columns (Gender, Status)

Because indexes slow down:

INSERT
UPDATE
DELETE

SQL Server must update indexes whenever table data changes.
================================================================================================= */


/* =================================================================================================
SECTION 11 — PERFORMANCE ANALYSIS
----------------------------------------------------------------------------------------------------

Use Execution Plan in SQL Server Management Studio.

Good Plan:
    INDEX SEEK

Bad Plan:
    TABLE SCAN

You can also use:

SET STATISTICS IO ON
SET STATISTICS TIME ON

to analyze query performance.
================================================================================================= */



/* ==============================================================================
   Clustered and Non-Clustered Indexes
============================================================================== */

-- Create a Heap Table as a copy of Sales.Customers 
SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers;

-- Test Query: Select Data and Check the Execution Plan
SELECT *
FROM Sales.DBCustomers
WHERE CustomerID = 1;

-- Create a Clustered Index on Sales.DBCustomers using CustomerID
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID);

-- Attempt to create a second Clustered Index on the same table (will fail) 
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID);

-- Drop the Clustered Index 
DROP INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers;

-- Test Query: Select Data with a Filter on LastName
SELECT *
FROM Sales.DBCustomers
WHERE LastName = 'Brown';

-- Create a Non-Clustered Index on LastName
CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName);

-- Create an additional Non-Clustered Index on FirstName
CREATE INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName);

-- Create a Composite (Composed) Index on Country and Score 
CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score);

-- Query that uses the Composite Index
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA'
  AND Score > 500;

-- Query that likely won't use the Composite Index due to column order
SELECT *
FROM Sales.DBCustomers
WHERE Score > 500
  AND Country = 'USA';

/* ==============================================================================
   Leftmost Prefix Rule Explanation
-------------------------------------------------------------------------------
   For a composite index defined on columns (A, B, C, D), the index can be
   utilized by queries that filter on:
     - Column A only,
     - Columns A and B,
     - Columns A, B, and C.
   However, queries that filter on:
     - Column B only,
     - Columns A and C,
     - Columns A, B, and D,
   will not be able to fully utilize the index due to the leftmost prefix rule.
=================================================================================
*/

/* ==============================================================================
   Columnstore Indexes
============================================================================== */

-- Create a Clustered Columnstore Index on Sales.DBCustomers
CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON Sales.DBCustomers;
GO

-- Create a Non-Clustered Columnstore Index on the FirstName column
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.DBCustomers (FirstName);
GO

-- Switch context to AdventureWorksDW2022 for FactInternetSales examples */
USE AdventureWorksDW2022;

-- Create a Heap Table from FactInternetSales
SELECT *
INTO FactInternetSales_HP
FROM FactInternetSales;

-- Create a RowStore Table from FactInternetSales
SELECT *
INTO FactInternetSales_RS
FROM FactInternetSales;

-- Create a Clustered Index (RowStore) on FactInternetSales_RS
CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK
ON FactInternetSales_RS (SalesOrderNumber, SalesOrderLineNumber);

-- Create a Columnstore Table from FactInternetSales
SELECT *
INTO FactInternetSales_CS
FROM FactInternetSales;

-- Create a Clustered Columnstore Index on FactInternetSales_CS
CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_PK
ON FactInternetSales_CS;

/* ==============================================================================
   Unique Indexes
============================================================================== */

-- Attempt to create a Unique Index on the Category column in Sales.Products.
   Note: This may fail if duplicate values exist.

CREATE UNIQUE INDEX idx_Products_Category
ON Sales.Products (Category);
  
-- Create a Unique Index on the Product column in Sales.Products
CREATE UNIQUE INDEX idx_Products_Product
ON Sales.Products (Product);
  
-- Test Insert: Attempt to insert a duplicate value (should fail if the constraint is enforced)
INSERT INTO Sales.Products (ProductID, Product)
VALUES (106, 'Caps');

/* ==============================================================================
   Filtered Indexes
============================================================================== */

-- Test Query: Select Customers where Country is 'USA' 
SELECT *
FROM Sales.Customers
WHERE Country = 'USA';
  
-- Create a Non-Clustered Filtered Index on the Country column for rows where Country = 'USA'
CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers (Country)
WHERE Country = 'USA';

/* ==============================================================================
   Index Monitoring
-------------------------------------------------------------------------------
     - List indexes and monitor their usage.
     - Report missing and duplicate indexes.
     - Retrieve and update statistics.
     - Check index fragmentation and perform index maintenance (reorganize/rebuild).
=================================================================================
*/

/* ==============================================================================
   Monitor Index Usage
============================================================================== */

-- List all indexes on a specific table
sp_helpindex 'Sales.DBCustomers'

-- Monitor Index Usage
SELECT 
	tbl.name AS TableName,
    idx.name AS IndexName,
    idx.type_desc AS IndexType,
    idx.is_primary_key AS IsPrimaryKey,
    idx.is_unique AS IsUnique,
    idx.is_disabled AS IsDisabled,
    s.user_seeks AS UserSeeks,
    s.user_scans AS UserScans,
    s.user_lookups AS UserLookups,
    s.user_updates AS UserUpdates,
    COALESCE(s.last_user_seek, s.last_user_scan) AS LastUpdate
FROM sys.indexes idx
JOIN sys.tables tbl
    ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
    ON s.object_id = idx.object_id
    AND s.index_id = idx.index_id
ORDER BY tbl.name, idx.name;

/* ==============================================================================
   Monitor Missing Indexes
============================================================================== */

SELECT * 
FROM sys.dm_db_missing_index_details;

/* ==============================================================================
   Monitor Duplicate Indexes
============================================================================== */

SELECT  
	tbl.name AS TableName,
	col.name AS IndexColumn,
	idx.name AS IndexName,
	idx.type_desc AS IndexType,
	COUNT(*) OVER (PARTITION BY  tbl.name , col.name ) ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC

/* ==============================================================================
   Update Statistics
============================================================================== */

SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    s.name AS StatisticName,
    sp.last_updated AS LastUpdate,
    DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdateDay,
    sp.rows AS 'Rows',
    sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables AS t
    ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY sp.modification_counter DESC;

-- Update statistics for a specific automatically created system statistic
UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000001_6EF57B66;
GO

-- Update all statistics for the Sales.DBCustomers table
UPDATE STATISTICS Sales.DBCustomers;
GO

-- Update statistics for all tables in the database
EXEC sp_updatestats;
GO

/* ==============================================================================
   Fragementations
============================================================================== */

-- Retrieve index fragmentation statistics for the current database
SELECT 
    tbl.name AS TableName,
    idx.name AS IndexName,
    s.avg_fragmentation_in_percent,
    s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s
INNER JOIN sys.tables tbl 
    ON s.object_id = tbl.object_id
INNER JOIN sys.indexes AS idx 
    ON idx.object_id = s.object_id
    AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC;

-- Reorganize the index (lightweight defragmentation)
ALTER INDEX idx_Customers_CS_Country 
ON Sales.Customers REORGANIZE;
GO

-- Rebuild the index (full rebuild, more resource-intensive)
ALTER INDEX idx_Customers_Country 
ON Sales.Customers REBUILD;
GO





