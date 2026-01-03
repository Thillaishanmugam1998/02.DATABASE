/*==============================================================
 FILE      : cascading_referential_integrity_demo.sql
 DB        : SQL SERVER
 TOPIC     : CASCADING REFERENTIAL INTEGRITY (Simple Notes)
 NOTE      : Easy, beginner-friendly, step-by-step with outputs
==============================================================*/

/*==============================================================
  IMPORTANT NOTE ABOUT CASCADING
==============================================================*/

/*
1) Cascading rules (CASCADE, SET NULL, SET DEFAULT, NO ACTION) 
   are allowed **ONLY for FOREIGN KEY columns**.

2) What this means:
   - Only columns that reference another table (child → parent) 
     can use cascading.
   - Regular columns (non-foreign key) cannot have cascade rules.
   - Example: 
       • Orders.pid → references Products.pcode  → can have CASCADE
       • Orders.quantity → just a number → cannot have CASCADE

3) Why:
   - Cascade is all about keeping **parent-child relationship consistent**.
   - Non-key columns are independent, so no need for cascade.
*/

/*==============================================================
  0) WHY CASCADING IS NEEDED?
==============================================================*/
/*
Problem:
- Parent table = Products
- Child table = Orders
- If we remove a product from the Products table, 
  the orders that are using that product will have a problem or error.
- Default behavior (NO ACTION) → SQL Server gives an error.

Solution:
- Cascading lets child rows automatically update or delete.
- Makes database consistent without manual changes.
*/

/*==============================================================
  1) PARENT TABLE : PRODUCTS
==============================================================*/
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;

CREATE TABLE Products
(
    ProductCode INT PRIMARY KEY,     -- Unique product ID
    ProductName VARCHAR(50),
    ProductCategory VARCHAR(50)
);

INSERT INTO Products VALUES
(1, 'Samsung Galaxy S22', 'Mobile'),
(2, 'iPhone 15', 'Mobile'),
(3, 'Dell XPS 13', 'Laptop'),
(4, 'Canon EOS 1500D', 'Camera');

SELECT * FROM Products;
/*
Output:
ProductCode | ProductName         | ProductCategory
--------------------------------------------------
1           | Samsung Galaxy S22  | Mobile
2           | iPhone 15           | Mobile
3           | Dell XPS 13         | Laptop
4           | Canon EOS 1500D     | Camera
*/

/*==============================================================
  2) CHILD TABLE WITHOUT CASCADE (NO ACTION)
==============================================================*/
DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    ProductID INT,
    Quantity INT,

    CONSTRAINT FK_Orders_NoAction
    FOREIGN KEY (ProductID) REFERENCES Products(ProductCode)
    -- NO CASCADE by default
);

INSERT INTO Orders VALUES
(1, 'Thillai', 1, 2),
(2, 'Senthil', 2, 1);

SELECT * FROM Orders;
/*
Output:
OrderID | CustomerName | ProductID | Quantity
---------------------------------------------
1       | Thillai      | 1         | 2
2       | Senthil      | 2         | 1
*/

-- ❌ Try deleting ProductCode = 1 → Error
-- DELETE FROM Products WHERE ProductCode = 1;

-- ✔ Updating ProductName works fine
UPDATE Products SET ProductName = 'Samsung Galaxy S22 Ultra' WHERE ProductCode = 1;

/*==============================================================
  3) CASCADING TYPES - EXPLAINED BEFORE EXAMPLES
==============================================================*/

/*
CASCADING TYPES:
----------------
Cascading rules are instructions for what should happen in a child table
when a related record in the parent table is UPDATED or DELETED.

1) CASCADE
   - What it is: Child rows automatically change or get deleted 
     when the parent row changes or is deleted.
   - Why we use it: To keep child tables consistent without manual updates.
   - What happens:
        • Delete parent → child rows deleted automatically
        • Update parent key → child foreign key updated automatically

2) SET NULL
   - What it is: Child foreign key becomes NULL when parent row changes or is deleted.
   - Why we use it: When we want to keep child rows but show that the parent no longer exists.
   - What happens:
        • Delete parent → child foreign key set to NULL
        • Update parent key → child foreign key set to NULL

3) SET DEFAULT
   - What it is: Child foreign key is set to a default value when parent row changes or is deleted.
   - Why we use it: When we want a default/fallback value instead of leaving NULL.
   - What happens:
        • Delete parent → child foreign key set to DEFAULT
        • Update parent key → child foreign key set to DEFAULT

4) NO ACTION / RESTRICT (Default behavior)
   - What it is: Prevents deletion or update of parent row if child rows exist.
   - Why we use it: To avoid accidentally breaking child data.
   - What happens:
        • Delete parent → Error
        • Update parent key → Error
        • Non-key column changes → Allowed
*/

/*
SIMPLE EXAMPLE FOR THINKING:
- Parent table: Products
- Child table: Orders
- ProductID in Orders references ProductCode in Products

IF we remove a product without cascade:
   → Orders with that product will stop working or give an error
   → Database becomes inconsistent

With cascading:
   → Child table reacts automatically based on cascade type
*/


/*==============================================================
  3) CASCADING TYPES WITH EXAMPLES
==============================================================*/

/*--------------------------------------------------------------
  3.1) CASCADE → child follows parent
--------------------------------------------------------------*/
DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    ProductID INT,
    Quantity INT,

    CONSTRAINT FK_Orders_Cascade
    FOREIGN KEY (ProductID) REFERENCES Products(ProductCode)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

INSERT INTO Orders VALUES
(1, 'Arun', 3, 1),
(2, 'Kumar', 4, 2);

-- UPDATE parent PK
UPDATE Products SET ProductCode = 3 WHERE ProductCode = 3;
-- ✔ Orders.ProductID auto updates from 3 → 3 (example)

-- DELETE parent PK
DELETE FROM Products WHERE ProductCode = 4;
-- ✔ Orders row for Kumar deleted automatically

SELECT * FROM Orders;
/*
Sample Output:
OrderID | CustomerName | ProductID | Quantity
---------------------------------------------
1       | Arun         | 3         | 1
*/

/*--------------------------------------------------------------
  3.2) SET NULL → child FK becomes NULL
--------------------------------------------------------------*/
DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    ProductID INT NULL,
    Quantity INT,

    CONSTRAINT FK_Orders_SetNull
    FOREIGN KEY (ProductID) REFERENCES Products(ProductCode)
    ON DELETE SET NULL
    ON UPDATE SET NULL
);

INSERT INTO Orders VALUES
(1, 'Thillai', 1, 2),
(2, 'Senthil', 2, 1);

-- DELETE parent PK
DELETE FROM Products WHERE ProductCode = 1;
-- ✔ Orders.ProductID = NULL for Thillai

-- UPDATE parent PK
UPDATE Products SET ProductCode = 2 WHERE ProductCode = 2;
-- ✔ Orders.ProductID = NULL for Senthil

SELECT * FROM Orders;
/*
Sample Output:
OrderID | CustomerName | ProductID | Quantity
---------------------------------------------
1       | Thillai      | NULL      | 2
2       | Senthil      | NULL      | 1
*/

/*--------------------------------------------------------------
  3.3) SET DEFAULT → child FK becomes default
--------------------------------------------------------------*/
DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    ProductID INT DEFAULT 0,
    Quantity INT,

    CONSTRAINT FK_Orders_SetDefault
    FOREIGN KEY (ProductID) REFERENCES Products(ProductCode)
    ON DELETE SET DEFAULT
    ON UPDATE SET DEFAULT
);

INSERT INTO Orders VALUES
(1, 'Tamil', 3, 1),
(2, 'Arun', 4, 1);

-- DELETE parent PK
DELETE FROM Products WHERE ProductCode = 3;
-- ✔ Orders.ProductID = 0 for Tamil

-- UPDATE parent PK
UPDATE Products SET ProductCode = 4 WHERE ProductCode = 4;
-- ✔ Orders.ProductID = 0 for Arun

SELECT * FROM Orders;
/*
Sample Output:
OrderID | CustomerName | ProductID | Quantity
---------------------------------------------
1       | Tamil        | 0         | 1
2       | Arun         | 0         | 1
*/

/*--------------------------------------------------------------
  3.4) NO ACTION / RESTRICT → default behavior
--------------------------------------------------------------*/
DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    ProductID INT,
    Quantity INT,

    CONSTRAINT FK_Orders_NoAction2
    FOREIGN KEY (ProductID) REFERENCES Products(ProductCode)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

INSERT INTO Orders VALUES
(1, 'Kumar', 1, 1),
(2, 'Ravi', 2, 1);

-- ❌ DELETE parent PK → Error
-- ❌ UPDATE parent PK → Error

SELECT * FROM Orders;

/*==============================================================
  4) SUMMARY
==============================================================*/
/*
CASCADING RULES:
-----------------------------------------------
1) CASCADE
   - Child row follows parent
   - Example: delete product → order deleted
2) SET NULL
   - Child FK becomes NULL
   - Example: delete product → order shows ProductID = NULL
3) SET DEFAULT
   - Child FK becomes DEFAULT value
   - Example: delete product → order shows ProductID = 0
4) NO ACTION / RESTRICT
   - Blocks update/delete parent if referenced
   - Default behavior
-----------------------------------------------
*/
