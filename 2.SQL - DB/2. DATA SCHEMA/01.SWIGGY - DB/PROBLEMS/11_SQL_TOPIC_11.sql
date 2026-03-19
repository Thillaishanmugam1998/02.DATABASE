/*
╔══════════════════════════════════════════════════════════════════════╗
║         FOODDELIVERYDB — TOPIC 11 : HAVING                          ║
║         Group-level Filtering — Correct Answers                     ║
║         Database  : FoodDeliveryDB                                  ║
║         Tables    : Cities, Customers, Restaurants, MenuItems,      ║
║                     DeliveryAgents, Orders, OrderItems,             ║
║                     Reviews, Coupons, RestaurantCategories          ║
╚══════════════════════════════════════════════════════════════════════╝
*/

-- ============================================================
-- ★ EASY 1
-- EN : Show only those cities that have more than 2 restaurants.
-- TM : 2-க்கும் அதிகமான restaurants உள்ள cities மட்டும் காட்டு.
-- ============================================================
-- Logic : Join Restaurants with Cities to get city_name.
--         Group by city and filter groups with COUNT > 2.
-- ============================================================

SELECT
    c.city_id,
    c.city_name,
    COUNT(r.restaurant_id)  AS restaurant_count
FROM Restaurants AS r
INNER JOIN Cities AS c
    ON c.city_id = r.city_id
GROUP BY
    c.city_id,
    c.city_name
HAVING COUNT(r.restaurant_id) > 2
ORDER BY c.city_id ASC;


-- ============================================================
-- ★ EASY 2
-- EN : Show payment modes used more than 5 times.
-- TM : 5-க்கும் அதிகமாக use ஆன payment modes காட்டு.
-- ============================================================
-- Logic : Group Orders by payment_mode.
--         Filter groups where usage count > 5.
-- ============================================================

SELECT
    payment_mode,
    COUNT(*)  AS usage_count
FROM Orders
GROUP BY payment_mode
HAVING COUNT(*) > 5;


-- ============================================================
-- ★ EASY 3
-- EN : Show customers who have placed more than 1 order.
-- TM : 1-க்கும் அதிகமான order போட்ட customers காட்டு.
-- ============================================================
-- Logic : Join Orders with Customers to get full_name.
--         Group by customer_id + full_name (safe grouping).
--         Filter groups with COUNT > 1.
-- ============================================================

SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id)  AS order_count
FROM Orders AS o
INNER JOIN Customers AS c
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.full_name
HAVING COUNT(o.order_id) > 1
ORDER BY c.customer_id ASC;


-- ============================================================
-- ★★ MEDIUM 1
-- EN : Show restaurants whose average food rating is above 4.2.
-- TM : Average food rating 4.2-க்கும் அதிகமான restaurants காட்டு.
-- ============================================================
-- Logic : Join Reviews with Restaurants to get restaurant_name.
--         Group by restaurant and filter AVG(food_rating) > 4.2.
-- ============================================================

SELECT
    r.restaurant_id,
    r.restaurant_name,
    AVG(re.food_rating)  AS avg_food_rating
FROM Reviews AS re
INNER JOIN Restaurants AS r
    ON r.restaurant_id = re.restaurant_id
GROUP BY
    r.restaurant_id,
    r.restaurant_name
HAVING AVG(re.food_rating) > 4.2
ORDER BY r.restaurant_name;


-- ============================================================
-- ★★ MEDIUM 2
-- EN : Show cities where total order revenue exceeds ₹1000.
-- TM : Total order revenue ₹1000-க்கும் அதிகமான cities காட்டு.
-- ============================================================
-- Logic : Orders → Customers → Cities (3-table JOIN).
--         Group by city and filter SUM(total_amount) > 1000.
-- ============================================================

SELECT
    ct.city_id,
    ct.city_name,
    SUM(o.total_amount)  AS total_revenue
FROM Orders AS o
INNER JOIN Customers AS c
    ON c.customer_id = o.customer_id
INNER JOIN Cities AS ct
    ON ct.city_id = c.city_id
GROUP BY
    ct.city_id,
    ct.city_name
HAVING SUM(o.total_amount) > 1000
ORDER BY total_revenue DESC;


-- ============================================================
-- ★★ MEDIUM 3
-- EN : Show delivery agents who have handled more than 2 orders
--      and have rating > 4.0.
-- TM : 2-க்கும் அதிகமான orders handle செய்த,
--      rating > 4.0 உள்ள agents காட்டு.
-- ============================================================
-- Logic : Filter agents with rating > 4.0 using WHERE (non-aggregated).
--         Then group by agent and filter order count > 2 using HAVING.
-- Key   : rating is a single value per agent → use WHERE, not HAVING.
-- ============================================================

SELECT
    da.agent_id,
    da.agent_name,
    da.rating,
    COUNT(o.order_id)  AS total_orders
FROM DeliveryAgents AS da
INNER JOIN Orders AS o
    ON o.agent_id = da.agent_id
WHERE da.rating > 4.0
GROUP BY
    da.agent_id,
    da.agent_name,
    da.rating
HAVING COUNT(o.order_id) > 2
ORDER BY da.agent_name;


-- ============================================================
-- ★★★ HARD 1
-- EN : Show restaurants where max item price > 3× min item price
--      (high price spread).
-- TM : Max item price, Min item price-ஐ விட 3 மடங்கு
--      அதிகமாக உள்ள restaurants காட்டு.
-- ============================================================
-- Logic : Group MenuItems by restaurant_id.
--         Use HAVING to compare MAX(price) vs 3 * MIN(price).
-- ============================================================

SELECT
    mi.restaurant_id,
    r.restaurant_name,
    MIN(mi.price)  AS min_price,
    MAX(mi.price)  AS max_price
FROM MenuItems AS mi
INNER JOIN Restaurants AS r
    ON r.restaurant_id = mi.restaurant_id
GROUP BY
    mi.restaurant_id,
    r.restaurant_name
HAVING MAX(mi.price) > 3 * MIN(mi.price)
ORDER BY mi.restaurant_id;


-- ============================================================
-- ★★★ HARD 2
-- EN : Show months in 2024 where cancelled orders are more than 0
--      but delivered orders are less than 3.
-- TM : 2024-இல் cancelled orders > 0,
--      ஆனால் delivered orders < 3 உள்ள months காட்டு.
-- ============================================================
-- Logic : Filter year 2024 using WHERE.
--         Group by month.
--         Use CASE WHEN inside SUM for conditional counting.
--         Apply two HAVING conditions.
-- ============================================================

SELECT
    MONTH(order_date)                                                       AS order_month,
    SUM(CASE WHEN status = 'Cancelled'  THEN 1 ELSE 0 END)                 AS cancelled_count,
    SUM(CASE WHEN status = 'Delivered'  THEN 1 ELSE 0 END)                 AS delivered_count
FROM Orders
WHERE YEAR(order_date) = 2024
GROUP BY MONTH(order_date)
HAVING
    SUM(CASE WHEN status = 'Cancelled'  THEN 1 ELSE 0 END) > 0
    AND
    SUM(CASE WHEN status = 'Delivered'  THEN 1 ELSE 0 END) < 3
ORDER BY order_month;


-- ============================================================
-- ★★★ HARD 3
-- EN : Show customers whose average discount received is greater
--      than ₹20 AND who have placed at least 2 orders.
-- TM : Average discount > ₹20 மற்றும்
--      குறைந்தது 2 orders போட்ட customers காட்டு.
-- ============================================================
-- Logic : Join Orders with Customers for full_name.
--         Group by customer.
--         HAVING filters: AVG(discount) > 20  AND  COUNT >= 2.
-- Key   : "at least 2" means >= 2 (not > 2).
--         COUNT(order_id) counts ALL orders regardless of status.
-- ============================================================

SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id)   AS total_orders,
    AVG(o.discount)     AS avg_discount
FROM Orders AS o
INNER JOIN Customers AS c
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.full_name
HAVING
    AVG(o.discount)   > 20
    AND
    COUNT(o.order_id) >= 2
ORDER BY c.customer_id ASC;


/*
╔══════════════════════════════════════════════════════════════════════╗
║                     QUICK REFERENCE NOTES                           ║
╠══════════════════════════════════════════════════════════════════════╣
║  WHERE  vs  HAVING                                                  ║
║  ─────────────────────────────────────────────────────────────────  ║
║  WHERE  → filters individual rows  BEFORE grouping                  ║
║  HAVING → filters groups           AFTER  grouping                  ║
║                                                                     ║
║  COUNT(CASE WHEN ... THEN 1 END)   ← correct conditional count      ║
║  COUNT(CASE WHEN ... THEN 1 ELSE 0 END) ← WRONG (counts all rows)  ║
║                                                                     ║
║  "at least N"  →  >= N                                              ║
║  "more than N" →  >  N                                              ║
║                                                                     ║
║  Never use SUM(id_column) — IDs are identifiers, not values.        ║
╚══════════════════════════════════════════════════════════════════════╝
*/