
/* =================================================================================================
SQL SERVER TRIGGERS – COMPLETE LEARNING SCRIPT
Audience : Freshers + Experienced Developers
Purpose  : Understand what triggers are, types, syntax, and practical examples with outputs
================================================================================================= */


/* =================================================================================================
SECTION 1 — WHAT IS A TRIGGER?
----------------------------------------------------------------------------------------------------
A Trigger is a special type of stored procedure that automatically executes when a specific event
occurs on a table, view, or database.

Common Events:
    INSERT  → When new rows are added
    UPDATE  → When existing rows are modified
    DELETE  → When rows are removed

Example Use Cases:
    • Audit logging
    • Data validation
    • Automatic calculations
    • Tracking data changes
================================================================================================= */


/* =================================================================================================
SECTION 2 — TYPES OF TRIGGERS
----------------------------------------------------------------------------------------------------

1. DML TRIGGERS (Data Manipulation Language)
   Fired when data inside tables changes.

   Events:
        INSERT
        UPDATE
        DELETE

   Types:
        AFTER Trigger
        INSTEAD OF Trigger


2. DDL TRIGGERS (Data Definition Language)
   Fired when database structure changes.

   Examples:
        CREATE TABLE
        ALTER TABLE
        DROP TABLE


3. LOGON TRIGGERS
   Fired when a user logs into SQL Server.

================================================================================================= */


/* =================================================================================================
SECTION 3 — TRIGGER BASIC SYNTAX
----------------------------------------------------------------------------------------------------

CREATE TRIGGER TriggerName
ON TableName
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    -- SQL logic here

END

Explanation:
TriggerName  → Name of the trigger
ON TableName → Table where trigger is attached
AFTER        → When trigger should execute
BEGIN/END    → Trigger logic

================================================================================================= */


/* =================================================================================================
SECTION 4 — IMPORTANT CONCEPT: INSERTED AND DELETED TABLES
----------------------------------------------------------------------------------------------------
When a trigger runs, SQL Server automatically creates temporary tables.

INSERTED → Contains new values
DELETED  → Contains old values

Event Behaviour:

INSERT
    INSERTED table contains newly inserted rows

UPDATE
    INSERTED = new values
    DELETED  = old values

DELETE
    DELETED table contains removed rows

Example:

UPDATE Employees
SET Salary = 90000
WHERE EmployeeID = 1

DELETED TABLE (Old Value)
EmployeeID | Salary
1          | 80000

INSERTED TABLE (New Value)
EmployeeID | Salary
1          | 90000

================================================================================================= */


/* =================================================================================================
SECTION 5 — SAMPLE LOG TABLE
This table stores trigger logs
================================================================================================= */

CREATE TABLE Sales.EmployeeLogs
(
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    ActionType VARCHAR(50),
    LogMessage VARCHAR(200),
    LogDate DATETIME
);
GO


/* =================================================================================================
SECTION 6 — AFTER INSERT TRIGGER
Runs after a new employee is added
================================================================================================= */

CREATE TRIGGER trg_AfterInsertEmployee
ON Sales.Employees
AFTER INSERT
AS
BEGIN

    INSERT INTO Sales.EmployeeLogs
    (
        EmployeeID,
        ActionType,
        LogMessage,
        LogDate
    )
    SELECT
        EmployeeID,
        'INSERT',
        'New Employee Added',
        GETDATE()
    FROM INSERTED

END
GO


/* =================================================================================================
SECTION 7 — AFTER UPDATE TRIGGER
Logs updates
================================================================================================= */

CREATE TRIGGER trg_AfterUpdateEmployee
ON Sales.Employees
AFTER UPDATE
AS
BEGIN

    INSERT INTO Sales.EmployeeLogs
    (
        EmployeeID,
        ActionType,
        LogMessage,
        LogDate
    )
    SELECT
        EmployeeID,
        'UPDATE',
        'Employee Updated',
        GETDATE()
    FROM INSERTED

END
GO


/* =================================================================================================
SECTION 8 — AFTER DELETE TRIGGER
Logs deletes
================================================================================================= */

CREATE TRIGGER trg_AfterDeleteEmployee
ON Sales.Employees
AFTER DELETE
AS
BEGIN

    INSERT INTO Sales.EmployeeLogs
    (
        EmployeeID,
        ActionType,
        LogMessage,
        LogDate
    )
    SELECT
        EmployeeID,
        'DELETE',
        'Employee Deleted',
        GETDATE()
    FROM DELETED

END
GO


/* =================================================================================================
SECTION 9 — INSTEAD OF TRIGGER (Similar to BEFORE Trigger)
SQL Server does not support BEFORE triggers.
Instead we use INSTEAD OF triggers.
================================================================================================= */

CREATE TRIGGER trg_InsteadOfDeleteEmployee
ON Sales.Employees
INSTEAD OF DELETE
AS
BEGIN

    PRINT 'Delete operation blocked by INSTEAD OF trigger'

END
GO


/* =================================================================================================
SECTION 10 — DDL TRIGGER EXAMPLE
This trigger fires when a table is created or dropped
================================================================================================= */

CREATE TRIGGER trg_DDL_TableAudit
ON DATABASE
FOR CREATE_TABLE, DROP_TABLE
AS
BEGIN

    PRINT 'Database structure changed (Table created or dropped)'

END
GO


/* =================================================================================================
SECTION 11 — TESTING TRIGGERS
================================================================================================= */

-- Insert Example
INSERT INTO Sales.Employees
VALUES (100,'John','Smith','IT','1990-01-01','M',50000,1)
GO

-- Update Example
UPDATE Sales.Employees
SET Salary = 55000
WHERE EmployeeID = 100
GO

-- Delete Example
DELETE FROM Sales.Employees
WHERE EmployeeID = 100
GO


/* =================================================================================================
SECTION 12 — VIEW OUTPUT
================================================================================================= */

SELECT *
FROM Sales.EmployeeLogs
GO


/* =================================================================================================
EXPECTED OUTPUT (Example)

LogID | EmployeeID | ActionType | LogMessage           | LogDate
---------------------------------------------------------------
1     | 100        | INSERT     | New Employee Added   | 2026-03-06
2     | 100        | UPDATE     | Employee Updated     | 2026-03-06
3     | 100        | DELETE     | Employee Deleted     | 2026-03-06

================================================================================================= */


/* =================================================================================================
BEST PRACTICES

1. Always write triggers using SET-based logic
2. Never assume single-row operations
3. Avoid heavy business logic inside triggers
4. Use triggers mainly for auditing and validation

================================================================================================= */
