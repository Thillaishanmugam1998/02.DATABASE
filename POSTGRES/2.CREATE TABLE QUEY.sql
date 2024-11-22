--1.CREATE A TABLE:
-------------------
CREATE TABLE employees (
	employee_id SERIAL PRIMARY KEY,
	first_name VARCHAR (50),
	last_name  VARCHAR (50),
	department VARCHAR (50),
	salary 	   NUMERIC (10,2),
	hire_date  DATE
);

--2. SELECT TABLE:
-----------------
SELECT * FROM employees
SELECT employee_id,first_name,last_name,department,salary,hire_date FROM employees

--3. DROP TABLE:
----------------
DROP TABLE IF EXISTS employees

--4. DESCRIPE TABLE:
-------------------
SELECT *
FROM information_schema.columns
WHERE table_name = 'employees';

--5.ALTER TABLE:
----------------
ALTER TABLE employees 
ADD COLUMN email VARCHAR (100);

ALTER TABLE employees
RENAME COLUMN email TO contact_email;

ALTER TABLE employees
ALTER COLUMN salary TYPE BIGINT;

ALTER TABLE employees 
DROP COLUMN contact_email ;

ALTER TABLE  employees RENAME TO employee;
ALTER TABLE employee RENAME TO employees;

ALTER DATABSE "JuwelApp" RENAME TO "juwelapp";

--6. INSERT TABLE:
------------------
INSERT INTO  employees (first_name,last_name,department,salary,hire_date,contact_email)
VALUES
	('Tamizh','Vani','frontend',150000,'17-01-2003','tamizhvani1714@gmail.com'),
	('Thillai','Shanmugam','Backend',100000,'14-04-1998','thillaishanmugamsathish@gmail.com');
