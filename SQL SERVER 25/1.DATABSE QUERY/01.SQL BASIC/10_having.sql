/*========================================================
  TOPIC NAME : HAVING CLAUSE
  FILE NAME  : HAVING_CONCEPT.sql
  DATABASE   : SQL SERVER
========================================================*/

/*========================================================
  1️⃣ WHAT IS HAVING?
----------------------------------------------------------
  HAVING clause is used to filter GROUPED data.
  It works AFTER GROUP BY.
  It is mainly used with aggregate functions.
========================================================*/

-- Simple definition:
-- WHERE  → filters rows
-- HAVING → filters groups (aggregate result)

/*========================================================
  2️⃣ FLOW OF QUERY CLAUSES (EXECUTION ORDER)
----------------------------------------------------------
  SQL does NOT execute in written order.
  Logical execution order is:
  
  1. FROM
  2. WHERE
  3. GROUP BY
  4. HAVING
  5. SELECT
  6. ORDER BY
========================================================*/

/*========================================================
  3️⃣ CREATE SAMPLE TABLE
========================================================*/

DROP TABLE IF EXISTS Employee;
GO

CREATE TABLE Employee
(
    EmpId   INT PRIMARY KEY,
    EmpName VARCHAR(50),
    City    VARCHAR(20),
    Salary  INT
);
GO

/*========================================================
  4️⃣ INSERT SAMPLE DATA
========================================================*/

INSERT INTO Employee VALUES
(1, 'Arun',   'MUMBAI',   20000),
(2, 'Bala',   'MUMBAI',   30000),
(3, 'Chandru','MUMBAI',   25000),
(4, 'David',  'DELHI',    15000),
(5, 'Ezhil',  'DELHI',    20000),
(6, 'Fazil',  'CHENNAI',  18000),
(7, 'Ganesh', 'CHENNAI',  12000);
GO

SELECT * FROM Employee;
GO

/*========================================================
  5️⃣ GROUP BY WITHOUT HAVING
========================================================*/

SELECT City, SUM(Salary) AS TotalSalary
FROM Employee
GROUP BY City;
GO

/*========================================================
  6️⃣ HAVING WITH AGGREGATE FUNCTIONS
========================================================*/

-- 6.1 SUM()
-- Cities where total salary > 60000
SELECT City, SUM(Salary) AS TotalSalary
FROM Employee
GROUP BY City
HAVING SUM(Salary) > 60000;
GO


-- 6.2 COUNT()
-- Cities having more than 2 employees
SELECT City, COUNT(*) AS EmpCount
FROM Employee
GROUP BY City
HAVING COUNT(*) > 2;
GO

-- 6.3 AVG()
-- Cities where average salary >= 20000
SELECT City, AVG(Salary) AS AvgSalary
FROM Employee
GROUP BY City
HAVING AVG(Salary) >= 20000;
GO

-- 6.4 MAX()
-- Cities where maximum salary >= 30000
SELECT City, MAX(Salary) AS MaxSalary
FROM Employee
GROUP BY City
HAVING MAX(Salary) >= 30000;
GO

-- 6.5 MIN()
-- Cities where minimum salary >= 15000
SELECT City, MIN(Salary) AS MinSalary
FROM Employee
GROUP BY City
HAVING MIN(Salary) >= 15000;
GO

/*========================================================
  7️⃣ WHY CANNOT USE WHERE WITH AGGREGATES?
========================================================*/

-- ❌ INVALID QUERY (ERROR)
-- WHERE executes BEFORE GROUP BY
-- Aggregate functions do NOT exist yet

/*
SELECT City, SUM(Salary)
FROM Employee
WHERE SUM(Salary) > 60000
GROUP BY City;
*/

-- ✅ CORRECT WAY USING HAVING

SELECT City, SUM(Salary) AS TotalSalary
FROM Employee
GROUP BY City
HAVING SUM(Salary) > 60000;
GO

/*========================================================
  8️⃣ WHERE + HAVING TOGETHER (BEST PRACTICE)
========================================================*/

-- Filter rows first using WHERE (FAST)
-- Then filter groups using HAVING

SELECT City, SUM(Salary) AS TotalSalary
FROM Employee
WHERE Salary >= 20000
GROUP BY City
HAVING SUM(Salary) > 50000;
GO

/*========================================================
  9️⃣ IMPORTANT INTERVIEW POINTS
========================================================*/

-- 1) WHERE cannot use aggregate functions
-- 2) HAVING must be used with GROUP BY (mostly)
-- 3) WHERE improves performance by filtering early
-- 4) HAVING is only for aggregated conditions

--WHERE condition use panninaa
--original (row-level) data-va filter pannalaam

--HAVING use panninaa
--aggregate result-a filter pannalaam
/*========================================================
  END OF FILE
========================================================*/
