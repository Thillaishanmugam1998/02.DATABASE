Section 9. Modifying Data
In this section, you will learn how to insert data into a table with the INSERT statement, modify existing data with the UPDATE statement, and remove data with the DELETE statement. Additionally, you will learn how to use the UPSERT statement to merge data.

Insert – guide you on how to insert a single row into a table.
Insert multiple rows – show you how to insert multiple rows into a table.
Update – update existing data in a table.
Update join – update values in a table based on values in another table.
Delete – delete data in a table.
Upsert – insert or update data if the new row already exists in the table.
***********************************************************************************************************************
--01.INSERT:
--CREATE A TABLE
CREATE TABLE links(
	id SERIAL PRIMARY KEY,
	url VARCHAR(100) NOT NULL,
	name VARCHAR(50) NOT NULL,
	description VARCHAR(100),
	last_update DATE
)

--SELECT TABLE
SELECT * FROM links

--INSERT VALUES INTO TABLE
INSERT INTO links(url,name,description,last_update)
VALUES
	('www.Google.com','Google','This is ''Google'' Website','2024-11-03')

--INSERT VALUES INTO TABLE AND RETRUN INSERTED ROW DATA
INSERT INTO links(url,name,description,last_update)
VALUES
	('www.Amazon.com','Amazon','This is ''Amazon'' Website','2024-11-05')
RETURNING *

--INSERT VALUES INTO TABLE AND RETRUN ID
INSERT INTO links(url,name,description,last_update)
VALUES
	('www.Flipkart.com','Flipkart','This is Flipkart Website','2024-11-01')
RETURNING id

--INSERT VALUES INTO TABLE AND RETRUN SPECIFIC COLOUMN
INSERT INTO links(url,name,description,last_update)
VALUES
	('www.Flipkart.com','Flipkart','This is Flipkart Website','2024-11-01')
RETURNING description
***********************************************************************************************************************
--02.INSET MULTIPLE COLOUMN
INSERT INTO links(url,name,description,last_update)
VALUES
	('www.github.com','github','This is github Website','2024-11-05'),
	('www.salesforce.net','SalesForce','IT','2024-11-08'),
	('www.tatasteel.ae','SteelTATA','TATA Groups','2024-11-13')
RETURNING id
***********************************************************************************************************************
--03.UPDATE QUERY
UPDATE links
SET
	last_update = '2025-01-01'
WHERE 
	id = 8
RETURNING *

--UPDATE MULTIPLE COLOUMNS
UPDATE links
SET
	last_update = '2024-12-01',
	name = 'TATA Steels'
WHERE 
	id = 8
RETURNING *
***********************************************************************************************************************
--04.DELETE A TABLE ROW
DELETE FROM links
WHERE id=7
RETURNING *
***********************************************************************************************************************
--05.UPSERT EXAMPLE
'INSERT + UPDATE = INSERT'
--CREATE A NEW TABLE
CREATE TABLE inventory(
   id INT PRIMARY KEY,
   name VARCHAR(255) NOT NULL,
   price DECIMAL(10,2) NOT NULL,
   quantity INT NOT NULL
);

--INSERT VALUES INTO A TABLE
INSERT INTO inventory(id, name, price, quantity)
VALUES
	(1, 'A', 15.99, 100),
	(2, 'B', 25.49, 50),
	(3, 'C', 19.95, 75)
RETURNING *;

--SELET FROM TABLE
SELECT * FROM inventory ORDER BY id

--IF I INSERT ALREADY INSERT VALUES IT WILL DUPLICATE
INSERT INTO inventory(id, name, price, quantity)
VALUES
	(4, 'A', 15.99, 500)
RETURNING *;

UPDATE inventory
SET price = 20 
WHERE id = 1
RETURNING *

	
'ABOVE, INSERT WILL DUPLICATE SAME PRODUCT NAME, PRICE, IT WILL CONFLICT, SO USE UPSERT'
--UPSERT INSERT EXAMPLE
INSERT INTO inventory(id,name,price,quantity)
VALUES
	(3,'C',500,250)
ON CONFLICT (id)
DO UPDATE SET
	price = EXCLUDED.price,
    quantity = EXCLUDED.quantity


INSERT INTO inventory(id,name,price,quantity)
VALUES
	(5,'D',55.2,10)
ON CONFLICT (id)
DO UPDATE SET
	price = EXCLUDED.price,
    quantity = EXCLUDED.quantity
RETURNING *

--DO NOATHING KEYWORD
INSERT INTO inventory(id,name,price,quantity)
VALUES
	(5,'D',55.2,10)
ON CONFLICT (id)
DO NOTHING
RETURNING *