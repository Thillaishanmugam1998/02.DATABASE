-- ★ EASY 1
-- EN : Show order_id, total_amount, delivery_fee and calculate 
-- final_bill = total_amount + delivery_fee - discount.

SELECT order_id,total_amount,(total_amount + (delivery_fee-discount)) AS FINAL_BILL FROM ORDERS

-- ★ EASY 2
-- EN : Show menu items where price is NOT equal to 200.
SELECT * FROM MenuItems WHERE PRICE != 200


-- ★ EASY 3
-- EN : Show all restaurants where rating > 4.3 AND is_open = 1.
SELECT * FROM Restaurants WHERE rating < 4.3 AND is_open=1


-- ★★ MEDIUM 1
-- EN : For each order, calculate: profit_margin = (total_amount - discount - delivery_fee) / total_amount * 100.
--      Show as percentage with 2 decimal places.

SELECT CAST ((((total_amount - (DISCOUNT+delivery_fee)) / total_amount) * 100) AS decimal(10,2)) AS PROFIT_MARGIN, * FROM Orders

-- ★★ MEDIUM 2
-- EN : Show customers where (city_id * 10) + customer_id > 50. (Arithmetic in WHERE)

SELECT * FROM Customers WHERE (city_id * 10) + customer_id > 50

-- ★★ MEDIUM 3
-- EN : Show orders where total_amount % 100 = 0 (evenly divisible by 100).

SELECT * FROM Orders WHERE total_amount%100 = 0
\
-- ★★★ HARD 1
-- EN : Assign a tier to each customer based on total spent:
--      Use variables (@gold_min, @silver_min) and assignment operators in a query.