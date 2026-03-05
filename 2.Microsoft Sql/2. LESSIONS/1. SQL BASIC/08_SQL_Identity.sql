/*=============================================================================
    FILE: 08_SQL_Identity.sql
    TOPIC: SQL SERVER IDENTITY - COMPLETE CONCEPT
    DB   : RetailLearningDB

    LEARNING GOAL:
    - What IDENTITY is and why used
    - Syntax and behavior
    - Manual identity insert
    - Identity gap after DELETE
    - Duplicate identity behavior
    - DELETE vs TRUNCATE and identity reset
    - Identity value functions (SCOPE_IDENTITY, @@IDENTITY, IDENT_CURRENT)
=============================================================================*/

IF DB_ID('RetailLearningDB') IS NULL
BEGIN
    CREATE DATABASE RetailLearningDB;
END
GO

USE RetailLearningDB;
GO

/*=============================================================================
    1) WHAT IS IDENTITY?
=============================================================================*/
/*
IDENTITY is an auto-number generator for a column.

Commonly used for surrogate primary key.
Each new row gets next numeric value automatically.

Syntax inside CREATE TABLE:
ColumnName INT IDENTITY(seed, increment)

Seed - Starting value for first row
Increment - Value added to previous identity for next row

Example:
TicketID INT IDENTITY(1000,1)
- First row  : 1000
- Next rows  : 1001, 1002, ...
*/

/*=============================================================================
    2) BASE TABLE SETUP
=============================================================================*/
DROP TABLE IF EXISTS SupportTickets_IdentityDemo;
GO

CREATE TABLE SupportTickets_IdentityDemo
(
    TicketID INT IDENTITY(1000,1) PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    IssueTitle NVARCHAR(150) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

/*=============================================================================
    3) NORMAL INSERT (IDENTITY AUTO GENERATION)
=============================================================================*/
INSERT INTO SupportTickets_IdentityDemo (CustomerName, IssueTitle)
VALUES
(N'Arun', N'Payment failed'),
(N'Meena', N'Unable to login'),
(N'Vikram', N'Address update issue');

SELECT * FROM SupportTickets_IdentityDemo ORDER BY TicketID;
GO

/*=============================================================================
    4) CHECK GENERATED IDENTITY VALUES
=============================================================================*/
/*
Important functions:
1) SCOPE_IDENTITY() -> last identity in current scope/session (most preferred)
2) @@IDENTITY      -> last identity in current session, any scope (trigger risk)
3) IDENT_CURRENT('TableName') -> last identity for that table, any session
*/

INSERT INTO SupportTickets_IdentityDemo (CustomerName, IssueTitle)
VALUES (N'Sneha', N'Refund not received');

SELECT
    SCOPE_IDENTITY() AS ScopeIdentityValue,
    @@IDENTITY AS AtAtIdentityValue,
    IDENT_CURRENT('SupportTickets_IdentityDemo') AS IdentCurrentValue;
GO

/*=============================================================================
    5) DELETE ROW AND CHECK IDENTITY GAP
=============================================================================*/
/*
DELETE removes row only.
Identity counter does NOT go backward.
Gap is normal behavior.
*/
DELETE FROM SupportTickets_IdentityDemo
WHERE TicketID = 1001;

INSERT INTO SupportTickets_IdentityDemo (CustomerName, IssueTitle)
VALUES (N'Kavin', N'Address change request');

SELECT * FROM SupportTickets_IdentityDemo ORDER BY TicketID;
GO

/*
Observe:
- TicketID 1001 deleted.
- New row does not reuse 1001.
- Next value continues forward.
*/

/*=============================================================================
    6) MANUAL IDENTITY INSERT (IDENTITY_INSERT)
=============================================================================*/
/*
Default behavior: cannot directly insert identity column value.
To do manual insert, enable IDENTITY_INSERT for one table at a time.
*/

SET IDENTITY_INSERT SupportTickets_IdentityDemo ON;

INSERT INTO SupportTickets_IdentityDemo (TicketID, CustomerName, IssueTitle, CreatedAt)
VALUES (2000, N'Migrated User', N'Old ticket migrated', SYSDATETIME());

SET IDENTITY_INSERT SupportTickets_IdentityDemo OFF;
GO

SELECT * FROM SupportTickets_IdentityDemo ORDER BY TicketID;
GO

/*=============================================================================
    7) DUPLICATE MANUAL IDENTITY VALUE (EXPECTED ERROR)
=============================================================================*/
BEGIN TRY
    SET IDENTITY_INSERT SupportTickets_IdentityDemo ON;

    INSERT INTO SupportTickets_IdentityDemo (TicketID, CustomerName, IssueTitle, CreatedAt)
    VALUES (2000, N'Duplicate User', N'Duplicate key test', SYSDATETIME());

    SET IDENTITY_INSERT SupportTickets_IdentityDemo OFF;
END TRY
BEGIN CATCH
    -- Ensure OFF in error scenario too
    IF (SELECT OBJECTPROPERTY(OBJECT_ID('SupportTickets_IdentityDemo'), 'TableHasIdentity')) = 1
    BEGIN TRY
        SET IDENTITY_INSERT SupportTickets_IdentityDemo OFF;
    END TRY
    BEGIN CATCH
    END CATCH;

    SELECT 'DUPLICATE IDENTITY ERROR' AS Demo, ERROR_MESSAGE() AS SqlServerMessage;
END CATCH;
GO

/*=============================================================================
    8) DELETE VS TRUNCATE WITH IDENTITY
=============================================================================*/
/*
DELETE:
- Removes rows
- Identity current value is NOT reset

TRUNCATE:
- Removes all rows quickly
- Identity value is reset to seed (for most normal tables)
- Cannot run if table is referenced by foreign key
*/

DROP TABLE IF EXISTS Identity_DeleteVsTruncate;
GO

CREATE TABLE Identity_DeleteVsTruncate
(
    RowID INT IDENTITY(1,1) PRIMARY KEY,
    Remarks VARCHAR(50)
);
GO

INSERT INTO Identity_DeleteVsTruncate (Remarks)
VALUES ('A'), ('B'), ('C');

SELECT IDENT_CURRENT('Identity_DeleteVsTruncate') AS CurrentAfterInsert;

DELETE FROM Identity_DeleteVsTruncate;

INSERT INTO Identity_DeleteVsTruncate (Remarks)
VALUES ('AfterDelete');

SELECT * FROM Identity_DeleteVsTruncate;
SELECT IDENT_CURRENT('Identity_DeleteVsTruncate') AS CurrentAfterDeleteInsert;
GO

TRUNCATE TABLE Identity_DeleteVsTruncate;

INSERT INTO Identity_DeleteVsTruncate (Remarks)
VALUES ('AfterTruncate');

SELECT * FROM Identity_DeleteVsTruncate;
SELECT IDENT_CURRENT('Identity_DeleteVsTruncate') AS CurrentAfterTruncateInsert;
GO

/*=============================================================================
    9) RESEED / RESET IDENTITY MANUALLY
=============================================================================*/
/*
DBCC CHECKIDENT can set next identity position.

Syntax:
DBCC CHECKIDENT ('TableName', RESEED, NewCurrentValue)

If set RESEED, 500 then next insert becomes 501.
*/
DBCC CHECKIDENT ('SupportTickets_IdentityDemo', RESEED, 5000);
GO

INSERT INTO SupportTickets_IdentityDemo (CustomerName, IssueTitle)
VALUES (N'Reseed User', N'Test after reseed');

SELECT TOP 5 *
FROM SupportTickets_IdentityDemo
ORDER BY TicketID DESC;
GO

/*=============================================================================
    10) BEST PRACTICES
=============================================================================*/
/*
1) Prefer SCOPE_IDENTITY() after insert in application code.
2) Do not depend on gap-free identity values.
3) Do not use identity value as business meaning (invoice logic, etc.)
   unless requirement is explicit.
4) Use IDENTITY_INSERT only for migration/repair scenarios.
5) Use DBCC CHECKIDENT carefully in production.
*/

/*=============================================================================
    11) FINAL RECAP
=============================================================================*/
/*
- IDENTITY auto-generates numeric keys.
- DELETE does not reuse deleted identity numbers.
- TRUNCATE usually resets identity to seed.
- Manual insert requires SET IDENTITY_INSERT ON.
- Duplicate identity value fails if PK/UNIQUE exists.
- Identity value check tools:
  SCOPE_IDENTITY(), @@IDENTITY, IDENT_CURRENT().
*/
