/*=============================================================================
    FILE: 03_SQL_DML_And_Alter_Table_Example.sql
    TOPIC: DML + COMPLETE ALTER TABLE OPERATIONS
    DB   : RetailLearningDB

    LEARNING GOAL:
    - Understand DML quickly (INSERT, UPDATE, DELETE)
    - Master ALTER TABLE operations with syntax + examples
=============================================================================*/

IF DB_ID('RetailLearningDB') IS NULL
BEGIN
    CREATE DATABASE RetailLearningDB;
END
GO

USE RetailLearningDB;
GO

/*=============================================================================
    1) DML QUICK REFERENCE
=============================================================================*/
/*
INSERT  -> add new rows
UPDATE  -> modify existing rows
DELETE  -> remove rows
*/

/*=============================================================================
    2) BASE TABLES FOR DEMO
=============================================================================*/
DROP TABLE IF EXISTS ProductCatalog;
DROP TABLE IF EXISTS ProductCategoryMaster;
GO

CREATE TABLE ProductCategoryMaster
(
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

INSERT INTO ProductCategoryMaster VALUES
(1, 'Electronics'),
(2, 'Furniture'),
(3, 'Accessories');
GO

CREATE TABLE ProductCatalog
(
    ProductID INT,
    ProductName VARCHAR(80),
    CategoryID INT,
    Price DECIMAL(10,2)
);
GO

INSERT INTO ProductCatalog (ProductID, ProductName, CategoryID, Price)
VALUES
(101, 'Laptop', 1, 65000.00),
(102, 'Phone', 1, 35000.00),
(103, 'Office Chair', 2, 7500.00),
(104, 'Headphones', 3, 2500.00);
GO

/*=============================================================================
    3) DML EXAMPLES
=============================================================================*/

-- INSERT
INSERT INTO ProductCatalog (ProductID, ProductName, CategoryID, Price)
VALUES (105, 'Desk Lamp', 3, 1500.00);

-- UPDATE
UPDATE ProductCatalog
SET Price = 68000.00
WHERE ProductID = 101;

-- DELETE
DELETE FROM ProductCatalog
WHERE ProductID = 105;

SELECT * FROM ProductCatalog;
GO

/*=============================================================================
    4) ALTER TABLE - WHAT OPERATIONS WE CAN DO?
=============================================================================*/
/*
A) Add column
   Syntax:
   ALTER TABLE TableName ADD ColumnName DataType [NULL | NOT NULL];

B) Drop column
   Syntax:
   ALTER TABLE TableName DROP COLUMN ColumnName;

C) Change data type / change length
   Syntax:
   ALTER TABLE TableName ALTER COLUMN ColumnName NewDataType(NewLength);

D) Change NULL to NOT NULL
   Syntax:
   ALTER TABLE TableName ALTER COLUMN ColumnName DataType NOT NULL;

E) Change NOT NULL to NULL
   Syntax:
   ALTER TABLE TableName ALTER COLUMN ColumnName DataType NULL;

F) Add PRIMARY KEY constraint
   Syntax:
   ALTER TABLE TableName ADD CONSTRAINT ConstraintName PRIMARY KEY (ColumnName);

G) Add UNIQUE constraint
   Syntax:
   ALTER TABLE TableName ADD CONSTRAINT ConstraintName UNIQUE (ColumnName);

H) Add CHECK constraint
   Syntax:
   ALTER TABLE TableName ADD CONSTRAINT ConstraintName CHECK (Condition);

I) Add DEFAULT constraint
   Syntax:
   ALTER TABLE TableName ADD CONSTRAINT ConstraintName DEFAULT (Value) FOR ColumnName;

J) Add FOREIGN KEY constraint
   Syntax:
   ALTER TABLE ChildTable
   ADD CONSTRAINT ConstraintName
   FOREIGN KEY (ChildColumn) REFERENCES ParentTable(ParentColumn);

K) Drop constraint
   Syntax:
   ALTER TABLE TableName DROP CONSTRAINT ConstraintName;

L) Rename column (SQL Server)
   Syntax:
   EXEC sp_rename 'TableName.OldColumnName', 'NewColumnName', 'COLUMN';
*/

/*=============================================================================
    5) ALTER TABLE PRACTICAL DEMO (ALL MAJOR OPERATIONS)
=============================================================================*/

/*---------------------------------------------------------------------
  5.1 Add column
---------------------------------------------------------------------*/
ALTER TABLE ProductCatalog
ADD StockQty INT NULL;

/*---------------------------------------------------------------------
  5.2 Change data type and length
---------------------------------------------------------------------*/
ALTER TABLE ProductCatalog
ALTER COLUMN ProductName NVARCHAR(120);

/*---------------------------------------------------------------------
  5.3 Change NULL / NOT NULL
  Important: Before making NOT NULL, fill existing NULL values
---------------------------------------------------------------------*/
UPDATE ProductCatalog
SET StockQty = 0
WHERE StockQty IS NULL;

ALTER TABLE ProductCatalog
ALTER COLUMN StockQty INT NOT NULL;

-- If business later allows unknown stock, switch back to NULL
ALTER TABLE ProductCatalog
ALTER COLUMN StockQty INT NULL;

/*---------------------------------------------------------------------
  5.4 Add PRIMARY KEY
---------------------------------------------------------------------*/
ALTER TABLE ProductCatalog
ALTER COLUMN ProductID INT NOT NULL;

ALTER TABLE ProductCatalog
ADD CONSTRAINT PK_ProductCatalog PRIMARY KEY (ProductID);

/*---------------------------------------------------------------------
  5.5 Add UNIQUE, CHECK, DEFAULT
---------------------------------------------------------------------*/
ALTER TABLE ProductCatalog
ADD CONSTRAINT UQ_ProductCatalog_ProductName UNIQUE (ProductName);

ALTER TABLE ProductCatalog
ADD CONSTRAINT CHK_ProductCatalog_Price CHECK (Price > 0);

ALTER TABLE ProductCatalog
ADD CONSTRAINT DF_ProductCatalog_StockQty DEFAULT (0) FOR StockQty;

/*---------------------------------------------------------------------
  5.6 Add FOREIGN KEY
---------------------------------------------------------------------*/
ALTER TABLE ProductCatalog
ADD CONSTRAINT FK_ProductCatalog_Category
FOREIGN KEY (CategoryID)
REFERENCES ProductCategoryMaster(CategoryID);

/*---------------------------------------------------------------------
  5.7 Rename column
---------------------------------------------------------------------*/
EXEC sp_rename 'ProductCatalog.ProductName', 'ProductTitle', 'COLUMN';

/*---------------------------------------------------------------------
  5.8 Drop constraints (remove rules when business changes)
---------------------------------------------------------------------*/
ALTER TABLE ProductCatalog DROP CONSTRAINT FK_ProductCatalog_Category;
ALTER TABLE ProductCatalog DROP CONSTRAINT DF_ProductCatalog_StockQty;
ALTER TABLE ProductCatalog DROP CONSTRAINT CHK_ProductCatalog_Price;
ALTER TABLE ProductCatalog DROP CONSTRAINT UQ_ProductCatalog_ProductName;

/*---------------------------------------------------------------------
  5.9 Drop column
---------------------------------------------------------------------*/
ALTER TABLE ProductCatalog
DROP COLUMN StockQty;
GO

SELECT * FROM ProductCatalog;
GO

/*=============================================================================
    6) IMPORTANT NOTES FOR LEARNERS
=============================================================================*/
/*
1. ALTER TABLE changes structure, not data directly.
2. Some ALTER operations fail if existing data violates new rule.
3. Before NOT NULL, ensure no NULL values exist.
4. Before FK, ensure child values exist in parent table.
5. Naming constraints clearly helps maintenance.
*/

/*=============================================================================
    7) FINAL RECAP
=============================================================================*/
/*
Using ALTER TABLE you can:
- add/drop columns
- change datatype and length
- switch NULL/NOT NULL
- add/drop PK, FK, UNIQUE, CHECK, DEFAULT constraints
- rename columns (sp_rename)

This is the core skill for handling changing business requirements.
*/
