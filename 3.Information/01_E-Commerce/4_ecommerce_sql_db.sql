-- =====================================================
-- E-COMMERCE DATABASE SETUP
-- =====================================================

-- Create the database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'ecommerce_practice')
BEGIN
    CREATE DATABASE ecommerce_practice;
END
GO

USE ecommerce_practice;
GO

-- =====================================================
-- TABLE CREATION (SQL Server Compatible)
-- =====================================================

-- 1. USERS TABLE
CREATE TABLE users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    registration_date DATE NOT NULL,
    loyalty_points INT DEFAULT 0,
    -- MS SQL doesn't have ENUM, use CHECK constraints
    account_status VARCHAR(20) DEFAULT 'Active' 
        CHECK (account_status IN ('Active', 'Inactive', 'Suspended')),
    date_of_birth DATE,
    gender VARCHAR(10) 
        CHECK (gender IN ('Male', 'Female', 'Other')),
    last_login DATETIME
);

-- 2. CATEGORIES TABLE
CREATE TABLE categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT,
    commission_rate DECIMAL(5,2),
    is_active BIT DEFAULT 1, -- BOOLEAN is BIT in SQL Server
    created_date DATE,
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
);

-- 3. SELLERS TABLE
CREATE TABLE sellers (
    seller_id INT PRIMARY KEY IDENTITY(1,1),
    seller_name VARCHAR(100) NOT NULL,
    business_name VARCHAR(150),
    email VARCHAR(100) UNIQUE,
    rating DECIMAL(3,2),
    total_sales DECIMAL(15,2) DEFAULT 0,
    city VARCHAR(50),
    state VARCHAR(50),
    join_date DATE,
    is_verified BIT DEFAULT 0,
    seller_status VARCHAR(20) DEFAULT 'Active'
        CHECK (seller_status IN ('Active', 'Inactive', 'Blocked'))
);

-- 4. PRODUCTS TABLE
CREATE TABLE products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    product_name VARCHAR(200) NOT NULL,
    category_id INT,
    seller_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    brand VARCHAR(100),
    rating DECIMAL(3,2),
    launch_date DATE,
    is_available BIT DEFAULT 1,
    weight_kg DECIMAL(6,2),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

-- 5. ORDERS TABLE
CREATE TABLE orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    order_date DATETIME NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) DEFAULT 0,
    payment_method VARCHAR(20)
        CHECK (payment_method IN ('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'COD', 'Wallet')),
    order_status VARCHAR(20)
        CHECK (order_status IN ('Pending', 'Confirmed', 'Shipped', 'Delivered', 'Cancelled', 'Returned')),
    delivery_date DATE,
    shipping_charges DECIMAL(6,2) DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 6. ORDER_ITEMS TABLE
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_applied DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 7. REVIEWS TABLE
CREATE TABLE reviews (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT,
    user_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text NVARCHAR(MAX), -- TEXT is deprecated in MS SQL, use NVARCHAR(MAX)
    review_date DATETIME,
    helpful_count INT DEFAULT 0,
    verified_purchase BIT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 8. ADDRESSES TABLE
CREATE TABLE addresses (
    address_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    address_type VARCHAR(20)
        CHECK (address_type IN ('Home', 'Work', 'Other','Office')),
    street VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10),
    is_default BIT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 9. PAYMENTS TABLE
CREATE TABLE payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT,
    payment_date DATETIME,
    amount DECIMAL(10,2),
    payment_method VARCHAR(20)
        CHECK (payment_method IN ('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'COD', 'Wallet')),
    transaction_status VARCHAR(20)
        CHECK (transaction_status IN ('Pending', 'Success', 'Failed', 'Refunded')),
    transaction_id VARCHAR(100) UNIQUE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 10. WISHLISTS TABLE
CREATE TABLE wishlists (
    wishlist_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    product_id INT,
    added_date DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 11. INVENTORY_LOGS TABLE
CREATE TABLE inventory_logs (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT,
    change_type VARCHAR(20)
        CHECK (change_type IN ('Purchase', 'Sale', 'Return', 'Damage', 'Adjustment')),
    quantity_change INT,
    timestamp DATETIME,
    reason VARCHAR(200),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 12. COUPONS TABLE
CREATE TABLE coupons (
    coupon_id INT PRIMARY KEY IDENTITY(1,1),
    coupon_code VARCHAR(50) UNIQUE NOT NULL,
    discount_type VARCHAR(20)
        CHECK (discount_type IN ('Percentage', 'Fixed')),
    discount_value DECIMAL(10,2),
    valid_from DATE,
    valid_until DATE,
    usage_limit INT,
    times_used INT DEFAULT 0,
    min_order_amount DECIMAL(10,2),
    is_active BIT DEFAULT 1
);
GO

-- =====================================================
-- DATA INSERTION
-- =====================================================

-- USERS DATA (30 records)
INSERT INTO users (username, email, phone, registration_date, loyalty_points, account_status, date_of_birth, gender, last_login) VALUES
('rajesh_kumar', 'rajesh.k@email.com', '9876543210', '2023-01-15', 450, 'Active', '1990-05-20', 'Male', '2024-12-28 10:30:00'),
('priya_sharma', 'priya.s@email.com', '9876543211', '2023-02-20', 890, 'Active', '1992-08-15', 'Female', '2024-12-29 14:20:00'),
('amit_patel', 'amit.p@email.com', '9876543212', '2023-03-10', 120, 'Active', '1988-11-30', 'Male', '2024-12-27 09:15:00'),
('sneha_reddy', 'sneha.r@email.com', '9876543213', '2023-04-05', 670, 'Active', '1995-03-22', 'Female', '2024-12-30 16:45:00'),
('vikram_singh', 'vikram.s@email.com', '9876543214', '2023-05-12', 0, 'Inactive', '1987-07-18', 'Male', '2024-10-15 11:00:00'),
('ananya_mehta', 'ananya.m@email.com', '9876543215', '2023-06-18', 1200, 'Active', '1993-12-10', 'Female', '2024-12-31 08:30:00'),
('karthik_nair', 'karthik.n@email.com', '9876543216', '2023-07-22', 340, 'Active', '1991-09-25', 'Male', '2024-12-29 19:20:00'),
('divya_iyer', 'divya.i@email.com', '9876543217', '2023-08-30', 550, 'Active', '1994-06-14', 'Female', '2024-12-28 13:40:00'),
('arjun_kapoor', 'arjun.k@email.com', '9876543218', '2023-09-14', 0, 'Suspended', '1989-02-08', 'Male', '2024-11-20 15:25:00'),
('pooja_desai', 'pooja.d@email.com', '9876543219', '2023-10-25', 780, 'Active', '1996-04-17', 'Female', '2024-12-30 10:15:00'),
('rahul_verma', 'rahul.v@email.com', '9876543220', '2023-11-08', 290, 'Active', '1990-10-12', 'Male', '2024-12-29 12:30:00'),
('kavya_rao', 'kavya.r@email.com', '9876543221', '2023-12-15', 920, 'Active', '1992-01-28', 'Female', '2024-12-31 09:45:00'),
('sanjay_gupta', 'sanjay.g@email.com', '9876543222', '2024-01-20', 150, 'Active', '1988-08-05', 'Male', '2024-12-27 17:20:00'),
('meera_krishnan', 'meera.k@email.com', '9876543223', '2024-02-10', 430, 'Active', '1994-11-19', 'Female', '2024-12-30 14:55:00'),
('aditya_joshi', 'aditya.j@email.com', '9876543224', '2024-03-05', 680, 'Active', '1991-05-23', 'Male', '2024-12-28 11:10:00'),
('ritu_bansal', 'ritu.b@email.com', '9876543225', '2024-04-12', 0, 'Inactive', '1993-09-30', 'Female', '2024-09-15 10:00:00'),
('nikhil_saxena', 'nikhil.s@email.com', '9876543226', '2024-05-18', 510, 'Active', '1989-12-07', 'Male', '2024-12-29 15:35:00'),
('swati_mishra', 'swati.m@email.com', '9876543227', '2024-06-22', 850, 'Active', '1995-02-14', 'Female', '2024-12-31 13:20:00'),
('varun_malhotra', 'varun.m@email.com', '9876543228', '2024-07-30', 200, 'Active', '1990-07-21', 'Male', '2024-12-27 16:40:00'),
('nisha_agarwal', 'nisha.a@email.com', '9876543229', '2024-08-15', 390, 'Active', '1992-03-16', 'Female', '2024-12-30 09:25:00'),
('harish_pillai', 'harish.p@email.com', '9876543230', '2024-09-10', 720, 'Active', '1988-10-29', 'Male', '2024-12-29 18:15:00'),
('anjali_bose', 'anjali.b@email.com', '9876543231', '2024-10-05', 0, 'Active', '1994-06-11', 'Female', '2024-12-28 12:50:00'),
('rohan_choudhary', 'rohan.c@email.com', '9876543232', '2024-10-20', 160, 'Active', '1991-01-25', 'Male', '2024-12-31 10:40:00'),
('tanvi_shah', 'tanvi.s@email.com', '9876543233', '2024-11-02', 540, 'Active', '1993-08-18', 'Female', '2024-12-30 15:10:00'),
('deepak_yadav', 'deepak.y@email.com', '9876543234', '2024-11-15', 0, 'Suspended', '1989-04-09', 'Male', '2024-12-10 14:30:00'),
('ishita_khanna', 'ishita.k@email.com', '9876543235', '2024-11-28', 310, 'Active', '1995-09-12', 'Female', '2024-12-29 11:45:00'),
('mahesh_pandey', 'mahesh.p@email.com', '9876543236', '2024-12-05', 890, 'Active', '1990-12-03', 'Male', '2024-12-31 16:20:00'),
('sonali_dixit', 'sonali.d@email.com', '9876543237', '2024-12-10', 240, 'Active', '1992-05-27', 'Female', '2024-12-30 13:55:00'),
('gaurav_thakur', 'gaurav.t@email.com', '9876543238', '2024-12-15', 470, 'Active', '1988-11-14', 'Male', '2024-12-29 09:30:00'),
('preeti_sinha', 'preeti.s@email.com', '9876543239', '2024-12-20', 620, 'Active', '1994-02-20', 'Female', '2024-12-31 14:15:00');

-- CATEGORIES DATA (25 records with hierarchy)
INSERT INTO categories (category_name, parent_category_id, commission_rate, is_active, created_date) VALUES
('Electronics', NULL, 5.00, 1, '2023-01-01'),
('Fashion', NULL, 10.00, 1, '2023-01-01'),
('Home & Kitchen', NULL, 8.00, 1, '2023-01-01'),
('Books', NULL, 3.00, 1, '2023-01-01'),
('Sports & Fitness', NULL, 7.00, 1, '2023-01-01'),
('Beauty & Personal Care', NULL, 12.00, 1, '2023-01-01'),
('Toys & Games', NULL, 9.00, 1, '2023-01-01'),
('Automotive', NULL, 6.00, 1, '2023-01-01'),
('Mobile Phones', 1, 4.00, 1, '2023-01-02'),
('Laptops', 1, 4.50, 1, '2023-01-02'),
('Headphones', 1, 6.00, 1, '2023-01-02'),
('Men Clothing', 2, 12.00, 1, '2023-01-02'),
('Women Clothing', 2, 12.00, 1, '2023-01-02'),
('Footwear', 2, 11.00, 1, '2023-01-02'),
('Kitchen Appliances', 3, 7.00, 1, '2023-01-02'),
('Home Decor', 3, 10.00, 1, '2023-01-02'),
('Furniture', 3, 9.00, 1, '2023-01-02'),
('Fiction Books', 4, 2.50, 1, '2023-01-02'),
('Non-Fiction Books', 4, 2.50, 1, '2023-01-02'),
('Gym Equipment', 5, 8.00, 1, '2023-01-02'),
('Sports Wear', 5, 9.00, 1, '2023-01-02'),
('Skincare', 6, 13.00, 1, '2023-01-02'),
('Makeup', 6, 14.00, 1, '2023-01-02'),
('Kids Toys', 7, 10.00, 1, '2023-01-02'),
('Car Accessories', 8, 7.00, 1, '2023-01-02');

-- SELLERS DATA (30 records)
INSERT INTO sellers (seller_name, business_name, email, rating, total_sales, city, state, join_date, is_verified, seller_status) VALUES
('Tech Paradise', 'Tech Paradise Pvt Ltd', 'tech.paradise@seller.com', 4.5, 2500000.00, 'Bangalore', 'Karnataka', '2023-01-10', 1, 'Active'),
('Fashion Hub', 'Fashion Hub India', 'fashion.hub@seller.com', 4.3, 1800000.00, 'Mumbai', 'Maharashtra', '2023-01-15', 1, 'Active'),
('Home Essentials', 'Home Essentials Co', 'home.essentials@seller.com', 4.6, 1200000.00, 'Delhi', 'Delhi', '2023-02-01', 1, 'Active'),
('Book World', 'Book World Store', 'book.world@seller.com', 4.7, 900000.00, 'Kolkata', 'West Bengal', '2023-02-10', 1, 'Active'),
('Sports Arena', 'Sports Arena Mart', 'sports.arena@seller.com', 4.4, 850000.00, 'Pune', 'Maharashtra', '2023-02-20', 1, 'Active'),
('Beauty Bliss', 'Beauty Bliss Retail', 'beauty.bliss@seller.com', 4.8, 1100000.00, 'Chennai', 'Tamil Nadu', '2023-03-01', 1, 'Active'),
('Toy Kingdom', 'Toy Kingdom Store', 'toy.kingdom@seller.com', 4.2, 650000.00, 'Hyderabad', 'Telangana', '2023-03-10', 1, 'Active'),
('Auto Parts Pro', 'Auto Parts Pro India', 'auto.parts@seller.com', 4.1, 720000.00, 'Ahmedabad', 'Gujarat', '2023-03-15', 1, 'Active'),
('Mobile Mania', 'Mobile Mania Store', 'mobile.mania@seller.com', 4.6, 3200000.00, 'Bangalore', 'Karnataka', '2023-04-01', 1, 'Active'),
('Laptop Galaxy', 'Laptop Galaxy Pvt Ltd', 'laptop.galaxy@seller.com', 4.5, 2800000.00, 'Mumbai', 'Maharashtra', '2023-04-10', 1, 'Active'),
('Audio World', 'Audio World Electronics', 'audio.world@seller.com', 4.4, 980000.00, 'Delhi', 'Delhi', '2023-04-20', 1, 'Active'),
('Mens Fashion', 'Mens Fashion Store', 'mens.fashion@seller.com', 4.3, 1350000.00, 'Jaipur', 'Rajasthan', '2023-05-01', 1, 'Active'),
('Womens Wardrobe', 'Womens Wardrobe Co', 'womens.wardrobe@seller.com', 4.7, 1650000.00, 'Lucknow', 'Uttar Pradesh', '2023-05-10', 1, 'Active'),
('Shoe Palace', 'Shoe Palace Retail', 'shoe.palace@seller.com', 4.5, 1120000.00, 'Chandigarh', 'Punjab', '2023-05-20', 1, 'Active'),
('Kitchen Pro', 'Kitchen Pro Appliances', 'kitchen.pro@seller.com', 4.6, 890000.00, 'Kochi', 'Kerala', '2023-06-01', 1, 'Active'),
('Decor Dreams', 'Decor Dreams Store', 'decor.dreams@seller.com', 4.4, 760000.00, 'Indore', 'Madhya Pradesh', '2023-06-10', 1, 'Active'),
('Furniture Factory', 'Furniture Factory India', 'furniture.factory@seller.com', 4.3, 1450000.00, 'Nagpur', 'Maharashtra', '2023-06-20', 1, 'Active'),
('Novel Nook', 'Novel Nook Books', 'novel.nook@seller.com', 4.8, 580000.00, 'Bhopal', 'Madhya Pradesh', '2023-07-01', 1, 'Active'),
('Knowledge Hub', 'Knowledge Hub Publications', 'knowledge.hub@seller.com', 4.7, 620000.00, 'Patna', 'Bihar', '2023-07-10', 1, 'Active'),
('Fitness First', 'Fitness First Equipment', 'fitness.first@seller.com', 4.5, 930000.00, 'Surat', 'Gujarat', '2023-07-20', 1, 'Active'),
('Athletic Gear', 'Athletic Gear Store', 'athletic.gear@seller.com', 4.4, 780000.00, 'Visakhapatnam', 'Andhra Pradesh', '2023-08-01', 1, 'Active'),
('Glow & Grace', 'Glow & Grace Cosmetics', 'glow.grace@seller.com', 4.9, 1280000.00, 'Coimbatore', 'Tamil Nadu', '2023-08-10', 1, 'Active'),
('Makeup Magic', 'Makeup Magic Store', 'makeup.magic@seller.com', 4.7, 1050000.00, 'Vadodara', 'Gujarat', '2023-08-20', 1, 'Active'),
('Happy Kids', 'Happy Kids Toys', 'happy.kids@seller.com', 4.6, 520000.00, 'Ludhiana', 'Punjab', '2023-09-01', 1, 'Active'),
('Car Care Plus', 'Car Care Plus Services', 'car.care@seller.com', 4.2, 690000.00, 'Agra', 'Uttar Pradesh', '2023-09-10', 1, 'Active'),
('Gadget Store', 'Gadget Store India', 'gadget.store@seller.com', 4.4, 1890000.00, 'Nashik', 'Maharashtra', '2023-09-20', 1, 'Active'),
('Style Station', 'Style Station Fashion', 'style.station@seller.com', 4.5, 1420000.00, 'Rajkot', 'Gujarat', '2023-10-01', 1, 'Active'),
('Smart Home', 'Smart Home Solutions', 'smart.home@seller.com', 4.6, 1150000.00, 'Kanpur', 'Uttar Pradesh', '2023-10-10', 1, 'Active'),
('Book Bazaar', 'Book Bazaar Store', 'book.bazaar@seller.com', 4.3, 480000.00, 'Mysore', 'Karnataka', '2023-10-20', 0, 'Active'),
('Quick Electronics', 'Quick Electronics Mart', 'quick.electronics@seller.com', 4.1, 920000.00, 'Guwahati', 'Assam', '2023-11-01', 1, 'Active');

-- PRODUCTS DATA (50 records)
INSERT INTO products (product_name, category_id, seller_id, price, stock, brand, rating, launch_date, is_available, weight_kg) VALUES
('Samsung Galaxy S23', 9, 9, 74999.00, 45, 'Samsung', 4.5, '2023-02-01', 1, 0.17),
('iPhone 14 Pro', 9, 9, 129999.00, 30, 'Apple', 4.8, '2023-09-10', 1, 0.21),
('OnePlus 11', 9, 9, 56999.00, 60, 'OnePlus', 4.4, '2023-02-07', 1, 0.20),
('Dell XPS 15', 10, 10, 145999.00, 25, 'Dell', 4.6, '2023-01-15', 1, 1.80),
('MacBook Air M2', 10, 10, 114900.00, 20, 'Apple', 4.9, '2023-07-12', 1, 1.24),
('HP Pavilion 15', 10, 10, 65999.00, 40, 'HP', 4.3, '2023-03-20', 1, 1.75),
('Sony WH-1000XM5', 11, 11, 29990.00, 80, 'Sony', 4.7, '2023-05-15', 1, 0.25),
('JBL Tune 760NC', 11, 11, 5999.00, 150, 'JBL', 4.2, '2023-02-28', 1, 0.22),
('Boat Airdopes 141', 11, 11, 1299.00, 300, 'Boat', 4.0, '2023-01-10', 1, 0.05),
('Levis Mens Jeans', 12, 12, 2499.00, 200, 'Levis', 4.4, '2023-04-01', 1, 0.60),
('Nike Mens T-Shirt', 12, 12, 1299.00, 250, 'Nike', 4.3, '2023-05-15', 1, 0.20),
('Puma Track Pants', 12, 12, 1799.00, 180, 'Puma', 4.2, '2023-06-10', 1, 0.30),
('Zara Women Dress', 13, 13, 3499.00, 120, 'Zara', 4.5, '2023-03-20', 1, 0.40),
('H&M Women Top', 13, 13, 999.00, 280, 'H&M', 4.1, '2023-07-05', 1, 0.15),
('Forever 21 Skirt', 13, 13, 1599.00, 150, 'Forever 21', 4.3, '2023-08-12', 1, 0.25),
('Adidas Running Shoes', 14, 14, 4999.00, 100, 'Adidas', 4.6, '2023-02-14', 1, 0.65),
('Nike Air Max', 14, 14, 8999.00, 75, 'Nike', 4.7, '2023-04-22', 1, 0.70),
('Puma Casual Sneakers', 14, 14, 3499.00, 130, 'Puma', 4.4, '2023-06-08', 1, 0.60),
('Philips Air Fryer', 15, 15, 7999.00, 50, 'Philips', 4.5, '2023-01-20', 1, 4.20),
('Prestige Mixer Grinder', 15, 15, 3499.00, 90, 'Prestige', 4.3, '2023-03-15', 1, 3.80),
('Butterfly Gas Stove', 15, 15, 2999.00, 70, 'Butterfly', 4.2, '2023-05-10', 1, 5.50),
('Wall Art Canvas', 16, 16, 1999.00, 100, 'HomeArt', 4.1, '2023-02-28', 1, 1.20),
('LED String Lights', 16, 16, 599.00, 250, 'Syska', 4.3, '2023-04-15', 1, 0.35),
('Decorative Cushions', 16, 16, 799.00, 200, 'Urban Living', 4.2, '2023-06-20', 1, 0.50),
('Wooden Study Table', 17, 17, 8999.00, 40, 'Durian', 4.4, '2023-01-25', 1, 18.50),
('Office Chair', 17, 17, 5499.00, 60, 'Green Soul', 4.5, '2023-03-10', 1, 12.00),
('Sofa 3 Seater', 17, 17, 24999.00, 25, 'Godrej Interio', 4.6, '2023-07-18', 1, 65.00),
('The Alchemist', 18, 18, 349.00, 500, 'HarperCollins', 4.8, '2022-01-01', 1, 0.30),
('Atomic Habits', 19, 19, 499.00, 400, 'Penguin', 4.9, '2022-06-15', 1, 0.35),
('Sapiens', 19, 19, 599.00, 350, 'Vintage', 4.7, '2022-03-20', 1, 0.42),
('Dumbbells Set 10kg', 20, 20, 1999.00, 80, 'Kore', 4.4, '2023-02-10', 1, 10.00),
('Yoga Mat', 20, 20, 699.00, 150, 'Strauss', 4.3, '2023-04-05', 1, 1.20),
('Resistance Bands', 20, 20, 499.00, 200, 'Fitsy', 4.2, '2023-06-12', 1, 0.30),
('Nike Dri-Fit Shorts', 21, 21, 1499.00, 180, 'Nike', 4.4, '2023-03-15', 1, 0.18),
('Adidas Sports Bra', 21, 21, 1299.00, 160, 'Adidas', 4.5, '2023-05-20', 1, 0.12),
('Lakme Lipstick', 22, 22, 399.00, 400, 'Lakme', 4.3, '2023-01-15', 1, 0.04),
('Himalaya Face Wash', 22, 22, 175.00, 600, 'Himalaya', 4.4, '2023-02-20', 1, 0.15),
('Nivea Body Lotion', 22, 22, 299.00, 350, 'Nivea', 4.5, '2023-03-25', 1, 0.20),
('Maybelline Mascara', 23, 23, 599.00, 280, 'Maybelline', 4.6, '2023-02-10', 1, 0.03),
('MAC Foundation', 23, 23, 2999.00, 150, 'MAC', 4.8, '2023-04-15', 1, 0.08),
('Lego City Set', 24, 24, 3499.00, 100, 'Lego', 4.7, '2023-01-20', 1, 1.50),
('Hot Wheels Car Pack', 24, 24, 999.00, 300, 'Hot Wheels', 4.4, '2023-03-10', 1, 0.25),
('Barbie Doll', 24, 24, 1299.00, 200, 'Mattel', 4.5, '2023-05-18', 1, 0.40),
('Car Dashboard Camera', 25, 25, 3999.00, 80, 'Qubo', 4.3, '2023-02-15', 1, 0.35),
('Car Seat Covers', 25, 25, 1499.00, 120, 'Elegant', 4.2, '2023-04-20', 1, 1.80),
('Xiaomi Mi 13', 9, 26, 54999.00, 55, 'Xiaomi', 4.4, '2023-12-01', 1, 0.19),
('Realme GT 3', 9, 26, 42999.00, 70, 'Realme', 4.3, '2023-11-15', 1, 0.18),
('Asus ROG Laptop', 10, 10, 125999.00, 15, 'Asus', 4.7, '2023-10-10', 1, 2.40),
('Samsung Galaxy Book', 10, 10, 89999.00, 35, 'Samsung', 4.5, '2023-09-20', 1, 1.55),
('Noise ColorFit Watch', 1, 26, 2499.00, 250, 'Noise', 4.2, '2023-08-15', 1, 0.05);

-- ORDERS DATA (60+ records)
INSERT INTO orders (user_id, order_date, total_amount, discount, payment_method, order_status, delivery_date, shipping_charges) VALUES
(1, '2024-12-01 10:30:00', 75499.00, 500.00, 'Credit Card', 'Delivered', '2024-12-05', 0.00),
(2, '2024-12-02 14:20:00', 5999.00, 0.00, 'UPI', 'Delivered', '2024-12-06', 50.00),
(3, '2024-12-03 09:15:00', 3798.00, 200.00, 'Debit Card', 'Delivered', '2024-12-07', 0.00),
(4, '2024-12-04 16:45:00', 114900.00, 0.00, 'Credit Card', 'Delivered', '2024-12-10', 0.00),
(5, '2024-12-05 11:00:00', 2499.00, 100.00, 'COD', 'Cancelled', NULL, 40.00),
(6, '2024-12-06 08:30:00', 29990.00, 1000.00, 'Net Banking', 'Delivered', '2024-12-11', 0.00),
(7, '2024-12-07 19:20:00', 8999.00, 500.00, 'UPI', 'Delivered', '2024-12-12', 0.00),
(8, '2024-12-08 13:40:00', 12497.00, 1500.00, 'Credit Card', 'Delivered', '2024-12-14', 0.00),
(9, '2024-12-09 15:25:00', 3499.00, 0.00, 'Wallet', 'Returned', '2024-12-13', 40.00),
(10, '2024-12-10 10:15:00', 7999.00, 0.00, 'UPI', 'Delivered', '2024-12-15', 0.00),
(11, '2024-12-11 12:30:00', 948.00, 50.00, 'Debit Card', 'Delivered', '2024-12-16', 60.00),
(12, '2024-12-12 09:45:00', 145999.00, 0.00, 'Credit Card', 'Shipped', NULL, 0.00),
(13, '2024-12-13 17:20:00', 24999.00, 2000.00, 'Net Banking', 'Delivered', '2024-12-20', 200.00),
(14, '2024-12-14 14:55:00', 4999.00, 0.00, 'UPI', 'Delivered', '2024-12-19', 0.00),
(15, '2024-12-15 11:10:00', 1598.00, 100.00, 'COD', 'Delivered', '2024-12-21', 50.00),
(16, '2024-12-16 10:00:00', 599.00, 0.00, 'Wallet', 'Cancelled', NULL, 40.00),
(17, '2024-12-17 15:35:00', 54999.00, 1000.00, 'Credit Card', 'Delivered', '2024-12-22', 0.00),
(18, '2024-12-18 13:20:00', 10497.00, 500.00, 'UPI', 'Delivered', '2024-12-23', 0.00),
(19, '2024-12-19 16:40:00', 3499.00, 0.00, 'Debit Card', 'Delivered', '2024-12-24', 40.00),
(20, '2024-12-20 09:25:00', 2999.00, 0.00, 'Net Banking', 'Delivered', '2024-12-25', 0.00),
(21, '2024-12-21 18:15:00', 129999.00, 0.00, 'Credit Card', 'Confirmed', NULL, 0.00),
(22, '2024-12-22 12:50:00', 8999.00, 1000.00, 'UPI', 'Shipped', NULL, 0.00),
(23, '2024-12-23 10:40:00', 1998.00, 0.00, 'COD', 'Delivered', '2024-12-28', 50.00),
(24, '2024-12-24 15:10:00', 5499.00, 0.00, 'Wallet', 'Delivered', '2024-12-29', 80.00),
(25, '2024-12-25 14:30:00', 699.00, 50.00, 'UPI', 'Pending', NULL, 40.00),
(1, '2024-12-26 11:45:00', 56999.00, 2000.00, 'Credit Card', 'Shipped', NULL, 0.00),
(2, '2024-12-27 16:20:00', 3499.00, 0.00, 'Debit Card', 'Confirmed', NULL, 40.00),
(3, '2024-12-28 13:55:00', 1299.00, 100.00, 'UPI', 'Delivered', '2025-01-02', 40.00),
(4, '2024-12-29 09:30:00', 65999.00, 3000.00, 'Net Banking', 'Pending', NULL, 0.00),
(5, '2024-12-30 14:15:00', 7999.00, 0.00, 'Credit Card', 'Confirmed', NULL, 0.00),
(6, '2024-11-01 10:30:00', 42999.00, 1000.00, 'UPI', 'Delivered', '2024-11-06', 0.00),
(7, '2024-11-05 14:20:00', 1299.00, 0.00, 'COD', 'Delivered', '2024-11-10', 40.00),
(8, '2024-11-10 09:15:00', 89999.00, 4000.00, 'Credit Card', 'Delivered', '2024-11-16', 0.00),
(9, '2024-11-12 16:45:00', 24999.00, 2000.00, 'Net Banking', 'Returned', '2024-11-18', 200.00),
(10, '2024-11-15 11:00:00', 2999.00, 150.00, 'UPI', 'Delivered', '2024-11-20', 0.00),
(11, '2024-11-18 08:30:00', 4999.00, 0.00, 'Debit Card', 'Delivered', '2024-11-23', 0.00),
(12, '2024-11-20 19:20:00', 125999.00, 5000.00, 'Credit Card', 'Delivered', '2024-11-27', 0.00),
(13, '2024-11-22 13:40:00', 1799.00, 100.00, 'Wallet', 'Delivered', '2024-11-27', 40.00),
(14, '2024-11-25 15:25:00', 3499.00, 0.00, 'UPI', 'Delivered', '2024-11-30', 40.00),
(15, '2024-11-28 10:15:00', 8999.00, 1000.00, 'Credit Card', 'Delivered', '2024-12-03', 0.00),
(16, '2024-10-05 12:30:00', 54999.00, 2000.00, 'Net Banking', 'Delivered', '2024-10-10', 0.00),
(17, '2024-10-10 09:45:00', 2499.00, 0.00, 'COD', 'Delivered', '2024-10-15', 40.00),
(18, '2024-10-15 17:20:00', 29990.00, 1500.00, 'Credit Card', 'Delivered', '2024-10-20', 0.00),
(19, '2024-10-20 14:55:00', 7999.00, 0.00, 'UPI', 'Delivered', '2024-10-25', 0.00),
(20, '2024-10-25 11:10:00', 114900.00, 0.00, 'Debit Card', 'Delivered', '2024-10-31', 0.00),
(21, '2024-09-05 10:00:00', 3499.00, 200.00, 'Wallet', 'Delivered', '2024-09-10', 40.00),
(22, '2024-09-10 15:35:00', 5999.00, 0.00, 'UPI', 'Delivered', '2024-09-15', 50.00),
(23, '2024-09-15 13:20:00', 145999.00, 5000.00, 'Credit Card', 'Delivered', '2024-09-22', 0.00),
(24, '2024-09-20 16:40:00', 1299.00, 0.00, 'Net Banking', 'Delivered', '2024-09-25', 40.00),
(25, '2024-09-25 09:25:00', 65999.00, 3000.00, 'Credit Card', 'Delivered', '2024-10-02', 0.00),
(1, '2024-08-10 18:15:00', 8999.00, 500.00, 'UPI', 'Delivered', '2024-08-15', 0.00),
(2, '2024-08-15 12:50:00', 24999.00, 2000.00, 'Debit Card', 'Delivered', '2024-08-22', 200.00),
(3, '2024-08-20 10:40:00', 2999.00, 0.00, 'COD', 'Delivered', '2024-08-25', 0.00),
(4, '2024-08-25 15:10:00', 42999.00, 1000.00, 'Credit Card', 'Delivered', '2024-08-31', 0.00),
(5, '2024-07-05 14:30:00', 129999.00, 0.00, 'Net Banking', 'Delivered', '2024-07-12', 0.00),
(6, '2024-07-10 11:45:00', 4999.00, 250.00, 'UPI', 'Delivered', '2024-07-15', 0.00),
(7, '2024-07-15 16:20:00', 89999.00, 4000.00, 'Credit Card', 'Delivered', '2024-07-22', 0.00),
(8, '2024-07-20 13:55:00', 3499.00, 0.00, 'Wallet', 'Delivered', '2024-07-25', 40.00),
(9, '2024-07-25 09:30:00', 7999.00, 0.00, 'Debit Card', 'Delivered', '2024-07-30', 0.00),
(10, '2024-06-01 14:15:00', 54999.00, 2000.00, 'Credit Card', 'Delivered', '2024-06-07', 0.00);

-- ORDER_ITEMS DATA (100+ records)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_applied) VALUES
(1, 1, 1, 74999.00, 500.00),
(2, 8, 1, 5999.00, 0.00),
(3, 10, 1, 2499.00, 100.00),
(3, 11, 1, 1299.00, 100.00),
(4, 5, 1, 114900.00, 0.00),
(5, 10, 1, 2499.00, 100.00),
(6, 7, 1, 29990.00, 1000.00),
(7, 17, 1, 8999.00, 500.00),
(8, 13, 1, 3499.00, 500.00),
(8, 16, 1, 4999.00, 500.00),
(8, 19, 1, 7999.00, 500.00),
(9, 18, 1, 3499.00, 0.00),
(10, 19, 1, 7999.00, 0.00),
(11, 28, 1, 349.00, 25.00),
(11, 36, 1, 399.00, 25.00),
(11, 37, 1, 175.00, 0.00),
(12, 4, 1, 145999.00, 0.00),
(13, 27, 1, 24999.00, 2000.00),
(14, 16, 1, 4999.00, 0.00),
(15, 14, 1, 999.00, 50.00),
(15, 36, 1, 399.00, 50.00),
(16, 23, 1, 599.00, 0.00),
(17, 46, 1, 54999.00, 1000.00),
(18, 17, 1, 8999.00, 500.00),
(18, 15, 1, 1599.00, 0.00),
(19, 20, 1, 3499.00, 0.00),
(20, 21, 1, 2999.00, 0.00),
(21, 2, 1, 129999.00, 0.00),
(22, 17, 1, 8999.00, 1000.00),
(23, 31, 1, 1999.00, 0.00),
(24, 26, 1, 5499.00, 0.00),
(25, 32, 1, 699.00, 50.00),
(26, 3, 1, 56999.00, 2000.00),
(27, 18, 1, 3499.00, 0.00),
(28, 9, 1, 1299.00, 100.00),
(29, 6, 1, 65999.00, 3000.00),
(30, 19, 1, 7999.00, 0.00),
(31, 47, 1, 42999.00, 1000.00),
(32, 11, 1, 1299.00, 0.00),
(33, 49, 1, 89999.00, 4000.00),
(34, 27, 1, 24999.00, 2000.00),
(35, 40, 1, 2999.00, 150.00),
(36, 16, 1, 4999.00, 0.00),
(37, 48, 1, 125999.00, 5000.00),
(38, 12, 1, 1799.00, 100.00),
(39, 20, 1, 3499.00, 0.00),
(40, 17, 1, 8999.00, 1000.00),
(41, 46, 1, 54999.00, 2000.00),
(42, 10, 1, 2499.00, 0.00),
(43, 7, 1, 29990.00, 1500.00),
(44, 19, 1, 7999.00, 0.00),
(45, 5, 1, 114900.00, 0.00),
(46, 18, 1, 3499.00, 200.00),
(47, 8, 1, 5999.00, 0.00),
(48, 4, 1, 145999.00, 5000.00),
(49, 9, 1, 1299.00, 0.00),
(50, 6, 1, 65999.00, 3000.00),
(51, 17, 1, 8999.00, 500.00),
(52, 27, 1, 24999.00, 2000.00),
(53, 21, 1, 2999.00, 0.00),
(54, 47, 1, 42999.00, 1000.00),
(55, 2, 1, 129999.00, 0.00),
(56, 16, 1, 4999.00, 250.00),
(57, 49, 1, 89999.00, 4000.00),
(58, 18, 1, 3499.00, 0.00),
(59, 19, 1, 7999.00, 0.00),
(60, 46, 1, 54999.00, 2000.00),
(1, 9, 1, 1299.00, 0.00),
(2, 22, 1, 1999.00, 0.00),
(8, 38, 1, 299.00, 0.00),
(11, 30, 1, 599.00, 0.00),
(18, 34, 1, 1499.00, 0.00),
(23, 42, 1, 999.00, 0.00),
(52, 39, 1, 2999.00, 0.00);

-- REVIEWS DATA (80+ records)
INSERT INTO reviews (product_id, user_id, rating, review_text, review_date, helpful_count, verified_purchase) VALUES
(1, 1, 5, 'Excellent phone with amazing camera quality!', '2024-12-06 10:00:00', 15, 1),
(1, 3, 4, 'Good performance but battery could be better', '2024-12-08 14:30:00', 8, 1),
(2, 4, 5, 'Best iPhone ever! Worth every penny', '2024-12-12 11:20:00', 25, 1),
(2, 21, 5, 'Premium build quality and smooth performance', '2024-12-15 16:45:00', 18, 0),
(3, 17, 4, 'Great value for money', '2024-12-23 09:30:00', 12, 1),
(4, 8, 5, 'Perfect laptop for professionals', '2024-12-18 13:40:00', 20, 1),
(4, 12, 5, 'Outstanding display and performance', '2024-12-25 15:20:00', 15, 1),
(5, 10, 5, 'MacBook Air is simply amazing!', '2024-12-16 10:15:00', 30, 1),
(6, 15, 4, 'Good laptop for everyday tasks', '2024-12-22 12:30:00', 10, 1),
(7, 6, 5, 'Best noise cancellation headphones', '2024-12-13 08:45:00', 22, 1),
(7, 18, 5, 'Crystal clear sound quality', '2024-12-20 14:00:00', 18, 1),
(8, 2, 4, 'Good headphones for the price', '2024-12-07 11:30:00', 9, 1),
(9, 11, 3, 'Average sound quality', '2024-12-17 16:20:00', 5, 1),
(10, 13, 4, 'Perfect fit and comfortable', '2024-12-21 10:40:00', 12, 1),
(11, 14, 5, 'Great quality T-shirt', '2024-12-20 09:15:00', 8, 1),
(13, 8, 5, 'Beautiful dress, loved it!', '2024-12-15 14:25:00', 16, 1),
(16, 11, 5, 'Most comfortable shoes ever', '2024-12-24 11:50:00', 20, 1),
(16, 19, 4, 'Good for running', '2024-12-27 15:30:00', 10, 1),
(17, 14, 5, 'Nike never disappoints', '2024-12-20 13:00:00', 18, 1),
(19, 10, 5, 'Best air fryer in market', '2024-12-16 10:30:00', 25, 1),
(19, 22, 4, 'Cooks food evenly', '2024-12-24 12:15:00', 12, 0),
(27, 13, 5, 'Comfortable and sturdy', '2024-12-22 14:45:00', 15, 1),
(28, 23, 5, 'Life-changing book!', '2024-12-29 09:20:00', 35, 1),
(28, 15, 5, 'Must read for everyone', '2024-12-18 11:40:00', 28, 1),
(29, 18, 5, 'Best self-help book', '2024-12-24 13:55:00', 32, 1),
(29, 24, 5, 'Highly recommended!', '2024-12-26 10:25:00', 25, 1),
(30, 19, 5, 'Fascinating read', '2024-12-26 14:30:00', 20, 1),
(31, 20, 4, 'Good quality dumbbells', '2024-12-26 16:10:00', 8, 1),
(46, 6, 4, 'Great phone for the price', '2024-11-12 10:20:00', 15, 1),
(47, 7, 4, 'Fast charging is impressive', '2024-11-16 14:35:00', 10, 1),
(49, 8, 5, 'Excellent laptop', '2024-11-17 11:45:00', 18, 1),
(7, 10, 5, 'Worth the premium price', '2024-11-21 15:20:00', 20, 1),
(17, 11, 5, 'Best running shoes', '2024-11-24 09:30:00', 16, 1),
(27, 9, 3, 'Assembly was difficult', '2024-11-20 13:15:00', 5, 1),
(16, 15, 5, 'Very comfortable', '2024-12-04 10:40:00', 12, 1),
(19, 20, 4, 'Good appliance', '2024-10-26 12:20:00', 8, 1),
(5, 20, 5, 'Perfect for work', '2024-11-02 14:30:00', 22, 1),
(7, 18, 5, 'Amazing noise cancellation', '2024-10-21 11:15:00', 18, 1),
(46, 16, 4, 'Value for money', '2024-10-11 09:45:00', 10, 1),
(2, 5, 5, 'iPhone is the best!', '2024-07-13 10:30:00', 20, 1),
(4, 23, 5, 'Great for coding', '2024-09-23 12:40:00', 15, 1),
(6, 24, 4, 'Good performance', '2024-09-26 14:20:00', 9, 1),
(8, 22, 4, 'Nice sound', '2024-09-11 11:00:00', 7, 1),
(10, 17, 4, 'Good jeans', '2024-10-16 13:30:00', 6, 1),
(13, 18, 5, 'Stylish and comfortable', '2024-10-21 10:50:00', 14, 1),
(16, 14, 5, 'Perfect for gym', '2024-10-26 09:20:00', 11, 1),
(17, 19, 5, 'Love these shoes', '2024-10-26 15:40:00', 13, 1),
(28, 1, 5, 'Beautiful story', '2024-08-16 11:30:00', 30, 1),
(29, 2, 5, 'Changed my life', '2024-08-16 14:00:00', 28, 1),
(30, 3, 5, 'Eye-opening', '2024-08-26 10:15:00', 25, 1),
(47, 4, 4, 'Good budget phone', '2024-09-01 12:45:00', 12, 1),
(1, 10, 4, 'Camera is fantastic', '2024-12-10 16:30:00', 10, 1),
(3, 11, 5, 'Fast and responsive', '2024-12-24 13:15:00', 14, 1),
(5, 12, 5, 'Apple quality', '2024-12-28 11:40:00', 20, 1),
(7, 13, 5, 'Best purchase', '2024-12-14 09:50:00', 19, 1),
(9, 28, 3, 'Okay product', '2024-12-30 14:20:00', 4, 1),
(16, 29, 5, 'Highly recommend', '2024-12-25 10:35:00', 15, 1),
(19, 30, 5, 'Excellent appliance', '2024-12-17 12:00:00', 17, 1),
(27, 1, 4, 'Sturdy table', '2024-12-23 15:10:00', 9, 1),
(28, 2, 5, 'My favorite book', '2024-11-11 11:25:00', 32, 1),
(29, 3, 5, 'Must read', '2024-11-16 13:40:00', 28, 1),
(2, 8, 5, 'iPhone 14 Pro is amazing', '2024-12-19 10:20:00', 22, 0),
(4, 9, 5, 'Best laptop for work', '2024-12-26 14:50:00', 18, 0),
(7, 15, 5, 'Sound quality is top-notch', '2024-12-21 16:15:00', 16, 0),
(16, 20, 5, 'Perfect for daily use', '2024-12-27 09:40:00', 12, 1),
(17, 21, 5, 'Nike quality is unbeatable', '2024-12-28 11:05:00', 14, 0),
(19, 25, 4, 'Good for small families', '2024-12-31 13:30:00', 10, 0),
(28, 26, 5, 'Life lessons in every page', '2024-11-25 15:45:00', 28, 1),
(29, 27, 5, 'Practical and useful', '2024-11-28 10:55:00', 25, 1),
(46, 28, 4, 'Reliable phone', '2024-11-07 12:20:00', 11, 1),
(5, 6, 5, 'MacBook is worth it', '2024-07-16 09:30:00', 24, 1),
(6, 29, 4, 'Decent laptop', '2024-12-05 14:40:00', 8, 0),
(10, 30, 4, 'Good fit', '2024-12-24 11:15:00', 7, 1),
(13, 1, 5, 'Beautiful and elegant', '2024-12-17 13:25:00', 15, 0),
(31, 2, 4, 'Good for home workout', '2024-12-27 10:50:00', 9, 1),
(36, 3, 5, 'Great shade', '2024-12-30 12:35:00', 13, 0),
(37, 4, 5, 'Gentle on skin', '2024-12-29 15:20:00', 11, 0),
(1, 25, 4, 'Battery life is decent', '2024-12-29 17:10:00', 6, 0);

-- ADDRESSES DATA (50+ records)
INSERT INTO addresses (user_id, address_type, street, city, state, pincode, is_default) VALUES
(1, 'Home', '123 MG Road', 'Bangalore', 'Karnataka', '560001', 1),
(1, 'Work', '45 Tech Park', 'Bangalore', 'Karnataka', '560103', 0),
(2, 'Home', '67 Marine Drive', 'Mumbai', 'Maharashtra', '400002', 1),
(3, 'Home', '89 Connaught Place', 'Delhi', 'Delhi', '110001', 1),
(4, 'Home', '234 Anna Salai', 'Chennai', 'Tamil Nadu', '600002', 1),
(5, 'Home', '456 FC Road', 'Pune', 'Maharashtra', '411004', 1),
(6, 'Work', '78 Park Street', 'Kolkata', 'West Bengal', '700016', 1),
(7, 'Home', '90 Banjara Hills', 'Hyderabad', 'Telangana', '500034', 1),
(8, 'Home', '12 Residency Road', 'Bangalore', 'Karnataka', '560025', 1),
(9, 'Home', '34 Carter Road', 'Mumbai', 'Maharashtra', '400050', 1),
(10, 'Home', '56 Nehru Place', 'Delhi', 'Delhi', '110019', 1),
(11, 'Home', '78 MG Road', 'Jaipur', 'Rajasthan', '302001', 1),
(12, 'Home', '90 Hazratganj', 'Lucknow', 'Uttar Pradesh', '226001', 1),
(13, 'Home', '123 Brigade Road', 'Bangalore', 'Karnataka', '560001', 1),
(14, 'Home', '45 T Nagar', 'Chennai', 'Tamil Nadu', '600017', 1),
(15, 'Home', '67 Koramangala', 'Bangalore', 'Karnataka', '560095', 1),
(16, 'Home', '89 Jubilee Hills', 'Hyderabad', 'Telangana', '500033', 1),
(17, 'Home', '12 Civil Lines', 'Jaipur', 'Rajasthan', '302006', 1),
(18, 'Home', '34 MG Road', 'Kochi', 'Kerala', '682016', 1),
(19, 'Home', '56 AB Road', 'Indore', 'Madhya Pradesh', '452001', 1),
(20, 'Home', '78 Sadar', 'Nagpur', 'Maharashtra', '440001', 1),
(21, 'Home', '90 New Market', 'Bhopal', 'Madhya Pradesh', '462001', 1),
(22, 'Home', '123 Boring Road', 'Patna', 'Bihar', '800001', 1),
(23, 'Home', '45 Ring Road', 'Surat', 'Gujarat', '395002', 1),
(24, 'Home', '67 Beach Road', 'Visakhapatnam', 'Andhra Pradesh', '530003', 1),
(25, 'Home', '89 RS Puram', 'Coimbatore', 'Tamil Nadu', '641002', 1),
(26, 'Home', '12 Alkapuri', 'Vadodara', 'Gujarat', '390007', 1),
(27, 'Home', '34 Model Town', 'Ludhiana', 'Punjab', '141002', 1),
(28, 'Home', '56 Taj Ganj', 'Agra', 'Uttar Pradesh', '282001', 1),
(29, 'Home', '78 Gangapur Road', 'Nashik', 'Maharashtra', '422005', 1),
(30, 'Home', '90 Raiya Road', 'Rajkot', 'Gujarat', '360005', 1),
(2, 'Work', '111 Powai', 'Mumbai', 'Maharashtra', '400076', 0),
(3, 'Work', '222 Cyber City', 'Delhi', 'Delhi', '110020', 0),
(4, 'Work', '333 OMR', 'Chennai', 'Tamil Nadu', '600096', 0),
(5, 'Work', '444 Hinjewadi', 'Pune', 'Maharashtra', '411057', 0),
(8, 'Work', '555 Electronic City', 'Bangalore', 'Karnataka', '560100', 0),
(10, 'Work', '666 Sector 62', 'Delhi', 'Delhi', '201301', 0),
(11, 'Office', '777 Vaishali Nagar', 'Jaipur', 'Rajasthan', '302021', 0),
(15, 'Work', '888 Whitefield', 'Bangalore', 'Karnataka', '560066', 0),
(17, 'Office', '999 Mansarovar', 'Jaipur', 'Rajasthan', '302020', 0),
(20, 'Other', '101 Dharampeth', 'Nagpur', 'Maharashtra', '440010', 0),
(22, 'Other', '202 Kankarbagh', 'Patna', 'Bihar', '800020', 0),
(25, 'Work', '303 Peelamedu', 'Coimbatore', 'Tamil Nadu', '641004', 0),
(1, 'Other', '404 Jayanagar', 'Bangalore', 'Karnataka', '560011', 0),
(6, 'Home', '505 Salt Lake', 'Kolkata', 'West Bengal', '700091', 0),
(13, 'Work', '606 Indiranagar', 'Bangalore', 'Karnataka', '560038', 0),
(18, 'Work', '707 Kakkanad', 'Kochi', 'Kerala', '682030', 0),
(23, 'Work', '808 Adajan', 'Surat', 'Gujarat', '395009', 0),
(28, 'Work', '909 Sanjay Place', 'Agra', 'Uttar Pradesh', '282002', 0),
(7, 'Work', '1010 Gachibowli', 'Hyderabad', 'Telangana', '500032', 0),
(14, 'Work', '1111 Velachery', 'Chennai', 'Tamil Nadu', '600042', 0),
(21, 'Other', '1212 MP Nagar', 'Bhopal', 'Madhya Pradesh', '462011', 0);

-- PAYMENTS DATA (55+ records)
INSERT INTO payments (order_id, payment_date, amount, payment_method, transaction_status, transaction_id) VALUES
(1, '2024-12-01 10:35:00', 74999.00, 'Credit Card', 'Success', 'TXN1001'),
(2, '2024-12-02 14:25:00', 6049.00, 'UPI', 'Success', 'TXN1002'),
(3, '2024-12-03 09:20:00', 3798.00, 'Debit Card', 'Success', 'TXN1003'),
(4, '2024-12-04 16:50:00', 114900.00, 'Credit Card', 'Success', 'TXN1004'),
(5, '2024-12-05 11:05:00', 2439.00, 'COD', 'Success', 'TXN1005'),
(6, '2024-12-06 08:35:00', 28990.00, 'Net Banking', 'Success', 'TXN1006'),
(7, '2024-12-07 19:25:00', 8499.00, 'UPI', 'Success', 'TXN1007'),
(8, '2024-12-08 13:45:00', 10997.00, 'Credit Card', 'Success', 'TXN1008'),
(9, '2024-12-09 15:30:00', 3539.00, 'Wallet', 'Refunded', 'TXN1009'),
(10, '2024-12-10 10:20:00', 7999.00, 'UPI', 'Success', 'TXN1010'),
(11, '2024-12-11 12:35:00', 1008.00, 'Debit Card', 'Success', 'TXN1011'),
(12, '2024-12-12 09:50:00', 145999.00, 'Credit Card', 'Success', 'TXN1012'),
(13, '2024-12-13 17:25:00', 23199.00, 'Net Banking', 'Success', 'TXN1013'),
(14, '2024-12-14 15:00:00', 4999.00, 'UPI', 'Success', 'TXN1014'),
(15, '2024-12-15 11:15:00', 1548.00, 'COD', 'Success', 'TXN1015'),
(16, '2024-12-16 10:05:00', 639.00, 'Wallet', 'Failed', 'TXN1016'),
(17, '2024-12-17 15:40:00', 53999.00, 'Credit Card', 'Success', 'TXN1017'),
(18, '2024-12-18 13:25:00', 9997.00, 'UPI', 'Success', 'TXN1018'),
(19, '2024-12-19 16:45:00', 3539.00, 'Debit Card', 'Success', 'TXN1019'),
(20, '2024-12-20 09:30:00', 2999.00, 'Net Banking', 'Success', 'TXN1020'),
(21, '2024-12-21 18:20:00', 129999.00, 'Credit Card', 'Pending', 'TXN1021'),
(22, '2024-12-22 12:55:00', 7999.00, 'UPI', 'Success', 'TXN1022'),
(23, '2024-12-23 10:45:00', 2048.00, 'COD', 'Success', 'TXN1023'),
(24, '2024-12-24 15:15:00', 5579.00, 'Wallet', 'Success', 'TXN1024'),
(25, '2024-12-25 14:35:00', 689.00, 'UPI', 'Pending', 'TXN1025'),
(26, '2024-12-26 11:50:00', 54999.00, 'Credit Card', 'Success', 'TXN1026'),
(27, '2024-12-27 16:25:00', 3539.00, 'Debit Card', 'Pending', 'TXN1027'),
(28, '2024-12-28 14:00:00', 1239.00, 'UPI', 'Success', 'TXN1028'),
(29, '2024-12-29 09:35:00', 62999.00, 'Net Banking', 'Pending', 'TXN1029'),
(30, '2024-12-30 14:20:00', 7999.00, 'Credit Card', 'Pending', 'TXN1030'),
(31, '2024-11-01 10:35:00', 41999.00, 'UPI', 'Success', 'TXN1031'),
(32, '2024-11-05 14:25:00', 1339.00, 'COD', 'Success', 'TXN1032'),
(33, '2024-11-10 09:20:00', 85999.00, 'Credit Card', 'Success', 'TXN1033'),
(34, '2024-11-12 16:50:00', 23199.00, 'Net Banking', 'Refunded', 'TXN1034'),
(35, '2024-11-15 11:05:00', 2849.00, 'UPI', 'Success', 'TXN1035'),
(36, '2024-11-18 08:35:00', 4999.00, 'Debit Card', 'Success', 'TXN1036'),
(37, '2024-11-20 19:25:00', 120999.00, 'Credit Card', 'Success', 'TXN1037'),
(38, '2024-11-22 13:45:00', 1739.00, 'Wallet', 'Success', 'TXN1038'),
(39, '2024-11-25 15:30:00', 3539.00, 'UPI', 'Success', 'TXN1039'),
(40, '2024-11-28 10:20:00', 7999.00, 'Credit Card', 'Success', 'TXN1040'),
(41, '2024-10-05 12:35:00', 52999.00, 'Net Banking', 'Success', 'TXN1041'),
(42, '2024-10-10 09:50:00', 2539.00, 'COD', 'Success', 'TXN1042'),
(43, '2024-10-15 17:25:00', 28490.00, 'Credit Card', 'Success', 'TXN1043'),
(44, '2024-10-20 15:00:00', 7999.00, 'UPI', 'Success', 'TXN1044'),
(45, '2024-10-25 11:15:00', 114900.00, 'Debit Card', 'Success', 'TXN1045'),
(46, '2024-09-05 10:05:00', 3339.00, 'Wallet', 'Success', 'TXN1046'),
(47, '2024-09-10 15:40:00', 6049.00, 'UPI', 'Success', 'TXN1047'),
(48, '2024-09-15 13:25:00', 140999.00, 'Credit Card', 'Success', 'TXN1048'),
(49, '2024-09-20 16:45:00', 1339.00, 'Net Banking', 'Success', 'TXN1049'),
(50, '2024-09-25 09:30:00', 62999.00, 'Credit Card', 'Success', 'TXN1050'),
(51, '2024-08-10 18:20:00', 8499.00, 'UPI', 'Success', 'TXN1051'),
(52, '2024-08-15 12:55:00', 23199.00, 'Debit Card', 'Success', 'TXN1052'),
(53, '2024-08-20 10:45:00', 2999.00, 'COD', 'Success', 'TXN1053'),
(54, '2024-08-25 15:15:00', 41999.00, 'Credit Card', 'Success', 'TXN1054'),
(55, '2024-07-05 14:35:00', 129999.00, 'Net Banking', 'Success', 'TXN1055');

-- WISHLISTS DATA (60+ records)
INSERT INTO wishlists (user_id, product_id, added_date) VALUES
(1, 2, '2024-12-20 10:00:00'),
(1, 5, '2024-12-18 14:30:00'),
(1, 48, '2024-12-15 09:20:00'),
(2, 4, '2024-12-22 11:45:00'),
(2, 27, '2024-12-19 16:10:00'),
(3, 7, '2024-12-21 13:25:00'),
(3, 17, '2024-12-17 10:50:00'),
(4, 49, '2024-12-23 15:30:00'),
(4, 2, '2024-12-16 12:00:00'),
(5, 46, '2024-12-24 09:40:00'),
(6, 1, '2024-12-20 14:15:00'),
(6, 16, '2024-12-18 11:30:00'),
(7, 19, '2024-12-22 16:45:00'),
(8, 13, '2024-12-19 10:20:00'),
(8, 39, '2024-12-17 13:55:00'),
(9, 27, '2024-12-21 15:10:00'),
(10, 7, '2024-12-23 11:25:00'),
(11, 28, '2024-12-20 09:35:00'),
(11, 29, '2024-12-18 14:50:00'),
(12, 4, '2024-12-22 12:15:00'),
(13, 26, '2024-12-19 16:30:00'),
(14, 16, '2024-12-21 10:45:00'),
(15, 10, '2024-12-23 13:20:00'),
(16, 8, '2024-12-20 15:55:00'),
(17, 3, '2024-12-18 11:10:00'),
(18, 49, '2024-12-22 14:25:00'),
(19, 20, '2024-12-19 09:40:00'),
(20, 5, '2024-12-21 12:50:00'),
(21, 2, '2024-12-23 16:05:00'),
(22, 17, '2024-12-20 10:30:00'),
(23, 31, '2024-12-18 13:45:00'),
(24, 32, '2024-12-22 15:15:00'),
(25, 46, '2024-12-19 11:50:00'),
(26, 7, '2024-12-21 14:35:00'),
(27, 13, '2024-12-23 09:20:00'),
(28, 28, '2024-12-20 12:40:00'),
(29, 6, '2024-12-18 16:55:00'),
(30, 19, '2024-12-22 10:15:00'),
(1, 17, '2024-11-15 11:20:00'),
(2, 16, '2024-11-18 14:35:00'),
(3, 46, '2024-11-20 09:50:00'),
(4, 1, '2024-11-22 13:15:00'),
(5, 7, '2024-11-25 16:40:00'),
(6, 49, '2024-11-28 10:25:00'),
(7, 27, '2024-12-01 14:50:00'),
(8, 5, '2024-12-03 11:30:00'),
(9, 4, '2024-12-05 15:45:00'),
(10, 19, '2024-12-07 09:55:00'),
(11, 2, '2024-12-09 13:10:00'),
(12, 48, '2024-12-11 16:25:00'),
(13, 17, '2024-12-13 10:40:00'),
(14, 31, '2024-12-15 14:55:00'),
(15, 7, '2024-12-17 11:15:00'),
(16, 46, '2024-12-19 15:30:00'),
(17, 13, '2024-12-21 09:45:00'),
(18, 28, '2024-12-23 13:00:00'),
(19, 49, '2024-12-25 16:20:00'),
(20, 2, '2024-12-27 10:35:00'),
(21, 5, '2024-12-29 14:50:00'),
(22, 27, '2024-12-31 11:05:00'),
(3, 19, '2024-10-10 12:30:00'),
(4, 32, '2024-10-15 15:45:00'),
(5, 16, '2024-10-20 09:20:00');

-- INVENTORY_LOGS DATA (80+ records)
INSERT INTO inventory_logs (product_id, change_type, quantity_change, timestamp, reason) VALUES
(1, 'Purchase', 100, '2024-11-01 09:00:00', 'New stock arrival'),
(1, 'Sale', -1, '2024-12-01 10:30:00', 'Order #1'),
(1, 'Sale', -1, '2024-12-10 16:30:00', 'Order placed'),
(2, 'Purchase', 50, '2024-11-01 09:00:00', 'New stock arrival'),
(2, 'Sale', -1, '2024-12-04 16:45:00', 'Order #4'),
(2, 'Sale', -1, '2024-12-21 18:15:00', 'Order #21'),
(3, 'Purchase', 80, '2024-11-15 10:00:00', 'Restock'),
(3, 'Sale', -1, '2024-12-26 11:45:00', 'Order #26'),
(4, 'Purchase', 40, '2024-10-01 09:00:00', 'New stock arrival'),
(4, 'Sale', -1, '2024-12-12 09:45:00', 'Order #12'),
(4, 'Sale', -1, '2024-09-15 13:20:00', 'Order placed'),
(5, 'Purchase', 35, '2024-10-15 09:00:00', 'New stock arrival'),
(5, 'Sale', -1, '2024-12-04 16:45:00', 'Order #4'),
(5, 'Sale', -1, '2024-10-25 11:10:00', 'Order #45'),
(6, 'Purchase', 60, '2024-11-01 09:00:00', 'New stock arrival'),
(6, 'Sale', -1, '2024-12-29 09:30:00', 'Order #29'),
(6, 'Sale', -1, '2024-09-25 09:25:00', 'Order placed'),
(7, 'Purchase', 100, '2024-10-01 09:00:00', 'New stock arrival'),
(7, 'Sale', -1, '2024-12-06 08:30:00', 'Order #6'),
(7, 'Sale', -1, '2024-10-15 17:20:00', 'Order #43'),
(8, 'Purchase', 200, '2024-11-01 09:00:00', 'New stock arrival'),
(8, 'Sale', -1, '2024-12-02 14:20:00', 'Order #2'),
(8, 'Sale', -1, '2024-09-10 15:35:00', 'Order placed'),
(9, 'Purchase', 350, '2024-10-01 09:00:00', 'Bulk purchase'),
(9, 'Sale', -1, '2024-12-28 13:55:00', 'Order #28'),
(9, 'Sale', -1, '2024-09-20 16:40:00', 'Order placed'),
(10, 'Purchase', 250, '2024-11-01 09:00:00', 'New stock arrival'),
(10, 'Sale', -1, '2024-12-03 09:15:00', 'Order #3'),
(10, 'Sale', -1, '2024-12-05 11:00:00', 'Order #5 (Cancelled)'),
(10, 'Return', 1, '2024-12-06 14:00:00', 'Order #5 cancellation'),
(10, 'Sale', -1, '2024-10-10 09:45:00', 'Order placed'),
(11, 'Purchase', 300, '2024-10-01 09:00:00', 'New stock arrival'),
(11, 'Sale', -1, '2024-12-03 09:15:00', 'Order #3'),
(11, 'Sale', -1, '2024-11-05 14:20:00', 'Order #32'),
(13, 'Purchase', 150, '2024-11-01 09:00:00', 'New stock arrival'),
(13, 'Sale', -1, '2024-12-08 13:40:00', 'Order #8'),
(16, 'Purchase', 120, '2024-10-15 09:00:00', 'New stock arrival'),
(16, 'Sale', -1, '2024-12-14 14:55:00', 'Order #14'),
(16, 'Sale', -1, '2024-12-08 13:40:00', 'Order #8'),
(16, 'Sale', -1, '2024-11-18 08:30:00', 'Order #36'),
(16, 'Sale', -1, '2024-07-10 11:45:00', 'Order placed'),
(17, 'Purchase', 100, '2024-10-01 09:00:00', 'New stock arrival'),
(17, 'Sale', -1, '2024-12-07 19:20:00', 'Order #7'),
(17, 'Sale', -1, '2024-12-18 13:20:00', 'Order #18'),
(17, 'Sale', -1, '2024-12-22 12:50:00', 'Order #22'),
(17, 'Sale', -1, '2024-11-28 10:15:00', 'Order #40'),
(17, 'Sale', -1, '2024-08-10 18:15:00', 'Order placed'),
(18, 'Purchase', 140, '2024-10-15 09:00:00', 'New stock arrival'),
(18, 'Sale', -1, '2024-12-09 15:25:00', 'Order #9 (Returned)'),
(18, 'Return', 1, '2024-12-14 10:00:00', 'Order #9 return'),
(18, 'Sale', -1, '2024-12-27 16:20:00', 'Order #27'),
(18, 'Sale', -1, '2024-09-05 10:00:00', 'Order placed'),
(18, 'Sale', -1, '2024-07-20 13:55:00', 'Order placed'),
(19, 'Purchase', 70, '2024-10-01 09:00:00', 'New stock arrival'),
(19, 'Sale', -1, '2024-12-10 10:15:00', 'Order #10'),
(19, 'Sale', -1, '2024-12-08 13:40:00', 'Order #8'),
(19, 'Sale', -1, '2024-12-30 14:15:00', 'Order #30'),
(19, 'Sale', -1, '2024-10-20 14:55:00', 'Order #44'),
(19, 'Sale', -1, '2024-07-25 09:30:00', 'Order placed'),
(20, 'Purchase', 100, '2024-11-01 09:00:00', 'New stock arrival'),
(20, 'Sale', -1, '2024-12-19 16:40:00', 'Order #19'),
(20, 'Sale', -1, '2024-11-25 15:25:00', 'Order #39'),
(21, 'Purchase', 90, '2024-10-15 09:00:00', 'New stock arrival'),
(21, 'Sale', -1, '2024-12-20 09:25:00', 'Order #20'),
(21, 'Sale', -1, '2024-08-20 10:40:00', 'Order placed'),
(27, 'Purchase', 50, '2024-10-01 09:00:00', 'New stock arrival'),
(27, 'Sale', -1, '2024-12-13 17:20:00', 'Order #13'),
(27, 'Sale', -1, '2024-11-12 16:45:00', 'Order #34 (Returned)'),
(27, 'Return', 1, '2024-11-19 11:00:00', 'Order #34 return'),
(27, 'Sale', -1, '2024-08-15 12:50:00', 'Order placed'),
(28, 'Purchase', 600, '2024-09-01 09:00:00', 'Large stock'),
(28, 'Sale', -1, '2024-12-11 12:30:00', 'Order #11'),
(29, 'Purchase', 500, '2024-09-01 09:00:00', 'Large stock'),
(30, 'Purchase', 450, '2024-09-01 09:00:00', 'Large stock'),
(31, 'Purchase', 100, '2024-10-15 09:00:00', 'New stock arrival'),
(31, 'Sale', -1, '2024-12-23 10:40:00', 'Order #23'),
(36, 'Purchase', 500, '2024-10-01 09:00:00', 'Cosmetics stock'),
(36, 'Sale', -1, '2024-12-11 12:30:00', 'Order #11'),
(37, 'Purchase', 700, '2024-10-01 09:00:00', 'Cosmetics stock'),
(37, 'Sale', -1, '2024-12-11 12:30:00', 'Order #11');

-- COUPONS DATA (25 records)
INSERT INTO coupons (coupon_code, discount_type, discount_value, valid_from, valid_until, usage_limit, times_used, min_order_amount, is_active) VALUES
('WELCOME10', 'Percentage', 10.00, '2024-01-01', '2024-12-31', 1000, 245, 500.00, 1),
('SAVE500', 'Fixed', 500.00, '2024-01-01', '2024-12-31', 500, 123, 2000.00, 1),
('FESTIVE20', 'Percentage', 20.00, '2024-10-01', '2025-01-15', 2000, 567, 1000.00, 1),
('MOBILE15', 'Percentage', 15.00, '2024-11-01', '2025-01-31', 300, 89, 5000.00, 1),
('LAPTOP1000', 'Fixed', 1000.00, '2024-12-01', '2025-02-28', 200, 45, 50000.00, 1),
('FASHION25', 'Percentage', 25.00, '2024-11-15', '2025-01-31', 1500, 334, 1500.00, 1),
('ELECTRONICS500', 'Fixed', 500.00, '2024-12-10', '2025-01-10', 400, 98, 10000.00, 1),
('NEWYEAR30', 'Percentage', 30.00, '2024-12-25', '2025-01-05', 1000, 278, 2000.00, 1),
('BOOKS5', 'Percentage', 5.00, '2024-01-01', '2024-12-31', 2000, 456, 200.00, 1),
('FITNESS100', 'Fixed', 100.00, '2024-11-01', '2025-03-31', 500, 67, 1000.00, 1),
('BEAUTY15', 'Percentage', 15.00, '2024-10-01', '2025-01-31', 800, 189, 800.00, 1),
('FIRSTORDER', 'Percentage', 15.00, '2024-01-01', '2024-12-31', 5000, 1234, 500.00, 1),
('MEGA50', 'Percentage', 50.00, '2024-12-01', '2024-12-31', 100, 78, 5000.00, 0),
('WEEKEND200', 'Fixed', 200.00, '2024-11-01', '2025-01-31', 600, 234, 1500.00, 1),
('CLEARANCE40', 'Percentage', 40.00, '2024-12-15', '2025-01-15', 300, 145, 3000.00, 1),
('LOYALTY500', 'Fixed', 500.00, '2024-01-01', '2024-12-31', 200, 156, 10000.00, 1),
('APP20', 'Percentage', 20.00, '2024-09-01', '2025-03-31', 2000, 678, 1000.00, 1),
('REFER300', 'Fixed', 300.00, '2024-01-01', '2024-12-31', 1000, 445, 2000.00, 1),
('SUMMER25', 'Percentage', 25.00, '2024-04-01', '2024-08-31', 1500, 1234, 1500.00, 0),
('WINTER30', 'Percentage', 30.00, '2024-12-01', '2025-02-28', 1000, 389, 2000.00, 1),
('FLASHSALE', 'Percentage', 35.00, '2024-12-20', '2024-12-25', 500, 456, 2500.00, 0),
('BANKOFF10', 'Percentage', 10.00, '2024-11-01', '2025-01-31', 3000, 890, 1000.00, 1),
('PREMIUM15', 'Percentage', 15.00, '2024-01-01', '2024-12-31', 500, 234, 5000.00, 1),
('UPISAVE100', 'Fixed', 100.00, '2024-10-01', '2025-03-31', 2000, 567, 500.00, 1),
('SUPERSAVER', 'Percentage', 12.00, '2024-01-01', '2024-12-31', 10000, 3456, 800.00, 1);

-- =====================================================
-- SQL PRACTICE QUESTIONS
-- =====================================================

/*
=============================================================================
                        BEGINNER LEVEL QUESTIONS
=============================================================================

-----------------------------------------------------------------------------
TOPIC 1: QUERY DATA (SELECT)
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q1: Display all columns from the users table
-- Expected: All user information with 30 rows

-- Q2: Show only product_name and price from products table
-- Expected: 50 product names with their prices

-- Q3: List all unique cities from the sellers table
-- Expected: Distinct cities where sellers are located

-- Q4: Display user_id, username and email from users table
-- Expected: Basic user contact information

-- Q5: Show all order statuses from orders table without duplicates
-- Expected: Unique order statuses (Pending, Confirmed, Shipped, etc.)

-- Q6: Calculate price after 10% discount for all products (display product_name, price, discounted_price)
-- Expected: Products with original and discounted prices

-- Q7: Display product names in UPPERCASE from products table
-- Expected: All product names in capital letters

-- Q8: Show seller names with alias 'Seller Name' and cities with alias 'Location'
-- Expected: Formatted seller information with custom column names


/*
MEDIUM QUESTIONS:
*/

-- Q9: Calculate total price (quantity * unit_price) for each order item
-- Expected: Order items with calculated total amount

-- Q10: Display products with their price in rupees and price in dollars (assume 1 USD = 83 INR)
-- Expected: Products showing prices in both currencies

-- Q11: Show user registration year from registration_date
-- Expected: Users with the year they registered

-- Q12: Calculate GST amount (18% of price) for all products
-- Expected: Products with GST amount

-- Q13: Display order_id with 'ORD-' prefix for all orders
-- Expected: Formatted order IDs like ORD-1, ORD-2, etc.


/*
HARD QUESTIONS:
*/

-- Q14: Calculate the age of each user based on date_of_birth (as of 2024-12-31)
-- Hint: Use TIMESTAMPDIFF or YEAR function
-- Expected: Users with their calculated age

-- Q15: Display products with price category: 'Budget' (<5000), 'Mid-Range' (5000-50000), 'Premium' (>50000)
-- Hint: Use CASE statement
-- Expected: Products categorized by price range

-- Q16: Show order_date formatted as 'DD-Mon-YYYY' (e.g., '15-Dec-2024')
-- Expected: Orders with formatted dates


/*
-----------------------------------------------------------------------------
TOPIC 2: DDL COMMANDS (CREATE, ALTER, DROP)
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q17: Create a new table 'order_tracking' with columns: tracking_id (INT, PRIMARY KEY), order_id (INT), current_location (VARCHAR), update_time (DATETIME)

-- Q18: Add a new column 'middle_name' (VARCHAR 50) to users table

-- Q19: Create a table 'return_requests' with: request_id (INT, AUTO_INCREMENT, PRIMARY KEY), order_id (INT), reason (TEXT), request_date (DATE)

-- Q20: Modify the 'phone' column in users table to VARCHAR(20)

-- Q21: Add a column 'description' (TEXT) to products table

-- Q22: Create an index on email column in users table


/*
MEDIUM QUESTIONS:
*/

-- Q23: Create table 'seller_ratings_monthly' with seller_id, month, year, avg_rating, total_orders

-- Q24: Add a foreign key constraint on order_tracking linking order_id to orders table

-- Q25: Add a CHECK constraint on reviews table ensuring rating is between 1 and 5

-- Q26: Create a table 'abandoned_carts' to track items users added but didn't purchase


/*
HARD QUESTIONS:
*/

-- Q27: Create a comprehensive 'product_price_history' table to track all price changes with timestamp, old_price, new_price

-- Q28: Alter the products table to add multiple columns: warranty_months (INT), return_policy_days (INT), in_stock_since (DATE)

-- Q29: Create a table 'flash_sales' with start_time, end_time, product_id, discount_percent, and appropriate constraints


/*
-----------------------------------------------------------------------------
TOPIC 3: DML COMMANDS (INSERT, UPDATE, DELETE)
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q30: Insert a new user with username 'test_user', email 'test@email.com', registration_date as today

-- Q31: Update the stock of product_id 1 to 50

-- Q32: Delete all orders with status 'Cancelled'

-- Q33: Update loyalty_points to 1000 for user_id 1

-- Q34: Insert a new category 'Smart Home' with commission_rate 8.5

-- Q35: Update the rating of seller_id 5 to 4.8


/*
MEDIUM QUESTIONS:
*/

-- Q36: Update all products' prices by increasing them by 5% for category_id 9 (Mobile Phones)

-- Q37: Insert 3 new products for seller_id 10 in one query

-- Q38: Update order_status to 'Delivered' for all orders where delivery_date is not NULL and status is 'Shipped'

-- Q39: Delete all wishlists for products that are not available (is_available = 0)

-- Q40: Update account_status to 'Inactive' for users who haven't logged in since '2024-10-01'


/*
HARD QUESTIONS:
*/

-- Q41: Update total_sales for all sellers based on their actual delivered order amounts
-- Hint: Use JOIN with orders and order_items

-- Q42: Insert new inventory logs for all products that have stock below 50, marking them as 'Low Stock Alert'

-- Q43: Update product ratings based on average rating from reviews table (only for products with 5+ reviews)


/*
=============================================================================
                        INTERMEDIATE LEVEL QUESTIONS
=============================================================================

-----------------------------------------------------------------------------
TOPIC 4: FILTERING DATA (WHERE, AND, OR, BETWEEN, IN, LIKE)
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q44: Find all active users
-- Expected: Users with account_status = 'Active'

-- Q45: Show products priced below 5000
-- Expected: Budget-friendly products

-- Q46: Display orders placed in December 2024
-- Expected: All December orders

-- Q47: Find products from brand 'Samsung'
-- Expected: Samsung products only

-- Q48: Show users registered in 2024
-- Expected: New users from current year

-- Q49: Find all sellers from 'Karnataka' state
-- Expected: Karnataka-based sellers

-- Q50: Display products that are currently unavailable
-- Expected: Products with is_available = 0


/*
MEDIUM QUESTIONS:
*/

-- Q51: Find products priced between 10000 and 50000
-- Expected: Mid-range products

-- Q52: Show orders with payment method 'UPI' or 'Credit Card' and status 'Delivered'
-- Expected: Successful online payments

-- Q53: Find users whose email contains 'gmail.com'
-- Expected: Gmail users

-- Q54: Display products from categories 9, 10, or 11 (Electronics)
-- Expected: Electronic items

-- Q55: Find sellers with rating greater than 4.5 and total_sales greater than 1000000
-- Expected: Top-performing sellers

-- Q56: Show orders where discount is greater than 1000 or total_amount is greater than 100000
-- Expected: High-value or discounted orders

-- Q57: Find products whose name starts with 'Samsung' or 'Apple'
-- Expected: Premium brand products

-- Q58: Display users who registered between '2024-06-01' and '2024-12-31'
-- Expected: Recent registered users (last 6 months)


/*
HARD QUESTIONS:
*/

-- Q59: Find products that have stock less than 50 AND (price > 50000 OR brand IN ('Apple', 'Samsung'))
-- Expected: Low stock premium products

-- Q60: Show orders where order_status is 'Delivered' AND delivery was completed within 5 days of order_date
-- Expected: Fast deliveries

-- Q61: Find users who have loyalty_points between 500 and 1000 AND registered before '2024-06-01' AND account_status is 'Active'
-- Expected: Loyal active users with moderate points

-- Q62: Display products where brand contains 'Nike' or 'Adidas' AND price < 5000 AND stock > 100
-- Expected: Popular sports brand budget items with good stock


/*
-----------------------------------------------------------------------------
TOPIC 5: SQL JOINS (BASICS) - INNER, LEFT, RIGHT
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q63: Display product names with their category names
-- Expected: Products joined with categories

-- Q64: Show order details with customer names
-- Expected: Orders with user information

-- Q65: List products with their seller names
-- Expected: Products and their sellers

-- Q66: Display orders with their payment information
-- Expected: Orders joined with payments table

-- Q67: Show reviews with product names
-- Expected: Reviews with corresponding product details


/*
MEDIUM QUESTIONS:
*/

-- Q68: Display all orders with username, product names, and quantities
-- Hint: Join orders, order_items, products, and users

-- Q69: Show products that have never been ordered (use LEFT JOIN)
-- Expected: Products not in order_items

-- Q70: List all users and their total number of orders (including users with 0 orders)
-- Hint: Use LEFT JOIN and COUNT

-- Q71: Display sellers with their products count (including sellers with no products)
-- Expected: Seller names with product counts

-- Q72: Show all categories with their product count and average product price
-- Expected: Categories with aggregated product data


/*
HARD QUESTIONS:
*/

-- Q73: Display complete order details: order_id, order_date, username, user_email, product_name, quantity, seller_name
-- Hint: Join 5 tables

-- Q74: Find users who have added products to wishlist but never ordered them
-- Hint: Use LEFT JOIN between wishlists and order_items

-- Q75: Show products with their review count and average rating (including products with no reviews)
-- Expected: All products with review statistics


/*
-----------------------------------------------------------------------------
TOPIC 6: SQL JOINS (ADVANCED) - FULL OUTER, CROSS, SELF, MULTIPLE TABLES
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q76: Create a combination of all users with all products using CROSS JOIN (limit to 10 results)
-- Expected: User-Product combinations

-- Q77: Find categories and their parent category names using SELF JOIN
-- Expected: Category hierarchy

-- Q78: Display all products and their orders using FULL OUTER JOIN (show products never ordered and orders if any)
-- Note: MySQL doesn't support FULL OUTER JOIN directly, use UNION of LEFT and RIGHT JOIN


/*
MEDIUM QUESTIONS:
*/

-- Q79: Find users who have both ordered and reviewed products
-- Hint: Join users with orders and reviews

-- Q80: Display sellers along with their products and the orders for those products
-- Hint: Join sellers, products, order_items

-- Q81: Show categories with their subcategories (parent-child relationship)
-- Hint: SELF JOIN on categories table

-- Q82: Find products that are in wishlists but have never been purchased
-- Hint: Join wishlists with order_items using appropriate joins


/*
HARD QUESTIONS:
*/

-- Q83: Display complete e-commerce flow: User → Order → Order Items → Product → Seller → Category
-- Show: username, order_date, product_name, seller_name, category_name
-- Hint: Join 6 tables

-- Q84: Find users who have placed orders, added reviews, and have items in wishlist
-- Hint: Join users with orders, reviews, and wishlists

-- Q85: Create a product recommendation matrix: show products frequently bought together
-- Hint: Self join on order_items to find products in same orders


/*
-----------------------------------------------------------------------------
TOPIC 7: SET OPERATORS (UNION, INTERSECT, EXCEPT)
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q86: Get a list of all unique cities from both users' addresses and sellers
-- Hint: Use UNION

-- Q87: Find common payment methods used in both orders and payments tables
-- Hint: Use INTERSECT (or INNER JOIN with DISTINCT)

-- Q88: List all product IDs from products table and wishlist table combined
-- Expected: Union of product IDs


/*
MEDIUM QUESTIONS:
*/

-- Q89: Find users who have either placed orders OR added items to wishlist (or both)
-- Hint: UNION user_ids from orders and wishlists

-- Q90: Get products that are either low in stock (< 30) OR have high rating (> 4.5)
-- Hint: Use UNION of two SELECT queries

-- Q91: Find email addresses that exist in both users and sellers tables
-- Hint: INTERSECT or INNER JOIN


/*
HARD QUESTIONS:
*/

-- Q92: Find products that are in wishlist but NOT in order_items (never purchased)
-- Hint: Use EXCEPT or LEFT JOIN with NULL check

-- Q93: Get list of users who have registered in 2024 but haven't placed any orders
-- Hint: EXCEPT or NOT EXISTS

-- Q94: Find sellers who have products listed but no products have been ordered
-- Hint: Complex query with EXCEPT or NOT IN


/*
=============================================================================
                        ADVANCED LEVEL QUESTIONS
=============================================================================

-----------------------------------------------------------------------------
TOPIC 8: STRING FUNCTIONS
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q95: Display first name from username (before underscore) for all users
-- Hint: Use SUBSTRING_INDEX or LEFT

-- Q96: Show product names with their character length
-- Expected: Product names with LENGTH

-- Q97: Convert all seller names to UPPER CASE
-- Expected: Uppercase seller names

-- Q98: Display user emails with domain part only (after @)
-- Hint: Use SUBSTRING_INDEX

-- Q99: Show product names with first 20 characters only
-- Hint: Use LEFT or SUBSTRING


/*
MEDIUM QUESTIONS:
*/

-- Q100: Create full name by combining first and last names from username (replace underscore with space)
-- Hint: Use REPLACE function

-- Q101: Display products with brand name in uppercase and product name in title case
-- Expected: Formatted product information

-- Q102: Extract pincode's first 3 digits from addresses
-- Hint: Use LEFT function

-- Q103: Find users whose username contains exactly 2 underscores
-- Hint: Use LENGTH and REPLACE

-- Q104: Format phone numbers as '+91-XXXXX-XXXXX'
-- Hint: Use CONCAT and SUBSTRING


/*
HARD QUESTIONS:
*/

-- Q105: Create email IDs for sellers from their business_name (remove spaces, lowercase, add @seller.com)
-- Hint: LOWER, REPLACE, CONCAT

-- Q106: Extract product category from product_name if it contains brand name (first word)
-- Hint: SUBSTRING_INDEX with complex logic

-- Q107: Format addresses as 'Street, City - Pincode, State' in single column
-- Hint: Multiple CONCAT operations


/*
-----------------------------------------------------------------------------
TOPIC 9: NUMERIC FUNCTIONS
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q108: Round all product prices to nearest 100
-- Expected: Rounded prices

-- Q109: Calculate absolute difference between total_amount and (total_amount - discount) for orders
-- Expected: Orders with discount amounts

-- Q110: Show products with price rounded to nearest 10
-- Expected: Rounded product prices


/*
MEDIUM QUESTIONS:
*/

-- Q111: Calculate ceiling and floor values of average product ratings
-- Expected: Products with CEIL and FLOOR of ratings

-- Q112: Display orders with total_amount, discount, and final_amount (total - discount) rounded to 2 decimals
-- Expected: Order financial details

-- Q113: Calculate square root of loyalty_points for users
-- Hint: Use SQRT or POWER

-- Q114: Find products where price MOD 1000 = 0 (prices in exact thousands)
-- Expected: Products with round thousand prices


/*
HARD QUESTIONS:
*/

-- Q115: Calculate EMI for products > 50000 (12 months @ 12% annual interest)
-- Hint: Monthly EMI = [P x R x (1+R)^N]/[(1+R)^N-1] where P=Principal, R=Monthly Rate, N=Months
-- Simple version: (Price * 1.12) / 12

-- Q116: Calculate compound interest on order amounts if invested for 1 year at 8% p.a.
-- Formula: A = P(1 + r)^t where A=final amount, P=principal, r=rate, t=time

-- Q117: Generate random discount between 5% and 20% for all products
-- Hint: Use RAND() function


/*
-----------------------------------------------------------------------------
TOPIC 10: DATE AND TIME FUNCTIONS
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q118: Display current date and time
-- Expected: NOW() output

-- Q119: Show order_date with only date part (no time)
-- Hint: Use DATE function

-- Q120: Extract year from user registration_date
-- Expected: Registration years

-- Q121: Display month name from order_date
-- Hint: Use MONTHNAME function

-- Q122: Show days between order_date and delivery_date
-- Hint: Use DATEDIFF


/*
MEDIUM QUESTIONS:
*/

-- Q123: Find orders placed in last 30 days
-- Hint: Use DATE_SUB and CURDATE()

-- Q124: Display users' account age in months since registration
-- Hint: TIMESTAMPDIFF in MONTHS

-- Q125: Show orders with day of week when they were placed
-- Hint: DAYNAME function

-- Q126: Find products launched in last 6 months
-- Expected: Recently launched products

-- Q127: Calculate delivery time in hours for delivered orders
-- Hint: TIMESTAMPDIFF in HOURS between order_date and delivery_date


/*
HARD QUESTIONS:
*/

-- Q128: Find orders where delivery took more than 7 days and group by month
-- Hint: DATEDIFF, DATE_FORMAT, GROUP BY

-- Q129: Display orders with expected delivery date (order_date + 7 days) and actual delivery_date
-- Hint: DATE_ADD function

-- Q130: Find users who registered in same month and year as today
-- Hint: MONTH() and YEAR() functions with WHERE clause

-- Q131: Calculate age of products in days since launch_date and categorize as: New (<30 days), Recent (30-90), Old (>90)
-- Hint: DATEDIFF and CASE


/*
-----------------------------------------------------------------------------
TOPIC 11: NULL FUNCTIONS (COALESCE, IFNULL, NULLIF)
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q132: Display user phone numbers, show 'Not Provided' if NULL
-- Hint: IFNULL or COALESCE

-- Q133: Show product weight, display 0 if NULL
-- Expected: Products with weight handling

-- Q134: Display delivery_date, show 'Not Delivered' if NULL
-- Expected: Orders with delivery status


/*
MEDIUM QUESTIONS:
*/

-- Q135: Calculate total order value: total_amount + IFNULL(shipping_charges, 0)
-- Expected: Orders with complete amount

-- Q136: Display seller rating, show 'New Seller' if rating is NULL
-- Expected: Seller rating information

-- Q137: Show product brand, if NULL show category_name instead
-- Hint: COALESCE with JOIN

-- Q138: Calculate discount percentage: (discount / NULLIF(total_amount, 0)) * 100
-- Hint: NULLIF prevents division by zero


/*
HARD QUESTIONS:
*/

-- Q139: Create a complete address string handling all NULL values gracefully
-- Format: COALESCE(street, '') + ', ' + COALESCE(city, '') + ' - ' + COALESCE(pincode, '')

-- Q140: Calculate average order value per user, handling users with no orders
-- Hint: COALESCE with LEFT JOIN and GROUP BY

-- Q141: Display product availability status considering both stock and is_available flag
-- Logic: If stock > 0 AND is_available = 1 then 'Available', else 'Out of Stock'


/*
-----------------------------------------------------------------------------
TOPIC 12: CASE STATEMENT
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q142: Categorize products as 'Cheap' (<1000), 'Moderate' (1000-10000), 'Expensive' (>10000)
-- Expected: Products with price categories

-- Q143: Display order status in Tamil: 'Pending'→'நிலுவையில்', 'Delivered'→'டெலிவரி செய்யப்பட்டது', etc.
-- Expected: Orders with Tamil status

-- Q144: Categorize users by loyalty points: 'Bronze' (<250), 'Silver' (250-500), 'Gold' (500-1000), 'Platinum' (>1000)
-- Expected: User loyalty tiers


/*
MEDIUM QUESTIONS:
*/

-- Q145: Create seller performance rating: 'Excellent' (rating >= 4.5), 'Good' (4-4.5), 'Average' (3.5-4), 'Poor' (<3.5)
-- Expected: Seller performance categories

-- Q146: Categorize orders by delivery speed: 'Express' (<= 3 days), 'Standard' (4-7 days), 'Delayed' (> 7 days)
-- Hint: Use DATEDIFF in CASE

-- Q147: Create payment priority: 'High' (> 50000), 'Medium' (10000-50000), 'Low' (< 10000)
-- Expected: Payment categorization

-- Q148: Season categorization based on order month: 'Spring' (Feb-Apr), 'Summer' (May-Jul), 'Monsoon' (Aug-Oct), 'Winter' (Nov-Jan)
-- Hint: Use MONTH() in CASE


/*
HARD QUESTIONS:
*/

-- Q149: Create complex product recommendation score:
-- Score = CASE 
--   WHEN rating > 4.5 AND stock > 50 THEN 'Highly Recommended'
--   WHEN rating > 4 AND stock > 20 THEN 'Recommended'
--   WHEN rating > 3.5 OR stock > 10 THEN 'Available'
--   ELSE 'Limited Stock'
-- END

-- Q150: Create dynamic discount suggestion based on multiple factors:
-- Consider: order_amount, payment_method, user_loyalty_points, order_count
-- Hint: Nested CASE statements

-- Q151: Categorize sellers by performance metrics combining rating, total_sales, and verification status


/*
-----------------------------------------------------------------------------
TOPIC 13: AGGREGATE FUNCTIONS & GROUP BY
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q152: Count total number of users
-- Expected: Single count value

-- Q153: Find total revenue from all delivered orders
-- Hint: SUM(total_amount) where status = 'Delivered'

-- Q154: Calculate average product price
-- Expected: Single average value

-- Q155: Find maximum and minimum product prices
-- Expected: Two values

-- Q156: Count total number of orders per user
-- Hint: GROUP BY user_id


/*
MEDIUM QUESTIONS:
*/

-- Q157: Find total sales amount per seller (only delivered orders)
-- Hint: JOIN sellers, products, order_items, orders and GROUP BY

-- Q158: Calculate average rating per product category
-- Expected: Categories with their average product ratings

-- Q159: Count number of products per brand, show only brands with more than 2 products
-- Hint: GROUP BY brand, HAVING COUNT(*) > 2

-- Q160: Find total discount given per payment method
-- Expected: Payment methods with total discounts

-- Q161: Calculate monthly revenue for December 2024
-- Hint: GROUP BY MONTH, YEAR

-- Q162: Find average loyalty points by account_status
-- Expected: Status-wise average points


/*
HARD QUESTIONS:
*/

-- Q163: Find top 5 sellers by total revenue (delivered orders only)
-- Hint: Complex JOIN with GROUP BY and ORDER BY

-- Q164: Calculate category-wise total products, average price, and total stock
-- Expected: Complete category summary

-- Q165: Find users who have spent more than 50000 in total and placed more than 3 orders
-- Hint: GROUP BY user_id, HAVING with multiple conditions

-- Q166: Calculate month-over-month revenue growth for last 6 months
-- Hint: GROUP BY month, use LAG window function or self-join

-- Q167: Find products with average rating > 4.5 and at least 5 reviews
-- Hint: JOIN with reviews, GROUP BY product, HAVING conditions


/*
=============================================================================
                        WINDOW FUNCTIONS
=============================================================================

-----------------------------------------------------------------------------
TOPIC 14: WINDOW FUNCTIONS BASICS (OVER, PARTITION BY, ORDER BY)
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q168: Add a serial number to all products ordered by price
-- Hint: ROW_NUMBER() OVER (ORDER BY price)

-- Q169: Display running total of order amounts ordered by order_date
-- Hint: SUM(total_amount) OVER (ORDER BY order_date)

-- Q170: Show each product with total count of all products
-- Hint: COUNT(*) OVER()


/*
MEDIUM QUESTIONS:
*/

-- Q171: Calculate running average of product prices ordered by launch_date
-- Hint: AVG(price) OVER (ORDER BY launch_date)

-- Q172: Display each order with percentage of its amount to total revenue
-- Formula: (amount / SUM(amount) OVER()) * 100

-- Q173: Show products with count of products in their category
-- Hint: PARTITION BY category_id


/*
HARD QUESTIONS:
*/

-- Q174: Calculate cumulative sales per seller ordered by order date
-- Hint: SUM() OVER (PARTITION BY seller_id ORDER BY order_date)

-- Q175: Display orders with running total per user
-- Hint: SUM(total_amount) OVER (PARTITION BY user_id ORDER BY order_date)

-- Q176: Calculate moving average of last 3 orders for each user
-- Hint: AVG(total_amount) OVER (PARTITION BY user_id ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)


/*
-----------------------------------------------------------------------------
TOPIC 15: WINDOW RANKING (ROW_NUMBER, RANK, DENSE_RANK, NTILE)
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q177: Rank products by price in descending order
-- Hint: RANK() OVER (ORDER BY price DESC)

-- Q178: Assign row numbers to users based on registration date
-- Expected: Sequential numbering

-- Q179: Divide products into 4 quartiles based on price
-- Hint: NTILE(4) OVER (ORDER BY price)


/*
MEDIUM QUESTIONS:
*/

-- Q180: Rank sellers by total_sales within each state
-- Hint: RANK() OVER (PARTITION BY state ORDER BY total_sales DESC)

-- Q181: Find dense rank of products by rating within each category
-- Hint: DENSE_RANK() OVER (PARTITION BY category_id ORDER BY rating DESC)

-- Q182: Assign percentile groups (10 groups) to users based on loyalty_points
-- Hint: NTILE(10)

-- Q183: Rank orders by amount within each payment method
-- Expected: Payment method-wise order ranking


/*
HARD QUESTIONS:
*/

-- Q184: Find top 3 products by rating in each category (use DENSE_RANK)
-- Hint: Use DENSE_RANK in subquery, then filter WHERE dense_rank <= 3

-- Q185: Rank users by total order amount and show their percentile
-- Hint: Combine RANK and PERCENT_RANK

-- Q186: Find products that rank in top 20% by price within their category
-- Hint: Use NTILE(5) and filter for group 5


/*
-----------------------------------------------------------------------------
TOPIC 16: WINDOW VALUE (LAG, LEAD, FIRST_VALUE, LAST_VALUE)
-----------------------------------------------------------------------------

EASY QUESTIONS:
*/

-- Q187: Show each order with the previous order amount for the same user
-- Hint: LAG(total_amount) OVER (PARTITION BY user_id ORDER BY order_date)

-- Q188: Display products with next product's price in the same category
-- Hint: LEAD(price) OVER (PARTITION BY category_id ORDER BY product_id)

-- Q189: Show first product name in each category
-- Hint: FIRST_VALUE(product_name) OVER (PARTITION BY category_id ORDER BY product_id)


/*
MEDIUM QUESTIONS:
*/

-- Q190: Calculate price difference between each product and the next product in same category
-- Hint: price - LEAD(price) OVER (...)

-- Q191: Show each order with first and last order date of that user
-- Hint: FIRST_VALUE and LAST_VALUE

-- Q192: Display products with the highest-rated product in their category
-- Hint: FIRST_VALUE(product_name) OVER (PARTITION BY category_id ORDER BY rating DESC)

-- Q193: Compare each month's revenue with previous month's revenue
-- Hint: Use LAG with monthly aggregated data


/*
HARD QUESTIONS:
*/

-- Q194: Calculate percentage growth in order amount compared to previous order for each user
-- Formula: ((current - previous) / previous) * 100
-- Hint: Use LAG in calculation

-- Q195: Find gap in days between consecutive orders for each user
-- Hint: DATEDIFF with LAG(order_date)

-- Q196: Show each product with the price difference from highest and lowest priced product in category
-- Hint: Combine FIRST_VALUE and LAST_VALUE with proper frame

-- Q197: Display running total and compare with final total for each category's products
-- Hint: SUM with different window frames

*/

-- =====================================================
-- END OF DATABASE AND QUESTIONS
-- =====================================================