/*======================================================================
    SQL DATA TYPES – CLEAN NOTES
======================================================================*/

-- 1) What are SQL data types?
--    SQL data types define what kind of data a column can store 
--    (numbers, text, date/time, images, etc.).

/*======================================================================
    1) INTEGER DATA TYPES
======================================================================*/
-- Used to store whole numbers only (no decimal point).
-- Typical use: EmpId, ProductCode, BranchCode, etc.

-- TINYINT   : 1 byte   (0 to 255)
-- SMALLINT  : 2 bytes  (-32,768 to 32,767)
-- INT       : 4 bytes  (-2,147,483,648 to 2,147,483,647)
-- BIGINT    : 8 bytes  (very large integer range)

/*======================================================================
    2) DECIMAL / NUMERIC DATA TYPES
======================================================================*/
-- DECIMAL(p, s) and NUMERIC(p, s) are functionally the same.
-- p = Precision = total number of digits (both sides of the decimal).
-- s = Scale     = number of digits after the decimal point.

-- Example: 728.456
--          Total digits = 6  => Precision = 6
--          Digits after decimal = 3 => Scale = 3

-- Valid precision range : 1 to 38
-- Default (if not specified) often : DECIMAL(18, 0) or similar
-- (depends on SQL Server version, but idea: high precision integer)

/*======================================================================
    3) MONEY DATA TYPES
======================================================================*/
-- Used to store currency values.

-- SMALLMONEY : smaller range money type
-- MONEY      : larger range money type

-- Example: Salary, ProductPrice, InvoiceAmount, etc.

/*======================================================================
    4) DATE / TIME DATA TYPES
======================================================================*/
-- DATE      : Stores date only   =>  yyyy-mm-dd
-- TIME      : Stores time only   =>  hh:mm:ss[.fractional seconds]
-- DATETIME  : Stores date + time (older type in SQL Server)
-- (In newer SQL Server versions you also have DATETIME2, DATEONLY, etc.)

/*======================================================================
    5) CHARACTER DATA TYPES
======================================================================*/
-- Used to store letters, digits, and symbols (names, descriptions, etc.)

/* 5.1) Non-Unicode data types (single-byte per char) */
-- CHAR(size)        : Fixed-length (padded with spaces)
-- VARCHAR(size)     : Variable-length (up to given size)
-- VARCHAR(MAX)      : Variable-length, very large text
-- TEXT              : Old / deprecated (use VARCHAR(MAX) instead)

/* 5.2) Unicode data types (supports multiple languages) */
-- NCHAR(size)       : Fixed-length Unicode
-- NVARCHAR(size)    : Variable-length Unicode
-- NVARCHAR(MAX)     : Large Unicode text
-- NTEXT             : Old / deprecated (use NVARCHAR(MAX) instead)

-- NOTE: In SQL Server, Unicode string literals must be prefixed with N
-- Example:  N'தமிழ்', N'日本語', N'مرحبا'

/*======================================================================
    6) BINARY DATA TYPES
======================================================================*/
-- Used to store raw binary data: images, audio, video, documents, etc.

-- BINARY(size)      : Fixed-length binary data
-- VARBINARY(size)   : Variable-length binary data
-- VARBINARY(MAX)    : Large binary data (e.g. file content)

/*======================================================================
    7) BOOLEAN DATA TYPE
======================================================================*/
-- In SQL Server, Boolean values are usually stored using BIT.
-- BIT : 0 = False, 1 = True, NULL = Unknown

/*======================================================================
    8) SPECIAL DATA TYPES (COMMON EXAMPLES)
======================================================================*/
-- UNIQUEIDENTIFIER : Stores a GUID.
-- XML             : Stores XML data.
-- GEOGRAPHY       : Spatial data (latitude/longitude etc.)
-- HIERARCHYID     : Represents hierarchical data (tree structures).

/***********************************************************************
    REAL-TIME EXAMPLE TABLE USING THESE DATA TYPES
    (SQL Server style)
***********************************************************************/

-- Drop table if exists (for re-run)
IF OBJECT_ID('dbo.EmployeeProfile', 'U') IS NOT NULL
    DROP TABLE dbo.EmployeeProfile;
GO

CREATE TABLE dbo.EmployeeProfile
(
    -- 1) Integer examples
    EmployeeId          INT IDENTITY(1,1)       NOT NULL,        -- Primary key
    DeptCode            SMALLINT                NULL,            -- Department code

    -- 2) Decimal / Numeric example
    BasicSalary         DECIMAL(18,2)           NOT NULL,        -- e.g. 50000.75

    -- 3) Money example
    Allowance           MONEY                   NULL,            -- e.g. 2000.00

    -- 4) Date / Time examples
    DateOfJoining       DATE                    NOT NULL,
    ShiftStartTime      TIME(0)                 NULL,
    LastLoginDateTime   DATETIME                NULL,

    -- 5) Character data types
    -- Non-Unicode (English only or limited charset)
    LoginUserName       VARCHAR(50)             NOT NULL,        -- Non-Unicode
    DepartmentShortName CHAR(5)                 NULL,            -- Fixed size code
    Remarks             VARCHAR(MAX)            NULL,            -- Long text (non-Unicode)

    -- Unicode (supports multiple languages)
    EmployeeFullName    NVARCHAR(100)           NOT NULL,        -- Unicode
    AddressLine         NVARCHAR(250)           NULL,            -- Unicode
    AboutEmployee       NVARCHAR(MAX)           NULL,            -- Large Unicode text

    -- 6) Binary data types
    ProfilePhoto        VARBINARY(MAX)          NULL,            -- Image file bytes
    SignatureBinary     VARBINARY(512)          NULL,            -- Small binary data

    -- 7) Boolean (Bit)
    IsActive            BIT                     NOT NULL
        CONSTRAINT DF_EmployeeProfile_IsActive DEFAULT(1),

    -- 8) Special Data Type
    RowGuid             UNIQUEIDENTIFIER        NOT NULL
        CONSTRAINT DF_EmployeeProfile_RowGuid DEFAULT NEWID(),

    CONSTRAINT PK_EmployeeProfile PRIMARY KEY (EmployeeId)
);
GO

/***********************************************************************
    INSERT EXAMPLES – NON-UNICODE vs UNICODE
***********************************************************************/

-- Example 1: Non-Unicode English data
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
    10,                     -- DeptCode (SMALLINT)
    50000.75,               -- BasicSalary (DECIMAL(18,2))
    2500.00,                -- Allowance (MONEY)
    '2024-01-10',           -- DateOfJoining (DATE)
    '09:00:00',             -- ShiftStartTime (TIME)
    GETDATE(),              -- LastLoginDateTime (DATETIME)
    'john.doe',             -- LoginUserName (VARCHAR - Non-Unicode)
    'HR',                   -- DepartmentShortName (CHAR(5))
    'Regular full-time employee', -- Remarks (VARCHAR(MAX))
    N'John Doe',            -- EmployeeFullName (NVARCHAR - Unicode literal also ok)
    N'123, Main Street, Chennai', -- AddressLine (NVARCHAR)
    N'Good communication skills, works in HR.', -- AboutEmployee (NVARCHAR(MAX))
    NULL,                   -- ProfilePhoto (VARBINARY(MAX))
    NULL,                   -- SignatureBinary (VARBINARY)
    1                       -- IsActive (BIT)
);
GO

-- Example 2: Unicode data with local language (Tamil, Hindi, etc.)
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
    't.shanmugam',                          -- Non-Unicode login (VARCHAR)
    'IT',
    'Handles core application development', -- Non-Unicode remark
    N'தில்லை சண்முகம்',                      -- Unicode (Tamil)
    N'சென்னை, இந்தியா',                     -- Unicode (Tamil address)
    N'எல்லா பயன்பாட்டின் முக்கிய டெவலப்பர்.', -- Unicode long text
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
