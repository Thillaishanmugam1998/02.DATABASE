-- ============================================================
--  FoodDeliveryDB  |  JOIN Questions  —  Correct Answers
--  Schema: Cities, Customers, RestaurantCategories, Restaurants,
--          MenuItems, DeliveryAgents, Orders, OrderItems,
--          Reviews, Coupons
-- ============================================================


-- ★ EASY 1
-- Show order_id and customer full_name using INNER JOIN.
SELECT o.order_id,
       c.full_name
FROM Orders AS o
INNER JOIN Customers AS c
    ON o.customer_id = c.customer_id;


-- ★ EASY 2
-- Show all customers and their orders using LEFT JOIN
-- (include customers with no orders too).
SELECT c.*,
       o.*
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.customer_id = o.customer_id;


-- ★ EASY 3
-- Show all restaurants and their category name using INNER JOIN.
SELECT r.restaurant_name,
       rc.category_name
FROM Restaurants AS r
INNER JOIN RestaurantCategories AS rc
    ON r.category_id = rc.category_id;


-- ★★ MEDIUM 1
-- Show customers who have NO orders (LEFT JOIN + NULL check).
SELECT c.*
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- ★★ MEDIUM 2
-- 3-table JOIN: order_id, customer name, restaurant name, order status.
SELECT o.order_id,
       c.full_name,
       r.restaurant_name,
       o.status
FROM Orders AS o
INNER JOIN Customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN Restaurants AS r
    ON r.restaurant_id = o.restaurant_id;


-- ★★ MEDIUM 3
-- SELF JOIN: pairs of restaurants in the same city.
-- (r1.restaurant_id < r2.restaurant_id removes self-pairs & duplicates)
SELECT r1.restaurant_name AS restaurant_1,
       r2.restaurant_name AS restaurant_2,
       r1.city_id
FROM Restaurants AS r1
INNER JOIN Restaurants AS r2
    ON  r1.city_id        = r2.city_id
    AND r1.restaurant_id  < r2.restaurant_id
ORDER BY r1.city_id;


-- ★★★ HARD 1
-- 5-table JOIN: city → customer → order → orderitems → menuitem.
-- Show city name, customer name, item name, quantity, unit_price.
SELECT ct.city_name,
       c.full_name,
       mi.item_name,
       oi.quantity,
       oi.unit_price
FROM Cities AS ct
INNER JOIN Customers AS c
    ON c.city_id = ct.city_id
INNER JOIN Orders AS o
    ON o.customer_id = c.customer_id
INNER JOIN OrderItems AS oi
    ON oi.order_id = o.order_id
INNER JOIN MenuItems AS mi
    ON mi.item_id = oi.item_id
ORDER BY c.full_name;


-- ★★★ HARD 2
-- FULL OUTER JOIN between Customers and Orders —
-- customers with no orders AND orders with no matching customer.
SELECT c.customer_id,
       c.full_name,
       o.order_id,
       o.status
FROM Customers AS c
FULL OUTER JOIN Orders AS o
    ON c.customer_id = o.customer_id;
-- Rows where o.* IS NULL  → customer has no orders
-- Rows where c.* IS NULL  → order has no matching customer (orphan data)


-- ★★★ HARD 3
-- Most expensive item each customer has ever ordered.
-- Uses window function RANK() — ties show all equally-priced top items.
SELECT customer_id,
       full_name,
       item_name,
       unit_price
FROM (
    SELECT c.customer_id,
           c.full_name,
           mi.item_name,
           oi.unit_price,
           RANK() OVER (
               PARTITION BY c.customer_id
               ORDER BY oi.unit_price DESC
           ) AS price_rank
    FROM Orders AS o
    INNER JOIN Customers AS c
        ON c.customer_id = o.customer_id
    INNER JOIN OrderItems AS oi
        ON oi.order_id = o.order_id
    INNER JOIN MenuItems AS mi
        ON mi.item_id = oi.item_id
) AS ranked
WHERE price_rank = 1;

-- Alternative: using ROW_NUMBER() if you want exactly ONE row per customer
-- (when there are ties, picks one arbitrarily)
/*
SELECT customer_id, full_name, item_name, unit_price
FROM (
    SELECT c.customer_id,
           c.full_name,
           mi.item_name,
           oi.unit_price,
           ROW_NUMBER() OVER (
               PARTITION BY c.customer_id
               ORDER BY oi.unit_price DESC
           ) AS rn
    FROM Orders AS o
    INNER JOIN Customers AS c  ON c.customer_id = o.customer_id
    INNER JOIN OrderItems AS oi ON oi.order_id  = o.order_id
    INNER JOIN MenuItems AS mi  ON mi.item_id   = oi.item_id
) AS ranked
WHERE rn = 1;
*/