-- ============================================
-- INSERT SAMPLE DATA
-- Simplified with 25+ records
-- ============================================

-- Insert Users (10 records)
INSERT INTO users (email, password_hash, first_name, last_name, phone, date_of_birth, gender, account_status, last_login) VALUES
('john.doe@email.com', 'hash123', 'John', 'Doe', '9876543210', '1990-05-15', 'Male', 'Active', '2026-02-01 10:30:00'),
('jane.smith@email.com', 'hash456', 'Jane', 'Smith', '9876543211', '1988-08-22', 'Female', 'Active', '2026-02-01 14:20:00'),
('raj.kumar@email.com', 'hash789', 'Raj', 'Kumar', '9876543212', '1995-03-10', 'Male', 'Active', '2026-01-31 18:45:00'),
('priya.sharma@email.com', 'hash321', 'Priya', 'Sharma', '9876543213', '1992-11-30', 'Female', 'Active', '2026-02-01 09:15:00'),
('amit.patel@email.com', 'hash654', 'Amit', 'Patel', '9876543214', '1985-07-18', 'Male', 'Active', '2026-01-30 16:00:00'),
('sneha.reddy@email.com', 'hash987', 'Sneha', 'Reddy', '9876543215', '1998-02-14', 'Female', 'Active', '2026-02-01 11:30:00'),
('vikram.singh@email.com', 'hash147', 'Vikram', 'Singh', '9876543216', '1991-09-05', 'Male', 'Active', '2026-01-25 08:00:00'),
('anita.gupta@email.com', 'hash258', 'Anita', 'Gupta', '9876543217', '1994-12-20', 'Female', 'Active', '2026-02-01 15:45:00'),
('rahul.verma@email.com', 'hash369', 'Rahul', 'Verma', '9876543218', '1989-06-25', 'Male', 'Active', '2026-01-31 20:30:00'),
('kavita.joshi@email.com', 'hash741', 'Kavita', 'Joshi', '9876543219', '1996-04-08', 'Female', 'Active', '2026-02-01 12:00:00');

PRINT '10 users inserted';
GO

-- Insert Sellers (5 records)
INSERT INTO sellers (user_id, business_name, business_email, business_phone, seller_rating, is_verified) VALUES
(1, 'TechWorld Electronics', 'contact@techworld.com', '9876543220', 4.5, 1),
(3, 'Fashion Hub India', 'support@fashionhub.in', '9876543221', 4.2, 1),
(5, 'HomeStyle Decor', 'info@homestyle.com', '9876543222', 4.7, 1),
(7, 'Book Paradise', 'hello@bookparadise.in', '9876543223', 4.6, 1),
(9, 'Sports Arena', 'contact@sportsarena.com', '9876543224', 4.3, 0);

PRINT '5 sellers inserted';
GO

-- Insert Addresses (8 records)
INSERT INTO addresses (user_id, address_type, full_name, phone, address_line1, city, state, pincode, is_default) VALUES
(1, 'Home', 'John Doe', '9876543210', '123 MG Road', 'Mumbai', 'Maharashtra', '400001', 1),
(2, 'Home', 'Jane Smith', '9876543211', '789 Brigade Road', 'Bangalore', 'Karnataka', '560001', 1),
(3, 'Home', 'Raj Kumar', '9876543212', '321 Park Street', 'Kolkata', 'West Bengal', '700016', 1),
(4, 'Home', 'Priya Sharma', '9876543213', '654 Connaught Place', 'New Delhi', 'Delhi', '110001', 1),
(6, 'Home', 'Sneha Reddy', '9876543215', '147 Banjara Hills', 'Hyderabad', 'Telangana', '500034', 1),
(8, 'Home', 'Anita Gupta', '9876543217', '258 Civil Lines', 'Pune', 'Maharashtra', '411001', 1),
(10, 'Home', 'Kavita Joshi', '9876543219', '369 Lalbagh Road', 'Bangalore', 'Karnataka', '560027', 1),
(1, 'Work', 'John Doe', '9876543210', '456 Andheri East', 'Mumbai', 'Maharashtra', '400069', 0);

PRINT '8 addresses inserted';
GO

-- Insert Categories (6 records)
INSERT INTO categories (category_name, description, is_active) VALUES
('Electronics', 'Electronic devices and accessories', 1),
('Fashion', 'Clothing and accessories', 1),
('Home & Kitchen', 'Home decor and kitchen items', 1),
('Books', 'Books and educational materials', 1),
('Sports', 'Sports equipment and fitness products', 1),
('Mobile Phones', 'Smartphones and accessories', 1);

PRINT '6 categories inserted';
GO

-- Insert Products (15 records)
INSERT INTO products (seller_id, category_id, product_name, description, brand, price, discount_percentage, is_active, average_rating, total_reviews, image_url) VALUES
(1, 6, 'Samsung Galaxy S24', '5G Smartphone, 256GB, 8GB RAM', 'Samsung', 79999.00, 15.00, 1, 4.5, 150, 'samsung-s24.jpg'),
(1, 6, 'iPhone 15 Pro', 'Apple smartphone, 256GB', 'Apple', 134900.00, 5.00, 1, 4.8, 89, 'iphone-15.jpg'),
(1, 1, 'Dell XPS 13 Laptop', '13.4 inch, Intel i7, 16GB RAM', 'Dell', 124999.00, 10.00, 1, 4.6, 62, 'dell-xps.jpg'),
(1, 1, 'Sony Headphones WH-1000XM5', 'Wireless Noise Cancelling', 'Sony', 29990.00, 20.00, 1, 4.7, 158, 'sony-headphones.jpg'),
(2, 2, 'Levis Men Jeans', 'Slim fit denim, blue, size 32', 'Levis', 2999.00, 30.00, 1, 4.3, 45, 'levis-jeans.jpg'),
(2, 2, 'Nike Air Max Sneakers', 'Running shoes, size 9', 'Nike', 8999.00, 25.00, 1, 4.5, 78, 'nike-shoes.jpg'),
(2, 2, 'Allen Solly Shirt', 'Formal shirt, cotton, blue, L', 'Allen Solly', 1799.00, 40.00, 1, 4.2, 32, 'shirt.jpg'),
(3, 3, 'Prestige Induction Cooktop', '2000W with touch panel', 'Prestige', 3499.00, 15.00, 1, 4.4, 89, 'induction.jpg'),
(3, 3, 'Philips Air Fryer', 'Digital, 4.1L, 1400W', 'Philips', 9999.00, 20.00, 1, 4.6, 112, 'airfryer.jpg'),
(3, 3, 'Havells Table Fan', '400mm high speed', 'Havells', 1899.00, 10.00, 1, 4.1, 56, 'fan.jpg'),
(4, 4, 'The Alchemist', 'Paulo Coelho, paperback', 'HarperCollins', 350.00, 20.00, 1, 4.8, 234, 'alchemist.jpg'),
(4, 4, 'Atomic Habits', 'James Clear, hardcover', 'Penguin', 599.00, 15.00, 1, 4.9, 189, 'atomic-habits.jpg'),
(5, 5, 'Adidas Gym Bag', 'Duffle bag, 50L, black', 'Adidas', 1999.00, 25.00, 1, 4.3, 34, 'gym-bag.jpg'),
(5, 5, 'Cricket Bat', 'Kashmir willow, full size', 'Nivia', 2499.00, 15.00, 1, 4.2, 28, 'cricket-bat.jpg'),
(1, 1, 'JBL Flip 6 Speaker', 'Bluetooth, waterproof', 'JBL', 11999.00, 18.00, 1, 4.5, 67, 'jbl-speaker.jpg');

PRINT '15 products inserted';
GO

-- Insert Inventory (15 records)
INSERT INTO inventory (product_id, quantity, reserved_quantity, warehouse_location, last_restocked) VALUES
(1, 150, 10, 'Mumbai Warehouse', '2026-01-28'),
(2, 80, 5, 'Mumbai Warehouse', '2026-01-25'),
(3, 45, 3, 'Bangalore Warehouse', '2026-01-26'),
(4, 200, 15, 'Delhi Warehouse', '2026-01-29'),
(5, 500, 20, 'Bangalore Warehouse', '2026-01-27'),
(6, 300, 12, 'Mumbai Warehouse', '2026-01-30'),
(7, 450, 18, 'Delhi Warehouse', '2026-01-24'),
(8, 120, 8, 'Hyderabad Warehouse', '2026-01-31'),
(9, 90, 6, 'Kolkata Warehouse', '2026-01-28'),
(10, 250, 10, 'Pune Warehouse', '2026-01-29'),
(11, 1000, 50, 'Delhi Warehouse', '2026-01-20'),
(12, 800, 40, 'Bangalore Warehouse', '2026-01-22'),
(13, 180, 7, 'Mumbai Warehouse', '2026-01-26'),
(14, 220, 9, 'Chennai Warehouse', '2026-01-27'),
(15, 160, 11, 'Delhi Warehouse', '2026-01-30');

PRINT '15 inventory records inserted';
GO

-- Insert Cart Items (6 records)
INSERT INTO cart_items (user_id, product_id, quantity) VALUES
(2, 1, 1),
(2, 4, 1),
(4, 5, 2),
(6, 9, 1),
(8, 11, 3),
(10, 6, 1);

PRINT '6 cart items inserted';
GO

-- Insert Wishlists (8 records)
INSERT INTO wishlists (user_id, product_id) VALUES
(1, 2),
(1, 3),
(2, 6),
(4, 1),
(6, 7),
(6, 8),
(8, 14),
(10, 2);

PRINT '8 wishlist items inserted';
GO

-- Insert Orders (8 records)
INSERT INTO orders (user_id, address_id, order_number, order_status, payment_method, total_amount, order_date, delivered_date) VALUES
(1, 1, 'ORD-2026-001', 'Delivered', 'Credit Card', 68238.82, '2026-01-20 10:30:00', '2026-01-24 15:30:00'),
(2, 2, 'ORD-2026-002', 'Delivered', 'UPI', 22362.56, '2026-01-22 14:15:00', '2026-01-26 18:20:00'),
(3, 3, 'ORD-2026-003', 'Shipped', 'Debit Card', 112499.00, '2026-01-25 09:45:00', NULL),
(4, 4, 'ORD-2026-004', 'Delivered', 'UPI', 1626.82, '2026-01-18 16:20:00', '2026-01-22 14:10:00'),
(6, 5, 'ORD-2026-005', 'Shipped', 'Credit Card', 7999.00, '2026-01-28 11:30:00', NULL),
(8, 6, 'ORD-2026-006', 'Confirmed', 'UPI', 919.82, '2026-01-30 13:45:00', NULL),
(10, 7, 'ORD-2026-007', 'Pending', 'Cash on Delivery', 5763.82, '2026-02-01 10:15:00', NULL),
(1, 8, 'ORD-2026-008', 'Delivered', 'Credit Card', 9839.00, '2026-01-15 12:00:00', '2026-01-19 16:45:00');

PRINT '8 orders inserted';
GO

-- Insert Order Items (12 records)
INSERT INTO order_items (order_id, product_id, quantity, price_per_unit, total_price) VALUES
(1, 1, 1, 67999.00, 67999.00),
(2, 5, 2, 2099.30, 4198.60),
(2, 4, 1, 23992.00, 23992.00),
(3, 3, 1, 112499.00, 112499.00),
(4, 7, 1, 1079.40, 1079.40),
(4, 11, 3, 280.00, 840.00),
(5, 9, 1, 7999.00, 7999.00),
(6, 12, 1, 509.15, 509.15),
(6, 11, 1, 280.00, 280.00),
(7, 6, 1, 6749.00, 6749.00),
(8, 15, 1, 9839.00, 9839.00),
(1, 4, 1, 23992.00, 23992.00);

PRINT '12 order items inserted';
GO

-- Insert Payments (8 records)
INSERT INTO payments (order_id, transaction_id, payment_method, payment_status, amount) VALUES
(1, 'TXN-001', 'Credit Card', 'Success', 68238.82),
(2, 'TXN-002', 'UPI', 'Success', 22362.56),
(3, 'TXN-003', 'Debit Card', 'Success', 112499.00),
(4, 'TXN-004', 'UPI', 'Success', 1626.82),
(5, 'TXN-005', 'Credit Card', 'Success', 7999.00),
(6, 'TXN-006', 'UPI', 'Success', 919.82),
(7, NULL, 'Cash on Delivery', 'Pending', 5763.82),
(8, 'TXN-008', 'Credit Card', 'Success', 9839.00);

PRINT '8 payments inserted';
GO

-- Insert Reviews (10 records)
INSERT INTO reviews (product_id, user_id, order_id, rating, review_title, review_text, helpful_count) VALUES
(1, 1, 1, 5, 'Excellent Phone!', 'Amazing display and battery life. Highly recommended!', 45),
(4, 2, 2, 5, 'Best Noise Cancellation', 'These headphones are incredible. Worth every penny!', 67),
(5, 2, 2, 4, 'Good Quality Jeans', 'Nice fit and comfortable. Good value for money.', 23),
(3, 3, 3, 5, 'Perfect for Work', 'Lightweight and powerful. Best laptop I have owned.', 34),
(7, 4, 4, 4, 'Nice Formal Shirt', 'Good quality fabric. Fits well.', 12),
(11, 4, 4, 5, 'Life-changing Book', 'Must read for everyone. Inspiring!', 89),
(9, 6, 5, 5, 'Best Air Fryer', 'Cooks perfectly with minimal oil. Easy to use.', 56),
(12, 8, 6, 5, 'Transformative Read', 'This book changed my perspective on habits.', 102),
(15, 1, 8, 4, 'Great Sound Quality', 'Portable and loud. Battery lasts long.', 28),
(6, 2, 2, 5, 'Comfortable Shoes', 'Perfect fit. Great cushioning for runs.', 41);

PRINT '10 reviews inserted';
GO

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

PRINT '';
PRINT '=== RECORD COUNT SUMMARY ===';
SELECT 'users' as TableName, COUNT(*) as RecordCount FROM users
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'addresses', COUNT(*) FROM addresses
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL SELECT 'cart_items', COUNT(*) FROM cart_items
UNION ALL SELECT 'wishlists', COUNT(*) FROM wishlists
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'reviews', COUNT(*) FROM reviews;

PRINT '';
PRINT 'All data inserted successfully!';
PRINT 'Total Records: 100+';
GO