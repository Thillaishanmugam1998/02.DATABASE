SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Customers'

SELECT phone, cast (phone as bigint) FROM Customers
SELECT phone, cast (phone as int) FROM Customers
--Msg 248, Level 16, State 1, Line 13 The conversion of the varchar value '9876543210' overflowed an int column.

SELECT order_date,format(order_date,'dd-MMM-yyy') FROM  Orders

select total_amount, concat (N'₹ ',cast(total_amount as varchar)) from Orders

select valid_from,valid_to,DATEDIFF(DAY,valid_from,valid_to) from Coupons

select
    case 
        when food_rating = 4 then 'GOOD'
        when food_rating = 3 then 'Averge'
        else 'Poor'
    end  as 
       food_rating,
    case 
        when  delivery_rating = 4 then 'GOOD'
        when delivery_rating  = 3 then 'Averge'
        else 'Poor'
    end as delivery_rating
    from Reviews


-- ★★★ HARD 1
-- EN : Create a computed column expression (not persisted) in a SELECT that shows
--      each order's GST amount (18% of total_amount) as DECIMAL(10,2),
--      total with GST, and a VARCHAR label like 'GST: ₹XX.XX'.

