/* ==============================================================================
   SQL SERVER TRIGGERS — COMPLETE GUIDE
   Tamil Explanation with Full Examples

   TABLE OF CONTENTS:
   ------------------
   SECTION 1  : TRIGGER NA ENNA? (What is a Trigger?)
   SECTION 2  : TRIGGER USE PANNI ENNA PANNALAM? (Use Cases)
   SECTION 3  : TRIGGER ILLANA ENNA PROBLEM?
   SECTION 4  : TRIGGER TYPES (DML, DDL, LOGON)
   SECTION 5  : INSERTED & DELETED MAGIC TABLES
   SECTION 6  : AFTER INSERT TRIGGER
   SECTION 7  : AFTER UPDATE TRIGGER
   SECTION 8  : AFTER DELETE TRIGGER
   SECTION 9  : INSTEAD OF TRIGGER (Block / Redirect Operations)
   SECTION 10 : DDL TRIGGER (Schema Changes Track)
   SECTION 11 : LOGON TRIGGER
   SECTION 12 : PRACTICAL USE CASE 1 — Audit Log
   SECTION 13 : PRACTICAL USE CASE 2 — Data Validation
   SECTION 14 : PRACTICAL USE CASE 3 — Auto Calculation
   SECTION 15 : PRACTICAL USE CASE 4 — Soft Delete
   SECTION 16 : PRACTICAL USE CASE 5 — Prevent Duplicate
   SECTION 17 : TRIGGER MANAGEMENT (View, Disable, Enable, Drop)
   SECTION 18 : BEST PRACTICES
   SECTION 19 : TRIGGER vs STORED PROCEDURE vs CONSTRAINT
============================================================================== */



/* ==============================================================================
   SECTION 1 — TRIGGER NA ENNA? (What is a Trigger?)
--------------------------------------------------------------------------------

   SIMPLE DEFINITION:
   ------------------
   Trigger = Automatic reaction to a database event.

   REAL LIFE EXAMPLE:
   ------------------
   🔔 Phone notification mathiri!

   "Zomato order place pannina" → Auto notification varum
   "Bank la transaction aagina" → Auto SMS varum
   "Database la INSERT aagina" → Auto trigger execute aagum!

   DATABASE EXAMPLE:
   -----------------
   Employees table la new employee add aana:
   → Auto-aaga EmployeeLogs table la record insert aagum!
   → Neeyae koopidalai, SQL Server automatically pannum!

   TRIGGER = Special stored procedure that runs AUTOMATICALLY
             when a specific event happens on a table/database.

   EVENTS THAT CAN FIRE A TRIGGER:
   --------------------------------
   DML Events  → INSERT, UPDATE, DELETE (table data change)
   DDL Events  → CREATE TABLE, ALTER TABLE, DROP TABLE
   LOGON Event → User SQL Server la login aagum bodhu

   SYNTAX OVERVIEW:
   ----------------
   CREATE TRIGGER TriggerName
   ON TableName
   AFTER INSERT          ← Event
   AS
   BEGIN
       -- Your logic here (auto runs!)
   END

============================================================================== */



/* ==============================================================================
   SECTION 2 — TRIGGER USE PANNI ENNA PANNALAM? (What Can You Do?)
--------------------------------------------------------------------------------

   ✅ 1. AUDIT LOGGING
      Who changed what? When? Track pannalam.
      Example: Employee salary change aana - old & new value log pannalam.

   ✅ 2. DATA VALIDATION
      Insert/Update aagum bodhu rules check pannalam.
      Example: Salary < 0 irundha - INSERT block pannalam.

   ✅ 3. AUTO CALCULATION
      One table change aana - another table auto update pannalam.
      Example: Order placed → Inventory auto reduce pannalam.

   ✅ 4. SOFT DELETE
      DELETE button press pannina - actually delete aagamal
      IsDeleted = 1 nu mark pannalam.

   ✅ 5. PREVENT DUPLICATES
      Custom duplicate check (UNIQUE index handle pannaadhatha).

   ✅ 6. DEFAULT VALUES AUTO SET
      Insert aagum bodhu computed values auto fill pannalam.

   ✅ 7. SYNC TABLES
      One table update → Related tables auto sync.

   ✅ 8. PREVENT UNAUTHORIZED CHANGES
      DDL trigger use pannி - Table drop aagamal prevent pannalam.

   ✅ 9. TRACK LOGIN ACTIVITY
      Logon trigger - who logged in, from where, what time.

   ✅ 10. SEND NOTIFICATIONS (via Service Broker)
       Critical data change aana - alert trigger pannalam.

============================================================================== */



/* ==============================================================================
   SECTION 3 — TRIGGER ILLANA ENNA PROBLEM?
--------------------------------------------------------------------------------

   WITHOUT TRIGGERS - Manual la ellame pannanum!

   ❌ PROBLEM 1: AUDIT TRAIL MISSING
   -----------------------------------
   Trigger illana:
   → Employee salary change aana, yaar pannanga? eppo? theriyaadhu!
   → DELETE aana row forever gone!
   → Compliance fail, legal issues varum!

   Trigger irundha:
   → Every change automatically log aagum ✅

   ❌ PROBLEM 2: DATA INCONSISTENCY
   ----------------------------------
   Trigger illana:
   → Orders table la order delete pannuvom
   → But OrderItems table la items still irukum!
   → Orphan records → Data corruption!

   Trigger irundha:
   → Order delete → Auto OrderItems also handle ✅

   ❌ PROBLEM 3: BUSINESS RULES EVERYWHERE
   ----------------------------------------
   Trigger illana:
   → Every application (Web app, Mobile app, API) la
     same validation logic write pannanum!
   → One place miss pannina → Bug!

   Trigger irundha:
   → Database level la once write pannuvom
   → All applications automatically get the rule ✅

   ❌ PROBLEM 4: MANUAL INVENTORY UPDATES
   ----------------------------------------
   Trigger illana:
   → Order place aana - developer manually
     inventory update code write pannanum
   → Forget pannina → Stock wrong aagum!

   Trigger irundha:
   → Order insert → Auto inventory reduce ✅

   ❌ PROBLEM 5: UNAUTHORIZED SCHEMA CHANGES
   -------------------------------------------
   Trigger illana:
   → Any developer accidentally DROP TABLE panniduvanga!
   → Production data gone! 😱

   Trigger irundha:
   → DDL Trigger block pannivudum ✅

   SUMMARY TABLE:
   ──────────────────────────────────────────────────────────────
   Problem              │ Without Trigger  │ With Trigger
   ─────────────────────│──────────────────│────────────────────
   Audit Logging        │ Manual code      │ Auto log ✅
   Data Consistency     │ App developer    │ DB level ✅
   Business Rules       │ Every app again  │ Once in DB ✅
   Inventory Sync       │ Manual update    │ Auto sync ✅
   Schema Protection    │ Anyone can drop  │ Blocked ✅
   ──────────────────────────────────────────────────────────────

============================================================================== */



/* ==============================================================================
   SECTION 4 — TRIGGER TYPES
--------------------------------------------------------------------------------

   TYPE 1: DML TRIGGERS
   ─────────────────────
   Table data change aagum bodhu fire aagum.

   Events  : INSERT, UPDATE, DELETE
   Sub-types:
     a) AFTER Trigger    → Data change AANA PIRAN run aagum
     b) INSTEAD OF Trigger → Data change AAGAMAL MUNNADI run aagum

   TYPE 2: DDL TRIGGERS
   ─────────────────────
   Database structure change aagum bodhu fire aagum.

   Events  : CREATE_TABLE, ALTER_TABLE, DROP_TABLE, etc.
   Scope   : DATABASE level or SERVER level

   TYPE 3: LOGON TRIGGERS
   ───────────────────────
   User SQL Server la login aagum bodhu fire aagum.
   Use case: Login audit, restrict certain users, etc.

   DML TRIGGER TIMING:
   ─────────────────────────────────────────────────────────
   AFTER Trigger:
   User → INSERT → Data saved → THEN Trigger runs

   INSTEAD OF Trigger:
   User → INSERT → Trigger runs FIRST → Data may or may not save
   ─────────────────────────────────────────────────────────

   NOTE: SQL Server la BEFORE trigger இல்லை!
   MySQL la irukku, SQL Server la INSTEAD OF use pannuvom.

============================================================================== */



/* ==============================================================================
   SECTION 5 — INSERTED & DELETED MAGIC TABLES
--------------------------------------------------------------------------------

   MOST IMPORTANT CONCEPT IN TRIGGERS!

   When trigger runs, SQL Server automatically creates
   2 special temporary tables:

   ┌─────────────────────────────────────────────────────────────┐
   │  INSERTED Table  │  New values irukum (after the change)    │
   │  DELETED Table   │  Old values irukum (before the change)   │
   └─────────────────────────────────────────────────────────────┘

   WHAT'S AVAILABLE IN EACH OPERATION:
   ──────────────────────────────────────────────────────────────
   Operation │ INSERTED Table  │ DELETED Table
   ──────────│─────────────────│──────────────────────────────
   INSERT    │ ✅ New rows      │ ❌ Empty
   UPDATE    │ ✅ New values    │ ✅ Old values
   DELETE    │ ❌ Empty         │ ✅ Deleted rows
   ──────────────────────────────────────────────────────────────

   UPDATE EXAMPLE:
   ───────────────
   UPDATE Employees SET Salary = 90000 WHERE EmployeeID = 1

   DELETED Table (what it WAS):        INSERTED Table (what it IS NOW):
   EmployeeID | Salary                 EmployeeID | Salary
   1          | 80000                  1          | 90000

   → Trigger la: i.Salary = 90000, d.Salary = 80000
   → Difference = 10000 raise!

============================================================================== */



/* ==============================================================================
   SECTION 6 — TABLE SETUP (Demo Tables)
============================================================================== */

-- Employees table
CREATE TABLE Sales.Employees (
    EmployeeID   INT PRIMARY KEY,
    FirstName    NVARCHAR(50),
    LastName     NVARCHAR(50),
    Department   NVARCHAR(50),
    Salary       DECIMAL(10,2),
    IsDeleted    BIT DEFAULT 0,
    CreatedDate  DATETIME DEFAULT GETDATE()
);
GO

-- Log table for audit
CREATE TABLE Sales.EmployeeLogs (
    LogID       INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID  INT,
    ActionType  VARCHAR(50),
    ColumnName  VARCHAR(100),
    OldValue    NVARCHAR(200),
    NewValue    NVARCHAR(200),
    ChangedBy   NVARCHAR(100) DEFAULT SYSTEM_USER,
    LogDate     DATETIME DEFAULT GETDATE()
);
GO

-- Inventory table (for auto-sync demo)
CREATE TABLE Sales.Products (
    ProductID   INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Stock       INT,
    Price       DECIMAL(10,2)
);
GO

-- Orders table
CREATE TABLE Sales.Orders (
    OrderID    INT PRIMARY KEY IDENTITY(1,1),
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATETIME DEFAULT GETDATE(),
    Status     NVARCHAR(20) DEFAULT 'Active'
);
GO

-- Insert sample products
INSERT INTO Sales.Products VALUES (1, 'Laptop',  50, 45000);
INSERT INTO Sales.Products VALUES (2, 'Mouse',  200, 500);
INSERT INTO Sales.Products VALUES (3, 'Keyboard',150, 800);
GO



/* ==============================================================================
   SECTION 7 — AFTER INSERT TRIGGER
--------------------------------------------------------------------------------
   Employee add aana → Auto log pannuvom
============================================================================== */

CREATE TRIGGER trg_AfterInsert_Employee
ON Sales.Employees
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;   -- Extra "rows affected" message suppress pannuvom

    INSERT INTO Sales.EmployeeLogs (EmployeeID, ActionType, ColumnName, OldValue, NewValue)
    SELECT
        i.EmployeeID,
        'INSERT',
        'ALL COLUMNS',
        NULL,
        CONCAT('Name: ', i.FirstName, ' ', i.LastName,
               ' | Dept: ', i.Department,
               ' | Salary: ', i.Salary)
    FROM INSERTED i;

    PRINT 'INSERT Trigger fired! Employee log created.';
END
GO

-- TEST: Insert a new employee
INSERT INTO Sales.Employees (EmployeeID, FirstName, LastName, Department, Salary)
VALUES (101, 'Ravi', 'Kumar', 'IT', 55000);
GO

-- Check log
SELECT * FROM Sales.EmployeeLogs;
GO

/*
EXPECTED OUTPUT:
LogID | EmployeeID | ActionType | ColumnName   | OldValue | NewValue
1     | 101        | INSERT     | ALL COLUMNS  | NULL     | Name: Ravi Kumar | Dept: IT | Salary: 55000
*/



/* ==============================================================================
   SECTION 8 — AFTER UPDATE TRIGGER
--------------------------------------------------------------------------------
   Employee salary change aana → Old & New value log pannuvom
============================================================================== */

CREATE TRIGGER trg_AfterUpdate_Employee
ON Sales.Employees
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Salary update aagindha nu check pannuvom
    IF UPDATE(Salary)
    BEGIN
        INSERT INTO Sales.EmployeeLogs (EmployeeID, ActionType, ColumnName, OldValue, NewValue)
        SELECT
            i.EmployeeID,
            'UPDATE',
            'Salary',
            CAST(d.Salary AS NVARCHAR),    -- Old value from DELETED
            CAST(i.Salary AS NVARCHAR)     -- New value from INSERTED
        FROM INSERTED i
        JOIN DELETED d ON i.EmployeeID = d.EmployeeID;
    END

    -- Department change aagindha nu check
    IF UPDATE(Department)
    BEGIN
        INSERT INTO Sales.EmployeeLogs (EmployeeID, ActionType, ColumnName, OldValue, NewValue)
        SELECT
            i.EmployeeID,
            'UPDATE',
            'Department',
            d.Department,
            i.Department
        FROM INSERTED i
        JOIN DELETED d ON i.EmployeeID = d.EmployeeID;
    END

    PRINT 'UPDATE Trigger fired! Changes logged.';
END
GO

-- TEST: Update salary
UPDATE Sales.Employees
SET Salary = 65000
WHERE EmployeeID = 101;
GO

-- TEST: Update department
UPDATE Sales.Employees
SET Department = 'HR'
WHERE EmployeeID = 101;
GO

-- Check logs
SELECT * FROM Sales.EmployeeLogs;
GO

/*
EXPECTED OUTPUT:
LogID | EmployeeID | ActionType | ColumnName | OldValue | NewValue
1     | 101        | INSERT     | ALL COLUMNS| NULL     | Name: Ravi Kumar...
2     | 101        | UPDATE     | Salary     | 55000    | 65000
3     | 101        | UPDATE     | Department | IT       | HR
*/



/* ==============================================================================
   SECTION 9 — AFTER DELETE TRIGGER
--------------------------------------------------------------------------------
   Employee delete aana → Log pannuvom (who was deleted)
============================================================================== */

CREATE TRIGGER trg_AfterDelete_Employee
ON Sales.Employees
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Sales.EmployeeLogs (EmployeeID, ActionType, ColumnName, OldValue, NewValue)
    SELECT
        d.EmployeeID,
        'DELETE',
        'ALL COLUMNS',
        CONCAT('Name: ', d.FirstName, ' ', d.LastName,
               ' | Dept: ', d.Department,
               ' | Salary: ', d.Salary),
        'DELETED'
    FROM DELETED d;

    PRINT 'DELETE Trigger fired! Deletion logged.';
END
GO

-- TEST: Delete employee
DELETE FROM Sales.Employees WHERE EmployeeID = 101;
GO

-- Check log - deletion recorded!
SELECT * FROM Sales.EmployeeLogs;
GO



/* ==============================================================================
   SECTION 10 — INSTEAD OF TRIGGER
--------------------------------------------------------------------------------
   SQL Server la BEFORE trigger இல்லை.
   INSTEAD OF = Action aagamal munnadi our logic run aagum.

   Use Cases:
   • Block certain operations
   • Soft Delete (actually delete aagamal IsDeleted = 1 set pannuvom)
   • Validate then decide to proceed or not
============================================================================== */

-- INSTEAD OF DELETE → Soft Delete implement pannuvom
CREATE TRIGGER trg_InsteadOfDelete_Employee
ON Sales.Employees
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Actually DELETE aagaadhu!
    -- IsDeleted flag = 1 nu mark mattum pannuvom
    UPDATE Sales.Employees
    SET IsDeleted = 1
    WHERE EmployeeID IN (SELECT EmployeeID FROM DELETED);

    -- Log pannuvom
    INSERT INTO Sales.EmployeeLogs (EmployeeID, ActionType, ColumnName, OldValue, NewValue)
    SELECT
        EmployeeID,
        'SOFT DELETE',
        'IsDeleted',
        '0',
        '1'
    FROM DELETED;

    PRINT 'INSTEAD OF trigger: Employee soft deleted (not actually removed)!';
END
GO

-- Re-insert employee for testing
INSERT INTO Sales.Employees (EmployeeID, FirstName, LastName, Department, Salary)
VALUES (101, 'Ravi', 'Kumar', 'IT', 55000);
GO

-- TEST: DELETE → actually soft delete aagum!
DELETE FROM Sales.Employees WHERE EmployeeID = 101;
GO

-- Employee still exists! But IsDeleted = 1
SELECT EmployeeID, FirstName, IsDeleted FROM Sales.Employees;
GO

/*
EXPECTED OUTPUT:
EmployeeID | FirstName | IsDeleted
101        | Ravi      | 1         ← Still exists, just flagged!
*/



/* ==============================================================================
   SECTION 11 — DDL TRIGGER
--------------------------------------------------------------------------------
   Database structure change (CREATE/ALTER/DROP table) aagum bodhu fire aagum.
   Production environment la accidental drops prevent pannalam!
============================================================================== */

-- DDL Audit table
CREATE TABLE Sales.DDL_AuditLog (
    LogID       INT IDENTITY(1,1) PRIMARY KEY,
    EventType   NVARCHAR(100),
    ObjectName  NVARCHAR(200),
    ObjectType  NVARCHAR(100),
    LoginName   NVARCHAR(100),
    EventDate   DATETIME DEFAULT GETDATE(),
    TSQLCommand NVARCHAR(MAX)
);
GO

-- DDL Trigger: CREATE or DROP table aana log pannuvom + DROP block pannuvom
CREATE TRIGGER trg_DDL_TableProtection
ON DATABASE
FOR CREATE_TABLE, DROP_TABLE, ALTER_TABLE
AS
BEGIN
    DECLARE @EventData XML = EVENTDATA();

    DECLARE @EventType  NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)');
    DECLARE @ObjectName NVARCHAR(200) = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(200)');
    DECLARE @LoginName  NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'NVARCHAR(100)');
    DECLARE @TSQLCmd    NVARCHAR(MAX) = @EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)');

    -- Log the event
    INSERT INTO Sales.DDL_AuditLog (EventType, ObjectName, LoginName, TSQLCommand)
    VALUES (@EventType, @ObjectName, @LoginName, @TSQLCmd);

    -- DROP TABLE aagamal block pannuvom
    IF @EventType = 'DROP_TABLE'
    BEGIN
        PRINT 'ERROR: DROP TABLE is not allowed! Contact DBA.';
        ROLLBACK;  -- Operation cancel!
    END

END
GO

-- TEST: Create a table (allowed, just logged)
CREATE TABLE Sales.TestDDL (ID INT);
GO

-- Check DDL log
SELECT * FROM Sales.DDL_AuditLog;
GO

-- TEST: Try to drop (will be BLOCKED!)
-- DROP TABLE Sales.TestDDL;
-- ERROR: DROP TABLE is not allowed! Contact DBA.

-- To disable DDL trigger if needed:
-- DISABLE TRIGGER trg_DDL_TableProtection ON DATABASE;

-- Cleanup test table (disable trigger first)
DISABLE TRIGGER trg_DDL_TableProtection ON DATABASE;
DROP TABLE IF EXISTS Sales.TestDDL;
ENABLE TRIGGER trg_DDL_TableProtection ON DATABASE;
GO



/* ==============================================================================
   SECTION 12 — LOGON TRIGGER
--------------------------------------------------------------------------------
   User login aagum bodhu fire aagum.
   Use: Track who logged in, from where, block certain logins.
============================================================================== */

-- Login audit table
CREATE TABLE Sales.LoginAuditLog (
    LogID       INT IDENTITY(1,1) PRIMARY KEY,
    LoginName   NVARCHAR(100),
    HostName    NVARCHAR(100),
    AppName     NVARCHAR(200),
    LoginTime   DATETIME DEFAULT GETDATE()
);
GO

-- Logon Trigger
CREATE TRIGGER trg_Logon_Audit
ON ALL SERVER
FOR LOGON
AS
BEGIN
    INSERT INTO YourDatabase.Sales.LoginAuditLog (LoginName, HostName, AppName)
    VALUES (
        ORIGINAL_LOGIN(),           -- Who logged in
        HOST_NAME(),                -- From which machine
        APP_NAME()                  -- Which application
    );
END
GO

-- View login history
SELECT * FROM Sales.LoginAuditLog;
GO

-- NOTE: Logon trigger careful ah use pannanum!
-- Wrong logic irundha → Nobody can login! 
-- Emergency disable: DISABLE TRIGGER trg_Logon_Audit ON ALL SERVER;



/* ==============================================================================
   SECTION 13 — PRACTICAL USE CASE 1: COMPLETE AUDIT LOG
--------------------------------------------------------------------------------
   Real world: Bank transaction mathiri — every change track pannuvom
============================================================================== */

-- Detailed audit trigger with COLUMNS_UPDATED()
CREATE TRIGGER trg_FullAudit_Employee
ON Sales.Employees
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Action VARCHAR(10);

    -- Which operation nu detect pannuvom
    IF EXISTS (SELECT 1 FROM INSERTED) AND EXISTS (SELECT 1 FROM DELETED)
        SET @Action = 'UPDATE';
    ELSE IF EXISTS (SELECT 1 FROM INSERTED)
        SET @Action = 'INSERT';
    ELSE
        SET @Action = 'DELETE';

    -- Single trigger for all 3 operations!
    INSERT INTO Sales.EmployeeLogs (EmployeeID, ActionType, ColumnName, OldValue, NewValue, ChangedBy)
    SELECT
        COALESCE(i.EmployeeID, d.EmployeeID),
        @Action,
        'Record',
        CASE WHEN d.EmployeeID IS NOT NULL
             THEN CONCAT('Salary:', d.Salary, ' Dept:', d.Department)
             ELSE NULL END,
        CASE WHEN i.EmployeeID IS NOT NULL
             THEN CONCAT('Salary:', i.Salary, ' Dept:', i.Department)
             ELSE NULL END,
        SYSTEM_USER
    FROM INSERTED i
    FULL OUTER JOIN DELETED d ON i.EmployeeID = d.EmployeeID;

END
GO



/* ==============================================================================
   SECTION 14 — PRACTICAL USE CASE 2: DATA VALIDATION
--------------------------------------------------------------------------------
   Salary negative aagamal prevent pannuvom
   Department valid value mattum allow pannuvom
============================================================================== */

CREATE TRIGGER trg_Validate_Employee
ON Sales.Employees
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Validation 1: Salary negative aagamal
    IF EXISTS (SELECT 1 FROM INSERTED WHERE Salary < 0)
    BEGIN
        RAISERROR ('ERROR: Salary cannot be negative!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validation 2: Salary unrealistically high
    IF EXISTS (SELECT 1 FROM INSERTED WHERE Salary > 10000000)
    BEGIN
        RAISERROR ('ERROR: Salary exceeds maximum limit of 1 Crore!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validation 3: Valid departments only
    IF EXISTS (
        SELECT 1 FROM INSERTED
        WHERE Department NOT IN ('IT', 'HR', 'Finance', 'Sales', 'Marketing', 'Operations')
    )
    BEGIN
        RAISERROR ('ERROR: Invalid Department! Use IT/HR/Finance/Sales/Marketing/Operations', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

END
GO

-- TEST: Negative salary (will FAIL ❌)
-- INSERT INTO Sales.Employees (EmployeeID, FirstName, LastName, Department, Salary)
-- VALUES (102, 'Test', 'User', 'IT', -5000);
-- ERROR: Salary cannot be negative!

-- TEST: Invalid department (will FAIL ❌)
-- INSERT INTO Sales.Employees (EmployeeID, FirstName, LastName, Department, Salary)
-- VALUES (102, 'Test', 'User', 'INVALID_DEPT', 50000);
-- ERROR: Invalid Department!

-- TEST: Valid insert (will PASS ✅)
INSERT INTO Sales.Employees (EmployeeID, FirstName, LastName, Department, Salary)
VALUES (102, 'Priya', 'Devi', 'HR', 48000);
GO



/* ==============================================================================
   SECTION 15 — PRACTICAL USE CASE 3: AUTO INVENTORY UPDATE
--------------------------------------------------------------------------------
   Order place aana → Product stock auto reduce aagum
   Order cancel aana → Stock auto restore aagum
============================================================================== */

CREATE TRIGGER trg_AutoUpdate_Inventory
ON Sales.Orders
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- New order insert aana → Stock reduce pannuvom
    IF EXISTS (SELECT 1 FROM INSERTED) AND NOT EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        -- Check: Enough stock irukka?
        IF EXISTS (
            SELECT 1
            FROM INSERTED i
            JOIN Sales.Products p ON i.ProductID = p.ProductID
            WHERE p.Stock < i.Quantity
        )
        BEGIN
            RAISERROR ('ERROR: Insufficient stock for this order!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Stock reduce pannuvom
        UPDATE p
        SET p.Stock = p.Stock - i.Quantity
        FROM Sales.Products p
        JOIN INSERTED i ON p.ProductID = i.ProductID;

        PRINT 'Order placed! Stock updated automatically.';
    END

    -- Order delete aana (cancel) → Stock restore pannuvom
    IF EXISTS (SELECT 1 FROM DELETED) AND NOT EXISTS (SELECT 1 FROM INSERTED)
    BEGIN
        UPDATE p
        SET p.Stock = p.Stock + d.Quantity
        FROM Sales.Products p
        JOIN DELETED d ON p.ProductID = d.ProductID;

        PRINT 'Order cancelled! Stock restored automatically.';
    END

END
GO

-- Check stock before order
SELECT ProductID, ProductName, Stock FROM Sales.Products;
GO

-- TEST: Place order for 5 Laptops
INSERT INTO Sales.Orders (ProductID, Quantity)
VALUES (1, 5);
GO

-- Stock should be 50 - 5 = 45 now!
SELECT ProductID, ProductName, Stock FROM Sales.Products;
GO

-- TEST: Cancel order (delete)
DELETE FROM Sales.Orders WHERE OrderID = 1;
GO

-- Stock should be back to 50!
SELECT ProductID, ProductName, Stock FROM Sales.Products;
GO

-- TEST: Order more than stock (will FAIL ❌)
-- INSERT INTO Sales.Orders (ProductID, Quantity) VALUES (1, 999);
-- ERROR: Insufficient stock!

/*
EXPECTED OUTPUT:
Before order: Laptop Stock = 50
After order:  Laptop Stock = 45   (auto reduced!)
After cancel: Laptop Stock = 50   (auto restored!)
*/



/* ==============================================================================
   SECTION 16 — PRACTICAL USE CASE 4: SALARY HISTORY TRACKING
--------------------------------------------------------------------------------
   Every salary change → History table la save pannuvom
   HR analysis, appraisal history, etc.
============================================================================== */

-- Salary history table
CREATE TABLE Sales.SalaryHistory (
    HistoryID   INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID  INT,
    OldSalary   DECIMAL(10,2),
    NewSalary   DECIMAL(10,2),
    ChangedBy   NVARCHAR(100),
    ChangeDate  DATETIME DEFAULT GETDATE(),
    Reason      NVARCHAR(200) DEFAULT 'Salary Update'
);
GO

CREATE TRIGGER trg_Track_SalaryHistory
ON Sales.Employees
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Salary)   -- Only salary change aana
    BEGIN
        INSERT INTO Sales.SalaryHistory (EmployeeID, OldSalary, NewSalary, ChangedBy)
        SELECT
            i.EmployeeID,
            d.Salary,       -- Old salary from DELETED
            i.Salary,       -- New salary from INSERTED
            SYSTEM_USER
        FROM INSERTED i
        JOIN DELETED d ON i.EmployeeID = d.EmployeeID
        WHERE i.Salary <> d.Salary;   -- Actually changed irundha mattum
    END
END
GO

-- TEST: Multiple salary changes
UPDATE Sales.Employees SET Salary = 60000 WHERE EmployeeID = 102;
UPDATE Sales.Employees SET Salary = 72000 WHERE EmployeeID = 102;
UPDATE Sales.Employees SET Salary = 85000 WHERE EmployeeID = 102;
GO

-- View complete salary history!
SELECT 
    sh.EmployeeID,
    e.FirstName,
    sh.OldSalary,
    sh.NewSalary,
    sh.NewSalary - sh.OldSalary AS Increment,
    sh.ChangedBy,
    sh.ChangeDate
FROM Sales.SalaryHistory sh
JOIN Sales.Employees e ON sh.EmployeeID = e.EmployeeID
ORDER BY sh.ChangeDate;
GO

/*
EXPECTED OUTPUT:
EmployeeID | FirstName | OldSalary | NewSalary | Increment | ChangedBy
102        | Priya     | 48000     | 60000     | 12000     | sa\admin
102        | Priya     | 60000     | 72000     | 12000     | sa\admin
102        | Priya     | 72000     | 85000     | 13000     | sa\admin
*/



/* ==============================================================================
   SECTION 17 — PRACTICAL USE CASE 5: PREVENT WEEKEND CHANGES
--------------------------------------------------------------------------------
   Saturday, Sunday la data change panna allow panna vendam!
   (Production safety rule)
============================================================================== */

CREATE TRIGGER trg_Prevent_WeekendChanges
ON Sales.Employees
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF DATEPART(WEEKDAY, GETDATE()) IN (1, 7)   -- 1=Sunday, 7=Saturday
    BEGIN
        RAISERROR ('ERROR: Data changes are not allowed on weekends!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END
GO

-- TEST: If today is weekend, this will fail!
-- INSERT INTO Sales.Employees (EmployeeID, FirstName, LastName, Department, Salary)
-- VALUES (103, 'Weekend', 'Test', 'IT', 50000);
-- ERROR (on weekends): Data changes not allowed on weekends!



/* ==============================================================================
   SECTION 18 — TRIGGER MANAGEMENT
--------------------------------------------------------------------------------
   View, Disable, Enable, Drop triggers
============================================================================== */

-- All triggers in database list
SELECT 
    t.name          AS TriggerName,
    OBJECT_NAME(t.parent_id) AS TableName,
    t.type_desc     AS TriggerType,
    t.is_disabled   AS IsDisabled,
    t.create_date   AS CreatedDate,
    t.modify_date   AS ModifiedDate
FROM sys.triggers t
WHERE t.is_ms_shipped = 0
ORDER BY OBJECT_NAME(t.parent_id), t.name;
GO

-- Specific table la irukka triggers
SELECT * FROM sys.triggers
WHERE parent_id = OBJECT_ID('Sales.Employees');
GO

-- Trigger definition paakka
EXEC sp_helptext 'trg_AfterInsert_Employee';
GO

-- DISABLE a specific trigger
DISABLE TRIGGER trg_Validate_Employee ON Sales.Employees;
GO

-- ENABLE a trigger
ENABLE TRIGGER trg_Validate_Employee ON Sales.Employees;
GO

-- DISABLE all triggers on a table
DISABLE TRIGGER ALL ON Sales.Employees;
GO

-- ENABLE all triggers on a table
ENABLE TRIGGER ALL ON Sales.Employees;
GO

-- DROP a trigger
DROP TRIGGER IF EXISTS trg_AfterInsert_Employee;
GO

-- Trigger code modify pannuvom (ALTER)
ALTER TRIGGER trg_AfterUpdate_Employee
ON Sales.Employees
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- Modified logic here
    PRINT 'Updated trigger is now running!';
END
GO



/* ==============================================================================
   SECTION 19 — BEST PRACTICES
--------------------------------------------------------------------------------

   ✅ DO:
   1. SET NOCOUNT ON → Use always (extra messages suppress)
   2. SET-BASED logic → Multiple rows handle always
   3. Error handling → TRY/CATCH + ROLLBACK use pannuvom
   4. Keep triggers simple → Heavy logic avoid
   5. Name clearly → trg_After/InsteadOf_Table_Action format

   ❌ DON'T:
   1. Single row assume பண்ணாதே → @@ROWCOUNT check panni
   2. Recursive triggers avoid → Trigger trigger call panna
   3. Heavy SELECT/JOIN in triggers → Performance hit
   4. PRINT statements in production triggers → Remove
   5. Too many triggers on one table → Confusing + slow

   MULTI-ROW SAFE PATTERN:
   -----------------------
   -- ❌ Wrong (assumes single row)
   DECLARE @EmpID INT = (SELECT EmployeeID FROM INSERTED)

   -- ✅ Correct (handles multiple rows)
   INSERT INTO Log
   SELECT EmployeeID FROM INSERTED

============================================================================== */



/* ==============================================================================
   SECTION 20 — TRIGGER vs STORED PROCEDURE vs CONSTRAINT
--------------------------------------------------------------------------------

   ─────────────────────────────────────────────────────────────────────────
   Feature          │ TRIGGER           │ STORED PROC    │ CONSTRAINT
   ─────────────────│───────────────────│────────────────│──────────────────
   Execution        │ AUTOMATIC         │ MANUAL call    │ AUTOMATIC
   Called by        │ DB Event          │ Developer/App  │ DB Engine
   Use case         │ Audit, Sync, Validate│ Business Logic│ Simple rules
   Can ROLLBACK?    │ ✅ Yes            │ ✅ Yes         │ ✅ Yes (auto)
   Sees old values? │ ✅ DELETED table  │ ❌ No          │ ❌ No
   Complex logic?   │ ✅ Yes            │ ✅ Yes         │ ❌ Limited
   Performance      │ ⚠️ Overhead       │ ✅ Controlled  │ ✅ Fast
   Debugging        │ ⚠️ Hard           │ ✅ Easy        │ ✅ Easy
   ─────────────────────────────────────────────────────────────────────────

   WHEN TO USE WHAT:
   -----------------
   CONSTRAINT → Simple NOT NULL, UNIQUE, CHECK rules
   TRIGGER    → Audit log, cross-table sync, complex validation
   STORED PROC → Business workflow, reports, complex operations

============================================================================== */



/* ==============================================================================
   END OF SQL TRIGGERS COMPLETE GUIDE

   Key Takeaways:
   1.  Trigger = Auto-execute when INSERT/UPDATE/DELETE/DDL/LOGON event
   2.  INSERTED table = New values | DELETED table = Old values
   3.  AFTER trigger → Event aana piran run
   4.  INSTEAD OF trigger → Event aagamal munnadi run (BEFORE alternative)
   5.  DDL trigger → Schema changes track/prevent
   6.  LOGON trigger → Login activity track
   7.  Trigger use: Audit, Validation, Auto-calc, Soft Delete, Protection
   8.  Trigger illana: Manual code everywhere, data inconsistency, no audit!
   9.  Always SET NOCOUNT ON + handle multiple rows
   10. ROLLBACK use pannina → Entire transaction cancel aagum!
============================================================================== */