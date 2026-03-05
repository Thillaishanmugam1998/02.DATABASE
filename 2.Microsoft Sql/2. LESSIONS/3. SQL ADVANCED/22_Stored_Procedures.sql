/* ==============================================================================
   SQL Stored Procedures
-------------------------------------------------------------------------------
   This script shows how to work with stored procedures in SQL Server,
   starting from basic implementations and advancing to more sophisticated
   techniques.

-------------------------------------------------------------------------------
   WHAT IS A STORED PROCEDURE?
-------------------------------------------------------------------------------
   A stored procedure is a precompiled collection of one or more SQL statements
   stored in the database under a name, and executed as a unit.

   Think of it like a function or method in programming — you define the logic
   once and call it by name whenever needed.

   Syntax:
     CREATE PROCEDURE procedure_name
     AS
     BEGIN
         -- SQL statements
     END;

   Execution:
     EXEC procedure_name;

-------------------------------------------------------------------------------
   WHY USE STORED PROCEDURES?
-------------------------------------------------------------------------------
   1. REUSABILITY
      Write the logic once and call it from anywhere — applications,
      other procedures, or scheduled jobs. No need to repeat the same
      SQL across multiple places.

   2. PERFORMANCE
      Stored procedures are precompiled and cached by SQL Server.
      The execution plan is reused on every call, making them faster
      than sending raw SQL queries each time.

   3. SECURITY
      You can grant users permission to EXECUTE a procedure without
      giving them direct access to the underlying tables. This limits
      exposure to sensitive data.

   4. MAINTAINABILITY
      Business logic lives in one place. If rules change, you update
      the procedure — not every application that queries the database.

   5. REDUCED NETWORK TRAFFIC
      Instead of sending large SQL strings from the application to the
      database, you send a short EXEC command. The heavy lifting happens
      server-side.

   6. ERROR HANDLING
      Procedures support structured error handling with TRY/CATCH blocks,
      transactions, and custom error messages — making them more robust
      than ad-hoc queries.

   Common Use Cases:
     - Fetching filtered or joined data for reports
     - Inserting, updating, or deleting records with validation
     - Enforcing business rules at the database level
     - Automating scheduled tasks or batch operations

-------------------------------------------------------------------------------
   Table of Contents:
     1. Basics (Creation and Execution)
     2. Parameters
     3. Multiple Queries
     4. Variables
     5. Control Flow with IF/ELSE
     6. Error Handling with TRY/CATCH
=================================================================================
*/

/* ==============================================================================
   QUERY vs STORED PROCEDURE — Key Differences
-------------------------------------------------------------------------------

   ┌─────────────────────┬──────────────────────────┬──────────────────────────┐
   │ Aspect              │ Query (Ad-hoc SQL)        │ Stored Procedure         │
   ├─────────────────────┼──────────────────────────┼──────────────────────────┤
   │ Definition          │ A raw SQL statement       │ A named, saved block of  │
   │                     │ written and sent          │ SQL stored in the DB     │
   │                     │ on the fly                │ and executed by name     │
   ├─────────────────────┼──────────────────────────┼──────────────────────────┤
   │ Storage             │ Not saved in the DB.      │ Saved permanently in     │
   │                     │ Lives in app code or      │ the database under a     │
   │                     │ query editor only         │ name                     │
   ├─────────────────────┼──────────────────────────┼──────────────────────────┤
   │ Compilation         │ Compiled every time       │ Precompiled once and     │
   │                     │ it is executed            │ cached for reuse         │
   ├─────────────────────┼──────────────────────────┼──────────────────────────┤
   │ Performance         │ Slower — execution plan   │ Faster — execution plan  │
   │                     │ is regenerated each time  │ is reused every call     │
   ├─────────────────────┼──────────────────────────┼──────────────────────────┤
   │ Reusability         │ Must be copy-pasted or    │ Call it anywhere with    │
   │                     │ rewritten every time      │ just: EXEC proc_name     │
   ├─────────────────────┼──────────────────────────┼──────────────────────────┤
   │ Parameters          │ Values hardcoded or       │ Accepts INPUT/OUTPUT     │
   │                     │ concatenated as strings   │ parameters cleanly       │
   ├─────────────────────┼──────────────────────────┼──────────────────────────┤
   │ Security            │ User needs direct table   │ User only needs EXECUTE  │
   │                     │ SELECT/INSERT permissions │ permission on the proc   │
   ├─────────────────────┼──────────────────────────┼──────────────────────────┤
   │ SQL Injection Risk  │ Higher — especially if    │ Lower — parameters are   │
   │                     │ strings are concatenated  │ passed safely, not       │
   │                     │ to build the query        │ concatenated into SQL    │
   ├─────────────────────┼──────────────────────────┼──────────────────────────┤
   │ Error Handling      │ Limited — must be handled │ Built-in TRY/CATCH       │
   │                     │ in application code       │ blocks inside the proc   │
   ├─────────────────────┼──────────────────────────┼──────────────────────────┤
   │ Transactions        │ Possible but harder to    │ Easily wrapped in        │
   │                     │ manage across statements  │ BEGIN/COMMIT/ROLLBACK    │
   ├─────────────────────┼──────────────────────────┼──────────────────────────┤
   │ Maintainability     │ Logic scattered across    │ Logic centralized in     │
   │                     │ app code and queries      │ one place in the DB      │
   ├─────────────────────┼──────────────────────────┼──────────────────────────┤
   │ Network Traffic     │ Full SQL string sent      │ Only EXEC + params sent  │
   │                     │ from app to DB each time  │ — DB does the heavy work │
   ├─────────────────────┼──────────────────────────┼──────────────────────────┤
   │ When to Use         │ Simple, one-off, or       │ Repeated, complex, or    │
   │                     │ exploratory queries       │ business-critical logic  │
   └─────────────────────┴──────────────────────────┴──────────────────────────┘

-------------------------------------------------------------------------------
   SIDE BY SIDE EXAMPLE — Same task, two approaches
-------------------------------------------------------------------------------*/

-- -----------------------------------------------
-- APPROACH 1: Ad-hoc Query
-- Written inline, executed directly
-- Must rewrite every time you need it
-- -----------------------------------------------

SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Department
FROM Employees
WHERE Department = 'Sales'   -- value is hardcoded
ORDER BY LastName;


-- -----------------------------------------------
-- APPROACH 2: Stored Procedure
-- Written once, reused forever
-- Department is passed as a parameter
-- -----------------------------------------------

CREATE PROCEDURE GetEmployeesByDepartment
    @Department VARCHAR(100)        -- accepts any department dynamically
AS
BEGIN
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        Department
    FROM Employees
    WHERE Department = @Department
    ORDER BY LastName;
END;

-- Calling it is simple and clean:
EXEC GetEmployeesByDepartment @Department = 'Sales';
EXEC GetEmployeesByDepartment @Department = 'HR';
EXEC GetEmployeesByDepartment @Department = 'Engineering';


/* ------------------------------------------------------------------------------
   QUICK RULE OF THUMB
-------------------------------------------------------------------------------
   Use a Query when:
     - You are exploring or testing data
     - The logic runs only once
     - It is a simple, short SELECT with no complex logic

   Use a Stored Procedure when:
     - The same logic runs repeatedly
     - You need parameters, error handling, or transactions
     - Security and performance are a concern
     - Business logic should live in the database, not the app
============================================================================== */

/* ==============================================================================
   Basic Stored Procedure
============================================================================== */

-- Define the Stored Procedure
CREATE PROCEDURE GetCustomerSummary AS
BEGIN
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Sales.Customers
    WHERE Country = 'USA';
END
GO

--Execute Stored Procedure
EXEC GetCustomerSummary;

/* ==============================================================================
   Parameters in Stored Procedure
============================================================================== */

-- Edit the Stored Procedure
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
    -- Reports: Summary from Customers and Orders
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Sales.Customers
    WHERE Country = @Country;
END
GO

--Execute Stored Procedure
EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummary @Country = 'USA';
EXEC GetCustomerSummary;

--DROP PROCEDURE GetCustomerSummary
/* ==============================================================================
   Multiple Queries in Stored Procedure
============================================================================== */

-- Edit the Stored Procedure
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
    -- Query 1: Find the Total Nr. of Customers and the Average Score
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Sales.Customers
    WHERE Country = @Country;

    -- Query 2: Find the Total Nr. of Orders and Total Sales
    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;
END
GO

--Execute Stored Procedure
EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummary @Country = 'USA';
EXEC GetCustomerSummary;

/* ==============================================================================
   Variables in Stored Procedure
============================================================================== */

-- Edit the Stored Procedure
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
    -- Declare Variables
    DECLARE @TotalCustomers INT, @AvgScore FLOAT;
                
    -- Query 1: Find the Total Nr. of Customers and the Average Score
    SELECT
		@TotalCustomers = COUNT(*),
		@AvgScore = AVG(Score)
    FROM Sales.Customers
    WHERE Country = @Country;

	PRINT('Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR));
	PRINT('Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR));

    -- Query 2: Find the Total Nr. of Orders and Total Sales
    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;
END
GO

--Execute Stored Procedure
EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummary @Country = 'USA';
EXEC GetCustomerSummary;

/* ==============================================================================
   Control Flow IFELSE in Stored Procedure
============================================================================== */

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
	-- Declare Variables
	DECLARE @TotalCustomers INT, @AvgScore FLOAT;     

	/* --------------------------------------------------------------------------
	   Prepare & Cleanup Data
	-------------------------------------------------------------------------- */

	IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
	BEGIN
		PRINT('Updating NULL Scores to 0');
		UPDATE Sales.Customers
		SET Score = 0
		WHERE Score IS NULL AND Country = @Country;
	END
	ELSE
	BEGIN
		PRINT('No NULL Scores found');
	END;

	/* --------------------------------------------------------------------------
	   Generating Reports
	-------------------------------------------------------------------------- */
	SELECT
		@TotalCustomers = COUNT(*),
		@AvgScore = AVG(Score)
	FROM Sales.Customers
	WHERE Country = @Country;

	PRINT('Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR));
	PRINT('Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR));

	SELECT
		COUNT(OrderID) AS TotalOrders,
		SUM(Sales) AS TotalSales,
		1/0 AS FaultyCalculation  -- Intentional error for demonstration
	FROM Sales.Orders AS o
	JOIN Sales.Customers AS c
		ON c.CustomerID = o.CustomerID
	WHERE c.Country = @Country;
END
GO

--Execute Stored Procedure
EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummary @Country = 'USA';
EXEC GetCustomerSummary;

/* ==============================================================================
   Error Handling TRY CATCH in Stored Procedure
============================================================================== */

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
    
BEGIN
    BEGIN TRY
        -- Declare Variables
        DECLARE @TotalCustomers INT, @AvgScore FLOAT;     

        /* --------------------------------------------------------------------------
           Prepare & Cleanup Data
        -------------------------------------------------------------------------- */

        IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
        BEGIN
            PRINT('Updating NULL Scores to 0');
            UPDATE Sales.Customers
            SET Score = 0
            WHERE Score IS NULL AND Country = @Country;
        END
        ELSE
        BEGIN
            PRINT('No NULL Scores found');
        END;

        /* --------------------------------------------------------------------------
           Generating Reports
        -------------------------------------------------------------------------- */
        SELECT
            @TotalCustomers = COUNT(*),
            @AvgScore = AVG(Score)
        FROM Sales.Customers
        WHERE Country = @Country;

        PRINT('Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR));
        PRINT('Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR));

        SELECT
            COUNT(OrderID) AS TotalOrders,
            SUM(Sales) AS TotalSales,
            1/0 AS FaultyCalculation  -- Intentional error for demonstration
        FROM Sales.Orders AS o
        JOIN Sales.Customers AS c
            ON c.CustomerID = o.CustomerID
        WHERE c.Country = @Country;
    END TRY
    BEGIN CATCH
        /* --------------------------------------------------------------------------
           Error Handling
        -------------------------------------------------------------------------- */
        PRINT('An error occurred.');
        PRINT('Error Message: ' + ERROR_MESSAGE());
        PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
        PRINT('Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR));
        PRINT('Error State: ' + CAST(ERROR_STATE() AS NVARCHAR));
        PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
        PRINT('Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A'));
    END CATCH;
END
GO

--Execute Stored Procedure
EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummary @Country = 'USA';
EXEC GetCustomerSummary;