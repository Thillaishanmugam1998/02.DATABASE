/* ==============================================================================
   SQL INDEXING - COMPLETE GUIDE
   Tamil Explanation with Examples
   
   TABLE OF CONTENTS:
   ------------------
   SECTION 1  : SQL Database Files (.MDF & .LDF)
   SECTION 2  : Pages & Extents (Data Storage)
   SECTION 3  : INDEX NA ENNA? (What is an Index?)
   SECTION 4  : WITHOUT INDEX - Table Scan
   SECTION 5  : WITH INDEX - B-Tree Structure
   SECTION 6  : CLUSTERED INDEX
   SECTION 7  : NON-CLUSTERED INDEX
   SECTION 8  : COMPOSITE INDEX + Leftmost Prefix Rule
   SECTION 9  : UNIQUE INDEX
   SECTION 10 : FILTERED INDEX
   SECTION 11 : COLUMNSTORE INDEX
   SECTION 12 : INDEX MONITORING
   SECTION 13 : MISSING INDEXES
   SECTION 14 : DUPLICATE INDEXES
   SECTION 15 : UPDATE STATISTICS
   SECTION 16 : FRAGMENTATION
   SECTION 17 : WHEN NOT TO USE INDEX
   SECTION 18 : PRACTICAL DEMO (Full Working Example)
============================================================================== */



/* ==============================================================================
   SECTION 1 — SQL DATABASE FILES (.MDF & .LDF)
--------------------------------------------------------------------------------

   PC la SQL Server database 2 main files la store aagum:

   📁 C:\Program Files\Microsoft SQL Server\MSSQL\DATA\
       ├── YourDatabase.mdf   ← ACTUAL DATA (tables, indexes, everything)
       └── YourDatabase.ldf   ← TRANSACTION LOG (every change record)

   .MDF FILE (Main Data File):
   ---------------------------
   • Actual table data store aagum
   • Indexes store aagum
   • Stored Procedures, Views ellam inga thaan
   • Oru database ku mandatory - oru .mdf file

   .LDF FILE (Log Data File):
   --------------------------
   • Every INSERT / UPDATE / DELETE record vaikkum
   • Transaction rollback ku use aagum (UNDO)
   • Database recovery ku use aagum
   • Oru database ku at least oru .ldf file

   DATABASE FILES PAAKKA:
============================================================================== */

-- Current database files info
SELECT 
    name AS FileName,
    physical_name AS FilePath,
    type_desc AS FileType,           -- ROWS = .mdf, LOG = .ldf
    size * 8 / 1024 AS SizeMB,
    max_size AS MaxSize
FROM sys.database_files;
GO



/* ==============================================================================
   SECTION 2 — PAGES & EXTENTS (Data Epdi Store Aagum?)
--------------------------------------------------------------------------------

   SQL Server data "PAGES" la store aagum.

   PAGE:
   -----
   • Smallest storage unit in SQL Server
   • Size = 8 KB (8192 bytes)
   • Oru page la approx 8-10 rows store aagum (row size pongadhu)

   EXTENT:
   -------
   • 8 Pages = 1 Extent
   • Size = 64 KB

   VISUAL:
   -------
   MDF File
   │
   ├── Extent 1 (64KB)
   │    ├── Page 1 (8KB): [Row1][Row2][Row3]...
   │    ├── Page 2 (8KB): [Row4][Row5][Row6]...
   │    └── Page 3-8 ...
   │
   └── Extent 2 (64KB)
        └── Page 9-16 ...

   PAGE TYPES:
   -----------
   • Data Page       → Actual table rows
   • Index Page      → Index B-Tree nodes
   • LOB Page        → Large data (TEXT, IMAGE, VARCHAR(MAX))

============================================================================== */

-- Page info paakka
DBCC PAGE('YourDatabase', 1, 1, 3); -- (database, fileID, pageID, printOption)
GO



/* ==============================================================================
   SECTION 3 — INDEX NA ENNA? (What is an Index?)
--------------------------------------------------------------------------------

   INDEX = Database object that speeds up data retrieval.

   REAL LIFE EXAMPLE:
   ------------------
   📚 500 Page Book la "SQL Server" topic theda:

   WITHOUT INDEX → Page 1 paaru... Page 2 paaru... Page 347 la kettan!
                   (347 pages waste - SLOW 🐌)

   WITH INDEX    → Book back la index → "SQL Server → Page 347"
                   Directly jump! (FAST 🚀)

   DATABASE LA SAME CONCEPT:

   WITHOUT INDEX → TABLE SCAN  (reads every single row)
   WITH INDEX    → INDEX SEEK  (directly finds required rows)

============================================================================== */



/* ==============================================================================
   SECTION 4 — WITHOUT INDEX (Table Scan - How Data is Fetched)
--------------------------------------------------------------------------------

   Heap Table = Index இல்லாத table
   SQL Server does FULL TABLE SCAN

   EXAMPLE:
   --------
   SELECT * FROM Customers WHERE CustomerID = 100;

   WHAT HAPPENS:
   Page 1  → CustomerID = 1, 2, 3...    not found
   Page 2  → CustomerID = 10, 11, 12... not found
   Page 3  → CustomerID = 25, 26, 27... not found
   ...
   Page 25 → CustomerID = 100 ✅ FOUND!

   ❌ Problem: 25 pages scan pannanum!
   10 million rows irundha = 10 million rows scan = VERY SLOW!

   EXECUTION PLAN LA KAANUM: "Table Scan" or "Clustered Index Scan"

============================================================================== */

-- Demo: Heap table create pannu (no index)
CREATE TABLE Demo_Heap (
    CustomerID   INT,
    FirstName    NVARCHAR(50),
    LastName     NVARCHAR(50),
    Email        NVARCHAR(100),
    Country      NVARCHAR(50),
    Score        INT
);

-- Sample data insert
INSERT INTO Demo_Heap VALUES (1,  'Ravi',   'Kumar',  'ravi@mail.com',   'India', 850);
INSERT INTO Demo_Heap VALUES (2,  'Priya',  'Devi',   'priya@mail.com',  'India', 720);
INSERT INTO Demo_Heap VALUES (3,  'John',   'Brown',  'john@mail.com',   'USA',   640);
INSERT INTO Demo_Heap VALUES (4,  'Maria',  'Smith',  'maria@mail.com',  'USA',   910);
INSERT INTO Demo_Heap VALUES (5,  'Arun',   'Raja',   'arun@mail.com',   'India', 780);

-- This will do TABLE SCAN (Ctrl+M for execution plan in SSMS)
SELECT * FROM Demo_Heap WHERE CustomerID = 4;
GO



/* ==============================================================================
   SECTION 5 — WITH INDEX (B-Tree Structure - How Index Works)
--------------------------------------------------------------------------------

   SQL Server uses B-TREE (Balanced Tree) structure for indexes.

   B-TREE STRUCTURE:
   -----------------

                        ROOT NODE
                       [50 | 100]
                      /     |     \
                    /        |      \
        [10|20|30]      [60|70|80]    [110|120]
        /  |  |  \          |               \
       ↓   ↓  ↓   ↓         ↓                ↓
   LEAF   LEAF LEAF LEAF   LEAF             LEAF
   NODES (Bottom level)

   HOW SEARCH WORKS (CustomerID = 100):
   1. Root Node check: "100 is >= 100, go right"
   2. Intermediate Node: "100 found here"
   3. Leaf Node: Get actual data!
   Only 3 STEPS! vs 1,000,000 rows scan!

   LEAF NODE CONTENT:
   ------------------
   Clustered Index     → Leaf = ACTUAL DATA ROW
   Non-Clustered Index → Leaf = KEY + POINTER to data row

============================================================================== */



/* ==============================================================================
   SECTION 6 — CLUSTERED INDEX
--------------------------------------------------------------------------------

   DEFINITION:
   -----------
   • Sorts & stores ACTUAL TABLE DATA based on index key
   • Only ONE clustered index per table (data oru orderla mattum store aagum)
   • Primary Key create pannum bodhu AUTO CREATE aagum
   • Leaf nodes = Actual data rows

   BEFORE CLUSTERED INDEX (Heap - unsorted):
   CustomerID | Name    | City
   5          | Ravi    | Chennai
   1          | Kumar   | Delhi
   3          | Priya   | Mumbai
   2          | Arun    | Kolkata

   AFTER CLUSTERED INDEX ON CustomerID (Physically sorted!):
   CustomerID | Name    | City
   1          | Kumar   | Delhi
   2          | Arun    | Kolkata
   3          | Priya   | Mumbai
   5          | Ravi    | Chennai

============================================================================== */

-- Step 1: Table la irukka indexes paaru
EXEC sp_helpindex 'Demo_Heap';

-- Step 2: Clustered Index create pannu
CREATE CLUSTERED INDEX idx_Heap_CustomerID
ON Demo_Heap (CustomerID);
GO

-- Now data is physically sorted by CustomerID
-- This will do INDEX SEEK (check execution plan)
SELECT * FROM Demo_Heap WHERE CustomerID = 4;
GO

-- Step 3: Second Clustered Index try pannu - ERROR varum!
-- CREATE CLUSTERED INDEX idx_Heap_CustomerID_2
-- ON Demo_Heap (CustomerID);
-- ERROR: Cannot create more than one clustered index on table 'Demo_Heap'

-- Step 4: Drop Clustered Index
DROP INDEX idx_Heap_CustomerID ON Demo_Heap;
GO



/* ==============================================================================
   SECTION 7 — NON-CLUSTERED INDEX
--------------------------------------------------------------------------------

   DEFINITION:
   -----------
   • Separate structure create aagum (original table touch aagadhu)
   • Leaf node = Key value + Row Pointer (RID or Clustered Key)
   • Oru table ku 999 non-clustered indexes varai possible
   • Original data order change aagadhu

   NON-CLUSTERED INDEX STRUCTURE:
   --------------------------------
   ┌────────────────────────────────────┐
   │  LastName   │  Row Pointer         │
   │─────────────│──────────────────────│
   │  Arun       │ → Page 3, Row 2      │
   │  Brown      │ → Page 1, Row 1      │
   │  Devi       │ → Page 2, Row 1      │
   │  Kumar      │ → Page 1, Row 3      │
   └────────────────────────────────────┘
            ↓
   SQL Server pointer follow pannி actual row fetch aagum
   (This extra step = KEY LOOKUP)

============================================================================== */

-- Non-Clustered Index on LastName
CREATE NONCLUSTERED INDEX idx_Heap_LastName
ON Demo_Heap (LastName);
GO

-- This will use Non-Clustered Index
SELECT * FROM Demo_Heap WHERE LastName = 'Kumar';
GO

-- Another Non-Clustered Index on FirstName
CREATE NONCLUSTERED INDEX idx_Heap_FirstName
ON Demo_Heap (FirstName);
GO

-- Check all indexes on table
EXEC sp_helpindex 'Demo_Heap';
GO



/* ==============================================================================
   SECTION 8 — COMPOSITE INDEX + LEFTMOST PREFIX RULE
--------------------------------------------------------------------------------

   DEFINITION:
   -----------
   Index on MULTIPLE COLUMNS.

   LEFTMOST PREFIX RULE:
   ---------------------
   Index: (A, B, C, D) irundha:

   ✅ USE AAGUM (index works):
      WHERE A = ?
      WHERE A = ? AND B = ?
      WHERE A = ? AND B = ? AND C = ?
      WHERE A = ? AND B = ? AND C = ? AND D = ?

   ❌ USE AAGADHU (index won't work / partial):
      WHERE B = ?              ← A skip pannita
      WHERE C = ?              ← A, B skip pannita
      WHERE A = ? AND C = ?   ← B skip pannita (partial use only)

   REAL EXAMPLE (Phone Directory):
   --------------------------------
   Index: (LastName, FirstName)

   "Brown" search           → ✅ Works (leftmost column)
   "Brown, John" search     → ✅ Works (both columns in order)
   "John" alone search      → ❌ Doesn't work (skipped LastName)

============================================================================== */

-- Composite Index on Country + Score
CREATE INDEX idx_Heap_Country_Score
ON Demo_Heap (Country, Score);
GO

-- ✅ This USES the index (Country is leftmost)
SELECT * FROM Demo_Heap
WHERE Country = 'India' AND Score > 700;
GO

-- ✅ This also USES the index (Country alone = leftmost prefix)
SELECT * FROM Demo_Heap
WHERE Country = 'USA';
GO

-- ❌ This may NOT fully use the index (Score alone, Country skipped)
SELECT * FROM Demo_Heap
WHERE Score > 700;
GO

-- Drop composite index
DROP INDEX idx_Heap_Country_Score ON Demo_Heap;
GO



/* ==============================================================================
   SECTION 9 — UNIQUE INDEX
--------------------------------------------------------------------------------

   DEFINITION:
   -----------
   • Duplicate values allow பண்ணாது
   • NULL value oru thadavai mattum allow (depends on version)
   • UNIQUE CONSTRAINT create pannum bodhu also creates unique index

   USE CASES:
   ----------
   • Email column
   • Phone Number
   • PAN Card Number
   • Username

============================================================================== */

-- Unique Index on Email
CREATE UNIQUE INDEX idx_Heap_Email
ON Demo_Heap (Email);
GO

-- ✅ This works
INSERT INTO Demo_Heap VALUES (6, 'Kiran', 'Raj', 'kiran@mail.com', 'India', 660);
GO

-- ❌ This FAILS - duplicate email
-- INSERT INTO Demo_Heap VALUES (7, 'Test', 'User', 'ravi@mail.com', 'India', 500);
-- ERROR: Cannot insert duplicate key row in object 'Demo_Heap'

-- Drop unique index
DROP INDEX idx_Heap_Email ON Demo_Heap;
GO



/* ==============================================================================
   SECTION 10 — FILTERED INDEX
--------------------------------------------------------------------------------

   DEFINITION:
   -----------
   • Table la SPECIFIC ROWS மட்டும் index பண்ணும்
   • WHERE clause use pannி filter பண்ணலாம்
   • Smaller index = Faster queries + Less storage

   USE CASE EXAMPLE:
   -----------------
   Orders table:
   Status = 'Active'    →   10,000 rows   ← Index only this!
   Status = 'Completed' →  500,000 rows   ← Skip - queries rare
   Status = 'Cancelled' →  200,000 rows   ← Skip

   Benefits:
   • Index size much smaller
   • Queries for Active orders super fast
   • Less maintenance when data changes

============================================================================== */

-- Filtered Index: Only India customers
CREATE NONCLUSTERED INDEX idx_Heap_India_Customers
ON Demo_Heap (CustomerID, Score)
WHERE Country = 'India';
GO

-- This query USES the filtered index
SELECT CustomerID, Score
FROM Demo_Heap
WHERE Country = 'India' AND Score > 700;
GO

-- Drop filtered index
DROP INDEX idx_Heap_India_Customers ON Demo_Heap;
GO



/* ==============================================================================
   SECTION 11 — COLUMNSTORE INDEX
--------------------------------------------------------------------------------

   DEFINITION:
   -----------
   • Data column-by-column store aagum (not row by row)
   • Analytics / Reporting / Data Warehouse ku best
   • Amazing compression - storage space miga kammiyaagum
   • Batch mode execution - very fast aggregations

   ROWSTORE vs COLUMNSTORE:
   -------------------------
   ROWSTORE (Normal):              COLUMNSTORE:
   ──────────────────              ──────────────────
   1 | John  | 50000              ID Column:
   2 | Maria | 60000       →      1, 2, 3, 4, 5...
   3 | David | 70000
                                   Name Column:
                                   John, Maria, David...

                                   Salary Column:
                                   50000, 60000, 70000...

   QUERY PERFORMANCE EXAMPLE:
   --------------------------
   SELECT SUM(Salary) FROM Employees

   Rowstore  → Every row full scan (ID + Name + Salary all read)
   Columnstore → ONLY Salary column read! Others skip! 🚀

   TYPES:
   ------
   1. Clustered Columnstore   → Entire table as columnstore
   2. Non-Clustered Columnstore → Subset of columns as columnstore

============================================================================== */

-- Create a table for columnstore demo
CREATE TABLE Demo_Sales (
    SaleID      INT,
    ProductID   INT,
    CustomerID  INT,
    SaleDate    DATE,
    Quantity    INT,
    Amount      DECIMAL(10,2),
    Region      NVARCHAR(50)
);

-- Insert sample data
INSERT INTO Demo_Sales VALUES (1, 101, 1, '2024-01-15', 5,  2500.00, 'South');
INSERT INTO Demo_Sales VALUES (2, 102, 2, '2024-01-16', 3,  1500.00, 'North');
INSERT INTO Demo_Sales VALUES (3, 101, 3, '2024-02-10', 8,  4000.00, 'South');
INSERT INTO Demo_Sales VALUES (4, 103, 1, '2024-02-20', 2,  800.00,  'East');
INSERT INTO Demo_Sales VALUES (5, 102, 4, '2024-03-05', 10, 5000.00, 'West');
GO

-- Clustered Columnstore Index (entire table)
CREATE CLUSTERED COLUMNSTORE INDEX idx_Sales_CS
ON Demo_Sales;
GO

-- Analytics query - very fast with columnstore!
SELECT 
    Region,
    SUM(Amount)   AS TotalSales,
    AVG(Amount)   AS AvgSale,
    COUNT(*)      AS NumberOfSales
FROM Demo_Sales
GROUP BY Region;
GO

-- Non-Clustered Columnstore (specific columns)
-- (First drop clustered, then create non-clustered)
DROP INDEX idx_Sales_CS ON Demo_Sales;
GO

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_Sales_NCCS
ON Demo_Sales (SaleDate, Amount, Region);
GO



/* ==============================================================================
   SECTION 12 — INDEX MONITORING (Usage Stats)
--------------------------------------------------------------------------------

   Monitor cheyyanum:
   • Kontha indexes actually use aaguthu?
   • Kontha indexes waste space mட்டும் pannirukkuthu?
   • Last usage eppo?

============================================================================== */

-- All indexes + usage stats
SELECT 
    tbl.name                                    AS TableName,
    idx.name                                    AS IndexName,
    idx.type_desc                               AS IndexType,
    idx.is_primary_key                          AS IsPrimaryKey,
    idx.is_unique                               AS IsUnique,
    idx.is_disabled                             AS IsDisabled,
    s.user_seeks                                AS UserSeeks,      -- Index Seek count
    s.user_scans                                AS UserScans,      -- Index Scan count
    s.user_lookups                              AS UserLookups,    -- Key Lookup count
    s.user_updates                              AS UserUpdates,    -- Update/Insert/Delete count
    COALESCE(s.last_user_seek, s.last_user_scan) AS LastUsed
FROM sys.indexes idx
JOIN sys.tables tbl
    ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
    ON s.object_id = idx.object_id
    AND s.index_id = idx.index_id
    AND s.database_id = DB_ID()
WHERE tbl.is_ms_shipped = 0              -- System tables skip
ORDER BY s.user_seeks DESC;
GO

-- Unused indexes (waste of space - consider dropping!)
SELECT 
    tbl.name    AS TableName,
    idx.name    AS IndexName,
    idx.type_desc AS IndexType
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
    ON s.object_id = idx.object_id
    AND s.index_id = idx.index_id
    AND s.database_id = DB_ID()
WHERE idx.index_id > 0                   -- Skip heaps
  AND s.user_seeks IS NULL               -- Never used for seeks
  AND s.user_scans IS NULL               -- Never used for scans
  AND tbl.is_ms_shipped = 0
ORDER BY tbl.name, idx.name;
GO



/* ==============================================================================
   SECTION 13 — MISSING INDEXES (SQL Server Recommendations)
--------------------------------------------------------------------------------

   SQL Server itself suggest pannuvaan:
   "Inga oru index create pannina X% improvement varum!"

============================================================================== */

-- Missing index details
SELECT 
    mid.statement                               AS TableName,
    migs.avg_user_impact                        AS AvgImpactPercent,     -- Impact %
    migs.user_seeks                             AS UserSeeks,
    migs.avg_total_user_cost                    AS AvgQueryCostWithout,
    mic.equality_columns                        AS EqualityColumns,      -- WHERE col = ?
    mic.inequality_columns                      AS InequalityColumns,    -- WHERE col > ?
    mic.included_columns                        AS IncludedColumns       -- INCLUDE columns
FROM sys.dm_db_missing_index_details mid
JOIN sys.dm_db_missing_index_groups mig
    ON mid.index_handle = mig.index_handle
JOIN sys.dm_db_missing_index_group_stats migs
    ON mig.index_group_handle = migs.group_handle
JOIN sys.dm_db_missing_index_group_stats_query mic
    ON migs.group_handle = mic.group_handle  -- Note: column name may vary
ORDER BY migs.avg_user_impact DESC;
GO

-- Simple version
SELECT * FROM sys.dm_db_missing_index_details;
GO



/* ==============================================================================
   SECTION 14 — DUPLICATE INDEXES
--------------------------------------------------------------------------------

   Same column la multiple indexes irundha:
   • Waste of storage space
   • Every INSERT/UPDATE/DELETE all duplicate indexes update aagum = SLOW
   • Find panni drop pannanum

============================================================================== */

-- Find duplicate/overlapping indexes
SELECT  
    tbl.name    AS TableName,
    col.name    AS ColumnName,
    idx.name    AS IndexName,
    idx.type_desc AS IndexType,
    COUNT(*) OVER (PARTITION BY tbl.name, col.name) AS DuplicateCount
FROM sys.indexes idx
JOIN sys.tables tbl 
    ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic 
    ON idx.object_id = ic.object_id 
    AND idx.index_id = ic.index_id
JOIN sys.columns col 
    ON ic.object_id = col.object_id 
    AND ic.column_id = col.column_id
WHERE tbl.is_ms_shipped = 0
ORDER BY DuplicateCount DESC, tbl.name, col.name;
GO



/* ==============================================================================
   SECTION 15 — UPDATE STATISTICS
--------------------------------------------------------------------------------

   STATISTICS = SQL Server ku table data distribution pathi information
   
   WHY IMPORTANT:
   • SQL Server statistics based on query plan create pannuvaan
   • Outdated stats → Wrong query plan → SLOW queries!
   
   WHEN TO UPDATE:
   • Large data changes (bulk insert/delete)
   • Nightly maintenance jobs la include pannuvanga

============================================================================== */

-- Check statistics + last update date
SELECT 
    SCHEMA_NAME(t.schema_id)        AS SchemaName,
    t.name                          AS TableName,
    s.name                          AS StatisticName,
    sp.last_updated                 AS LastUpdated,
    DATEDIFF(day, sp.last_updated, GETDATE()) AS DaysSinceUpdate,
    sp.rows                         AS TotalRows,
    sp.modification_counter         AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables AS t
    ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
WHERE t.is_ms_shipped = 0
ORDER BY sp.modification_counter DESC;
GO

-- Update stats for specific table
UPDATE STATISTICS Demo_Heap;
GO

-- Update stats for all tables in database
EXEC sp_updatestats;
GO

-- Update stats with full scan (more accurate, more time)
UPDATE STATISTICS Demo_Heap WITH FULLSCAN;
GO



/* ==============================================================================
   SECTION 16 — FRAGMENTATION
--------------------------------------------------------------------------------

   INDEX FRAGMENTATION = Index pages out of order aagi vidum over time.

   WHY IT HAPPENS:
   • INSERT / UPDATE / DELETE operations pannum bodhu
   • Page splits occur - data shuffles around

   FRAGMENTATION LEVELS:
   ─────────────────────────────────────────────────────────
   < 10%  → OK, no action needed
   10-30% → REORGANIZE (lightweight, online operation)
   > 30%  → REBUILD (full rebuild, more resource-intensive)
   ─────────────────────────────────────────────────────────

   REORGANIZE vs REBUILD:
   ─────────────────────────────────────────────────────────────────────
   REORGANIZE  → Defrag in place, online, low impact, good for <30%
   REBUILD     → Drop + recreate index, offline (or online with EE),
                 full reset, good for >30%
   ─────────────────────────────────────────────────────────────────────

============================================================================== */

-- Check fragmentation for all indexes in current database
SELECT 
    tbl.name                            AS TableName,
    idx.name                            AS IndexName,
    s.avg_fragmentation_in_percent      AS FragmentationPercent,
    s.page_count                        AS PageCount,
    CASE 
        WHEN s.avg_fragmentation_in_percent < 10  THEN '✅ OK'
        WHEN s.avg_fragmentation_in_percent < 30  THEN '⚠️ REORGANIZE'
        ELSE                                           '❌ REBUILD'
    END                                 AS Recommendation
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s
INNER JOIN sys.tables tbl 
    ON s.object_id = tbl.object_id
INNER JOIN sys.indexes AS idx 
    ON idx.object_id = s.object_id
    AND idx.index_id = s.index_id
WHERE s.page_count > 10              -- Small indexes skip
ORDER BY s.avg_fragmentation_in_percent DESC;
GO

-- REORGANIZE (for 10-30% fragmentation)
ALTER INDEX idx_Heap_LastName
ON Demo_Heap REORGANIZE;
GO

-- REBUILD (for >30% fragmentation)
ALTER INDEX idx_Heap_LastName
ON Demo_Heap REBUILD;
GO

-- REBUILD ALL indexes on a table
ALTER INDEX ALL ON Demo_Heap REBUILD;
GO



/* ==============================================================================
   SECTION 17 — WHEN NOT TO USE INDEXES
--------------------------------------------------------------------------------

   AVOID INDEX ON:
   ─────────────────────────────────────────────────────────────
   ❌ Small tables       → Full scan faster than index seek!
   ❌ Low cardinality    → Gender (M/F), Status (Active/Inactive)
                           Only 2-3 unique values = index useless
   ❌ Frequently updated → Every update = index update = slow!
   ❌ Bulk insert tables → Temporary staging tables
   ─────────────────────────────────────────────────────────────

   PERFORMANCE TRADE-OFF:
   ─────────────────────────────────────────────────────────────
   INDEX HELPS  → SELECT queries (WHERE, JOIN, ORDER BY)
   INDEX HURTS  → INSERT, UPDATE, DELETE (all indexes update)
   ─────────────────────────────────────────────────────────────

   RULE OF THUMB:
   "Don't over-index. Each index has a cost."

============================================================================== */



/* ==============================================================================
   SECTION 18 — PRACTICAL DEMO (Full Working Example)
--------------------------------------------------------------------------------
   WideWorldImporters / AdventureWorks la try panna kooda use pannalam
   Illa na Demo_Heap table la try pannuvom
============================================================================== */

-- ============================================================
-- DEMO 1: Execution Plan - Table Scan vs Index Seek
-- ============================================================

-- Enable Execution Plan: Ctrl+M in SSMS
-- OR: Include Actual Execution Plan button click

-- TABLE SCAN (no index on Score)
SELECT * FROM Demo_Heap WHERE Score > 700;
GO

-- Create Index
CREATE INDEX idx_Demo_Score ON Demo_Heap (Score);
GO

-- INDEX SEEK (after index created)
SELECT * FROM Demo_Heap WHERE Score > 700;
GO


-- ============================================================
-- DEMO 2: IO Statistics (Pages read - lower is better)
-- ============================================================

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Check IO before index
SELECT * FROM Demo_Heap WHERE Country = 'India';
GO

-- Create index
CREATE INDEX idx_Demo_Country ON Demo_Heap (Country);
GO

-- Check IO after index
SELECT * FROM Demo_Heap WHERE Country = 'India';
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


-- ============================================================
-- DEMO 3: Include Columns (Covering Index - Key Lookup avoid)
-- ============================================================

/*
   Problem:
   Non-clustered index on Country.
   SELECT CustomerID, Score WHERE Country = 'India'
   → Index find pannuvaan → then KEY LOOKUP for CustomerID, Score
   → Two operations = slightly slower

   Solution: Include CustomerID, Score IN the index itself!
*/

-- Without include: causes Key Lookup
CREATE INDEX idx_Country_NoInclude
ON Demo_Heap (Country);
GO

SELECT CustomerID, Score FROM Demo_Heap WHERE Country = 'India';
GO

-- With include: Covering Index - no Key Lookup needed!
DROP INDEX idx_Country_NoInclude ON Demo_Heap;
GO

CREATE INDEX idx_Country_WithInclude
ON Demo_Heap (Country)
INCLUDE (CustomerID, Score);
GO

SELECT CustomerID, Score FROM Demo_Heap WHERE Country = 'India';
-- Now INDEX SEEK only! No Key Lookup! ✅
GO


-- ============================================================
-- DEMO 4: QUICK SUMMARY - All Index Types
-- ============================================================

/*
   ┌─────────────────────┬────────────┬──────────────────────────────────────┐
   │ INDEX TYPE          │ PER TABLE  │ BEST FOR                             │
   ├─────────────────────┼────────────┼──────────────────────────────────────┤
   │ Clustered           │ Only 1     │ Primary Key, main search column      │
   │ Non-Clustered       │ Up to 999  │ WHERE, JOIN, ORDER BY columns        │
   │ Composite           │ Up to 999  │ Multiple column filters              │
   │ Unique              │ Multiple   │ Email, Phone - no duplicates         │
   │ Filtered            │ Multiple   │ Specific subset of rows              │
   │ Clustered Columnstore│ Only 1   │ Analytics, SUM/AVG/GROUP BY          │
   │ NC Columnstore      │ Multiple   │ Specific column analytics            │
   └─────────────────────┴────────────┴──────────────────────────────────────┘
*/


-- ============================================================
-- CLEANUP (Optional - run to clean demo objects)
-- ============================================================

-- DROP TABLE Demo_Heap;
-- DROP TABLE Demo_Sales;


/* ==============================================================================
   END OF SQL INDEXING GUIDE
   
   Key Takeaways:
   1. Index = Book index mathiri - direct jump to data
   2. B-Tree structure = fast search in 3-4 steps
   3. Clustered = data itself sorted (only 1 per table)
   4. Non-Clustered = separate lookup structure (up to 999)
   5. Composite = multi-column, follow leftmost prefix rule
   6. Unique = no duplicates allowed
   7. Filtered = partial table index (specific rows)
   8. Columnstore = analytics ku best
   9. Monitor usage, missing, duplicates, fragmentation regularly
   10. Don't over-index - INSERT/UPDATE/DELETE affected!
============================================================================== */