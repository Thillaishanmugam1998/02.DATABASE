***********************************************************************************************************
Step 1: Create a  New Table
---------------------------
CREATE TABLE users(
	id  SERIAL PRIMARY KEY,
	name VARCHAR(50),
	age  INT,
	city VARCHAR(50)	
);
***********************************************************************************************************

***********************************************************************************************************
Step 2: Insert Data into the Table
----------------------------------
INSERT INTO users( name, age, city ) VALUES
('A',30,'Thanjavur'),
('B',25,'Kumbakonam'),
('C',35,'Orathanadu'),
('D',45,'Chennai'),
('E',30,'Madurai')
***********************************************************************************************************

***********************************************************************************************************
Step 3: Retrieve Data Using SQL Commands:
-----------------------------------------
--1. SELECT Statement:
SELECT * FROM users

SELECT id,name,age,city FROM users

--2. Column Aliases
SELECT name AS user_name, age AS user_age FROM users

--3. ORDER BY Clause
SELECT * FROM users ORDER BY age ASC
SELECT * FROM users ORDER BY age DESC

--4. SELECT DISTINCT
SELECT DISTINCT age FROM users			(WORK)
SELECT DISTINCT age,name FROM users	(NOT WORK)
***********************************************************************************************************

***********************************************************************************************************
