Drop table Sales


CREATE TABLE Sales (
    SaleID      INT IDENTITY(1,1) PRIMARY KEY,
    SaleDate    DATE,
    Product     VARCHAR(50),
    Category    VARCHAR(30),
    Region      VARCHAR(30),
    CustomerType VARCHAR(20),   -- New / Returning / Corporate
    Quantity    INT,
    Amount      DECIMAL(12,2)
);



INSERT INTO Sales (SaleDate, Product, Category, Region, CustomerType, Quantity, Amount)
VALUES 
-- Electronics
('2025-01-05', 'Laptop',        'Electronics', 'North',   'New',       1,  45000.00),
('2025-01-08', 'Mobile',        'Electronics', 'South',   'Returning', 2,  32000.00),
('2025-01-12', 'Headphones',    'Electronics', 'North',   'Corporate', 5,   8500.00),
('2025-01-15', 'Tablet',        'Electronics', 'East',    'New',       1,  28000.00),

-- Clothing
('2025-01-03', 'T-Shirt',       'Clothing',    'South',   'Returning', 4,   1200.00),
('2025-01-10', 'Jeans',         'Clothing',    'North',   'New',       2,   3200.00),
('2025-01-18', 'Jacket',        'Clothing',    'West',    'Corporate', 3,   6500.00),

-- Home Appliances
('2025-01-07', 'Mixer Grinder', 'Home Appliances', 'South', 'Returning', 2,  4500.00),
('2025-01-14', 'Refrigerator',  'Home Appliances', 'North', 'New',       1, 32000.00),
('2025-01-20', 'Washing Machine','Home Appliances','East', 'Corporate', 1, 28000.00),

-- Books & Stationery
('2025-01-09', 'Novel',         'Books',       'West',    'Returning', 3,    900.00),
('2025-01-16', 'Notebook',      'Stationery',  'South',   'New',       10,   500.00),

-- More mixed rows
('2025-01-22', 'Laptop',        'Electronics', 'South',   'Corporate', 1,  48000.00),
('2025-01-25', 'T-Shirt',       'Clothing',    'North',   'New',       5,   1500.00),
('2025-01-27', 'Mobile',        'Electronics', 'West',    'Returning', 1,  18000.00),
('2025-01-28', 'Jeans',         'Clothing',    'East',    'Corporate', 2,   6000.00),
('2025-02-01', 'Headphones',    'Electronics', 'South',   'New',       4,   7200.00),
('2025-02-03', 'Mixer Grinder', 'Home Appliances', 'West','Returning', 1,  4200.00);