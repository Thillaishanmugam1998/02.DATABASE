/*========================================================
 FILE NAME : Assignment_Operator.sql
 TOPIC     : Assignment Operator & Compound Assignment Operators
 DB        : SQL Server
 PURPOSE   :
   - Understand assignment operator (=)
   - Learn variable assignment
   - Learn column alias assignment
   - Understand compound assignment operators
   - Practice interview-oriented examples
========================================================*/


/*========================================================
 1) ASSIGNMENT OPERATOR (=)
========================================================*/
/*
 The assignment operator (=) is used to assign a value
 to a variable in SQL Server.

 NOTE:
 - SQL Server supports only ONE assignment operator (=)
*/


/*========================================================
 EXAMPLE 1: SIMPLE VARIABLE ASSIGNMENT
========================================================*/

DECLARE @MyCounter INT;
SET @MyCounter = 1;

SELECT @MyCounter AS CounterValue;
GO

/*
 OUTPUT:
 ----------
 CounterValue
 ----------
 1
*/


/*========================================================
 2) ASSIGNMENT OPERATOR WITH COLUMN ALIAS
========================================================*/
/*
 The assignment operator can also be used to assign
 expressions to column headings (aliases).
*/


/*-- Sample Employee Table for Demo --*/
DROP TABLE IF EXISTS Employee;
GO

CREATE TABLE Employee
(
    ID   INT,
    Name NVARCHAR(50)
);
GO

INSERT INTO Employee VALUES (1, 'Arun');
INSERT INTO Employee VALUES (2, 'Bala');
INSERT INTO Employee VALUES (3, 'Charan');
GO


/*========================================================
 EXAMPLE 2: COLUMN HEADING ASSIGNMENT
========================================================*/

SELECT 
    FirstColumn  = 'abcd',
    SecondColumn = ID,
    ThirdColumn = 'Thillai'
FROM Employee;
GO

/*
 OUTPUT:
 --------------------------
 FirstColumn | SecondColumn
 --------------------------
 abcd        | 1
 abcd        | 2
 abcd        | 3
*/


/*========================================================
 3) COMPOUND ASSIGNMENT OPERATORS
========================================================*/
/*
 Introduced in SQL Server 2008

 Compound Assignment Operators:
 - Perform operation and assignment in ONE statement
 - Shorter and cleaner syntax
 - Improves readability
*/


/*========================================================
 EXAMPLE 3: WITHOUT COMPOUND ASSIGNMENT
========================================================*/

DECLARE @MyVariable INT;
SET @MyVariable = 10;
SET @MyVariable = @MyVariable * 5;

SELECT @MyVariable AS MyResult;
GO

/*
 OUTPUT:
 --------
 MyResult
 --------
 50
*/


/*========================================================
 EXAMPLE 4: USING COMPOUND ASSIGNMENT
========================================================*/

DECLARE @MyVariable INT;
SET @MyVariable = 10;
SET @MyVariable *= 5;

SELECT @MyVariable AS MyResult;
GO

/*
 OUTPUT:
 --------
 MyResult
 --------
 50
*/


/*========================================================
 4) LIST OF COMPOUND ASSIGNMENT OPERATORS
========================================================*/

/*
 +=   Add and assign
 -=   Subtract and assign
 *=   Multiply and assign
 /=   Divide and assign
 %=   Modulo and assign
*/


/*========================================================
 EXAMPLE 5: += OPERATOR
========================================================*/

DECLARE @Value INT = 10;
SET @Value += 5;

SELECT @Value AS Result;
GO
-- Output: 15


/*========================================================
 EXAMPLE 6: -= OPERATOR
========================================================*/

DECLARE @Value INT = 20;
SET @Value -= 8;

SELECT @Value AS Result;
GO
-- Output: 12


/*========================================================
 EXAMPLE 7: *= OPERATOR
========================================================*/

DECLARE @Value INT = 6;
SET @Value *= 4;

SELECT @Value AS Result;
GO
-- Output: 24


/*========================================================
 EXAMPLE 8: /= OPERATOR
========================================================*/

DECLARE @Value INT = 20;
SET @Value /= 4;

SELECT @Value AS Result;
GO
-- Output: 5


/*========================================================
 EXAMPLE 9: %= OPERATOR (MODULO)
========================================================*/

DECLARE @Value INT = 23;
SET @Value %= 5;

SELECT @Value AS Result;
GO
-- Output: 3


/*========================================================
 INTERVIEW KEY POINTS
========================================================*/

-- 1) SQL Server supports only (=) as assignment operator
-- 2) Assignment operator works with variables and column aliases
-- 3) Compound assignment operators introduced in SQL Server 2008
-- 4) Compound operators reduce code length and improve clarity
-- 5) Used only with variables (not table columns directly)


/*========================================================
 END OF FILE
========================================================*/
