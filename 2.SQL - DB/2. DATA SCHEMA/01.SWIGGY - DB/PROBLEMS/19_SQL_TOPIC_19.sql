-- ★ EASY 1
-- EN : Show the year and month of each order date.
select year(order_date),month(order_date) from Orders

-- ★ EASY 2
-- EN : Show how many days ago each order was placed (from today).
select DATEDIFF(DAY,order_date,GETDATE()) from Orders

-- ★ EASY 3
-- EN : Show the weekday name for each order (Monday, Tuesday...).
select  datename(WEEKDAY,order_date)  from Orders


-- ★★ MEDIUM 1
-- EN : Show orders placed in the last 90 days. Use DATEADD.
select * from Orders where order_date > DATEADD(DAY,-90,GETDATE())


-- ★★ MEDIUM 2
-- EN : Find how many days each customer has been registered (from registered_on to today).
select DATEDIFF(day,registered_on,GETDATE()) from Customers

-- ★★ MEDIUM 3
-- EN : Show the first day of the month for each order_date.
select order_date from Orders

select DATETRUNC(time,order_date) from Orders