-- ============================================================
--  TOPIC 02 — DDL (Data Definition Language)  |  FoodDeliveryDB
--  Final Correct Answers
-- ============================================================

-- Q1. Add a new column 'landmark' (VARCHAR 200) to the Restaurants table.
ALTER TABLE Restaurants
ADD landmark VARCHAR(200);

-- Q2. Rename the column 'landmark' in Restaurants table to 'area'.
EXEC sp_rename 'Restaurants.landmark', 'area', 'COLUMN';

-- Q3. Create a new table called 'Offers' with columns:
--     offer_id (INT, PK, IDENTITY), offer_name (VARCHAR 100), discount_pct (DECIMAL 5,2).
CREATE TABLE Offers
(
    offer_id     INT IDENTITY CONSTRAINT PK_offer_id PRIMARY KEY,
    offer_name   VARCHAR(100),
    discount_pct DECIMAL(5,2)
);

-- Q4. Alter the MenuItems table — add a column 'calories' INT DEFAULT 0.
--     Then add a CHECK constraint that calories must be >= 0.
ALTER TABLE MenuItems
ADD calories INT DEFAULT 0;

ALTER TABLE MenuItems
ADD CONSTRAINT check_calories CHECK (calories >= 0);

-- Q5. Drop the 'area' column from Restaurants table.
ALTER TABLE Restaurants
DROP COLUMN area;

-- Q6. Create a table 'CustomerAddresses' with:
--     address_id (PK IDENTITY), customer_id (FK → Customers),
--     address_line VARCHAR(300), address_type CHECK ('Home','Work','Other'),
--     is_default BIT DEFAULT 0.
CREATE TABLE CustomerAddresses
(
    address_id   INT IDENTITY CONSTRAINT PK_address_id PRIMARY KEY,
    customer_id  INT CONSTRAINT FK_customer_id FOREIGN KEY REFERENCES Customers(customer_id),
    address_line VARCHAR(300),
    address_type VARCHAR(10) CONSTRAINT chk_address_type CHECK (address_type IN ('Home','Work','Other')),
    is_default   BIT DEFAULT 0
);

-- Q7. Create a table 'RestaurantHours' with:
--     id (PK IDENTITY), restaurant_id (FK), day_of_week VARCHAR(10)
--     CHECK in ('Mon','Tue','Wed','Thu','Fri','Sat','Sun'),
--     open_time TIME, close_time TIME,
--     UNIQUE constraint on (restaurant_id, day_of_week).
CREATE TABLE RestaurantHours
(
    id            INT IDENTITY CONSTRAINT PK_reshours_id PRIMARY KEY,
    restaurant_id INT CONSTRAINT FK_restaurant_id FOREIGN KEY REFERENCES Restaurants(restaurant_id),
    day_of_week   VARCHAR(10) CONSTRAINT chk_day_of_week CHECK (day_of_week IN ('Mon','Tue','Wed','Thu','Fri','Sat','Sun')),
    open_time     TIME,
    close_time    TIME,
    CONSTRAINT un_resid_day_of_week UNIQUE (restaurant_id, day_of_week)
);

-- Q8. Alter the Orders table — add column 'cancelled_reason' VARCHAR(200) NULL,
--     add column 'cancelled_on' DATETIME NULL,
--     and add a CHECK that cancelled_on > order_date when not null.
ALTER TABLE Orders
ADD cancelled_reason VARCHAR(200) NULL;

ALTER TABLE Orders
ADD cancelled_on DATETIME NULL;

ALTER TABLE Orders
ADD CONSTRAINT check_cancelled_on
CHECK (cancelled_on IS NULL OR cancelled_on > order_date);

-- Q9. Drop the Offers table. Before dropping, check if it exists.
--     Also drop the CustomerAddresses table (handle FK dependency properly).
ALTER TABLE CustomerAddresses
DROP CONSTRAINT FK_customer_id;

DROP TABLE IF EXISTS CustomerAddresses;
DROP TABLE IF EXISTS Offers;

-- ============================================================