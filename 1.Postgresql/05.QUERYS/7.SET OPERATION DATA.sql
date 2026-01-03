******************************************************************************************************************************
--set operations

--CREATE A TABLE
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE teachers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

--INSERT VALUES INTO VALUES
INSERT INTO teachers (name) VALUES
('Alice'),('Bob'),('Tamil'),('Thillai')

INSERT INTO students (name) VALUES
('Alice'),('Bob'),('sabi'),('sathish')

--RETRIVE A DATA
SELECT * FROM teachers
SELECT * FROM students
******************************************************************************************************************************

******************************************************************************************************************************
--1. UNION
The UNION operation is used to combine the results of two or more SELECT queries into a single result set. It removes duplicate rows by default. 
If you want to include duplicates, you can use UNION ALL.

SELECT * FROM teachers
UNION
SELECT * FROM students

SELECT * FROM teachers
UNION ALL
SELECT * FROM students
******************************************************************************************************************************

******************************************************************************************************************************
--2. INTERSECT
The INTERSECT operation returns the common rows that appear in the result sets of both SELECT queries.

SELECT * FROM teachers
INTERSECT
SELECT * FROM students 
******************************************************************************************************************************

******************************************************************************************************************************
--3. EXCEPT
The EXCEPT operation returns rows from the first SELECT query that are not present in the result set of the second SELECT query.
SELECT * FROM teachers
EXCEPT
SELECT * FROM students 
******************************************************************************************************************************

******************************************************************************************************************************

Summary
-------
UNION: Combines results from multiple queries and removes duplicates.

INTERSECT: Returns common rows from multiple queries.

EXCEPT: Returns rows from the first query that are not in the second query.
	