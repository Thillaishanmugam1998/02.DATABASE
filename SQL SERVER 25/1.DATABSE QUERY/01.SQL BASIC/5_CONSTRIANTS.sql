/*========================================================
  TOPIC : SQL SERVER CONSTRAINTS (COMPLETE SYNTAX GUIDE)
  FILE  : constraints_practice.sql
========================================================*/


/*========================================================
  DEFAULT CONSTRAINT
========================================================*/

-- 1) DEFAULT during CREATE TABLE
CREATE TABLE car_default_create
(
    id INT,
    wheel_count SMALLINT DEFAULT 4
);

-- 2) DEFAULT using ALTER TABLE
CREATE TABLE car_default_alter
(
    id INT,
    wheel_count SMALLINT
);

ALTER TABLE car_default_alter
ADD CONSTRAINT df_wheel DEFAULT 4 FOR wheel_count;

DROP TABLE car_default_create;
DROP TABLE car_default_alter;


/*========================================================
  NOT NULL CONSTRAINT
========================================================*/

-- 1) NOT NULL during CREATE TABLE
CREATE TABLE notnull_create
(
    id INT,
    username VARCHAR(50) NOT NULL
);

-- 2) NOT NULL using ALTER TABLE
-- Works ONLY if column has no NULL values
ALTER TABLE notnull_create
ALTER COLUMN username VARCHAR(50) NOT NULL;

DROP TABLE notnull_create;


/*========================================================
  NULL CONSTRAINT
========================================================*/

-- 1) NULL during CREATE TABLE (DEFAULT behavior)
CREATE TABLE null_create
(
    id INT,
    remarks VARCHAR(100) NULL
);

-- 2) NULL using ALTER TABLE
ALTER TABLE null_create
ALTER COLUMN remarks VARCHAR(100) NULL;

DROP TABLE null_create;


/*========================================================
  UNIQUE CONSTRAINT
========================================================*/

-- UNIQUE during CREATE TABLE
CREATE TABLE unique_create
(
    id INT,
    remarks VARCHAR(100) UNIQUE
);

INSERT INTO unique_create VALUES (1, 'A');
-- INSERT INTO unique_create VALUES (2, 'A'); -- ❌ Error: duplicate value

DROP TABLE unique_create;


-- UNIQUE using ALTER TABLE
CREATE TABLE unique_create
(
    id INT,
    remarks VARCHAR(100)
);

-- Ensure NO duplicate values before adding UNIQUE
ALTER TABLE unique_create
ADD CONSTRAINT uq_unique_remarks UNIQUE (remarks);

DROP TABLE unique_create;


/*========================================================
  CHECK CONSTRAINT
========================================================*/

-- CHECK during CREATE TABLE
CREATE TABLE check_constraint
(
    id INT,
    age SMALLINT CONSTRAINT chk_age CHECK (age >= 18)
);

INSERT INTO check_constraint VALUES (1, 18);
INSERT INTO check_constraint VALUES (2, 20);
-- INSERT INTO check_constraint VALUES (3, 2); -- ❌ Error

DROP TABLE check_constraint;


-- CHECK using ALTER TABLE
CREATE TABLE check_constraint
(
    id INT,
    age SMALLINT
);

-- Ensure existing data satisfies condition
ALTER TABLE check_constraint
ADD CONSTRAINT chk_age CHECK (age >= 18);

DROP TABLE check_constraint;


/*========================================================
  PRIMARY KEY CONSTRAINT
========================================================*/

-- Correct PRIMARY KEY (only ONE per table)
CREATE TABLE branches
(
    bcode INT PRIMARY KEY,
    bname VARCHAR(40),
    bloc CHAR(6)
);

INSERT INTO branches VALUES (1, 'HDFC', '612001');
-- INSERT INTO branches VALUES (1, 'KVB', '612001'); -- ❌ Duplicate PK
-- INSERT INTO branches VALUES (NULL, 'IOB', '612002'); -- ❌ PK cannot be NULL

DROP TABLE branches;


-- PRIMARY KEY using ALTER TABLE
CREATE TABLE branches
(
    bcode INT NOT NULL,
    bname VARCHAR(40),
    bloc CHAR(6)
);

ALTER TABLE branches
ADD CONSTRAINT pk_branches PRIMARY KEY (bcode);

DROP TABLE branches;


-- COMPOSITE PRIMARY KEY
CREATE TABLE branches
(
    bcode INT,
    bname VARCHAR(40),
    bloc CHAR(6),
    CONSTRAINT pk_branch_comp PRIMARY KEY (bcode, bname)
);

INSERT INTO branches VALUES (1, 'HDFC', '612001'); -- ✔
INSERT INTO branches VALUES (1, 'KVB',  '612001'); -- ✔
-- INSERT INTO branches VALUES (1, 'HDFC', '612005'); -- ❌ Duplicate composite key

DROP TABLE branches;


/*========================================================
  FOREIGN KEY CONSTRAINT
========================================================*/

CREATE TABLE branches
(
    bcode INT PRIMARY KEY,
    bname VARCHAR(40)
);

CREATE TABLE bank
(
    id INT PRIMARY KEY,
    bc INT,
    income MONEY,
    CONSTRAINT fk_bank_branch
        FOREIGN KEY (bc) REFERENCES branches(bcode)
);

INSERT INTO branches VALUES (1, 'HDFC');
INSERT INTO bank VALUES (1, 1, 500000);
-- INSERT INTO bank VALUES (2, 5, 600000); -- ❌ No matching PK

DROP TABLE bank;
DROP TABLE branches;


/*========================================================
  FULL PRACTICE EXAMPLE
========================================================*/

DROP TABLE IF EXISTS carmodel;

CREATE TABLE carmodel
(
    id INT,
    car_brand VARCHAR(50),
    car_fuel_type VARCHAR(20),
    car_wheel SMALLINT DEFAULT 4,
    car_model VARCHAR(50) NOT NULL
);

INSERT INTO carmodel (id, car_brand, car_fuel_type, car_model)
VALUES
(1, 'TATA', 'PETROL', 'NEXON'),
(2, 'AUDI', 'PETROL', 'A6');

SELECT * FROM carmodel;


/*========================================================
  QUICK INTERVIEW SUMMARY
========================================================*/

-- DEFAULT
-- col datatype DEFAULT value
-- ALTER TABLE t ADD CONSTRAINT name DEFAULT value FOR col;

-- NOT NULL
-- col datatype NOT NULL
-- ALTER TABLE t ALTER COLUMN col datatype NOT NULL;

-- NULL
-- col datatype NULL
-- ALTER TABLE t ALTER COLUMN col datatype NULL;

-- UNIQUE
-- col datatype UNIQUE
-- ALTER TABLE t ADD CONSTRAINT name UNIQUE (col);

-- PRIMARY KEY
-- col datatype PRIMARY KEY
-- ALTER TABLE t ADD CONSTRAINT name PRIMARY KEY (col);

-- FOREIGN KEY
-- FOREIGN KEY (col) REFERENCES parent(col);
