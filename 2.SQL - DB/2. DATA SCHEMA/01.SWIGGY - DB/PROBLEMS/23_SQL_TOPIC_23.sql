-- ★ EASY 1
-- EN : Find the total number of orders in the database.
SELECT count(*) as total_orders 
FROM Orders

-- ★ EASY 2
-- EN : Find the maximum, minimum, and average menu item price.
select max(price) as maximum_price,
min(price) as minimum_price, 
avg(price) as average_price 
from MenuItems

-- ★ EASY 3
-- EN : Find the total revenue from all delivered orders.
select sum(total_amount) as total_revenue
from Orders 
where status = 'Delivered'

-- ★★ MEDIUM 1
-- EN : Show COUNT, SUM, AVG of orders grouped by restaurant_id.

select restaurant_id ,count(*) as countOfRestaurent,
sum(total_amount) as totalAmount, avg(total_amount) as avgAmount
from Orders 
group by restaurant_id


-- ★★ MEDIUM 2
-- EN : Find the customer who has spent the most money overall.
SELECT TOP 1 cus.customer_id,cus.full_name,sum(ord.total_amount) as total_spent 
FROM Customers AS cus 
INNER JOIN Orders AS ord ON ord.customer_id = cus.customer_id
GROUP BY cus.customer_id,cus.full_name
ORDER BY total_spent desc


-- ★★ MEDIUM 3
-- EN : Show COUNT(DISTINCT customer_id) — unique customers who ordered per restaurant.

select restaurant_id,count(distinct customer_id) as uniqueCustomers 
from Orders
group by restaurant_id order by restaurant_id


-- ★★★ HARD 1
-- EN : Show for each restaurant:
--      total_orders, total_revenue, avg_revenue, best_order (MAX),
--      worst_order (MIN), unique_customers.

