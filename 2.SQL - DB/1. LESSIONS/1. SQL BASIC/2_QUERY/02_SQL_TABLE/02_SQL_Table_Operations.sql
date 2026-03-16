/*=============================================================================
    FILE: 02_SQL_Table_Operations.sql
    TOPIC: SQL COMMAND TYPES + TABLE OPERATIONS
    DB   : RetailLearningDB

    LEARNING GOAL:
    - First understand SQL command categories completely
    - Then practice table operations with real examples
=============================================================================*/

IF DB_ID('RetailLearningDB') IS NULL
BEGIN
    CREATE DATABASE RetailLearningDB;
END
GO

USE RetailLearningDB;
GO

/*=============================================================================
    1) SQL COMMAND CATEGORIES - FULL EXPLANATION
=============================================================================*/
/*
SQL commands are commonly grouped into 5 families:

1. DDL (Data Definition Language)
   Purpose:
   - Create or change database objects (database, table, column, constraint)

   Commands:
   - CREATE
   - ALTER
   - DROP
   - TRUNCATE
   - RENAME (in SQL Server usually via sp_rename)

   Real-time example:
   - When a new module starts, developer creates tables.
   - When business adds a new field (ex: GSTNumber), table is altered.

2. DML (Data Manipulation Language)
   Purpose:
   - Add, update, delete actual row data inside tables

   Commands:
   - INSERT
   - UPDATE
   - DELETE

   Real-time example:
   - Insert new customer
   - Update mobile number
   - Delete cancelled test records

3. DQL (Data Query Language)
   Purpose:
   - Read/fetch data

   Command:
   - SELECT

   Real-time example:
   - Fetch all active customers
   - Generate dashboard reports

4. TCL (Transaction Control Language)
   Purpose:
   - Control transaction behavior (all-or-nothing changes)

   Commands:
   - BEGIN TRANSACTION
   - COMMIT
   - ROLLBACK

   Real-time example:
   - Transfer money: debit and credit must both succeed.

5. DCL (Data Control Language)
   Purpose:
   - Control access/security permissions

   Commands:
   - GRANT
   - REVOKE

   Real-time example:
   - Give read-only access to reporting user.
*/

/*=============================================================================
    2) WHY TABLE OPERATIONS MATTER?
=============================================================================*/
/*
Table operations are part of DDL and are used in every project phase:

- Initial development: CREATE TABLE
- Requirement changes: ALTER TABLE
- Data reset in testing: TRUNCATE TABLE
- Cleanup/decommission: DROP TABLE

If these are not understood clearly:
- You may lose data accidentally.
- You may break dependent queries/procedures.
- Production changes can fail.
*/

/*=============================================================================
    3) PRACTICAL SAMPLE FLOW (STEP-BY-STEP)
    Use case: Customer master table in retail app
=============================================================================*/

/*---------------------------------------------------------------------
  STEP 1: CREATE TABLE (DDL)
---------------------------------------------------------------------*/
DROP TABLE IF EXISTS DemoCustomer;
GO

CREATE TABLE DemoCustomer
(
    CustomerID INT,
    CustomerName VARCHAR(100),
    City VARCHAR(50)
);
GO

/*
Explanation:
- CustomerID: customer numeric id
- CustomerName: name of customer
- City: location
*/

/*---------------------------------------------------------------------
  STEP 2: INSERT DATA (DML) - to verify table works
---------------------------------------------------------------------*/
INSERT INTO DemoCustomer (CustomerID, CustomerName, City)
VALUES
(1, 'Arun', 'Chennai'),
(2, 'Meena', 'Coimbatore');

SELECT * FROM DemoCustomer;
GO

/*---------------------------------------------------------------------
  STEP 3: ALTER TABLE (DDL)
---------------------------------------------------------------------*/

-- 3.1 Change data type/size (support larger multilingual names)
ALTER TABLE DemoCustomer
ALTER COLUMN CustomerName NVARCHAR(120);

-- 3.2 Add new column (new business requirement)
ALTER TABLE DemoCustomer
ADD MobileNo CHAR(10) NULL;

-- 3.3 Drop old column (if no longer needed)
ALTER TABLE DemoCustomer
DROP COLUMN City;

-- 3.4 Rename column for better naming clarity
EXEC sp_rename 'DemoCustomer.CustomerName', 'FullName', 'COLUMN';

-- 3.5 Rename table
EXEC sp_rename 'DemoCustomer', 'DemoCustomerMaster';
GO

SELECT * FROM DemoCustomerMaster;
GO

/*---------------------------------------------------------------------
  STEP 4: TRUNCATE TABLE (DDL)
---------------------------------------------------------------------*/
/*
TRUNCATE TABLE DemoCustomerMaster;

What it does:
- Deletes all rows quickly
- Keeps table structure

Important points:
- WHERE clause not allowed
- Usually used in test/staging cleanup
- Cannot be used when table is referenced by active foreign key
*/

TRUNCATE TABLE DemoCustomerMaster;
SELECT * FROM DemoCustomerMaster;
GO

/*---------------------------------------------------------------------
  STEP 5: DROP TABLE (DDL)
---------------------------------------------------------------------*/
/*
DROP TABLE removes:
- all rows
- full table structure

After DROP, table no longer exists.
*/
DROP TABLE DemoCustomerMaster;
GO

/*=============================================================================
    4) IMPORTANT DIFFERENCE: DELETE vs TRUNCATE vs DROP
=============================================================================*/
/*
DELETE:
- DML command
- Removes rows (can use WHERE)
- Table structure stays

TRUNCATE:
- DDL command
- Removes all rows only (no WHERE)
- Table structure stays
- Faster for full table cleanup

DROP:
- DDL command
- Removes complete object (structure + data)
*/

/*=============================================================================
    5) QUICK RECAP
=============================================================================*/
/*
- DDL changes structure.
- DML changes data.
- DQL reads data.
- TCL controls transaction safety.
- DCL controls permissions.

Most used table lifecycle:
CREATE -> ALTER -> (INSERT/UPDATE/DELETE/SELECT) -> TRUNCATE or DROP
*/
