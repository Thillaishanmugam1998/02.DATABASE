-- ============================================
-- E-COMMERCE PLATFORM - SQL PRACTICE QUESTIONS
-- 50+ Questions with Answers
-- Covers: Basic to Advanced SQL Concepts
-- ============================================

-- ============================================
-- SECTION 1: BASIC SELECT QUERIES (10 Questions)
-- ============================================

-- Q1. Retrieve all users from the database
SELECT * FROM users;

-- Q2. Get all active products with their names and prices
SELECT product_name, price, final_price 
FROM products 
WHERE is_active = 1;

-- Q3. List all orders placed in January 2026
SELECT * FROM orders 
WHERE order_date >= '2026-01-01' AND order_date < '2026-02-01';

-- Q4. Find all products with discount greater than 20%
SELECT product_name, price, discount_percentage, final_price 
FROM products 
WHERE discount_percentage > 20;

-- Q5. Get all users with 'gmail' email addresses
SELECT * FROM users 
WHERE email LIKE '%gmail%';

-- Q6. List all delivered orders
SELECT * FROM orders 
WHERE order_status = 'Delivered';

-- Q7. Find products priced between 5000 and 50000
SELECT product_name, price, final_price 
FROM products 
WHERE final_price BETWEEN 5000 AND 50000;

-- Q8. Get all verified sellers
SELECT * FROM sellers 
WHERE is_verified = 1;

-- Q9. List top 5 most expensive products
SELECT TOP 5 product_name, price, final_price 
FROM products 
ORDER BY final_price DESC;

-- Q10. Find all reviews with 5-star rating
SELECT * FROM reviews 
WHERE rating = 5;


-- ============================================
-- SECTION 2: AGGREGATE FUNCTIONS (10 Questions)
-- ============================================

-- Q11. Count total number of users
SELECT COUNT(*) AS total_users 
FROM users;

-- Q12. Calculate average product price
SELECT AVG(final_price) AS average_price 
FROM products;

-- Q13. Find the most expensive product price
SELECT MAX(final_price) AS max_price 
FROM products;

-- Q14. Get total revenue from all delivered orders
SELECT SUM(total_amount) AS total_revenue 
FROM orders 
WHERE order_status = 'Delivered';

-- Q15. Count products in each category
SELECT category_id, COUNT(*) AS product_count 
FROM products 
GROUP BY category_id;

-- Q16. Find average rating for each product
SELECT product_id, AVG(rating) AS avg_rating, COUNT(*) AS review_count 
FROM reviews 
GROUP BY product_id;

-- Q17. Calculate total quantity of products in inventory
SELECT SUM(quantity) AS total_stock 
FROM inventory;

-- Q18. Find minimum and maximum order amounts
SELECT MIN(total_amount) AS min_order, MAX(total_amount) AS max_order 
FROM orders;

-- Q19. Count orders by status
SELECT order_status, COUNT(*) AS order_count 
FROM orders 
GROUP BY order_status;

-- Q20. Find sellers with more than 10 products (using HAVING)
SELECT seller_id, COUNT(*) AS product_count 
FROM products 
GROUP BY seller_id 
HAVING COUNT(*) > 10;


-- ============================================
-- SECTION 3: JOINS (15 Questions)
-- ============================================

-- Q21. Get all products with their category names
SELECT p.product_name, p.price, c.category_name 
FROM products p 
INNER JOIN categories c ON p.category_id = c.category_id;

-- Q22. List all orders with customer details
SELECT o.order_number, o.order_date, o.total_amount, 
       u.first_name, u.last_name, u.email 
FROM orders o 
INNER JOIN users u ON o.user_id = u.user_id;

-- Q23. Show products with their seller business names
SELECT p.product_name, p.price, s.business_name 
FROM products p 
INNER JOIN sellers s ON p.seller_id = s.seller_id;

-- Q24. Get order items with product details
SELECT oi.order_id, oi.quantity, oi.total_price, 
       p.product_name, p.brand 
FROM order_items oi 
INNER JOIN products p ON oi.product_id = p.product_id;

-- Q25. List reviews with user and product information
SELECT r.rating, r.review_title, r.review_text, 
       u.first_name, u.last_name, p.product_name 
FROM reviews r 
INNER JOIN users u ON r.user_id = u.user_id 
INNER JOIN products p ON r.product_id = p.product_id;

-- Q26. Show orders with delivery address details
SELECT o.order_number, o.order_date, o.total_amount, 
       a.address_line1, a.city, a.state, a.pincode 
FROM orders o 
INNER JOIN addresses a ON o.address_id = a.address_id;

-- Q27. Get all products with inventory information
SELECT p.product_name, p.price, 
       i.quantity, i.reserved_quantity, i.available_quantity 
FROM products p 
INNER JOIN inventory i ON p.product_id = i.product_id;

-- Q28. List cart items with user and product details
SELECT u.first_name, u.last_name, p.product_name, 
       c.quantity, p.final_price 
FROM cart_items c 
INNER JOIN users u ON c.user_id = u.user_id 
INNER JOIN products p ON c.product_id = p.product_id;

-- Q29. Show payments with order information
SELECT p.transaction_id, p.amount, p.payment_status, 
       o.order_number, o.order_date 
FROM payments p 
INNER JOIN orders o ON p.order_id = o.order_id;

-- Q30. Get wishlist items with product details
SELECT u.first_name, u.last_name, p.product_name, p.final_price 
FROM wishlists w 
INNER JOIN users u ON w.user_id = u.user_id 
INNER JOIN products p ON w.product_id = p.product_id;

-- Q31. Find users who have never placed an order (LEFT JOIN)
SELECT u.user_id, u.first_name, u.last_name, u.email 
FROM users u 
LEFT JOIN orders o ON u.user_id = o.user_id 
WHERE o.order_id IS NULL;

-- Q32. List all products and their reviews (even products without reviews)
SELECT p.product_name, r.rating, r.review_title 
FROM products p 
LEFT JOIN reviews r ON p.product_id = r.product_id;

-- Q33. Get complete order details (multi-table join)
SELECT o.order_number, o.order_date, o.total_amount, 
       u.first_name, u.last_name, 
       oi.quantity, p.product_name, p.final_price 
FROM orders o 
INNER JOIN users u ON o.user_id = u.user_id 
INNER JOIN order_items oi ON o.order_id = oi.order_id 
INNER JOIN products p ON oi.product_id = p.product_id;

-- Q34. Show sellers and their total products sold
SELECT s.business_name, COUNT(DISTINCT p.product_id) AS total_products 
FROM sellers s 
LEFT JOIN products p ON s.seller_id = p.seller_id 
GROUP BY s.seller_id, s.business_name;

-- Q35. List products with category and seller information
SELECT p.product_name, c.category_name, s.business_name, p.final_price 
FROM products p 
INNER JOIN categories c ON p.category_id = c.category_id 
INNER JOIN sellers s ON p.seller_id = s.seller_id;


-- ============================================
-- SECTION 4: SUBQUERIES (10 Questions)
-- ============================================

-- Q36. Find products more expensive than average price
SELECT product_name, final_price 
FROM products 
WHERE final_price > (SELECT AVG(final_price) FROM products);

-- Q37. Get users who have placed more than 2 orders
SELECT user_id, first_name, last_name 
FROM users 
WHERE user_id IN (
    SELECT user_id 
    FROM orders 
    GROUP BY user_id 
    HAVING COUNT(*) > 2
);

-- Q38. Find the most expensive product in each category
SELECT p.category_id, p.product_name, p.final_price 
FROM products p 
WHERE p.final_price = (
    SELECT MAX(final_price) 
    FROM products 
    WHERE category_id = p.category_id
);

-- Q39. List products that have never been ordered
SELECT product_id, product_name, final_price 
FROM products 
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM order_items);

-- Q40. Find orders with total amount above average
SELECT order_number, total_amount 
FROM orders 
WHERE total_amount > (SELECT AVG(total_amount) FROM orders);

-- Q41. Get sellers with products rated above 4.5
SELECT DISTINCT s.seller_id, s.business_name 
FROM sellers s 
WHERE s.seller_id IN (
    SELECT seller_id 
    FROM products 
    WHERE average_rating > 4.5
);

-- Q42. Find products in the same category as 'Samsung Galaxy S24'
SELECT product_name, final_price 
FROM products 
WHERE category_id = (
    SELECT category_id 
    FROM products 
    WHERE product_name = 'Samsung Galaxy S24'
) AND product_name != 'Samsung Galaxy S24';

-- Q43. Get top 3 customers by total spending
SELECT TOP 3 u.user_id, u.first_name, u.last_name, SUM(o.total_amount) AS total_spent 
FROM users u 
INNER JOIN orders o ON u.user_id = o.user_id 
GROUP BY u.user_id, u.first_name, u.last_name 
ORDER BY total_spent DESC;

-- Q44. Find products with stock below average
SELECT p.product_name, i.quantity 
FROM products p 
INNER JOIN inventory i ON p.product_id = i.product_id 
WHERE i.quantity < (SELECT AVG(quantity) FROM inventory);

-- Q45. List users who have items in both cart and wishlist
SELECT u.user_id, u.first_name, u.last_name 
FROM users u 
WHERE u.user_id IN (SELECT user_id FROM cart_items) 
  AND u.user_id IN (SELECT user_id FROM wishlists);


-- ============================================
-- SECTION 5: ADVANCED QUERIES (10 Questions)
-- ============================================

-- Q46. Calculate revenue by category
SELECT c.category_name, SUM(oi.total_price) AS category_revenue 
FROM categories c 
INNER JOIN products p ON c.category_id = p.category_id 
INNER JOIN order_items oi ON p.product_id = oi.product_id 
INNER JOIN orders o ON oi.order_id = o.order_id 
WHERE o.order_status = 'Delivered' 
GROUP BY c.category_id, c.category_name 
ORDER BY category_revenue DESC;

-- Q47. Find products with low stock (available quantity < 50)
SELECT p.product_name, i.available_quantity, i.warehouse_location 
FROM products p 
INNER JOIN inventory i ON p.product_id = i.product_id 
WHERE i.available_quantity < 50 
ORDER BY i.available_quantity ASC;

-- Q48. Get monthly order count and revenue for 2026
SELECT 
    MONTH(order_date) AS month, 
    COUNT(*) AS order_count, 
    SUM(total_amount) AS monthly_revenue 
FROM orders 
WHERE YEAR(order_date) = 2026 
GROUP BY MONTH(order_date) 
ORDER BY month;

-- Q49. Find customers who haven't ordered in last 7 days
SELECT u.user_id, u.first_name, u.last_name, MAX(o.order_date) AS last_order_date 
FROM users u 
INNER JOIN orders o ON u.user_id = o.user_id 
GROUP BY u.user_id, u.first_name, u.last_name 
HAVING MAX(o.order_date) < DATEADD(day, -7, GETDATE());

-- Q50. Calculate seller performance (total revenue and average rating)
SELECT 
    s.business_name, 
    COUNT(DISTINCT p.product_id) AS total_products, 
    AVG(p.average_rating) AS avg_product_rating, 
    SUM(oi.total_price) AS total_revenue 
FROM sellers s 
LEFT JOIN products p ON s.seller_id = p.seller_id 
LEFT JOIN order_items oi ON p.product_id = oi.product_id 
GROUP BY s.seller_id, s.business_name 
ORDER BY total_revenue DESC;

-- Q51. Product conversion rate (cart to order)
SELECT 
    p.product_name, 
    COUNT(DISTINCT c.cart_id) AS cart_count, 
    COUNT(DISTINCT oi.order_item_id) AS order_count 
FROM products p 
LEFT JOIN cart_items c ON p.product_id = c.product_id 
LEFT JOIN order_items oi ON p.product_id = oi.product_id 
GROUP BY p.product_id, p.product_name;

-- Q52. Find customers with abandoned carts (items in cart but no recent orders)
SELECT 
    u.user_id, u.first_name, u.last_name, u.email, 
    COUNT(c.cart_id) AS cart_items 
FROM users u 
INNER JOIN cart_items c ON u.user_id = c.user_id 
LEFT JOIN orders o ON u.user_id = o.user_id 
    AND o.order_date > DATEADD(day, -7, GETDATE()) 
WHERE o.order_id IS NULL 
GROUP BY u.user_id, u.first_name, u.last_name, u.email;

-- Q53. Top 5 most reviewed products
SELECT TOP 5 
    p.product_name, 
    COUNT(r.review_id) AS review_count, 
    AVG(CAST(r.rating AS DECIMAL(3,2))) AS avg_rating 
FROM products p 
INNER JOIN reviews r ON p.product_id = r.product_id 
GROUP BY p.product_id, p.product_name 
ORDER BY review_count DESC;

-- Q54. Calculate average order value by payment method
SELECT 
    payment_method, 
    COUNT(*) AS order_count, 
    AVG(total_amount) AS avg_order_value, 
    SUM(total_amount) AS total_revenue 
FROM orders 
GROUP BY payment_method 
ORDER BY total_revenue DESC;

-- Q55. Find duplicate email addresses (data quality check)
SELECT email, COUNT(*) AS count 
FROM users 
GROUP BY email 
HAVING COUNT(*) > 1;


-- ============================================
-- SECTION 6: UPDATE & DELETE QUERIES (5 Questions)
-- ============================================

-- Q56. Update product discount percentage
UPDATE products 
SET discount_percentage = 25.00 
WHERE product_id = 1;

-- Q57. Mark order as delivered
UPDATE orders 
SET order_status = 'Delivered', delivered_date = GETDATE() 
WHERE order_number = 'ORD-2026-007';

-- Q58. Update user's last login time
UPDATE users 
SET last_login = GETDATE() 
WHERE user_id = 5;

-- Q59. Delete items from cart for a specific user
DELETE FROM cart_items 
WHERE user_id = 2;

-- Q60. Remove products with zero inventory
DELETE FROM products 
WHERE product_id IN (
    SELECT product_id 
    FROM inventory 
    WHERE quantity = 0
);


-- ============================================
-- SECTION 7: WINDOW FUNCTIONS (5 Questions)
-- ============================================

-- Q61. Rank products by price within each category
SELECT 
    product_name, category_id, final_price, 
    RANK() OVER (PARTITION BY category_id ORDER BY final_price DESC) AS price_rank 
FROM products;

-- Q62. Running total of orders by date
SELECT 
    order_date, total_amount, 
    SUM(total_amount) OVER (ORDER BY order_date) AS running_total 
FROM orders;

-- Q63. Row number for each user's orders
SELECT 
    user_id, order_number, order_date, 
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date DESC) AS order_sequence 
FROM orders;

-- Q64. Calculate moving average of product prices
SELECT 
    product_name, final_price, 
    AVG(final_price) OVER (ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg 
FROM products;

-- Q65. Find top 3 products per category by rating
SELECT * FROM (
    SELECT 
        product_name, category_id, average_rating, 
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY average_rating DESC) AS rank 
    FROM products
) AS ranked 
WHERE rank <= 3;


-- ============================================
-- SECTION 8: CASE STATEMENTS (5 Questions)
-- ============================================

-- Q66. Categorize products by price range
SELECT 
    product_name, final_price, 
    CASE 
        WHEN final_price < 1000 THEN 'Budget' 
        WHEN final_price BETWEEN 1000 AND 10000 THEN 'Mid-Range' 
        WHEN final_price > 10000 THEN 'Premium' 
    END AS price_category 
FROM products;

-- Q67. Label order status
SELECT 
    order_number, order_status, 
    CASE 
        WHEN order_status IN ('Delivered') THEN 'Completed' 
        WHEN order_status IN ('Shipped', 'Out for Delivery') THEN 'In Progress' 
        WHEN order_status IN ('Pending', 'Confirmed') THEN 'Processing' 
        ELSE 'Other' 
    END AS status_category 
FROM orders;

-- Q68. Customer segmentation by total spending
SELECT 
    u.user_id, u.first_name, u.last_name, 
    SUM(o.total_amount) AS total_spent, 
    CASE 
        WHEN SUM(o.total_amount) > 100000 THEN 'VIP' 
        WHEN SUM(o.total_amount) > 50000 THEN 'Premium' 
        WHEN SUM(o.total_amount) > 10000 THEN 'Regular' 
        ELSE 'New' 
    END AS customer_tier 
FROM users u 
LEFT JOIN orders o ON u.user_id = o.user_id 
GROUP BY u.user_id, u.first_name, u.last_name;

-- Q69. Stock status indicator
SELECT 
    p.product_name, i.available_quantity, 
    CASE 
        WHEN i.available_quantity = 0 THEN 'Out of Stock' 
        WHEN i.available_quantity < 50 THEN 'Low Stock' 
        WHEN i.available_quantity < 200 THEN 'In Stock' 
        ELSE 'Well Stocked' 
    END AS stock_status 
FROM products p 
INNER JOIN inventory i ON p.product_id = i.product_id;

-- Q70. Discount tier classification
SELECT 
    product_name, discount_percentage, 
    CASE 
        WHEN discount_percentage >= 30 THEN 'Hot Deal' 
        WHEN discount_percentage >= 15 THEN 'Good Offer' 
        WHEN discount_percentage > 0 THEN 'Sale' 
        ELSE 'Regular Price' 
    END AS deal_type 
FROM products;


-- ============================================
-- SECTION 9: DATE & TIME FUNCTIONS (5 Questions)
-- ============================================

-- Q71. Find orders placed in the last 30 days
SELECT * FROM orders 
WHERE order_date >= DATEADD(day, -30, GETDATE());

-- Q72. Calculate age of users
SELECT 
    first_name, last_name, date_of_birth, 
    DATEDIFF(year, date_of_birth, GETDATE()) AS age 
FROM users 
WHERE date_of_birth IS NOT NULL;

-- Q73. Get day of week for orders
SELECT 
    order_number, order_date, 
    DATENAME(weekday, order_date) AS day_of_week 
FROM orders;

-- Q74. Find products added in current month
SELECT product_name, created_at 
FROM products 
WHERE MONTH(created_at) = MONTH(GETDATE()) 
  AND YEAR(created_at) = YEAR(GETDATE());

-- Q75. Calculate average delivery time
SELECT 
    AVG(DATEDIFF(day, order_date, delivered_date)) AS avg_delivery_days 
FROM orders 
WHERE delivered_date IS NOT NULL;


-- ============================================
-- SECTION 10: STRING FUNCTIONS (5 Questions)
-- ============================================

-- Q76. Get user full names (concatenation)
SELECT 
    user_id, 
    first_name + ' ' + last_name AS full_name, 
    email 
FROM users;

-- Q77. Extract domain from email addresses
SELECT 
    email, 
    SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) AS email_domain 
FROM users;

-- Q78. Convert product names to uppercase
SELECT 
    UPPER(product_name) AS product_name_upper, 
    final_price 
FROM products;

-- Q79. Find products with specific keyword in name
SELECT product_name, final_price 
FROM products 
WHERE product_name LIKE '%phone%' OR product_name LIKE '%mobile%';

-- Q80. Get first 3 characters of order number
SELECT 
    order_number, 
    LEFT(order_number, 3) AS order_prefix 
FROM orders;


-- ============================================
-- END OF QUESTIONS
-- Total: 80 SQL Practice Questions
-- ============================================

PRINT '=== 80 SQL Practice Questions Loaded Successfully ===';
PRINT 'Categories Covered:';
PRINT '1. Basic SELECT Queries (10)';
PRINT '2. Aggregate Functions (10)';
PRINT '3. JOINS (15)';
PRINT '4. Subqueries (10)';
PRINT '5. Advanced Queries (10)';
PRINT '6. UPDATE & DELETE (5)';
PRINT '7. Window Functions (5)';
PRINT '8. CASE Statements (5)';
PRINT '9. Date & Time Functions (5)';
PRINT '10. String Functions (5)';
GO