-- ============================================================
--  TOPIC 03 — DML (Data Manipulation Language)  |  FoodDeliveryDB
--  Final Correct Answers
-- ============================================================

-- Q1. Insert a new city 'Vellore', state 'Tamil Nadu' into the Cities table.
INSERT INTO Cities (city_name, state)
VALUES ('Vellore', 'Tamil Nadu');

-- Q2. Update the rating of restaurant_id = 3 to 4.8.
UPDATE Restaurants
SET rating = 4.8
WHERE restaurant_id = 3;

-- Q3. Delete all coupons that have expired (valid_to < GETDATE()).
DELETE FROM Coupons
WHERE valid_to < GETDATE();

-- Q4. Insert 3 new customers into the Customers table at once (one INSERT statement).
INSERT INTO Customers (full_name, email, phone, city_id, registered_on, is_active)
VALUES
    ('Tamilvani',        'tamil@gmail.com',      '8675692630', 4, CAST(GETDATE() AS DATE), 1),
    ('Thillai Shanmugam','thillai@gmail.com',     '7598397824', 4, CAST(GETDATE() AS DATE), 1),
    ('Tamizhilai',       'tamil1701@gmail.com',   '9080323760', 4, CAST(GETDATE() AS DATE), 1);

-- Q5. Update all orders where status = 'Placed' and order_date < 7 days ago
--     — set their status to 'Cancelled'.
UPDATE Orders
SET status = 'Cancelled'
WHERE status = 'Placed'
  AND order_date < DATEADD(DAY, -7, GETDATE());

-- Q6. Increase the price of all non-veg menu items by 10%.
UPDATE MenuItems
SET price = price * 1.10
WHERE is_veg = 0;

-- Q7. Insert a new order for customer_id=1, restaurant_id=5 with 2 menu items:
--     item_id=11 qty=1, item_id=12 qty=2. Use a transaction.
BEGIN TRY
    BEGIN TRANSACTION

        DECLARE @order_id    INT
        DECLARE @price_1     DECIMAL(10,2)
        DECLARE @price_2     DECIMAL(10,2)
        DECLARE @total_price DECIMAL(10,2)

        -- Get prices from MenuItems
        SELECT @price_1 = price FROM MenuItems WHERE item_id = 11;
        SELECT @price_2 = price FROM MenuItems WHERE item_id = 12;

        -- Calculate total
        SET @total_price = (@price_1 * 1) + (@price_2 * 2);

        -- Insert into Orders
        INSERT INTO Orders (customer_id, restaurant_id, order_number, status, payment_mode,
                            total_amount, discount, delivery_fee)
        VALUES (1, 5, 'ORD-NEW-001', 'Placed', 'Cash', @total_price, 0, 0);

        -- Get new order_id
        SET @order_id = SCOPE_IDENTITY();

        -- Insert into OrderItems
        INSERT INTO OrderItems (order_id, item_id, quantity, unit_price)
        VALUES (@order_id, 11, 1, @price_1),
               (@order_id, 12, 2, @price_2);

    COMMIT TRANSACTION
    PRINT 'Transaction completed successfully.';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
    ROLLBACK TRANSACTION;
END CATCH

-- Q8. Soft delete — set is_active = 0 for customers who have NOT placed
--     any order in the last 180 days.
UPDATE Customers
SET is_active = 0
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM Orders
    WHERE order_date >= DATEADD(DAY, -180, GETDATE())
);

-- Q9. Update total_amount of all orders by recalculating from OrderItems.

-- Method 1 — Subquery
UPDATE Orders
SET total_amount = (
    SELECT SUM(quantity * unit_price)
    FROM OrderItems
    WHERE OrderItems.order_id = Orders.order_id
);

-- Method 2 — CTE (Recommended)
WITH OrderTotals AS
(
    SELECT
        order_id,
        SUM(quantity * unit_price) AS total
    FROM OrderItems
    GROUP BY order_id
)
UPDATE o
SET o.total_amount = t.total
FROM Orders AS o
JOIN OrderTotals AS t ON o.order_id = t.order_id;

-- ============================================================