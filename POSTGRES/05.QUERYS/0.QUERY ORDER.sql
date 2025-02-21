**************************************************************************************************************************************************
Here is the execution order of SQL clauses in PostgreSQL:
--------------------------------------------------------
Execution Order of SQL Clauses:

FROM (and JOINs)

WHERE

GROUP BY

HAVING

SELECT

DISTINCT

ORDER BY

LIMIT / OFFSET
**************************************************************************************************************************************************

**************************************************************************************************************************************************
Detailed Explanation:
---------------------
1. FROM (and JOINs)
PostgreSQL first identifies the tables involved in the query and performs any necessary joins.
This step retrieves the raw data from the tables.

2. WHERE
After retrieving the raw data, PostgreSQL applies the WHERE clause to filter rows based on the specified conditions.
Only rows that satisfy the WHERE condition are included in the result set.

3. GROUP BY
If the query includes a GROUP BY clause, PostgreSQL groups the filtered rows based on the specified columns.
This step is necessary for aggregate functions like COUNT, SUM, AVG, etc.

4. HAVING
After grouping, PostgreSQL applies the HAVING clause to filter groups based on conditions applied to aggregate values.
Only groups that satisfy the HAVING condition are included in the result set.

5. SELECT
PostgreSQL now evaluates the SELECT clause to determine which columns to include in the final result set.
This step also evaluates any expressions or calculations specified in the SELECT clause.

6. DISTINCT
If the query includes the DISTINCT keyword, PostgreSQL removes duplicate rows from the result set.

7. ORDER BY
PostgreSQL sorts the final result set based on the columns specified in the ORDER BY clause.

8. LIMIT / OFFSET
Finally, PostgreSQL applies the LIMIT and OFFSET clauses to restrict the number of rows returned and skip a specified number of rows, respectively.
**************************************************************************************************************************************************

**************************************************************************************************************************************************
Example Query:
-------------
Let is use an example query to illustrate the execution order:

SELECT department_id, AVG(salary) AS avg_salary
FROM employees
WHERE salary > 40000
GROUP BY department_id
HAVING AVG(salary) > 50000
ORDER BY avg_salary DESC
LIMIT 2;


Execution Steps:
----------------
FROM: PostgreSQL retrieves all rows from the employees table.

WHERE: Filters rows where salary > 40000.

GROUP BY: Groups the filtered rows by department_id.

HAVING: Filters groups where the average salary is greater than 50,000.

SELECT: Calculates the average salary for each group and selects department_id and avg_salary.

ORDER BY: Sorts the result set by avg_salary in descending order.

LIMIT: Returns only the top 2 rows from the sorted result set.

Key Points:
----------
1.The execution order is different from the written order of the query.
2.Understanding the execution order helps in optimizing queries and debugging issues.
3.For example, you cannot use a column alias defined in the SELECT clause in the WHERE clause because the WHERE clause is executed before the SELECT clause.
**************************************************************************************************************************************************

**************************************************************************************************************************************************
Common Mistakes:
----------------
Using SELECT aliases in WHERE:


SELECT employee_name AS name
FROM employees
WHERE name = 'Alice'; -- Error: "name" is not recognized in WHERE
Fix: Use the original column name in the WHERE clause.

Using HAVING without GROUP BY:

HAVING is used to filter groups, so it requires a GROUP BY clause (unless you are using it with aggregate functions on the entire table).

Summary:
--------
The execution order of SQL clauses in PostgreSQL is:

FROM → 2. WHERE → 3. GROUP BY → 4. HAVING → 5. SELECT → 6. DISTINCT → 7. ORDER BY → 8. LIMIT/OFFSET.

**************************************************************************************************************************************************
