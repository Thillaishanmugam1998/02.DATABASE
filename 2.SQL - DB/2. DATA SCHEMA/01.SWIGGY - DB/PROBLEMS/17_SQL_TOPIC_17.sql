-- ★ EASY 1
-- EN : Show all customer names in UPPERCASE.
select upper(full_name) from Customers

-- ★ EASY 2
-- EN : Show the length of each restaurant name.
select len(restaurant_name) from Restaurants

-- ★ EASY 3
-- EN : Show the first 5 characters of each customer's email.
select LEFT(email,5) from Customers


-- ★★ MEDIUM 1
-- EN : Extract the username (part before @) from each customer's email.

select left(email,(CHARINDEX('@',email)-1)) as username from Customers

-- ★★ MEDIUM 2
-- EN : Replace all spaces in restaurant names with underscores.
select REPLACE(restaurant_name,' ','_') from Restaurants

-- ★★ MEDIUM 3
-- EN : Show customer names that contain the letter 'a' (case-insensitive).
--      Use LIKE or CHARINDEX.

select full_name from Customers where full_name like '%a%'
or
select full_name from Customers where CHARINDEX('a',full_name) != 0


-- ★★★ HARD 1
-- EN : Build a formatted delivery label string:
--      'ORDER #[order_number] | [customer_name] | [city_name] | ₹[total_amount]'
--      Use CONCAT or + operator.


select 'ORDER #'+order_number+ '|' + full_name + '|'+ city_name + '|' + N'₹'+ cast (total_amount as varchar) from Orders as od
inner join Customers as c on c.customer_id = od.customer_id
inner join Cities as ct on ct.city_id = c.city_id


 
-- ★★★ HARD 2
-- EN : Show the domain part of each customer's email (part after @).
--      Then group by domain and count how many customers use each domain.

select SUBSTRING(email,(CHARINDEX('@',email)+1),len(email)),count(*) from Customers
group by SUBSTRING(email,(CHARINDEX('@',email)+1),len(email))




