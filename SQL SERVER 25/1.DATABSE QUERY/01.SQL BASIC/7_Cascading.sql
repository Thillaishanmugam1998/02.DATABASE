/*========================================================
 FILE : cascading_referential_integrity.sql
 DB   : SQL SERVER
 TOPIC: CASCADING REFERENTIAL INTEGRITY
 NOTE :
   • Cascading rules apply ONLY to FOREIGN KEY columns
   • Non-key columns can always be updated
========================================================*/


/*========================================================
  BASE TABLE : PRODUCTS (PARENT)
========================================================*/

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;

CREATE TABLE products
(
    pcode INT PRIMARY KEY,
    pname VARCHAR(50),
    pcategory VARCHAR(50)
);

INSERT INTO products VALUES
(0,  'UNKNOWN PRODUCT',        'DEFAULT'),
(1,  'Samsung Galaxy S22',     'Mobile'),
(2,  'iPhone 15',              'Mobile'),
(3,  'Lenovo ThinkPad Gen3',    'Laptop'),
(4,  'Dell XPS 13',             'Laptop'),
(5,  'Sony VX100',              'Camera'),
(6,  'Canon EOS 1500D',         'Camera'),
(7,  'iPad Pro',                'Tablet'),
(8,  'Samsung Galaxy Tab',      'Tablet'),
(9,  'Apple Watch Series 9',    'Watch');

SELECT * FROM products;


/*========================================================
  IMPORTANT NOTE
========================================================
• Foreign Key protects ONLY:
      orders.pid  --->  products.pcode

• You CAN update:
      products.pname
      products.pcategory

• You CANNOT update/delete:
      products.pcode
  unless cascading rules are defined
========================================================*/


/*========================================================
  CASE 1 : NO ACTION (DEFAULT)
========================================================*/

DROP TABLE IF EXISTS orders;

CREATE TABLE orders
(
    oid INT PRIMARY KEY,
    ocname VARCHAR(50),
    odate DATETIME,
    pid INT,
    pcount INT,

    CONSTRAINT fk_orders_noaction
    FOREIGN KEY (pid) REFERENCES products(pcode)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

INSERT INTO orders VALUES
(1,'Thillai',GETDATE(),1,2),
(2,'Senthil',GETDATE(),2,1);

-- ❌ DELETE → ERROR
-- DELETE FROM products WHERE pcode = 1;

-- ❌ UPDATE → ERROR
-- UPDATE products SET pcode = 10 WHERE pcode = 2;

-- ✔ Allowed (non-key column)
UPDATE products SET pname = 'iPhone 15 Pro' WHERE pcode = 2;


/*========================================================
  CASE 2 : CASCADE
========================================================*/

DROP TABLE IF EXISTS orders;

CREATE TABLE orders
(
    oid INT PRIMARY KEY,
    ocname VARCHAR(50),
    odate DATETIME,
    pid INT,
    pcount INT,

    CONSTRAINT fk_orders_cascade
    FOREIGN KEY (pid) REFERENCES products(pcode)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

INSERT INTO orders VALUES
(1,'Arun',GETDATE(),5,1);

-- ✔ UPDATE cascades
UPDATE products SET pcode = 50 WHERE pcode = 5;

-- OUTPUT:
-- orders.pid changes from 5 → 50

-- ✔ DELETE cascades
DELETE FROM products WHERE pcode = 50;

-- OUTPUT:
-- corresponding order row deleted


/*========================================================
  CASE 3 : SET NULL
========================================================*/

DROP TABLE IF EXISTS orders;

CREATE TABLE orders
(
    oid INT PRIMARY KEY,
    ocname VARCHAR(50),
    odate DATETIME,
    pid INT NULL,
    pcount INT,

    CONSTRAINT fk_orders_setnull
    FOREIGN KEY (pid) REFERENCES products(pcode)
    ON DELETE SET NULL
    ON UPDATE SET NULL
);

INSERT INTO orders VALUES
(1,'Tamil',GETDATE(),6,1);

-- ✔ UPDATE
UPDATE products SET pcode = 60 WHERE pcode = 6;

-- OUTPUT:
-- orders.pid = NULL

-- ✔ DELETE
DELETE FROM products WHERE pcode = 1;

-- OUTPUT:
-- orders.pid = NULL


/*========================================================
  CASE 4 : SET DEFAULT
========================================================*/

DROP TABLE IF EXISTS orders;

CREATE TABLE orders
(
    oid INT PRIMARY KEY,
    ocname VARCHAR(50),
    odate DATETIME,
    pid INT DEFAULT 0,
    pcount INT,

    CONSTRAINT fk_orders_setdefault
    FOREIGN KEY (pid) REFERENCES products(pcode)
    ON DELETE SET DEFAULT
    ON UPDATE SET DEFAULT
);

INSERT INTO orders VALUES
(1,'Kumar',GETDATE(),8,2);

-- ✔ UPDATE
UPDATE products SET pcode = 80 WHERE pcode = 8;

-- OUTPUT:
-- orders.pid = 0  (DEFAULT PRODUCT)

-- ✔ DELETE
DELETE FROM products WHERE pcode = 4;

-- OUTPUT:
-- orders.pid = 0


/*========================================================
  FINAL SUMMARY (INTERVIEW NOTE)
========================================================
• Cascading rules apply ONLY to FOREIGN KEY column
• Primary key non-referenced columns can be updated freely

RULE COMPARISON:
----------------------------------------------------------
NO ACTION   → Block update/delete
CASCADE     → Child follows parent
SET NULL    → FK becomes NULL
SET DEFAULT → FK becomes DEFAULT value
========================================================*/
