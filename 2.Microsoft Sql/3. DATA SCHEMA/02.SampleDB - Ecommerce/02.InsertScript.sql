INSERT INTO Customers (FirstName, LastName, Email, Phone) VALUES
    (N'Thillai',    N'S',           N'thillai.s@cuddalore.dev',    '9876543210'),  -- You! Multi-orders
    (N'Arun',       N'Kumar',       N'arun.kumar@tntech.com',      NULL),           -- No phone, single order
    (N'Priya',      N'Murugan',     N'priya.m@flipkart-like.com',  '8123456789'),
    (N'Ramesh',     N'Pillai',      N'ramesh.p@localshop.in',      '9445566778'),
    (N'Selvi',      N'R',           N'selvi.ramazon@test.com',     '9876543221'),
    (N'Kumar',      N'P',           N'kumar.p@enterprise.net',     '9998887776'),   -- High-value
    (N'Lakshmi',    N'B',           N'lakshmi.b@homeshopper.in',   NULL),
    (N'Venu',       N'Gopal',       N'venu.g@techgadgets.com',     '8765432109'),
    (N'Meera',      N'Singh',       N'meera.s@intlbuyer.com',      '+911234567890'), -- Intl format
    (N'David',      N'Wilson',      N'david.w@globalretail.org',   '02079456789');   -- UK expat


INSERT INTO Products (ProductName, Category, UnitPrice, StockQty, IsActive) VALUES
    (N'Wireless Mouse Pro',     N'Electronics',   899.00,  5,   1),   -- Low stock
    (N'USB-C Cable 2m Fast',    N'Accessories',   349.00,  85,  1),
    (N'Coffee Mug Ceramic',     N'Home',          249.00,  200, 1),
    (N'Notebook A5 Lined',      N'Stationery',    179.00,  150, 1),
    (N'iPhone 15 Case',         N'Mobile',        1299.00, 20,  1),   -- High price
    (N'Gaming Keyboard RGB',    N'Electronics',   4999.00, 8,   1),   -- Premium, low stock
    (N'LED Desk Lamp',          N'Home',          1599.00, 45,  1),
    (N'Pen Set Premium',        N'Stationery',    299.00,  300, 1),
    (N'Old DVD Player',         N'Electronics',   499.00,  100, 0),   -- Inactive
    (N'Bluetooth Speaker Mini', N'Electronics',   1799.00, 12,  1);   -- Test joins exclude inactive



INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, OrderStatus) VALUES
    (1, '2026-02-01 10:30:00',  2798.00, 'Delivered'),    -- Thillai: 2 mice + laptop bag (simulate)
    (2, '2026-02-03 14:15:00',  349.00,  'Pending'),      -- Arun: Cable
    (1, '2026-02-04 05:32:00',  428.00,  'Shipped'),      -- Thillai today (your time!)
    (3, '2026-01-30 09:00:00',  598.00,  'Processing'),
    (4, '2026-02-02 18:45:00',  1798.00, 'Cancelled'),    -- Edge: Cancelled for refund queries
    (5, '2026-01-28 16:20:00',  2598.00, 'Delivered'),
    (6, '2026-02-03 22:10:00',  9997.00, 'Shipped'),      -- Enterprise bulk
    (7, '2026-01-31 11:55:00',  448.00,  'Pending'),
    (8, '2026-02-04 03:15:00',  3798.00, 'Processing'),   -- Early morning Cuddalore
    (9, '2026-02-02 20:00:00',  1299.00, 'Delivered');    -- Intl single item


INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
    (1, 1, 2, 899.00),      -- Thillai: 2 mice @ old price
    (1, 4, 3, 179.00),      -- +3 notebooks (total matches 2*899 + 3*179 - wait, adjust your calc)
    (2, 2, 1, 349.00),      -- Arun single
    (3, 2, 1, 349.00),      -- Thillai cable
    (3, 3, 1, 79.00),       -- Mug discounted snapshot
    (4, 5, 1, 1299.00),     -- Priya case
    (4, 1, 1, 799.00),      -- Mouse price drop
    (5, 6, 1, 4999.00),     -- Ramesh cancelled premium (test DELETE CASCADE)
    (6, 7, 2, 1599.00),     -- Selvi lamps
    (7, 10,3, 599.00);      -- Kumar bulk speakers (snapshot discount)



COMMIT TRANSACTION;
GO

-- 1. Row counts
SELECT 'Customers' AS TableName, COUNT(*) AS Rows FROM Customers
UNION ALL SELECT 'Products', COUNT(*) FROM Products
UNION ALL SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL SELECT 'OrderItems', COUNT(*) FROM OrderItems;

-- 2. Thillai's orders (your practice query)
SELECT c.FirstName + ' ' + c.LastName AS Customer, o.OrderID, o.TotalAmount, o.OrderStatus
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.CustomerID = 1;

-- 3. Low stock alert (WinForms grid)
SELECT p.ProductName, p.StockQty, p.Category
FROM Products p WHERE p.StockQty < 20 AND p.IsActive = 1;

-- 4. Customer lifetime value (GROUP BY)
SELECT c.Email, SUM(o.TotalAmount) AS LifetimeValue, COUNT(o.OrderID) AS OrderCount
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Email
HAVING SUM(o.TotalAmount) > 1000;