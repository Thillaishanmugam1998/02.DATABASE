 SELECT 
	customer.customer_id,
	first_name || ' ' || last_name AS fullname,
	MAX(payment.payment_id) AS count
FROM
    payment
INNER JOIN 
	 customer
ON
	payment.customer_id = customer.customer_idxz
GROUP BY
	 customer.customer_id
ORDER BY
 	customer.customer_id


select * from customer