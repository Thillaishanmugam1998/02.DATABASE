/* ==============================================================================
   SQL SERVER — CTE (Common Table Expression) COMPLETE GUIDE
   Tamil Explanation | Same Examples from Lesson File

   TABLE OF CONTENTS:
   ------------------
   SECTION 1  : CTE Na Enna?
   SECTION 2  : CTE Illana Enna Problem?
   SECTION 3  : CTE Syntax — How to Write
   SECTION 4  : ORDER BY Rule — Important!
   SECTION 5  : Stand-Alone CTE
   SECTION 6  : Nested CTE (Multiple CTEs)
   SECTION 7  : Recursive CTE — Number Series
   SECTION 8  : Recursive CTE — Employee Hierarchy
   SECTION 9  : CTE vs Subquery vs Temp Table
   SECTION 10 : Summary
============================================================================== */



/* ==============================================================================
   SECTION 1 — CTE NA ENNA?
--------------------------------------------------------------------------------

   SIMPLE DEFINITION:
   ------------------
   CTE = Oru query ku temporary peyar kodukkuvom.
   Antha peyar use pannி same query la use pannuvom.

   REAL LIFE EXAMPLE:
   ------------------
   🗒️ Notebook la shorthand mathiri!

   Friend ku letter write pannuvom:
   "Thiruvalluvar Nagar, 4th Street, House No 12, Chennai - 600045"

   Every time full address write pannurom? NO!
   "My Address" nu shortcut vechu → letter la "My Address" use pannuvom!

   CTE also same:
   → Long complex query → Short name kuduvom
   → Antha name use pannி main query write pannuvom!

   TECHNICAL DEFINITION:
   ---------------------
   • Temporary named result set
   • One query ku mattum live aagum (permanent store aagadhu)
   • Readability improve aagum
   • Duplicate query avoid pannuvom

   SYNTAX SKELETON:
   ----------------
   WITH CTE_Name AS          ← Step 1: Name kuduvom
   (
       SELECT ...            ← Step 2: Query write pannuvom
       FROM ...
   )
   SELECT *                  ← Step 3: CTE name use pannuvom
   FROM CTE_Name;

============================================================================== */



/* ==============================================================================
   SECTION 2 — CTE ILLANA ENNA PROBLEM?
--------------------------------------------------------------------------------

   LESSON FILE LA IRUKURA EXACT PROBLEM:
   
   Suppose: CustomerID + TotalSales + LastOrderDate paakanum.
   Same Sales.Orders table la rendu different queries run pannanum.
   CTE illana — same table ku rendu separate queries!
============================================================================== */

-- ❌ WITHOUT CTE — Rendu separate queries, duplicate work!

-- Query 1: Total Sales per Customer
SELECT
    CustomerID,
    SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID;

-- Query 2: Last Order Date per Customer
SELECT
    CustomerID,
    MAX(OrderDate) AS LastOrder
FROM Sales.Orders
GROUP BY CustomerID;

/*
   PROBLEM:
   ─────────────────────────────────────────────────────────────
   ❌ Same Sales.Orders table rendu thadavai scan aagum
   ❌ Rendu results separate — JOIN pannanum na subquery vendiyirukkum
   ❌ Logic duplicate — maintain pannuvaadhu kasta paduvom
   ❌ Complex aana — 5-6 such queries = unreadable code!
   ─────────────────────────────────────────────────────────────

   SOLUTION → CTE use pannuvom! (Next section)
*/



/* ==============================================================================
   SECTION 3 — CTE SYNTAX — HOW TO WRITE
--------------------------------------------------------------------------------

   STEP BY STEP BREAKDOWN:

   WITH CTE_TotalSales AS    ← "WITH" keyword mandatory
   (                         ← Opening bracket
       SELECT ...            ← Any valid SELECT query
       FROM ...
       GROUP BY ...
   )                         ← Closing bracket
   SELECT *                  ← Main query (CTE name use pannuvom)
   FROM CTE_TotalSales;      ← CTE name as table mathiri use!

   RULES:
   ──────────────────────────────────────────────────
   ✅ WITH keyword mandatory (always start with this)
   ✅ CTE la any valid SELECT query write pannalam
   ✅ Main query la table mathiri use pannalam
   ✅ Multiple CTEs → comma separate pannuvom
   ❌ CTE la INSERT/UPDATE/DELETE cannot define
   ❌ ORDER BY not allowed (unless TOP/OFFSET use)
   ❌ CTE permanent store aagadhu (one query only)
   ──────────────────────────────────────────────────
*/



/* ==============================================================================
   SECTION 4 — ORDER BY RULE — IMPORTANT!
--------------------------------------------------------------------------------

   CTE INSIDE ORDER BY ILLAI!
   CTE OUTSIDE (main query la) ORDER BY MUST!

   WHY?
   CTE = Temporary result set, no guaranteed order.
   ORDER BY = Final output ku apply pannuvom, so outside varum.
============================================================================== */

-- ❌ WRONG — ORDER BY inside CTE (ERROR varum!)
/*
WITH CTE_Test AS
(
    SELECT *
    FROM Sales.Orders
    ORDER BY Sales DESC     ← ERROR! Not allowed inside CTE
)
SELECT * FROM CTE_Test;
*/

-- ✅ CORRECT — ORDER BY outside CTE (main query la)
WITH CTE_Test AS
(
    SELECT *
    FROM Sales.Orders
    -- No ORDER BY here!
)
SELECT *
FROM CTE_Test
ORDER BY Sales DESC;    -- ✅ Main query la ORDER BY
GO

/*
   EXCEPTION — ORDER BY inside CTE allowed only with:
   • TOP clause: SELECT TOP 10 * FROM ... ORDER BY Sales DESC
   • OFFSET/FETCH: ... ORDER BY ... OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY
   • FOR XML: ... ORDER BY ... FOR XML AUTO
*/

-- ✅ Exception: TOP with ORDER BY inside CTE is allowed
WITH CTE_Top5 AS
(
    SELECT TOP 5 *          -- TOP irundha ORDER BY allowed!
    FROM Sales.Orders
    ORDER BY Sales DESC
)
SELECT * FROM CTE_Top5;
GO



/* ==============================================================================
   SECTION 5 — STAND-ALONE CTE
--------------------------------------------------------------------------------
   Lesson file: CTE_TotalSales — basic standalone example

   WHAT THIS DOES:
   Sales.Orders table la CustomerID group pannி
   Total Sales calculate pannuvom → CTE la store → Main query la use
============================================================================== */

-- ✅ SOLUTION WITH CTE — Clean single query!
WITH CTE_TotalSales AS
(
    -- CTE DEFINITION: CustomerID ku Total Sales calculate
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
    -- Result: Each CustomerID → Their total sales
)
-- MAIN QUERY: CTE name table mathiri use pannuvom!
SELECT
    CustomerID,
    TotalSales
FROM CTE_TotalSales;
GO

/*
   HOW TO READ THIS:
   ─────────────────────────────────────────────────────────────
   Step 1: CTE_TotalSales execute aagum
           → Each CustomerID ku TotalSales calculate
           → Temporary result memory la store

   Step 2: Main query → CTE_TotalSales from select pannuvom
           → Normal table mathiri treat aagum!

   RESULT:
   CustomerID | TotalSales
   1          | 4500.00
   2          | 2300.00
   3          | 8900.00
   ...

   WITHOUT CTE: Subquery la wrap pannanum (unreadable!)
   WITH CTE: Clean, readable, maintainable ✅
   ─────────────────────────────────────────────────────────────
*/



/* ==============================================================================
   SECTION 6 — NESTED CTE (MULTIPLE CTEs)
--------------------------------------------------------------------------------
   Lesson file: 3 CTEs chained — TotalSales → Rank → Segment → Final JOIN

   WHAT THIS DOES:
   CTE 1 (CTE_TotalSales)    → Each customer total sales calculate
   CTE 2 (CTE_CustomerRank)  → CTE 1 use pannி rank kuduvom
   CTE 3 (CTE_CustomerSegment) → CTE 1 use pannி High/Medium/Low label
   Final Query               → All 3 CTEs JOIN pannி full report!

   FLOW:
   Sales.Orders
       ↓
   CTE_TotalSales (SUM of sales per customer)
       ↓               ↓
   CTE_CustomerRank   CTE_CustomerSegment
   (RANK by sales)    (High/Medium/Low)
       ↓               ↓
         Final JOIN with Customers table
============================================================================== */

WITH

-- ─────────────────────────────────────────────────────────────
-- CTE 1: Each customer total sales
-- ─────────────────────────────────────────────────────────────
CTE_TotalSales AS
(
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
    /*
       OUTPUT SHAPE:
       CustomerID | TotalSales
       1          | 4500
       2          | 2300
       3          | 8900
    */
),

-- ─────────────────────────────────────────────────────────────
-- CTE 2: CTE_TotalSales use pannி rank kuduvom
-- Most sales → Rank 1, next → Rank 2, etc.
-- ─────────────────────────────────────────────────────────────
CTE_CustomerRank AS
(
    SELECT
        CustomerID,
        TotalSales,
        RANK() OVER (ORDER BY TotalSales DESC) AS CustomerRank
        /*
           RANK() = Window function
           ORDER BY TotalSales DESC = Highest sales = Rank 1
           Same sales = Same rank (1,1,3 — not 1,1,2)
        */
    FROM CTE_TotalSales    -- ← Previous CTE use pannuvom!
    /*
       OUTPUT SHAPE:
       CustomerID | TotalSales | CustomerRank
       3          | 8900       | 1
       1          | 4500       | 2
       2          | 2300       | 3
    */
),

-- ─────────────────────────────────────────────────────────────
-- CTE 3: CTE_TotalSales use pannி customer segment label
-- High / Medium / Low — business category
-- ─────────────────────────────────────────────────────────────
CTE_CustomerSegment AS
(
    SELECT
        CustomerID,
        TotalSales,
        CASE
            WHEN TotalSales > 100 THEN 'High'
            WHEN TotalSales > 80  THEN 'Medium'
            ELSE                       'Low'
        END AS CustomerSegment
        /*
           CASE = IF/ELSE mathiri
           TotalSales > 100 → 'High'
           TotalSales 81-100 → 'Medium'
           TotalSales <= 80  → 'Low'
        */
    FROM CTE_TotalSales    -- ← Same CTE_TotalSales reuse!
    /*
       OUTPUT SHAPE:
       CustomerID | TotalSales | CustomerSegment
       3          | 8900       | High
       1          | 4500       | High
       2          | 23         | Low
    */
)

-- ─────────────────────────────────────────────────────────────
-- FINAL QUERY: All 3 CTEs + Customers table JOIN pannuvom
-- Complete customer report!
-- ─────────────────────────────────────────────────────────────
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    ts.TotalSales,
    cr.CustomerRank,
    cs.CustomerSegment
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales    ts ON ts.CustomerID = c.CustomerID
LEFT JOIN CTE_CustomerRank  cr ON cr.CustomerID = c.CustomerID
LEFT JOIN CTE_CustomerSegment cs ON cs.CustomerID = c.CustomerID;
GO

/*
   FINAL OUTPUT:
   CustomerID | FirstName | LastName | TotalSales | CustomerRank | CustomerSegment
   3          | David     | Smith    | 8900       | 1            | High
   1          | Ravi      | Kumar    | 4500       | 2            | High
   2          | Priya     | Devi     | 23         | 3            | Low

   WHY 3 CTEs BETTER THAN ONE BIG QUERY?
   ─────────────────────────────────────────────────────────────
   ❌ Without CTE:
   SELECT c.CustomerID, c.FirstName,
          (SELECT SUM(Sales) FROM Sales.Orders WHERE CustomerID = c.CustomerID) AS TotalSales,
          RANK() OVER (ORDER BY (SELECT SUM(Sales)...) DESC) AS Rank,
          CASE WHEN (SELECT SUM(Sales)...) > 100 THEN 'High'... AS Segment
   FROM Sales.Customers c...
   → Unreadable! SUM(Sales) subquery 3 times repeat!

   ✅ With CTE:
   → Each step clear
   → SUM(Sales) once calculate → 3 CTEs reuse
   → Easy to debug (each CTE separately test pannalam)
   ─────────────────────────────────────────────────────────────
*/



/* ==============================================================================
   SECTION 7 — RECURSIVE CTE — NUMBER SERIES
--------------------------------------------------------------------------------
   Lesson file: CTE_NumberSeries — 1 to 20 generate pannuvom

   RECURSIVE CTE NA ENNA?
   -----------------------
   CTE itself ah call pannuvom (self-reference)!
   Loop mathiri work aagum — but SQL la loop illai, so CTE use pannuvom.

   STRUCTURE:
   ──────────────────────────────────────────────
   WITH CTE_Name AS
   (
       -- PART 1: ANCHOR (Starting point — oru thadavai mattum run)
       SELECT 1 AS Number

       UNION ALL

       -- PART 2: RECURSIVE (Itself call pannuvom — condition true la)
       SELECT Number + 1
       FROM CTE_Name             ← Own name use pannuvom!
       WHERE Number < 20         ← Stop condition (without this = infinite loop!)
   )
   SELECT * FROM CTE_Name;
   ──────────────────────────────────────────────
============================================================================== */

WITH CTE_NumberSeries AS
(
    -- ─────────────────────────────────────────
    -- ANCHOR MEMBER: Starting value = 1
    -- Only ONCE execute aagum (loop start)
    -- ─────────────────────────────────────────
    SELECT 1 AS Number

    UNION ALL

    -- ─────────────────────────────────────────
    -- RECURSIVE MEMBER: Previous result + 1
    -- WHERE condition false aagum varai repeat
    -- ─────────────────────────────────────────
    SELECT Number + 1
    FROM CTE_NumberSeries          -- Own name call pannuvom!
    WHERE Number < 20              -- Number = 20 aana STOP!
)
SELECT Number
FROM CTE_NumberSeries
OPTION (MAXRECURSION 100);        -- Max 100 levels (safety limit)
GO

/*
   HOW THIS WORKS — STEP BY STEP:
   ─────────────────────────────────────────────────────────────
   Iteration 1 (Anchor):    Number = 1   → WHERE 1 < 20 ✅ continue
   Iteration 2 (Recursive): Number = 1+1 = 2   → WHERE 2 < 20 ✅
   Iteration 3 (Recursive): Number = 2+1 = 3   → WHERE 3 < 20 ✅
   ...
   Iteration 20:            Number = 19+1 = 20 → WHERE 20 < 20 ❌ STOP!
   ─────────────────────────────────────────────────────────────

   OUTPUT:
   Number
   1
   2
   3
   ...
   20

   MAXRECURSION 100 — WHY?
   Default max = 100 recursions.
   100+ levels need → OPTION (MAXRECURSION 0) = unlimited (careful!)
   0 set pannina infinite loop risk — always WHERE condition correct ah veyyavum!

   REAL USE CASES:
   • Date series generate (Jan 1 to Dec 31 every day)
   • Invoice number sequence
   • Test data generate
*/

-- Bonus: Date series generate (practical use!)
WITH CTE_DateSeries AS
(
    SELECT CAST('2024-01-01' AS DATE) AS DateValue    -- Anchor: Jan 1

    UNION ALL

    SELECT DATEADD(DAY, 1, DateValue)                 -- Each day +1
    FROM CTE_DateSeries
    WHERE DateValue < '2024-01-31'                    -- Stop: Jan 31
)
SELECT DateValue
FROM CTE_DateSeries
OPTION (MAXRECURSION 100);
GO
/*
   OUTPUT:
   DateValue
   2024-01-01
   2024-01-02
   2024-01-03
   ...
   2024-01-31
*/



/* ==============================================================================
   SECTION 8 — RECURSIVE CTE — EMPLOYEE HIERARCHY
--------------------------------------------------------------------------------
   Lesson file: CTE_EmployeeHierarchy
   Manager → Team Lead → Employee — tree structure show pannuvom

   USE CASE:
   CEO → VP → Manager → Team Lead → Employee
   Oru table la ManagerID column irukum.
   Who reports to whom — recursively find pannuvom!

   TABLE STRUCTURE:
   EmployeeID | FirstName | ManagerID
   1          | CEO       | NULL       ← Top (no manager)
   2          | VP        | 1          ← Reports to CEO
   3          | Manager   | 2          ← Reports to VP
   4          | TeamLead  | 3          ← Reports to Manager
   5          | Employee  | 4          ← Reports to TeamLead
============================================================================== */

WITH CTE_EmployeeHierarchy AS
(
    -- ─────────────────────────────────────────────────────────
    -- ANCHOR: Top-level employees (no manager = CEO/Top level)
    -- ManagerID IS NULL = Nobody above them
    -- Level = 1 (topmost)
    -- ─────────────────────────────────────────────────────────
    SELECT
        EmployeeID,
        FirstName,
        ManagerID,
        1 AS Level              -- CEO = Level 1
    FROM Sales.Employees
    WHERE ManagerID IS NULL     -- Top level (no manager)

    UNION ALL

    -- ─────────────────────────────────────────────────────────
    -- RECURSIVE: Find employees who report to previous level
    -- Previous result (h) la irukura EmployeeID →
    -- Next level employees (e) la ManagerID = h.EmployeeID
    -- ─────────────────────────────────────────────────────────
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        h.Level + 1             -- Each level down = +1
    FROM Sales.Employees e
    INNER JOIN CTE_EmployeeHierarchy h
        ON e.ManagerID = h.EmployeeID   -- This employee's manager = previous level's employee
    /*
       INNER JOIN logic:
       h = Previous iteration result (managers)
       e = Current employees table
       e.ManagerID = h.EmployeeID → "This employee reports to that manager"
    */
)
SELECT
    EmployeeID,
    FirstName,
    ManagerID,
    Level
FROM CTE_EmployeeHierarchy;
GO

/*
   HOW THIS WORKS — STEP BY STEP:
   ─────────────────────────────────────────────────────────────
   ANCHOR run:
   → ManagerID IS NULL → CEO fetch → Level = 1
   Result: [1, CEO, NULL, 1]

   RECURSIVE run 1:
   → h = CEO (EmployeeID=1)
   → e la ManagerID = 1 irukkaanga? → VP fetch → Level = 1+1 = 2
   Result: [2, VP, 1, 2]

   RECURSIVE run 2:
   → h = VP (EmployeeID=2)
   → e la ManagerID = 2 irukkaanga? → Manager fetch → Level = 2+1 = 3
   Result: [3, Manager, 2, 3]

   ...continues until no more employees found → STOP!
   ─────────────────────────────────────────────────────────────

   FINAL OUTPUT:
   EmployeeID | FirstName | ManagerID | Level
   1          | CEO       | NULL      | 1      ← Top
   2          | VP        | 1         | 2
   3          | Manager   | 2         | 3
   4          | TeamLead  | 3         | 4
   5          | Employee  | 4         | 5      ← Bottom

   REAL USE CASES:
   • Org chart generate pannuvom
   • Bill of Materials (Product → Sub-components)
   • Category tree (Electronics → Mobile → Smartphones)
   • File system folder structure
*/

-- Bonus: Level indentation add pannuvom (nice visual!)
WITH CTE_EmployeeHierarchy AS
(
    SELECT
        EmployeeID,
        FirstName,
        ManagerID,
        1 AS Level,
        CAST(FirstName AS NVARCHAR(200)) AS HierarchyPath
    FROM Sales.Employees
    WHERE ManagerID IS NULL

    UNION ALL

    SELECT
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        h.Level + 1,
        CAST(h.HierarchyPath + ' → ' + e.FirstName AS NVARCHAR(200))
    FROM Sales.Employees e
    INNER JOIN CTE_EmployeeHierarchy h ON e.ManagerID = h.EmployeeID
)
SELECT
    REPLICATE('    ', Level - 1) + FirstName AS OrgChart,   -- Indentation!
    Level,
    HierarchyPath
FROM CTE_EmployeeHierarchy
ORDER BY HierarchyPath;
GO

/*
   OUTPUT (with indentation):
   OrgChart              | Level | HierarchyPath
   CEO                   | 1     | CEO
       VP                | 2     | CEO → VP
           Manager       | 3     | CEO → VP → Manager
               TeamLead  | 4     | CEO → VP → Manager → TeamLead
*/



/* ==============================================================================
   SECTION 9 — CTE vs SUBQUERY vs TEMP TABLE
--------------------------------------------------------------------------------

   SAME PROBLEM — 3 DIFFERENT APPROACHES:
   "Each customer total sales paakanum"

   ─────────────────────────────────────────────────────────────────────────────
*/

-- APPROACH 1: Subquery (Nested query)
SELECT
    CustomerID,
    TotalSales
FROM
(
    SELECT CustomerID, SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) AS SubQuery_TotalSales;    -- Subquery ku alias mandatory
GO

-- APPROACH 2: CTE
WITH CTE_TotalSales AS
(
    SELECT CustomerID, SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
)
SELECT CustomerID, TotalSales
FROM CTE_TotalSales;
GO

-- APPROACH 3: Temp Table
SELECT CustomerID, SUM(Sales) AS TotalSales
INTO #TempSales                     -- Temp table create + data insert
FROM Sales.Orders
GROUP BY CustomerID;

SELECT * FROM #TempSales;           -- Separate query la use
DROP TABLE #TempSales;              -- Manual cleanup needed
GO

/*
   COMPARISON:
   ─────────────────────────────────────────────────────────────────────────────
   Feature          │ Subquery          │ CTE               │ Temp Table
   ─────────────────│───────────────────│───────────────────│────────────────
   Readability      │ ❌ Nested mess    │ ✅ Clean          │ ✅ Separate
   Reusability      │ ❌ Repeat pannanum│ ✅ Multiple JOIN  │ ✅ Multiple query
   Recursion        │ ❌ Not possible   │ ✅ Supported      │ ❌ Not possible
   Performance      │ 🟡 Medium         │ 🟡 Medium         │ ✅ Indexed possible
   Scope            │ Same query only   │ Same query only   │ Session la live
   Cleanup          │ Auto             │ Auto              │ Manual DROP needed
   Large data       │ ❌ Slow           │ ❌ Slow           │ ✅ Better
   ─────────────────────────────────────────────────────────────────────────────

   WHEN TO USE WHAT:
   • CTE        → Complex multi-step logic, recursion, readability important
   • Subquery   → Simple one-time nested filter
   • Temp Table → Large data, multiple times reuse, indexing needed
*/



/* ==============================================================================
   SECTION 10 — SUMMARY
--------------------------------------------------------------------------------

   3 TYPES OF CTE:
   ─────────────────────────────────────────────────────────────────────────────

   TYPE 1: STAND-ALONE CTE
   • Single CTE, independent
   • One result set → Main query la use
   • Use: Simple aggregation, avoid subquery

   TYPE 2: NESTED CTE (Multiple CTEs)
   • Multiple CTEs comma separate
   • One CTE another CTE use pannuvom
   • Use: Multi-step calculations, complex reports

   TYPE 3: RECURSIVE CTE
   • CTE itself call pannuvom
   • Anchor + Recursive member
   • MAXRECURSION option use pannuvom
   • Use: Number/Date series, Hierarchy data

   KEY RULES:
   ──────────────────────────────────────────────────────────────────────
   ✅ WITH keyword always first
   ✅ ORDER BY → main query la (not inside CTE)
   ✅ Multiple CTEs → comma separate
   ✅ Recursive → ANCHOR + UNION ALL + RECURSIVE + WHERE stop condition
   ✅ MAXRECURSION → Default 100, change with OPTION clause
   ❌ CTE inside another CTE definition illai (only in final query reference)
   ❌ Permanent store aagadhu (query end = CTE gone)
   ──────────────────────────────────────────────────────────────────────

   INTERVIEW ANSWER:
   -----------------
   "CTE is a temporary named result set that exists only for a single query.
    It improves readability by breaking complex queries into simple steps,
    avoids duplicate logic, and supports recursion for hierarchy/sequence data."

============================================================================== */