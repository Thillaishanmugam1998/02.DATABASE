/*==============================================================
    SQL SUB-TYPES (SQL COMMAND CATEGORIES)
==============================================================*/
-- SQL commands are divided into 5 main types:

-- 1) DDL (Data Definition Language)
--    Used to CREATE or MODIFY database objects
--    Commands: CREATE, ALTER, DROP, TRUNCATE, sp_rename

-- 2) DML (Data Manipulation Language)
--    Used to INSERT, UPDATE, DELETE data
--    Commands: INSERT, UPDATE, DELETE

-- 3) DQL / DRL (Data Query / Retrieval Language)
--    Used to FETCH data from tables
--    Commands: SELECT

-- 4) TCL (Transaction Control Language)
--    Used to manage transactions
--    Commands: COMMIT, ROLLBACK, SAVEPOINT

-- 5) DCL (Data Control Language)
--    Used to control user permissions
--    Commands: GRANT, REVOKE


/*==============================================================
    01. CREATE TABLE
==============================================================*/
-- Used to create a new table in the database

-- Syntax:
-- CREATE TABLE <TableName>
-- (
--      <ColumnName1> <DataType> [Size],
--      <ColumnName2> <DataType> [Size],
--      ...
-- );

-- Example:
CREATE TABLE Student
(
    StId    INT,                -- Student ID
    SName   VARCHAR(MAX),       -- Student Name
    Salary  DECIMAL(6,2)        -- Student Salary
);


/*==============================================================
    02. ALTER TABLE
    (Modify Existing Table Structure)
==============================================================*/

-- 1) Change column size (width)
-- Syntax:
-- ALTER TABLE <TableName>
-- ALTER COLUMN <ColumnName> <DataType>(NewSize);
ALTER TABLE Student
ALTER COLUMN SName VARCHAR(100);


-- 2) Change data type of column
-- Syntax:
-- ALTER TABLE <TableName>
-- ALTER COLUMN <ColumnName> <NewDataType>;
ALTER TABLE Student
ALTER COLUMN SName NVARCHAR(100);


-- 3) Change NULL to NOT NULL or NOT NULL to NULL
-- Syntax:
-- ALTER TABLE <TableName>
-- ALTER COLUMN <ColumnName> <DataType> NOT NULL;
-- ALTER TABLE <TableName>
-- ALTER COLUMN <ColumnName> <DataType> NULL;
ALTER TABLE Student
ALTER COLUMN StId INT NOT NULL;

ALTER TABLE Student
ALTER COLUMN StId INT NULL;


-- 4) Add a new column
-- Syntax:
-- ALTER TABLE <TableName>
-- ADD <ColumnName> <DataType>(Size);
ALTER TABLE Student
ADD Branch VARCHAR(50);


-- 5) Delete (Drop) a column
-- Syntax:
-- ALTER TABLE <TableName>
-- DROP COLUMN <ColumnName>;
ALTER TABLE Student
DROP COLUMN Branch;


-- 6) Rename column or table
-- Using system stored procedure: sp_rename

-- Syntax:
-- EXEC sp_rename 'TableName.OldColumnName', 'NewColumnName';
-- EXEC sp_rename 'OldTableName', 'NewTableName';

EXEC sp_rename 'Student.SName', 'StudentName';


/*==============================================================
    03. TRUNCATE TABLE
==============================================================*/
-- Deletes ALL rows from table
-- WHERE clause is NOT allowed
-- Table structure remains
-- Faster than DELETE

-- Syntax:
-- TRUNCATE TABLE <TableName>;
TRUNCATE TABLE Student;


/*==============================================================
    04. DROP TABLE
==============================================================*/
-- Permanently deletes the table
-- Both data and structure are removed

-- Syntax:
-- DROP TABLE <TableName>;
DROP TABLE Student;
