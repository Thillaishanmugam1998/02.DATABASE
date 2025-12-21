/*========================================================
 FILE NAME  : Where_vs_Having.sql
 TOPIC      : Difference Between WHERE and HAVING Clause
 DATABASE   : SQL Server
 PURPOSE    :
   - Understand WHERE vs HAVING
   - Learn execution order
   - Learn performance impact
   - Practice interview-based examples
========================================================*/


/*========================================================
 STEP 1: CREATE SAMPLE TABLE
========================================================*/

DROP TABLE IF EXISTS Sales;
GO

CREATE TABLE Sales
(
    Product     NVARCHAR(50),
    SaleAmount  INT
);
GO


/*========================================================
 STEP 2: INSERT SAMPLE DATA
========================================================*/

INSERT INTO Sales VALUES ('iPhone',   500);
INSERT INTO Sales VALUES ('Laptop',   800);
INSERT INTO Sales VALUES ('iPhone',  1000);
INSERT INTO Sales VALUES ('Speakers', 400);
INSERT INTO Sales VALUES ('Laptop',   600);
GO


/*========================================================
 VIEW DATA
========================================================*/
SELECT * FROM Sales;
GO


/*========================================================
 EXAMPLE 1: TOTAL SALES BY PRODUCT (GROUP BY)
========================================================*/

SELECT 
    Product,
    SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY Product;
GO

/*
 OUTPUT:
 --------------------------------
 Product     | TotalSales
 --------------------------------
 iPhone      | 1500
 Laptop      | 1400
 Speakers    | 400
*/


/*========================================================
 EXAMPLE 2: FILTER GROUPS USING HAVING
 Find products where total sales > 1000
========================================================*/

SELECT 
    Product,
    SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY Product
HAVING SUM(SaleAmount) > 1000;
GO

/*
 OUTPUT:
 -------------------------
 Product  | TotalSales
 -------------------------
 iPhone   | 1500
 Laptop  | 1400
*/


/*========================================================
 EXAMPLE 3: INVALID USE OF WHERE WITH AGGREGATE
 (THIS WILL FAIL)
========================================================*/

-- ❌ WRONG QUERY
/*
SELECT 
    Product,
    SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY Product
WHERE SUM(SaleAmount) > 1000;
*/

-- ❌ ERROR:
-- Incorrect syntax near the keyword 'WHERE'
-- Reason: WHERE cannot be used with aggregate functions


/*========================================================
 KEY RULE:
 WHERE  → Filters ROWS (before aggregation)
 HAVING → Filters GROUPS (after aggregation)
========================================================*/


/*========================================================
 EXAMPLE 4: USING WHERE (FILTER FIRST, THEN AGGREGATE)
 Calculate total sales of iPhone and Speakers
========================================================*/

SELECT 
    Product,
    SUM(SaleAmount) AS TotalSales
FROM Sales
WHERE Product IN ('iPhone', 'Speakers')
GROUP BY Product;
GO

/*
 EXECUTION FLOW:
 1) WHERE filters rows
 2) GROUP BY groups rows
 3) SUM calculates totals

 PERFORMANCE: FAST ✅
*/


/*========================================================
 EXAMPLE 5: USING HAVING (AGGREGATE FIRST, THEN FILTER)
 Calculate total sales of iPhone and Speakers
========================================================*/

SELECT 
    Product,
    SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY Product
HAVING Product IN ('iPhone', 'Speakers');
GO

/*
 EXECUTION FLOW:
 1) All rows selected
 2) GROUP BY applied
 3) SUM calculated
 4) HAVING filters groups

 PERFORMANCE: SLOWER ❌
*/


/*========================================================
 BEST PRACTICE:
 Always use WHERE instead of HAVING
 when aggregate condition is NOT required
========================================================*/


/*========================================================
 WHERE + HAVING TOGETHER (REAL INTERVIEW QUESTION)
========================================================*/

SELECT 
    Product,
    SUM(SaleAmount) AS TotalSales
FROM Sales
WHERE SaleAmount >= 500          -- row-level filter
GROUP BY Product
HAVING SUM(SaleAmount) > 1000;   -- group-level filter
GO

/*
 EXECUTION ORDER:
 1) FROM
 2) WHERE
 3) GROUP BY
 4) HAVING
 5) SELECT
*/


/*========================================================
 FINAL DIFFERENCE SUMMARY (INTERVIEW READY)
========================================================*/

-- 1) WHERE cannot be used with aggregate functions
--    HAVING can be used with aggregate functions

-- 2) WHERE filters individual rows
--    HAVING filters grouped data

-- 3) WHERE executes BEFORE GROUP BY
--    HAVING executes AFTER GROUP BY

-- 4) WHERE is faster than HAVING

-- 5) WHERE can be used with:
--    SELECT, INSERT, UPDATE, DELETE

-- 6) HAVING can be used ONLY with SELECT


/*========================================================
 END OF FILE
========================================================*/
