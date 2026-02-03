/* ===============================
   Q1: Display all users
   =============================== */
SELECT *
FROM users;


/* ===============================
   Q2: Display product name and price
   =============================== */
SELECT product_name, price
FROM products;


/* ===============================
   Q3: List distinct seller cities
   =============================== */
SELECT DISTINCT city
FROM sellers;


/* ===============================
   Q4: Display user id, username, and email
   =============================== */
SELECT user_id, username, email
FROM users;


/* ===============================
   Q5: List distinct order statuses
   =============================== */
SELECT DISTINCT order_status
FROM orders;


/* ===============================
   Q6: Calculate 10% discounted price
   =============================== */
SELECT 
    product_name,
    price,
    price - (price * 0.10) AS discounted_price
FROM products;


/* ===============================
   Q7: Display product names in uppercase
   =============================== */
SELECT UPPER(product_name) AS product_name
FROM products;


/* ===============================
   Q8: Display seller name and city with aliases
   =============================== */
SELECT 
    seller_name AS [Seller Name],
    city AS [Location]
FROM sellers;


/* ===============================
   Q9: Calculate total price per order item
   =============================== */
SELECT 
    product_id,
    quantity,
    unit_price,
    quantity * unit_price AS [Total Price]
FROM order_items
ORDER BY product_id;


/* ===============================
   Q10: Convert price from INR to USD
   =============================== */
SELECT 
    product_name,
    price AS [Indian Rupees],
    price / 83.0 AS [Dollar]
FROM products;


/* ===============================
   Q11: Extract registration year
   =============================== */
SELECT 
    username,
    YEAR(registration_date) AS [Register Year]
FROM users;


/* ===============================
   Q12: Calculate GST (18%) and final price
   =============================== */
SELECT 
    product_name,
    price,
    price * 0.18 AS GST,
    price * 1.18 AS [Price With GST]
FROM products;


/* ===============================
   Q13: Format order id as ORD-<id>
   =============================== */
SELECT 
    CONCAT('ORD-', order_id) AS orderid
FROM orders;


/* ===============================
   Q14: Calculate accurate age from date_of_birth
   =============================== */
SELECT 
    username,
    date_of_birth,
    DATEDIFF(YEAR, date_of_birth, GETDATE())
    - CASE 
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, date_of_birth, GETDATE()), date_of_birth) > GETDATE()
        THEN 1
        ELSE 0
      END AS age
FROM users;


/* ===============================
   Q15: Categorize products by price
   =============================== */
SELECT 
    product_name,
    price,
    CASE
        WHEN price < 5000 THEN 'Budget'
        WHEN price <= 50000 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS category
FROM products;


/* ===============================
   Q16: Format order_date as DD-Mon-YYYY
   =============================== */
SELECT 
    order_id,
    REPLACE(CONVERT(VARCHAR(11), order_date, 106), ' ', '-') 
        AS formatted_order_date
FROM orders;
