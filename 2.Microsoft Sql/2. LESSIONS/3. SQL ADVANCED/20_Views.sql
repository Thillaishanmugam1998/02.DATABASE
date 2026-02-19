/* =============================================================================
SQL SERVER VIEWS - COMPLETE GUIDE
=============================================================================*/

/* =============================================================================
DATABASE HIERARCHY
===============================================================================

SQL Server
  └── Database
        └── Schema
              └── Tables (Physical Data)
              └── Views  (Virtual Data)

===============================================================================*/


/* =============================================================================
DEFINITIONS
===============================================================================

SQL Server :
Stores and manages databases.

Database :
Structured collection of data.

Schema :
Logical container for database objects.

Table :
Physical storage of data (rows and columns).

View :
Virtual table created from a query.
Does not store data physically.

DDL (Data Definition Language) :
Commands used to manage database structure.
Examples: CREATE, ALTER, DROP

===============================================================================*/


/* =============================================================================
TABLE vs VIEW
===============================================================================

TABLE

• Stores physical data
• Faster performance
• Supports Read and Write
• Requires more maintenance


VIEW

• Does not store data
• Stores only query logic
• Used mainly for Read
• Easier maintenance

===============================================================================*/


/* =============================================================================
WHY USE VIEWS?
===============================================================================

1. Centralize complex query logic
2. Reduce query duplication
3. Improve reusability
4. Simplify data access
5. Improve data security

===============================================================================*/


/* =============================================================================
VIEW vs CTE
===============================================================================

VIEW

• Permanent object
• Reusable across multiple queries
• Requires manual maintenance


CTE

• Temporary object
• Used only within a single query
• Automatically cleaned up

===============================================================================*/


/* =============================================================================
VIEW SYNTAX
===============================================================================

CREATE VIEW Schema.ViewName AS
(
    SELECT columns
    FROM tables
    WHERE condition
)
===============================================================================*/


/* =============================================================================
USE CASE 1 : CREATE, DROP, MODIFY VIEW
===============================================================================

TASK :
Create a Monthly Sales Summary View

Returns:

• OrderMonth
• TotalSales
• TotalOrders
• TotalQuantities

===============================================================================*/


-- CREATE VIEW

CREATE VIEW Sales.V_Monthly_Summary AS

SELECT

    DATETRUNC(month, OrderDate) AS OrderMonth,
    SUM(Sales) AS TotalSales,
    COUNT(OrderID) AS TotalOrders,
    SUM(Quantity) AS TotalQuantities

FROM Sales.Orders

GROUP BY DATETRUNC(month, OrderDate);

GO



-- QUERY VIEW

SELECT * FROM Sales.V_Monthly_Summary;

GO



-- DROP VIEW

IF OBJECT_ID('Sales.V_Monthly_Summary', 'V') IS NOT NULL

DROP VIEW Sales.V_Monthly_Summary;

GO



-- MODIFY VIEW (Recreate with new logic)

CREATE VIEW Sales.V_Monthly_Summary AS

SELECT

    DATETRUNC(month, OrderDate) AS OrderMonth,
    SUM(Sales) AS TotalSales,
    COUNT(OrderID) AS TotalOrders

FROM Sales.Orders

GROUP BY DATETRUNC(month, OrderDate);

GO




/* =============================================================================
USE CASE 2 : HIDE QUERY COMPLEXITY
===============================================================================

TASK :
Create View combining multiple tables

Tables Used:

• Orders
• Products
• Customers
• Employees

===============================================================================*/


CREATE VIEW Sales.V_Order_Details AS

SELECT

    o.OrderID,
    o.OrderDate,

    p.Product,
    p.Category,

    COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') AS CustomerName,
    c.Country AS CustomerCountry,

    COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') AS SalesName,
    e.Department,

    o.Sales,
    o.Quantity

FROM Sales.Orders o

LEFT JOIN Sales.Products p
ON p.ProductID = o.ProductID

LEFT JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID

LEFT JOIN Sales.Employees e
ON e.EmployeeID = o.SalesPersonID;

GO




/* =============================================================================
USE CASE 3 : DATA SECURITY VIEW
===============================================================================

TASK :
Create View for EU Team

Requirement:

Exclude USA Customers

===============================================================================*/


CREATE VIEW Sales.V_Order_Details_EU AS

SELECT

    o.OrderID,
    o.OrderDate,

    p.Product,
    p.Category,

    COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') AS CustomerName,
    c.Country AS CustomerCountry,

    COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') AS SalesName,
    e.Department,

    o.Sales,
    o.Quantity

FROM Sales.Orders o

LEFT JOIN Sales.Products p
ON p.ProductID = o.ProductID

LEFT JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID

LEFT JOIN Sales.Employees e
ON e.EmployeeID = o.SalesPersonID

WHERE c.Country != 'USA';

GO

/* =============================================================================
USE CASE 4 : REPORTING AND REUSABILITY
===============================================================================

PURPOSE :

• Used by Reporting Team
• Avoid writing complex query multiple times
• Central place for report data

SCENARIO :

Management wants Sales Report by Category and Country

===============================================================================*/


CREATE VIEW Sales.V_Sales_Report

AS

SELECT

    DATETRUNC(MONTH, o.OrderDate) AS OrderMonth,

    p.Category,

    c.Country,

    SUM(o.Sales) AS TotalSales,

    SUM(o.Quantity) AS TotalQuantity,

    COUNT(o.OrderID) AS TotalOrders

FROM Sales.Orders o

JOIN Sales.Products p
ON p.ProductID = o.ProductID

JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID

GROUP BY

    DATETRUNC(MONTH, o.OrderDate),
    p.Category,
    c.Country;

GO



-- REPORT TEAM QUERY

SELECT * FROM Sales.V_Sales_Report;

GO




/* =============================================================================
USE CASE 5 : ABSTRACTION LAYER
===============================================================================

PURPOSE :

• Hide actual table structure
• Users interact only with View
• Prevent direct table access

BENEFIT :

If table structure changes,
View can be modified without impacting users

===============================================================================*/


CREATE VIEW Sales.V_Product_Public

AS

SELECT

    ProductID,
    Product,
    Category

FROM Sales.Products;

GO



-- USER QUERY

SELECT * FROM Sales.V_Product_Public;

GO




/* =============================================================================
FINAL SUMMARY : ALL VIEW USE CASES
===============================================================================

Views are used for:

1. Create aggregated summary
2. Hide complex joins
3. Improve data security
4. Simplify reporting
5. Improve query reusability
6. Provide abstraction layer
7. Control data access

===============================================================================*/
/* =============================================================================
REAL-TIME PROBLEM WITHOUT VIEW AND SOLUTION WITH VIEW
===============================================================================

SCENARIO :

Company : E-Commerce Application

Tables :

Sales.Orders
Sales.Customers
Sales.Products

Users :

• Reporting Team
• Developer Team
• Manager

===============================================================================*/



/* =============================================================================
PROBLEM 1 : WITHOUT VIEW - COMPLEX QUERY EVERY TIME
===============================================================================

Every user must write same JOIN query.

Problems :

• Time consuming
• Error-prone
• Duplicate code
• Hard to maintain

===============================================================================*/


-- REPORT TEAM QUERY

SELECT

    o.OrderID,
    o.OrderDate,

    c.FirstName + ' ' + c.LastName AS CustomerName,

    p.Product,
    p.Category,

    o.Sales

FROM Sales.Orders o

JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID

JOIN Sales.Products p
ON p.ProductID = o.ProductID;



-- MANAGER QUERY (AGAIN SAME JOIN)

SELECT

    p.Category,

    SUM(o.Sales) AS TotalSales

FROM Sales.Orders o

JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID

JOIN Sales.Products p
ON p.ProductID = o.ProductID

GROUP BY p.Category;



/*

REAL-TIME PROBLEMS :

Problem 1 :
Same JOIN repeated everywhere

Problem 2 :
If table structure changes,
Need modify 100+ queries

Problem 3 :
High chance of developer mistakes

Problem 4 :
Difficult to maintain

*/




/* =============================================================================
SOLUTION : WITH VIEW
===============================================================================

Create View Once

===============================================================================*/


CREATE VIEW Sales.V_OrderDetails

AS

SELECT

    o.OrderID,
    o.OrderDate,

    c.FirstName + ' ' + c.LastName AS CustomerName,

    p.Product,
    p.Category,

    o.Sales,
    o.Quantity

FROM Sales.Orders o

JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID

JOIN Sales.Products p
ON p.ProductID = o.ProductID;

GO




/* =============================================================================
NOW USERS USE SIMPLE QUERY
===============================================================================*/


-- REPORT TEAM QUERY

SELECT *

FROM Sales.V_OrderDetails;




-- MANAGER QUERY

SELECT

    Category,

    SUM(Sales) AS TotalSales

FROM Sales.V_OrderDetails

GROUP BY Category;




/*

REAL-TIME BENEFITS :

Benefit 1 :
No JOIN required

Benefit 2 :
Easy to use

Benefit 3 :
Reduce duplicate code

Benefit 4 :
Easy maintenance

Benefit 5 :
Less errors

*/




/* =============================================================================
REAL-TIME PROBLEM 2 : SECURITY ISSUE WITHOUT VIEW
===============================================================================

Employee table contains salary

Manager should not see salary

===============================================================================*/


-- WITHOUT VIEW (SECURITY RISK)

SELECT *

FROM HR.Employees;



/*
Problem :

Salary column visible

Security issue

*/




/* =============================================================================
SOLUTION : WITH VIEW
===============================================================================*/


CREATE VIEW HR.V_Employee_Public

AS

SELECT

    EmployeeID,
    FirstName,
    LastName,
    Department

FROM HR.Employees;

GO




-- USER QUERY

SELECT *

FROM HR.V_Employee_Public;



/*

BENEFIT :

Salary hidden

Improves security

*/




/* =============================================================================
FINAL REAL-TIME SUMMARY
===============================================================================

WITHOUT VIEW PROBLEMS :

• Duplicate queries
• Hard maintenance
• Security risk
• Complex query writing
• High chance of errors



WITH VIEW BENEFITS :

• Easy access
• Secure data
• Reusable query
• Easy maintenance
• Cleaner architecture


===============================================================================*/
