-- ★ EASY 1
-- EN : Try inserting a restaurant with rating = 6.0 — it should fail. Write the insert and
--      explain which constraint stops it.
-- TM : rating = 6.0 உடன் restaurant insert செய்ய முயற்சி. எந்த constraint block செய்கிறது?

insert into Restaurants(restaurant_name,category_id,city_id,address,rating,is_open,opened_on)
values('hamus',1,1,'kodaikanal',6.0,1,getdate())

select * from INFORMATION_SCHEMA.CHECK_CONSTRAINTS where CONSTRAINT_NAME = 'CK__Restauran__ratin__5535A963'


-- ★ EASY 2
-- EN : Try inserting a customer without an email — which constraint prevents it?
-- TM : Email இல்லாமல் customer insert செய்ய முயற்சி. எந்த constraint block செய்கிறது?

insert into Customers(full_name,phone,city_id,registered_on,is_active)
values('thillai','8767898765',1,GETDATE(),0)

-- email column not null 



-- ★ EASY 3
-- EN : Insert a delivery agent without specifying rating — what default value gets set?
-- TM : Rating கொடுக்காமல் delivery agent insert செய். Default value என்ன set ஆகும்?


select * from DeliveryAgents

insert into DeliveryAgents (agent_name,phone,city_id,vehicle_type,is_active,joined_on)
values('Tamilvani','8675692638',1,'Bike',1,GETDATE())


-- ★★ MEDIUM 1
-- EN : Add a UNIQUE constraint on the 'phone' column of DeliveryAgents table.
--      Then try inserting a duplicate phone number.
-- TM : DeliveryAgents-இல் phone column-க்கு UNIQUE constraint சேர்.
--      Duplicate phone insert செய்ய முயற்சி.

alter table DeliveryAgents add constraint Unique_phone_agent unique(phone)
insert into DeliveryAgents (agent_name,phone,city_id,vehicle_type,is_active,joined_on)
values('Tamilvani','8675692638',1,'Bike',1,GETDATE())



-- ★★ MEDIUM 2
-- EN : Add a CHECK constraint to Orders: discount must not be greater than total_amount.
-- TM : Orders table-இல் discount > total_amount ஆகக்கூடாது என்று CHECK constraint சேர்.

select * from Orders

alter table orders add constraint check_con_order check (discount < total_amount) 

update orders set discount = 150 where order_id=1

-- ★★ MEDIUM 3
-- EN : Find all constraints defined on the Orders table using system catalog views
--      (sys.check_constraints, sys.foreign_keys, etc.).
-- TM : Orders table-இல் உள்ள எல்லா constraints-ஐயும் system catalog-ஐ use செய்து காட்டு.

select * from sys.check_constraints as cc
inner join sys.tables as tt on tt.object_id = cc.parent_object_id
where tt.name = 'orders'

select * from sys.tables


-- ★★★ HARD 1
-- EN : Disable a CHECK constraint on MenuItems (price > 0), insert a row with price = -10,
--      then re-enable the constraint. Observe behavior.
-- TM : MenuItems-இல் CHECK constraint-ஐ disable செய். price = -10 insert செய்.
--      பிறகு constraint-ஐ re-enable செய். என்ன நடக்கிறது?


