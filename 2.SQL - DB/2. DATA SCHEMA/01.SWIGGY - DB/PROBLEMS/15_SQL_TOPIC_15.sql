-- ============================================================
--  TOPIC 15 — IN / BETWEEN / NOT IN / EXISTS / ANY / ALL
--  FoodDeliveryDB — Correct Answers (All 9 Queries)
-- ============================================================


-- ★ EASY 1
-- EN : Show orders where payment_mode IN ('UPI', 'Card').
SELECT *
FROM Orders
WHERE payment_mode IN ('UPI', 'Card');


-- ★ EASY 2
-- EN : Show menu items priced BETWEEN 100 AND 300.
SELECT *
FROM MenuItems
WHERE price BETWEEN 100 AND 300;


-- ★ EASY 3
-- EN : Show restaurants with category_id NOT IN (5, 6, 7).
SELECT *
FROM Restaurants
WHERE category_id NOT IN (5, 6, 7);


-- ★★ MEDIUM 1
-- EN : Show customers who have NOT placed any orders (use NOT EXISTS).
SELECT *
FROM Customers AS c1
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders AS o
    WHERE o.customer_id = c1.customer_id
);


-- ★★ MEDIUM 2
-- EN : Show menu items whose price > ANY price in restaurant_id = 1's menu.
SELECT *
FROM MenuItems
WHERE price > ANY (
    SELECT price
    FROM MenuItems
    WHERE restaurant_id = 1
);


-- ★★ MEDIUM 3
-- EN : Show customers who exist in BOTH Customers table AND have placed an order (use EXISTS).
SELECT *
FROM Customers AS c
WHERE EXISTS (
    SELECT 1
    FROM Orders AS o
    WHERE o.customer_id = c.customer_id
);


-- ★★★ HARD 1
-- EN : Show non-veg menu items whose price > ALL prices of veg items in the same restaurant.
SELECT *
FROM MenuItems AS mi
WHERE is_veg = 0
  AND price > ALL (
      SELECT price
      FROM MenuItems AS mi2
      WHERE is_veg = 1
        AND mi2.restaurant_id = mi.restaurant_id
  );


-- ★★★ HARD 2
-- EN : Show restaurants that have at least one order with total_amount > 500.
--      Write both EXISTS and IN approaches.

-- Approach 1 : EXISTS
SELECT DISTINCT o1.restaurant_id
FROM Orders AS o1
WHERE EXISTS (
    SELECT 1
    FROM Orders AS o2
    WHERE o2.restaurant_id = o1.restaurant_id   -- same restaurant link
      AND o2.total_amount > 500
);

-- Approach 2 : IN
SELECT DISTINCT restaurant_id
FROM Orders
WHERE restaurant_id IN (
    SELECT restaurant_id
    FROM Orders
    WHERE total_amount > 500
);


-- ★★★ HARD 3
-- EN : Show customers whose total spend is BETWEEN the average spend
--      of customers in city_id=1 AND the average spend of customers in city_id=2.

-- Key logic:
--   Step 1 : SUM(total_amount) per customer  → each customer's total spend
--   Step 2 : AVG of those sums for city 1    → lower / upper bound
--   Step 3 : AVG of those sums for city 2    → other bound
--   Step 4 : HAVING total_spend BETWEEN city1_avg AND city2_avg

SELECT
    o.customer_id,
    SUM(o.total_amount) AS total_spend
FROM Orders AS o
JOIN Customers AS c ON c.customer_id = o.customer_id
GROUP BY o.customer_id
HAVING SUM(o.total_amount) BETWEEN

    -- City 1 : average of per-customer totals
    (SELECT AVG(city1.total_spend)
     FROM (
         SELECT o1.customer_id, SUM(o1.total_amount) AS total_spend
         FROM Orders AS o1
         JOIN Customers AS c1 ON c1.customer_id = o1.customer_id
         WHERE c1.city_id = 1
         GROUP BY o1.customer_id
     ) AS city1)

    AND

    -- City 2 : average of per-customer totals
    (SELECT AVG(city2.total_spend)
     FROM (
         SELECT o2.customer_id, SUM(o2.total_amount) AS total_spend
         FROM Orders AS o2
         JOIN Customers AS c2 ON c2.customer_id = o2.customer_id
         WHERE c2.city_id = 2
         GROUP BY o2.customer_id
     ) AS city2);

-- ============================================================
--  END OF FILE
-- ============================================================