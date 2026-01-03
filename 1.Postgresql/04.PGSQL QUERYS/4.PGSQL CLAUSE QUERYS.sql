-- ADD NEW COLOUMN:
ALTER TABLE employees
ADD COLUMN joining_date DATE;
--=========================================================================================================================

--=========================================================================================================================
-- SELECT TABLE
SELECT * FROM employees ORDER BY id  ASC


-- UPDATE TABLE
UPDATE employees
SET joining_date = '2024/01/01'

	
-- Update joining_date for particular employee
UPDATE employees
SET joining_date = '2024/02/20'
WHERE name = 'Thillai-1'

	
-- Update joining_date for each employee
UPDATE employees
SET joining_date = CASE 
    WHEN name = 'Thillai-1' THEN '2024-01-01' :: DATE
    WHEN name = 'Thillai-2' THEN '2024-02-01' :: DATE
    WHEN name = 'Thillai-3' THEN '2024-03-01' :: DATE
    WHEN name = 'Thillai-4' THEN '2024-04-01' :: DATE
    WHEN name = 'Thillai-5' THEN '2024-05-01' :: DATE
    WHEN name = 'Tamizh-1' THEN '2024-06-01' :: DATE
    WHEN name = 'Tamizh-2' THEN '2024-07-01' :: DATE
    WHEN name = 'Tamizh-3' THEN '2024-08-01' :: DATE
    WHEN name = 'Tamizh-4' THEN '2024-09-01' :: DATE
    WHEN name = 'Tamizh-5' THEN '2024-10-01' :: DATE
END;

--=====================================================================================================
--PostgreSQL WHERE CLAUSE
SELECT * FROM employees WHERE department = 'HR'
SELECT * FROM employees WHERE department = 'Accounts'
SELECT * FROM employees WHERE department = 'Finance'
SELECT * FROM employees WHERE department = 'IT'
SELECT * FROM employees WHERE department = 'Sales'

SELECT * FROM employees WHERE (salary > 50000)
SELECT * FROM employees WHERE (salary >= 20000)
SELECT * FROM employees WHERE (salary >=20000) AND (salary < 50000)

--=====================================================================================================
--PostgreSQL WHERE CLAUSE
SELECT * FROM employees
SELECT * FROM employees ORDER BY id ASC
SELECT * FROM employees ORDER BY id DESC
SELECT * FROM employees ORDER BY joining_date ASC
SELECT * FROM employees ORDER BY joining_date DESC
SELECT * FROM employees WHERE department = 'HR'
SELECT * FROM employees WHERE department = 'Accounts'
SELECT * FROM employees WHERE department = 'Finance'
SELECT * FROM employees WHERE department = 'IT'
SELECT * FROM employees WHERE department = 'Sales'

SELECT * FROM employees WHERE (salary > 50000)
SELECT * FROM employees WHERE (salary >= 20000) ORDER BY salary ASC
SELECT * FROM employees WHERE (salary >=20000) AND (salary < 50000)


--=====================================================================================================
--PostgreSQL WHERE CLAUSE
SELECT department,
FROM employees
GROUP BY department,name;

--=====================================================================================================
--PostgreSQL GROUB BY CLAUSE
 
SELECT  * FROM employees ORDER BY id ASC

--GROUP BY CLAUSE IS USED TO ARRANGE IDENTICAL DATA INTO GROUPS
SELECT department FROM employees GROUP BY department; 
SELECT department, salary FROM employees GROUP BY department;

SELECT department,SUM(salary) AS total_salary 
FROM employees
GROUP BY department;

SELECT department,AVG(salary) AS average_salary 
FROM employees
GROUP BY department;

SELECT department,MIN(salary) AS minimum_salary
FROM employees
GROUP BY department;

SELECT department,MAX(salary) AS maximum_salary 
FROM employees
GROUP BY department;

SELECT department,COUNT(*) AS total_employees
FROM employees
GROUP BY department;

SELECT salary FROM employees GROUP BY salary

SELECT salary, COUNT(*) FROM employees GROUP BY salary


INSERT INTO employees (name,department,salary,joining_date)
VALUES
	('Tamizhillai','Marketing',80000,'2024-11-01'),
	('Shanmugam','IT',150000,'2024-11-01'),
	('Sathish','HR',10000,'2024-11-01')


--=====================================================================================================
--PostgreSQL HAVING  CLAUSE

SELECT department, COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING (COUNT(*) < 2)

SELECT department, COUNT(*) AS employee_count, SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING (SUM(salary) > 150000)

--=====================================================================================================
--PostgreSQL DISTINCT
	
SELECT  DISTINCT department
FROM employees;

--=====================================================================================================
--PostgreSQL LIMI

SELECT *
FROM employees
ORDER BY id ASC
LIMIT 5;

--=====================================================================================================
--postgreSQL FETCH:
SELECT *
FROM employees
ORDER BY id ASC
FETCH FIRST 10 ROW ONLY;
