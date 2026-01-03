/*==============================================================
    FILE NAME : realworld_constraints.sql
    TOPIC     : SQL SERVER CONSTRAINTS (REAL-WORLD EXAMPLES)
    PURPOSE   : YouTube Coaching Notes
==============================================================*/

/*==============================================================
    DATABASE CREATION
==============================================================*/
CREATE DATABASE RetailDB;
GO

USE RetailDB;
GO


/*==============================================================
    1) CUSTOMER TABLE
    Stores customer information
==============================================================*/
CREATE TABLE Customer
(
    CustomerID INT PRIMARY KEY,        -- PRIMARY KEY ensures unique customer
    CustomerName VARCHAR(50) NOT NULL, -- Cannot be NULL
    MobileNo CHAR(10)                  -- Mobile number as CHAR(10)
);

-- Insert sample data
INSERT INTO Customer VALUES (1, 'Thillai',  '8675692630');
INSERT INTO Customer VALUES (2, 'Senthil',  '7598397824');
INSERT INTO Customer VALUES (3, 'Tamil',    '9080323760');


/*==============================================================
    2) PRODUCTS TABLE
    Stores product information
==============================================================*/
CREATE TABLE Products
(
    ProductCode INT PRIMARY KEY,       -- Unique product ID
    ProductName VARCHAR(40) NOT NULL,
    Price MONEY
);

-- Insert sample products
INSERT INTO Products VALUES (1, 'Camera',     24500);
INSERT INTO Products VALUES (2, 'iPhone',    245000);
INSERT INTO Products VALUES (3, 'Tab',        75500);
INSERT INTO Products VALUES (4, 'PS5',        50000);
INSERT INTO Products VALUES (5, 'HeadPhone',   2500);


/*==============================================================
    3) ORDERS TABLE
    Stores orders, demonstrates FOREIGN KEY relationships
==============================================================*/
CREATE TABLE Orders
(
    OrderID   INT PRIMARY KEY,         -- Unique order ID
    OrderDate DATETIME NOT NULL,
    Quantity  INT NOT NULL,

    CustomerID INT,                    -- FK to Customer
    ProductCode INT,                   -- FK to Product

    CONSTRAINT FK_Orders_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),

    CONSTRAINT FK_Orders_Product FOREIGN KEY (ProductCode)
        REFERENCES Products(ProductCode)
);

-- Sample orders
INSERT INTO Orders VALUES (1, GETDATE(), 2, 1, 2); -- Customer 1 buys 2 iPhones
INSERT INTO Orders VALUES (2, GETDATE(), 1, 3, 4); -- Customer 3 buys 1 PS5
INSERT INTO Orders VALUES (3, GETDATE(), 3, 2, 5); -- Customer 2 buys 3 HeadPhones


/*==============================================================
    4) EMPLOYEE TABLE
    Adding constraints after table creation
==============================================================*/
DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee
(
    EmpID INT,
    EmpName VARCHAR(50),
    Age INT,
    ProductCode INT
);

-- 1) Add PRIMARY KEY
ALTER TABLE Employee
ALTER COLUMN EmpID INT NOT NULL;

ALTER TABLE Employee
ADD CONSTRAINT PK_Employee PRIMARY KEY (EmpID);

-- 2) Add UNIQUE constraint
ALTER TABLE Employee
ADD CONSTRAINT UQ_EmployeeName UNIQUE (EmpName);

-- 3) Add CHECK constraint
ALTER TABLE Employee
ADD CONSTRAINT CHK_EmployeeAge CHECK (Age >= 10);

-- 4) Add FOREIGN KEY constraint
ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_Product
FOREIGN KEY (ProductCode) REFERENCES Products(ProductCode);


/*==============================================================
    5) DROP CONSTRAINTS
==============================================================*/
-- Drop CHECK constraint
ALTER TABLE Employee DROP CONSTRAINT CHK_EmployeeAge;

-- Drop UNIQUE constraint
ALTER TABLE Employee DROP CONSTRAINT UQ_EmployeeName;

-- Drop FOREIGN KEY constraint
ALTER TABLE Employee DROP CONSTRAINT FK_Employee_Product;


/*==============================================================
    6) EXPLANATIONS
==============================================================*/

/*
PRIMARY KEY:
- Uniquely identifies each row in a table.
- Cannot be NULL.
- Example: CustomerID in Customer table.
- Ensures no duplicate customer exists.

FOREIGN KEY:
- References a PRIMARY KEY in another table.
- Ensures referential integrity (no orphan records).
- Example: CustomerID in Orders table references Customer(CustomerID).

UNIQUE:
- Ensures values in a column (or combination of columns) are unique.

CHECK:
- Enforces a condition on column values (e.g., Age >= 10).

DEFAULT:
- Sets a default value for a column if no value is provided.

NOT NULL:
- Column must have a value; cannot be empty.
*/


/*==============================================================
    7) SELECT EXAMPLES
==============================================================*/
-- View customers
SELECT * FROM Customer;

-- View products
SELECT * FROM Products;

-- View orders with customer and product info
SELECT o.OrderID, o.OrderDate, o.Quantity,
       c.CustomerName, p.ProductName, p.Price
FROM Orders o
JOIN Customer c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductCode = p.ProductCode;

-- View employee table
SELECT * FROM Employee;
GO
