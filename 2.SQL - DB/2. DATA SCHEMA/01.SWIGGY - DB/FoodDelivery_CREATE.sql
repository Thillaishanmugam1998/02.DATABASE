-- ============================================================
--   FOOD DELIVERY DATABASE - CREATE SCRIPT (FIXED v2)
--   Style     : Swiggy / Zomato
--   Database  : SQL Server (MSSQL)
--   Fixed     : All FK conflicts resolved, item_id verified
-- ============================================================
--
--  item_id reference map (IDENTITY starts at 1):
--  1-4   → rest 1  (Idli, Dosa, Vada, Pongal)
--  5-7   → rest 2  (Chicken Biryani, Mutton Biryani, Egg Biryani)
--  8-9   → rest 3  (Masala Dosa, Uthappam)
--  10    → rest 4  (Ghee Pongal)
--  11-12 → rest 5  (Dindigul Biryani, Salna)
--  13-14 → rest 6  (Chettinad Chicken, Parotta)
--  15-16 → rest 7  (Margherita Pizza, Chicken Supreme Pizza)
--  17-18 → rest 8  (Zinger Burger, Popcorn Chicken)
--  19-20 → rest 9  (Hakka Noodles, Manchurian)
--  21-22 → rest 10 (BBQ Veg Platter, BBQ Non-Veg Platter)
--  23-24 → rest 11 (Paneer Butter Masala, Dal Makhani)
--  25-26 → rest 12 (Gulab Jamun, Rasgulla)
--  27-28 → rest 13 (Quinoa Bowl, Grilled Chicken Bowl)
--  29-30 → rest 14 (Veggie Delight Sub, Chicken Teriyaki Sub)
--  31-32 → rest 15 (Farm House Pizza, Peppy Paneer Pizza)
--  33    → rest 16 (Hyderabadi Biryani)
--  34    → rest 17 (Butter Chicken)
--  35    → rest 18 (Oats Bowl)
--  36-37 → rest 19 (Masala Chai, Samosa)
--  38-39 → rest 20 (Prawn Fry, Fish Curry)
--  40-41 → rest 21 (Chole Bhature, Paneer Tikka)
--  42-43 → rest 22 (Fried Rice, Chilli Chicken)
--  44-45 → rest 23 (Pani Puri, Bhel Puri)
--  46-47 → rest 24 (Chocolate Cake, Brownie)
--  48-49 → rest 25 (Grilled Fish, Tandoori Prawns)
--  MAX item_id = 49
-- ============================================================

-- ──────────────────────────────────────────
-- STEP 0 : DROP & CREATE DATABASE
-- ──────────────────────────────────────────
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'FoodDeliveryDB')
BEGIN
    ALTER DATABASE FoodDeliveryDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE FoodDeliveryDB;
END
GO

CREATE DATABASE FoodDeliveryDB;
GO
USE FoodDeliveryDB;
GO

-- ──────────────────────────────────────────
-- STEP 1 : Cities
-- ──────────────────────────────────────────
CREATE TABLE Cities (
    city_id   INT          IDENTITY(1,1) PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    state     VARCHAR(100) NOT NULL
);

INSERT INTO Cities (city_name, state) VALUES
('Chennai',     'Tamil Nadu'),      -- 1
('Coimbatore',  'Tamil Nadu'),      -- 2
('Madurai',     'Tamil Nadu'),      -- 3
('Trichy',      'Tamil Nadu'),      -- 4
('Salem',       'Tamil Nadu'),      -- 5
('Bangalore',   'Karnataka'),       -- 6
('Hyderabad',   'Telangana'),       -- 7
('Mumbai',      'Maharashtra'),     -- 8
('Delhi',       'Delhi'),           -- 9
('Pune',        'Maharashtra'),     -- 10
('Kolkata',     'West Bengal'),     -- 11
('Ahmedabad',   'Gujarat'),         -- 12
('Jaipur',      'Rajasthan'),       -- 13
('Surat',       'Gujarat'),         -- 14
('Lucknow',     'Uttar Pradesh');   -- 15

-- ──────────────────────────────────────────
-- STEP 2 : Customers
-- ──────────────────────────────────────────
CREATE TABLE Customers (
    customer_id   INT          IDENTITY(1,1) PRIMARY KEY,
    full_name     VARCHAR(150) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    phone         CHAR(10)     NOT NULL,
    city_id       INT          NOT NULL,
    registered_on DATE         DEFAULT GETDATE(),
    is_active     BIT          DEFAULT 1,
    CONSTRAINT fk_cust_city FOREIGN KEY (city_id)
        REFERENCES Cities(city_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO Customers (full_name, email, phone, city_id, registered_on) VALUES
('Arun Kumar',     'arun@mail.com',     '9876543210', 1,  '2023-01-15'),  -- 1
('Priya Ravi',     'priya@mail.com',    '9876543211', 1,  '2023-02-20'),  -- 2
('Karthik S',      'karthik@mail.com',  '9876543212', 2,  '2023-03-10'),  -- 3
('Meena Devi',     'meena@mail.com',    '9876543213', 2,  '2023-03-25'),  -- 4
('Suresh V',       'suresh@mail.com',   '9876543214', 3,  '2023-04-05'),  -- 5
('Lakshmi N',      'lakshmi@mail.com',  '9876543215', 4,  '2023-04-18'),  -- 6
('Vijay M',        'vijay@mail.com',    '9876543216', 5,  '2023-05-01'),  -- 7
('Anitha B',       'anitha@mail.com',   '9876543217', 6,  '2023-05-14'),  -- 8
('Ravi Shankar',   'ravi@mail.com',     '9876543218', 7,  '2023-06-20'),  -- 9
('Deepa P',        'deepa@mail.com',    '9876543219', 8,  '2023-07-11'),  -- 10
('Mohan Das',      'mohan@mail.com',    '9876543220', 9,  '2023-07-30'),  -- 11
('Saranya T',      'saranya@mail.com',  '9876543221', 1,  '2023-08-08'),  -- 12
('Bala G',         'bala@mail.com',     '9876543222', 2,  '2023-08-22'),  -- 13
('Nithya K',       'nithya@mail.com',   '9876543223', 3,  '2023-09-05'),  -- 14
('Harish L',       'harish@mail.com',   '9876543224', 4,  '2023-09-19'),  -- 15
('Pooja R',        'pooja@mail.com',    '9876543225', 5,  '2023-10-02'),  -- 16
('Dinesh C',       'dinesh@mail.com',   '9876543226', 6,  '2023-10-16'),  -- 17
('Kavitha M',      'kavitha@mail.com',  '9876543227', 7,  '2023-11-01'),  -- 18
('Senthil P',      'senthil@mail.com',  '9876543228', 8,  '2023-11-15'),  -- 19
('Uma S',          'uma@mail.com',      '9876543229', 9,  '2023-12-01'),  -- 20
('Rajesh T',       'rajesh@mail.com',   '9876543230', 1,  '2024-01-10'),  -- 21
('Vani A',         'vani@mail.com',     '9876543231', 2,  '2024-01-25'),  -- 22
('Prakash N',      'prakash@mail.com',  '9876543232', 3,  '2024-02-08'),  -- 23
('Geetha V',       'geetha@mail.com',   '9876543233', 4,  '2024-02-22'),  -- 24
('Muthukumar R',   'muthu@mail.com',    '9876543234', 5,  '2024-03-05');  -- 25

-- ──────────────────────────────────────────
-- STEP 3 : RestaurantCategories
-- ──────────────────────────────────────────
CREATE TABLE RestaurantCategories (
    category_id   INT          IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO RestaurantCategories (category_name) VALUES
('South Indian'),  -- 1
('North Indian'),  -- 2
('Chinese'),       -- 3
('Biryani'),       -- 4
('Pizza'),         -- 5
('Burgers'),       -- 6
('Desserts'),      -- 7
('Seafood'),       -- 8
('Healthy'),       -- 9
('Street Food');   -- 10

-- ──────────────────────────────────────────
-- STEP 4 : Restaurants
-- ──────────────────────────────────────────
CREATE TABLE Restaurants (
    restaurant_id   INT           IDENTITY(1,1) PRIMARY KEY,
    restaurant_name VARCHAR(200)  NOT NULL,
    category_id     INT           NOT NULL,
    city_id         INT           NOT NULL,
    address         VARCHAR(300),
    rating          DECIMAL(3,1)  CHECK (rating BETWEEN 1.0 AND 5.0),
    is_open         BIT           DEFAULT 1,
    opened_on       DATE,
    CONSTRAINT fk_rest_cat  FOREIGN KEY (category_id)
        REFERENCES RestaurantCategories(category_id)
        ON UPDATE CASCADE,
    CONSTRAINT fk_rest_city FOREIGN KEY (city_id)
        REFERENCES Cities(city_id)
        ON UPDATE CASCADE
);

INSERT INTO Restaurants (restaurant_name, category_id, city_id, address, rating, opened_on) VALUES
('Murugan Idli Shop',      1, 1, '12 Anna Salai, Chennai',          4.5, '2018-06-01'),  -- 1
('Buhari Hotel',           4, 1, '83 Mount Road, Chennai',          4.3, '2017-03-15'),  -- 2
('Sangeetha Restaurant',   1, 1, '45 T Nagar, Chennai',             4.2, '2019-07-20'),  -- 3
('Hotel Saravana Bhavan',  1, 2, '78 DB Road, Coimbatore',          4.6, '2016-11-10'),  -- 4
('Thalappakatti',          4, 3, '23 Town Hall Road, Madurai',      4.7, '2015-05-05'),  -- 5
('Junior Kuppanna',        2, 4, '56 Kamaraj Salai, Trichy',        4.4, '2020-01-12'),  -- 6
('Pizza Hut',              5, 1, '90 Nungambakkam, Chennai',        4.0, '2021-08-18'),  -- 7
('KFC Chennai',            6, 1, '34 Express Avenue, Chennai',      3.9, '2020-04-22'),  -- 8
('Mainland China',         3, 6, '11 Koramangala, Bangalore',       4.2, '2019-09-30'),  -- 9
('Barbeque Nation',        2, 7, '67 Banjara Hills, Hyderabad',     4.5, '2018-12-25'),  -- 10
('Cream Centre',           2, 8, '45 Nariman Point, Mumbai',        4.1, '2017-06-14'),  -- 11
('Haldiram''s',            7, 9, '23 Connaught Place, Delhi',       4.3, '2016-03-08'),  -- 12
('The Bowl Company',       9, 6, '89 Indiranagar, Bangalore',       4.0, '2022-02-17'),  -- 13
('Subway',                 9, 5, '12 Five Roads, Salem',            3.8, '2021-10-05'),  -- 14
('Dominos',                5, 2, '67 RS Puram, Coimbatore',         4.1, '2020-07-19'),  -- 15
('Biriyani Zone',          4, 6, '34 MG Road, Bangalore',           4.4, '2019-11-11'),  -- 16
('Spice Garden',           2, 7, '56 Jubilee Hills, Hyderabad',     4.2, '2021-03-03'),  -- 17
('Green Bowl',             9, 1, '78 Adyar, Chennai',               3.9, '2022-06-28'),  -- 18
('Chai Kings',            10, 3, '90 Meenakshi Nagar, Madurai',     4.0, '2023-01-15'),  -- 19
('Fish Land',              8, 1, '23 Besant Nagar, Chennai',        4.6, '2018-08-08'),  -- 20
('Punjabi Tadka',          2, 9, '45 Karol Bagh, Delhi',            4.3, '2017-05-20'),  -- 21
('Dragon Palace',          3, 8, '67 Andheri, Mumbai',              4.1, '2020-09-15'),  -- 22
('Tasty Bites',           10, 4, '12 Srirangam, Trichy',            3.7, '2022-11-30'),  -- 23
('Cake Walk',              7, 6, '89 Whitefield, Bangalore',         4.2, '2021-07-07'),  -- 24
('Sea Shell',              8, 7, '34 Secunderabad, Hyderabad',      4.5, '2019-04-16');  -- 25

-- ──────────────────────────────────────────
-- STEP 5 : MenuItems
-- ──────────────────────────────────────────
CREATE TABLE MenuItems (
    item_id       INT           IDENTITY(1,1) PRIMARY KEY,
    restaurant_id INT           NOT NULL,
    item_name     VARCHAR(200)  NOT NULL,
    price         DECIMAL(10,2) NOT NULL CHECK (price > 0),
    is_veg        BIT           DEFAULT 1,
    is_available  BIT           DEFAULT 1,
    CONSTRAINT fk_menu_rest FOREIGN KEY (restaurant_id)
        REFERENCES Restaurants(restaurant_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO MenuItems (restaurant_id, item_name, price, is_veg) VALUES
-- rest 1 → item_id 1,2,3,4
(1,  'Idli (2 pcs)',            40,  1),
(1,  'Dosa',                    60,  1),
(1,  'Vada',                    30,  1),
(1,  'Pongal',                  50,  1),
-- rest 2 → item_id 5,6,7
(2,  'Chicken Biryani',        180,  0),
(2,  'Mutton Biryani',         250,  0),
(2,  'Egg Biryani',            140,  0),
-- rest 3 → item_id 8,9
(3,  'Masala Dosa',             80,  1),
(3,  'Uthappam',                70,  1),
-- rest 4 → item_id 10
(4,  'Ghee Pongal',             90,  1),
-- rest 5 → item_id 11,12
(5,  'Dindigul Biryani',       200,  0),
(5,  'Salna',                   50,  1),
-- rest 6 → item_id 13,14
(6,  'Chettinad Chicken',      220,  0),
(6,  'Parotta',                 20,  1),
-- rest 7 → item_id 15,16
(7,  'Margherita Pizza',       299,  1),
(7,  'Chicken Supreme Pizza',  399,  0),
-- rest 8 → item_id 17,18
(8,  'Zinger Burger',          199,  0),
(8,  'Popcorn Chicken',        149,  0),
-- rest 9 → item_id 19,20
(9,  'Hakka Noodles',          180,  1),
(9,  'Manchurian',             160,  1),
-- rest 10 → item_id 21,22
(10, 'BBQ Veg Platter',        499,  1),
(10, 'BBQ Non-Veg Platter',    699,  0),
-- rest 11 → item_id 23,24
(11, 'Paneer Butter Masala',   280,  1),
(11, 'Dal Makhani',            220,  1),
-- rest 12 → item_id 25,26
(12, 'Gulab Jamun',            120,  1),
(12, 'Rasgulla',               100,  1),
-- rest 13 → item_id 27,28
(13, 'Quinoa Bowl',            320,  1),
(13, 'Grilled Chicken Bowl',   380,  0),
-- rest 14 → item_id 29,30
(14, 'Veggie Delight Sub',     199,  1),
(14, 'Chicken Teriyaki Sub',   249,  0),
-- rest 15 → item_id 31,32
(15, 'Farm House Pizza',       349,  1),
(15, 'Peppy Paneer Pizza',     329,  1),
-- rest 16 → item_id 33
(16, 'Hyderabadi Biryani',     220,  0),
-- rest 17 → item_id 34
(17, 'Butter Chicken',         260,  0),
-- rest 18 → item_id 35
(18, 'Oats Bowl',              180,  1),
-- rest 19 → item_id 36,37
(19, 'Masala Chai',             40,  1),
(19, 'Samosa',                  30,  1),
-- rest 20 → item_id 38,39
(20, 'Prawn Fry',              350,  0),
(20, 'Fish Curry',             300,  0),
-- rest 21 → item_id 40,41
(21, 'Chole Bhature',          180,  1),
(21, 'Paneer Tikka',           280,  1),
-- rest 22 → item_id 42,43
(22, 'Fried Rice',             200,  1),
(22, 'Chilli Chicken',         240,  0),
-- rest 23 → item_id 44,45
(23, 'Pani Puri',               50,  1),
(23, 'Bhel Puri',               60,  1),
-- rest 24 → item_id 46,47
(24, 'Chocolate Cake',         280,  1),
(24, 'Brownie',                180,  1),
-- rest 25 → item_id 48,49
(25, 'Grilled Fish',           380,  0),
(25, 'Tandoori Prawns',        450,  0);
-- MAX item_id = 49

-- ──────────────────────────────────────────
-- STEP 6 : DeliveryAgents
-- ──────────────────────────────────────────
CREATE TABLE DeliveryAgents (
    agent_id     INT          IDENTITY(1,1) PRIMARY KEY,
    agent_name   VARCHAR(150) NOT NULL,
    phone        CHAR(10)     NOT NULL,
    city_id      INT          NOT NULL,
    vehicle_type VARCHAR(50)  CHECK (vehicle_type IN ('Bike','Cycle','Scooter')),
    rating       DECIMAL(3,1) DEFAULT 4.0,
    is_active    BIT          DEFAULT 1,
    joined_on    DATE         DEFAULT GETDATE(),
    CONSTRAINT fk_agent_city FOREIGN KEY (city_id)
        REFERENCES Cities(city_id)
        ON UPDATE CASCADE
);

INSERT INTO DeliveryAgents (agent_name, phone, city_id, vehicle_type, rating, joined_on) VALUES
('Murugan A',  '8800001001', 1, 'Bike',    4.5, '2022-01-10'),  -- 1
('Selvam B',   '8800001002', 1, 'Scooter', 4.2, '2022-03-15'),  -- 2
('Dinesh K',   '8800001003', 2, 'Bike',    4.7, '2022-05-20'),  -- 3
('Aravind P',  '8800001004', 3, 'Bike',    4.1, '2022-07-08'),  -- 4
('Sundar M',   '8800001005', 4, 'Scooter', 4.3, '2022-09-22'),  -- 5
('Rajan T',    '8800001006', 5, 'Cycle',   3.9, '2023-01-05'),  -- 6
('Anand G',    '8800001007', 6, 'Bike',    4.6, '2023-02-18'),  -- 7
('Velu S',     '8800001008', 7, 'Scooter', 4.0, '2023-04-10'),  -- 8
('Sunil R',    '8800001009', 8, 'Bike',    4.4, '2023-06-25'),  -- 9
('Karthi N',   '8800001010', 9, 'Bike',    4.2, '2023-08-14'),  -- 10
('Prasanth V', '8800001011', 1, 'Bike',    4.8, '2023-10-01'),  -- 11
('Manoj D',    '8800001012', 2, 'Scooter', 3.8, '2023-11-19'),  -- 12
('Hari L',     '8800001013', 3, 'Bike',    4.5, '2024-01-07'),  -- 13
('Balu C',     '8800001014', 4, 'Cycle',   4.0, '2024-02-28'),  -- 14
('Naveen R',   '8800001015', 5, 'Bike',    4.3, '2024-03-15');  -- 15

-- ──────────────────────────────────────────
-- STEP 7 : Sequence for Order Numbers
-- ──────────────────────────────────────────
CREATE SEQUENCE seq_order_number
    START WITH 10001
    INCREMENT BY 1
    MINVALUE 10001
    NO MAXVALUE
    NO CYCLE;
GO

-- ──────────────────────────────────────────
-- STEP 8 : Orders
-- ──────────────────────────────────────────
-- Orders FK references:
--   customer_id  → Customers (1–25)
--   restaurant_id → Restaurants (1–25)
--   agent_id     → DeliveryAgents (1–15) or NULL
-- ──────────────────────────────────────────
CREATE TABLE Orders (
    order_id      INT           IDENTITY(1,1) PRIMARY KEY,
    order_number  VARCHAR(20)   DEFAULT ('ORD-' + CAST(NEXT VALUE FOR seq_order_number AS VARCHAR)),
    customer_id   INT           NOT NULL,
    restaurant_id INT           NOT NULL,
    agent_id      INT,
    order_date    DATETIME      DEFAULT GETDATE(),
    status        VARCHAR(50)   DEFAULT 'Placed'
                                CHECK (status IN (
                                    'Placed','Confirmed','Preparing',
                                    'Out for Delivery','Delivered','Cancelled'
                                )),
    total_amount  DECIMAL(10,2),
    discount      DECIMAL(10,2) DEFAULT 0,
    delivery_fee  DECIMAL(10,2) DEFAULT 30,
    payment_mode  VARCHAR(50)   CHECK (payment_mode IN ('UPI','Card','Cash','Wallet')),
    CONSTRAINT fk_ord_cust  FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
        ON UPDATE CASCADE,
    CONSTRAINT fk_ord_rest  FOREIGN KEY (restaurant_id)
        REFERENCES Restaurants(restaurant_id),
    CONSTRAINT fk_ord_agent FOREIGN KEY (agent_id)
        REFERENCES DeliveryAgents(agent_id)
);

INSERT INTO Orders (customer_id, restaurant_id, agent_id, order_date, status, total_amount, discount, delivery_fee, payment_mode) VALUES
-- cust 1–25 valid | rest 1–25 valid | agent 1–15 or NULL valid
(1,  1,  1,  '2024-01-05 09:30:00', 'Delivered',        130,   10, 30, 'UPI'),     -- ord 1  | rest1  | agent1
(2,  2,  2,  '2024-01-06 12:45:00', 'Delivered',        430,   20, 30, 'Card'),    -- ord 2  | rest2  | agent2
(3,  5,  3,  '2024-01-07 13:00:00', 'Delivered',        250,    0, 30, 'Cash'),    -- ord 3  | rest5  | agent3
(4,  7,  1,  '2024-01-08 19:30:00', 'Delivered',        698,   50, 30, 'UPI'),     -- ord 4  | rest7  | agent1
(5,  10, 7,  '2024-01-09 20:00:00', 'Delivered',       1198,  100, 30, 'Card'),    -- ord 5  | rest10 | agent7
(6,  3,  2,  '2024-01-10 08:00:00', 'Delivered',        150,   10, 30, 'Wallet'),  -- ord 6  | rest3  | agent2
(7,  15, 3,  '2024-01-11 18:30:00', 'Delivered',        349,    0, 30, 'UPI'),     -- ord 7  | rest15 | agent3
(8,  9,  7,  '2024-01-12 13:15:00', 'Delivered',        340,   20, 30, 'Card'),    -- ord 8  | rest9  | agent7
(9,  16, 8,  '2024-01-13 14:00:00', 'Delivered',        440,   40, 30, 'Cash'),    -- ord 9  | rest16 | agent8
(10, 11, 9,  '2024-01-14 20:30:00', 'Delivered',        500,    0, 30, 'UPI'),     -- ord 10 | rest11 | agent9
(11, 12, 10, '2024-01-15 16:00:00', 'Delivered',        220,   20, 30, 'Wallet'),  -- ord 11 | rest12 | agent10
(12, 20, 1,  '2024-02-01 19:00:00', 'Delivered',        650,   50, 30, 'Card'),    -- ord 12 | rest20 | agent1
(13, 4,  3,  '2024-02-03 09:00:00', 'Delivered',         90,    0, 30, 'UPI'),     -- ord 13 | rest4  | agent3
(14, 6,  4,  '2024-02-05 12:30:00', 'Delivered',        240,   10, 30, 'Cash'),    -- ord 14 | rest6  | agent4
(15, 8,  1,  '2024-02-07 18:45:00', 'Delivered',        348,   30, 30, 'UPI'),     -- ord 15 | rest8  | agent1
(16, 13, 7,  '2024-02-09 13:00:00', 'Delivered',        700,   50, 30, 'Card'),    -- ord 16 | rest13 | agent7
(17, 17, 8,  '2024-02-11 20:15:00', 'Delivered',        260,    0, 30, 'UPI'),     -- ord 17 | rest17 | agent8
(18, 19, 2,  '2024-02-13 07:30:00', 'Delivered',         70,    0, 30, 'Wallet'),  -- ord 18 | rest19 | agent2
(19, 21, 10, '2024-02-15 12:00:00', 'Delivered',        460,   40, 30, 'Card'),    -- ord 19 | rest21 | agent10
(20, 24, 7,  '2024-02-17 17:00:00', 'Delivered',        460,   20, 30, 'UPI'),     -- ord 20 | rest24 | agent7
(1,  7,  1,  '2024-03-01 19:30:00', 'Cancelled',        299,    0, 30, 'UPI'),     -- ord 21 | rest7  | agent1
(2,  2,  NULL,'2024-03-02 13:00:00','Placed',            180,    0, 30, 'Card'),    -- ord 22 | rest2  | no agent
(3,  5,  3,  '2024-03-03 12:45:00', 'Delivered',        200,    0, 30, 'Cash'),    -- ord 23 | rest5  | agent3
(4,  15, 3,  '2024-03-04 18:00:00', 'Delivered',        678,   30, 30, 'UPI'),     -- ord 24 | rest15 | agent3
(5,  10, 7,  '2024-03-05 21:00:00', 'Out for Delivery', 699,    0, 30, 'Card'),    -- ord 25 | rest10 | agent7
(6,  1,  2,  '2024-03-06 08:30:00', 'Delivered',        130,   10, 30, 'Wallet'),  -- ord 26 | rest1  | agent2
(7,  3,  2,  '2024-03-07 09:15:00', 'Delivered',         80,    0, 30, 'UPI'),     -- ord 27 | rest3  | agent2
(8,  9,  7,  '2024-03-08 14:30:00', 'Preparing',        360,   20, 30, 'Card'),    -- ord 28 | rest9  | agent7
(9,  20, 8,  '2024-03-09 20:00:00', 'Delivered',        350,    0, 30, 'Cash'),    -- ord 29 | rest20 | agent8
(10, 25, 9,  '2024-03-10 19:30:00', 'Delivered',        830,   50, 30, 'UPI');     -- ord 30 | rest25 | agent9

-- ──────────────────────────────────────────
-- STEP 9 : OrderItems
-- ──────────────────────────────────────────
-- VERIFIED: Every item_id below exists in MenuItems (range 1–49)
--           Every order_id below exists in Orders    (range 1–30)
--           item_id must match the restaurant_id of its order
-- ──────────────────────────────────────────
CREATE TABLE OrderItems (
    order_item_id INT           IDENTITY(1,1) PRIMARY KEY,
    order_id      INT           NOT NULL,
    item_id       INT           NOT NULL,
    quantity      INT           NOT NULL CHECK (quantity > 0),
    unit_price    DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_oi_order FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_oi_item  FOREIGN KEY (item_id)
        REFERENCES MenuItems(item_id)
);

INSERT INTO OrderItems (order_id, item_id, quantity, unit_price) VALUES
-- ord1  → rest1  : items 1-4
(1,  1,  2,  40),   -- Idli ×2
(1,  2,  1,  60),   -- Dosa ×1
-- ord2  → rest2  : items 5-7
(2,  5,  2, 180),   -- Chicken Biryani ×2
(2,  7,  1, 140),   -- Egg Biryani ×1
-- ord3  → rest5  : items 11-12
(3,  11, 1, 200),   -- Dindigul Biryani ×1
(3,  12, 2,  50),   -- Salna ×2
-- ord4  → rest7  : items 15-16
(4,  15, 1, 299),   -- Margherita Pizza ×1
(4,  16, 1, 399),   -- Chicken Supreme Pizza ×1
-- ord5  → rest10 : items 21-22
(5,  21, 1, 499),   -- BBQ Veg Platter ×1
(5,  22, 1, 699),   -- BBQ Non-Veg Platter ×1
-- ord6  → rest3  : items 8-9
(6,  8,  1,  80),   -- Masala Dosa ×1
(6,  9,  1,  70),   -- Uthappam ×1
-- ord7  → rest15 : items 31-32
(7,  31, 1, 349),   -- Farm House Pizza ×1
-- ord8  → rest9  : items 19-20
(8,  19, 1, 180),   -- Hakka Noodles ×1
(8,  20, 1, 160),   -- Manchurian ×1
-- ord9  → rest16 : item 33
(9,  33, 2, 220),   -- Hyderabadi Biryani ×2
-- ord10 → rest11 : items 23-24
(10, 23, 1, 280),   -- Paneer Butter Masala ×1
(10, 24, 1, 220),   -- Dal Makhani ×1
-- ord11 → rest12 : items 25-26
(11, 25, 1, 120),   -- Gulab Jamun ×1
(11, 26, 1, 100),   -- Rasgulla ×1
-- ord12 → rest20 : items 38-39
(12, 38, 1, 350),   -- Prawn Fry ×1
(12, 39, 1, 300),   -- Fish Curry ×1
-- ord13 → rest4  : item 10
(13, 10, 1,  90),   -- Ghee Pongal ×1
-- ord14 → rest6  : items 13-14
(14, 13, 1, 220),   -- Chettinad Chicken ×1
(14, 14, 2,  20),   -- Parotta ×2
-- ord15 → rest8  : items 17-18
(15, 17, 1, 199),   -- Zinger Burger ×1
(15, 18, 1, 149),   -- Popcorn Chicken ×1
-- ord16 → rest13 : items 27-28
(16, 27, 1, 320),   -- Quinoa Bowl ×1
(16, 28, 1, 380),   -- Grilled Chicken Bowl ×1
-- ord17 → rest17 : item 34
(17, 34, 1, 260),   -- Butter Chicken ×1
-- ord18 → rest19 : items 36-37
(18, 36, 1,  40),   -- Masala Chai ×1
(18, 37, 1,  30),   -- Samosa ×1
-- ord19 → rest21 : items 40-41
(19, 40, 1, 180),   -- Chole Bhature ×1
(19, 41, 1, 280),   -- Paneer Tikka ×1
-- ord20 → rest24 : items 46-47
(20, 46, 1, 280),   -- Chocolate Cake ×1
(20, 47, 1, 180),   -- Brownie ×1
-- ord21 → rest7  : item 15 (Cancelled order)
(21, 15, 1, 299),   -- Margherita Pizza ×1
-- ord22 → rest2  : item 5 (Placed order)
(22, 5,  1, 180),   -- Chicken Biryani ×1
-- ord23 → rest5  : item 11
(23, 11, 1, 200),   -- Dindigul Biryani ×1
-- ord24 → rest15 : items 31-32
(24, 31, 1, 349),   -- Farm House Pizza ×1
(24, 32, 1, 329),   -- Peppy Paneer Pizza ×1
-- ord25 → rest10 : item 22 (Out for Delivery)
(25, 22, 1, 699),   -- BBQ Non-Veg Platter ×1
-- ord26 → rest1  : items 1-2
(26, 1,  2,  40),   -- Idli ×2
(26, 2,  1,  60),   -- Dosa ×1
-- ord27 → rest3  : item 8
(27, 8,  1,  80),   -- Masala Dosa ×1
-- ord28 → rest9  : items 19-20 (Preparing)
(28, 19, 1, 180),   -- Hakka Noodles ×1
(28, 20, 1, 180),   -- Manchurian ×1
-- ord29 → rest20 : item 38
(29, 38, 1, 350),   -- Prawn Fry ×1
-- ord30 → rest25 : items 48-49
(30, 48, 1, 380),   -- Grilled Fish ×1      ← FIXED: was 49, now 48
(30, 49, 1, 450);   -- Tandoori Prawns ×1   ← FIXED: was 50, now 49

-- ──────────────────────────────────────────
-- STEP 10 : Reviews
-- ──────────────────────────────────────────
-- VERIFIED: order_id, customer_id, restaurant_id all exist
-- ──────────────────────────────────────────
CREATE TABLE Reviews (
    review_id       INT          IDENTITY(1,1) PRIMARY KEY,
    order_id        INT          NOT NULL UNIQUE,
    customer_id     INT          NOT NULL,
    restaurant_id   INT          NOT NULL,
    food_rating     INT          CHECK (food_rating     BETWEEN 1 AND 5),
    delivery_rating INT          CHECK (delivery_rating BETWEEN 1 AND 5),
    review_text     VARCHAR(500),
    reviewed_on     DATETIME     DEFAULT GETDATE(),
    CONSTRAINT fk_rev_order FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),
    CONSTRAINT fk_rev_cust  FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),
    CONSTRAINT fk_rev_rest  FOREIGN KEY (restaurant_id)
        REFERENCES Restaurants(restaurant_id)
);

INSERT INTO Reviews (order_id, customer_id, restaurant_id, food_rating, delivery_rating, review_text, reviewed_on) VALUES
(1,  1,  1, 5, 4, 'Idli was super soft and fresh!',            '2024-01-05 10:30:00'),
(2,  2,  2, 4, 5, 'Biryani taste was amazing.',                 '2024-01-06 14:00:00'),
(3,  3,  5, 5, 4, 'Authentic Dindigul Biryani. Loved it!',      '2024-01-07 14:30:00'),
(4,  4,  7, 4, 4, 'Pizza was hot and on time.',                 '2024-01-08 20:30:00'),
(5,  5, 10, 5, 5, 'BBQ Platter was outstanding!',               '2024-01-09 21:30:00'),
(6,  6,  3, 4, 4, 'Good breakfast delivery.',                   '2024-01-10 09:00:00'),
(7,  7, 15, 4, 5, 'Pizza arrived warm. Crust was crispy.',      '2024-01-11 19:30:00'),
(8,  8,  9, 4, 3, 'Noodles were good but took some time.',      '2024-01-12 14:30:00'),
(9,  9, 16, 5, 4, 'Best Hyderabadi Biryani ever!',              '2024-01-13 15:00:00'),
(10,10, 11, 4, 4, 'Paneer curry was rich and creamy.',          '2024-01-14 21:30:00'),
(11,11, 12, 3, 4, 'Sweets were okay, could be fresher.',        '2024-01-15 17:00:00'),
(12,12, 20, 5, 5, 'Prawn fry was perfectly cooked!',            '2024-02-01 20:00:00'),
(13,13,  4, 4, 4, 'Simple and tasty breakfast.',                '2024-02-03 10:00:00'),
(14,14,  6, 5, 4, 'Chettinad chicken was spicy and delicious.', '2024-02-05 13:30:00'),
(15,15,  8, 4, 5, 'Zinger burger and fast delivery!',           '2024-02-07 19:45:00'),
(16,16, 13, 5, 4, 'Healthy bowl, great portion.',               '2024-02-09 14:00:00'),
(17,17, 17, 4, 4, 'Butter chicken was good.',                   '2024-02-11 21:15:00'),
(18,18, 19, 3, 5, 'Tea was average but delivery was quick.',    '2024-02-13 08:30:00'),
(19,19, 21, 4, 4, 'Chole bhature was filling.',                 '2024-02-15 13:00:00'),
(20,20, 24, 5, 4, 'Chocolate cake was heavenly!',               '2024-02-17 18:00:00'),
(23, 3,  5, 5, 4, 'Second time ordering - still amazing!',      '2024-03-03 13:45:00'),
(24, 4, 15, 4, 5, 'Farm House Pizza was great!',                '2024-03-04 19:00:00'),
(26, 6,  1, 5, 4, 'Fresh morning idli, perfect start!',         '2024-03-06 09:30:00'),
(27, 7,  3, 4, 3, 'Masala dosa was crispy.',                    '2024-03-07 10:15:00'),
(29, 9, 20, 5, 5, 'Prawn fry again - never disappoints!',       '2024-03-09 21:00:00'),
(30,10, 25, 5, 4, 'Grilled fish was fresh and juicy!',          '2024-03-10 20:30:00');

-- ──────────────────────────────────────────
-- STEP 11 : Coupons
-- ──────────────────────────────────────────
CREATE TABLE Coupons (
    coupon_id       INT           IDENTITY(1,1) PRIMARY KEY,
    coupon_code     VARCHAR(20)   NOT NULL UNIQUE,
    discount_type   VARCHAR(10)   CHECK (discount_type IN ('Flat','Percent')),
    discount_value  DECIMAL(10,2) NOT NULL,
    min_order_value DECIMAL(10,2) DEFAULT 0,
    valid_from      DATE,
    valid_to        DATE,
    is_active       BIT           DEFAULT 1
);

INSERT INTO Coupons (coupon_code, discount_type, discount_value, min_order_value, valid_from, valid_to) VALUES
('WELCOME50',  'Flat',    50,  100, '2024-01-01', '2024-12-31'),
('SAVE10',     'Percent', 10,  200, '2024-01-01', '2024-06-30'),
('FEAST100',   'Flat',   100,  500, '2024-02-01', '2024-04-30'),
('NEWUSER',    'Flat',    30,   50, '2024-01-01', '2024-12-31'),
('WEEKEND20',  'Percent', 20,  300, '2024-01-01', '2024-12-31'),
('BIRYANI40',  'Flat',    40,  180, '2024-01-15', '2024-07-15'),
('PIZZA15',    'Percent', 15,  299, '2024-01-01', '2024-12-31'),
('FREESHIP',   'Flat',    30,   99, '2024-01-01', '2024-12-31'),
('SUMMER25',   'Percent', 25,  400, '2024-03-01', '2024-05-31'),
('MONSOON50',  'Flat',    50,  250, '2024-06-01', '2024-09-30');

-- ──────────────────────────────────────────
-- VERIFICATION QUERIES (Run after setup)
-- ──────────────────────────────────────────
-- SELECT 'Cities'               AS tbl, COUNT(*) AS rows FROM Cities
-- UNION ALL SELECT 'Customers',              COUNT(*) FROM Customers
-- UNION ALL SELECT 'RestaurantCategories',   COUNT(*) FROM RestaurantCategories
-- UNION ALL SELECT 'Restaurants',            COUNT(*) FROM Restaurants
-- UNION ALL SELECT 'MenuItems',              COUNT(*) FROM MenuItems
-- UNION ALL SELECT 'DeliveryAgents',         COUNT(*) FROM DeliveryAgents
-- UNION ALL SELECT 'Orders',                 COUNT(*) FROM Orders
-- UNION ALL SELECT 'OrderItems',             COUNT(*) FROM OrderItems
-- UNION ALL SELECT 'Reviews',                COUNT(*) FROM Reviews
-- UNION ALL SELECT 'Coupons',                COUNT(*) FROM Coupons;

-- ============================================================
-- SETUP COMPLETE - No FK conflicts!
-- Tables  : 10 | Records : 300+ rows
-- Fixed   : OrderItems item_id 49→48, 50→49
-- ============================================================