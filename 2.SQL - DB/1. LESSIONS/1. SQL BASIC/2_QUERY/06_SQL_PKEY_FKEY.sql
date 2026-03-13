/*=========================================================================
    FILE  : 06_SQL_Primary_Foreign_Key.sql
    TOPIC : PRIMARY KEY + FOREIGN KEY (Beginner to Practical)
    DB    : RetailLearningDB

    GOAL:
    - Understand PK and FK from zero
    - See real-world e-commerce relationship
    - Understand problems without keys
=========================================================================*/

IF DB_ID('RetailLearningDB') IS NULL
BEGIN
    CREATE DATABASE RetailLearningDB;
END
GO

USE RetailLearningDB;
GO

DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS BadOrders_NoKeys;
GO

/*=========================================================================
    1) CONCEPTS
=========================================================================*/
/*
PRIMARY KEY (PK)
- Uniquely identifies each row
- Cannot be NULL

FOREIGN KEY (FK)
- Column in child table referencing parent table PK/UNIQUE
- Prevents invalid references (orphan rows)

Memory line:
PK = row identity
FK = table relationship
*/

/*=========================================================================
    2) WITHOUT KEYS: PROBLEM DEMO
=========================================================================*/
CREATE TABLE BadOrders_NoKeys
(
    OrderID INT,
    CustomerID INT,
    ProductID INT,
    Quantity INT
);

INSERT INTO BadOrders_NoKeys VALUES (1001, 1, 101, 2);
INSERT INTO BadOrders_NoKeys VALUES (1001, 1, 101, 5); -- duplicate order id
INSERT INTO BadOrders_NoKeys VALUES (1002, 9999, 5555, 1); -- invalid references

SELECT * FROM BadOrders_NoKeys;
GO

/*=========================================================================
    3) WITH KEYS: REAL DESIGN
=========================================================================*/
CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    Email VARCHAR(120) UNIQUE
);

CREATE TABLE Products
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0)
);

CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    OrderDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CustomerID INT NOT NULL,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems
(
    OrderItemID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0),
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

INSERT INTO Customers VALUES
(1, N'Arun Kumar', 'arun@email.com'),
(2, N'Meena Ravi', 'meena@email.com');

INSERT INTO Products VALUES
(101, 'Laptop', 65000.00),
(102, 'Phone', 35000.00),
(103, 'Headphones', 2500.00);

INSERT INTO Orders (OrderID, CustomerID) VALUES
(5001, 1),
(5002, 2);

INSERT INTO OrderItems VALUES
(9001, 5001, 101, 1, 65000.00),
(9002, 5001, 103, 2, 2500.00),
(9003, 5002, 102, 1, 35000.00);
GO

/*=========================================================================
    4) PROOF: CONSTRAINT ERRORS (EXPECTED)
=========================================================================*/
BEGIN TRY
    INSERT INTO Customers VALUES (1, N'Duplicate', 'dup@email.com');
END TRY
BEGIN CATCH
    SELECT 'PK ERROR' AS Demo, ERROR_MESSAGE() AS SqlServerMessage;
END CATCH;

BEGIN TRY
    INSERT INTO Orders (OrderID, CustomerID) VALUES (5003, 999);
END TRY
BEGIN CATCH
    SELECT 'FK ERROR - INVALID CUSTOMER' AS Demo, ERROR_MESSAGE() AS SqlServerMessage;
END CATCH;
GO

/*=========================================================================
    5) RELIABLE JOIN OUTPUT
=========================================================================*/
SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerName,
    p.ProductName,
    oi.Quantity,
    oi.UnitPrice,
    oi.Quantity * oi.UnitPrice AS LineTotal
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON oi.OrderID = o.OrderID
JOIN Products p ON p.ProductID = oi.ProductID
ORDER BY o.OrderID, oi.OrderItemID;
GO

/*=========================================================================
    6) RECAP
=========================================================================*/
/*
Without PK/FK: duplicate and orphan data.
With PK/FK: trusted data and safe relationships.
PK identifies rows, FK connects rows.
*/
