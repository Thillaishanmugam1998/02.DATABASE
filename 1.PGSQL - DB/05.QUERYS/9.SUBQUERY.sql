Section 7. Subquery
Subquery – write a query nested inside another query.
Correlated Subquery – show you how to use a correlated subquery to perform a query that depends on the values of the current row being processed.
ANY  – retrieve data by comparing a value with a set of values returned by a subquery.
ALL – query data by comparing a value with a list of values returned by a subquery.
EXISTS  – check for the existence of rows returned by a subquery.
--------------------------------------------------------------------------------------------------------------------------------------------
USE THIS TABLE:
--------------
SELECT * FROM account_master
SELECT * FROM transactions

1. Subquery
Definition: A subquery is a query nested inside another query, typically used in the WHERE, SELECT, or FROM clause.

Example Query: Find all customers from the account_master table who have made at least one transaction with an amount greater than 2000.
select account_id from transactions where transaction_amount > 2000

SELECT customer_name, account_number
FROM account_master
WHERE account_id IN (
    SELECT account_id
    FROM transactions
    WHERE transaction_amount > 2000
);

SELECT customer_name,account_number,account_balance
FROM account_master
WHERE account_balance >(SELECT avg(transaction_amount) FROM transactions) AND account_status = 'Active'
------------------------------------------------------------------------------------------------------------------------
1. Subquery Questions
Q1: Find all customers whose account balance is less than the total sum of all deposits made in the transactions table.

SELECT customer_name,account_number,account_balance
FROM account_master
WHERE account_balance < (SELECT sum(transaction_amount) FROM transactions WHERE transaction_type = 'Deposit')
	
Q2: List customers who have an account type of 'Savings' and have made at least one transaction greater than 1000.
Q3: Identify branches where the average account balance is higher than the average transaction amount across all transactions.

SELECT am.branch_name, AVG(account_balance)
FROM account_master AS am
WHERE account_balance > (SELECT AVG(transaction_amount) FROM transactions)
GROUP BY branch_name 
	
Q4: Retrieve the customer names and account numbers for accounts opened after the earliest transaction date in the transactions table.
	
SELECT customer_name,account_number
FROM account_master
WHERE open_date < (SELECT MIN(transaction_date) FROM transactions)
	
