**********************************************************************************************************************************
--DROP A TABLE
DROP TABLE IF EXISTS employees

--CREATE A TABLE
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT,
    salary NUMERIC(10, 2)
);

CREATE TABLE departments(
	department_id SERIAL PRIMARY KEY,
	department_name VARCHAR(50) NOT NULL
);

--INSERT A SAMPLE DATA
INSERT INTO employees (employee_name,department_id,salary) VALUES
('Alice',1,50000),
('Bob',2,60000),
('Charlie', 1, 55000),
('David', NULL, 70000),
('Eve', 3, 45000);

INSERT INTO departments (department_name) VALUES
('HR'),
('Engineering'),
('Marketing');

--SELECT DATA FROM TABLE
SELECT * FROM employees
SELECT * FROM departments
**********************************************************************************************************************************

**********************************************************************************************************************************
--TABLE ALIES
SELECT e.employee_name,d.department_name
FROM employees AS e
JOIN departments AS d 
ON e.department_id = d.department_id
**********************************************************************************************************************************

**********************************************************************************************************************************
--INNER JOIN
--An Inner Join returns only the rows that have matching values in both tables.
SELECT e.employee_name,d.department_name
FROM employees AS e
INNER JOIN departments AS d 
ON e.department_id = d.department_id
**********************************************************************************************************************************

**********************************************************************************************************************************
--Key Concepts:
Left Table: The table that appears first in the FROM clause of the query.

Right Table: The table that appears after the JOIN keyword in the query.

LEFT JOIN: Returns all rows from the left table, and matching rows from the right table. If no match is found, NULL is returned for columns from the right table.

RIGHT JOIN: Returns all rows from the right table, and matching rows from the left table. If no match is found, NULL is returned for columns from the left table.
	
--LEFT JOIN
SELECT e.employee_name,d.department_name
FROM employees AS e
LEFT JOIN departments AS d 
ON e.department_id = d.department_id

--LEFT JOIN
SELECT e.employee_name,d.department_name
FROM departments AS d
LEFT JOIN employees AS e 
ON d.department_id = e.department_id

--RIGHT JOIN
SELECT e.employee_name,d.department_name
FROM employees AS e
RIGHT JOIN departments AS d 
ON e.department_id = d.department_id

SELECT e.employee_name,d.department_name
FROM departments AS d
RIGHT JOIN employees AS e 
ON d.department_id = e.department_id
**********************************************************************************************************************************

**********************************************************************************************************************************