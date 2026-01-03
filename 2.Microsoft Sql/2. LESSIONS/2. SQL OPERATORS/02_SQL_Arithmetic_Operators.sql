/***********************************************************************
SQL NOTES: ARITHMETIC OPERATORS IN SQL SERVER
Author: ChatGPT
Level: Beginner to Advanced
DB: SQL Server
Purpose:
  - Understand arithmetic operators
  - Learn usage with variables and table columns
  - Practice real-time and interview-oriented examples
************************************************************************/

-- ===============================================================
-- 1) WHAT ARE ARITHMETIC OPERATORS?
-- ===============================================================
/*
Arithmetic operators in SQL are used to perform
mathematical calculations on numeric values.

SQL Server supports the following arithmetic operators:

+   Addition
-   Subtraction
*   Multiplication
/   Division
%   Modulo (Remainder)

Key Notes:
- Operate on numeric data types (INT, DECIMAL, FLOAT, etc.)
- Can be used with variables or columns in tables.
*/

-- ===============================================================
-- 2) ADDITION OPERATOR (+)
-- ===============================================================
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

-- ===============================================================
-- 3) SUBTRACTION OPERATOR (-)
-- ===============================================================
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

-- ===============================================================
-- 4) MULTIPLICATION OPERATOR (*)
-- ===============================================================
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

-- ===============================================================
-- 5) DIVISION OPERATOR (/)
-- ===============================================================
/*
 IMPORTANT:
 - Integer / Integer = Integer (decimal part truncated)
 - Decimal / Decimal = Decimal (precision preserved)
*/

-- Integer division
DECLARE @A INT = 20, @B INT = 3;
SELECT @A / @B AS IntegerDivision;
GO
/*
 OUTPUT:
 ----------------
 IntegerDivision
 ----------------
 6
*/

-- Decimal division
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

-- ===============================================================
-- 6) MODULO OPERATOR (%)
-- ===============================================================
/*
Returns the remainder after division.
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

-- ===============================================================
-- 7) ARITHMETIC OPERATORS WITH TABLE DATA
-- ===============================================================
DROP TABLE IF EXISTS ProductSales;
GO

CREATE TABLE ProductSales
(
    ProductName NVARCHAR(50),
    Quantity    INT,
    Price       INT
);
GO

INSERT INTO ProductSales VALUES 
('Mouse', 2, 500),
('Keyboard', 1, 800),
('Monitor', 3, 700);
GO

-- Calculate total price for each product (Quantity * Price)
SELECT 
    ProductName,
    Quantity,
    Price,
    Quantity * Price AS TotalPrice
FROM ProductSales;
GO

/*
 Real-life use case:
 - Billing and invoicing
 - Shopping cart total calculation
 - Financial reports
*/

-- ===============================================================
-- 8) ARITHMETIC OPERATOR PRECEDENCE
-- ===============================================================
/*
Operator precedence determines the order of calculations:

1) *  /  %   (Highest)
2) +  -       (Lowest)
*/

-- Without brackets
SELECT 10 + 5 * 2 AS ResultWithoutBrackets;
GO
-- Output: 20

-- With brackets
SELECT (10 + 5) * 2 AS ResultWithBrackets;
GO
-- Output: 30

-- ===============================================================
-- 9) USING CAST TO PRESERVE DECIMAL PRECISION
-- ===============================================================
-- Integer division truncates decimals by default
SELECT CAST(10 AS DECIMAL(5,2)) / 3 AS DecimalResult;
GO
/*
 OUTPUT:
 -------------
 DecimalResult
 -------------
 3.33
*/

-- ===============================================================
-- 10) REAL-TIME TABLE EXAMPLES
-- ===============================================================
-- Adding tax column
ALTER TABLE ProductSales ADD Tax DECIMAL(10,2) DEFAULT 0;
GO

UPDATE ProductSales
SET Tax = Price * 0.18;  -- 18% tax
GO

SELECT ProductName, Price, Tax, Price + Tax AS PriceWithTax
FROM ProductSales;
GO

-- ===============================================================
-- 11) COMMON INTERVIEW QUESTIONS
-- ===============================================================
/*
Q1: What is the difference between / and %?
A1: / returns quotient, % returns remainder.

Q2: How do you preserve decimal places in division?
A2: Use DECIMAL, FLOAT, or CAST.

Q3: What is the operator precedence in SQL?
A3: * / % first, then + -
*/

-- ===============================================================
-- 12) IMPORTANT TIPS AND NOTES
-- ===============================================================
/*
1) Arithmetic operators can be used with variables or table columns.
2) Integer division truncates decimals. Use DECIMAL to keep precision.
3) Always consider operator precedence when combining multiple operators.
4) Modulo (%) is very useful for identifying even/odd numbers or cycles.
5) Use brackets () to control order of operations explicitly.
6) Widely used in finance, billing, reporting, and analytics queries.
*/

-- ===============================================================
-- 13) SUMMARY
-- ===============================================================
/*
- + : Addition
- - : Subtraction
- * : Multiplication
- / : Division
- % : Modulo (remainder)
- Integer division truncates decimal; use DECIMAL for precision.
- Operator precedence: * / % > + -
- Brackets can override precedence
- Essential for calculations on variables and table columns
*/

-- ===============================================================
-- END OF FILE: ARITHMETIC OPERATORS
-- ===============================================================
