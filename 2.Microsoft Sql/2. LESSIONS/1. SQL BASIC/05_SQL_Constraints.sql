/*=============================================================================
    FILE: 05_SQL_Constraints.sql
    TOPIC: SQL CONSTRAINTS - COMPLETE GUIDE
    DB   : RetailLearningDB

    LEARNING GOAL:
    - Understand what constraints are and why we use them
    - Learn all major constraint types with examples
    - Learn column-level vs table-level constraints
    - Learn two implementation styles:
      1) Add constraints during CREATE TABLE
      2) Create table first, then add constraints using ALTER TABLE
=============================================================================*/

IF DB_ID('RetailLearningDB') IS NULL
BEGIN
    CREATE DATABASE RetailLearningDB;
END
GO

USE RetailLearningDB;
GO

/*=============================================================================
    1) WHAT IS A CONSTRAINT?
=============================================================================*/
/*
Constraint is a rule enforced by the database on table data.

Why constraints are important:
- Prevent invalid data
- Protect data integrity even if application code has bugs
- Keep data consistent for reporting and analytics
- Reduce manual data cleanup effort

Simple idea:
"Constraint = safety rule for columns/tables"
*/

/*=============================================================================
    2) TYPES OF CONSTRAINTS
=============================================================================*/
/*
1) NOT NULL
   - Column must have value

2) PRIMARY KEY (PK)
   - Uniquely identifies each row
   - Unique + Not Null

3) UNIQUE
   - No duplicate values in column (or column combination)

4) CHECK
   - Value must satisfy a condition

5) DEFAULT
   - If no value given, database inserts default value

6) FOREIGN KEY (FK)
   - Child column must match existing value in parent table
   - Maintains relationship integrity
*/

/*=============================================================================
    3) COLUMN-LEVEL VS TABLE-LEVEL CONSTRAINTS
=============================================================================*/
/*
COLUMN-LEVEL CONSTRAINT:
- Defined next to a single column
- Best when rule belongs to one column

Example:
Email VARCHAR(120) UNIQUE
Age INT CHECK (Age >= 18)

TABLE-LEVEL CONSTRAINT:
- Defined after all columns
- Best for:
  - multi-column constraints
  - explicit naming
  - readability in bigger tables

Example:
CONSTRAINT PK_Table PRIMARY KEY (CustomerID)
CONSTRAINT UQ_Table UNIQUE (Email)

Which is preferred?
- In real projects, TABLE-LEVEL with explicit names is often preferred
  because maintenance/debugging is easier.
- For simple quick demos, column-level is fine.
*/

/*=============================================================================
    4) CREATE CONSTRAINTS DURING TABLE CREATION
=============================================================================*/

DROP TABLE IF EXISTS OrderHeader_ConstraintCreate;
DROP TABLE IF EXISTS Customer_ConstraintCreate;
GO

CREATE TABLE Customer_ConstraintCreate
(
    CustomerID INT NOT NULL,
    CustomerName NVARCHAR(100) NOT NULL,
    Email VARCHAR(120) NULL,
    Age INT NOT NULL,
    Country VARCHAR(40) NOT NULL,

    -- Table-level constraints (preferred for named constraints)
    CONSTRAINT PK_Customer_ConstraintCreate PRIMARY KEY (CustomerID),
    CONSTRAINT UQ_Customer_ConstraintCreate_Email UNIQUE (Email),
    CONSTRAINT CHK_Customer_ConstraintCreate_Age CHECK (Age >= 18),
    CONSTRAINT DF_Customer_ConstraintCreate_Country DEFAULT ('India') FOR Country
);
GO

CREATE TABLE OrderHeader_ConstraintCreate
(
    OrderID INT NOT NULL,
    CustomerID INT NOT NULL,
    OrderAmount DECIMAL(12,2) NOT NULL,

    CONSTRAINT PK_OrderHeader_ConstraintCreate PRIMARY KEY (OrderID),
    CONSTRAINT CHK_OrderHeader_ConstraintCreate_OrderAmount CHECK (OrderAmount > 0),
    CONSTRAINT FK_OrderHeader_ConstraintCreate_Customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customer_ConstraintCreate(CustomerID)
);
GO

/*=============================================================================
    5) VALID INSERT EXAMPLES (CREATE-TIME CONSTRAINTS)
=============================================================================*/
INSERT INTO Customer_ConstraintCreate (CustomerID, CustomerName, Email, Age, Country)
VALUES
(1, N'Arun', 'arun@email.com', 25, DEFAULT),
(2, N'Meena', 'meena@email.com', 29, 'India');

INSERT INTO OrderHeader_ConstraintCreate (OrderID, CustomerID, OrderAmount)
VALUES
(1001, 1, 65000.00),
(1002, 2, 12000.00);

SELECT * FROM Customer_ConstraintCreate;
SELECT * FROM OrderHeader_ConstraintCreate;
GO

/*=============================================================================
    6) INVALID INSERT EXAMPLES (EXPECTED ERRORS)
=============================================================================*/

-- PK violation (duplicate CustomerID)
BEGIN TRY
    INSERT INTO Customer_ConstraintCreate (CustomerID, CustomerName, Email, Age, Country)
    VALUES (1, N'Duplicate Arun', 'dup1@email.com', 27, 'India');
END TRY
BEGIN CATCH
    SELECT 'PK ERROR' AS Demo, ERROR_MESSAGE() AS SqlServerMessage;
END CATCH;

-- UNIQUE violation (duplicate Email)
BEGIN TRY
    INSERT INTO Customer_ConstraintCreate (CustomerID, CustomerName, Email, Age, Country)
    VALUES (3, N'Duplicate Email', 'arun@email.com', 31, 'India');
END TRY
BEGIN CATCH
    SELECT 'UNIQUE ERROR' AS Demo, ERROR_MESSAGE() AS SqlServerMessage;
END CATCH;

-- CHECK violation (Age < 18)
BEGIN TRY
    INSERT INTO Customer_ConstraintCreate (CustomerID, CustomerName, Email, Age, Country)
    VALUES (4, N'Under Age', 'underage@email.com', 16, 'India');
END TRY
BEGIN CATCH
    SELECT 'CHECK ERROR' AS Demo, ERROR_MESSAGE() AS SqlServerMessage;
END CATCH;

-- NOT NULL violation (CustomerName)
BEGIN TRY
    INSERT INTO Customer_ConstraintCreate (CustomerID, CustomerName, Email, Age, Country)
    VALUES (5, NULL, 'nullname@email.com', 22, 'India');
END TRY
BEGIN CATCH
    SELECT 'NOT NULL ERROR' AS Demo, ERROR_MESSAGE() AS SqlServerMessage;
END CATCH;

-- FK violation (CustomerID does not exist in parent table)
BEGIN TRY
    INSERT INTO OrderHeader_ConstraintCreate (OrderID, CustomerID, OrderAmount)
    VALUES (1003, 999, 500.00);
END TRY
BEGIN CATCH
    SELECT 'FOREIGN KEY ERROR' AS Demo, ERROR_MESSAGE() AS SqlServerMessage;
END CATCH;
GO

/*=============================================================================
    7) CREATE TABLE FIRST, THEN ADD CONSTRAINTS (ALTER TABLE METHOD)
=============================================================================*/

DROP TABLE IF EXISTS Employee_ConstraintAlter;
GO

CREATE TABLE Employee_ConstraintAlter
(
    EmpID INT,
    EmpName NVARCHAR(100),
    Email VARCHAR(120),
    Age INT,
    Department NVARCHAR(50),
    CreatedOn DATE
);
GO

/* 7.1 Add NOT NULL using ALTER COLUMN */
ALTER TABLE Employee_ConstraintAlter
ALTER COLUMN EmpID INT NOT NULL;

ALTER TABLE Employee_ConstraintAlter
ALTER COLUMN EmpName NVARCHAR(100) NOT NULL;

/* 7.2 Add PRIMARY KEY */
ALTER TABLE Employee_ConstraintAlter
ADD CONSTRAINT PK_Employee_ConstraintAlter PRIMARY KEY (EmpID);

/* 7.3 Add UNIQUE */
ALTER TABLE Employee_ConstraintAlter
ADD CONSTRAINT UQ_Employee_ConstraintAlter_Email UNIQUE (Email);

/* 7.4 Add CHECK */
ALTER TABLE Employee_ConstraintAlter
ADD CONSTRAINT CHK_Employee_ConstraintAlter_Age CHECK (Age >= 18);

/* 7.5 Add DEFAULT */
ALTER TABLE Employee_ConstraintAlter
ADD CONSTRAINT DF_Employee_ConstraintAlter_CreatedOn DEFAULT (CAST(GETDATE() AS DATE)) FOR CreatedOn;
GO

INSERT INTO Employee_ConstraintAlter (EmpID, EmpName, Email, Age, Department)
VALUES
(101, N'Sneha', 'sneha@email.com', 24, N'Sales'),
(102, N'Rahul', 'rahul@email.com', 28, N'HR');

SELECT * FROM Employee_ConstraintAlter;
GO

/*=============================================================================
    8) DROP CONSTRAINTS EXAMPLE
=============================================================================*/
/*
Business rules can change, then constraints may need to be replaced.
Syntax:
ALTER TABLE TableName DROP CONSTRAINT ConstraintName;
*/

ALTER TABLE Employee_ConstraintAlter DROP CONSTRAINT DF_Employee_ConstraintAlter_CreatedOn;
ALTER TABLE Employee_ConstraintAlter DROP CONSTRAINT CHK_Employee_ConstraintAlter_Age;
ALTER TABLE Employee_ConstraintAlter DROP CONSTRAINT UQ_Employee_ConstraintAlter_Email;
GO

/*=============================================================================
    9) BEST PRACTICES (MOST PREFERRED IN PROJECTS)
=============================================================================*/
/*
1) Prefer explicit constraint names
   Example: PK_Customer, FK_Order_Customer

2) Prefer table-level named constraints for maintainability

3) Keep business validation in DB + application both
   (defense in depth)

4) Use CHECK for business rules (age > 18, price > 0)

5) Add FK for all true parent-child relationships

6) Before adding constraints on existing table,
   clean bad data first or operation may fail.
*/

/*=============================================================================
    10) QUICK RECAP
=============================================================================*/
/*
- Constraint = database rule for valid data.
- Main types: NOT NULL, PK, UNIQUE, CHECK, DEFAULT, FK.
- Can be added:
  1) while creating table
  2) later using ALTER TABLE
- Column-level: for single-column simple rules.
- Table-level: preferred for named and multi-column rules.
*/
