/*==============================================================
    FILE NAME:
    03_SQL_DML_And_Alter_Table_Example.sql
==============================================================*/


/*==============================================================
    01. CREATE TABLE
==============================================================*/
-- Creating a table to store international cricket teams

CREATE TABLE international_teams
(
    team_id     INT,             -- Team ID
    team_name   VARCHAR(50),     -- Team Name
    team_rank   INT              -- Team Ranking
);


/*==============================================================
    02. VIEW TABLE DATA
==============================================================*/
-- Display all records from table

SELECT * 
FROM international_teams;


/*==============================================================
    03. INSERT DATA INTO TABLE
==============================================================*/
-- Method 1: Insert data by specifying column names

INSERT INTO international_teams (team_id, team_name, team_rank)
VALUES
    (1, 'India', 1),
    (2, 'Australia', 3),
    (3, 'England', 2);


-- Method 2: Insert data without column names
-- (Order of values must match table structure)

INSERT INTO international_teams
VALUES
    (4, 'West Indians', 5),
    (5, 'South Africa', 4);


/*==============================================================
    04. ALTER TABLE (MODIFY COLUMN)
==============================================================*/

-- Change column size
ALTER TABLE international_teams
ALTER COLUMN team_name VARCHAR(15);

-- Change data type
ALTER TABLE international_teams
ALTER COLUMN team_name NVARCHAR(15);

-- Make column NOT NULL
ALTER TABLE international_teams
ALTER COLUMN team_name VARCHAR(15) NOT NULL;

-- ❌ ERROR: Data type is mandatory while altering column
-- ALTER TABLE international_teams ALTER COLUMN team_name NOT NULL;

-- Change column to allow NULL values
ALTER TABLE international_teams
ALTER COLUMN team_name NVARCHAR(20) NULL;


/*==============================================================
    05. ADD NEW COLUMN
==============================================================*/

-- ❌ ERROR: COLUMN keyword not used in SQL Server
-- ALTER TABLE international_teams ADD COLUMN team_type VARCHAR(50) NULL;

-- ❌ ERROR: NOT NULL column requires default value
-- ALTER TABLE international_teams ADD team_type VARCHAR(50) NOT NULL;

-- ✅ Correct way to add column
ALTER TABLE international_teams
ADD team_type VARCHAR(50) NULL;


-- Drop the added column
ALTER TABLE international_teams
DROP COLUMN team_type;


/*==============================================================
    06. RENAME TABLE & COLUMN
==============================================================*/

-- Rename table
EXEC sp_rename 'international_teams', 'i_teams';

-- Rename column
EXEC sp_rename 'i_teams.team_rank', 'world_rank';


/*==============================================================
    07. TRUNCATE TABLE
==============================================================*/
-- Deletes all rows but keeps table structure

TRUNCATE TABLE i_teams;


/*==============================================================
    08. VIEW TABLE AFTER TRUNCATE
==============================================================*/

SELECT * 
FROM i_teams;


/*==============================================================
    09. DROP TABLE
==============================================================*/
-- Permanently deletes table and data

DROP TABLE i_teams;
