--Section 13. PostgreSQL Constraints
----------------------------------------------------------------------------------------------------------------------------------------
--1) Creating a table with a primary key that consists of one column
CREATE TABLE orders(
	order_id SERIAL PRIMARY KEY,
	customer_id VARCHAR(255) NOT NULL,
	order_date DATE NOT NULL
)

SELECT * FROM orders

INSERT INTO orders(customer_id,order_date)
VALUES 
('1', CURRENT_DATE )
********************************************************************************************************************
--2)  Adding a primary key to an existing table

CREATE TABLE products(
	product_id INT,
	name VARCHAR(255) NOT NULL,
	description TEXT,
	price DEC(10,2)
)

SELECT * FROM products

ALTER TABLE products
ADD PRIMARY KEY (product_id);
********************************************************************************************************************
--3) Creating a table with a primary key that consists of two columns

CREATE TABLE order_items(
	order_id INT PRIMARY KEY,
	item_no SERIAL PRIMARY KEY,
	item_description VARCHAR NOT NULL,
	quantity INTEGER NOT NULL,
	price DEC(10,2)
)
--ABOVE QUERY RETURN ERROR BECAUSE 2 PRIMARY KEY NOT ALLOWED
CREATE TABLE order_items(
	order_id INT ,
	item_no SERIAL ,
	item_description VARCHAR NOT NULL,
	quantity INTEGER NOT NULL,
	price DEC(10,2),
	PRIMARY KEY (order_id,item_no)
)

SELECT * FROM order_items
********************************************************************************************************************
--Adding an auto-incremented primary key to an existing table

CREATE TABLE vendors (
  name VARCHAR(255)
);

INSERT INTO vendors (name)
VALUES
  ('Microsoft'),
  ('IBM'),
  ('Apple'),
  ('Samsung')
RETURNING *;

ALTER TABLE vendors
ADD COLUMN vendor_id SERIAL PRIMARY KEY;

SELECT * FROM vendors

--DROP PRIMARY KEY
ALTER TABLE vendors
DROP CONSTRAINT vendors_pkey;
