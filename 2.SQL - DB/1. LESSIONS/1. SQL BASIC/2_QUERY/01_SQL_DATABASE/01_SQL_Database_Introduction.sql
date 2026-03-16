/*=============================================================================
    FILE: 01_SQL_Database_Introduction.sql
    TOPIC: DATABASE CREATION + RENAME + SINGLE_USER/MULTI_USER
    DB   : SQL Server

    GOAL OF THIS LESSON:
    - Learn database commands from zero level.
    - Understand syntax and why each command is used.
    - Understand safe rename flow in real projects.
=============================================================================*/

/*=============================================================================
    1) WHAT IS A DATABASE?
=============================================================================*/
/*
A database is a structured storage system used by applications.

Example:
- In an e-commerce app, customers, products, orders, and payments
  are stored in database tables.

Without database:
- data duplication increases
- search/reporting becomes difficult
- multi-user access is unreliable
*/

/*=============================================================================
    2) CREATE DATABASE - SYNTAX AND EXAMPLE
=============================================================================*/
/*
Syntax:
CREATE DATABASE DatabaseName;

Use case:
- First step when starting a new project.
- Creates a new logical container for all project tables.
*/

IF DB_ID('RetailLearningDB') IS NULL
BEGIN
    CREATE DATABASE RetailLearningDB;
END
GO

/* Verify */
SELECT name AS DatabaseName
FROM sys.databases
WHERE name = 'RetailLearningDB';
GO

/*=============================================================================
    3) USE DATABASE - WHY IMPORTANT?
=============================================================================*/
/*
Syntax:
USE DatabaseName;

Why:
- SQL Server can host many databases.
- USE tells SQL Server where your next commands should execute.
*/

USE RetailLearningDB;
GO

/*=============================================================================
    4) RENAME DATABASE - WHY / WHEN?
=============================================================================*/
/*
Common situations:
- Temporary name during development, final name needed later.
- Naming standard changes (example: TestDB -> RetailLearningDB).
- Organization-level naming policy updates.

Important:
- Rename can fail if users or applications are connected.
- So we usually switch to SINGLE_USER mode first.
*/

/*=============================================================================
    5) SINGLE_USER MODE - WHY WE CHANGE?
=============================================================================*/
/*
SINGLE_USER mode allows only one connection.

Why change to SINGLE_USER before rename/drop/maintenance?
- Prevents active user sessions from locking the database.
- Avoids "database is in use" errors.
- Ensures maintenance command succeeds immediately.
*/

ALTER DATABASE RetailLearningDB
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

/*
WITH ROLLBACK IMMEDIATE:
- Disconnects other active users instantly.
- Rolls back their running transactions.
*/

/*=============================================================================
    6) RENAME DATABASE - SAFE FLOW
=============================================================================*/
/*
Syntax:
ALTER DATABASE OldName MODIFY NAME = NewName;

Real demonstration:
RetailLearningDB -> RetailLearningDB_Training
*/

ALTER DATABASE RetailLearningDB
MODIFY NAME = RetailLearningDB_Training;
GO

/* Check renamed database */
SELECT name
FROM sys.databases
WHERE name IN ('RetailLearningDB', 'RetailLearningDB_Training');
GO

/*=============================================================================
    7) MULTI_USER MODE - WHY WE CHANGE BACK?
=============================================================================*/
/*
After maintenance, production/test users must connect again.
So change SINGLE_USER back to MULTI_USER.
*/

ALTER DATABASE RetailLearningDB_Training
SET MULTI_USER;
GO

/*=============================================================================
    8) RENAME BACK FOR THIS COURSE CONTINUITY
=============================================================================*/
/*
All remaining lesson files use RetailLearningDB.
So we rename back to keep the full course consistent.
*/

ALTER DATABASE RetailLearningDB_Training
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

ALTER DATABASE RetailLearningDB_Training
MODIFY NAME = RetailLearningDB;
GO

ALTER DATABASE RetailLearningDB
SET MULTI_USER;
GO

USE RetailLearningDB;
GO

/*=============================================================================
    9) FINAL RECAP (FULL UNDERSTANDING)
=============================================================================*/
/*
1. CREATE DATABASE:
   Creates a new database container.

2. USE:
   Switches execution context to selected database.

3. SINGLE_USER:
   Use before rename/drop/maintenance when active connections exist.

4. ALTER DATABASE ... MODIFY NAME:
   Renames database safely.

5. MULTI_USER:
   Restore normal access after maintenance.

Golden practical flow:
SINGLE_USER -> RENAME/MAINTENANCE -> MULTI_USER
*/
