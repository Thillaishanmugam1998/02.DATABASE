/***********************************************************************
SQL NOTES: HAVING
Author: ChatGPT
Level: Beginner to Advanced
Topic: HAVING
Purpose: Complete study notes from zero to hero
************************************************************************/

-- ===============================================================
-- 1. WHAT IS HAVING?
-- ===============================================================
/*
HAVING is a SQL clause used to filter groups of data after 
they have been aggregated using GROUP BY. 

- Think of WHERE as a filter for individual rows.
- HAVING filters the results of grouped rows.
- It is almost always used with GROUP BY and aggregate functions 
  like SUM, COUNT, AVG, MIN, MAX.

In simple words:
- Use WHERE to filter before grouping.
- Use HAVING to filter after grouping.
*/

-- Analogy:
-- Imagine you group students by class to calculate average marks.
-- HAVING lets you see only classes where the average marks are above 70.

-- ===============================================================
-- 2. WHY HAVING IS NEEDED?
-- ===============================================================
/*
Real-life use cases:
1. Sales: Show only products where total sales > 1000 units.
2. HR: Find departments with more than 10 employees.
3. Education: List classes with average score above 80.
4. Analytics: Count cities with more than 100 active users.

Without HAVING, you can group data but cannot filter based on aggregates.
*/

-- ===============================================================
-- 3. SYNTAX
-- ===============================================================
/*
Basic Syntax:

SELECT column1, column2, AGGREGATE_FUNCTION(column)
FROM table_name
WHERE conditions -- optional, filters rows BEFORE grouping
GROUP BY column1, column2
HAVING aggregate_condition -- filters groups AFTER aggregation
ORDER BY column;

Explanation:
- SELECT: Columns to display.
- AGGREGATE_FUNCTION: SUM, COUNT, AVG, MIN, MAX.
- FROM: The table to query.
- WHERE: Filters individual rows before grouping.
- GROUP BY: Defines how rows are grouped.
- HAVING: Filters groups based on aggregate values.
- ORDER BY: Sorts the final result.
*/

-- ===============================================================
-- 4. STEP-BY-STEP EXAMPLES WITH TABLES
-- ===============================================================

-- Drop Table
Drop table Sales;

-- Sample table: Sales
CREATE TABLE Sales (
    id INT,
    product VARCHAR(50),
    region VARCHAR(50),
    quantity INT,
    price DECIMAL(10,2)
);

-- Sample data
INSERT INTO Sales (id, product, region, quantity, price) VALUES
(1, 'Laptop', 'North', 10, 800),
(2, 'Laptop', 'South', 5, 850),
(3, 'Phone', 'North', 20, 500),
(4, 'Phone', 'South', 15, 520),
(5, 'Tablet', 'North', 7, 300),
(6, 'Tablet', 'South', 3, 320),
(7, 'Laptop', 'North', 8, 800);

-- ===============================================================
-- Example 1: HAVING with SUM
-- Total quantity per product where total quantity > 15
SELECT product, SUM(quantity) AS total_quantity
FROM Sales
GROUP BY product
HAVING SUM(quantity) > 15;

-- Expected output:
-- +--------+---------------+
-- | product| total_quantity|
-- +--------+---------------+
-- | Laptop | 23            |
-- | Phone  | 35            |
-- +--------+---------------+

-- ===============================================================
-- Example 2: HAVING with COUNT
-- Products sold in more than 2 regions
SELECT product, COUNT(DISTINCT region) AS regions_sold
FROM Sales
GROUP BY product
HAVING COUNT(DISTINCT region) > 1;

-- Output:
-- +--------+--------------+
-- | product| regions_sold |
-- +--------+--------------+
-- | Laptop | 2            |
-- | Phone  | 2            |
-- | Tablet | 2            |
-- +--------+--------------+

-- ===============================================================
-- Example 3: HAVING with AVG
-- Products with average price > 500
SELECT product, AVG(price) AS avg_price
FROM Sales
GROUP BY product
HAVING AVG(price) > 500;

-- Output:
-- +--------+----------+
-- | product| avg_price|
-- +--------+----------+
-- | Laptop | 816.67   |
-- | Phone  | 510      |
-- +--------+----------+

-- ===============================================================
-- Example 4: Using HAVING with multiple conditions
-- Products where total quantity > 10 AND average price > 500
SELECT product, SUM(quantity) AS total_quantity, AVG(price) AS avg_price
FROM Sales
GROUP BY product
HAVING SUM(quantity) > 10 AND AVG(price) > 500;

-- Output:
-- +--------+---------------+----------+
-- | product| total_quantity| avg_price|
-- +--------+---------------+----------+
-- | Laptop | 23            | 816.67   |
-- | Phone  | 35            | 510      |
-- +--------+---------------+----------+

-- ===============================================================
-- Example 5: HAVING vs WHERE
-- Show only North region data first, then group by product
-- Filter groups where total quantity > 10
SELECT product, SUM(quantity) AS total_quantity
FROM Sales
WHERE region = 'North'  -- filters rows BEFORE grouping
GROUP BY product
HAVING SUM(quantity) > 10; -- filters groups AFTER aggregation

-- Output:
-- +--------+---------------+
-- | product| total_quantity|
-- +--------+---------------+
-- | Phone  | 20            |
-- +--------+---------------+

-- ===============================================================
-- 5. IMPORTANT TIPS AND NOTES
-- ===============================================================
/*
1. HAVING is always used with GROUP BY. Without GROUP BY, use WHERE instead.
2. Use HAVING to filter based on aggregate functions (SUM, COUNT, AVG, MIN, MAX).
3. WHERE filters individual rows before grouping.
4. HAVING filters groups after aggregation.
5. You can combine multiple conditions with AND/OR in HAVING.
6. Common mistake: using non-aggregated columns in HAVING without GROUP BY → ERROR.
7. HAVING can also be used without WHERE, but usually after GROUP BY.
*/

-- ===============================================================
-- 6. SUMMARY
-- ===============================================================
/*
- HAVING filters aggregated groups.
- Use it with GROUP BY and aggregate functions.
- Syntax: SELECT columns, AGG_FUNC(column) FROM table GROUP BY columns HAVING condition;
- WHERE filters rows before grouping, HAVING filters groups after grouping.
- Supports SUM, COUNT, AVG, MIN, MAX, and logical conditions.
*/

-- ===============================================================
-- End of SQL HAVING Notes
-- ===============================================================
