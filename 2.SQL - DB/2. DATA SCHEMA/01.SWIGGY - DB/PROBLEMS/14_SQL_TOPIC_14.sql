-- ============================================================
--  TOPIC 14 — Logical Operators  |  FoodDeliveryDB
--  Correct Answers — All 9 Queries
-- ============================================================

-- ★ EASY 1
-- Show restaurants that are OPEN and have rating >= 4.0.
SELECT *
FROM Restaurants
WHERE is_open = 1
  AND rating >= 4.0;


-- ★ EASY 2
-- Show orders that are NOT cancelled and NOT placed.
SELECT *
FROM Orders
WHERE status NOT IN ('Cancelled', 'Placed');


-- ★ EASY 3
-- Show menu items that are veg OR price < 100.
SELECT *
FROM MenuItems
WHERE is_veg = 1
   OR price < 100;


-- ★★ MEDIUM 1
-- Show customers who are active (is_active=1)
-- AND registered in 2023
-- AND from city_id IN (1,2,3).
SELECT *
FROM Customers
WHERE is_active = 1
  AND YEAR(registered_on) = 2023        -- integer, not string '2023'
  AND city_id IN (1, 2, 3);


-- ★★ MEDIUM 2
-- Show orders where (status='Delivered' AND payment_mode='UPI')
--                OR (status='Cancelled' AND discount > 0).
SELECT *
FROM Orders
WHERE (status = 'Delivered' AND payment_mode = 'UPI')
   OR (status = 'Cancelled'  AND discount > 0);


-- ★★ MEDIUM 3
-- Show delivery agents who are active
-- AND (vehicle_type='Bike' OR rating > 4.5).
SELECT *
FROM DeliveryAgents
WHERE is_active = 1
  AND (vehicle_type = 'Bike' OR rating > 4.5);


-- ★★★ HARD 1
-- Show all menu items where NOT (is_veg = 1 AND price > 300).
-- De Morgan's Law: NOT (A AND B) = (NOT A) OR (NOT B)
--   NOT (is_veg = 1)   => is_veg != 1
--   NOT (price > 300)  => price <= 300   (boundary 300 must be INCLUDED)
--   Combined with OR, not AND
SELECT *
FROM MenuItems
WHERE is_veg != 1
   OR price <= 300;


-- ★★★ HARD 2
-- Find customers who have placed an order with status='Delivered'
-- AND also have at least one order with status='Cancelled'.
SELECT customer_id
FROM Orders
WHERE status IN ('Delivered', 'Cancelled')
GROUP BY customer_id
HAVING COUNT(CASE WHEN status = 'Delivered' THEN 1 END) >= 1   -- must have Delivered
   AND COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) >= 1;  -- must have Cancelled


-- ★★★ HARD 3
-- Show restaurants where:
--   (category_id IN (1,4) AND rating > 4.2)
--   OR (city_id = 1 AND is_open = 1 AND rating >= 4.0)
--   BUT NOT (restaurant_id IN (2, 8)).
SELECT *
FROM Restaurants
WHERE (
        (category_id IN (1, 4) AND rating > 4.2)
     OR (city_id = 1 AND is_open = 1 AND rating >= 4.0)
      )
  AND restaurant_id NOT IN (2, 8);

-- ============================================================
--  END OF FILE
-- ============================================================