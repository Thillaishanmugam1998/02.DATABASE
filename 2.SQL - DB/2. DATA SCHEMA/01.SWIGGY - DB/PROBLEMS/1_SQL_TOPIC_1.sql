-- ============================================================
--  TOPIC 01 — SQL SELECT  |  FoodDeliveryDB
--  Final Correct Answers
-- ============================================================

-- Q1. Show all customers.
SELECT * 
FROM Customers;

-- Q2. Show only the full_name and email of all customers.
SELECT full_name, email 
FROM Customers;

-- Q3. Show the first 5 rows from the MenuItems table.
SELECT TOP 5 * 
FROM MenuItems 
ORDER BY item_id ASC;

-- Q4. Show restaurant name, rating, and city_id for all open restaurants.
SELECT restaurant_name, rating, city_id 
FROM Restaurants 
WHERE is_open = 1;

-- Q5. Show distinct payment modes used in the Orders table.
SELECT DISTINCT payment_mode 
FROM Orders;

-- Q6. Show order_id, order_date, total_amount, delivery_fee and
--     net_payable = total_amount + delivery_fee - discount.
SELECT 
    order_id,
    order_date,
    total_amount,
    delivery_fee,
    (total_amount + delivery_fee - discount) AS net_payable
FROM Orders;

-- Q7. Show each menu item with restaurant name, category name,
--     city name, and price. Only available items (is_available = 1).
SELECT 
    MI.item_name,
    R.restaurant_name,
    RC.category_name,
    C.city_name,
    MI.price
FROM MenuItems AS MI
LEFT JOIN Restaurants          AS R  ON R.restaurant_id  = MI.restaurant_id
LEFT JOIN RestaurantCategories AS RC ON RC.category_id   = R.category_id
LEFT JOIN Cities               AS C  ON C.city_id        = R.city_id
WHERE MI.is_available = 1;

-- Q8. Show all orders with customer name, restaurant name,
--     agent name (Not Assigned if null), status, total_amount.
--     Sorted by order_date DESC.
SELECT 
    C.full_name,
    R.restaurant_name,
    ISNULL(DA.agent_name, 'Not Assigned') AS Delivery_Agent_Name,
    O.status,
    O.total_amount
FROM Orders AS O
LEFT JOIN Customers      AS C  ON C.customer_id    = O.customer_id
LEFT JOIN Restaurants    AS R  ON R.restaurant_id  = O.restaurant_id
LEFT JOIN DeliveryAgents AS DA ON DA.agent_id      = O.agent_id
ORDER BY O.order_date DESC;

-- Q9. Show full order details: order_number, customer name,
--     restaurant name, item name, quantity, unit_price, line total.
SELECT 
    O.order_number,
    C.full_name,
    R.restaurant_name,
    MI.item_name,
    OI.quantity,
    OI.unit_price,
    (OI.quantity * OI.unit_price) AS line_total
FROM Orders AS O
LEFT JOIN Customers   AS C  ON C.customer_id   = O.customer_id
LEFT JOIN Restaurants AS R  ON R.restaurant_id = O.restaurant_id
LEFT JOIN OrderItems  AS OI ON OI.order_id     = O.order_id
LEFT JOIN MenuItems   AS MI ON MI.item_id      = OI.item_id;

-- ============================================================