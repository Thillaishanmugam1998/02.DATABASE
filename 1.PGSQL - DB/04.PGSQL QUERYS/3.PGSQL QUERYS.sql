--DROP TABLE
DROP TABLE IF EXISTS employees

--CREATE TABLE
CREATE TABLE employees(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100),
	department VARCHAR(50),
	salary NUMERIC
)

--SELECT TABLE
SELECT * FROM employees

--INSERT TABLE
INSERT INTO employees (name,department,salary)
VALUES
	('Thillai-1','HR',50000),
	('Thillai-2','Accounts',40000),
	('Thillai-3','Finance',35000),
	('Thillai-4','IT',100000),
	('Thillai-5','Sales',20000),
	('Tamizh-1','HR',50000),
	('Tamizh-2','Accounts',40000),
	('Tamizh-3','Finance',35000),
	('Tamizh-4','IT',100000),
	('Tamizh-5','Sales',20000);

--UPDATE TABLE
UPDATE employees
SET salary = 60000
WHERE department = 'IT'

--DELETE ROW
DELETE FROM employees
WHERE department = 'IT'
