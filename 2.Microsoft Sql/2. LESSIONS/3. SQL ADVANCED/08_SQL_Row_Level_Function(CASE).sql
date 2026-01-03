/*
========================================================================
SQL SERVER - CASE STATEMENT - ZERO TO HERO NOTES
========================================================================

Author: ChatGPT
Topic: CASE STATEMENT
Purpose: Learn everything about CASE statements in SQL Server, from basics to advanced use.

Contents:
1. What CASE Statement is
2. Why CASE Statement is needed (use cases)
3. Syntax
4. Step-by-step examples with tables
5. Multiple scenarios
6. Important tips and common mistakes
7. Query execution order explanation
8. Summary

========================================================================
*/

/*========================================================================
1. WHAT IS CASE STATEMENT?
========================================================================

- The CASE statement in SQL Server is used to return values based on conditions.
- It is like an IF-ELSE in programming.
- It allows you to create new calculated columns or modify data based on logic.

Example in simple terms:
If student's score >= 50 then 'Pass', else 'Fail'

*/

/*========================================================================
2. WHY CASE STATEMENT IS NEEDED
========================================================================

Real-life use cases:
1. Grading students:
   - Score >= 90 -> 'A'
   - Score >= 80 -> 'B'
   - Else -> 'C'

2. Categorizing sales:
   - Amount >= 1000 -> 'High'
   - Amount >= 500 -> 'Medium'
   - Else -> 'Low'

3. Handling NULLs or missing data:
   - Show 'Unknown' if value is NULL

4. Conditional aggregation:
   - COUNT or SUM only certain types of data based on conditions

*/

/*========================================================================
3. SYNTAX
========================================================================

-- Simple CASE
CASE expression
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ...
    ELSE default_result
END

-- Searched CASE (more flexible)
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ...
    ELSE default_result
END

Notes:
- CASE always ends with END
- ELSE is optional; if omitted and no match, NULL is returned
- Can be used in SELECT, WHERE, ORDER BY, GROUP BY, HAVING

*/

/*========================================================================
4. STEP-BY-STEP EXAMPLES
========================================================================
*/

/*========================================================================
EXAMPLE 1: Single-column CASE (grading system)
========================================================================*/

-- Step 0: Drop table if it exists
DROP TABLE IF EXISTS Students;

-- Step 1: Create table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName NVARCHAR(50),
    Score INT
);

-- Step 2: Insert sample data
INSERT INTO Students (StudentID, StudentName, Score) VALUES
(1, 'Alice', 95),
(2, 'Bob', 82),
(3, 'Charlie', 67),
(4, 'David', 45),
(5, 'Eve', NULL);  -- NULL value to test edge case

/* 
Initial table:

StudentID | StudentName | Score
--------------------------------
1         | Alice       | 95
2         | Bob         | 82
3         | Charlie     | 67
4         | David       | 45
5         | Eve         | NULL
*/

/* Step 3: Query using CASE */

SELECT
    StudentID,
    StudentName,
    Score,
    CASE 
        WHEN Score >= 90 THEN 'A'
        WHEN Score >= 80 THEN 'B'
        WHEN Score >= 70 THEN 'C'
        WHEN Score >= 50 THEN 'D'
        WHEN Score < 50 THEN 'F'
        ELSE 'No Score'  -- Handles NULL
    END AS Grade
FROM Students;

/* How SQL processes this query internally:
1. FROM Students -> reads all rows
2. SELECT -> calculates the CASE for each row
3. CASE checks conditions in order (top to bottom)
4. Outputs a new column "Grade"
*/

/* Output:

StudentID | StudentName | Score | Grade
----------------------------------------
1         | Alice       | 95    | A
2         | Bob         | 82    | B
3         | Charlie     | 67    | D
4         | David       | 45    | F
5         | Eve         | NULL  | No Score
*/

/*========================================================================
EXAMPLE 2: Multi-column CASE (bonus points adjustment)
========================================================================*/

-- Step 0: Drop table if exists
DROP TABLE IF EXISTS Exams;

-- Step 1: Create table
CREATE TABLE Exams (
    ExamID INT PRIMARY KEY,
    StudentName NVARCHAR(50),
    Score INT,
    ExtraCredit INT
);

-- Step 2: Insert data
INSERT INTO Exams (ExamID, StudentName, Score, ExtraCredit) VALUES
(1, 'Alice', 88, 5),
(2, 'Bob', 76, 10),
(3, 'Charlie', 54, 0),
(4, 'David', 43, 2);

/* Initial table:

ExamID | StudentName | Score | ExtraCredit
-------------------------------------------
1      | Alice       | 88    | 5
2      | Bob         | 76    | 10
3      | Charlie     | 54    | 0
4      | David       | 43    | 2
*/

-- Step 3: Query with multi-column CASE
SELECT
    StudentName,
    Score,
    ExtraCredit,
    Score + ExtraCredit AS TotalScore,
    CASE 
        WHEN Score + ExtraCredit >= 90 THEN 'A'
        WHEN Score + ExtraCredit >= 80 THEN 'B'
        WHEN Score + ExtraCredit >= 70 THEN 'C'
        WHEN Score + ExtraCredit >= 50 THEN 'D'
        ELSE 'F'
    END AS FinalGrade
FROM Exams;

/* Output:

StudentName | Score | ExtraCredit | TotalScore | FinalGrade
-----------------------------------------------------------
Alice       | 88    | 5           | 93         | A
Bob         | 76    | 10          | 86         | B
Charlie     | 54    | 0           | 54         | D
David       | 43    | 2           | 45         | F
*/

/*========================================================================
EXAMPLE 3: CASE with aggregate function
========================================================================*/

-- Step 0: Drop table
DROP TABLE IF EXISTS Sales;

-- Step 1: Create table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    Product NVARCHAR(50),
    Quantity INT,
    Price DECIMAL(10,2)
);

-- Step 2: Insert data
INSERT INTO Sales (SaleID, Product, Quantity, Price) VALUES
(1, 'Laptop', 5, 1000.00),
(2, 'Mouse', 50, 20.00),
(3, 'Keyboard', 30, 30.00),
(4, 'Laptop', 2, 1000.00),
(5, 'Mouse', 20, 20.00),
(6, 'Keyboard', 10, 30.00);

/* Step 3: Aggregate CASE query */
SELECT
    Product,
    SUM(Quantity) AS TotalQuantity,
    SUM(
        CASE 
            WHEN Price >= 100 THEN Quantity * Price
            ELSE 0
        END
    ) AS HighValueSales
FROM Sales
GROUP BY Product;

/* Explanation:
- SUM aggregates Quantity per product
- CASE filters only high-value sales (Price >= 100)
- GROUP BY ensures aggregation is per Product
*/

/* Output:

Product   | TotalQuantity | HighValueSales
------------------------------------------
Laptop    | 7             | 7000
Mouse     | 70            | 0
Keyboard  | 40            | 0
*/

/*========================================================================
EXAMPLE 4: CASE in WHERE clause
========================================================================*/

-- Fetch products with high revenue only
SELECT *
FROM Sales
WHERE
    CASE 
        WHEN Price * Quantity >= 500 THEN 1
        ELSE 0
    END = 1;

/* Output:

SaleID | Product | Quantity | Price
------------------------------------
1      | Laptop  | 5        | 1000.00
4      | Laptop  | 2        | 1000.00
*/

/*========================================================================
EXAMPLE 5: Handling NULLs
========================================================================*/

SELECT
    StudentID,
    StudentName,
    Score,
    CASE 
        WHEN Score IS NULL THEN 'Score Missing'
        WHEN Score >= 50 THEN 'Pass'
        ELSE 'Fail'
    END AS Result
FROM Students;

/* Output:

StudentID | StudentName | Score | Result
-----------------------------------------
1         | Alice       | 95    | Pass
2         | Bob         | 82    | Pass
3         | Charlie     | 67    | Pass
4         | David       | 45    | Fail
5         | Eve         | NULL  | Score Missing
*/

/*========================================================================
5. IMPORTANT TIPS & COMMON MISTAKES
========================================================================

1. Always end CASE with END.
2. ELSE is optional, but NULL is returned if omitted.
3. Order of WHEN clauses matters (top to bottom).
4. CASE can be used in SELECT, WHERE, ORDER BY, GROUP BY, HAVING.
5. Aggregates inside CASE must be wrapped properly (SUM, COUNT).
6. Avoid comparing columns with NULL directly using =; use IS NULL.
7. Column aliases can’t be used inside the same SELECT in WHERE; use subquery if needed.
8. Use meaningful names for computed columns.

*/

/*========================================================================
6. SQL SERVER QUERY EXECUTION ORDER
========================================================================

1. FROM -> gather tables and JOINs
2. WHERE -> filter rows
3. GROUP BY -> aggregate rows
4. HAVING -> filter aggregated rows
5. SELECT -> calculate columns, including CASE
6. DISTINCT -> remove duplicates
7. ORDER BY -> sort results
8. TOP/LIMIT -> return subset

*/

/*========================================================================
7. SUMMARY
========================================================================

- CASE is SQL Server's way to implement conditional logic.
- Can be simple (value-based) or searched (condition-based).
- Works with SELECT, WHERE, ORDER BY, GROUP BY, HAVING.
- Useful for grading, categorization, conditional aggregation, NULL handling.
- Always include END, and optionally ELSE.
- Check execution order: CASE is evaluated during SELECT phase.
- Test with edge cases: NULLs, duplicates, zero values.

*/

/*========================================================================
End of CASE STATEMENT NOTES - Ready to run in SSMS
========================================================================*/
