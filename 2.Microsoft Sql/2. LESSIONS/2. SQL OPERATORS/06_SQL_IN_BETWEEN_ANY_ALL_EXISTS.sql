/***********************************************************************
SQL NOTES: BETWEEN, LIKE, IN, ALL, ANY, EXISTS
Author: ChatGPT
Level: Beginner to Advanced
DB: SQL Server
Purpose:
  - Understand advanced SQL operators for filtering
  - Learn usage with variables and table data
  - Practice real-time and interview-oriented examples
************************************************************************/

/*========================================================
1) WHAT ARE BETWEEN, LIKE, IN, ALL, ANY, EXISTS?
========================================================*/
/*
1) BETWEEN:
   - Filters data within a range of values (inclusive)
   - Works with numbers, dates, strings

2) LIKE:
   - Pattern matching for strings
   - Supports wildcards:
       % : any number of characters
       _ : exactly one character

3) IN:
   - Filters values that match a list of values
   - Syntax: column IN (value1, value2, ...)

4) ALL:
   - Compares a value to ALL values returned by a subquery
   - Example: value > ALL (subquery)

5) ANY / SOME:
   - Compares a value to ANY (at least one) value from subquery
   - Example: value = ANY (subquery)

6) EXISTS:
   - Checks if a subquery returns any row
   - Returns TRUE if at least one row exists
*/

/*========================================================
2) WHY THESE OPERATORS ARE NEEDED?
========================================================*/
/*
Real-life use cases:
- BETWEEN: Salary between 20000 and 40000
- LIKE: Find names starting with 'A'
- IN: Filter departments: IN ('IT','HR')
- ALL: Compare a product’s price against all competitors
- ANY: Check if a student scored more than any score in another class
- EXISTS: Check if a customer has orders
*/

/*========================================================
3) CREATE SAMPLE TABLES
========================================================*/
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
GO

CREATE TABLE Students
(
    StudentID INT,
    StudentName NVARCHAR(50),
    Score INT,
    Dept NVARCHAR(20)
);
GO

INSERT INTO Students VALUES
(1, 'Arun', 85, 'IT'),
(2, 'Bala', 72, 'HR'),
(3, 'Charan', 90, 'IT'),
(4, 'Deepak', 65, 'Admin'),
(5, 'Ezhil', 78, 'HR');
GO

CREATE TABLE Orders
(
    OrderID INT,
    Customer NVARCHAR(50),
    Amount INT
);
GO

INSERT INTO Orders VALUES
(101, 'Arun', 500),
(102, 'Bala', 800),
(103, 'Arun', 1200),
(104, 'Charan', 700);
GO

CREATE TABLE Products
(
    ProductID INT,
    ProductName NVARCHAR(50),
    Price INT
);
GO

INSERT INTO Products VALUES
(1, 'Mouse', 500),
(2, 'Keyboard', 800),
(3, 'Monitor', 1200),
(4, 'Laptop', 5000);
GO

/*========================================================
4) BETWEEN OPERATOR
========================================================*/
SELECT * 
FROM Students
WHERE Score BETWEEN 70 AND 90;
GO

SELECT *
FROM Orders
WHERE Amount BETWEEN 600 AND 1300;
GO

/*========================================================
5) LIKE OPERATOR
========================================================*/
SELECT * 
FROM Students
WHERE StudentName LIKE 'A%';
GO

SELECT * 
FROM Students
WHERE StudentName LIKE '%a';
GO

SELECT * 
FROM Students
WHERE StudentName LIKE '_____';
GO

/*========================================================
6) IN OPERATOR
========================================================*/
-- Syntax: column IN (value1, value2, value3, ...)

-- Example 1: Students in IT or HR
SELECT *
FROM Students
WHERE Dept IN ('IT','HR');
GO
/*
 OUTPUT: Arun, Bala, Charan, Ezhil
*/

-- Example 2: Orders with specific amounts
SELECT *
FROM Orders
WHERE Amount IN (500, 700);
GO
/*
 OUTPUT: OrderID 101, 104
*/

-- Example 3: Using NOT IN
SELECT *
FROM Students
WHERE Dept NOT IN ('IT','HR');
GO
/*
 OUTPUT: Deepak (Admin)
*/

/*========================================================
7) ALL OPERATOR
========================================================*/
SELECT *
FROM Students
WHERE Score > ALL (SELECT Score FROM Students WHERE Score < 80);
GO
/*
 OUTPUT: Arun(85), Charan(90)
*/

/*========================================================
8) ANY / SOME OPERATOR
========================================================*/
SELECT *
FROM Students
WHERE Score > ANY (SELECT Score FROM Students WHERE Score < 70);
GO
/*
 OUTPUT: Arun, Bala, Charan, Ezhil
*/

/*========================================================
9) EXISTS OPERATOR
========================================================*/
SELECT DISTINCT Customer
FROM Orders O
WHERE EXISTS (
    SELECT 1 
    FROM Orders 
    WHERE Customer = O.Customer
);
GO

SELECT StudentName
FROM Students S
WHERE EXISTS (
    SELECT 1
    FROM Orders O
    WHERE O.Customer = S.StudentName
);
GO

/*========================================================
10) COMBINED EXAMPLES
========================================================*/
-- Students scoring 70-90 AND in IT or HR
SELECT *
FROM Students
WHERE Score BETWEEN 70 AND 90
  AND Dept IN ('IT','HR');
GO

-- Orders where amount is 500 or 700 AND customer exists in Students
SELECT *
FROM Orders O
WHERE Amount IN (500,700)
  AND EXISTS (
    SELECT 1
    FROM Students S
    WHERE S.StudentName = O.Customer
);
GO

-- Products with price > ALL products < 1000
SELECT *
FROM Products
WHERE Price > ALL (SELECT Price FROM Products WHERE Price < 1000);
GO

/*========================================================
11) IMPORTANT TIPS AND NOTES
========================================================*/
/*
1) BETWEEN is inclusive: low and high included.
2) LIKE:
   - % : any characters
   - _ : single character
3) IN: matches a value against a list
   - NOT IN filters everything except the list
4) ALL: value must satisfy comparison with all subquery results
5) ANY/SOME: value must satisfy comparison with at least one subquery result
6) EXISTS: returns TRUE if subquery returns any rows
7) Combine operators with AND/OR for complex conditions
8) Use EXISTS for correlated subqueries to check row-wise conditions
*/

/*========================================================
12) SUMMARY
========================================================*/
/*
BETWEEN : filter value within range (inclusive)
LIKE    : string pattern matching (% and _)
IN      : value matches list of values
ALL     : value compared to all subquery results
ANY/SOME: value compared to at least one subquery result
EXISTS  : subquery returns at least one row
*/

/*========================================================
END OF FILE: BETWEEN, LIKE, IN, ALL, ANY, EXISTS
========================================================*/
