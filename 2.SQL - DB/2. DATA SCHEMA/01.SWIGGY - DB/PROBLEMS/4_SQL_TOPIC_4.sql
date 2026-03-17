-- =====================================================
-- SQL PRACTICE : CAST, CONVERT, FORMAT, INFORMATION_SCHEMA
-- Author : Practice Script
-- =====================================================

-- =====================================================
-- ★ EASY 1
-- Show all column data types of Orders table
-- =====================================================

SELECT
COLUMN_NAME,
DATA_TYPE,
CHARACTER_MAXIMUM_LENGTH,
NUMERIC_PRECISION,
NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders';

-- =====================================================
-- ★ EASY 2
-- Show phone number cast as INT and BIGINT
-- =====================================================

SELECT
phone,
CAST(phone AS BIGINT) AS phone_bigint
FROM Customers;

-- This will cause overflow error
-- INT max = 2147483647
-- phone numbers exceed this range

SELECT
phone,
CAST(phone AS INT) AS phone_int
FROM Customers;

-- =====================================================
-- ★ EASY 3
-- Format order_date as DD-Mon-YYYY
-- =====================================================

SELECT
order_date,
FORMAT(order_date,'dd-MMM-yyyy') AS formatted_order_date
FROM Orders;

-- =====================================================
-- ★ MEDIUM 1
-- Convert total_amount to VARCHAR and add ₹ symbol
-- =====================================================

SELECT
total_amount,
CONCAT('₹ ', CAST(total_amount AS VARCHAR(20))) AS formatted_amount
FROM Orders;

-- =====================================================
-- ★ MEDIUM 2
-- Show difference in days between coupon validity
-- =====================================================

SELECT
valid_from,
valid_to,
DATEDIFF(DAY, valid_from, valid_to) AS valid_days
FROM Coupons;

-- =====================================================
-- ★ MEDIUM 3
-- Show rating category using CAST inside CASE
-- =====================================================

SELECT
food_rating,
CASE
WHEN CAST(food_rating AS INT) IN (4,5) THEN 'Good'
WHEN CAST(food_rating AS INT) = 3 THEN 'Average'
ELSE 'Poor'
END AS food_rating_status,

```
delivery_rating,
CASE
    WHEN CAST(delivery_rating AS INT) IN (4,5) THEN 'Good'
    WHEN CAST(delivery_rating AS INT) = 3 THEN 'Average'
    ELSE 'Poor'
END AS delivery_rating_status
```

FROM Reviews;

-- =====================================================
-- ★ HARD 1
-- Compute GST (18%) and total with GST
-- =====================================================

SELECT
order_id,
total_amount,

```
CAST(total_amount * 0.18 AS DECIMAL(10,2)) AS gst_amount,

CAST(total_amount * 1.18 AS DECIMAL(10,2)) AS total_with_gst,

CONCAT('GST: ₹', CAST(total_amount * 0.18 AS DECIMAL(10,2))) 
AS gst_label
```

FROM Orders
ORDER BY order_id;

-- =====================================================
-- ★ HARD 2
-- Show MenuItems data along with column data types
-- =====================================================

SELECT
m.*,
c.COLUMN_NAME,
c.DATA_TYPE
FROM MenuItems m
JOIN INFORMATION_SCHEMA.COLUMNS c
ON c.TABLE_NAME = 'MenuItems'
AND c.TABLE_SCHEMA = 'dbo'
ORDER BY c.ORDINAL_POSITION;

-- =====================================================
-- ★ HARD 3
-- Demonstrate implicit vs explicit conversion
-- =====================================================

-- Safe conversion using TRY_CAST

SELECT
total_amount,
order_number,
total_amount + TRY_CAST(order_number AS DECIMAL(10,2))
AS safe_total_using_try_cast
FROM Orders;

-- Safe conversion using TRY_CONVERT

SELECT
total_amount,
order_number,
total_amount + TRY_CONVERT(DECIMAL(10,2), order_number)
AS safe_total_using_try_convert
FROM Orders;

-- =====================================================
-- END OF SCRIPT
-- =====================================================
