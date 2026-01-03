/*======================================================================
    SQL DATA TYPES – CLEAN NOTES (WITH UNICODE EXPLANATION)
======================================================================*/

/*
    1) What are SQL data types?
       SQL data types define what kind of data a column can store:
       - Numbers
       - Text
       - Dates / Time
       - Binary / Images / Files
       - Special types (GUID, XML, Geography)

    2) Unicode vs Non-Unicode
       -------------------------------------------------
       - Non-Unicode types (CHAR, VARCHAR, TEXT)
         • Single-byte per character
         • Supports only English or limited charset
         • Smaller storage size
         
       - Unicode types (NCHAR, NVARCHAR, NTEXT)
         • Two bytes per character
         • Supports multiple languages (Tamil, Hindi, Chinese, Arabic, etc.)
         • Prefix string literal with N
           Example: N'தமிழ்', N'हिंदी', N'مرحبا'
*/

/*======================================================================
    1) INTEGER DATA TYPES
======================================================================*/
-- Whole numbers only (no decimals)
-- Typical use: Employee IDs, Product Codes

-- TINYINT   : 1 byte   (0 to 255)
-- SMALLINT  : 2 bytes  (-32,768 to 32,767)
-- INT       : 4 bytes  (-2,147,483,648 to 2,147,483,647)
-- BIGINT    : 8 bytes  (very large integers)


/*======================================================================
    2) DECIMAL / NUMERIC DATA TYPES
======================================================================*/
-- Store numbers with decimal points
-- DECIMAL(p,s) or NUMERIC(p,s)
-- p = precision = total digits, s = scale = digits after decimal
-- Example: 728.456 → Precision=6, Scale=3


/*======================================================================
    3) MONEY DATA TYPES
======================================================================*/
-- Store currency values
-- SMALLMONEY : small range
-- MONEY      : larger range
-- Example: Salary, Price, InvoiceAmount


/*======================================================================
    4) DATE / TIME DATA TYPES
======================================================================*/
-- DATE      : yyyy-mm-dd
-- TIME      : hh:mm:ss[.fractional seconds]
-- DATETIME  : date + time (older type)
-- DATETIME2 : newer, more precise date+time
-- Example: Employee joining date, shift start time


/*======================================================================
    5) CHARACTER DATA TYPES
======================================================================*/
-- 5.1 Non-Unicode (English / limited charset)
-- CHAR(size)     : Fixed-length
-- VARCHAR(size)  : Variable-length
-- VARCHAR(MAX)   : Large text
-- TEXT           : Old / deprecated

-- 5.2 Unicode (supports multiple languages)
-- NCHAR(size)    : Fixed-length Unicode
-- NVARCHAR(size) : Variable-length Unicode
-- NVARCHAR(MAX)  : Large Unicode text
-- NTEXT          : Old / deprecated

/*======================================================================
    6) BINARY DATA TYPES
======================================================================*/
-- Store raw binary data: images, documents
-- BINARY(size)      : Fixed-length binary
-- VARBINARY(size)   : Variable-length
-- VARBINARY(MAX)    : Large binary files


/*======================================================================
    7) BOOLEAN DATA TYPE
======================================================================*/
-- BIT : 0=False, 1=True, NULL=Unknown


/*======================================================================
    8) SPECIAL DATA TYPES
======================================================================*/
-- UNIQUEIDENTIFIER : GUID
-- XML             : XML documents
-- GEOGRAPHY       : Spatial data (lat/lon)
-- HIERARCHYID     : Hierarchical / tree structures


/**********************************************************************
    REAL-TIME EXAMPLE TABLE USING ALL DATA TYPES
**********************************************************************/

-- Drop table if exists
IF OBJECT_ID('dbo.EmployeeProfile','U') IS NOT NULL
    DROP TABLE dbo.EmployeeProfile;
GO

CREATE TABLE dbo.EmployeeProfile
(
    -- INTEGER
    EmployeeId          INT IDENTITY(1,1) NOT NULL,  -- Primary Key
    DeptCode            SMALLINT NULL,               -- Department code

    -- DECIMAL / NUMERIC
    BasicSalary         DECIMAL(18,2) NOT NULL,      -- e.g. 50000.75

    -- MONEY
    Allowance           MONEY NULL,                  -- e.g. 2000.00

    -- DATE / TIME
    DateOfJoining       DATE NOT NULL,
    ShiftStartTime      TIME(0) NULL,
    LastLoginDateTime   DATETIME NULL,

    -- CHARACTER (Non-Unicode)
    LoginUserName       VARCHAR(50) NOT NULL,
    DepartmentShortName CHAR(5) NULL,
    Remarks             VARCHAR(MAX) NULL,

    -- CHARACTER (Unicode)
    EmployeeFullName    NVARCHAR(100) NOT NULL,
    AddressLine         NVARCHAR(250) NULL,
    AboutEmployee       NVARCHAR(MAX) NULL,

    -- BINARY
    ProfilePhoto        VARBINARY(MAX) NULL,
    SignatureBinary     VARBINARY(512) NULL,

    -- BOOLEAN
    IsActive            BIT NOT NULL CONSTRAINT DF_EmployeeProfile_IsActive DEFAULT(1),

    -- SPECIAL
    RowGuid             UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_EmployeeProfile_RowGuid DEFAULT NEWID(),

    CONSTRAINT PK_EmployeeProfile PRIMARY KEY(EmployeeId)
);
GO


/**********************************************************************
    INSERT EXAMPLES – NON-UNICODE vs UNICODE
**********************************************************************/

-- Non-Unicode example
INSERT INTO dbo.EmployeeProfile
(
    DeptCode,
    BasicSalary,
    Allowance,
    DateOfJoining,
    ShiftStartTime,
    LastLoginDateTime,
    LoginUserName,
    DepartmentShortName,
    Remarks,
    EmployeeFullName,
    AddressLine,
    AboutEmployee,
    ProfilePhoto,
    SignatureBinary,
    IsActive
)
VALUES
(
    10,
    50000.75,
    2500.00,
    '2024-01-10',
    '09:00:00',
    GETDATE(),
    'john.doe',                     -- Non-Unicode
    'HR',
    'Regular full-time employee',   -- Non-Unicode
    N'John Doe',                    -- Unicode ok
    N'123, Main Street, Chennai',
    N'Good communication skills, works in HR.',
    NULL,
    NULL,
    1
);
GO

-- Unicode example (Tamil / Hindi)
INSERT INTO dbo.EmployeeProfile
(
    DeptCode,
    BasicSalary,
    Allowance,
    DateOfJoining,
    ShiftStartTime,
    LastLoginDateTime,
    LoginUserName,
    DepartmentShortName,
    Remarks,
    EmployeeFullName,
    AddressLine,
    AboutEmployee,
    ProfilePhoto,
    SignatureBinary,
    IsActive
)
VALUES
(
    20,
    65000.00,
    3000.00,
    '2024-02-15',
    '10:00:00',
    GETDATE(),
    't.shanmugam',
    'IT',
    'Handles core application development',
    N'தில்லை சண்முகம்',
    N'சென்னை, இந்தியா',
    N'எல்லா பயன்பாட்டின் முக்கிய டெவலப்பர்.',
    NULL,
    NULL,
    1
);
GO

-- Check inserted data
SELECT EmployeeId,
       LoginUserName,
       EmployeeFullName,
       AddressLine,
       BasicSalary,
       Allowance,
       IsActive
FROM dbo.EmployeeProfile;
GO
