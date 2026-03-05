/*=============================================================================
    FILE: 04_SQL_Data_Types.sql
    TOPIC: SQL SERVER DATA TYPES - COMPLETE LEARNER GUIDE
    DB   : RetailLearningDB

    LEARNING GOAL:
    - Understand each data type family clearly
    - Understand bytes, range, precision, and scale
    - Understand DATE vs DATETIME2
    - Use one practical table with real values
=============================================================================*/

IF DB_ID('RetailLearningDB') IS NULL
BEGIN
    CREATE DATABASE RetailLearningDB;
END
GO

USE RetailLearningDB;
GO

/*=============================================================================
    1) WHAT IS A DATA TYPE?
=============================================================================*/
/*
Data type defines what kind of value a column can store.

Why this matters:
- Prevents invalid data
- Controls storage size
- Improves performance
- Improves accuracy (especially money/decimal/date)
*/

/*=============================================================================
    2) INTEGER TYPES (WHOLE NUMBERS) - BYTES + RANGE
=============================================================================*/
/*
1) TINYINT
   - Storage: 1 byte
   - Range: 0 to 255
   - Use case: rating, small status code

2) SMALLINT
   - Storage: 2 bytes
   - Range: -32,768 to 32,767
   - Use case: small counters, small department code

3) INT
   - Storage: 4 bytes
   - Range: -2,147,483,648 to 2,147,483,647
   - Use case: most common IDs and counters

4) BIGINT
   - Storage: 8 bytes
   - Very large range
   - Use case: huge tables, very large transaction IDs
*/

/* Quick integer demo */
SELECT
    CAST(200 AS TINYINT) AS TinyIntValue,
    CAST(25000 AS SMALLINT) AS SmallIntValue,
    CAST(150000 AS INT) AS IntValue,
    CAST(9000000000 AS BIGINT) AS BigIntValue;
GO

/*=============================================================================
    3) DECIMAL / NUMERIC - PRECISION (p) AND SCALE (s)
=============================================================================*/
/*
DECIMAL(p,s) or NUMERIC(p,s)
- p (precision) = total number of digits
- s (scale)     = digits after decimal point

Example:
DECIMAL(10,2)
- Total 10 digits allowed
- 2 digits after decimal
- 8 digits before decimal
- Max positive value: 99999999.99

Another example:
DECIMAL(6,3)
- Total 6 digits
- 3 after decimal
- 3 before decimal
- Example valid value: 728.456
*/

/* Decimal demo table */
DROP TABLE IF EXISTS DecimalDemo;
GO

CREATE TABLE DecimalDemo
(
    AmountA DECIMAL(10,2),
    AmountB DECIMAL(6,3)
);
GO

INSERT INTO DecimalDemo (AmountA, AmountB)
VALUES (12345678.90, 728.456);

SELECT * FROM DecimalDemo;
GO

/*=============================================================================
    4) DATE AND TIME TYPES - FORMAT + DIFFERENCE
=============================================================================*/
/*
A) DATE
- Stores only date
- Format: YYYY-MM-DD
- Example: '2026-03-05'

B) TIME
- Stores only time
- Format: HH:MM:SS[.fraction]

C) DATETIME (older type)
- Stores date + time
- Lower precision than DATETIME2

D) DATETIME2 (recommended modern type)
- Stores date + time
- Higher precision and wider range
- Best practice for new projects

Simple memory:
DATE      -> only calendar date
DATETIME2 -> date + exact time
*/

/* Date/time demo */
SELECT
    CAST('2026-03-05' AS DATE) AS DateOnly,
    CAST('09:30:45' AS TIME(0)) AS TimeOnly,
    CAST('2026-03-05 09:30:45.1234567' AS DATETIME2(7)) AS DateTime2Value;
GO

/*=============================================================================
    5) CHARACTER TYPES - CHAR/VARCHAR vs NCHAR/NVARCHAR
=============================================================================*/
/*
CHAR(n): fixed-length non-unicode
VARCHAR(n): variable-length non-unicode

NCHAR(n): fixed-length unicode
NVARCHAR(n): variable-length unicode

Use NVARCHAR when multilingual data is possible.
Use N prefix for unicode string literals.
Example: N'தமிழ்'
*/

/*=============================================================================
    6) OTHER USEFUL TYPES
=============================================================================*/
/*
BIT: boolean-like (0/1)
MONEY: currency type
VARBINARY(MAX): binary data like file/image bytes
UNIQUEIDENTIFIER: globally unique ID (NEWID())
*/

/*=============================================================================
    7) PRACTICAL TABLE USING MULTIPLE DATA TYPES
=============================================================================*/
DROP TABLE IF EXISTS EmployeeDataTypeDemo;
GO

CREATE TABLE EmployeeDataTypeDemo
(
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,      -- INT + IDENTITY
    EmployeeCode CHAR(8) NOT NULL,                 -- fixed length
    FullName NVARCHAR(100) NOT NULL,               -- unicode
    LoginName VARCHAR(50) NOT NULL,                -- non-unicode

    Age SMALLINT NOT NULL,                         -- integer bytes/range demo
    ExperienceYears DECIMAL(4,1) NULL,             -- p=4, s=1
    Salary DECIMAL(12,2) NOT NULL,                 -- p=12, s=2
    Bonus MONEY NULL,

    DateOfJoining DATE NOT NULL,                   -- date only
    LastLogin DATETIME2(3) NULL,                   -- date + time

    IsActive BIT NOT NULL DEFAULT 1,
    ProfilePhoto VARBINARY(MAX) NULL,
    EmployeeGuid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID()
);
GO

/*=============================================================================
    8) SAMPLE DATA INSERTS
=============================================================================*/
INSERT INTO EmployeeDataTypeDemo
(
    EmployeeCode, FullName, LoginName, Age, ExperienceYears, Salary, Bonus,
    DateOfJoining, LastLogin, IsActive
)
VALUES
('EMP00001', N'Arun Kumar', 'arun.k', 26, 2.5, 55000.00, 5000.00,
 '2024-01-10', '2026-03-05 09:15:30.125', 1),
('EMP00002', N'தில்லை சண்முகம்', 'thillai.s', 30, 6.0, 90000.00, NULL,
 '2021-06-15', SYSDATETIME(), 1);
GO

SELECT
    EmployeeID,
    EmployeeCode,
    FullName,
    Age,
    ExperienceYears,
    Salary,
    DateOfJoining,
    LastLogin,
    IsActive,
    EmployeeGuid
FROM EmployeeDataTypeDemo;
GO

/*=============================================================================
    9) SEE STORAGE FOR FIXED VS VARIABLE EXAMPLE
=============================================================================*/
/*
DATALENGTH shows how many bytes are used by value.
*/
SELECT
    EmployeeCode,
    DATALENGTH(EmployeeCode) AS EmployeeCodeBytes,
    FullName,
    DATALENGTH(FullName) AS FullNameBytes
FROM EmployeeDataTypeDemo;
GO

/*=============================================================================
    10) FINAL RECAP FOR NO-DOUBT LEARNING
=============================================================================*/
/*
1) SMALLINT means:
   - 2 bytes, range -32768 to 32767.

2) DECIMAL(p,s) means:
   - p = total digits, s = digits after decimal.
   - Example DECIMAL(12,2): 10 digits before decimal + 2 after decimal.

3) DATE means:
   - only date part (YYYY-MM-DD).

4) DATETIME2 means:
   - date + time with better precision than DATETIME.

5) Pick type based on business meaning, not just "it works".
*/
