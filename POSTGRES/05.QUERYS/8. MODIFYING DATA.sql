**********************************************************************************************************************************
--MODIFYING DATA
----------------

--CREATE A TABLE
CREATE TABLE worker
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	position VARCHAR(50)
)

SELECT * FROM worker
**********************************************************************************************************************

**********************************************************************************************************************
--INSERT
INSERT INTO worker (name, position) VALUES ('Abi', 'Software Engineer');

--INSERT INTO MULTIPLE
INSERT INTO worker (name, position) VALUES 
('Dharshini', 'Data Scientist'),
('Thilai', 'Product Manager'),
('Tamizh', 'CEO');
**********************************************************************************************************************

**********************************************************************************************************************
--UPDATE
UPDATE worker SET position = 'Senior Software Engineer' WHERE id = 1;
**********************************************************************************************************************

**********************************************************************************************************************
--DELETE
DELETE FROM worker WHERE id = 3;
**********************************************************************************************************************

**********************************************************************************************************************
--UPSERT
INSERT INTO worker (name, position)
VALUES ('Thillai', 'Team Leader')
ON CONFLICT(name) 
DO UPDATE SET position = EXCLUDED.position

--The ON CONFLICT clause relies on a unique identifier to detect conflicts.
--If you try to use ON CONFLICT without a primary key or unique constraint, PostgreSQL will throw the error: