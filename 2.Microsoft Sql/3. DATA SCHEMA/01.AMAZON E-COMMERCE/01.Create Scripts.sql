-- ============================================
-- E-COMMERCE PLATFORM DATABASE SCHEMA
-- SQL Server 2025 Compatible
-- Simplified & Beginner Friendly
-- ============================================

-- Drop existing tables if they exist (in reverse order of dependencies)
IF OBJECT_ID('order_items', 'U') IS NOT NULL DROP TABLE order_items;
IF OBJECT_ID('orders', 'U') IS NOT NULL DROP TABLE orders;
IF OBJECT_ID('cart_items', 'U') IS NOT NULL DROP TABLE cart_items;
IF OBJECT_ID('reviews', 'U') IS NOT NULL DROP TABLE reviews;
IF OBJECT_ID('wishlists', 'U') IS NOT NULL DROP TABLE wishlists;
IF OBJECT_ID('inventory', 'U') IS NOT NULL DROP TABLE inventory;
IF OBJECT_ID('products', 'U') IS NOT NULL DROP TABLE products;
IF OBJECT_ID('categories', 'U') IS NOT NULL DROP TABLE categories;
IF OBJECT_ID('addresses', 'U') IS NOT NULL DROP TABLE addresses;
IF OBJECT_ID('payments', 'U') IS NOT NULL DROP TABLE payments;
IF OBJECT_ID('sellers', 'U') IS NOT NULL DROP TABLE sellers;
IF OBJECT_ID('users', 'U') IS NOT NULL DROP TABLE users;
GO

-- ============================================
-- TABLE: users
-- ============================================
CREATE TABLE users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    account_status VARCHAR(20) DEFAULT 'Active' CHECK (account_status IN ('Active', 'Inactive', 'Suspended')),
    created_at DATETIME DEFAULT GETDATE(),
    last_login DATETIME NULL
);
GO

CREATE INDEX idx_email ON users(email);
CREATE INDEX idx_account_status ON users(account_status);
GO

-- ============================================
-- TABLE: sellers
-- ============================================
CREATE TABLE sellers (
    seller_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    business_name VARCHAR(255) NOT NULL,
    business_email VARCHAR(255) UNIQUE NOT NULL,
    business_phone VARCHAR(20),
    seller_rating DECIMAL(3,2) DEFAULT 0.00,
    is_verified BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
GO

CREATE INDEX idx_seller_rating ON sellers(seller_rating);
GO

-- ============================================
-- TABLE: addresses
-- ============================================
CREATE TABLE addresses (
    address_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    address_type VARCHAR(20) DEFAULT 'Home' CHECK (address_type IN ('Home', 'Work', 'Other')),
    full_name VARCHAR(200) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address_line1 VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    country VARCHAR(100) DEFAULT 'India',
    is_default BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
GO

CREATE INDEX idx_user_address ON addresses(user_id);
GO

-- ============================================
-- TABLE: categories
-- ============================================
CREATE TABLE categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- ============================================
-- TABLE: products
-- ============================================
CREATE TABLE products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    seller_id INT NOT NULL,
    category_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    description VARCHAR(1000),
    brand VARCHAR(100),
    price DECIMAL(10,2) NOT NULL,
    discount_percentage DECIMAL(5,2) DEFAULT 0.00,
    final_price AS (price - (price * discount_percentage / 100)) PERSISTED,
    is_active BIT DEFAULT 1,
    average_rating DECIMAL(3,2) DEFAULT 0.00,
    total_reviews INT DEFAULT 0,
    image_url VARCHAR(500),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
GO

CREATE INDEX idx_category ON products(category_id);
CREATE INDEX idx_price ON products(final_price);
CREATE INDEX idx_rating ON products(average_rating);
GO

-- ============================================
-- TABLE: inventory
-- ============================================
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    reserved_quantity INT DEFAULT 0,
    available_quantity AS (quantity - reserved_quantity) PERSISTED,
    warehouse_location VARCHAR(100),
    last_restocked DATETIME NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
GO

CREATE INDEX idx_product_inventory ON inventory(product_id);
GO

-- ============================================
-- TABLE: cart_items
-- ============================================
CREATE TABLE cart_items (
    cart_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    added_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
GO

CREATE INDEX idx_user_cart ON cart_items(user_id);
GO

-- ============================================
-- TABLE: wishlists
-- ============================================
CREATE TABLE wishlists (
    wishlist_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    added_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
GO

CREATE INDEX idx_user_wishlist ON wishlists(user_id);
GO

-- ============================================
-- TABLE: orders
-- ============================================
CREATE TABLE orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    address_id INT NOT NULL,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    order_status VARCHAR(30) DEFAULT 'Pending' CHECK (order_status IN ('Pending', 'Confirmed', 'Shipped', 'Delivered', 'Cancelled')),
    payment_method VARCHAR(30) CHECK (payment_method IN ('Credit Card', 'Debit Card', 'UPI', 'Cash on Delivery')),
    total_amount DECIMAL(10,2) NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    delivered_date DATETIME NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (address_id) REFERENCES addresses(address_id)
);
GO

CREATE INDEX idx_user_orders ON orders(user_id);
CREATE INDEX idx_order_status ON orders(order_status);
CREATE INDEX idx_order_date ON orders(order_date);
GO

-- ============================================
-- TABLE: order_items
-- ============================================
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
GO

CREATE INDEX idx_order ON order_items(order_id);
GO

-- ============================================
-- TABLE: payments
-- ============================================
CREATE TABLE payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,
    payment_method VARCHAR(30),
    payment_status VARCHAR(20) DEFAULT 'Pending' CHECK (payment_status IN ('Pending', 'Success', 'Failed')),
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
GO

CREATE INDEX idx_payment_order ON payments(order_id);
GO

-- ============================================
-- TABLE: reviews
-- ============================================
CREATE TABLE reviews (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    order_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_title VARCHAR(200),
    review_text VARCHAR(1000),
    helpful_count INT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
GO

CREATE INDEX idx_product_reviews ON reviews(product_id);
GO

PRINT 'Schema created successfully!';
GO