--PostgreSQL Foreign Key
------------------------
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS contacts;;

CREATE TABLE customers(
	customer_id INT GENERATED ALWAYS AS IDENTITY,
	customer_name VARCHAR(255) NOT NULL,
	PRIMARY KEY(customer_id)
);


CREATE TABLE contacts(
   contact_id INT GENERATED ALWAYS AS IDENTITY,
   customer_id INT,
   contact_name VARCHAR(255) NOT NULL,
   phone VARCHAR(15),
   email VARCHAR(100),
   PRIMARY KEY(contact_id),
   CONSTRAINT fk_customer
      FOREIGN KEY(customer_id)
        REFERENCES customers(customer_id)
);


SELECT * FROM customers
SELECT * FROM contacts

INSERT 


