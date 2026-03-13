/* ==============================================================================
   SQL SERVER — VIEWS COMPLETE GUIDE
   Tamil Explanation | Concise & Clear

   TABLE OF CONTENTS:
   SECTION 1 : View Na Enna?
   SECTION 2 : View Illana Enna Problem?
   SECTION 3 : Syntax + CREATE / ALTER / DROP
   SECTION 4 : Use Case 1 — Monthly Summary
   SECTION 5 : Use Case 2 — Hide Complexity (Multi-table JOIN)
   SECTION 6 : Use Case 3 — Data Security
   SECTION 7 : Use Case 4 — Reporting & Reusability
   SECTION 8 : Use Case 5 — Abstraction Layer
   SECTION 9 : View vs CTE vs Temp Table
   SECTION 10 : Summary
============================================================================== */



/* ==============================================================================
   SECTION 1 — VIEW NA ENNA?
--------------------------------------------------------------------------------

   VIEW = Virtual Table.
   Data store aagadhu — only query logic save aagum.

   REAL LIFE EXAMPLE:
   📺 TV Channel mathiri!
   • TV channel itself pichure store panna — No!
   • Live broadcast show pannum — source la irundhu!

   View also same:
   • Data table la irukum
   • View = window through which you see that data

   DATABASE HIERARCHY:
   SQL Server → Database → Schema → Tables (Physical Data)
                                  → Views  (Virtual Data)

   TABLE vs VIEW:
   ─────────────────────────────────────────────────
   Table → Physical data store
   View  → Only query store (data table la irukum)
   ─────────────────────────────────────────────────

============================================================================== */



/* ==============================================================================
   SECTION 2 — VIEW ILLANA ENNA PROBLEM?
--------------------------------------------------------------------------------
   3 Tables JOIN — every user every time same query write pannanum!
============================================================================== */

-- ❌ WITHOUT VIEW — Report team same JOIN write pannanum
SELECT
    o.OrderID, o.OrderDate,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    p.Product, p.Category,
    o.Sales
FROM Sales.Orders o
JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
JOIN Sales.Products  p ON p.ProductID  = o.ProductID;

-- ❌ Manager also SAME JOIN again!
SELECT
    p.Category,
    SUM(o.Sales) AS TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
JOIN Sales.Products  p ON p.ProductID  = o.ProductID
GROUP BY p.Category;

/*
   PROBLEMS:
   ❌ Same JOIN 100 places repeat
   ❌ Table name change aana → 100 queries fix pannanum
   ❌ Developer mistake panna chance high
   ❌ Maintain panna kastam
*/



/* ==============================================================================
   SECTION 3 — SYNTAX + CREATE / ALTER / DROP
============================================================================== */

-- ── CREATE ──────────────────────────────────────────────────
CREATE VIEW Sales.V_OrderDetails AS
SELECT
    o.OrderID, o.OrderDate,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    p.Product, p.Category,
    o.Sales, o.Quantity
FROM Sales.Orders o
JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
JOIN Sales.Products  p ON p.ProductID  = o.ProductID;
GO

-- ── QUERY VIEW — Simple! No JOIN needed ─────────────────────
SELECT * FROM Sales.V_OrderDetails;

SELECT Category, SUM(Sales) AS TotalSales
FROM Sales.V_OrderDetails
GROUP BY Category;
GO

/*
   ✅ NOW EVERYONE USE SAME VIEW — No JOIN needed!
   Report team:  SELECT * FROM Sales.V_OrderDetails
   Manager:      SELECT Category, SUM(Sales)... FROM Sales.V_OrderDetails
*/

-- ── ALTER (Modify View) ──────────────────────────────────────
ALTER VIEW Sales.V_OrderDetails AS
SELECT
    o.OrderID, o.OrderDate,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    p.Product, p.Category,
    o.Sales                          -- Quantity remove panninom
FROM Sales.Orders o
JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
JOIN Sales.Products  p ON p.ProductID  = o.ProductID;
GO

-- ── DROP View ────────────────────────────────────────────────
IF OBJECT_ID('Sales.V_OrderDetails', 'V') IS NOT NULL
    DROP VIEW Sales.V_OrderDetails;
GO



/* ==============================================================================
   SECTION 4 — USE CASE 1: MONTHLY SUMMARY
--------------------------------------------------------------------------------
   Monthly sales aggregate — View la save pannuvom.
   Report team SELECT * pannina done!
============================================================================== */

CREATE VIEW Sales.V_Monthly_Summary AS
SELECT
    DATETRUNC(month, OrderDate) AS OrderMonth,
    SUM(Sales)     AS TotalSales,
    COUNT(OrderID) AS TotalOrders,
    SUM(Quantity)  AS TotalQuantities
FROM Sales.Orders
GROUP BY DATETRUNC(month, OrderDate);
GO

-- Use pannuvom
SELECT * FROM Sales.V_Monthly_Summary;
GO

/*
   OUTPUT:
   OrderMonth  | TotalSales | TotalOrders | TotalQuantities
   2024-01-01  | 45000      | 120         | 340
   2024-02-01  | 52000      | 145         | 410
*/



/* ==============================================================================
   SECTION 5 — USE CASE 2: HIDE COMPLEXITY (Multi-Table JOIN)
--------------------------------------------------------------------------------
   4 tables JOIN — complex query → View la hide pannuvom
   User simple SELECT * pannina — full data varum!
============================================================================== */

CREATE VIEW Sales.V_Order_Details AS
SELECT
    o.OrderID,
    o.OrderDate,
    p.Product,
    p.Category,
    COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') AS CustomerName,
    c.Country AS CustomerCountry,
    COALESCE(e.FirstName,'') + ' ' + COALESCE(e.LastName,'') AS SalesName,
    e.Department,
    o.Sales,
    o.Quantity
FROM Sales.Orders o
LEFT JOIN Sales.Products  p ON p.ProductID  = o.ProductID
LEFT JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.Employees e ON e.EmployeeID = o.SalesPersonID;
GO

-- User ku simple!
SELECT * FROM Sales.V_Order_Details;
GO

/*
   BENEFIT:
   4 tables JOIN logic → View la oru place
   User: SELECT * FROM Sales.V_Order_Details → Done! ✅
*/



/* ==============================================================================
   SECTION 6 — USE CASE 3: DATA SECURITY
--------------------------------------------------------------------------------
   EU Team ku USA data paakka koodadhu.
   Salary column employees ku paakka koodadhu.
   View use pannி filter + hide pannuvom!
============================================================================== */

-- EU Team View: USA customers exclude
CREATE VIEW Sales.V_Order_Details_EU AS
SELECT
    o.OrderID, o.OrderDate,
    p.Product, p.Category,
    COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') AS CustomerName,
    c.Country AS CustomerCountry,
    o.Sales, o.Quantity
FROM Sales.Orders o
LEFT JOIN Sales.Products  p ON p.ProductID  = o.ProductID
LEFT JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.Employees e ON e.EmployeeID = o.SalesPersonID
WHERE c.Country != 'USA';    -- USA data hidden! ✅
GO

-- Salary hide: Only safe columns show
CREATE VIEW HR.V_Employee_Public AS
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department
    -- Salary column illai → hidden! ✅
FROM HR.Employees;
GO

SELECT * FROM HR.V_Employee_Public;
GO

/*
   SECURITY BENEFIT:
   Table ku direct access kudukkaama → View access kuduvom
   User only sees what they should see!

   ┌──────────────────────────────────────────────┐
   │  HR.Employees (Full table — DBA only)        │
   │  EmployeeID | Name | Department | Salary     │
   └──────────────────────────────────────────────┘
                           ↓ View filter
   ┌──────────────────────────────────────────────┐
   │  HR.V_Employee_Public (Staff sees this)      │
   │  EmployeeID | Name | Department              │
   └──────────────────────────────────────────────┘
*/



/* ==============================================================================
   SECTION 7 — USE CASE 4: REPORTING & REUSABILITY
--------------------------------------------------------------------------------
   Management Sales Report — Category + Country + Month breakdown
   Oru view → All teams reuse pannuvom
============================================================================== */

CREATE VIEW Sales.V_Sales_Report AS
SELECT
    DATETRUNC(MONTH, o.OrderDate) AS OrderMonth,
    p.Category,
    c.Country,
    SUM(o.Sales)     AS TotalSales,
    SUM(o.Quantity)  AS TotalQuantity,
    COUNT(o.OrderID) AS TotalOrders
FROM Sales.Orders o
JOIN Sales.Products  p ON p.ProductID  = o.ProductID
JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
GROUP BY
    DATETRUNC(MONTH, o.OrderDate),
    p.Category,
    c.Country;
GO

-- Report team full data
SELECT * FROM Sales.V_Sales_Report;

-- Manager: Only USA
SELECT * FROM Sales.V_Sales_Report WHERE Country = 'USA';

-- Analyst: Category wise total
SELECT Category, SUM(TotalSales) AS GrandTotal
FROM Sales.V_Sales_Report
GROUP BY Category;
GO

/*
   ONE VIEW → MULTIPLE TEAMS → MULTIPLE USE CASES ✅
*/



/* ==============================================================================
   SECTION 8 — USE CASE 5: ABSTRACTION LAYER
--------------------------------------------------------------------------------
   Table structure change aana — View modify pannuvom.
   User query change aagadhu!
============================================================================== */

CREATE VIEW Sales.V_Product_Public AS
SELECT
    ProductID,
    Product,
    Category
FROM Sales.Products;    -- Internal table structure user ku theriyaadhu
GO

SELECT * FROM Sales.V_Product_Public;
GO

/*
   BENEFIT:
   Tomorrow: Products table rename aagindha →
   Only View update pannuvom →
   User query: SELECT * FROM Sales.V_Product_Public → Still works! ✅
*/



/* ==============================================================================
   SECTION 9 — VIEW vs CTE vs TEMP TABLE
--------------------------------------------------------------------------------

   ─────────────────────────────────────────────────────────────────
   Feature      │ View              │ CTE            │ Temp Table
   ─────────────│───────────────────│────────────────│────────────
   Storage      │ Query only (DB)   │ Memory only    │ TempDB
   Lifetime     │ Permanent         │ One query only │ Session end
   Reusability  │ ✅ All queries    │ ❌ Same query  │ 🟡 Same session
   Recursion    │ ❌ No             │ ✅ Yes         │ ❌ No
   Security     │ ✅ Row/col hide   │ ❌ No          │ ❌ No
   Performance  │ 🟡 Medium         │ 🟡 Medium      │ ✅ Index possible
   Maintenance  │ ✅ One place      │ Auto cleanup   │ Manual DROP
   ─────────────────────────────────────────────────────────────────

   WHEN TO USE:
   View       → Permanent reusable logic, security, reporting
   CTE        → Complex multi-step logic in one query, recursion
   Temp Table → Large data, multiple reuse, indexing needed
*/



/* ==============================================================================
   SECTION 10 — SUMMARY
--------------------------------------------------------------------------------

   VIEW = Virtual table (only query stored, not data)

   5 USE CASES:
   ─────────────────────────────────────────────────────
   1. Monthly Summary   → Aggregate data simple access
   2. Hide Complexity   → 4 table JOIN → Simple SELECT
   3. Data Security     → Filter rows + hide columns
   4. Reporting         → One view → All teams reuse
   5. Abstraction       → Table change → User unaffected
   ─────────────────────────────────────────────────────

   KEY COMMANDS:
   CREATE VIEW  → New view create
   ALTER VIEW   → Modify existing view
   DROP VIEW    → Delete view
   SELECT *     → Use view like a table

   WITHOUT VIEW → Duplicate JOIN, security risk, hard maintain
   WITH VIEW    → Clean, secure, reusable, easy maintain ✅

============================================================================== */