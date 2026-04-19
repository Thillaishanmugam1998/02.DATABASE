-- ============================================================
--  FoodDeliveryDB — CASE Statement Correct Answers
--  All 9 Queries | SQL Server
-- ============================================================


-- ★ EASY 1
-- Show each order with a label: 'Cheap' (< 200), 'Moderate' (200–500), 'Expensive' (> 500).

SELECT *,
    CASE
        WHEN total_amount < 200              THEN 'Cheap'
        WHEN total_amount BETWEEN 200 AND 500 THEN 'Moderate'
        WHEN total_amount > 500              THEN 'Expensive'
    END AS Level
FROM Orders;


-- ★ EASY 2
-- Show is_veg as 'Veg' or 'Non-Veg' for each menu item.

SELECT
    item_id,
    restaurant_id,
    item_name,
    CASE
        WHEN is_veg = 1 THEN 'Veg'
        ELSE 'Non-Veg'
    END AS itemCategory
FROM MenuItems;


-- ★ EASY 3
-- Show order status with an emoji: Delivered ✅, Cancelled ❌, others 🔄.

SELECT
    order_id,
    order_number,
    customer_id,
    restaurant_id,
    agent_id,
    order_date,
    status,
    CASE
        WHEN status = 'Delivered' THEN N'✅'
        WHEN status = 'Cancelled' THEN N'❌'
        ELSE N'🔄'
    END AS emoji
FROM Orders;


-- ★★ MEDIUM 1
-- Show each customer's loyalty tier based on total orders:
-- 0 orders = 'New', 1–2 = 'Bronze', 3–5 = 'Silver', 6+ = 'Gold'.
-- Fix: LEFT JOIN from Customers so 0-order customers appear too.

SELECT
    c.customer_id,
    COUNT(o.order_id) AS order_count,
    CASE
        WHEN COUNT(o.order_id) = 0               THEN 'New'
        WHEN COUNT(o.order_id) BETWEEN 1 AND 2   THEN 'Bronze'
        WHEN COUNT(o.order_id) BETWEEN 3 AND 5   THEN 'Silver'
        ELSE 'Gold'
    END AS loyalty
FROM Customers AS c
LEFT JOIN Orders AS o ON o.customer_id = c.customer_id
GROUP BY c.customer_id;


-- ★★ MEDIUM 2
-- Show restaurants with a "performance" label:
-- rating >= 4.5 = 'Excellent', 4.0–4.4 = 'Good', < 4.0 = 'Needs Improvement'.

SELECT
    restaurant_id,
    restaurant_name,
    rating,
    CASE
        WHEN rating >= 4.5               THEN 'Excellent'
        WHEN rating BETWEEN 4.0 AND 4.4  THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance
FROM Restaurants;


-- ★★ MEDIUM 3
-- Pivot-style report: count of orders for each status as separate columns.
-- Columns: placed_count, confirmed_count, delivered_count, cancelled_count.
-- Fix: use correct schema status values ('Placed', 'Confirmed').

SELECT
    SUM(CASE WHEN status = 'Placed'    THEN 1 ELSE 0 END) AS placed_count,
    SUM(CASE WHEN status = 'Confirmed' THEN 1 ELSE 0 END) AS confirmed_count,
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_count,
    SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_count
FROM Orders;


-- ★★★ HARD 1
-- Delivery agent performance:
-- rating >= 4.5 AND deliveries >= 5 = 'Star Agent'
-- rating >= 4.0                     = 'Good Agent'
-- else                              = 'Needs Training'

SELECT
    da.agent_id,
    da.agent_name,
    da.rating,
    COUNT(o.order_id) AS total_deliveries,
    CASE
        WHEN da.rating >= 4.5 AND COUNT(o.order_id) >= 5 THEN 'Star Agent'
        WHEN da.rating >= 4.0                             THEN 'Good Agent'
        ELSE 'Needs Training'
    END AS performance
FROM DeliveryAgents AS da
LEFT JOIN Orders AS o ON o.agent_id = da.agent_id
GROUP BY da.agent_id, da.agent_name, da.rating;


-- ★★★ HARD 2
-- Discount effectiveness: was the order above average?
-- Fix: correlated subquery to get overall avg, compare per row.

SELECT
    order_id,
    order_number,
    total_amount,
    discount_amount,
    CASE
        WHEN total_amount > (SELECT AVG(total_amount) FROM Orders)
            THEN 'Helped'
        ELSE 'Not Helped'
    END AS discount_effectiveness
FROM Orders;


-- ★★★ HARD 3
-- City summary: city_name, total_customers, total_orders,
--               total_revenue, best_rating, best_restaurant_name.
-- Fix 1: COUNT(DISTINCT) for unique customers.
-- Fix 2: Subquery to get best-rated restaurant name per city.

SELECT
    c.city_name,
    COUNT(DISTINCT o.customer_id)   AS total_customers,
    COUNT(o.order_id)               AS total_orders,
    SUM(o.total_amount)             AS total_revenue,
    MAX(r.rating)                   AS best_rating,
    (
        SELECT TOP 1 r2.restaurant_name
        FROM Restaurants AS r2
        INNER JOIN Orders AS o2      ON o2.restaurant_id = r2.restaurant_id
        INNER JOIN Customers AS c2   ON c2.customer_id   = o2.customer_id
        WHERE c2.city_id = cus.city_id
        ORDER BY r2.rating DESC
    )                               AS best_restaurant_name
FROM Orders AS o
INNER JOIN Customers AS cus ON cus.customer_id = o.customer_id
INNER JOIN Cities    AS c   ON c.city_id       = cus.city_id
INNER JOIN Restaurants AS r ON r.restaurant_id = o.restaurant_id
GROUP BY c.city_name, cus.city_id
ORDER BY c.city_name;

