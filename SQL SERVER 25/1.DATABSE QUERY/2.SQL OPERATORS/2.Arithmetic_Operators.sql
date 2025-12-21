/*========================================================
 FILE NAME : Arithmetic_Operators.sql
 TOPIC     : Arithmetic Operators in SQL Server
 DB        : SQL Server
 PURPOSE   :
   - Understand arithmetic operators
   - Learn usage with variables and columns
   - Practice real-time and interview examples
========================================================*/


/*========================================================
 1) WHAT ARE ARITHMETIC OPERATORS?
========================================================*/
/*
 Arithmetic operators are used to perform
 mathematical calculations on numeric values.

 SQL Server supports the following arithmetic operators:
 +   Addition
 -   Subtraction
 *   Multiplication
 /   Division
 %   Modulo (Remainder)
*/


/*========================================================
 2) ADDITION OPERATOR (+)
========================================================*/

DECLARE @A INT = 10, @B INT = 5;
SELECT @A + @B AS AdditionResult;
GO

/*
 OUTPUT:
 ---------------
 AdditionResult
 ---------------
 15
*/


/*========================================================
 3) SUBTRACTION OPERATOR (-)
========================================================*/

DECLARE @A INT = 20, @B INT = 8;
SELECT @A - @B AS SubtractionResult;
GO

/*
 OUTPUT:
 -------------------
 SubtractionResult
 -------------------
 12
*/


/*========================================================
 4) MULTIPLICATION OPERATOR (*)
========================================================*/

DECLARE @A INT = 6, @B INT = 7;
SELECT @A * @B AS MultiplicationResult;
GO

/*
 OUTPUT:
 ------------------------
 MultiplicationResult
 ------------------------
 42
*/


/*========================================================
 5) DIVISION OPERATOR (/)
========================================================*/
/*
 IMPORTANT:
 - Integer / Integer = Integer
 - Decimal / Decimal = Decimal
*/

DECLARE @A INT = 20, @B INT = 3;
SELECT @A / @B AS IntegerDivision;
GO

/*
 OUTPUT:
 ----------------
 IntegerDivision
 ----------------
 6   (Decimal part is truncated)
*/


/*========================================================
 DIVISION WITH DECIMAL
========================================================*/

DECLARE @A DECIMAL(10,2) = 20, @B DECIMAL(10,2) = 3;
SELECT @A / @B AS DecimalDivision;
GO

/*
 OUTPUT:
 -----------------
 DecimalDivision
 -----------------
 6.66
*/


/*========================================================
 6) MODULO OPERATOR (%)
========================================================*/
/*
 Returns remainder after division
*/

DECLARE @A INT = 23, @B INT = 5;
SELECT @A % @B AS ModuloResult;
GO

/*
 OUTPUT:
 -------------
 ModuloResult
 -------------
 3
*/


/*========================================================
 7) ARITHMETIC OPERATORS WITH TABLE DATA
========================================================*/

DROP TABLE IF EXISTS ProductSales;
GO

CREATE TABLE ProductSales
(
    ProductName NVARCHAR(50),
    Quantity    INT,
    Price       INT
);
GO

INSERT INTO ProductSales VALUES ('Mouse',    2, 500);
INSERT INTO ProductSales VALUES ('Keyboard', 1, 800);
INSERT INTO ProductSales VALUES ('Monitor',  3, 700);
GO


/*========================================================
 CALCULATE TOTAL PRICE (Quantity * Price)
========================================================*/

SELECT 
    ProductName,
    Quantity,
    Price,
    Quantity * Price AS TotalPrice
FROM ProductSales;
GO

/*
 REAL-TIME USE CASE:
 - Billing
 - Invoice calculation
 - Shopping cart
*/


/*========================================================
 8) ARITHMETIC OPERATOR PRECEDENCE
========================================================*/
/*
 Operator precedence:
 1) *  /  %
 2) +  -
*/

SELECT 10 + 5 * 2 AS ResultWithoutBrackets;
GO
-- Output: 20

SELECT (10 + 5) * 2 AS ResultWithBrackets;
GO
-- Output: 30


/*========================================================
 9) COMMON INTERVIEW QUESTIONS
========================================================*/

-- Q1: What is the result of 10 / 3?
-- A : 3 (Integer division)

-- Q2: How to get decimal result?
-- A : Use DECIMAL or CAST

SELECT CAST(10 AS DECIMAL(5,2)) / 3 AS DecimalResult;
GO

-- Q3: What does % operator do?
-- A : Returns remainder


/*========================================================
 KEY POINTS SUMMARY
========================================================*/

-- +  Addition
-- -  Subtraction
-- *  Multiplication
-- /  Division
-- %  Modulo

-- Integer division truncates decimal values
-- Use DECIMAL to preserve precision
-- Widely used in financial and calculation queries


/*========================================================
 END OF FILE
========================================================*/
