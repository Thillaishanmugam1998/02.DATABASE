/***********************************************************************
SQL NOTES: DIFFERENCE BETWEEN GROUP BY AND WHERE & CLAUSE EXECUTION FLOW
Author: ChatGPT
Level: Beginner to Advanced
Topic: GROUP BY vs WHERE & SQL Clause Execution Flow
Purpose: Complete study notes from zero to hero
************************************************************************/

-- ===============================================================
-- 1. WHAT IS THIS TOPIC ABOUT?
-- ===============================================================
/*
This topic explains:
1. The difference between GROUP BY and WHERE in SQL.
2. When to use each.
3. How SQL queries are executed internally (Execution Flow).

Key points:
- WHERE filters rows BEFORE grouping/aggregation.
- GROUP BY arranges rows into groups for aggregation.
- HAVING filters groups AFTER aggregation.
- SQL execution flow determines the order in which clauses are processed.
*/

-- ===============================================================
-- 2. WHY THIS TOPIC IS NEEDED?
-- ===============================================================
/*
Real-life use cases:
1. Sales Analysis:
   - WHERE: Filter sales in a specific region before calculating totals.
   - GROUP BY: Find total sales per product.
   - HAVING: Show only products with total sales > 1000.
2. HR Analytics:
   - WHERE: Employees with salary > 5000
   - GROUP BY: Total salary per department
   - HAVING: Departments where total salary > 20000
3. Analytics & Reporting: Understanding clause execution prevents mistakes in queries.
*/

-- ===============================================================
-- 3. SYNTAX
-- ===============================================================
/*
Basic structure with GROUP BY, WHERE, and HAVING:

SELECT column1, AGGREGATE_FUNCTION(column2)
FROM table_name
WHERE condition_on_rows       -- Filters rows before grouping
GROUP BY column1              -- Groups rows
HAVING condition_on_groups    -- Filters groups after aggregation
ORDER BY column;              -- Sorts result

Key differences:
- WHERE: operates on individual rows
- GROUP BY: groups rows for aggregation
- HAVING: operates on aggregated groups
*/

-- ===============================================================
-- 4. SQL CLAUSE EXECUTION FLOW
-- ===============================================================
/*
SQL executes queries in this logical order:

1. FROM      -> Identify table(s) to use
2. JOIN      -> Combine tables if needed
3. WHERE     -> Filter rows BEFORE grouping
4. GROUP BY  -> Group filtered rows
5. HAVING    -> Filter groups AFTER aggregation
6. SELECT    -> Choose columns & calculate aggregates
7. ORDER BY  -> Sort final result
*/

-- ===============================================================
-- 5. STEP-BY-STEP EXAMPLES WITH TABLES
-- ===============================================================

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
-- Example 1: Using WHERE to filter rows BEFORE grouping
-- Find total quantity per product for North region only
SELECT product, SUM(quantity) AS total_quantity
FROM Sales
WHERE region = 'North'   -- Filters rows first
GROUP BY product;

-- Output:
-- +--------+---------------+
-- | product| total_quantity|
-- +--------+---------------+
-- | Laptop | 18            |
-- | Phone  | 20            |
-- | Tablet | 7             |
-- +--------+---------------+

-- ===============================================================
-- Example 2: Using HAVING to filter groups AFTER grouping
-- Find products with total quantity > 15 (all regions)
SELECT product, SUM(quantity) AS total_quantity
FROM Sales
GROUP BY product
HAVING SUM(quantity) > 15;  -- Filters after aggregation

-- Output:
-- +--------+---------------+
-- | product| total_quantity|
-- +--------+---------------+
-- | Laptop | 23            |
-- | Phone  | 35            |
-- +--------+---------------+

-- ===============================================================
-- Example 3: WHERE vs HAVING combined
-- Filter North region first, then show products with total quantity > 15
SELECT product, SUM(quantity) AS total_quantity
FROM Sales
WHERE region = 'North'
GROUP BY product
HAVING SUM(quantity) > 15;

-- Output:
-- +--------+---------------+
-- | product| total_quantity|
-- +--------+---------------+
-- | Laptop | 18            |
-- | Phone  | 20            |
-- +--------+---------------+

-- ===============================================================
-- Example 4: Multiple conditions in WHERE and HAVING
-- Only South region, products with total quantity >= 5
SELECT product, SUM(quantity) AS total_quantity
FROM Sales
WHERE region = 'South'       -- Row filter
GROUP BY product
HAVING SUM(quantity) >= 5;   -- Group filter

-- Output:
-- +--------+---------------+
-- | product| total_quantity|
-- +--------+---------------+
-- | Laptop | 5             |
-- | Phone  | 15            |
-- +--------+---------------+

-- ===============================================================
-- 6. IMPORTANT TIPS AND NOTES
-- ===============================================================
/*
1. WHERE filters rows before any aggregation.
2. GROUP BY groups the filtered rows.
3. HAVING filters the aggregated results.
4. You cannot use aggregate functions in WHERE (ERROR), only in HAVING.
   Example: WHERE SUM(quantity) > 10 -- ❌ WRONG
5. Always follow SQL execution order mentally to debug queries.
6. WHERE can improve performance because it reduces rows before grouping.
7. Common mistake: Confusing WHERE and HAVING. Remember:
   - WHERE = row filter
   - HAVING = group filter
*/

-- ===============================================================
-- 7. SUMMARY (Quick Revision)
-- ===============================================================
/*
- WHERE: filters individual rows BEFORE grouping.
- GROUP BY: groups rows for aggregation.
- HAVING: filters groups AFTER aggregation.
- SQL Execution Flow:
    1. FROM
    2. JOIN
    3. WHERE
    4. GROUP BY
    5. HAVING
    6. SELECT
    7. ORDER BY
- Aggregate functions (SUM, COUNT, AVG, MIN, MAX) must be filtered with HAVING, not WHERE.
- Use WHERE to reduce rows early for performance, HAVING for group conditions.
*/

-- ===============================================================
-- End of SQL Notes: GROUP BY vs WHERE & Clause Execution Flow
-- ===============================================================
