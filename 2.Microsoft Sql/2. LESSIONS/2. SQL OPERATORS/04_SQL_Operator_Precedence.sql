/*========================================================
 FILE NAME : Operator_Precedence.sql
 TOPIC     : Operator Precedence in SQL Server
 DB        : SQL Server
 PURPOSE   :
   - Understand operator precedence (execution order)
   - Avoid logical bugs in calculations and filters
   - Learn how parentheses change results
========================================================*/


/*========================================================
 1) WHAT IS OPERATOR PRECEDENCE?
========================================================*/
/*
 Operator precedence defines the order in which SQL Server
 evaluates operators in an expression.

 If multiple operators exist in one expression:
 - SQL Server evaluates higher-precedence operators first
 - Parentheses () override default precedence
*/


/*========================================================
 2) OPERATOR PRECEDENCE ORDER (HIGH → LOW)
========================================================*/
/*
 1) ( )              Parentheses
 2) *, /, %          Multiplication, Division, Modulo
 3) +, -             Addition, Subtraction
 4) Comparison       =, <>, !=, >, <, >=, <=
 5) NOT
 6) AND
 7) OR
*/


/*========================================================
 3) ARITHMETIC PRECEDENCE (NO PARENTHESES)
========================================================*/

SELECT 10 + 5 * 2 AS Result;
GO

/*
 Evaluation:
 5 * 2 = 10
 10 + 10 = 20

 OUTPUT:
 -------
 20
*/


/*========================================================
 4) ARITHMETIC PRECEDENCE WITH PARENTHESES
========================================================*/

SELECT (10 + 5) * 2 AS Result;
GO

/*
 Evaluation:
 (10 + 5) = 15
 15 * 2 = 30

 OUTPUT:
 -------
 30
*/


/*========================================================
 5) MULTIPLE OPERATORS TOGETHER
========================================================*/

SELECT 100 - 20 / 5 * 2 AS Result;
GO

/*
 Evaluation:
 20 / 5 = 4
 4 * 2 = 8
 100 - 8 = 92

 OUTPUT:
 -------
 92
*/


/*========================================================
 6) USING VARIABLES
========================================================*/

DECLARE @A INT = 10, @B INT = 5, @C INT = 2;

SELECT @A + @B * @C AS WithoutBrackets;
SELECT (@A + @B) * @C AS WithBrackets;
GO

/*
 OUTPUT:
 -----------------
 WithoutBrackets | WithBrackets
 -----------------
 20              | 30
*/


/*========================================================
 7) COMPARISON + LOGICAL PRECEDENCE
========================================================*/

DROP TABLE IF EXISTS Employees;
GO

CREATE TABLE Employees
(
    EmpId   INT,
    Name    NVARCHAR(50),
    Salary  INT,
    Dept    NVARCHAR(20)
);
GO

INSERT INTO Employees VALUES
(1, 'Arun',   30000, 'IT'),
(2, 'Bala',   18000, 'HR'),
(3, 'Charan', 25000, 'IT'),
(4, 'Deepak', 15000, 'Admin'),
(5, 'Ezhil',  22000, 'HR');
GO


/*========================================================
 8) AND vs OR (WITHOUT PARENTHESES)
========================================================*/

SELECT *
FROM Employees
WHERE Dept = 'IT' OR Dept = 'HR' AND Salary > 20000;
GO

/*
 Evaluation:
 AND has higher precedence than OR

 Equivalent to:
 Dept = 'IT'
 OR (Dept = 'HR' AND Salary > 20000)

 RESULT:
 - All IT employees
 - HR employees with Salary > 20000
*/


/*========================================================
 9) AND vs OR (WITH PARENTHESES)
========================================================*/

SELECT *
FROM Employees
WHERE (Dept = 'IT' OR Dept = 'HR')
  AND Salary > 20000;
GO

/*
 Evaluation:
 Parentheses executed first

 RESULT:
 - IT and HR employees
 - Only if Salary > 20000
*/


/*========================================================
 10) NOT OPERATOR PRECEDENCE
========================================================*/

SELECT *
FROM Employees
WHERE NOT Salary > 20000;
GO

/*
 Equivalent to:
 WHERE Salary <= 20000
*/


/*========================================================
 11) REAL-TIME BUG EXAMPLE (INTERVIEW FAVORITE)
========================================================*/

-- ❌ BUGGY QUERY
SELECT *
FROM Employees
WHERE Dept = 'IT' OR Dept = 'HR' AND Salary >= 25000;
GO

-- ✅ CORRECT QUERY
SELECT *
FROM Employees
WHERE (Dept = 'IT' OR Dept = 'HR')
  AND Salary >= 25000;
GO


/*========================================================
 12) BEST PRACTICES
========================================================*/

-- 1) Always use parentheses for clarity
-- 2) Never rely on default precedence in business logic
-- 3) Parentheses improve readability and avoid bugs
-- 4) Critical in WHERE and HAVING clauses


/*========================================================
 13) QUICK INTERVIEW QUESTIONS
========================================================*/

-- Q1: Which has higher precedence AND or OR?
-- A : AND

-- Q2: Which executes first?
--     10 + 5 * 2  OR  (10 + 5) * 2
-- A : 10 + (5 * 2)

-- Q3: Best practice?
-- A : Always use parentheses


/*========================================================
 END OF FILE
========================================================*/
