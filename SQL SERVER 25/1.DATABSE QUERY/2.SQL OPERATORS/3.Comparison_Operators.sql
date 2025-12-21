/*========================================================
 FILE NAME : Comparison_Operators.sql
 TOPIC     : Comparison Operators in SQL Server
 DB        : SQL Server
 PURPOSE   :
   - Understand comparison operators
   - Learn usage with variables and table data
   - Practice interview-oriented examples
========================================================*/


/*========================================================
 1) WHAT ARE COMPARISON OPERATORS?
========================================================*/
/*
 Comparison operators are used to compare two values.
 They always return TRUE or FALSE logically
 (in result set: row is returned or not).

 SQL Server Comparison Operators:
 =    Equal to
 <>   Not equal to
 !=   Not equal to
 >    Greater than
 <    Less than
 >=   Greater than or equal to
 <=   Less than or equal to
*/


/*========================================================
 2) CREATE SAMPLE TABLE
========================================================*/

DROP TABLE IF EXISTS Employees;
GO

CREATE TABLE Employees
(
    EmpId     INT,
    EmpName   NVARCHAR(50),
    Salary    INT,
    Dept      NVARCHAR(20)
);
GO

INSERT INTO Employees VALUES (1, 'Arun',   25000, 'IT');
INSERT INTO Employees VALUES (2, 'Bala',   18000, 'HR');
INSERT INTO Employees VALUES (3, 'Charan', 30000, 'IT');
INSERT INTO Employees VALUES (4, 'Deepak', 15000, 'Admin');
INSERT INTO Employees VALUES (5, 'Ezhil',  22000, 'HR');
GO


/*========================================================
 VIEW TABLE DATA
========================================================*/
SELECT * FROM Employees;
GO


/*========================================================
 3) EQUAL TO OPERATOR (=)
========================================================*/

SELECT *
FROM Employees
WHERE Dept = 'IT';
GO

/*
 OUTPUT:
 Employees working in IT department
*/


/*========================================================
 4) NOT EQUAL TO OPERATOR (<>)
========================================================*/

SELECT *
FROM Employees
WHERE Dept <> 'HR';
GO

/*
 Returns all employees except HR department
*/


/*========================================================
 5) NOT EQUAL TO OPERATOR (!=)
========================================================*/

SELECT *
FROM Employees
WHERE Salary != 25000;
GO

/*
 Same as <> operator
*/


/*========================================================
 6) GREATER THAN OPERATOR (>)
========================================================*/

SELECT *
FROM Employees
WHERE Salary > 20000;
GO

/*
 Employees earning more than 20000
*/


/*========================================================
 7) LESS THAN OPERATOR (<)
========================================================*/

SELECT *
FROM Employees
WHERE Salary < 20000;
GO

/*
 Employees earning less than 20000
*/


/*========================================================
 8) GREATER THAN OR EQUAL TO (>=)
========================================================*/

SELECT *
FROM Employees
WHERE Salary >= 22000;
GO

/*
 Salary 22000 and above
*/


/*========================================================
 9) LESS THAN OR EQUAL TO (<=)
========================================================*/

SELECT *
FROM Employees
WHERE Salary <= 18000;
GO

/*
 Salary 18000 and below
*/


/*========================================================
 10) COMPARISON OPERATORS WITH VARIABLES
========================================================*/

DECLARE @MinSalary INT = 20000;

SELECT *
FROM Employees
WHERE Salary >= @MinSalary;
GO


/*========================================================
 11) REAL-TIME USE CASES
========================================================*/
/*
 - Salary filtering
 - Age eligibility
 - Date range comparison
 - Stock availability
 - Access control rules
*/


/*========================================================
 12) INTERVIEW TRICK QUESTIONS
========================================================*/

-- Q1: Difference between <> and != ?
-- A : No difference in SQL Server (both mean NOT EQUAL)

-- Q2: Can comparison operators be used with WHERE?
-- A : Yes, very commonly

-- Q3: Can comparison operators be used with HAVING?
-- A : Yes, with aggregate functions

-- Example:
SELECT Dept, COUNT(*) AS EmpCount
FROM Employees
GROUP BY Dept
HAVING COUNT(*) > 1;
GO


/*========================================================
 KEY POINTS SUMMARY
========================================================*/

-- =   Equal
-- <>  Not Equal
-- !=  Not Equal
-- >   Greater Than
-- <   Less Than
-- >=  Greater Than or Equal
-- <=  Less Than or Equal

-- Used mainly in WHERE and HAVING clauses
-- Core concept for filtering data


/*========================================================
 END OF FILE
========================================================*/
