
********************************************************************************************************************
--GROUP BY Clause
--The GROUP BY clause groups rows that have the same values in specified columns into summary rows.
--It is often used with aggregate functions like COUNT, SUM, AVG, MIN, and MAX to perform 
calculations on each group of rows.

Syntax:
------
SELECT column1, aggregate_function(column2)
FROM table_name
GROUP BY column1;


SELECT * FROM departments
SELECT * FROM employees

--Example 1: Basic GROUP BY
--Query: Find the total salary for each departme
SELECT department_id, SUM(salary)
FROM employees
GROUP BY department_id

--Example 2: GROUP BY with JOIN
--Query: Find the total salary for each department, along with the department name.
SELECT e.department_id, d.department_name, SUM(salary) AS TotalSalary
FROM employees AS e
INNER JOIN departments AS d ON e.department_id = d.department_id
GROUP BY e.department_id,d.department_name

--Example 3: COUNT
--Query: Count the number of employees in each department.
SELECT e.department_id, d.department_name, COUNT(salary) AS ToTalEmployee
FROM employees AS e
INNER JOIN departments AS d ON e.department_id = d.department_id
GROUP BY e.department_id,d.department_name	

--Example 4: AVG
---Query: Calculate the average salary for each department.
SELECT e.department_id,d.department_name,AVG(salary) as department_AvgSalary
FROM employees AS e 
INNER JOIN departments AS d ON e.department_id = d.department_id
GROUP BY e.department_id, d.department_name

--Example 5: MIN
--Query: Find the minimum salary in each department.
SELECT e.department_id,d.department_name,MIN(salary) as department_AvgSalary
FROM employees AS e 
INNER JOIN departments AS d ON e.department_id = d.department_id
GROUP BY e.department_id, d.department_name


--Example 6: MAX
--Query: Find the maximum salary in each department.
SELECT e.department_id,d.department_name,MAX(salary) as department_AvgSalary
FROM employees AS e 
INNER JOIN departments AS d ON e.department_id = d.department_id
GROUP BY e.department_id, d.department_name
********************************************************************************************************************

********************************************************************************************************************
--HAVING Clause
--The HAVING clause is used to filter groups of rows based on a condition applied to the result of aggregate functions.
--It is similar to the WHERE clause, but WHERE filters rows before grouping, while HAVING filters groups after grouping.
Syntax:
-------

SELECT column1, aggregate_function(column2)
FROM table_name
GROUP BY column1
HAVING condition;

--Example 1: HAVING with COUNT
--Query: Find departments with more than 2 employees.
SELECT d.department_id,department_name,COUNT(salary) AS total_employees
FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
GROUP BY d.department_id,d.department_name
HAVING COUNT(e.department_id)>=2


--Example 2: HAVING with SUM
--Query: Find departments where the total salary is greater than 140,000.
SELECT d.department_id,d.department_name, SUM(salary) AS TotalSalary
FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
GROUP BY d.department_id,d.department_name
HAVING SUM(salary) >= 100000

--Example 3: HAVING with AVG
--Query: Find departments where the average salary is greater than 50,000.
SELECT d.department_id,d.department_name, AVG(salary) AS avergae_salary
FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
GROUP BY d.department_id,d.department_name
HAVING AVG(salary) >= 10000

--Example 4: HAVING with MIN
--Query: Find departments where the minimum salary is less than 50,000.
SELECT d.department_id,d.department_name, MIN(salary) AS avergae_salary
FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
GROUP BY d.department_id,d.department_name
HAVING MIN(salary) < 50000


--Example 5: HAVING with MAX
--Query: Find departments where the maximum salary is less than 50,000.
SELECT d.department_id,d.department_name, MAX(salary) AS avergae_salary
FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
GROUP BY d.department_id,d.department_name
HAVING MAX(salary) > 50000
********************************************************************************************************************

********************************************************************************************************************