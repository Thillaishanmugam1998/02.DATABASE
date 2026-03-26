
-- ★ EASY 1
-- EN : Show the rounded total_amount (to nearest 10) for each order.

select round(total_amount,-1) from Orders


-- ★ EASY 2
-- EN : Show ABS value of (total_amount - 400) for each order.

select abs(total_amount - 400) as absvalue from Orders

-- ★ EASY 3
-- EN : Show CEILING and FLOOR of each menu item price divided by 7.
select (price/7),CEILING(price/7),floor(price/7) from MenuItems



-- ★★ MEDIUM 1
-- EN : Calculate total tax (18% GST) per order. Round to 2 decimal places.
--      Show order_id, total_amount, gst_amount, total_with_gst.

select order_id,total_amount,round((total_amount*(0.18)),2) as gst_amount,
round((total_amount*(0.18)),2)+ total_amount as total_with_gst from Orders



-- ★★ MEDIUM 2
-- EN : Show orders where total_amount POWER of 0.5 (square root) is > 20.
--      Use SQRT or POWER function.