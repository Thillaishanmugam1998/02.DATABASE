/********************************************************************
-- Topic: SQL Server String Functions
-- Purpose: Learn everything about string (text) functions in SQL Server
-- Author: Beginner-Friendly SQL Guide
-- Notes: Step-by-step examples with tables, sample data, and outputs
-- Instructions: Copy this file and run in Microsoft SQL Server (SSMS)
********************************************************************/

-- =================================================================================
-- 1. What are String Functions?
-- =================================================================================
/*
String functions in SQL Server are special operations that allow you
to manipulate, query, and transform text (varchar, nvarchar, char, etc.).
For example, you can extract part of a string, change case, find length,
replace text, or combine strings.

Examples:
- 'Hello World' → get 'World'
- 'hello' → convert to 'HELLO'
- 'SQL' + 'Server' → 'SQL Server'
*/

-- =================================================================================
-- 2. Why String Functions are Needed
-- =================================================================================
/*
Real-life use cases:
1. Formatting names or addresses from user input
2. Extracting domain from email addresses
3. Cleaning data (removing spaces, special characters)
4. Generating reports with proper capitalization
5. Searching for specific patterns in text

Example Scenario:
You have a customer table with names and emails:
- You want to show only the first name
- Standardize all names to uppercase
- Extract the domain from email addresses
*/

-- =================================================================================
-- 3. Common SQL Server String Functions and Syntax
-- =================================================================================
/*
1. LEN(string)                 -> Returns the length of the string
2. LEFT(string, n)             -> Returns the leftmost n characters
3. RIGHT(string, n)            -> Returns the rightmost n characters
4. SUBSTRING(string, start, n) -> Returns n characters starting from 'start'
5. UPPER(string)                -> Converts string to uppercase
6. LOWER(string)                -> Converts string to lowercase
7. LTRIM(string)                -> Removes leading spaces
8. RTRIM(string)                -> Removes trailing spaces
9. REPLACE(string, old, new)   -> Replaces all occurrences of 'old' with 'new'
10. CHARINDEX(substring, string) -> Returns starting position of substring
11. CONCAT(string1, string2, …) -> Concatenates multiple strings
12. FORMAT(value, 'format')     -> Formats values (numbers/dates) as text
*/

-- =================================================================================
-- 4. Step-by-Step Examples with Tables
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- Example 1: Basic String Operations
-- ---------------------------------------------------------------------------------

-- Drop table if exists
DROP TABLE IF EXISTS Employees;

-- Create sample table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100)
);

-- Insert sample data
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email)
VALUES
(1, 'John', 'Doe', 'john.doe@example.com'),
(2, 'Jane', 'Smith', 'jane.smith@example.com'),
(3, 'Alice', 'Johnson', 'alice.j@example.net');

-- Step 1: SQL processes FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
-- Step 2: Apply string functions
-- Step 3: Output

-- Select basic string manipulations
SELECT
    EmployeeID,
    FirstName,
    LastName,
    -- Combine first and last name
    CONCAT(FirstName, ' ', LastName) AS FullName,
    -- Convert to uppercase
    UPPER(FirstName) AS FirstName_Upper,
    -- Convert to lowercase
    LOWER(LastName) AS LastName_Lower,
    -- Length of first name
    LEN(FirstName) AS FirstName_Length,
    -- Extract first 3 letters of last name
    LEFT(LastName, 3) AS LastName_Left3,
    -- Extract last 2 letters of last name
    RIGHT(LastName, 2) AS LastName_Right2,
    -- Find position of '@' in email
    CHARINDEX('@', Email) AS AtSymbolPosition,
    -- Replace 'example.com' with 'company.com'
    REPLACE(Email, 'example.com', 'company.com') AS Email_Updated
FROM Employees;

/*
Output Table:

EmployeeID | FirstName | LastName | FullName      | FirstName_Upper | LastName_Lower | FirstName_Length | LastName_Left3 | LastName_Right2 | AtSymbolPosition | Email_Updated
-----------|-----------|----------|---------------|----------------|----------------|-----------------|----------------|----------------|-----------------|-------------------
1          | John      | Doe      | John Doe      | JOHN           | doe            | 4               | Doe            | oe             | 9               | john.doe@company.com
2          | Jane      | Smith    | Jane Smith    | JANE           | smith          | 4               | Smi            | th             | 10              | jane.smith@company.com
3          | Alice     | Johnson  | Alice Johnson | ALICE          | johnson        | 5               | Joh            | on             | 6               | alice.j@company.net
*/

-- ---------------------------------------------------------------------------------
-- Example 2: Using SUBSTRING and TRIM
-- ---------------------------------------------------------------------------------

-- Extract first name from email (before '@')
SELECT
    EmployeeID,
    Email,
    -- Find '@' position
    CHARINDEX('@', Email) AS AtPos,
    -- Extract everything before '@'
    SUBSTRING(Email, 1, CHARINDEX('@', Email) - 1) AS EmailUser,
    -- Remove any leading/trailing spaces
    LTRIM(RTRIM(SUBSTRING(Email, 1, CHARINDEX('@', Email) - 1))) AS EmailUser_Clean
FROM Employees;

/*
Output Table:

EmployeeID | Email                 | AtPos | EmailUser      | EmailUser_Clean
-----------|----------------------|-------|----------------|----------------
1          | john.doe@example.com  | 9     | john.doe       | john.doe
2          | jane.smith@example.com| 10    | jane.smith     | jane.smith
3          | alice.j@example.net   | 8     | alice.j        | alice.j
*/

-- ---------------------------------------------------------------------------------
-- Example 3: Handling NULLs and Edge Cases
-- ---------------------------------------------------------------------------------

-- Add a record with NULL
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email)
VALUES (4, NULL, 'Brown', NULL);

-- Using ISNULL to handle NULLs
SELECT
    EmployeeID,
    ISNULL(FirstName, 'Unknown') AS FirstName_Clean,
    ISNULL(Email, 'NoEmail@example.com') AS Email_Clean
FROM Employees;

/*
Output Table:

EmployeeID | FirstName_Clean | Email_Clean
-----------|----------------|---------------------
1          | John           | john.doe@example.com
2          | Jane           | jane.smith@example.com
3          | Alice          | alice.j@example.net
4          | Unknown        | NoEmail@example.com
*/

-- =================================================================================
-- 5. Important Tips, Best Practices, and Common Mistakes
-- =================================================================================
/*
1. Always handle NULLs with ISNULL or COALESCE when manipulating strings.
2. CHARINDEX returns 0 if substring is not found; check before using in SUBSTRING.
3. CONCAT automatically handles NULLs, while '+' operator can produce NULL if one operand is NULL.
4. Use LTRIM/RTRIM to remove extra spaces before comparisons.
5. LEN counts characters, not bytes; DATALENGTH counts bytes.
6. String functions can be nested for complex transformations.
*/

-- =================================================================================
-- 6. SQL Server Query Execution Order (Relevant to String Functions)
-- =================================================================================
/*
1. FROM: SQL reads table(s)
2. WHERE: Filters rows
3. GROUP BY: Groups rows if using aggregates
4. HAVING: Filters groups
5. SELECT: Computes expressions (string functions included)
6. ORDER BY: Sorts results
7. TOP/LIMIT: Limits rows returned

Important: String functions are applied **after WHERE and GROUP BY** but **before ORDER BY**.
*/

-- =================================================================================
-- 7. Summary – Key Points for Quick Revision
-- =================================================================================
/*
- String functions are used to manipulate text.
- Common functions: LEN, LEFT, RIGHT, SUBSTRING, UPPER, LOWER, LTRIM, RTRIM, REPLACE, CHARINDEX, CONCAT.
- Always handle NULLs.
- Use step-by-step transformation: find positions → extract → clean → format.
- Remember SQL execution order when using functions with WHERE, GROUP BY, HAVING.
*/

