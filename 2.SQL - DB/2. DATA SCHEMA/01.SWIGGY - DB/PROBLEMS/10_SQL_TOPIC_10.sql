

-- ============================================================
-- FoodDeliveryDB — GROUP BY Practice
-- Correct Answers with Questions
-- ============================================================


-- ★ EASY 1
-- EN : Count the number of restaurants in each city.
-- TM : ஒவ்வொரு city-லும் எத்தனை restaurants இருக்கின்றன என்று count செய்.

SELECT ci.city_name, COUNT(*) AS restaurant_count
FROM Restaurants r
JOIN Cities ci ON r.city_id = ci.city_id
GROUP BY ci.city_name
ORDER BY restaurant_count DESC;


-- ★ EASY 2
-- EN : Find the total number of orders for each payment mode.
-- TM : ஒவ்வொரு payment mode-லும் எத்தனை orders இருக்கின்றன?

SELECT payment_mode, COUNT(*) AS total_orders
FROM Orders
GROUP BY payment_mode
ORDER BY total_orders DESC;


-- ★ EASY 3
-- EN : Count how many customers registered each month in 2023.
-- TM : 2023-இல் ஒவ்வொரு மாதமும் எத்தனை customers register ஆனார்கள்?
-- NOTE: Use WHERE for non-aggregate filter (not HAVING). DATENAME for month name.

SELECT
    MONTH(registered_on)                  AS month_num,
    DATENAME(MONTH, registered_on)        AS month_name,
    COUNT(*)                              AS customer_count
FROM Customers
WHERE YEAR(registered_on) = 2023
GROUP BY MONTH(registered_on), DATENAME(MONTH, registered_on)
ORDER BY month_num;


-- ★★ MEDIUM 1
-- EN : Find the total revenue generated per restaurant.
--      Show restaurant name and total revenue. Include only delivered orders.
-- TM : ஒவ்வொரு restaurant-இன் total revenue என்ன? Delivered orders மட்டும் எடு.
-- NOTE: CTE used for clarity. INNER JOIN correct — only restaurants with orders shown.

WITH cte_restaurant_revenue AS
(
    SELECT restaurant_id, SUM(total_amount) AS total_revenue
    FROM Orders
    WHERE status = 'Delivered'
    GROUP BY restaurant_id
)
SELECT r.restaurant_name, crr.total_revenue
FROM Restaurants AS r
INNER JOIN cte_restaurant_revenue AS crr ON crr.restaurant_id = r.restaurant_id
ORDER BY crr.total_revenue DESC;


-- ★★ MEDIUM 2
-- EN : Find the average order amount per customer. Show customer name and average.
-- TM : ஒவ்வொரு customer-இன் average order amount என்ன?
-- NOTE: CTE keeps aggregation separate from presentation.

WITH cte_customer_avg AS
(
    SELECT customer_id, AVG(total_amount) AS avg_order_amount
    FROM Orders
    GROUP BY customer_id
)
SELECT c.full_name, cca.avg_order_amount
FROM Customers AS c
INNER JOIN cte_customer_avg AS cca ON cca.customer_id = c.customer_id
ORDER BY cca.avg_order_amount DESC;


-- ★★ MEDIUM 3
-- EN : Group menu items by restaurant and show min price, max price, and count of items.
-- TM : Restaurant-வாரியாக menu items-ஐ group செய். Min price, max price, item count காட்டு.

SELECT
    r.restaurant_name,
    MIN(mi.price)    AS min_price,
    MAX(mi.price)    AS max_price,
    COUNT(mi.item_id) AS total_items
FROM MenuItems AS mi
INNER JOIN Restaurants AS r ON r.restaurant_id = mi.restaurant_id
GROUP BY r.restaurant_name
ORDER BY r.restaurant_name;


-- ★★★ HARD 1
-- EN : Find total revenue per city (join Customers → Orders via city). Show city name.
-- TM : City-வாரியாக total revenue கண்டுபிடி. City name காட்டு.
-- NOTE: CTE handles 3-table join cleanly before final GROUP BY.

WITH cte_city_orders AS
(
    SELECT o.total_amount, ct.city_name
    FROM Orders AS o
    INNER JOIN Customers AS c  ON c.customer_id = o.customer_id
    INNER JOIN Cities    AS ct ON ct.city_id    = c.city_id
)
SELECT city_name, SUM(total_amount) AS total_revenue
FROM cte_city_orders
GROUP BY city_name
ORDER BY total_revenue DESC;


-- ★★★ HARD 2
-- EN : Group orders by YEAR and MONTH. Show year, month name, order count, total revenue.
--      Sort by year and month.
-- TM : Year மற்றும் Month-வாரியாக orders group செய். Month name, order count, revenue காட்டு.
-- NOTE: DATENAME for month name. ORDER BY on numeric month (not name) for correct sort.

SELECT
    YEAR(order_date)               AS order_year,
    MONTH(order_date)              AS month_num,
    DATENAME(MONTH, order_date)    AS month_name,
    COUNT(*)                       AS order_count,
    SUM(total_amount)              AS total_revenue
FROM Orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    DATENAME(MONTH, order_date)
ORDER BY order_year, month_num;


-- ★★★ HARD 3
-- EN : For each delivery agent, show total orders delivered, total revenue handled,
--      and their own rating. Group by agent.
-- TM : ஒவ்வொரு delivery agent-க்கும் delivered orders, handled revenue, மற்றும் rating காட்டு.
-- NOTE: CTE aggregates delivered orders. Outer query joins agent name + rating.

WITH cte_agent_summary AS
(
    SELECT
        o.agent_id,
        COUNT(*)                            AS total_orders_delivered,
        SUM(o.total_amount + o.delivery_fee) AS total_revenue_handled
    FROM Orders AS o
    WHERE o.status = 'Delivered'
    GROUP BY o.agent_id
)
SELECT
    da.agent_id,
    da.agent_name,
    cas.total_orders_delivered,
    cas.total_revenue_handled,
    da.rating
FROM DeliveryAgents AS da
INNER JOIN cte_agent_summary AS cas ON cas.agent_id = da.agent_id
ORDER BY cas.total_orders_delivered DESC;


-- ============================================================
-- END OF FILE
-- ============================================================