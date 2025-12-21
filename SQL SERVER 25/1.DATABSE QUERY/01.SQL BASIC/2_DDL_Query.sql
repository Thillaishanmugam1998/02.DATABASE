/*==============================================================
    SQL SUB-TYPES
==============================================================*/
-- 1) DDL (Data Definition Language) → CREATE, ALTER, DROP, TRUNCATE, sp_rename
-- 2) DML (Data Manipulation Language) → INSERT, UPDATE, DELETE
-- 3) DQL / DRL (Data Query / Retrieval Language) → SELECT
-- 4) TCL (Transaction Control Language) → COMMIT, ROLLBACK, SAVEPOINT
-- 5) DCL (Data Control Language) → GRANT, REVOKE

/*==============================================================
    01. CREATE TABLE
==============================================================*/
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
    StId    INT,
    SName   VARCHAR(MAX),
    Salary  DECIMAL(6,2)
);


 /*==============================================================
    02. ALTER TABLE (MODIFY TABLE STRUCTURE)
==============================================================*/

-- 1) Change the width (size) of an existing column
-- Syntax:
-- ALTER TABLE <TableName> ALTER COLUMN <ColumnName> <DataType>(NewSize);
ALTER TABLE Student ALTER COLUMN SName VARCHAR(100);


-- 2) Change data type of existing column
-- Syntax:
-- ALTER TABLE <TableName> ALTER COLUMN <ColumnName> <NewDataType>;
ALTER TABLE Student ALTER COLUMN SName NVARCHAR(100);


-- 3) Change NULL to NOT NULL (or vice versa)
-- Syntax:
-- ALTER TABLE <TableName> ALTER COLUMN <ColumnName> <DataType> NOT NULL;
-- ALTER TABLE <TableName> ALTER COLUMN <ColumnName> <DataType> NULL;
ALTER TABLE Student ALTER COLUMN StId INT NOT NULL;
ALTER TABLE Student ALTER COLUMN StId INT NULL;


-- 4) Add a new column to existing table
-- Syntax:
-- ALTER TABLE <TableName> ADD <ColumnName> <DataType>(Size);
ALTER TABLE Student ADD Branch VARCHAR(50);


-- 5) Delete (Drop) an existing column
-- Syntax:
-- ALTER TABLE <TableName> DROP COLUMN <ColumnName>;
ALTER TABLE Student DROP COLUMN Branch;


-- 6) Rename column or table using system stored procedure
-- Syntax:
-- EXEC sp_rename 'TableName.OldColumnName', 'NewColumnName';
-- EXEC sp_rename 'OldTableName', 'NewTableName';

EXEC sp_rename 'Student.SName', 'StudentName';


/*==============================================================
    03. TRUNCATE TABLE
==============================================================*/
-- Deletes ALL rows
-- Does NOT support WHERE clause
-- Structure remains
-- Syntax:
-- TRUNCATE TABLE <TableName>;
TRUNCATE TABLE Student;


/*==============================================================
    04. DROP TABLE
==============================================================*/
-- Permanently deletes the table from database
-- Syntax:
-- DROP TABLE <TableName>;
DROP TABLE Student;
