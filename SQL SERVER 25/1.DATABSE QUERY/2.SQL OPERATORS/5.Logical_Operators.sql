/*========================================================
 FILE NAME : Logical_Operators.sql
 TOPIC     : Logical Operators in SQL Server
 DB        : SQL Server
 PURPOSE   :
   - Understand AND, OR, NOT operators
   - Learn real-time filtering logic
   - Avoid common logical mistakes
   - Prepare for interview questions
========================================================*/


/*========================================================
 1) WHAT ARE LOGICAL OPERATORS?
========================================================*/
/*
 Logical operators are used to combine or negate
 multiple conditions in SQL.

 SQL Server Logical Operators:
 - AND
 - OR
 - NOT
*/


/*========================================================
 2) CREATE SAMPLE TABLE
========================================================*/

DROP TABLE IF EXISTS Employees;
GO

CREATE TABLE Employees
(
    EmpId   INT,
    EmpName NVARCHAR(50),
    Salary  INT,
    Dept    NVARCHAR(20),
    City    NVARCHAR(20)
);
GO

INSERT INTO Employees VALUES
(1, 'Arun',   30000, 'IT',    'Chennai'),
(2, 'Bala',   18000, 'HR',    'Madurai'),
(3, 'Charan', 25000, 'IT',    'Chennai'),
(4, 'Deepak', 15000, 'Admin', 'Trichy'),
(5, 'Ezhil',  22000, 'HR',    'Chennai');
GO


/*========================================================
 VIEW DATA
========================================================*/
SELECT * FROM Employees;
GO


/*========================================================
 3) AND OPERATOR
========================================================*/
/*
 AND returns TRUE only if ALL conditions are TRUE
*/

SELECT *
FROM Employees
WHERE Dept = 'IT'
  AND Salary > 25000;
GO

/*
 RESULT:
 - Employees in IT department
 - AND Salary greater than 25000
*/


/*========================================================
 4) OR OPERATOR
========================================================*/
/*
 OR returns TRUE if ANY one condition is TRUE
*/

SELECT *
FROM Employees
WHERE Dept = 'HR'
   OR Dept = 'Admin';
GO

/*
 RESULT:
 - HR employees
 - Admin employees
*/


/*========================================================
 5) NOT OPERATOR
========================================================*/
/*
 NOT reverses the condition
*/

SELECT *
FROM Employees
WHERE NOT Dept = 'IT';
GO

/*
 RESULT:
 - All employees except IT department
*/


/*========================================================
 6) COMBINING AND + OR (WITHOUT PARENTHESES)
========================================================*/

SELECT *
FROM Employees
WHERE Dept = 'IT'
   OR Dept = 'HR'
  AND Salary > 20000;
GO

/*
 IMPORTANT:
 AND has higher precedence than OR

 Equivalent to:
 Dept = 'IT'
 OR (Dept = 'HR' AND Salary > 20000)
*/


/*========================================================
 7) COMBINING AND + OR (WITH PARENTHESES)
========================================================*/

SELECT *
FROM Employees
WHERE (Dept = 'IT' OR Dept = 'HR')
  AND Salary > 20000;
GO

/*
 RESULT:
 - IT and HR employees
 - Only if Salary > 20000
*/


/*========================================================
 8) NOT WITH AND
========================================================*/

SELECT *
FROM Employees
WHERE NOT (Dept = 'HR' AND City = 'Chennai');
GO

/*
 RESULT:
 - Excludes HR employees from Chennai
*/


/*========================================================
 9) REAL-TIME USE CASE EXAMPLES
========================================================*/
/*
 - Employee eligibility rules
 - Access control
 - Report filtering
 - Business conditions
*/

-- Employees eligible for bonus
SELECT *
FROM Employees
WHERE Salary >= 20000
  AND Dept <> 'Admin';
GO


/*========================================================
 10) COMMON INTERVIEW TRICK QUESTIONS
========================================================*/

-- Q1: Which has higher precedence AND or OR?
-- A : AND

-- Q2: How to change precedence?
-- A : Use parentheses ()

-- Q3: What does NOT do?
-- A : Negates a condition


/*========================================================
 11) BEST PRACTICES
========================================================*/

-- Always use parentheses for complex conditions
-- Avoid relying on default precedence
-- Write readable and maintainable WHERE clauses


/*========================================================
 12) LOGICAL OPERATOR SUMMARY
========================================================*/

-- AND  → All conditions must be TRUE
-- OR   → Any one condition must be TRUE
-- NOT  → Reverses the condition

-- Used mainly in WHERE and HAVING clauses


/*******************************************************
 END OF FILE
********************************************************/
