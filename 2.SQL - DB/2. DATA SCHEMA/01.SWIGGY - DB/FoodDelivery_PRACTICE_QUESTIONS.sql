-- ============================================================
--   FOOD DELIVERY DB — PRACTICE QUESTIONS
--   Database  : FoodDeliveryDB (MSSQL)
--   Topics    : All 23 topics from syllabus
--   Levels    : EASY | MEDIUM | HARD
--   Language  : Tamil + English (Bilingual)
-- ============================================================
-- NOTE: Run FoodDelivery_CREATE.sql first before practicing!
-- ============================================================

USE FoodDeliveryDB;
GO

/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 01 — SQL SELECT                               ║
║  Basic data retrieval — அடிப்படை தரவு எடுக்கும் வழி║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show all customers.
-- TM : எல்லா customers-ஐயும் காட்டு.


-- ★ EASY 2
-- EN : Show only the full_name and email of all customers.
-- TM : Customers-இன் பெயர் மற்றும் email மட்டும் காட்டு.


-- ★ EASY 3
-- EN : Show the first 5 rows from the MenuItems table.
-- TM : MenuItems table-இல் முதல் 5 rows காட்டு.


-- ★★ MEDIUM 1
-- EN : Show restaurant name, rating, and city_id for all open restaurants.
-- TM : திறந்திருக்கும் restaurants-இன் பெயர், rating, city_id காட்டு.


-- ★★ MEDIUM 2
-- EN : Show distinct payment modes used in the Orders table.
-- TM : Orders table-இல் use ஆன distinct payment modes காட்டு.


-- ★★ MEDIUM 3
-- EN : Show order_id, order_date, total_amount, and delivery_fee for all orders.
--      Also show a column net_payable = total_amount + delivery_fee - discount.
-- TM : Orders table-இல் order_id, order_date, total_amount, delivery_fee காட்டு.
--      net_payable = total_amount + delivery_fee - discount என்ற புதிய column சேர்.


-- ★★★ HARD 1
-- EN : Show each menu item with its restaurant name, category name, city name, and price.
--      Display only available items (is_available = 1).
-- TM : ஒவ்வொரு menu item-க்கும் restaurant பெயர், category பெயர், city பெயர், price காட்டு.
--      கிடைக்கும் items மட்டும் காட்டு.


-- ★★★ HARD 2
-- EN : Show all orders with customer name, restaurant name, delivery agent name (show 'Not Assigned'
--      if no agent), order status, and total amount. Sort by order_date descending.
-- TM : எல்லா orders-க்கும் customer பெயர், restaurant பெயர், delivery agent பெயர்
--      (agent இல்லாவிட்டால் 'Not Assigned'), status, total_amount காட்டு. order_date-ஆல் sort செய்.


-- ★★★ HARD 3
-- EN : Show the full order details: order_number, customer name, restaurant name,
--      each item ordered, quantity, unit_price, and line total (qty × price).
-- TM : Full order details: order_number, customer பெயர், restaurant பெயர்,
--      order செய்த ஒவ்வொரு item, quantity, unit_price, line total காட்டு.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 02 — DDL (Data Definition Language)           ║
║  Table உருவாக்கல் மற்றும் மாற்றுதல்                 ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Add a new column 'landmark' (VARCHAR 200) to the Restaurants table.
-- TM : Restaurants table-இல் 'landmark' என்ற புதிய column சேர்.


-- ★ EASY 2
-- EN : Rename the column 'landmark' in Restaurants table to 'area'.
-- TM : Restaurants table-இல் 'landmark' column-இன் பெயரை 'area' என மாற்று.


-- ★ EASY 3
-- EN : Create a new table called 'Offers' with columns:
--      offer_id (INT, PK, IDENTITY), offer_name (VARCHAR 100), discount_pct (DECIMAL 5,2).
-- TM : 'Offers' என்ற புதிய table உருவாக்கு. Columns: offer_id (PK), offer_name, discount_pct.


-- ★★ MEDIUM 1
-- EN : Alter the MenuItems table — add a column 'calories' INT DEFAULT 0.
--      Then add a CHECK constraint that calories must be >= 0.
-- TM : MenuItems table-இல் 'calories' INT column சேர். CHECK constraint போடு (>= 0).


-- ★★ MEDIUM 2
-- EN : Drop the 'area' column from Restaurants table.
-- TM : Restaurants table-இல் 'area' column-ஐ நீக்கு.


-- ★★ MEDIUM 3
-- EN : Create a table 'CustomerAddresses' with:
--      address_id (PK IDENTITY), customer_id (FK → Customers), address_line VARCHAR(300),
--      address_type CHECK ('Home','Work','Other'), is_default BIT DEFAULT 0.
-- TM : 'CustomerAddresses' table உருவாக்கு. customer_id FK-ஆக Customers-ஐ reference செய்யட்டும்.


-- ★★★ HARD 1
-- EN : Create a table 'RestaurantHours' with:
--      id (PK IDENTITY), restaurant_id (FK), day_of_week VARCHAR(10)
--      CHECK in ('Mon','Tue','Wed','Thu','Fri','Sat','Sun'),
--      open_time TIME, close_time TIME,
--      UNIQUE constraint on (restaurant_id, day_of_week).
-- TM : 'RestaurantHours' table உருவாக்கு. Restaurant-க்கு ஒவ்வொரு நாளும் ஒரு row மட்டுமே
--      இருக்க வேண்டும் என்று UNIQUE constraint போடு.


-- ★★★ HARD 2
-- EN : Alter the Orders table — add column 'cancelled_reason' VARCHAR(200) NULL,
--      add column 'cancelled_on' DATETIME NULL,
--      and add a CHECK that cancelled_on > order_date when not null.
-- TM : Orders table-இல் cancel reason மற்றும் cancel date columns சேர்.
--      cancelled_on > order_date என்ற CHECK constraint போடு.


-- ★★★ HARD 3
-- EN : Drop the Offers table you created. Before dropping, check if it exists.
--      Also drop the CustomerAddresses table (handle FK dependency properly).
-- TM : முன்பு create செய்த Offers மற்றும் CustomerAddresses tables-ஐ safely drop செய்.
--      FK dependency சரியாக handle செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 03 — DML (Data Manipulation Language)         ║
║  Data சேர்த்தல், மாற்றுதல், நீக்கல்                  ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Insert a new city 'Vellore', state 'Tamil Nadu' into the Cities table.
-- TM : Cities table-இல் 'Vellore', 'Tamil Nadu' என்று ஒரு புதிய row சேர்.


-- ★ EASY 2
-- EN : Update the rating of restaurant_id = 3 to 4.8.
-- TM : restaurant_id = 3-இன் rating-ஐ 4.8 ஆக மாற்று.


-- ★ EASY 3
-- EN : Delete all coupons that have expired (valid_to < GETDATE()).
-- TM : காலாவதியான coupons-ஐ Delete செய்.


-- ★★ MEDIUM 1
-- EN : Insert 3 new customers into the Customers table at once (one INSERT statement).
--      Use city_id values that already exist.
-- TM : ஒரே INSERT statement-இல் 3 புதிய customers சேர்.


-- ★★ MEDIUM 2
-- EN : Update all orders where status = 'Placed' and order_date < DATEADD(DAY,-7,GETDATE())
--      — set their status to 'Cancelled'.
-- TM : 7 நாளுக்கு முன்பு place ஆன, இன்னும் 'Placed' status-இல் இருக்கும்
--      orders-ஐ 'Cancelled' ஆக மாற்று.


-- ★★ MEDIUM 3
-- EN : Increase the price of all non-veg menu items by 10%.
-- TM : Non-veg menu items எல்லாவற்றின் price-ஐ 10% அதிகரி.


-- ★★★ HARD 1
-- EN : Insert a new order for customer_id=1, restaurant_id=5 with 2 menu items:
--      item_id=11 qty=1, item_id=12 qty=2. Set total_amount correctly.
--      Use a transaction — rollback if anything fails.
-- TM : புதிய order insert செய் (2 items உடன்). Transaction use செய்.
--      ஏதாவது fail ஆனால் rollback ஆகட்டும்.


-- ★★★ HARD 2
-- EN : Soft delete — instead of deleting, set is_active = 0 for all customers
--      who have NOT placed any order in the last 180 days.
-- TM : கடந்த 180 நாளில் order போடாத customers-ஐ hard delete செய்யாமல்
--      is_active = 0 ஆக மாற்று (soft delete).


-- ★★★ HARD 3
-- EN : Update the total_amount of all orders by recalculating it from OrderItems
--      (SUM of quantity × unit_price). Use a subquery or CTE inside UPDATE.
-- TM : OrderItems table-இல் இருந்து calculate செய்து Orders-இன் total_amount-ஐ
--      update செய். Subquery அல்லது CTE use செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 04 — Data Types                               ║
║  Column data types பற்றிய புரிதல்                    ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : What are the data types of all columns in the Orders table?
--      Query INFORMATION_SCHEMA to find out.
-- TM : Orders table-இல் உள்ள எல்லா columns-இன் data types என்ன என்று
--      INFORMATION_SCHEMA use செய்து காட்டு.


-- ★ EASY 2
-- EN : Show the phone number of all customers cast as INT.
--      Why might this cause an issue? (Just try it and observe.)
-- TM : Customers-இன் phone number-ஐ INT-ஆக CAST செய்து காட்டு.


-- ★ EASY 3
-- EN : Show order_date formatted as 'DD-Mon-YYYY' string using CONVERT or FORMAT.
-- TM : order_date-ஐ 'DD-Mon-YYYY' format-ஆக string-ஆக மாற்று.


-- ★★ MEDIUM 1
-- EN : Convert total_amount from DECIMAL to VARCHAR and concatenate with '₹' symbol.
--      Show as: '₹ 430.00' format.
-- TM : total_amount-ஐ VARCHAR-ஆக மாற்றி '₹' symbol சேர்த்து காட்டு.


-- ★★ MEDIUM 2
-- EN : Show the difference in days between valid_from and valid_to for each coupon.
--      Cast both columns to DATE if needed.
-- TM : ஒவ்வொரு coupon-இன் valid_from மற்றும் valid_to-க்கு இடையே உள்ள நாட்கள் காட்டு.


-- ★★ MEDIUM 3
-- EN : Show a column that displays rating as 'Good' if CAST to INT is 4 or 5,
--      else 'Average' else 'Poor'. Use CAST inside CASE.
-- TM : Rating-ஐ INT-ஆக CAST செய்து CASE-ஐ use செய்து 'Good', 'Average', 'Poor' காட்டு.


-- ★★★ HARD 1
-- EN : Create a computed column expression (not persisted) in a SELECT that shows
--      each order's GST amount (18% of total_amount) as DECIMAL(10,2),
--      total with GST, and a VARCHAR label like 'GST: ₹XX.XX'.
-- TM : Orders table-இல் GST (18%) தனியாக calculate செய்து காட்டு. Label-உம் சேர்.


-- ★★★ HARD 2
-- EN : Show all columns from MenuItems with their SQL data types alongside
--      using INFORMATION_SCHEMA.COLUMNS joined with actual data.
-- TM : MenuItems-இன் data values-உடன் அந்த column-இன் data type-ஐயும் சேர்த்து காட்டு.


-- ★★★ HARD 3
-- EN : Demonstrate implicit vs explicit conversion: Try adding total_amount (DECIMAL)
--      and delivery_fee (DECIMAL) — fine. Now try to add total_amount + order_number (VARCHAR).
--      Write a safe version using TRY_CAST / TRY_CONVERT.
-- TM : Implicit vs Explicit conversion demonstrate செய்.
--      VARCHAR column-ஐ DECIMAL-உடன் safe-ஆக add பண்ண TRY_CAST use செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 05 — Constraints                              ║
║  NOT NULL, UNIQUE, CHECK, DEFAULT                    ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Try inserting a restaurant with rating = 6.0 — it should fail. Write the insert and
--      explain which constraint stops it.
-- TM : rating = 6.0 உடன் restaurant insert செய்ய முயற்சி. எந்த constraint block செய்கிறது?


-- ★ EASY 2
-- EN : Try inserting a customer without an email — which constraint prevents it?
-- TM : Email இல்லாமல் customer insert செய்ய முயற்சி. எந்த constraint block செய்கிறது?


-- ★ EASY 3
-- EN : Insert a delivery agent without specifying rating — what default value gets set?
-- TM : Rating கொடுக்காமல் delivery agent insert செய். Default value என்ன set ஆகும்?


-- ★★ MEDIUM 1
-- EN : Add a UNIQUE constraint on the 'phone' column of DeliveryAgents table.
--      Then try inserting a duplicate phone number.
-- TM : DeliveryAgents-இல் phone column-க்கு UNIQUE constraint சேர்.
--      Duplicate phone insert செய்ய முயற்சி.


-- ★★ MEDIUM 2
-- EN : Add a CHECK constraint to Orders: discount must not be greater than total_amount.
-- TM : Orders table-இல் discount > total_amount ஆகக்கூடாது என்று CHECK constraint சேர்.


-- ★★ MEDIUM 3
-- EN : Find all constraints defined on the Orders table using system catalog views
--      (sys.check_constraints, sys.foreign_keys, etc.).
-- TM : Orders table-இல் உள்ள எல்லா constraints-ஐயும் system catalog-ஐ use செய்து காட்டு.


-- ★★★ HARD 1
-- EN : Disable a CHECK constraint on MenuItems (price > 0), insert a row with price = -10,
--      then re-enable the constraint. Observe behavior.
-- TM : MenuItems-இல் CHECK constraint-ஐ disable செய். price = -10 insert செய்.
--      பிறகு constraint-ஐ re-enable செய். என்ன நடக்கிறது?


-- ★★★ HARD 2
-- EN : Drop the existing UNIQUE constraint on Customers.email,
--      then re-add it as a named constraint 'uq_customer_email'.
-- TM : Customers.email-இல் உள்ள UNIQUE constraint-ஐ drop செய்து
--      'uq_customer_email' என்ற பெயருடன் மீண்டும் சேர்.


-- ★★★ HARD 3
-- EN : Create a table 'PremiumMembers' that inherits all NOT NULL rules via constraints,
--      with a CHECK that membership_end > membership_start,
--      and a DEFAULT for membership_type = 'Silver'.
-- TM : 'PremiumMembers' table உருவாக்கு. Membership end > start CHECK,
--      Default type = 'Silver' என்று set செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 06 — Primary Key & Foreign Key                ║
║  PK, FK relationship புரிதல்                         ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : List all Primary Key constraints in FoodDeliveryDB using system views.
-- TM : FoodDeliveryDB-இல் உள்ள எல்லா Primary Key constraints-ஐ system views மூலம் காட்டு.


-- ★ EASY 2
-- EN : List all Foreign Key relationships — which table references which table?
-- TM : எல்லா Foreign Key relationships-ஐ காட்டு — எந்த table, எந்த table-ஐ reference செய்கிறது?


-- ★ EASY 3
-- EN : Try inserting an order with a customer_id that does NOT exist — observe the FK error.
-- TM : இல்லாத customer_id உடன் order insert செய்ய முயற்சி. FK error பார்.


-- ★★ MEDIUM 1
-- EN : Show all customers who have placed orders — use FK relationship in JOIN.
-- TM : Order போட்ட customers-ஐ மட்டும் FK JOIN use செய்து காட்டு.


-- ★★ MEDIUM 2
-- EN : Show all restaurants that have at least one menu item.
--      Use FK between MenuItems and Restaurants.
-- TM : குறைந்தது ஒரு menu item உள்ள restaurants-ஐ FK relationship use செய்து காட்டு.


-- ★★ MEDIUM 3
-- EN : Show parent-child relationship data: For each restaurant, show its category name
--      and how many menu items it has.
-- TM : ஒவ்வொரு restaurant-க்கும் category பெயர் மற்றும் menu item count காட்டு.


-- ★★★ HARD 1
-- EN : Try to delete a city that is referenced by customers — it should succeed due to
--      ON DELETE CASCADE. Verify rows are deleted. Then ROLLBACK.
-- TM : CASCADE delete demonstrate செய். City delete செய்தால் அந்த customers
--      automatically delete ஆகிறார்களா என்று verify செய்.


-- ★★★ HARD 2
-- EN : Show a 4-level deep FK chain:
--      Cities → Customers → Orders → OrderItems
--      Display city name, customer name, order number, and item name.
-- TM : 4-level FK chain traverse செய். City → Customer → Order → Item வரை JOIN செய்.


-- ★★★ HARD 3
-- EN : Find all orphan records (rows in child tables that have no matching parent).
--      Check if any OrderItems have an order_id not in Orders.
-- TM : Child table-இல் parent இல்லாத orphan records இருக்கிறதா என்று check செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 07 — Cascading                                ║
║  ON DELETE CASCADE, ON UPDATE CASCADE                ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Which tables in FoodDeliveryDB have ON DELETE CASCADE? Query sys.foreign_keys.
-- TM : FoodDeliveryDB-இல் எந்த tables-க்கு ON DELETE CASCADE இருக்கிறது? sys.foreign_keys use செய்.


-- ★ EASY 2
-- EN : Delete a menu item from MenuItems — does it cascade to OrderItems?
--      Try item_id = 4 (Pongal) and check.
-- TM : MenuItems-இல் ஒரு item delete செய். OrderItems-இல் cascade ஆகிறதா? Check செய்.


-- ★ EASY 3
-- EN : Update city_id of Chennai from 1 to 100 — does it cascade to Customers? (Try it.)
-- TM : Chennai-இன் city_id-ஐ மாற்று — Customers table-இலும் மாறுகிறதா?


-- ★★ MEDIUM 1
-- EN : Demonstrate what happens when you delete an Order — do OrderItems auto-delete?
--      Write the DELETE and a SELECT to verify. Use a transaction and ROLLBACK.
-- TM : Order delete செய்தால் OrderItems-உம் delete ஆகுமா? Transaction use செய்து verify செய்.


-- ★★ MEDIUM 2
-- EN : Which tables do NOT have cascading? What happens if you try to delete a record
--      referenced by those tables?
-- TM : Cascading இல்லாத tables எவை? அவற்றை delete செய்ய முயற்சித்தால் என்ன நடக்கும்?


-- ★★ MEDIUM 3
-- EN : Add ON DELETE SET NULL behavior for the agent_id column in Orders
--      (drop and recreate FK). Then delete an agent and verify.
-- TM : Orders.agent_id-க்கு ON DELETE SET NULL behavior add செய்.
--      Agent delete செய்தால் orders-இல் agent_id NULL ஆகுமா? Verify செய்.


-- ★★★ HARD 1
-- EN : Simulate a full cascade chain: Delete a city → customers cascade → orders cascade
--      → order items cascade. Count rows before and after. Use transaction + ROLLBACK.
-- TM : City delete → Customer cascade → Order cascade → OrderItems cascade.
--      முன்பும் பின்பும் row count compare செய். Transaction use செய்.


-- ★★★ HARD 2
-- EN : Change the cascading rule on Restaurants → Orders FK from NO ACTION to CASCADE.
--      This requires dropping and recreating the FK constraint.
-- TM : Restaurants → Orders FK-இன் cascade rule-ஐ NO ACTION-இல் இருந்து CASCADE-ஆக மாற்று.


-- ★★★ HARD 3
-- EN : Design a scenario where CASCADE DELETE could be dangerous and explain it.
--      Show it with FoodDeliveryDB: If you cascade-delete a restaurant,
--      what all disappears? Trace the full impact.
-- TM : Cascade delete dangerous-ஆக இருக்கும் scenario காட்டு.
--      Restaurant delete செய்தால் என்னென்ன data போகும்? Full impact trace செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 08 — IDENTITY                                 ║
║  Auto-increment columns                              ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show the current IDENTITY seed and increment for the Customers table.
-- TM : Customers table-இன் current IDENTITY seed மற்றும் increment என்ன?


-- ★ EASY 2
-- EN : Insert a new customer and find the newly generated customer_id using SCOPE_IDENTITY().
-- TM : புதிய customer insert செய். SCOPE_IDENTITY() use செய்து generate ஆன ID காட்டு.


-- ★ EASY 3
-- EN : What is the last identity value inserted in the Orders table? Use IDENT_CURRENT.
-- TM : Orders table-இல் last insert ஆன identity value என்ன? IDENT_CURRENT use செய்.


-- ★★ MEDIUM 1
-- EN : Delete the last 5 orders and re-insert new ones.
--      Do the new identity values continue from where left off, or reset? Observe.
-- TM : Last 5 orders delete செய்து மீண்டும் insert செய்.
--      Identity values reset ஆகுமா, continue ஆகுமா?


-- ★★ MEDIUM 2
-- EN : Use IDENTITY_INSERT to manually insert a row with a specific ID (e.g., customer_id = 999).
-- TM : IDENTITY_INSERT-ஐ ON செய்து manually customer_id = 999 உடன் row insert செய்.


-- ★★ MEDIUM 3
-- EN : Reseed the Customers table IDENTITY to start from 500 using DBCC CHECKIDENT.
-- TM : Customers table-இன் IDENTITY-ஐ 500-இல் இருந்து start ஆகும்படி reseed செய்.


-- ★★★ HARD 1
-- EN : Create a table that uses IDENTITY(100, 5) — starts at 100, increments by 5.
--      Insert 5 rows and verify the generated IDs.
-- TM : IDENTITY(100, 5) உடன் table உருவாக்கு. 5 rows insert செய். IDs verify செய்.


-- ★★★ HARD 2
-- EN : Show the difference between @@IDENTITY, SCOPE_IDENTITY(), and IDENT_CURRENT().
--      Write a scenario using a trigger that inserts into another table to demonstrate
--      why SCOPE_IDENTITY() is safer than @@IDENTITY.
-- TM : @@IDENTITY, SCOPE_IDENTITY(), IDENT_CURRENT()-க்கு இடையே உள்ள
--      வித்தியாசம் என்ன? Trigger scenario use செய்து காட்டு.


-- ★★★ HARD 3
-- EN : Your Orders table has gaps in order_id (some were deleted). Write a query to
--      find all missing IDs in the sequence.
-- TM : Orders table-இல் delete ஆனதால் gap உள்ள order_id values எவை? Query எழுது.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 09 — SEQUENCE                                 ║
║  Sequence objects                                    ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show the current value of seq_order_number sequence.
-- TM : seq_order_number sequence-இன் current value என்ன?


-- ★ EASY 2
-- EN : Get the next 3 values from seq_order_number using NEXT VALUE FOR.
-- TM : seq_order_number-இல் இருந்து அடுத்த 3 values NEXT VALUE FOR use செய்து எடு.


-- ★ EASY 3
-- EN : List all sequences in the FoodDeliveryDB using sys.sequences.
-- TM : FoodDeliveryDB-இல் உள்ள எல்லா sequences-ஐ sys.sequences use செய்து காட்டு.


-- ★★ MEDIUM 1
-- EN : Create a new sequence 'seq_invoice_number' starting at 5000, incrementing by 10.
--      Use it to generate an invoice number in a SELECT.
-- TM : 5000-இல் இருந்து 10 step-ஆக increment ஆகும் 'seq_invoice_number' sequence உருவாக்கு.


-- ★★ MEDIUM 2
-- EN : Alter seq_order_number to restart from 20000.
-- TM : seq_order_number-ஐ 20000-இல் இருந்து restart ஆகும்படி ALTER செய்.


-- ★★ MEDIUM 3
-- EN : What is the difference between SEQUENCE and IDENTITY? Write both and compare.
-- TM : SEQUENCE மற்றும் IDENTITY-க்கு இடையே உள்ள வித்தியாசம் என்ன?
--      இரண்டையும் use செய்து compare செய்.


-- ★★★ HARD 1
-- EN : Create a sequence that CYCLES — after reaching max value 10, it restarts from 1.
--      Insert 15 rows into a temp table using this cycling sequence. Observe values.
-- TM : Max = 10 ஆன பிறகு 1-இல் இருந்து restart ஆகும் cycling sequence உருவாக்கு.
--      15 rows insert செய்து values observe செய்.


-- ★★★ HARD 2
-- EN : Use a sequence in a multi-table insert scenario:
--      Generate an invoice_id from sequence, insert into an Invoices table,
--      and use the same value as FK in an InvoiceItems table.
-- TM : Sequence use செய்து multi-table insert செய்.
--      Invoice-க்கும் InvoiceItems-க்கும் same value use செய்.


-- ★★★ HARD 3
-- EN : Drop seq_invoice_number. Create a shared sequence 'seq_global_id' used
--      by both Customers and Restaurants tables (to demonstrate cross-table sequences).
-- TM : seq_invoice_number drop செய். Customers மற்றும் Restaurants இரண்டுக்கும்
--      shared-ஆக use ஆகும் 'seq_global_id' sequence உருவாக்கு.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 10 — GROUP BY                                 ║
║  Data grouping                                       ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Count the number of restaurants in each city.
-- TM : ஒவ்வொரு city-லும் எத்தனை restaurants இருக்கின்றன என்று count செய்.


-- ★ EASY 2
-- EN : Find the total number of orders for each payment mode.
-- TM : ஒவ்வொரு payment mode-லும் எத்தனை orders இருக்கின்றன?


-- ★ EASY 3
-- EN : Count how many customers registered each month in 2023.
-- TM : 2023-இல் ஒவ்வொரு மாதமும் எத்தனை customers register ஆனார்கள்?


-- ★★ MEDIUM 1
-- EN : Find the total revenue generated per restaurant. Show restaurant name and total revenue.
--      Include only delivered orders.
-- TM : ஒவ்வொரு restaurant-இன் total revenue என்ன? Delivered orders மட்டும் எடு.


-- ★★ MEDIUM 2
-- EN : Find the average order amount per customer. Show customer name and average.
-- TM : ஒவ்வொரு customer-இன் average order amount என்ன?


-- ★★ MEDIUM 3
-- EN : Group menu items by restaurant and show min price, max price, and count of items.
-- TM : Restaurant-வாரியாக menu items-ஐ group செய். Min price, max price, item count காட்டு.


-- ★★★ HARD 1
-- EN : Find total revenue per city (join Customers → Orders via city). Show city name.
-- TM : City-வாரியாக total revenue கண்டுபிடி. City name காட்டு.


-- ★★★ HARD 2
-- EN : Group orders by YEAR and MONTH. Show year, month name, order count, total revenue.
--      Sort by year and month.
-- TM : Year மற்றும் Month-வாரியாக orders group செய். Month name, order count, revenue காட்டு.


-- ★★★ HARD 3
-- EN : For each delivery agent, show total orders delivered, total revenue handled,
--      and their own rating. Group by agent.
-- TM : ஒவ்வொரு delivery agent-க்கும் delivered orders, handled revenue, மற்றும் rating காட்டு.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 11 — HAVING                                   ║
║  Group-level filtering                               ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show only those cities that have more than 2 restaurants.
-- TM : 2-க்கும் அதிகமான restaurants உள்ள cities மட்டும் காட்டு.


-- ★ EASY 2
-- EN : Show payment modes used more than 5 times.
-- TM : 5-க்கும் அதிகமாக use ஆன payment modes காட்டு.


-- ★ EASY 3
-- EN : Show customers who have placed more than 1 order.
-- TM : 1-க்கும் அதிகமான order போட்ட customers காட்டு.


-- ★★ MEDIUM 1
-- EN : Show restaurants whose average food rating is above 4.2.
-- TM : Average food rating 4.2-க்கும் அதிகமான restaurants காட்டு.


-- ★★ MEDIUM 2
-- EN : Show cities where total order revenue exceeds ₹1000.
-- TM : Total order revenue ₹1000-க்கும் அதிகமான cities காட்டு.


-- ★★ MEDIUM 3
-- EN : Show delivery agents who have handled more than 2 orders and have rating > 4.0.
-- TM : 2-க்கும் அதிகமான orders handle செய்த, rating > 4.0 உள்ள agents காட்டு.


-- ★★★ HARD 1
-- EN : Show restaurants where max item price > 3× min item price (high price spread).
-- TM : Max item price, Min item price-ஐ விட 3 மடங்கு அதிகமாக உள்ள restaurants காட்டு.


-- ★★★ HARD 2
-- EN : Show months in 2024 where cancelled orders are more than 0
--      but delivered orders are less than 3.
-- TM : 2024-இல் cancelled orders > 0, ஆனால் delivered orders < 3 உள்ள months காட்டு.


-- ★★★ HARD 3
-- EN : Show customers whose average discount received is greater than ₹20
--      AND who have placed at least 2 orders.
-- TM : Average discount > ₹20 மற்றும் குறைந்தது 2 orders போட்ட customers காட்டு.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 12 — GROUP BY + WHERE                         ║
║  Filtering before grouping                           ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Count orders per status, but only for orders placed in 2024.
-- TM : 2024-இல் place ஆன orders மட்டும் எடுத்து status-வாரியாக count செய்.


-- ★ EASY 2
-- EN : Count veg items per restaurant.
-- TM : ஒவ்வொரு restaurant-இலும் எத்தனை veg items இருக்கின்றன?


-- ★ EASY 3
-- EN : Find average rating of open restaurants per city.
-- TM : திறந்திருக்கும் restaurants மட்டும் எடுத்து city-வாரியாக average rating கண்டுபிடி.


-- ★★ MEDIUM 1
-- EN : For Delivered orders only, find total revenue per restaurant.
--      Only include restaurants in city_id IN (1, 2, 3).
-- TM : Delivered orders மட்டும் எடுத்து, city_id 1,2,3-ல் உள்ள restaurants-இன் revenue கண்டுபிடி.


-- ★★ MEDIUM 2
-- EN : Count how many non-veg items each restaurant has, but only for restaurants with rating >= 4.0.
-- TM : Rating >= 4.0 உள்ள restaurants மட்டும் எடுத்து, அவற்றின் non-veg item count காட்டு.


-- ★★ MEDIUM 3
-- EN : Find total discount given per payment mode, only for orders placed in Jan-Mar 2024.
-- TM : Jan-Mar 2024-இல் place ஆன orders மட்டும் எடுத்து, payment mode-வாரியாக total discount கண்டுபிடி.


-- ★★★ HARD 1
-- EN : Find agents who delivered orders in Jan 2024 — show agent name, delivery count,
--      total amount handled. Only count Delivered status orders.
-- TM : Jan 2024-இல் Delivered orders handle செய்த agents-ஐ காட்டு.
--      Agent பெயர், delivery count, total amount காட்டு.


-- ★★★ HARD 2
-- EN : For each city, count customers who registered AFTER 2023-06-01 and have at least 1 order.
-- TM : 2023-06-01-க்கு பிறகு register ஆன, குறைந்தது 1 order உள்ள customers-ஐ city-வாரியாக count செய்.


-- ★★★ HARD 3
-- EN : Show restaurants that have at least 3 menu items priced above ₹150,
--      and at least 1 review with food_rating = 5. Use WHERE + GROUP BY + HAVING.
-- TM : ₹150-க்கும் அதிகமான 3+ items உள்ள, food_rating 5 உள்ள review உடைய
--      restaurants-ஐ WHERE + GROUP BY + HAVING use செய்து காட்டு.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 13 — Assignment / Arithmetic / Comparison     ║
║             Operators                                ║
║  Operators பயிற்சி                                   ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show order_id, total_amount, delivery_fee and calculate final_bill = total_amount + delivery_fee - discount.
-- TM : order_id, total_amount, delivery_fee காட்டு. final_bill = total_amount + delivery_fee - discount calculate செய்.


-- ★ EASY 2
-- EN : Show menu items where price is NOT equal to 200.
-- TM : price ≠ 200 உள்ள menu items காட்டு.


-- ★ EASY 3
-- EN : Show all restaurants where rating > 4.3 AND is_open = 1.
-- TM : rating > 4.3 மற்றும் திறந்திருக்கும் restaurants காட்டு.


-- ★★ MEDIUM 1
-- EN : For each order, calculate: profit_margin = (total_amount - discount - delivery_fee) / total_amount * 100.
--      Show as percentage with 2 decimal places.
-- TM : ஒவ்வொரு order-க்கும் profit margin percentage calculate செய்.


-- ★★ MEDIUM 2
-- EN : Show customers where (city_id * 10) + customer_id > 50. (Arithmetic in WHERE)
-- TM : (city_id * 10) + customer_id > 50 உள்ள customers காட்டு.


-- ★★ MEDIUM 3
-- EN : Show orders where total_amount % 100 = 0 (evenly divisible by 100).
-- TM : total_amount 100-ஆல் வகுபடும் orders காட்டு (modulo operator use செய்).


-- ★★★ HARD 1
-- EN : Assign a tier to each customer based on total spent:
--      Use variables (@gold_min, @silver_min) and assignment operators in a query.
-- TM : Variables (@gold_min, @silver_min) use செய்து customer tier assign செய்.


-- ★★★ HARD 2
-- EN : Calculate for each menu item:
--      price_with_gst = price * 1.18,
--      price_with_gst_and_service = price * 1.18 * 1.05,
--      round both to 2 decimals.
-- TM : ஒவ்வொரு menu item-க்கும் GST (18%) மற்றும் service charge (5%) சேர்த்த price calculate செய்.


-- ★★★ HARD 3
-- EN : Find all orders where the effective discount % = (discount / total_amount) * 100
--      is greater than 10%. Show order_id, effective_discount_pct.
-- TM : Effective discount % = (discount / total_amount) * 100 > 10% உள்ள orders காட்டு.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 14 — Logical Operators                        ║
║  AND, OR, NOT                                        ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show restaurants that are OPEN and have rating >= 4.0.
-- TM : திறந்திருக்கும் மற்றும் rating >= 4.0 உள்ள restaurants காட்டு.


-- ★ EASY 2
-- EN : Show orders that are NOT cancelled and NOT placed.
-- TM : Cancelled அல்லது Placed status இல்லாத orders காட்டு.


-- ★ EASY 3
-- EN : Show menu items that are veg OR price < 100.
-- TM : Veg items அல்லது price < 100 உள்ள items காட்டு.


-- ★★ MEDIUM 1
-- EN : Show customers who are active (is_active=1) AND registered in 2023 AND from city_id IN (1,2,3).
-- TM : Active, 2023-இல் register ஆன, city_id 1/2/3 உள்ள customers காட்டு.


-- ★★ MEDIUM 2
-- EN : Show orders where (status='Delivered' AND payment_mode='UPI')
--      OR (status='Cancelled' AND discount > 0).
-- TM : (Delivered + UPI) அல்லது (Cancelled + discount > 0) உள்ள orders காட்டு.


-- ★★ MEDIUM 3
-- EN : Show delivery agents who are active AND (vehicle_type='Bike' OR rating > 4.5).
-- TM : Active agents, vehicle = Bike அல்லது rating > 4.5 உடையவர்களை காட்டு.


-- ★★★ HARD 1
-- EN : Show all menu items where NOT (is_veg = 1 AND price > 300).
--      Rewrite using De Morgan's Law equivalent.
-- TM : NOT (is_veg=1 AND price>300) condition-ஐ De Morgan's Law use செய்து rewrite செய்.


-- ★★★ HARD 2
-- EN : Find customers who have placed an order with status='Delivered' AND
--      also have at least one order with status='Cancelled'.
-- TM : ஒரே customer Delivered order-உம் Cancelled order-உம் இரண்டும் உடையவர்களை காட்டு.


-- ★★★ HARD 3
-- EN : Show restaurants where: (category_id IN (1,4) AND rating > 4.2)
--      OR (city_id = 1 AND is_open = 1 AND rating >= 4.0)
--      BUT NOT (restaurant_id IN (2, 8)).
-- TM : Complex logical conditions உடன் restaurants filter செய். Multiple AND/OR/NOT use செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 15 — IN, BETWEEN, ANY, ALL, EXISTS            ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show orders where payment_mode IN ('UPI', 'Card').
-- TM : UPI அல்லது Card payment mode உள்ள orders காட்டு.


-- ★ EASY 2
-- EN : Show menu items priced BETWEEN 100 AND 300.
-- TM : Price 100-க்கும் 300-க்கும் இடையே உள்ள menu items காட்டு.


-- ★ EASY 3
-- EN : Show restaurants with category_id NOT IN (5, 6, 7).
-- TM : category_id 5, 6, 7 இல்லாத restaurants காட்டு.


-- ★★ MEDIUM 1
-- EN : Show customers who have NOT placed any orders (use NOT EXISTS).
-- TM : ஒரு order-கூட போடாத customers-ஐ NOT EXISTS use செய்து காட்டு.


-- ★★ MEDIUM 2
-- EN : Show menu items whose price > ANY price in restaurant_id = 1's menu.
-- TM : Restaurant 1-இன் menu price-ஐ விட அதிகமான price உள்ள items காட்டு (ANY use செய்).


-- ★★ MEDIUM 3
-- EN : Show customers who exist in BOTH Customers table AND have placed an order (use EXISTS).
-- TM : Order போட்ட customers-ஐ EXISTS use செய்து காட்டு.


-- ★★★ HARD 1
-- EN : Show menu items whose price > ALL prices of veg items in the same restaurant.
--      (Non-veg items that are more expensive than all veg items in that restaurant.)
-- TM : Same restaurant-இல் எல்லா veg items-ஐ விட அதிகமான price உள்ள non-veg items காட்டு (ALL use செய்).


-- ★★★ HARD 2
-- EN : Show restaurants that have at least one order with total_amount > 500 (use EXISTS).
--      Compare with IN-based approach — write both.
-- TM : total_amount > 500 உள்ள order உடைய restaurants காட்டு. EXISTS மற்றும் IN இரண்டும் எழுது.


-- ★★★ HARD 3
-- EN : Show customers whose total spend is BETWEEN the average spend of customers
--      in city_id=1 and the average spend of customers in city_id=2.
-- TM : Total spend, city 1-இன் avg spend மற்றும் city 2-இன் avg spend-க்கு இடையே உள்ள
--      customers-ஐ BETWEEN use செய்து காட்டு.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 16 — SET Operators                            ║
║  UNION, INTERSECT, EXCEPT                            ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show all unique city_ids used in both Customers and Restaurants (UNION).
-- TM : Customers மற்றும் Restaurants இரண்டிலும் use ஆன unique city_ids காட்டு (UNION).


-- ★ EASY 2
-- EN : Show city_ids that appear in BOTH Customers AND Restaurants (INTERSECT).
-- TM : Customers மற்றும் Restaurants இரண்டிலும் உள்ள city_ids காட்டு (INTERSECT).


-- ★ EASY 3
-- EN : Show city_ids that have customers but NO restaurants (EXCEPT).
-- TM : Customers இருக்கும், restaurants இல்லாத city_ids காட்டு (EXCEPT).


-- ★★ MEDIUM 1
-- EN : Get a combined list of all names from Customers (full_name) and DeliveryAgents (agent_name)
--      with a label column showing 'Customer' or 'Agent'. Use UNION ALL.
-- TM : Customers மற்றும் DeliveryAgents-இன் பெயர்களை ஒரே list-ஆக காட்டு. Label சேர்.


-- ★★ MEDIUM 2
-- EN : Find customer_ids who placed orders in January 2024 but NOT in February 2024 (EXCEPT).
-- TM : Jan 2024-இல் order போட்டு, Feb 2024-இல் order போடாத customers காட்டு (EXCEPT).


-- ★★ MEDIUM 3
-- EN : Find restaurants that received both 5-star and 1-star food reviews (INTERSECT logic).
-- TM : 5 star மற்றும் 1 star review இரண்டும் பெற்ற restaurants காட்டு.


-- ★★★ HARD 1
-- EN : Use UNION ALL with GROUP BY to find how many entities are in each table:
--      Show table_name, row_count for Cities, Customers, Restaurants, Orders.
-- TM : UNION ALL use செய்து ஒவ்வொரு table-இன் row count-ஐ ஒரே result-ஆக காட்டு.


-- ★★★ HARD 2
-- EN : Find menu items that are available in more than one restaurant
--      (same item_name) using set operator logic.
-- TM : Same item_name ஒன்றுக்கும் அதிகமான restaurants-இல் இருந்தால் காட்டு.


-- ★★★ HARD 3
-- EN : UNION ALL vs UNION performance: Get all orders from Jan 2024 and all orders from Feb 2024
--      with UNION (removes duplicates) vs UNION ALL (keeps all). What's the difference here?
-- TM : Jan 2024 மற்றும் Feb 2024 orders-ஐ UNION மற்றும் UNION ALL இரண்டாலும் எடு.
--      வித்தியாசம் என்ன என்று explain செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 17 — JOINs                                    ║
║  INNER, LEFT, RIGHT, FULL OUTER, SELF, CROSS         ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show order_id and customer full_name using INNER JOIN.
-- TM : INNER JOIN use செய்து order_id மற்றும் customer பெயர் காட்டு.


-- ★ EASY 2
-- EN : Show all customers and their orders using LEFT JOIN
--      (include customers with no orders too).
-- TM : LEFT JOIN use செய்து எல்லா customers-ஐயும், அவர்களின் orders-ஐயும் காட்டு.
--      Order இல்லாத customers-உம் show ஆகட்டும்.


-- ★ EASY 3
-- EN : Show all restaurants and their category name using INNER JOIN.
-- TM : INNER JOIN use செய்து restaurant பெயர் மற்றும் category பெயர் காட்டு.


-- ★★ MEDIUM 1
-- EN : Show customers who have NO orders (use LEFT JOIN with NULL check).
-- TM : Order போடாத customers-ஐ LEFT JOIN + NULL check use செய்து காட்டு.


-- ★★ MEDIUM 2
-- EN : 3-table JOIN: Show order_id, customer name, restaurant name, and order status.
-- TM : 3 tables JOIN செய்து order_id, customer பெயர், restaurant பெயர், status காட்டு.


-- ★★ MEDIUM 3
-- EN : SELF JOIN: Find pairs of restaurants in the same city.
--      Show rest1.restaurant_name, rest2.restaurant_name, city_id.
-- TM : SELF JOIN use செய்து same city-இல் உள்ள restaurant pairs காட்டு.


-- ★★★ HARD 1
-- EN : 5-table JOIN: city → customer → order → orderitems → menuitem.
--      Show city name, customer name, item name, quantity, unit_price.
-- TM : 5 tables JOIN செய்து city பெயர், customer பெயர், item பெயர், quantity, price காட்டு.


-- ★★★ HARD 2
-- EN : FULL OUTER JOIN between Customers and Orders —
--      show customers with no orders AND orders with no matching customer (if any).
-- TM : FULL OUTER JOIN use செய்து orders இல்லாத customers மற்றும் customer இல்லாத orders காட்டு.


-- ★★★ HARD 3
-- EN : Show the most expensive item each customer has ever ordered.
--      Use JOIN + subquery or JOIN + window function.
-- TM : ஒவ்வொரு customer-ம் order செய்த most expensive item காட்டு.
--      JOIN + subquery அல்லது window function use செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 18 — String Functions                         ║
║  String manipulation                                 ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show all customer names in UPPERCASE.
-- TM : எல்லா customer பெயர்களையும் UPPERCASE-ஆல் காட்டு.


-- ★ EASY 2
-- EN : Show the length of each restaurant name.
-- TM : ஒவ்வொரு restaurant பெயரின் length காட்டு.


-- ★ EASY 3
-- EN : Show the first 5 characters of each customer's email.
-- TM : ஒவ்வொரு customer email-இன் முதல் 5 characters காட்டு.


-- ★★ MEDIUM 1
-- EN : Extract the username (part before @) from each customer's email.
-- TM : Customer email-இல் @ -க்கு முன்னால் உள்ள username பகுதி மட்டும் காட்டு.


-- ★★ MEDIUM 2
-- EN : Replace all spaces in restaurant names with underscores.
-- TM : Restaurant பெயரில் உள்ள spaces-ஐ underscores-ஆக மாற்று.


-- ★★ MEDIUM 3
-- EN : Show customer names that contain the letter 'a' (case-insensitive).
--      Use LIKE or CHARINDEX.
-- TM : 'a' என்ற letter கொண்ட customer பெயர்களை காட்டு. LIKE அல்லது CHARINDEX use செய்.


-- ★★★ HARD 1
-- EN : Build a formatted delivery label string:
--      'ORDER #[order_number] | [customer_name] | [city_name] | ₹[total_amount]'
--      Use CONCAT or + operator.
-- TM : Delivery label string format பண்ணு: 'ORDER #ORD-10001 | Arun Kumar | Chennai | ₹130.00'
--      CONCAT use செய்.


-- ★★★ HARD 2
-- EN : Show the domain part of each customer's email (part after @).
--      Then group by domain and count how many customers use each domain.
-- TM : Email-இல் @ பின்னால் உள்ள domain extract செய். Domain-வாரியாக customer count காட்டு.


-- ★★★ HARD 3
-- EN : Find customers whose name contains the same character repeated consecutively
--      (e.g., 'aa', 'rr'). Use PATINDEX or LIKE with pattern.
-- TM : பெயரில் consecutive duplicate characters உள்ள customers-ஐ PATINDEX use செய்து காட்டு.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 19 — Number Functions                         ║
║  Math operations on numbers                          ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show the rounded total_amount (to nearest 10) for each order.
-- TM : ஒவ்வொரு order-இன் total_amount-ஐ nearest 10-க்கு ROUND செய்து காட்டு.


-- ★ EASY 2
-- EN : Show ABS value of (total_amount - 400) for each order.
-- TM : (total_amount - 400)-இன் absolute value காட்டு.


-- ★ EASY 3
-- EN : Show CEILING and FLOOR of each menu item price divided by 7.
-- TM : Menu item price ÷ 7-இன் CEILING மற்றும் FLOOR காட்டு.


-- ★★ MEDIUM 1
-- EN : Calculate total tax (18% GST) per order. Round to 2 decimal places.
--      Show order_id, total_amount, gst_amount, total_with_gst.
-- TM : ஒவ்வொரு order-க்கும் GST (18%) calculate செய். total_with_gst காட்டு.


-- ★★ MEDIUM 2
-- EN : Show orders where total_amount POWER of 0.5 (square root) is > 20.
--      Use SQRT or POWER function.
-- TM : total_amount-இன் square root > 20 உள்ள orders காட்டு.


-- ★★ MEDIUM 3
-- EN : Rank menu items by price. Show RANK using price as the basis.
--      Also show price as percentage of max price in that restaurant.
-- TM : Menu items-ஐ price-ஆல் rank செய். அந்த restaurant max price-இல் இந்த item எத்தனை % என்று காட்டு.


-- ★★★ HARD 1
-- EN : Show compound discount: if a customer gets 10% off and then additional ₹50 flat off,
--      calculate final price for each order. Show formula step by step.
-- TM : 10% discount + ₹50 flat discount apply செய்தால் final price என்னவாகும்?
--      Step-by-step calculate செய்து காட்டு.


-- ★★★ HARD 2
-- EN : For each restaurant, calculate the standard deviation of menu item prices.
--      Use STDEV() aggregate function.
-- TM : ஒவ்வொரு restaurant-இல் menu item prices-இன் standard deviation கண்டுபிடி.


-- ★★★ HARD 3
-- EN : Find the geometric mean of all order amounts (EXP(AVG(LOG(total_amount)))).
--      Use LOG, EXP math functions.
-- TM : எல்லா order amounts-இன் geometric mean கண்டுபிடி. LOG, EXP functions use செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 20 — Date / Time Functions                    ║
║  Date operations                                     ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show the year and month of each order date.
-- TM : ஒவ்வொரு order-இன் year மற்றும் month காட்டு.


-- ★ EASY 2
-- EN : Show how many days ago each order was placed (from today).
-- TM : ஒவ்வொரு order எத்தனை நாட்களுக்கு முன்பு place ஆனது என்று காட்டு.


-- ★ EASY 3
-- EN : Show the weekday name for each order (Monday, Tuesday...).
-- TM : ஒவ்வொரு order எந்த weekday-ல் place ஆனது என்று காட்டு.


-- ★★ MEDIUM 1
-- EN : Show orders placed in the last 90 days. Use DATEADD.
-- TM : கடந்த 90 நாட்களில் place ஆன orders காட்டு. DATEADD use செய்.


-- ★★ MEDIUM 2
-- EN : Find how many days each customer has been registered (from registered_on to today).
-- TM : ஒவ்வொரு customer எத்தனை நாட்களாக registered ஆக இருக்கிறார் என்று காட்டு.


-- ★★ MEDIUM 3
-- EN : Show the first day of the month for each order_date.
-- TM : ஒவ்வொரு order_date-இன் அந்த மாதத்தின் முதல் நாள் என்ன என்று காட்டு.


-- ★★★ HARD 1
-- EN : Calculate each restaurant's "age" in years and months from opened_on to today.
--      Format as 'X years Y months'.
-- TM : ஒவ்வொரு restaurant opened ஆன date-இல் இருந்து இன்று வரை எத்தனை years, months என்று காட்டு.


-- ★★★ HARD 2
-- EN : Find the busiest hour of day for orders (which hour has the most orders).
--      Use DATEPART(HOUR, order_date).
-- TM : ஒரு நாளில் எந்த hour-ல் மிகவும் அதிகமாக orders வருகின்றன என்று கண்டுபிடி.


-- ★★★ HARD 3
-- EN : Show orders placed on weekends vs weekdays separately.
--      Count and total revenue for each. Use DATEPART(WEEKDAY,...).
-- TM : Weekend-இல் மற்றும் Weekday-இல் place ஆன orders-ஐ தனியாக காட்டு.
--      Count மற்றும் total revenue compare செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 21 — NULL Functions                           ║
║  ISNULL, COALESCE, NULLIF                            ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show agent_id for each order. Replace NULL with 0 using ISNULL.
-- TM : Orders-இல் agent_id NULL ஆக இருந்தால் 0 காட்டு. ISNULL use செய்.


-- ★ EASY 2
-- EN : Show review_text for each review. If NULL, show 'No review given'.
-- TM : Review text இல்லாவிட்டால் 'No review given' காட்டு.


-- ★ EASY 3
-- EN : Count how many orders have NULL agent_id.
-- TM : Agent assign ஆகாத orders எத்தனை என்று count செய்.


-- ★★ MEDIUM 1
-- EN : Use COALESCE to show: agent_name if assigned, else 'Unassigned'.
--      Join DeliveryAgents table.
-- TM : Agent assigned ஆனால் பெயர், இல்லாவிட்டால் 'Unassigned' காட்டு. COALESCE use செய்.


-- ★★ MEDIUM 2
-- EN : Use NULLIF to convert discount = 0 to NULL.
--      Then compute average discount excluding zero-discount orders.
-- TM : discount = 0-ஐ NULL ஆக மாற்றி NULLIF use செய். Zero discount இல்லாத avg discount கண்டுபிடி.


-- ★★ MEDIUM 3
-- EN : Show the effective agent rating: use the agent's rating if available,
--      else use the restaurant's average review rating, else 0.
--      Use COALESCE with multiple fallbacks.
-- TM : Agent rating இல்லாவிட்டால் restaurant review avg rating, அதுவும் இல்லாவிட்டால் 0 காட்டு.
--      COALESCE multiple fallback use செய்.


-- ★★★ HARD 1
-- EN : Identify all columns across all tables that allow NULL values.
--      Query INFORMATION_SCHEMA.COLUMNS.
-- TM : FoodDeliveryDB-இல் NULL allow செய்யும் எல்லா columns-ஐ INFORMATION_SCHEMA use செய்து காட்டு.


-- ★★★ HARD 2
-- EN : Write a query that shows the "completeness score" of each order:
--      +1 for agent assigned, +1 for review exists, +1 for discount > 0.
--      Max score = 3. Use CASE + NULL checks.
-- TM : ஒவ்வொரு order-க்கும் completeness score calculate செய் (agent, review, discount).
--      Max 3 points. CASE + NULL check use செய்.


-- ★★★ HARD 3
-- EN : Show all orders where either delivery_rating IS NULL (no review) or
--      food_rating < 3. These are "attention needed" orders.
--      Show customer name, restaurant, and a reason column.
-- TM : Review இல்லாத அல்லது food_rating < 3 உள்ள orders "attention needed" ஆக காட்டு.
--      Reason column சேர்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 22 — CASE Statements                          ║
║  Conditional logic                                   ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show each order with a label: 'Cheap' (< 200), 'Moderate' (200–500), 'Expensive' (> 500).
-- TM : Order amount-ஆல் 'Cheap', 'Moderate', 'Expensive' label assign செய்.


-- ★ EASY 2
-- EN : Show is_veg as 'Veg' or 'Non-Veg' for each menu item.
-- TM : is_veg column-ஐ 'Veg' அல்லது 'Non-Veg' ஆக காட்டு.


-- ★ EASY 3
-- EN : Show order status with an emoji: Delivered ✅, Cancelled ❌, others 🔄.
-- TM : Order status-க்கு emoji label காட்டு.


-- ★★ MEDIUM 1
-- EN : Show each customer's loyalty tier based on total orders:
--      0 orders = 'New', 1–2 = 'Bronze', 3–5 = 'Silver', 6+ = 'Gold'.
-- TM : Customer order count-ஆல் loyalty tier assign செய். (New, Bronze, Silver, Gold)


-- ★★ MEDIUM 2
-- EN : Show restaurants with a "performance" label:
--      rating >= 4.5 = 'Excellent', 4.0–4.4 = 'Good', < 4.0 = 'Needs Improvement'.
-- TM : Restaurant rating-ஆல் performance label assign செய்.


-- ★★ MEDIUM 3
-- EN : Pivot-style report: Show count of orders for each status
--      as separate columns using CASE + SUM.
--      Columns: placed_count, confirmed_count, delivered_count, cancelled_count.
-- TM : CASE + SUM use செய்து order status-ஐ pivot table-போல் columns-ஆக காட்டு.


-- ★★★ HARD 1
-- EN : Show delivery agent performance:
--      If rating >= 4.5 AND total deliveries >= 5 = 'Star Agent'
--      If rating >= 4.0 = 'Good Agent'
--      Else = 'Needs Training'. Use nested CASE or AND logic.
-- TM : Agent rating மற்றும் total deliveries combine செய்து performance label assign செய்.


-- ★★★ HARD 2
-- EN : Show a discount effectiveness report:
--      For each order, show if discount helped (order > avg order) or not.
--      Use CASE with subquery.
-- TM : Discount பெற்ற orders, average-ஐ விட அதிகமாக இருக்கிறதா என்று CASE + subquery use செய்து காட்டு.


-- ★★★ HARD 3
-- EN : Build a complete summary row per city using CASE + GROUP BY:
--      city_name, total_customers, total_orders, total_revenue,
--      best_rating_restaurant (use MAX with CASE).
-- TM : City-வாரியாக summary row உருவாக்கு. CASE + GROUP BY use செய்து best restaurant காட்டு.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 23 — Aggregate Functions                      ║
║  COUNT, SUM, AVG, MIN, MAX                           ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Find the total number of orders in the database.
-- TM : Database-இல் மொத்தம் எத்தனை orders இருக்கின்றன?


-- ★ EASY 2
-- EN : Find the maximum, minimum, and average menu item price.
-- TM : Menu item-இன் max price, min price, average price கண்டுபிடி.


-- ★ EASY 3
-- EN : Find the total revenue from all delivered orders.
-- TM : Delivered orders மொத்த revenue என்ன?


-- ★★ MEDIUM 1
-- EN : Show COUNT, SUM, AVG of orders grouped by restaurant_id.
-- TM : Restaurant-வாரியாக order count, sum, avg காட்டு.


-- ★★ MEDIUM 2
-- EN : Find the customer who has spent the most money overall.
-- TM : மொத்தமாக மிகவும் அதிகமாக செலவழித்த customer யார்?


-- ★★ MEDIUM 3
-- EN : Show COUNT(DISTINCT customer_id) — unique customers who ordered per restaurant.
-- TM : ஒவ்வொரு restaurant-இலும் unique customers எத்தனை பேர் order போட்டிருக்கிறார்கள்?


-- ★★★ HARD 1
-- EN : Show for each restaurant:
--      total_orders, total_revenue, avg_revenue, best_order (MAX),
--      worst_order (MIN), unique_customers.
-- TM : Restaurant-வாரியாக 6 aggregate values ஒரே query-ல் காட்டு.


-- ★★★ HARD 2
-- EN : Show the percentage contribution of each restaurant to total overall revenue.
--      (restaurant_revenue / total_revenue) * 100.
-- TM : ஒவ்வொரு restaurant-இன் revenue, total revenue-இல் எத்தனை % என்று காட்டு.


-- ★★★ HARD 3
-- EN : Compare month-over-month revenue: For each month, show current_month_revenue
--      and previous_month_revenue. Use aggregate + LAG window function.
-- TM : Month-over-month revenue compare செய். Current month vs Previous month revenue காட்டு.
--      Aggregate + LAG window function use செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 24 — Window Functions (Basics + Aggregations) ║
║  OVER(), PARTITION BY, ORDER BY                      ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Show each order along with the total count of all orders using a window function.
-- TM : ஒவ்வொரு order row-உடன் மொத்த order count-ஐ Window function-ஆல் காட்டு.


-- ★ EASY 2
-- EN : Show each order with the running total of total_amount (cumulative sum).
-- TM : ஒவ்வொரு order-க்கும் running total (cumulative sum) காட்டு.


-- ★ EASY 3
-- EN : Show each order with the average total_amount per restaurant (partition by restaurant).
-- TM : ஒவ்வொரு order-க்கும் அந்த restaurant-இன் average order amount காட்டு (PARTITION BY).


-- ★★ MEDIUM 1
-- EN : Show each order with:
--      - Running total of amount (ORDER BY order_date)
--      - Moving average of last 3 orders
-- TM : Running total மற்றும் last 3 orders-இன் moving average காட்டு.


-- ★★ MEDIUM 2
-- EN : For each customer, show their orders and cumulative spend so far (ordered by date).
-- TM : ஒவ்வொரு customer-க்கும் date-வாரியாக cumulative spend காட்டு.


-- ★★ MEDIUM 3
-- EN : Show MAX and MIN total_amount within each city (partition by customer's city).
-- TM : ஒவ்வொரு order-க்கும் அந்த city-இல் max மற்றும் min order amount காட்டு.


-- ★★★ HARD 1
-- EN : Show the difference between each order's amount and the previous order's amount
--      for the same customer (LAG function).
-- TM : Same customer-இன் consecutive orders-க்கு இடையே உள்ள amount difference காட்டு (LAG).


-- ★★★ HARD 2
-- EN : Show a 3-order rolling average revenue for each restaurant (partition by restaurant_id).
-- TM : Restaurant-வாரியாக 3-order rolling average revenue காட்டு.


-- ★★★ HARD 3
-- EN : Show for each order:
--      - Its rank within the customer's orders (by amount)
--      - The % of that order to customer's total spend
--      - Label if it's customer's best order
-- TM : ஒவ்வொரு order-க்கும் customer-இல் rank, customer total-இல் %, best order label காட்டு.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 25 — Window Ranking Functions                 ║
║  ROW_NUMBER, RANK, DENSE_RANK, NTILE, PERCENT_RANK   ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Assign ROW_NUMBER to all customers ordered by registered_on.
-- TM : Customers-ஐ registered_on-ஆல் order செய்து ROW_NUMBER assign செய்.


-- ★ EASY 2
-- EN : RANK menu items by price (highest first). Same prices get same rank.
-- TM : Menu items-ஐ price-ஆல் RANK செய் (highest first).


-- ★ EASY 3
-- EN : Divide all orders into 4 equal groups (NTILE 4) based on total_amount.
-- TM : Orders-ஐ total_amount-ஆல் 4 groups-ஆக NTILE use செய்து பிரி.


-- ★★ MEDIUM 1
-- EN : Rank restaurants within each city by their rating. Show top-ranked per city.
-- TM : ஒவ்வொரு city-லும் restaurants-ஐ rating-ஆல் rank செய். Top 1 per city காட்டு.


-- ★★ MEDIUM 2
-- EN : Show DENSE_RANK vs RANK for menu items by price — highlight the difference.
-- TM : Menu items-இன் price-ஆல் DENSE_RANK vs RANK-ஐ compare செய். வித்தியாசம் காட்டு.


-- ★★ MEDIUM 3
-- EN : Find the top 2 customers by total spend per city using DENSE_RANK.
-- TM : ஒவ்வொரு city-லும் top 2 customers (total spend ஆல்) DENSE_RANK use செய்து காட்டு.


-- ★★★ HARD 1
-- EN : Show PERCENT_RANK of each restaurant's rating within its category.
--      Format as percentage. Interpret: what does 90th percentile mean here?
-- TM : Restaurant rating-இன் PERCENT_RANK category-வாரியாக காட்டு. 90th percentile explain செய்.


-- ★★★ HARD 2
-- EN : Identify the top 3 orders per restaurant by total_amount using ROW_NUMBER.
--      Filter in outer query using CTE.
-- TM : ஒவ்வொரு restaurant-இல் top 3 orders ROW_NUMBER + CTE use செய்து காட்டு.


-- ★★★ HARD 3
-- EN : Build a leaderboard:
--      Rank customers by (total_orders DESC, total_revenue DESC, registration_date ASC).
--      Show rank, customer name, city, orders, revenue.
-- TM : Customer leaderboard உருவாக்கு. Multiple sort criteria use செய்து RANK assign செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 26 — Subqueries                               ║
║  Nested queries                                      ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Find the most expensive menu item using a subquery.
-- TM : Subquery use செய்து most expensive menu item கண்டுபிடி.


-- ★ EASY 2
-- EN : Show customers who live in the same city as restaurant_id = 1.
-- TM : Restaurant 1 இருக்கும் city-ல் வசிக்கும் customers காட்டு. Subquery use செய்.


-- ★ EASY 3
-- EN : Find all orders above the average order amount.
-- TM : Average order amount-ஐ விட அதிகமான orders காட்டு. Subquery use செய்.


-- ★★ MEDIUM 1
-- EN : Show each restaurant and the number of items it has, but only for restaurants
--      that have MORE items than the average number of items per restaurant.
-- TM : Average item count-ஐ விட அதிகமான items உள்ள restaurants மட்டும் காட்டு.


-- ★★ MEDIUM 2
-- EN : Find the customer(s) who placed the single most expensive order.
--      Use a correlated subquery.
-- TM : Highest total_amount order போட்ட customer யார்? Correlated subquery use செய்.


-- ★★ MEDIUM 3
-- EN : Find restaurants that have never received a review.
--      Use NOT IN with subquery.
-- TM : ஒரு review-கூட இல்லாத restaurants காட்டு. NOT IN + subquery use செய்.


-- ★★★ HARD 1
-- EN : For each customer, show their most recent order details
--      using a correlated subquery.
-- TM : ஒவ்வொரு customer-இன் most recent order details correlated subquery use செய்து காட்டு.


-- ★★★ HARD 2
-- EN : Show restaurants whose average food_rating is higher than the overall
--      average food_rating across all restaurants.
-- TM : Overall average food_rating-ஐ விட அதிக average food_rating உள்ள restaurants காட்டு.
--      Subquery in HAVING use செய்.


-- ★★★ HARD 3
-- EN : Find the second most expensive menu item per restaurant using a subquery.
-- TM : ஒவ்வொரு restaurant-இல் 2nd most expensive menu item கண்டுபிடி. Subquery use செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 27 — CTE (Common Table Expressions)           ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Write a CTE that lists all delivered orders. Then SELECT from it.
-- TM : Delivered orders-ஐ CTE-ல் வை. பிறகு SELECT செய்.


-- ★ EASY 2
-- EN : Write a CTE to calculate each restaurant's total revenue.
-- TM : Restaurant-வாரியாக total revenue CTE-ல் calculate செய்.


-- ★ EASY 3
-- EN : Write a CTE for the top 5 most expensive menu items.
-- TM : Top 5 expensive menu items-ஐ CTE use செய்து காட்டு.


-- ★★ MEDIUM 1
-- EN : Write a multi-CTE query:
--      CTE1: total revenue per restaurant
--      CTE2: filter restaurants with revenue > 500
--      Final SELECT: show restaurant name and revenue.
-- TM : Multi-CTE use செய். CTE1 revenue calculate செய். CTE2 filter செய். Final result காட்டு.


-- ★★ MEDIUM 2
-- EN : Use a CTE to rank customers by total orders, then show only rank 1–5.
-- TM : CTE use செய்து customers-ஐ rank செய். Top 5 மட்டும் காட்டு.


-- ★★ MEDIUM 3
-- EN : Write a CTE that calculates each agent's total delivered orders and average rating.
--      Then SELECT agents where both metrics are above average.
-- TM : Agent deliveries மற்றும் ratings CTE-ல் calculate செய்.
--      Average-ஐ விட அதிகமான agents மட்டும் காட்டு.


-- ★★★ HARD 1
-- EN : Write a recursive CTE to generate numbers 1–30.
--      Use it to create a calendar of order dates and fill in missing dates with 0 revenue.
-- TM : Recursive CTE use செய்து 1-30 numbers generate செய்.
--      Order dates calendar உருவாக்கு. Orders இல்லாத dates-க்கு 0 revenue காட்டு.


-- ★★★ HARD 2
-- EN : Use a CTE to identify customers who have spent MORE in their 2nd order than their 1st order.
-- TM : 2nd order amount > 1st order amount உள்ள customers-ஐ CTE use செய்து கண்டுபிடி.


-- ★★★ HARD 3
-- EN : Build a full customer analytics CTE chain:
--      CTE1: total orders + total spend per customer
--      CTE2: add loyalty tier (CASE)
--      CTE3: add city name (JOIN)
--      Final: show all columns with rank by spend.
-- TM : 3-level CTE chain உருவாக்கு. Orders, Tier, City, Rank — எல்லாம் ஒரே query-ல் காட்டு.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 28 — Views                                    ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Create a view called vw_ActiveRestaurants showing only open restaurants
--      with their city name and category name.
-- TM : Open restaurants + city + category காட்டும் vw_ActiveRestaurants view உருவாக்கு.


-- ★ EASY 2
-- EN : Query the existing vw_OrderSummary view — show only Delivered orders.
-- TM : vw_OrderSummary view-இல் இருந்து Delivered orders மட்டும் SELECT செய்.


-- ★ EASY 3
-- EN : List all views in FoodDeliveryDB using sys.views or INFORMATION_SCHEMA.
-- TM : FoodDeliveryDB-இல் உள்ள எல்லா views-ஐ sys.views use செய்து காட்டு.


-- ★★ MEDIUM 1
-- EN : Create a view vw_CustomerOrderStats showing:
--      customer_id, full_name, total_orders, total_spent, last_order_date.
-- TM : Customer statistics-ஐ காட்டும் vw_CustomerOrderStats view உருவாக்கு.


-- ★★ MEDIUM 2
-- EN : Create a view vw_TopRatedRestaurants for restaurants with avg food_rating > 4.0.
--      Include: restaurant_name, category, city, avg_rating.
-- TM : Average food rating > 4.0 உள்ள restaurants-க்கான vw_TopRatedRestaurants view உருவாக்கு.


-- ★★ MEDIUM 3
-- EN : Alter vw_ActiveRestaurants to also include the restaurant's rating.
--      (DROP and recreate, or use ALTER VIEW.)
-- TM : vw_ActiveRestaurants view-ல் rating column சேர். ALTER VIEW use செய்.


-- ★★★ HARD 1
-- EN : Create a view vw_DailyRevenueSummary showing date, total_orders, total_revenue
--      for all delivered orders. Query it to find the best revenue day.
-- TM : Daily revenue summary view உருவாக்கு. Best revenue day கண்டுபிடி.


-- ★★★ HARD 2
-- EN : Create an updatable view (WITH CHECK OPTION) that shows only Chennai customers (city_id=1).
--      Try inserting a customer with city_id=2 through the view — it should fail.
-- TM : WITH CHECK OPTION உடன் view உருவாக்கு. Different city customer insert செய்ய முயற்சி.


-- ★★★ HARD 3
-- EN : Create a complex view that joins 5 tables and uses CASE, aggregation, and window functions.
--      The view should show: agent performance scorecard.
-- TM : 5 tables JOIN + CASE + Window function உடன் Agent scorecard view உருவாக்கு.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 29 — Temporary Tables                         ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Create a local temp table #TopCustomers and insert the top 5 customers by order count.
-- TM : #TopCustomers temp table உருவாக்கி top 5 customers insert செய்.


-- ★ EASY 2
-- EN : Use SELECT INTO to create a temp table #DeliveredOrders from Orders where status='Delivered'.
-- TM : Delivered orders மட்டும் SELECT INTO-ஐ use செய்து #DeliveredOrders temp table உருவாக்கு.


-- ★ EASY 3
-- EN : Create a temp table, insert data, query it, and DROP it. Show the full lifecycle.
-- TM : Temp table create → insert → select → drop — full lifecycle காட்டு.


-- ★★ MEDIUM 1
-- EN : Create a global temp table ##RestaurantSummary with aggregated data.
--      Explain the difference between # and ## temp tables.
-- TM : ## global temp table உருவாக்கு. # vs ## வித்தியாசம் explain செய்.


-- ★★ MEDIUM 2
-- EN : Use a temp table to store intermediate results:
--      Step 1: Insert order totals per customer into #CustomerTotals.
--      Step 2: JOIN #CustomerTotals with Customers to show final report.
-- TM : Intermediate results temp table-இல் store செய். 2-step query எழுது.


-- ★★ MEDIUM 3
-- EN : Create a temp table with an index. Insert 30 rows. Query with WHERE on indexed column.
-- TM : Index உடன் temp table உருவாக்கு. 30 rows insert செய். Index column-ஆல் query செய்.


-- ★★★ HARD 1
-- EN : Use a temp table inside a stored procedure:
--      Create sp_GetCityReport that takes @city_id, uses temp table internally,
--      and returns restaurant + order summary for that city.
-- TM : Stored procedure-க்குள் temp table use செய்.
--      sp_GetCityReport(@city_id) procedure எழுது.


-- ★★★ HARD 2
-- EN : Compare Temp Table vs CTE vs Subquery for the same problem:
--      Find customers who have placed more than 1 order.
--      Write all 3 approaches and observe.
-- TM : Same problem-ஐ Temp Table, CTE, Subquery — 3 வழிகளிலும் solve செய்.


-- ★★★ HARD 3
-- EN : Simulate a multi-step ETL using temp tables:
--      #Raw → extract all orders
--      #Cleaned → filter Delivered only
--      #Report → aggregate by restaurant
--      Final SELECT from #Report.
-- TM : Multi-step ETL simulate செய். Raw → Cleaned → Report → Final SELECT.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 30 — Stored Procedures                        ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Create sp_GetAllRestaurants — a simple procedure that returns all restaurants.
-- TM : எல்லா restaurants-ஐ return செய்யும் sp_GetAllRestaurants procedure உருவாக்கு.


-- ★ EASY 2
-- EN : Create sp_GetOrdersByCustomer @customer_id INT — returns all orders for that customer.
-- TM : Customer ID கொடுத்தால் அந்த customer orders return செய்யும் procedure உருவாக்கு.


-- ★ EASY 3
-- EN : Execute both procedures you just created.
-- TM : உருவாக்கிய procedures இரண்டையும் EXEC செய்.


-- ★★ MEDIUM 1
-- EN : Create sp_PlaceOrder with params: @customer_id, @restaurant_id, @payment_mode.
--      Insert into Orders and return the new order_id.
-- TM : New order insert செய்து new order_id return செய்யும் sp_PlaceOrder procedure எழுது.


-- ★★ MEDIUM 2
-- EN : Create sp_UpdateOrderStatus @order_id INT, @new_status VARCHAR(50).
--      Include validation — status must be valid, else RAISERROR.
-- TM : Order status update செய்யும் procedure எழுது. Invalid status-க்கு RAISERROR throw செய்.


-- ★★ MEDIUM 3
-- EN : Create sp_GetRestaurantReport @restaurant_id INT that returns:
--      restaurant info, total orders, total revenue, avg rating.
-- TM : Restaurant-இன் full report return செய்யும் procedure எழுது.


-- ★★★ HARD 1
-- EN : Create sp_CancelOrder @order_id INT:
--      - Check if order exists
--      - Check if status allows cancellation
--      - Update status to Cancelled
--      - Return success/failure message
--      Use TRY-CATCH.
-- TM : Order cancel செய்யும் procedure எழுது. TRY-CATCH use செய். Validation செய்.


-- ★★★ HARD 2
-- EN : Create sp_CustomerFullProfile @customer_id INT that returns 3 result sets:
--      1. Customer info
--      2. Order history
--      3. Review history
-- TM : Customer profile procedure எழுது. 3 result sets return செய்.


-- ★★★ HARD 3
-- EN : Create sp_GenerateMonthlyReport @year INT, @month INT:
--      Returns total orders, revenue, new customers, top restaurant, top agent.
--      Use temp tables internally.
-- TM : Monthly report generate செய்யும் procedure எழுது.
--      5 metrics return செய். Temp tables internally use செய்.


/*
╔══════════════════════════════════════════════════════╗
║  TOPIC 31 — Triggers                                 ║
╚══════════════════════════════════════════════════════╝
*/

-- ★ EASY 1
-- EN : Create an AFTER INSERT trigger on Reviews that prints 'New review added!'
--      using PRINT statement.
-- TM : Reviews-இல் new row insert ஆனால் 'New review added!' print செய்யும் trigger உருவாக்கு.


-- ★ EASY 2
-- EN : Create a trigger that prevents inserting an order with total_amount = 0.
--      Use INSTEAD OF INSERT on Orders.
-- TM : total_amount = 0 உடன் order insert செய்யாமல் தடுக்கும் INSTEAD OF trigger உருவாக்கு.


-- ★ EASY 3
-- EN : List all triggers in FoodDeliveryDB using sys.triggers.
-- TM : FoodDeliveryDB-இல் உள்ள எல்லா triggers-ஐ sys.triggers use செய்து காட்டு.


-- ★★ MEDIUM 1
-- EN : Create an AFTER UPDATE trigger on Restaurants that logs rating changes
--      into a RestaurantRatingLog table (old_rating, new_rating, changed_on).
-- TM : Restaurant rating மாறும்போது log செய்யும் AFTER UPDATE trigger உருவாக்கு.


-- ★★ MEDIUM 2
-- EN : Create a trigger that automatically sets is_active = 0 for a customer
--      when all their orders are cancelled.
-- TM : Customer-இன் எல்லா orders cancelled ஆனால் customer-ஐ inactive ஆக்கும் trigger எழுது.


-- ★★ MEDIUM 3
-- EN : Create a trigger on OrderItems that updates the total_amount in Orders
--      after any INSERT or UPDATE on OrderItems.
-- TM : OrderItems insert/update ஆனால் Orders.total_amount automatically update ஆகும்படி trigger எழுது.


-- ★★★ HARD 1
-- EN : Create an audit trigger on Customers table that logs:
--      old_name, new_name, old_email, new_email, changed_by, changed_on
--      into CustomerAuditLog table. Handle multiple row updates.
-- TM : Customers update ஆனால் audit log செய்யும் trigger எழுது. Multiple rows handle செய்.


-- ★★★ HARD 2
-- EN : Create an INSTEAD OF DELETE trigger on Restaurants:
--      Instead of deleting, set is_open = 0 (soft delete).
--      Also log the attempted deletion.
-- TM : Restaurant delete attempt-ஐ intercept செய்து soft delete (is_open=0) செய்யும் trigger எழுது.


-- ★★★ HARD 3
-- EN : Create a trigger that enforces business logic:
--      A customer cannot place more than 3 orders on the same day.
--      AFTER INSERT on Orders — if violated, ROLLBACK and RAISERROR.
-- TM : ஒரே நாளில் 3-க்கும் அதிகமான orders போட முயன்றால் ROLLBACK செய்யும் trigger எழுது.


-- ============================================================
-- END OF PRACTICE QUESTIONS
-- Total: 23 Topics × 9 Questions = 207 Questions
-- Levels: Easy (3) + Medium (3) + Hard (3) per topic
-- ============================================================
