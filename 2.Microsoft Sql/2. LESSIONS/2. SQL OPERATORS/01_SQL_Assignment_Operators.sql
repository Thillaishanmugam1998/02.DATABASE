/***********************************************************************
SQL NOTES: ASSIGNMENT OPERATOR & COMPOUND ASSIGNMENT OPERATORS
Author: ChatGPT
Level: Beginner to Advanced
DB: SQL Server
Purpose:
  - Understand assignment operator (=)
  - Learn variable assignment
  - Learn column alias assignment
  - Understand compound assignment operators
  - Practice interview-oriented examples
************************************************************************/

-- ===============================================================
-- 1) WHAT IS THE ASSIGNMENT OPERATOR?
-- ===============================================================
/*
The Assignment Operator (=) in SQL Server is used to assign a value
to a variable or a column alias.  

Key points:
- Assigns a value to a variable.
- Can assign expressions or constants to column aliases.
- SQL Server supports only one assignment operator: =

Compound Assignment Operators (+=, -=, *=, /=, %=):
- Perform a calculation and assignment in one step.
- Introduced in SQL Server 2008.
*/

-- ===============================================================
-- 2) WHY ASSIGNMENT OPERATORS ARE NEEDED?
-- ===============================================================
/*
Real-life use cases:

1) Variable assignment:
   - Track counters in loops
   - Store intermediate calculations

2) Column alias assignment:
   - Assign meaningful names to columns in SELECT queries
   - Improve readability of reports

3) Compound assignment:
   - Increment/decrement variables in a concise way
   - Simplify repetitive calculations
*/

-- ===============================================================
-- 3) SYNTAX
-- ===============================================================
/*
1) Simple variable assignment:
   DECLARE @VariableName DataType;
   SET @VariableName = value;

2) Column alias assignment:
   SELECT ColumnOrExpression AS AliasName
   FROM TableName;

3) Compound assignment:
   SET @Variable Operator= value;

Operators:
   +=  Add and assign
   -=  Subtract and assign
   *=  Multiply and assign
   /=  Divide and assign
   %=  Modulo and assign
*/

-- ===============================================================
-- 4) STEP-BY-STEP EXAMPLES
-- ===============================================================

/*--------------------------------------------------------------
EXAMPLE 1: SIMPLE VARIABLE ASSIGNMENT
---------------------------------------------------------------*/
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

-- ===============================================================
-- EXAMPLE 2: COLUMN ALIAS ASSIGNMENT
-- ===============================================================
-- Sample Employee Table
DROP TABLE IF EXISTS Employee;
GO

CREATE TABLE Employee
(
    ID   INT,
    Name NVARCHAR(50)
);
GO

INSERT INTO Employee VALUES (1, 'Arun'), (2, 'Bala'), (3, 'Charan');
GO

-- Assigning expressions to column headings
SELECT 
    FirstColumn  = 'abcd',
    SecondColumn = ID,
    ThirdColumn  = 'Thillai'
FROM Employee;
GO

/*
 OUTPUT:
 --------------------------
 FirstColumn | SecondColumn | ThirdColumn
 --------------------------
 abcd        | 1            | Thillai
 abcd        | 2            | Thillai
 abcd        | 3            | Thillai
*/

-- ===============================================================
-- EXAMPLE 3: VARIABLE ASSIGNMENT WITHOUT COMPOUND OPERATOR
-- ===============================================================
DECLARE @MyVariable INT;
SET @MyVariable = 10;
SET @MyVariable = @MyVariable * 5;

SELECT @MyVariable AS MyResult;
GO
-- Output: 50

-- ===============================================================
-- EXAMPLE 4: VARIABLE ASSIGNMENT WITH COMPOUND OPERATOR
-- ===============================================================
DECLARE @MyVariable INT;
SET @MyVariable = 10;
SET @MyVariable *= 5;

SELECT @MyVariable AS MyResult;
GO
-- Output: 50

-- ===============================================================
-- 5) MULTIPLE EXAMPLES OF COMPOUND ASSIGNMENT OPERATORS
-- ===============================================================

-- += OPERATOR (Add and assign)
DECLARE @Value INT = 10;
SET @Value += 5;
SELECT @Value AS Result;
GO
-- Output: 15

-- -= OPERATOR (Subtract and assign)
DECLARE @Value INT = 20;
SET @Value -= 8;
SELECT @Value AS Result;
GO
-- Output: 12

-- *= OPERATOR (Multiply and assign)
DECLARE @Value INT = 6;
SET @Value *= 4;
SELECT @Value AS Result;
GO
-- Output: 24

-- /= OPERATOR (Divide and assign)
DECLARE @Value INT = 20;
SET @Value /= 4;
SELECT @Value AS Result;
GO
-- Output: 5

-- %= OPERATOR (Modulo and assign)
DECLARE @Value INT = 23;
SET @Value %= 5;
SELECT @Value AS Result;
GO
-- Output: 3

-- ===============================================================
-- 6) IMPORTANT TIPS AND NOTES
-- ===============================================================
/*
1) SQL Server supports only = as the standard assignment operator.
2) Assignment operator (=) works for:
   - Variables
   - Column aliases in SELECT queries
3) Compound assignment operators reduce code length and improve readability.
4) Compound operators can only be used with variables, not directly with table columns.
5) Always declare a variable with DECLARE before using SET.
6) Best practice: Use meaningful variable names for clarity.
7) For calculations, compound operators are cleaner than writing full expressions.
*/

-- ===============================================================
-- 7) SUMMARY
-- ===============================================================
/*
- =  : Assign value to variable or column alias.
- SET : Used to assign value to variables.
- Compound operators (+=, -=, *=, /=, %=) perform operation + assignment in one step.
- Assignment operators improve readability and reduce repetitive code.
- Always declare variables with DECLARE before assignment.
- Column aliases make SELECT outputs more readable.
*/

-- ===============================================================
-- END OF SQL NOTES: ASSIGNMENT OPERATOR & COMPOUND OPERATORS
-- ===============================================================
