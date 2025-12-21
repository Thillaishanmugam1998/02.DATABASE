/*========================================================
  CUSTOMER TABLE
========================================================*/

CREATE TABLE customer
(
    cid     INT PRIMARY KEY,
    cname   VARCHAR(30),
    cmobno  CHAR(10)
);

-- Use quotes for CHAR(10) mobile numbers
INSERT INTO customer VALUES (1, 'Thillai', '8675692630');
INSERT INTO customer VALUES (2, 'Senthil', '7598397824');
INSERT INTO customer VALUES (3, 'Tamil',   '9080323760');


/*========================================================
  PRODUCTS TABLE
========================================================*/

CREATE TABLE products
(
    pcode INT PRIMARY KEY,
    pname VARCHAR(40),
    price MONEY
);

INSERT INTO products VALUES (1, 'Camera',     24500);
INSERT INTO products VALUES (2, 'iPhone',    245000);
INSERT INTO products VALUES (3, 'Tab',        75500);
INSERT INTO products VALUES (4, 'PS5',        50000);
INSERT INTO products VALUES (5, 'HeadPhone',   2500);


/*========================================================
  ORDERS TABLE
  (Relationship with TWO parent tables)
========================================================*/

CREATE TABLE orders
(
    oid     INT PRIMARY KEY,
    ordate  DATETIME,
    quantity INT,

    cid INT,
    pcode INT,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (cid) REFERENCES customer(cid),

    CONSTRAINT fk_orders_product
        FOREIGN KEY (pcode) REFERENCES products(pcode)
);


/*========================================================
  ADD CONSTRAINTS TO EXISTING TABLE
========================================================*/

DROP TABLE IF EXISTS employee;

CREATE TABLE employee
(
    empid INT,
    ename VARCHAR(50),
    age   INT,
    pcode INT
);

-- 1) ADD PRIMARY KEY (column must be NOT NULL)
ALTER TABLE employee
ALTER COLUMN empid INT NOT NULL;

ALTER TABLE employee
ADD CONSTRAINT pk_employee PRIMARY KEY (empid);


-- 2) ADD UNIQUE CONSTRAINT
ALTER TABLE employee
ADD CONSTRAINT uq_employee_ename UNIQUE (ename);


-- 3) ADD CHECK CONSTRAINT
ALTER TABLE employee
ADD CONSTRAINT chk_employee_age CHECK (age >= 10);


-- 4) ADD FOREIGN KEY CONSTRAINT
ALTER TABLE employee
ADD CONSTRAINT fk_employee_pcode
FOREIGN KEY (pcode) REFERENCES products(pcode);


/*========================================================
  DROP CONSTRAINTS
========================================================*/

ALTER TABLE employee DROP CONSTRAINT chk_employee_age;
ALTER TABLE employee DROP CONSTRAINT uq_employee_ename;
