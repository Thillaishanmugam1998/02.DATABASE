/* =============================================================================
SQL SERVER - COMMON TABLE EXPRESSIONS (CTE) CLEAN PROFESSIONAL VERSION
===============================================================================

DEFINITION
-------------------------------------------------------------------------------
CTE (Common Table Expression) is a temporary named result set used only within
a single query. It improves readability and avoids duplicate queries.

KEY POINTS
-------------------------------------------------------------------------------
• Temporary result (not stored permanently)
• Exists only for one query
• Improves readability
• Used for aggregation, ranking, hierarchy

ORDER BY RULE
-------------------------------------------------------------------------------
ORDER BY is NOT allowed inside CTE unless used with TOP, OFFSET, or FOR XML

WRONG ❌
WITH CTE_Test AS
(
    SELECT *
    FROM Sales.Orders
    ORDER BY Sales DESC
)

CORRECT ✅
WITH CTE_Test AS
(
    SELECT *
    FROM Sales.Orders
)
SELECT *
FROM CTE_Test
ORDER BY Sales DESC;

===============================================================================*/



/* =============================================================================
PROBLEM WITHOUT CTE (REAL-TIME)
-------------------------------------------------------------------------------
Duplicate query written multiple times
Hard to maintain
===============================================================================*/

SELECT CustomerID, SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID;

SELECT CustomerID, MAX(OrderDate) AS LastOrder
FROM Sales.Orders
GROUP BY CustomerID;



/* =============================================================================
SOLUTION USING STAND-ALONE CTE
-------------------------------------------------------------------------------
Defined and used independently
===============================================================================*/

WITH CTE_TotalSales AS
(
    SELECT CustomerID, SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
)
SELECT CustomerID, TotalSales
FROM CTE_TotalSales;



/* =============================================================================
NESTED CTE (MULTIPLE CTE)
-------------------------------------------------------------------------------
One CTE uses another CTE
===============================================================================*/

WITH CTE_TotalSales AS
(
    SELECT CustomerID, SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
),
CTE_CustomerRank AS
(
    SELECT CustomerID, TotalSales,
           RANK() OVER (ORDER BY TotalSales DESC) AS CustomerRank
    FROM CTE_TotalSales
),
CTE_CustomerSegment AS
(
    SELECT CustomerID, TotalSales,
           CASE
               WHEN TotalSales > 100 THEN 'High'
               WHEN TotalSales > 80 THEN 'Medium'
               ELSE 'Low'
           END AS CustomerSegment
    FROM CTE_TotalSales
)
SELECT c.CustomerID, c.FirstName, c.LastName,
       ts.TotalSales, cr.CustomerRank, cs.CustomerSegment
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales ts ON ts.CustomerID = c.CustomerID
LEFT JOIN CTE_CustomerRank cr ON cr.CustomerID = c.CustomerID
LEFT JOIN CTE_CustomerSegment cs ON cs.CustomerID = c.CustomerID;



/* =============================================================================
RECURSIVE CTE - GENERATE NUMBER SEQUENCE
-------------------------------------------------------------------------------
Used to generate numbers (replaces loops)
===============================================================================*/

WITH CTE_NumberSeries AS
(
    SELECT 1 AS Number
    UNION ALL
    SELECT Number + 1
    FROM CTE_NumberSeries
    WHERE Number < 20
)
SELECT Number
FROM CTE_NumberSeries
OPTION (MAXRECURSION 100);



/* =============================================================================
RECURSIVE CTE - EMPLOYEE HIERARCHY
-------------------------------------------------------------------------------
Used for hierarchy data like Manager -> Employee
===============================================================================*/

WITH CTE_EmployeeHierarchy AS
(
    SELECT EmployeeID, FirstName, ManagerID, 1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL

    UNION ALL

    SELECT e.EmployeeID, e.FirstName, e.ManagerID, Level + 1
    FROM Sales.Employees e
    INNER JOIN CTE_EmployeeHierarchy h
        ON e.ManagerID = h.EmployeeID
)
SELECT EmployeeID, FirstName, ManagerID, Level
FROM CTE_EmployeeHierarchy;



/* =============================================================================
FINAL SUMMARY
===============================================================================

STAND-ALONE CTE
• Independent
• Used once

NESTED CTE
• Uses another CTE
• Used for complex logic

RECURSIVE CTE
• Self-referencing
• Used for sequence and hierarchy

WITHOUT CTE PROBLEMS
• Duplicate queries
• Hard maintenance

WITH CTE BENEFITS
• Clean code
• Easy maintenance
• Better readability

INTERVIEW ANSWER
-------------------------------------------------------------------------------
CTE is used to simplify complex queries and avoid duplicate logic.

===============================================================================*/
