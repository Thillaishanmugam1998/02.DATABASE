/*=============================================================================
    FILE: 07_SQL_Cascading.sql
    TOPIC: CASCADE ACTIONS IN FOREIGN KEY
    DB   : RetailLearningDB

    LEARNING GOAL:
    - What cascading is
    - Why cascading is needed
    - Types of cascade actions
    - Real examples for each action
=============================================================================*/

IF DB_ID('RetailLearningDB') IS NULL
BEGIN
    CREATE DATABASE RetailLearningDB;
END
GO

USE RetailLearningDB;
GO

/*=============================================================================
    1) WHAT IS CASCADING?
=============================================================================*/
/*
Cascading means SQL Server automatically applies parent table changes
to child table rows through a FOREIGN KEY rule.

Parent table: master table (example: Customers)
Child table: dependent table (example: Orders)

Why needed:
- Prevent orphan rows
- Keep related data consistent
- Reduce manual update/delete coding
*/

/*=============================================================================
    2) TYPES OF CASCADE ACTIONS
=============================================================================*/
/*
When parent row is UPDATED or DELETED, FK can use:

1) CASCADE
   - Child rows are automatically updated/deleted.

2) SET NULL
   - Child FK column becomes NULL.
   - Child FK column must allow NULL.

3) SET DEFAULT
   - Child FK column set to its default value.
   - FK column must have a DEFAULT value.

4) NO ACTION (default behavior)
   - Blocks parent update/delete if child rows exist.
*/

/*=============================================================================
    3) SYNTAX TEMPLATE
=============================================================================*/
/*
CREATE TABLE ChildTable
(
    ChildID INT PRIMARY KEY,
    ParentID INT,
    CONSTRAINT FK_Child_Parent
        FOREIGN KEY (ParentID)
        REFERENCES ParentTable(ParentID)
        ON DELETE CASCADE_ACTION
        ON UPDATE CASCADE_ACTION
);
*/

/*=============================================================================
    4) DEMO A: ON DELETE CASCADE + ON UPDATE CASCADE
=============================================================================*/
DROP TABLE IF EXISTS OrderItems_Cas;
DROP TABLE IF EXISTS Orders_Cas;
DROP TABLE IF EXISTS Customers_Cas;
GO

CREATE TABLE Customers_Cas
(
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL
);

CREATE TABLE Orders_Cas
(
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    CONSTRAINT FK_OrdersCas_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers_Cas(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE OrderItems_Cas
(
    OrderItemID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    Qty INT NOT NULL,
    CONSTRAINT FK_OrderItemsCas_Orders
        FOREIGN KEY (OrderID)
        REFERENCES Orders_Cas(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

INSERT INTO Customers_Cas VALUES (1, N'Arun'), (2, N'Meena');
INSERT INTO Orders_Cas VALUES (101, 1), (102, 1), (103, 2);
INSERT INTO OrderItems_Cas VALUES
(1, 101, 'Laptop', 1),
(2, 101, 'Mouse', 2),
(3, 102, 'Keyboard', 1),
(4, 103, 'Phone', 1);
GO

-- ON DELETE CASCADE demo
DELETE FROM Customers_Cas WHERE CustomerID = 1;

SELECT * FROM Customers_Cas;
SELECT * FROM Orders_Cas;
SELECT * FROM OrderItems_Cas;
GO

-- ON UPDATE CASCADE demo
UPDATE Customers_Cas
SET CustomerID = 22
WHERE CustomerID = 2;

SELECT * FROM Customers_Cas;
SELECT * FROM Orders_Cas;
GO

/*=============================================================================
    5) DEMO B: ON DELETE SET NULL
=============================================================================*/
DROP TABLE IF EXISTS Tickets_SetNull;
DROP TABLE IF EXISTS Agent_SetNull;
GO

CREATE TABLE Agent_SetNull
(
    AgentID INT PRIMARY KEY,
    AgentName NVARCHAR(100) NOT NULL
);

CREATE TABLE Tickets_SetNull
(
    TicketID INT PRIMARY KEY,
    AgentID INT NULL, -- must allow NULL
    IssueTitle NVARCHAR(120) NOT NULL,
    CONSTRAINT FK_TicketsSetNull_Agent
        FOREIGN KEY (AgentID)
        REFERENCES Agent_SetNull(AgentID)
        ON DELETE SET NULL
        ON UPDATE NO ACTION
);
GO

INSERT INTO Agent_SetNull VALUES (10, N'Sneha');
INSERT INTO Tickets_SetNull VALUES (1001, 10, N'Payment failed');

DELETE FROM Agent_SetNull WHERE AgentID = 10;

SELECT * FROM Tickets_SetNull; -- AgentID becomes NULL
GO

/*=============================================================================
    6) DEMO C: ON DELETE SET DEFAULT
=============================================================================*/
DROP TABLE IF EXISTS Tickets_SetDefault;
DROP TABLE IF EXISTS Agent_SetDefault;
GO

CREATE TABLE Agent_SetDefault
(
    AgentID INT PRIMARY KEY,
    AgentName NVARCHAR(100) NOT NULL
);

-- 0 = Unassigned (default parent row)
INSERT INTO Agent_SetDefault VALUES (0, N'Unassigned');
INSERT INTO Agent_SetDefault VALUES (20, N'Rahul');

CREATE TABLE Tickets_SetDefault
(
    TicketID INT PRIMARY KEY,
    AgentID INT NOT NULL CONSTRAINT DF_TicketsSetDefault_AgentID DEFAULT (0),
    IssueTitle NVARCHAR(120) NOT NULL,
    CONSTRAINT FK_TicketsSetDefault_Agent
        FOREIGN KEY (AgentID)
        REFERENCES Agent_SetDefault(AgentID)
        ON DELETE SET DEFAULT
        ON UPDATE NO ACTION
);
GO

INSERT INTO Tickets_SetDefault VALUES (2001, 20, N'Unable to login');

DELETE FROM Agent_SetDefault WHERE AgentID = 20;

SELECT * FROM Tickets_SetDefault; -- AgentID becomes 0
GO

/*=============================================================================
    7) DEMO D: NO ACTION (BLOCK OPERATION)
=============================================================================*/
DROP TABLE IF EXISTS Orders_NoAction;
DROP TABLE IF EXISTS Customers_NoAction;
GO

CREATE TABLE Customers_NoAction
(
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL
);

CREATE TABLE Orders_NoAction
(
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    CONSTRAINT FK_OrdersNoAction_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers_NoAction(CustomerID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
GO

INSERT INTO Customers_NoAction VALUES (1, N'Vikram');
INSERT INTO Orders_NoAction VALUES (3001, 1);

BEGIN TRY
    DELETE FROM Customers_NoAction WHERE CustomerID = 1;
END TRY
BEGIN CATCH
    SELECT 'NO ACTION BLOCKED DELETE' AS Demo, ERROR_MESSAGE() AS SqlServerMessage;
END CATCH;
GO

/*=============================================================================
    8) WHICH CASCADE TYPE TO CHOOSE?
=============================================================================*/
/*
Use CASCADE:
- When child data should never exist without parent.
  Example: OrderItems without Order should not exist.

Use SET NULL:
- Relationship can become optional.
  Example: Ticket can exist without assigned agent.

Use SET DEFAULT:
- Need fallback relationship.
  Example: move to "Unassigned" owner.

Use NO ACTION:
- Want strict manual control; parent cannot be deleted by mistake.
*/

/*=============================================================================
    9) FINAL RECAP
=============================================================================*/
/*
Cascading is an FK behavior that keeps parent-child data consistent.
Main types: CASCADE, SET NULL, SET DEFAULT, NO ACTION.
Choose based on business rules, not only technical convenience.
*/
