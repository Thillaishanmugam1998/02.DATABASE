
/* =================================================================================================
SQL SERVER HEAP STORAGE – REAL SCENARIO EXPLANATION
Audience : Freshers + Experienced Developers
Purpose  : Understand how SQL Server stores rows in Data Pages when a table is a HEAP
================================================================================================= */


/* =================================================================================================
SECTION 1 — WHAT IS A HEAP TABLE?
----------------------------------------------------------------------------------------------------
A HEAP is a table WITHOUT a clustered index.

When a table does not have a clustered index, SQL Server stores the rows in
Data Pages without any logical order.

Definition:
    Heap = Table without clustered index
================================================================================================= */


/* =================================================================================================
SECTION 2 — CREATE SAMPLE TABLE
----------------------------------------------------------------------------------------------------
This table has no clustered index, so SQL Server will store it as a HEAP.
================================================================================================= */

CREATE TABLE Employees
(
    EmpID INT,
    Name VARCHAR(50)
);
GO


/* =================================================================================================
SECTION 3 — INSERT SAMPLE DATA (20 RECORDS)
================================================================================================= */

INSERT INTO Employees VALUES (1,'Emp1');
INSERT INTO Employees VALUES (2,'Emp2');
INSERT INTO Employees VALUES (3,'Emp3');
INSERT INTO Employees VALUES (4,'Emp4');
INSERT INTO Employees VALUES (5,'Emp5');
INSERT INTO Employees VALUES (6,'Emp6');
INSERT INTO Employees VALUES (7,'Emp7');
INSERT INTO Employees VALUES (8,'Emp8');
INSERT INTO Employees VALUES (9,'Emp9');
INSERT INTO Employees VALUES (10,'Emp10');
INSERT INTO Employees VALUES (11,'Emp11');
INSERT INTO Employees VALUES (12,'Emp12');
INSERT INTO Employees VALUES (13,'Emp13');
INSERT INTO Employees VALUES (14,'Emp14');
INSERT INTO Employees VALUES (15,'Emp15');
INSERT INTO Employees VALUES (16,'Emp16');
INSERT INTO Employees VALUES (17,'Emp17');
INSERT INTO Employees VALUES (18,'Emp18');
INSERT INTO Employees VALUES (19,'Emp19');
INSERT INTO Employees VALUES (20,'Emp20');
GO


/* =================================================================================================
SECTION 4 — WHERE THIS DATA IS STORED
----------------------------------------------------------------------------------------------------
All data is stored inside the SQL Server database file (.mdf).

Example:

CompanyDB.mdf
     |
     |--- Data Pages
     |--- Index Pages
     |--- Metadata Pages

Our table rows are stored inside DATA PAGES.
================================================================================================= */


/* =================================================================================================
SECTION 5 — DATA PAGE STRUCTURE
----------------------------------------------------------------------------------------------------
Smallest unit of storage in SQL Server.

1 Data Page = 8 KB (8192 bytes)

Page Structure:

+-----------------------------------+
| Page Header (96 bytes)            |
+-----------------------------------+
| Row Data                          |
| Row Data                          |
| Row Data                          |
| ...                               |
+-----------------------------------+
| Slot Array                        |
+-----------------------------------+

================================================================================================= */


/* =================================================================================================
SECTION 6 — ROW SIZE ESTIMATION
----------------------------------------------------------------------------------------------------

EmpID  = 4 bytes
Name   = ~50 bytes
Row overhead ≈ 7 bytes

Approx row size ≈ 61 bytes

Rows per page:

8192 / 61 ≈ 130 rows

So a single page can store about 130 rows.
================================================================================================= */


/* =================================================================================================
SECTION 7 — OUR SCENARIO (20 ROWS)
----------------------------------------------------------------------------------------------------

We inserted 20 rows.

Since one page can store about 130 rows,
SQL Server creates ONLY ONE DATA PAGE.

Visual Representation:

Data Page 1
------------------------------------------------
EmpID | Name
------------------------------------------------
1  | Emp1
2  | Emp2
3  | Emp3
...
18 | Emp18
19 | Emp19
20 | Emp20
------------------------------------------------

================================================================================================= */


/* =================================================================================================
SECTION 8 — HOW SQL SERVER EXECUTES A QUERY
----------------------------------------------------------------------------------------------------

Query:

SELECT * FROM Employees WHERE EmpID = 18

Since the table is a HEAP and has no index,
SQL Server must scan the rows.

This operation is called:

TABLE SCAN

Process:

1. SQL Server reads Data Page
2. Checks row by row
3. Stops when EmpID = 18 is found

Execution flow:

Query
  |
  v
Table Scan
  |
  v
Data Page
  |
  v
Row-by-row search
  |
  v
Row 18 found

================================================================================================= */


/* =================================================================================================
SECTION 9 — EXAMPLE QUERY
================================================================================================= */

SELECT *
FROM Employees
WHERE EmpID = 18;
GO


/* =================================================================================================
SECTION 10 — WHAT HAPPENS IF TABLE GROWS?
----------------------------------------------------------------------------------------------------

Example:

200 rows

Rows per page ≈ 130

SQL Server will create:

Page 1 → rows 1 to 130
Page 2 → rows 131 to 200

Structure:

Employees Heap

Page 1
Rows 1 - 130

Page 2
Rows 131 - 200

Query search must scan multiple pages.

================================================================================================= */


/* =================================================================================================
SECTION 11 — HOW TO IMPROVE PERFORMANCE
----------------------------------------------------------------------------------------------------

Create a clustered index:

CREATE CLUSTERED INDEX IX_Employees_EmpID
ON Employees(EmpID);

Now SQL Server builds a B-Tree structure and performs an INDEX SEEK
instead of a TABLE SCAN.

================================================================================================= */



/* =================================================================================================
SECTION 8 — CREATE CLUSTERED INDEX
----------------------------------------------------------------------------------------------------
A clustered index sorts and stores the actual table data based on the index key.

Only ONE clustered index per table.
================================================================================================= */

CREATE CLUSTERED INDEX IX_Employees_EmpID
ON Employees(EmpID);
GO


/* =================================================================================================
SECTION 9 — B-TREE STRUCTURE
----------------------------------------------------------------------------------------------------

Clustered indexes use a B-Tree structure.

Structure:

            Root Node
              |
       -----------------
       |               |
   Intermediate    Intermediate
       |               |
     Leaf Nodes (Data Pages)

Leaf level contains the actual table rows.

================================================================================================= */


/* =================================================================================================
SECTION 10 — DATA STORAGE WITH CLUSTERED INDEX
----------------------------------------------------------------------------------------------------

Rows are physically sorted by EmpID.

Example page layout:

Page 1 → EmpID 1 - 130
Page 2 → EmpID 131 - 260
Page 3 → EmpID 261 - 390
Page 4 → EmpID 391 - 520
Page 5 → EmpID 521 - 650
Page 6 → EmpID 651 - 780
Page 7 → EmpID 781 - 910
Page 8 → EmpID 911 - 1000

================================================================================================= */


/* =================================================================================================
SECTION 11 — INDEX PAGES
----------------------------------------------------------------------------------------------------

Clustered index creates INDEX PAGES above the data pages.

Example:

Root Page
    |
Intermediate Page
    |
Leaf Pages (Data Pages)

These pages store key values and page pointers.

================================================================================================= */


/* =================================================================================================
SECTION 12 — QUERY EXECUTION WITH CLUSTERED INDEX
----------------------------------------------------------------------------------------------------

Query:

SELECT * FROM Employees WHERE EmpID = 700

Execution:

Step 1 → Root node checks range
Step 2 → Navigate to correct intermediate node
Step 3 → Navigate to leaf page
Step 4 → Locate EmpID = 700 directly

This operation is called:

INDEX SEEK

Much faster than table scan.

================================================================================================= */


/* =================================================================================================
SECTION 13 — VISUAL EXECUTION PATH
----------------------------------------------------------------------------------------------------

        Root Page
           |
           v
     Intermediate Page
           |
           v
      Data Page (651–780)
           |
           v
        Row 700 found

================================================================================================= */


/* =================================================================================================
SECTION 14 — PERFORMANCE DIFFERENCE
----------------------------------------------------------------------------------------------------

Without Index:
    TABLE SCAN
    Reads multiple pages

With Clustered Index:
    INDEX SEEK
    Direct navigation through B-Tree

================================================================================================= */
