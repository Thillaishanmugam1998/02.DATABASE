/***********************************************************************
SQL NOTES: Combining Data (Set Operators)
Author: ChatGPT
Level: Beginner to Advanced
DB: SQL Server
Purpose:
  - Understand how to combine query results
  - Learn set operators: UNION, UNION ALL, INTERSECT, EXCEPT
  - Practice real-time and interview-oriented examples
************************************************************************/

/*========================================================
1) WHAT ARE SET OPERATORS?
========================================================*/
/*
Set operators are used to combine results from two or more SELECT statements into a single result set.

Types of Set Operators in SQL Server:
1) UNION       : Combines results and removes duplicates
2) UNION ALL   : Combines results and keeps duplicates
3) INTERSECT   : Returns only common rows from both queries
4) EXCEPT      : Returns rows from first query not in the second query

RULES:
- Each SELECT must have same number of columns
- Data types must be compatible
- Column names are taken from the first SELECT
*/

/*========================================================
2) WHY SET OPERATORS ARE NEEDED?
========================================================*/
/*
Real-life use cases:
- UNION: Combine sales from two different regions
- UNION ALL: Combine logs from multiple sources including duplicates
- INTERSECT: Find students enrolled in both courses
- EXCEPT: Find products in warehouse A not in warehouse B
*/

/*========================================================
3) CREATE SAMPLE TABLES
========================================================*/
DROP TABLE IF EXISTS Sales2022;
DROP TABLE IF EXISTS Sales2023;
DROP TABLE IF EXISTS StudentsA;
DROP TABLE IF EXISTS StudentsB;
GO

CREATE TABLE Sales2022
(
    SaleID INT,
    Product NVARCHAR(50),
    Amount INT
);
GO

INSERT INTO Sales2022 VALUES
(1, 'Mouse', 500),
(2, 'Keyboard', 800),
(3, 'Monitor', 1200);
GO

CREATE TABLE Sales2023
(
    SaleID INT,
    Product NVARCHAR(50),
    Amount INT
);
GO

INSERT INTO Sales2023 VALUES
(4, 'Mouse', 500),
(5, 'Keyboard', 900),
(6, 'Laptop', 5000);
GO

CREATE TABLE StudentsA
(
    StudentID INT,
    Name NVARCHAR(50)
);
GO

INSERT INTO StudentsA VALUES
(1, 'Arun'),
(2, 'Bala'),
(3, 'Charan');
GO

CREATE TABLE StudentsB
(
    StudentID INT,
    Name NVARCHAR(50)
);
GO

INSERT INTO StudentsB VALUES
(2, 'Bala'),
(3, 'Charan'),
(4, 'Deepak');
GO

/*========================================================
4) UNION OPERATOR
========================================================*/
-- Syntax:
-- SELECT columns FROM table1
-- UNION
-- SELECT columns FROM table2;

-- Example: Combine sales from 2022 and 2023 (remove duplicates)
SELECT Product, Amount
FROM Sales2022
UNION
SELECT Product, Amount
FROM Sales2023;
GO
/*
 OUTPUT:
 Product   | Amount
 -----------------
 Mouse     | 500
 Keyboard  | 800
 Monitor   | 1200
 Keyboard  | 900
 Laptop    | 5000
*/

-- Notes: UNION removes duplicate rows

/*========================================================
5) UNION ALL OPERATOR
========================================================*/
-- Combines results and keeps duplicates
SELECT Product, Amount
FROM Sales2022
UNION ALL
SELECT Product, Amount
FROM Sales2023;
GO
/*
 OUTPUT:
 Product   | Amount
 -----------------
 Mouse     | 500
 Keyboard  | 800
 Monitor   | 1200
 Mouse     | 500
 Keyboard  | 900
 Laptop    | 5000
*/

-- Use case: when you need full data including duplicates (e.g., total logs)

/*========================================================
6) INTERSECT OPERATOR
========================================================*/
-- Returns only rows common to both queries
SELECT Name
FROM StudentsA
INTERSECT
SELECT Name
FROM StudentsB;
GO
/*
 OUTPUT:
 Name
 -----
 Bala
 Charan
*/

-- Use case: Find students enrolled in both courses

/*========================================================
7) EXCEPT OPERATOR
========================================================*/
-- Returns rows from first query that are NOT in second query
SELECT Name
FROM StudentsA
EXCEPT
SELECT Name
FROM StudentsB;
GO
/*
 OUTPUT:
 Name
 -----
 Arun
*/

-- Use case: Find students in course A not in course B

/*========================================================
8) MULTIPLE EXAMPLES WITH COMBINATIONS
========================================================*/
-- Example 1: Combine sales from 2022 and 2023 and get unique products
SELECT Product
FROM Sales2022
UNION
SELECT Product
FROM Sales2023;
GO
/*
 OUTPUT:
 Product
 -------
 Mouse
 Keyboard
 Monitor
 Laptop
*/

-- Example 2: Products sold in both years
SELECT Product
FROM Sales2022
INTERSECT
SELECT Product
FROM Sales2023;
GO
/*
 OUTPUT:
 Product
 -------
 Mouse
 Keyboard
*/

-- Example 3: Products sold in 2022 but not in 2023
SELECT Product
FROM Sales2022
EXCEPT
SELECT Product
FROM Sales2023;
GO
/*
 OUTPUT:
 Product
 -------
 Monitor
*/

/*========================================================
9) IMPORTANT TIPS AND NOTES
========================================================*/
/*
1) Number and order of columns must match in all SELECTs.
2) Data types of corresponding columns must be compatible.
3) UNION removes duplicates; UNION ALL keeps duplicates.
4) INTERSECT returns only common rows.
5) EXCEPT returns rows from first query that are not in second.
6) Column names in final output are from the first SELECT.
7) Parentheses can be used to combine multiple operators for complex queries.
*/

/*========================================================
10) SUMMARY
========================================================*/
/*
SET OPERATORS:
1) UNION     : Combine results, remove duplicates
2) UNION ALL : Combine results, keep duplicates
3) INTERSECT : Rows common to both queries
4) EXCEPT    : Rows in first query but not in second
Rules:
- Same number of columns
- Compatible data types
- Column names from first SELECT
*/

--=========================================================
-- END OF FILE: Combining Data (Set Operators)
--=========================================================
