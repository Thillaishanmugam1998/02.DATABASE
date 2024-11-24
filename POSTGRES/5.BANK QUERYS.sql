PostgreSQL evaluates the GROUP BY clause after the FROM and WHERE clauses and before the HAVING SELECT, DISTINCT, ORDER BY and LIMIT clauses.

	
CREATE TABLE IF NOT EXISTS BankAccountTransactions(
	TransactionID	SERIAL PRIMARY KEY,
	AccountNumbPostgreSQL evaluates the GROUP BY clause after the FROM and WHERE clauses and before the HAVING SELECT, DISTINCT, ORDER BY and LIMIT clauses.r Varchar(20) NOT NULL,
	TransactionType Varchar(20) NOT NULL,
	TransactionAmount Numeric(12,2) NOT NULL,
	AccountBalance Numeric (12,2) NOT NULL,
	TransactionDate DATE,
	Transactionstatus varchar(20) NOT NULL,
	TransactionMethod Varchar(10) NOT NULL
);

SELECT * FROM BankAccountTransactions

	
INSERT INTO BankAccountTransactions(AccountNumber,TransactionType,TransactionAmount,AccountBalance,TransactionDate,Transactionstatus,TransactionMethod)
VALUES
('100','CREDIT',50000,500000,'01-01-2024','FAIL','ONLINE'),
('200','CREDIT',500,2500,'01-01-2024','SUCCESS','BANK'),
('300','CREDIT',15000,25000,'02-01-2024','PENDING','ONLINE'),
('400','CREDIT',100,250,'04-01-2024','SUCCESS','ONLINE'),
('500','CREDIT',50,70,'05-01-2024','SUCCESS','ONLINE'),
('600','CREDIT',5000,10000,'10-01-2024','SUCCESS','ONLINE'),
('700','CREDIT',2000,20000,'01-02-2024','SUCCESS','ONLINE'),
('800','CREDIT',35000,50000,'01-03-2024','SUCCESS','BANK'),
('900','CREDIT',100000,1000000,'01-03-2024','FAIL','ATM'),
('110','DEBIT',100000,400000,'02-01-2024','SUCCESS','ONLINE'),
('220','DEBIT',50000,500000,'03-01-2024','SUCCESS','ONLINE'),
('330','DEBIT',50000,500000,'04-01-2024','SUCCESS','ATM'),
('440','DEBIT',300,1200,'04-01-2024','FAIL','ONLINE'),
('550','DEBIT',2500,5000,'04-01-2024','SUCCESS','ONLINE'),
('660','DEBIT',80000,234000,'01-04-2024','SUCCESS','ONLINE'),
('770','DEBIT',200000,1000000,'01-05-2024','SUCCESS','ONLINE'),
('880','DEBIT',2,110,'01-05-2024','SUCCESS','ONLINE'),
('990','DEBIT',150000,2540000,'30-05-2024','SUCCESS','ONLINE');

--To Get the total amount of credit transaction on particular date?
SELECT TransactionType, SUM(TransactionAmount),Transactionstatus
FROM BankAccountTransactions
WHERE TransactionDate = '01-01-2024' AND Transactionstatus = 'SUCCESS'
GROUP BY TransactionType,Transactionstatus
HAVING TransactionType = 'CREDIT'

--To get total credit amount
SELECT SUM(TransactionAmount)
FROM BankAccountTransactions
WHERE TransactionType = 'CREDIT'


--To get the Highest Bank Balance 
SELECT MAX(AccountBalance) AS HIGH_ACCOUNT_BALANCE
FROM BankAccountTransactions

SELECT AccountNumber,MAX(AccountBalance) as 

SELECT Transactionstatus, COUNT(*)
FROM BankAccountTransactions
	WHERE TransactionType = 'DEBIT'
GROUP BY Transactionstatus
HAVING Transactionstatus = 'SUCCESS'


SELECT COUNT(*) AS OnlineSuccessCount
FROM BankAccountTransactions
WHERE TransactionMethod = 'ONLINE' AND Transactionstatus = 'SUCCESS';

