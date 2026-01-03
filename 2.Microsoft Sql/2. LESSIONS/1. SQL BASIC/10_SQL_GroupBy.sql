/***********************************************************************
SQL NOTES: GROUP BY
Author: ChatGPT
Level: Beginner to Advanced
Topic: GROUP BY
Purpose: Complete study notes from zero to hero
************************************************************************/

-- ===============================================================
-- 1. WHAT IS GROUP BY?
-- ===============================================================
/*
GROUP BY is a SQL clause used to arrange identical data into groups. 
It is often used with aggregate functions like SUM, COUNT, AVG, MAX, MIN 
to perform calculations on each group of data rather than the whole table.

In simple words:
- It "groups" rows that have the same value in specified column(s).
- Then we can perform calculations on each group.
*/

-- Example analogy:
-- Think of a classroom where you want to know the total marks of each student. 
-- GROUP BY lets you collect all marks for each student and calculate totals per student.

-- ===============================================================
-- 2. WHY GROUP BY IS NEEDED?
-- ===============================================================
/*
Use cases in real life:
1. Business: Calculate total sales for each product or region.
2. Education: Find the average marks per class or student.
3. Analytics: Count number of users per city.
4. Finance: Sum expenses per department.

Without GROUP BY, aggregate functions would calculate only over 
the entire table, not per group.
*/

-- ===============================================================
-- 3. SYNTAX
-- ===============================================================
/*
Basic Syntax:

SELECT column1, column2, ..., AGGREGATE_FUNCTION(column)
FROM table_name
WHERE conditions
GROUP BY column1, column2, ... 
HAVING condition_on_aggregate
ORDER BY column;

Explanation:
- SELECT: Columns to display.
- AGGREGATE_FUNCTION: SUM, COUNT, AVG, MIN, MAX, etc.
- FROM: The table.
- WHERE: Filters rows BEFORE grouping.
- GROUP BY: Column(s) to group the data by.
- HAVING: Filters groups AFTER aggregation (like WHERE for groups).
- ORDER BY: Sort the final result.
*/

-- ===============================================================
-- 4. STEP-BY-STEP EXAMPLES WITH TABLES
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
-- Example 1: GROUP BY single column
-- Total quantity sold per product
SELECT product, SUM(quantity) AS total_quantity
FROM Sales
GROUP BY product;

-- Expected output:
-- +--------+---------------+
-- | product| total_quantity|
-- +--------+---------------+
-- | Laptop | 23            |
-- | Phone  | 35            |
-- | Tablet | 10            |
-- +--------+---------------+

-- ===============================================================
-- Example 2: GROUP BY multiple columns
-- Total quantity sold per product per region
SELECT product, region, SUM(quantity) AS total_quantity
FROM Sales
GROUP BY product, region;

-- Expected output:
-- +--------+--------+---------------+
-- | product| region | total_quantity|
-- +--------+--------+---------------+
-- | Laptop | North  | 18            |
-- | Laptop | South  | 5             |
-- | Phone  | North  | 20            |
-- | Phone  | South  | 15            |
-- | Tablet | North  | 7             |
-- | Tablet | South  | 3             |
-- +--------+--------+---------------+

-- ===============================================================
-- Example 3: Using COUNT
-- Count number of sales entries per product
SELECT product, COUNT(*) AS sales_count
FROM Sales
GROUP BY product;

-- Output:
-- +--------+------------+
-- | product| sales_count|
-- +--------+------------+
-- | Laptop | 3          |
-- | Phone  | 2          |
-- | Tablet | 2          |
-- +--------+------------+

-- ===============================================================
-- Example 4: Using AVG, MIN, MAX
-- Average price per product
SELECT product, AVG(price) AS avg_price,
              MIN(price) AS min_price,
              MAX(price) AS max_price
FROM Sales
GROUP BY product;

-- ===============================================================
-- Example 5: Using HAVING to filter groups
-- Products with total quantity sold greater than 15
SELECT product, SUM(quantity) AS total_quantity
FROM Sales
GROUP BY product
HAVING SUM(quantity) > 15;

-- Output:
-- +--------+---------------+
-- | product| total_quantity|
-- +--------+---------------+
-- | Laptop | 23            |
-- | Phone  | 35            |
-- +--------+---------------+

-- ===============================================================
-- Example 6: Combining GROUP BY with ORDER BY
-- Total quantity sold per product, sorted descending
SELECT product, SUM(quantity) AS total_quantity
FROM Sales
GROUP BY product
ORDER BY total_quantity DESC;

-- ===============================================================
-- 5. IMPORTANT TIPS AND NOTES
-- ===============================================================
/*
1. Every column in SELECT that is NOT aggregated must be in GROUP BY.
2. WHERE filters rows before grouping, HAVING filters groups after grouping.
3. GROUP BY can have multiple columns; groups are formed by unique combinations.
4. Use meaningful aliases (AS total_quantity) for readability.
5. Aggregate functions commonly used with GROUP BY:
   - COUNT(column) / COUNT(*)
   - SUM(column)
   - AVG(column)
   - MIN(column)
   - MAX(column)
6. Common mistakes:
   - Selecting columns without grouping or aggregation → ERROR.
   - Forgetting HAVING for filtering groups → leads to incorrect results.
*/

-- ===============================================================
-- 6. SUMMARY
-- ===============================================================
/*
- GROUP BY is used to group rows with the same values.
- Essential with aggregate functions to get group-level calculations.
- Syntax: SELECT columns, AGG_FUNC(column) FROM table GROUP BY columns;
- Use HAVING to filter after grouping, WHERE to filter before grouping.
- Multiple columns in GROUP BY → group by unique combinations.
- Common aggregates: SUM, COUNT, AVG, MIN, MAX.
*/

-- ===============================================================
-- End of SQL GROUP BY Notes
-- ===============================================================
