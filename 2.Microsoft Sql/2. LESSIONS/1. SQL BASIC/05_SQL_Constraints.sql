/*========================================================
    TOPIC : SQL SERVER CONSTRAINTS – COMPLETE GUIDE
    FILE  : sql_constraints_practice.sql
========================================================*/

/*
    1) WHAT ARE CONSTRAINTS?
    --------------------------------------------------------
    - Constraints enforce rules at the column or table level.
    - They ensure **data integrity** in your database.
    - Examples of why we need constraints:
        • Prevent duplicate values (UNIQUE, PRIMARY KEY)
        • Prevent invalid data (CHECK, NOT NULL)
        • Automatically set default values (DEFAULT)
        • Ensure relationships between tables (FOREIGN KEY)
*/

/*========================================================
    2) DEFAULT CONSTRAINT
========================================================*/

-- DEFAULT sets a default value for a column if user doesn't provide one

-- Example: Real-world car table
CREATE TABLE CarsDefaultCreate
(
    CarID INT,
    CarBrand VARCHAR(50),
    WheelCount SMALLINT DEFAULT 4   -- Default 4 wheels
);

-- Insert without specifying WheelCount
INSERT INTO CarsDefaultCreate (CarID, CarBrand)
VALUES (1, 'Tata Nexon');

SELECT * FROM CarsDefaultCreate; -- WheelCount = 4 automatically

-- Add DEFAULT constraint using ALTER TABLE
CREATE TABLE CarsDefaultAlter
(
    CarID INT,
    CarBrand VARCHAR(50),
    WheelCount SMALLINT
);

ALTER TABLE CarsDefaultAlter
ADD CONSTRAINT DF_WheelCount DEFAULT 4 FOR WheelCount;

INSERT INTO CarsDefaultAlter (CarID, CarBrand)
VALUES (2, 'Audi A6');

SELECT * FROM CarsDefaultAlter;

-- Cleanup
DROP TABLE CarsDefaultCreate;
DROP TABLE CarsDefaultAlter;


/*========================================================
    3) NOT NULL CONSTRAINT
========================================================*/

-- NOT NULL ensures a column **cannot have NULL values**
CREATE TABLE EmployeesNotNull
(
    EmpID INT,
    EmpName VARCHAR(50) NOT NULL  -- Employee name is required
);

-- Insert example
-- INSERT INTO EmployeesNotNull (EmpID) VALUES (1); -- ❌ Error, EmpName is NULL
INSERT INTO EmployeesNotNull (EmpID, EmpName) VALUES (1, 'John Doe');

-- Add NOT NULL using ALTER TABLE (only works if no NULL exists)
ALTER TABLE EmployeesNotNull
ALTER COLUMN EmpName VARCHAR(50) NOT NULL;

SELECT * FROM EmployeesNotNull;

DROP TABLE EmployeesNotNull;


/*========================================================
    4) UNIQUE CONSTRAINT
========================================================*/

-- UNIQUE ensures no duplicate values
CREATE TABLE UsersUnique
(
    UserID INT,
    Email VARCHAR(100) UNIQUE   -- Each email must be unique
);

INSERT INTO UsersUnique VALUES (1, 'john@example.com');
-- INSERT INTO UsersUnique VALUES (2, 'john@example.com'); -- ❌ Error

-- Add UNIQUE using ALTER TABLE
CREATE TABLE UsersUniqueAlter
(
    UserID INT,
    Email VARCHAR(100)
);

-- Make sure existing data has no duplicates
ALTER TABLE UsersUniqueAlter
ADD CONSTRAINT UQ_Email UNIQUE (Email);

DROP TABLE UsersUnique;
DROP TABLE UsersUniqueAlter;


/*========================================================
    5) CHECK CONSTRAINT
========================================================*/

-- CHECK ensures values meet a condition
CREATE TABLE StudentsCheck
(
    StudentID INT,
    Age SMALLINT CONSTRAINT CHK_StudentAge CHECK (Age >= 18)
);

INSERT INTO StudentsCheck VALUES (1, 18); -- OK
INSERT INTO StudentsCheck VALUES (2, 25); -- OK
-- INSERT INTO StudentsCheck VALUES (3, 15); -- ❌ Error

-- Add CHECK using ALTER TABLE
CREATE TABLE StudentsCheckAlter
(
    StudentID INT,
    Age SMALLINT
);

-- Ensure data meets condition
ALTER TABLE StudentsCheckAlter
ADD CONSTRAINT CHK_StudentAgeAge CHECK (Age >= 18);

DROP TABLE StudentsCheck;
DROP TABLE StudentsCheckAlter;


/*========================================================
    6) PRIMARY KEY CONSTRAINT
========================================================*/

-- PRIMARY KEY ensures **unique and not null** (one per table)
CREATE TABLE BranchesPK
(
    BranchCode INT PRIMARY KEY,
    BranchName VARCHAR(50),
    BranchLocation CHAR(6)
);

INSERT INTO BranchesPK VALUES (1, 'HDFC', '612001');
-- INSERT INTO BranchesPK VALUES (1, 'KVB', '612001'); -- ❌ Duplicate
-- INSERT INTO BranchesPK VALUES (NULL, 'IOB', '612002'); -- ❌ NULL not allowed

-- Add PRIMARY KEY using ALTER TABLE
CREATE TABLE BranchesPKAlter
(
    BranchCode INT NOT NULL,
    BranchName VARCHAR(50),
    BranchLocation CHAR(6)
);

ALTER TABLE BranchesPKAlter
ADD CONSTRAINT PK_Branches PRIMARY KEY (BranchCode);

-- Composite PRIMARY KEY
CREATE TABLE BranchesCompositePK
(
    BranchCode INT,
    BranchName VARCHAR(50),
    BranchLocation CHAR(6),
    CONSTRAINT PK_BranchComposite PRIMARY KEY (BranchCode, BranchName)
);

INSERT INTO BranchesCompositePK VALUES (1, 'HDFC', '612001'); -- OK
INSERT INTO BranchesCompositePK VALUES (1, 'KVB', '612001');  -- OK
-- INSERT INTO BranchesCompositePK VALUES (1, 'HDFC', '612005'); -- ❌ Duplicate

DROP TABLE BranchesPK;
DROP TABLE BranchesPKAlter;
DROP TABLE BranchesCompositePK;


/*========================================================
    7) FOREIGN KEY CONSTRAINT
========================================================*/

-- FOREIGN KEY enforces relationship between tables
CREATE TABLE BranchesFK
(
    BranchCode INT PRIMARY KEY,
    BranchName VARCHAR(50)
);

CREATE TABLE BankFK
(
    BankID INT PRIMARY KEY,
    BranchCode INT,
    Income MONEY,
    CONSTRAINT FK_BankBranch
        FOREIGN KEY (BranchCode) REFERENCES BranchesFK(BranchCode)
);

INSERT INTO BranchesFK VALUES (1, 'HDFC');
INSERT INTO BankFK VALUES (1, 1, 500000);
-- INSERT INTO BankFK VALUES (2, 5, 600000); -- ❌ No matching PK

DROP TABLE BankFK;
DROP TABLE BranchesFK;


/*========================================================
    SQL SERVER CONSTRAINTS – COLUMN-LEVEL & TABLE-LEVEL
    FILE  : sql_constraints_guide.sql
========================================================*/

/*
    WHAT ARE CONSTRAINTS?
    - Constraints enforce rules to maintain **data integrity**.
    - Examples:
        • NOT NULL → ensures column must have value
        • UNIQUE → prevents duplicate values
        • PRIMARY KEY → unique + not null
        • FOREIGN KEY → enforces relationships
        • CHECK → restricts values based on condition
        • DEFAULT → sets default value if not provided
*/

/*========================================================
    1) NOT NULL / NULL (COLUMN PROPERTY)
========================================================*/
-- Column-level only (cannot name)
CREATE TABLE Employees
(
    EmpID INT NOT NULL,          -- Column-level NOT NULL
    EmpName VARCHAR(50) NULL     -- Column can accept NULL
);

-- Change column to NOT NULL
ALTER TABLE Employees
ALTER COLUMN EmpName VARCHAR(50) NOT NULL;

-- Allow NULL again
ALTER TABLE Employees
ALTER COLUMN EmpName VARCHAR(50) NULL;


/*========================================================
    2) DEFAULT CONSTRAINT
========================================================*/
-- Column-level DEFAULT (named constraint)
CREATE TABLE Cars
(
    CarID INT,
    WheelCount INT CONSTRAINT DF_WheelCount DEFAULT 4
);

-- Add DEFAULT after table creation
ALTER TABLE Cars
ADD CONSTRAINT DF_WheelCount2 DEFAULT 4 FOR WheelCount;


/*========================================================
    3) UNIQUE CONSTRAINT
========================================================*/
-- Column-level UNIQUE
CREATE TABLE Users
(
    UserID INT,
    Email VARCHAR(100) CONSTRAINT UQ_Email UNIQUE
);

-- Table-level UNIQUE (can include multiple columns)
CREATE TABLE UsersComposite
(
    UserID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    CONSTRAINT UQ_FullName UNIQUE (FirstName, LastName)
);


/*========================================================
    4) CHECK CONSTRAINT
========================================================*/
-- Column-level CHECK (applies only to that column)
CREATE TABLE Students
(
    StudentID INT,
    Age INT CONSTRAINT CHK_Age CHECK (Age >= 18)
);

-- Table-level CHECK (can reference multiple columns)
CREATE TABLE StudentsTableCheck
(
    StudentID INT,
    Age INT,
    Score INT,
    CONSTRAINT CHK_AgeScore CHECK (Age >= 18 AND Score >= 0)
);


/*========================================================
    5) PRIMARY KEY
========================================================*/
-- Column-level PRIMARY KEY
CREATE TABLE Branches
(
    BranchCode INT CONSTRAINT PK_Branch PRIMARY KEY,
    BranchName VARCHAR(50)
);

-- Table-level PRIMARY KEY (can be composite)
CREATE TABLE BranchesComposite
(
    BranchCode INT,
    BranchName VARCHAR(50),
    BranchLocation CHAR(6),
    CONSTRAINT PK_BranchComposite PRIMARY KEY (BranchCode, BranchName)
);


/*========================================================
    6) FOREIGN KEY
========================================================*/
-- Column-level FOREIGN KEY
CREATE TABLE Bank
(
    BankID INT PRIMARY KEY,
    BranchCode INT CONSTRAINT FK_BankBranch FOREIGN KEY REFERENCES Branches(BranchCode),
    Income MONEY
);

-- Table-level FOREIGN KEY (can reference multiple columns)
CREATE TABLE BankTableFK
(
    BankID INT PRIMARY KEY,
    BranchCode INT,
    BranchName VARCHAR(50),
    CONSTRAINT FK_BankBranchTable FOREIGN KEY (BranchCode, BranchName)
        REFERENCES BranchesComposite(BranchCode, BranchName)
);


/*========================================================
    7) REAL-TIME EXAMPLE
========================================================*/
-- Car model table with multiple constraints
CREATE TABLE CarModel
(
    CarID INT,
    CarBrand VARCHAR(50),
    CarFuelType VARCHAR(20),
    CarWheel SMALLINT CONSTRAINT DF_CarWheel DEFAULT 4,  -- Column-level default
    CarModel VARCHAR(50) NOT NULL,                        -- Column-level NOT NULL
    CONSTRAINT UQ_Car UNIQUE (CarBrand, CarModel)        -- Table-level unique
);

INSERT INTO CarModel (CarID, CarBrand, CarFuelType, CarModel)
VALUES
(1, 'TATA', 'PETROL', 'NEXON'),
(2, 'AUDI', 'PETROL', 'A6');

SELECT * FROM CarModel;


/*========================================================
    8) DROP CONSTRAINT SYNTAX
========================================================*/
-- Drop a named constraint
ALTER TABLE CarModel DROP CONSTRAINT DF_CarWheel;
ALTER TABLE CarModel DROP CONSTRAINT UQ_Car;

-- NOT NULL cannot be dropped using DROP CONSTRAINT
ALTER TABLE CarModel ALTER COLUMN CarModel VARCHAR(50) NULL;  -- Use ALTER COLUMN instead


/*========================================================
    9) DROP CONSTRAINT
========================================================*/

-- Drop a constraint using ALTER TABLE
-- Syntax: ALTER TABLE table_name DROP CONSTRAINT constraint_name

-- Example: Drop default constraint
-- ALTER TABLE CarModel DROP CONSTRAINT DF_CarWheel;  -- If existed

-- Drop unique constraint
-- ALTER TABLE CarModel DROP CONSTRAINT UQ_Car;


