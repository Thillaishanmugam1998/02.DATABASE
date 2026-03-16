/* ==============================================================================
   SQL SERVER — STORED PROCEDURES COMPLETE GUIDE
   Tamil Explanation | Same Examples from Lesson File
   
   TABLE OF CONTENTS:
   ------------------
   SECTION 1  : Stored Procedure Na Enna?
   SECTION 2  : En Use Panrom? (Why Not Just Use a Query?)
   SECTION 3  : Query vs Stored Procedure — Real Comparison
   SECTION 4  : Basic Stored Procedure
   SECTION 5  : Parameters
   SECTION 6  : Multiple Queries
   SECTION 7  : Variables
   SECTION 8  : IF/ELSE Control Flow
   SECTION 9  : TRY/CATCH Error Handling
   SECTION 10 : Full Summary
============================================================================== */



/* ==============================================================================
   SECTION 1 — STORED PROCEDURE NA ENNA?
--------------------------------------------------------------------------------

   SIMPLE DEFINITION:
   ------------------
   Stored Procedure =  A stored procedure is a precompiled collection of one or more SQL statements
   stored in the database under a name, and executed as a unit.

   Think of it like a function or method in programming — you define the logic
   once and call it by name whenever needed.

   REAL LIFE EXAMPLE:
   ------------------
   🍽️ Restaurant menu mathiri!

   WITHOUT Stored Procedure:
   → Every time customer varuvaanga → Chef ku
     "2 cups rice, 1 cup dal, 200g chicken, 15 min cook..."
     ellame explain pannanum! 😫

   WITH Stored Procedure:
   → "Chicken Biryani order please" → Chef understands everything!
   → Oru name sollichae — full process execute! 😎

   DATABASE LA:
   ------------
   WITHOUT → Every time full SQL query write pannanum
   WITH    → EXEC GetCustomerSummary — oru line!

   TECHNICAL DEFINITION:
   ---------------------
   • Precompiled collection of SQL statements
   • Database la save aagum (permanent)
   • Name kodutha execute aagum
   • Parameters accept pannuvom (dynamic)
   • Error handling built-in

   BASIC SYNTAX:
   -------------
   -- Create:
   CREATE PROCEDURE ProcedureName
   AS
   BEGIN
       -- SQL logic here
   END

   -- Execute:
   EXEC ProcedureName;

============================================================================== */



/* ==============================================================================
   SECTION 2 — EN USE PANROM? (Why Stored Procedure?)
--------------------------------------------------------------------------------

   REASON 1: REUSABILITY (Oru thadavai write → Forever use)
   ----------------------------------------------------------
   Without SP:
   → Web app la same query
   → Mobile app la same query
   → Reports la same query
   → 3 places la same code! 😫

   With SP:
   → EXEC GetCustomerSummary → Everywhere same call! ✅

   ─────────────────────────────────────────────────────────────

   REASON 2: PERFORMANCE (Faster execution)
   -----------------------------------------
   Normal Query:
   → Every time SQL Server parse → compile → execute
   → 3 steps every single time!

   Stored Procedure:
   → First time: parse → compile → CACHE
   → Next time: directly execute from cache!
   → Plan reuse = FASTER! 🚀

   ─────────────────────────────────────────────────────────────

   REASON 3: SECURITY (Table access kudukaama)
   --------------------------------------------
   Without SP:
   → App ku direct table access kudukanum
   → SELECT, INSERT, UPDATE ellame grant pannanum
   → Risk! 😰

   With SP:
   → User ku only EXECUTE permission kuduvom
   → Table directly touch panna mudiyaadhu
   → Secure! 🔒

   ─────────────────────────────────────────────────────────────

   REASON 4: MAINTAINABILITY (One place change)
   ---------------------------------------------
   Business rule change aagindha:
   Without SP → Web app, Mobile app, API — ellame update pannanum
   With SP    → SP la oru place update → Done! ✅

   ─────────────────────────────────────────────────────────────

   REASON 5: REDUCED NETWORK TRAFFIC
   -----------------------------------
   Without SP:
   App → Server ku full SQL string send pannuvom
   "SELECT COUNT(*) AS TotalCustomers, AVG(Score) AS AvgScore
    FROM Sales.Customers WHERE Country = @Country..." (100+ chars)

   With SP:
   App → "EXEC GetCustomerSummary 'USA'" (30 chars only!)
   Server side heavy work nadakkum! ✅

   ─────────────────────────────────────────────────────────────

   REASON 6: ERROR HANDLING (TRY/CATCH built-in)
   -----------------------------------------------
   Normal Query → Error aana app crash!
   Stored Procedure → TRY/CATCH handle pannalam, graceful error! ✅

============================================================================== */



/* ==============================================================================
   SECTION 3 — QUERY vs STORED PROCEDURE (Real Comparison)
--------------------------------------------------------------------------------

   SAME TASK — TWO APPROACHES:

   APPROACH 1: Ad-hoc Query (Normal Query)
   ----------------------------------------
   • Direct SQL write panni run pannuvom
   • Every time full query send aagum
   • Hard-coded values
   • No reuse
   ─────────────────────────────────────────────────────────────
*/

-- Normal Query approach:
-- USA customers paakanum → Full query write pannanum
SELECT
    COUNT(*) AS TotalCustomers,
    AVG(Score) AS AvgScore
FROM Sales.Customers
WHERE Country = 'USA';    -- Hard-coded! 'Germany' paakanum na new query!

-- Germany customers paakanum → Again same query, value change mattum!
SELECT
    COUNT(*) AS TotalCustomers,
    AVG(Score) AS AvgScore
FROM Sales.Customers
WHERE Country = 'Germany';  -- Duplicate code! ❌

/*
   PROBLEM WITH QUERY APPROACH:
   • Country change aana → New query write pannanum
   • 10 countries = 10 queries = 10x duplicate code!
   • Business logic app la irukum (DB la illai)
   • Security: Table ku direct access kudukkanum
   • SQL Injection risk (if app concatenates strings)

   ─────────────────────────────────────────────────────────────

   APPROACH 2: Stored Procedure
   -----------------------------
   • Once write → Always reuse
   • Parameter pass pannuvom → Dynamic!
   • DB la save aagum
   • Secure + Fast
   ─────────────────────────────────────────────────────────────
*/

-- Stored Procedure approach:
-- Once create pannuvom
CREATE PROCEDURE GetCustomerSummary
AS
BEGIN
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Sales.Customers
    WHERE Country = 'USA';
END
GO

-- Oru line la execute!
EXEC GetCustomerSummary;
GO

/*
   COMPARISON TABLE:
   ─────────────────────────────────────────────────────────────────────────
   Aspect            │ Ad-hoc Query          │ Stored Procedure
   ──────────────────│───────────────────────│────────────────────────────
   Storage           │ Not saved in DB       │ DB la permanently saved
   Compilation       │ Every time compile    │ Once compile, cache reuse
   Performance       │ Slower                │ Faster (plan reuse)
   Reusability       │ Copy-paste every time │ EXEC oru line mattum
   Parameters        │ Hard-coded values     │ Dynamic parameters
   Security          │ Table access needed   │ Only EXECUTE needed
   SQL Injection     │ Higher risk           │ Lower risk
   Error Handling    │ App level             │ TRY/CATCH inside SP
   Maintenance       │ Change everywhere     │ One place change
   Network Traffic   │ Full SQL send         │ Only EXEC send
   ─────────────────────────────────────────────────────────────────────────

   WHEN TO USE QUERY:
   • Data explore panna (one-time)
   • Simple short SELECT
   • Testing / Debugging

   WHEN TO USE STORED PROCEDURE:
   • Same logic repeat aagum
   • Parameters needed
   • Error handling needed
   • Security important
   • Business-critical logic
   ─────────────────────────────────────────────────────────────────────────
*/



/* ==============================================================================
   SECTION 4 — BASIC STORED PROCEDURE
--------------------------------------------------------------------------------
   USA customers summary — basic version, no parameters
   
   WHAT THIS DOES:
   • Sales.Customers table la USA customers count pannuvom
   • Average Score calculate pannuvom
============================================================================== */

-- ─────────────────────────────────────────────────────────────
-- CREATE: SP create pannuvom
-- ─────────────────────────────────────────────────────────────
CREATE PROCEDURE GetCustomerSummary AS
BEGIN
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Sales.Customers
    WHERE Country = 'USA';    -- Fixed to USA only (no parameter yet)
END
GO

/*
   WHAT HAPPENS INTERNALLY:
   1. SQL Server reads this CREATE statement
   2. Parses + Compiles the SQL inside
   3. Saves execution plan in cache
   4. Stores procedure in sys.procedures

   NEXT TIME EXEC PANNINA:
   → No parse, no compile needed!
   → Directly cached plan use aagum → FAST!
*/

-- ─────────────────────────────────────────────────────────────
-- EXECUTE: SP run pannuvom
-- ─────────────────────────────────────────────────────────────
EXEC GetCustomerSummary;
GO

/*
EXPECTED OUTPUT:
TotalCustomers | AvgScore
213            | 487.5

PROBLEM WITH THIS VERSION:
'USA' hard-coded irukku!
Germany paakanum na → SP modify pannanum!
Solution → Parameters use pannuvom! (Next section)
*/



/* ==============================================================================
   SECTION 5 — PARAMETERS
--------------------------------------------------------------------------------
   Hard-coded 'USA' → Dynamic @Country parameter aakkuvom!

   PARAMETER TYPES:
   • INPUT  parameter  → Caller SP ku value kuduppaan (most common)
   • OUTPUT parameter  → SP caller ku value return pannuvom
   • DEFAULT parameter → Value kudukkavillana default use aagum
   
   SYNTAX:
   CREATE PROCEDURE ProcName
       @ParamName DataType = DefaultValue    ← = DefaultValue is optional
   AS BEGIN ... END
============================================================================== */

-- ─────────────────────────────────────────────────────────────
-- ALTER: Existing SP modify pannuvom (parameter add pannuvom)
-- ─────────────────────────────────────────────────────────────
ALTER PROCEDURE GetCustomerSummary
    @Country NVARCHAR(50) = 'USA'    -- Default value = 'USA'
AS
BEGIN
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Sales.Customers
    WHERE Country = @Country;    -- Hard-code pochu! Now dynamic! ✅
END
GO

/*
   WHAT CHANGED:
   Before: WHERE Country = 'USA'        ← Fixed
   After:  WHERE Country = @Country     ← Dynamic!

   @Country = NVARCHAR(50) → 50 character string accept pannuvom
   = 'USA' → Parameter illana DEFAULT 'USA' use aagum
*/

-- ─────────────────────────────────────────────────────────────
-- EXECUTE: Different ways to call
-- ─────────────────────────────────────────────────────────────

-- Method 1: Named parameter (recommended - clear)
EXEC GetCustomerSummary @Country = 'Germany';
GO
/*
OUTPUT:
TotalCustomers | AvgScore
89             | 512.3
*/

-- Method 2: Positional (order matter!)
EXEC GetCustomerSummary 'USA';
GO
/*
OUTPUT:
TotalCustomers | AvgScore
213            | 487.5
*/

-- Method 3: Default value use (parameter kudukkavillai = 'USA' use aagum)
EXEC GetCustomerSummary;
GO
/*
OUTPUT: Same as 'USA' — default value kicked in!
TotalCustomers | AvgScore
213            | 487.5
*/

/*
   BENEFIT OF PARAMETERS:
   • Oru SP — any country ku work aagum!
   • 50 countries irundhalum → Same EXEC, different @Country value
   • Code duplicate zero!
*/



/* ==============================================================================
   SECTION 6 — MULTIPLE QUERIES IN ONE SP
--------------------------------------------------------------------------------
   Oru SP la rendu queries run pannuvom:
   1. Customer summary (Count + Avg Score)
   2. Order summary (Total Orders + Total Sales)

   WHY MULTIPLE QUERIES IN ONE SP?
   • Related information oru call la get pannalam
   • App 2 separate calls panna vendam
   • Network traffic reduce
   • Transaction consistency (both or neither)
============================================================================== */

ALTER PROCEDURE GetCustomerSummary
    @Country NVARCHAR(50) = 'USA'
AS
BEGIN

    -- ─────────────────────────────────────────────
    -- Query 1: Customer Summary
    -- Sales.Customers table la @Country filter
    -- ─────────────────────────────────────────────
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Sales.Customers
    WHERE Country = @Country;

    -- ─────────────────────────────────────────────
    -- Query 2: Order Summary
    -- Orders + Customers JOIN pannி @Country filter
    -- ─────────────────────────────────────────────
    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;

END
GO

-- Execute — Two result sets return aagum!
EXEC GetCustomerSummary @Country = 'Germany';
GO
/*
RESULT SET 1 (Customer Summary):
TotalCustomers | AvgScore
89             | 512.3

RESULT SET 2 (Order Summary):
TotalOrders | TotalSales
342         | 187650.00
*/

EXEC GetCustomerSummary @Country = 'USA';
GO

EXEC GetCustomerSummary;    -- Default 'USA'
GO

/*
   WHY RENDU QUERIES IN ONE SP?
   App: "Germany data kudu" → ONE call → TWO result sets back!
   vs
   App: First call for customers + Second call for orders = 2 network trips!
   SP approach = faster, cleaner! ✅
*/



/* ==============================================================================
   SECTION 7 — VARIABLES
--------------------------------------------------------------------------------
   Query result → Variable la store pannuvom → PRINT pannuvom

   VARIABLE USE CASES:
   • Intermediate calculations store pannuvom
   • PRINT statements la use pannuvom
   • Conditions check pannuvom (IF @Count > 0)
   • One query result → Another query la use pannuvom

   SYNTAX:
   DECLARE @VariableName DataType;         -- Declare
   SET @VariableName = value;              -- Assign (direct)
   SELECT @VariableName = column FROM ...; -- Assign (from query)
============================================================================== */

ALTER PROCEDURE GetCustomerSummary
    @Country NVARCHAR(50) = 'USA'
AS
BEGIN

    -- ─────────────────────────────────────────────
    -- Variables declare pannuvom
    -- ─────────────────────────────────────────────
    DECLARE @TotalCustomers INT;     -- Integer store pannuvom
    DECLARE @AvgScore FLOAT;         -- Decimal store pannuvom

    /*
       DECLARE = Variable create pannum
       @TotalCustomers INT   → whole number (1, 89, 213...)
       @AvgScore FLOAT       → decimal number (487.5, 512.3...)
    */

    -- ─────────────────────────────────────────────
    -- Query 1: Variable la value store pannuvom
    -- SELECT → directly variable ku assign!
    -- ─────────────────────────────────────────────
    SELECT
        @TotalCustomers = COUNT(*),      -- Result → variable la save!
        @AvgScore       = AVG(Score)
    FROM Sales.Customers
    WHERE Country = @Country;

    /*
       WHAT HAPPENS HERE:
       COUNT(*) result → @TotalCustomers la store aagum
       AVG(Score) result → @AvgScore la store aagum
       No result set shown to user (variable la capture aagum)
    */

    -- ─────────────────────────────────────────────
    -- Variable use pannி PRINT pannuvom
    -- ─────────────────────────────────────────────
    PRINT('Total Customers from ' + @Country + ': ' + CAST(@TotalCustomers AS NVARCHAR));
    PRINT('Average Score from ' + @Country + ': '   + CAST(@AvgScore AS NVARCHAR));

    /*
       CAST() = Data type convert pannuvom
       INT → NVARCHAR convert pannanum because:
       PRINT string + number directly panna mudiyaadhu!

       Example output in Messages tab:
       "Total Customers from Germany: 89"
       "Average Score from Germany: 512.3"
    */

    -- ─────────────────────────────────────────────
    -- Query 2: Orders summary (result set return)
    -- ─────────────────────────────────────────────
    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales,
        1/0 AS FaultyCalculation    -- ← Intentional ERROR for next section demo!
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;

    /*
       1/0 = Division by zero ERROR!
       SQL Server throw pannuvum: "Divide by zero error encountered"
       Next section la TRY/CATCH use pannி handle pannuvom
    */

END
GO

-- Execute and check Messages tab for PRINT output!
EXEC GetCustomerSummary @Country = 'Germany';
GO
/*
MESSAGES TAB OUTPUT:
Total Customers from Germany: 89
Average Score from Germany: 512.3

RESULTS TAB:
ERROR: Divide by zero error encountered (1/0 la irundhu)
*/

EXEC GetCustomerSummary @Country = 'USA';
EXEC GetCustomerSummary;
GO



/* ==============================================================================
   SECTION 8 — IF/ELSE CONTROL FLOW
--------------------------------------------------------------------------------
   Condition based logic — NULL scores irundha update pannuvom

   WHY IF/ELSE IN SP?
   • Data quality check pannalam
   • Different paths different logic
   • Business rules enforce pannalam

   SYNTAX:
   IF (condition)
   BEGIN
       -- True la run aagum
   END
   ELSE
   BEGIN
       -- False la run aagum
   END
============================================================================== */

ALTER PROCEDURE GetCustomerSummary
    @Country NVARCHAR(50) = 'USA'
AS
BEGIN

    -- Variables
    DECLARE @TotalCustomers INT;
    DECLARE @AvgScore FLOAT;

    -- ─────────────────────────────────────────────────────────
    -- STEP 1: Data Cleanup — NULL Scores check + fix pannuvom
    -- ─────────────────────────────────────────────────────────

    IF EXISTS (
        SELECT 1
        FROM Sales.Customers
        WHERE Score IS NULL
          AND Country = @Country
    )
    /*
       EXISTS() = At least oru row irundha TRUE return pannuvom
       SELECT 1 → Actual column matter illai, row irukka nu check mattum
       
       Translation:
       "@Country la Score = NULL irukka customers irukkaanga?"
    */
    BEGIN
        -- NULL irukku → 0 la update pannuvom
        PRINT('Updating NULL Scores to 0');

        UPDATE Sales.Customers
        SET Score = 0
        WHERE Score IS NULL
          AND Country = @Country;

        /*
           NULL scores irundha AVG() wrong aagum!
           NULL values AVG calculation la skip aagum.
           0 la set pannina → Correct average varum.
        */
    END
    ELSE
    BEGIN
        -- NULL இல்லை → No action needed
        PRINT('No NULL Scores found');
    END;

    -- ─────────────────────────────────────────────────────────
    -- STEP 2: Summary Queries
    -- ─────────────────────────────────────────────────────────

    SELECT
        @TotalCustomers = COUNT(*),
        @AvgScore       = AVG(Score)
    FROM Sales.Customers
    WHERE Country = @Country;

    PRINT('Total Customers from ' + @Country + ': ' + CAST(@TotalCustomers AS NVARCHAR));
    PRINT('Average Score from '   + @Country + ': ' + CAST(@AvgScore AS NVARCHAR));

    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales)     AS TotalSales,
        1/0 AS FaultyCalculation    -- Still here → Next section fix pannuvom
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;

END
GO

EXEC GetCustomerSummary @Country = 'Germany';
GO
/*
MESSAGES TAB (if NULL scores exist):
"Updating NULL Scores to 0"
"Total Customers from Germany: 89"
"Average Score from Germany: 498.7"

MESSAGES TAB (if no NULL scores):
"No NULL Scores found"
"Total Customers from Germany: 89"
"Average Score from Germany: 512.3"

Then ERROR on 1/0 line...
*/

EXEC GetCustomerSummary @Country = 'USA';
EXEC GetCustomerSummary;
GO



/* ==============================================================================
   SECTION 9 — TRY/CATCH ERROR HANDLING
--------------------------------------------------------------------------------
   Error aana → Crash aagamal gracefully handle pannuvom

   WITHOUT TRY/CATCH:
   → Error varum → SP stop aagum → App ku ugly error message
   → User "Error 8134: Divide by zero" paakuvaanga 😱

   WITH TRY/CATCH:
   → Error varum → CATCH block run aagum
   → Friendly message show pannalam
   → Log pannalam
   → App crash aagaadhu ✅

   SYNTAX:
   BEGIN TRY
       -- Normal logic here
       -- Error varudha → immediately CATCH ku jump
   END TRY
   BEGIN CATCH
       -- Error details handle pannuvom
       ERROR_MESSAGE()   → Error text
       ERROR_NUMBER()    → Error code
       ERROR_SEVERITY()  → How serious (1-25)
       ERROR_STATE()     → Error state
       ERROR_LINE()      → Which line error
       ERROR_PROCEDURE() → Which SP la error
   END CATCH
============================================================================== */

ALTER PROCEDURE GetCustomerSummary
    @Country NVARCHAR(50) = 'USA'
AS
BEGIN

    -- ─────────────────────────────────────────────────────────
    -- TRY block: Normal logic here
    -- Error aana → immediately CATCH ku jump aagum
    -- ─────────────────────────────────────────────────────────
    BEGIN TRY

        -- Variables
        DECLARE @TotalCustomers INT;
        DECLARE @AvgScore FLOAT;

        -- ── Data Cleanup ──────────────────────────────────────
        IF EXISTS (
            SELECT 1
            FROM Sales.Customers
            WHERE Score IS NULL
              AND Country = @Country
        )
        BEGIN
            PRINT('Updating NULL Scores to 0');
            UPDATE Sales.Customers
            SET Score = 0
            WHERE Score IS NULL
              AND Country = @Country;
        END
        ELSE
        BEGIN
            PRINT('No NULL Scores found');
        END;

        -- ── Customer Summary ──────────────────────────────────
        SELECT
            @TotalCustomers = COUNT(*),
            @AvgScore       = AVG(Score)
        FROM Sales.Customers
        WHERE Country = @Country;

        PRINT('Total Customers from ' + @Country + ': ' + CAST(@TotalCustomers AS NVARCHAR));
        PRINT('Average Score from '   + @Country + ': ' + CAST(@AvgScore AS NVARCHAR));

        -- ── Order Summary (with intentional 1/0 error) ────────
        SELECT
            COUNT(OrderID) AS TotalOrders,
            SUM(Sales)     AS TotalSales,
            1/0 AS FaultyCalculation    -- ERROR here! → CATCH ku jump!
        FROM Sales.Orders AS o
        JOIN Sales.Customers AS c
            ON c.CustomerID = o.CustomerID
        WHERE c.Country = @Country;

        /*
           1/0 line reach aana →
           SQL Server error throw pannuvaan →
           Remaining TRY code skip →
           Directly CATCH block ku jump!
        */

    END TRY

    -- ─────────────────────────────────────────────────────────
    -- CATCH block: Error details print pannuvom
    -- ─────────────────────────────────────────────────────────
    BEGIN CATCH

        PRINT('An error occurred.');

        PRINT('Error Message: '   + ERROR_MESSAGE());
        -- "Divide by zero error encountered."

        PRINT('Error Number: '    + CAST(ERROR_NUMBER()   AS NVARCHAR));
        -- 8134 (SQL Server error code for divide by zero)

        PRINT('Error Severity: '  + CAST(ERROR_SEVERITY() AS NVARCHAR));
        -- 16 (User errors = 11-16, System errors = 17-25)

        PRINT('Error State: '     + CAST(ERROR_STATE()    AS NVARCHAR));
        -- State code (mostly 1)

        PRINT('Error Line: '      + CAST(ERROR_LINE()     AS NVARCHAR));
        -- Exact line number where error occurred!

        PRINT('Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A'));
        -- 'GetCustomerSummary' (SP name)

        /*
           ISNULL(ERROR_PROCEDURE(), 'N/A'):
           SP name return pannuvaan normally.
           SP outside error aana NULL return pannuvaan.
           ISNULL → NULL irundha 'N/A' show pannuvom.
        */

    END CATCH;

END
GO

-- Execute — Error varum, but SP crash aagaadhu!
EXEC GetCustomerSummary @Country = 'Germany';
GO
/*
MESSAGES TAB OUTPUT:
No NULL Scores found
Total Customers from Germany: 89
Average Score from Germany: 512.3
An error occurred.
Error Message: Divide by zero error encountered.
Error Number: 8134
Error Severity: 16
Error State: 1
Error Line: 67
Error Procedure: GetCustomerSummary

↑ SP gracefully handled the error!
↑ User gets meaningful message, not ugly SQL crash!
*/

EXEC GetCustomerSummary @Country = 'USA';
EXEC GetCustomerSummary;
GO



/* ==============================================================================
   SECTION 10 — SP MANAGEMENT COMMANDS
--------------------------------------------------------------------------------
   Create, Alter, Drop, Execute, View SP info
============================================================================== */

-- SP create pannuvom
CREATE PROCEDURE MyProc AS BEGIN SELECT 1; END
GO

-- SP modify pannuvom (ALTER — existing SP update)
ALTER PROCEDURE MyProc AS BEGIN SELECT 2; END
GO

-- SP execute pannuvom
EXEC MyProc;
EXEC MyProc;        -- Same call, cached plan reuse → FAST!
GO

-- SP delete pannuvom
DROP PROCEDURE IF EXISTS MyProc;
GO

-- All SPs in database list pannuvom
SELECT
    name            AS ProcedureName,
    create_date     AS CreatedDate,
    modify_date     AS ModifiedDate
FROM sys.procedures
WHERE is_ms_shipped = 0    -- System SPs skip
ORDER BY name;
GO

-- Specific SP code paakuvom
EXEC sp_helptext 'GetCustomerSummary';
GO

-- SP parameters paakuvom
EXEC sp_help 'GetCustomerSummary';
GO



/* ==============================================================================
   SECTION 11 — COMPLETE SUMMARY
--------------------------------------------------------------------------------

   STORED PROCEDURE EVOLUTION (This lesson la):
   ─────────────────────────────────────────────────────────────────────────────
   Version 1 (Basic):
     → USA hard-coded, no params, simple SELECT

   Version 2 (Parameters):
     → @Country param add → Dynamic, any country work aagum
     → Default value 'USA' → Param illana default use

   Version 3 (Multiple Queries):
     → Rendu result sets — Customer summary + Order summary
     → One SP call → Complete dashboard data!

   Version 4 (Variables):
     → Results variable la store → PRINT statements
     → Messages tab la meaningful output

   Version 5 (IF/ELSE):
     → NULL check → Auto fix pannuvom
     → Data quality ensure pannuvom before report

   Version 6 (TRY/CATCH):
     → Error gracefully handle
     → Meaningful error messages
     → SP crash aagaadhu

   KEY TAKEAWAYS:
   ─────────────────────────────────────────────────────────────────────────────
   1. SP = Named saved SQL → EXEC oru line la run
   2. Query vs SP: Query = one-time | SP = reusable, fast, secure
   3. Parameters → Hard-code vendam, dynamic aagum
   4. DECLARE + SELECT → Variable la query result store
   5. IF/EXISTS → Data condition check + fix
   6. TRY/CATCH → ERROR_MESSAGE(), ERROR_LINE() etc use pannuvom
   7. ALTER PROCEDURE → Existing SP modify (DROP + CREATE vendam)
   8. PRINT → Messages tab la output (debugging ku useful)
   9. CAST() → Data type convert (INT → NVARCHAR for PRINT)
   10. SP = Performance + Security + Maintainability + Reusability
   ─────────────────────────────────────────────────────────────────────────────

============================================================================== */