-- =============================================
-- Sample Database: Small Retail / E-commerce Test Schema
-- 4 tables with proper PK → FK relationships
-- =============================================

-- 1. Customers (Root table)
CREATE TABLE Customers (
    CustomerID    INT          IDENTITY(1,1)   PRIMARY KEY,
    FirstName     NVARCHAR(50)                NOT NULL,
    LastName      NVARCHAR(50)                NOT NULL,
    Email         NVARCHAR(100)   UNIQUE      NOT NULL,
    Phone         NVARCHAR(20)                NULL,
    CreatedDate   DATETIME2       DEFAULT SYSUTCDATETIME()
);

-- 2. Products (Independent catalog table)
CREATE TABLE Products (
    ProductID     INT           IDENTITY(1,1)   PRIMARY KEY,
    ProductName   NVARCHAR(100)                 NOT NULL,
    Category      NVARCHAR(50)                  NULL,
    UnitPrice     DECIMAL(10,2)                 NOT NULL,
    StockQty      INT           DEFAULT 0       NOT NULL,
    IsActive      BIT           DEFAULT 1
);

-- 3. Orders (references Customers)
CREATE TABLE Orders (
    OrderID       INT           IDENTITY(1,1)   PRIMARY KEY,
    CustomerID    INT                           NOT NULL,
    OrderDate     DATETIME2     DEFAULT SYSUTCDATETIME(),
    TotalAmount   DECIMAL(12,2)                 NOT NULL,
    OrderStatus   NVARCHAR(20)  DEFAULT 'Pending' -- Pending, Processing, Shipped, Delivered, Cancelled
        CONSTRAINT CHK_OrderStatus 
        CHECK (OrderStatus IN ('Pending','Processing','Shipped','Delivered','Cancelled')),

    CONSTRAINT FK_Orders_Customers 
        FOREIGN KEY (CustomerID) 
        REFERENCES Customers(CustomerID)
        ON DELETE NO ACTION     -- or CASCADE if you prefer
);

-- 4. OrderItems (references Orders + Products)
CREATE TABLE OrderItems (
    OrderItemID   INT           IDENTITY(1,1)   PRIMARY KEY,
    OrderID       INT                           NOT NULL,
    ProductID     INT                           NOT NULL,
    Quantity      INT                           NOT NULL 
        CONSTRAINT CHK_Quantity_Positive CHECK (Quantity > 0),
    UnitPrice     DECIMAL(10,2)                 NOT NULL,   -- price at time of order
    LineTotal     AS (Quantity * UnitPrice) PERSISTED,     -- computed column

    CONSTRAINT FK_OrderItems_Orders 
        FOREIGN KEY (OrderID) 
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE,          -- delete order → delete its items

    CONSTRAINT FK_OrderItems_Products 
        FOREIGN KEY (ProductID) 
        REFERENCES Products(ProductID)
        ON DELETE NO ACTION
);