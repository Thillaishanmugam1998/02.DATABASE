-- ============================================================
--   SQL CONCEPTS: Normal Table vs Temp Table vs CTE vs Views
--   Real-Time IT Company Project Example
--   Simple English | Clear Differences | When to Use What
-- ============================================================

-- SCENARIO:
-- You work at an IT company called "TechCorp".
-- There is a project called "Employee Payroll & HR System".
-- The team has: Employees, Departments, Salaries, and Projects.
-- We will solve REAL problems using each concept.

-- ============================================================
-- PART 1: NORMAL TABLE
-- ============================================================

-- WHAT IS IT?
-- A Normal Table is a PERMANENT table stored in the database.
-- It stays there FOREVER until you manually drop it.
-- Everyone in the team can see and use it anytime.

-- WHEN TO USE IT?
-- Use Normal Table when:
--   1. Data is permanent and important (like Employee records)
--   2. Multiple users/systems need to access it daily
--   3. You want indexes, foreign keys, and constraints on it
--   4. Data should survive even after server restart

-- REAL SITUATION IN TECHCORP:
-- HR Manager says: "We need to store all employee details permanently"
-- Answer: Create a Normal Table!

CREATE TABLE Employees (
    employee_id     INT PRIMARY KEY,
    employee_name   VARCHAR(100),
    department      VARCHAR(50),
    designation     VARCHAR(50),
    joining_date    DATE,
    salary          DECIMAL(10, 2),
    is_active       BIT DEFAULT 1   -- 1 = Active, 0 = Left company
);

CREATE TABLE Departments (
    department_id   INT PRIMARY KEY,
    department_name VARCHAR(50),
    manager_id      INT
);

CREATE TABLE Projects (
    project_id      INT PRIMARY KEY,
    project_name    VARCHAR(100),
    department_id   INT,
    start_date      DATE,
    end_date        DATE,
    status          VARCHAR(20)   -- 'Active', 'Completed', 'On Hold'
);

-- Insert sample data
INSERT INTO Employees VALUES (1, 'Ravi Kumar',    'Engineering', 'Senior Dev',   '2020-01-15', 85000, 1);
INSERT INTO Employees VALUES (2, 'Priya Sharma',  'Engineering', 'Junior Dev',   '2021-06-01', 55000, 1);
INSERT INTO Employees VALUES (3, 'Amit Singh',    'HR',          'HR Manager',   '2019-03-10', 70000, 1);
INSERT INTO Employees VALUES (4, 'Sneha Patel',   'Finance',     'Analyst',      '2022-08-20', 60000, 1);
INSERT INTO Employees VALUES (5, 'Karan Mehta',   'Engineering', 'Tech Lead',    '2018-07-05', 95000, 1);
INSERT INTO Employees VALUES (6, 'Divya Reddy',   'Finance',     'Senior Analyst','2020-11-12', 72000, 1);
INSERT INTO Employees VALUES (7, 'Suresh Babu',   'Engineering', 'Junior Dev',   '2023-02-01', 50000, 1);
INSERT INTO Employees VALUES (8, 'Lakshmi Nair',  'HR',          'HR Executive', '2021-09-15', 48000, 1);

INSERT INTO Departments VALUES (1, 'Engineering', 5);
INSERT INTO Departments VALUES (2, 'HR',          3);
INSERT INTO Departments VALUES (3, 'Finance',     6);

INSERT INTO Projects VALUES (1, 'Payroll System',      1, '2024-01-01', '2024-06-30', 'Completed');
INSERT INTO Projects VALUES (2, 'HR Portal Upgrade',   2, '2024-03-01', '2024-09-30', 'Active');
INSERT INTO Projects VALUES (3, 'Finance Dashboard',   3, '2024-05-01', '2024-12-31', 'Active');
INSERT INTO Projects VALUES (4, 'Mobile App v2',       1, '2024-07-01', '2025-01-31', 'Active');

-- Normal Table Query Example:
-- HR wants to see all active engineering employees
SELECT employee_id, employee_name, designation, salary
FROM Employees
WHERE department = 'Engineering' AND is_active = 1;

-- KEY POINTS ABOUT NORMAL TABLE:
-- + Data is PERMANENT - survives restarts, sessions
-- + Supports INDEXES for fast search
-- + Supports FOREIGN KEYS for data integrity
-- + Multiple users can read/write at same time
-- - You must manually manage and clean up data
-- - Dropping table loses all data permanently

-- ============================================================
-- PART 2: TEMPORARY TABLE
-- ============================================================

-- WHAT IS IT?
-- A Temp Table is a table that lives ONLY during your session.
-- Once your connection closes, the temp table is GONE automatically.
-- Other users CANNOT see your temp table (it's private to your session).

-- WHEN TO USE IT?
-- Use Temp Table when:
--   1. You need to store intermediate results during complex processing
--   2. You are doing a long multi-step calculation
--   3. You don't want to mess with real tables
--   4. You need to reuse the same data multiple times in your script
--   5. Data is only needed for THIS session/batch job

-- REAL SITUATION IN TECHCORP:
-- Finance team runs a monthly payroll script every month-end.
-- Step 1: Find all active employees
-- Step 2: Calculate tax for each
-- Step 3: Calculate bonus
-- Step 4: Generate final payslip
-- They need to store middle results somewhere → Use Temp Table!

-- Step 1: Store active employees in temp table
CREATE TABLE #ActiveEmployees (
    employee_id     INT,
    employee_name   VARCHAR(100),
    department      VARCHAR(50),
    salary          DECIMAL(10, 2),
    tax_amount      DECIMAL(10, 2),
    bonus_amount    DECIMAL(10, 2),
    net_pay         DECIMAL(10, 2)
);

-- Step 2: Load active employees
INSERT INTO #ActiveEmployees (employee_id, employee_name, department, salary)
SELECT employee_id, employee_name, department, salary
FROM Employees
WHERE is_active = 1;

-- Step 3: Calculate Tax (simple 10% rule for example)
UPDATE #ActiveEmployees
SET tax_amount = salary * 0.10;

-- Step 4: Calculate Bonus (Engineering gets 15%, others get 10%)
UPDATE #ActiveEmployees
SET bonus_amount = CASE
    WHEN department = 'Engineering' THEN salary * 0.15
    ELSE salary * 0.10
END;

-- Step 5: Calculate Net Pay
UPDATE #ActiveEmployees
SET net_pay = salary + bonus_amount - tax_amount;

-- Step 6: Now use the clean result
SELECT
    employee_name,
    department,
    salary          AS base_salary,
    bonus_amount    AS bonus,
    tax_amount      AS tax_deduction,
    net_pay         AS final_take_home
FROM #ActiveEmployees
ORDER BY department, employee_name;

-- This temp table will be DELETED automatically when session ends!

-- ANOTHER REAL USE: Report Generation
-- Manager wants: "Show me employees earning above department average"
-- This needs 2 steps - first find averages, then compare

CREATE TABLE #DeptAvgSalary (
    department      VARCHAR(50),
    avg_salary      DECIMAL(10, 2)
);

INSERT INTO #DeptAvgSalary
SELECT department, AVG(salary)
FROM Employees
WHERE is_active = 1
GROUP BY department;

-- Now use temp table to find above-average earners
SELECT
    e.employee_name,
    e.department,
    e.salary,
    d.avg_salary        AS dept_avg,
    e.salary - d.avg_salary AS above_avg_by
FROM Employees e
JOIN #DeptAvgSalary d ON e.department = d.department
WHERE e.salary > d.avg_salary AND e.is_active = 1;

-- Clean up (optional - auto-deleted when session ends)
DROP TABLE IF EXISTS #ActiveEmployees;
DROP TABLE IF EXISTS #DeptAvgSalary;

-- KEY POINTS ABOUT TEMP TABLE:
-- + Auto-deleted when your session ends (no cleanup needed)
-- + Safe - other users cannot see your temp table
-- + Can add INDEXES on temp tables for faster joins
-- + Great for step-by-step processing / batch jobs
-- - Only lives during your session
-- - Not shared across users or sessions

-- ============================================================
-- PART 3: CTE (Common Table Expression)
-- ============================================================

-- WHAT IS IT?
-- CTE is a TEMPORARY named result that you define at the TOP of a query.
-- It starts with the keyword WITH.
-- It exists ONLY for that single query execution - not even the full session!
-- Think of it as giving a name to a subquery so your code is cleaner.

-- WHEN TO USE IT?
-- Use CTE when:
--   1. Your query is getting complex and hard to read
--   2. You need to reuse the same subquery multiple times in ONE query
--   3. You want to write recursive queries (like org hierarchy)
--   4. You want to break a complex logic into readable steps
--   5. You DON'T need to reuse results in a LATER query

-- REAL SITUATION IN TECHCORP:
-- Tech Lead asks: "Give me a report showing:
--   - Each department's total salary cost
--   - Each employee's % share of their department salary
--   - Flag if employee earns above department average"

-- WITHOUT CTE - hard to read, subqueries inside subqueries:
SELECT
    e.employee_name,
    e.department,
    e.salary,
    (SELECT SUM(salary) FROM Employees WHERE department = e.department AND is_active = 1) AS dept_total,
    e.salary * 100.0 / (SELECT SUM(salary) FROM Employees WHERE department = e.department AND is_active = 1) AS pct_share
FROM Employees e
WHERE e.is_active = 1;
-- ^ This is messy! Same subquery repeated twice!

-- WITH CTE - clean, readable, same logic:
WITH DeptSummary AS (
    -- Step 1: Calculate department totals and averages
    SELECT
        department,
        SUM(salary)  AS dept_total_salary,
        AVG(salary)  AS dept_avg_salary,
        COUNT(*)     AS headcount
    FROM Employees
    WHERE is_active = 1
    GROUP BY department
)
-- Step 2: Use the CTE in main query
SELECT
    e.employee_name,
    e.department,
    e.salary,
    d.dept_total_salary,
    d.dept_avg_salary,
    d.headcount,
    ROUND(e.salary * 100.0 / d.dept_total_salary, 2) AS pct_of_dept_cost,
    CASE
        WHEN e.salary > d.dept_avg_salary THEN 'Above Average'
        ELSE 'Below Average'
    END AS performance_band
FROM Employees e
JOIN DeptSummary d ON e.department = d.department
WHERE e.is_active = 1
ORDER BY e.department, e.salary DESC;

-- MULTIPLE CTEs IN ONE QUERY:
-- Manager asks: "Show me projects with their team cost and compare with company avg"

WITH ProjectTeam AS (
    -- Which employees are in Engineering (working on eng projects)
    SELECT employee_id, employee_name, salary
    FROM Employees
    WHERE department = 'Engineering' AND is_active = 1
),
TeamCostSummary AS (
    -- Total cost of engineering team
    SELECT
        SUM(salary)  AS total_team_cost,
        AVG(salary)  AS avg_team_salary,
        COUNT(*)     AS team_size
    FROM ProjectTeam
),
CompanyAvg AS (
    -- Company-wide average
    SELECT AVG(salary) AS company_avg_salary
    FROM Employees
    WHERE is_active = 1
)
-- Final result combining all CTEs
SELECT
    pt.employee_name,
    pt.salary,
    tcs.total_team_cost,
    tcs.avg_team_salary,
    ca.company_avg_salary,
    CASE
        WHEN pt.salary > ca.company_avg_salary THEN 'Paid Above Company Avg'
        ELSE 'Paid Below Company Avg'
    END AS salary_vs_company
FROM ProjectTeam pt
CROSS JOIN TeamCostSummary tcs
CROSS JOIN CompanyAvg ca;

-- RECURSIVE CTE - Real use: Employee Reporting Hierarchy
-- Example: Who reports to whom in the org

-- Lets imagine a manager table
CREATE TABLE EmployeeHierarchy (
    emp_id      INT PRIMARY KEY,
    emp_name    VARCHAR(100),
    manager_id  INT NULL    -- NULL means this is the TOP (CEO)
);

INSERT INTO EmployeeHierarchy VALUES (1, 'CEO Arjun',       NULL);
INSERT INTO EmployeeHierarchy VALUES (2, 'CTO Kiran',       1);
INSERT INTO EmployeeHierarchy VALUES (3, 'VP Eng Meena',    2);
INSERT INTO EmployeeHierarchy VALUES (4, 'Tech Lead Karan', 3);
INSERT INTO EmployeeHierarchy VALUES (5, 'Dev Ravi',        4);
INSERT INTO EmployeeHierarchy VALUES (6, 'Dev Priya',       4);

-- Recursive CTE: Show full reporting chain
WITH OrgChart AS (
    -- Base case: Start from the top (CEO)
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS level,
        CAST(emp_name AS VARCHAR(500)) AS reporting_path
    FROM EmployeeHierarchy
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive case: Find employees under each manager
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        oc.level + 1,
        CAST(oc.reporting_path + ' → ' + e.emp_name AS VARCHAR(500))
    FROM EmployeeHierarchy e
    JOIN OrgChart oc ON e.manager_id = oc.emp_id
)
SELECT
    REPLICATE('  ', level) + emp_name AS org_tree,   -- indent by level
    level AS org_level,
    reporting_path
FROM OrgChart
ORDER BY reporting_path;

-- KEY POINTS ABOUT CTE:
-- + Makes complex queries VERY readable and clean
-- + Can define multiple CTEs in one WITH block
-- + Supports RECURSIVE queries (hierarchy, tree structures)
-- + No physical storage - lives only during query execution
-- - Cannot be reused in a LATER query (only in the same query)
-- - For very large datasets, Temp Tables can be faster

-- ============================================================
-- PART 4: VIEWS
-- ============================================================

-- WHAT IS IT?
-- A View is a SAVED query that looks and behaves like a table.
-- It is PERMANENT (saved in the database), but stores NO DATA.
-- Every time you query a view, it runs the underlying query fresh.
-- Think of it as a "shortcut" or "window" into your data.

-- WHEN TO USE IT?
-- Use Views when:
--   1. You want to HIDE complexity from business users or front-end apps
--   2. You want to RESTRICT access (security - show only certain columns)
--   3. The same complex query is needed by MANY different queries/teams
--   4. You want to give a simplified "face" to your messy table structure
--   5. Reporting tools (Power BI, Tableau) need a clean data source

-- REAL SITUATION IN TECHCORP:
-- Problem 1: Business Analysts keep writing the same 20-line query.
-- Problem 2: Front-end API should NOT show salary to all users.
-- Problem 3: Power BI team needs a clean employee summary table.
-- Solution: Create Views!

-- View 1: Employee Summary (for HR dashboard)
CREATE VIEW vw_EmployeeSummary AS
SELECT
    e.employee_id,
    e.employee_name,
    e.department,
    e.designation,
    e.joining_date,
    DATEDIFF(YEAR, e.joining_date, GETDATE()) AS years_in_company,
    CASE
        WHEN DATEDIFF(YEAR, e.joining_date, GETDATE()) >= 5 THEN 'Senior'
        WHEN DATEDIFF(YEAR, e.joining_date, GETDATE()) >= 2 THEN 'Mid-Level'
        ELSE 'Junior'
    END AS experience_band
FROM Employees e
WHERE e.is_active = 1;
-- Notice: NO SALARY column here! HR doesn't want salary visible to all.

-- Now anyone can just use this like a table:
SELECT * FROM vw_EmployeeSummary WHERE department = 'Engineering';

-- View 2: Department Cost View (for Finance team)
CREATE VIEW vw_DepartmentCostReport AS
SELECT
    department,
    COUNT(*)        AS total_employees,
    SUM(salary)     AS total_salary_cost,
    AVG(salary)     AS avg_salary,
    MIN(salary)     AS min_salary,
    MAX(salary)     AS max_salary
FROM Employees
WHERE is_active = 1
GROUP BY department;

-- Finance team can now simply run:
SELECT * FROM vw_DepartmentCostReport ORDER BY total_salary_cost DESC;

-- View 3: Project Status View (for Project Manager dashboard)
CREATE VIEW vw_ActiveProjectSummary AS
SELECT
    p.project_name,
    d.department_name,
    p.start_date,
    p.end_date,
    p.status,
    DATEDIFF(DAY, GETDATE(), p.end_date) AS days_remaining,
    CASE
        WHEN DATEDIFF(DAY, GETDATE(), p.end_date) < 0  THEN 'Overdue'
        WHEN DATEDIFF(DAY, GETDATE(), p.end_date) < 30 THEN 'Deadline Soon'
        ELSE 'On Track'
    END AS project_health
FROM Projects p
JOIN Departments d ON p.department_id = d.department_id
WHERE p.status = 'Active';

-- Project Managers just query:
SELECT * FROM vw_ActiveProjectSummary WHERE project_health = 'Deadline Soon';

-- KEY POINTS ABOUT VIEWS:
-- + PERMANENT - saved in database, available always
-- + Acts like a table - easy for non-SQL experts to use
-- + Great for SECURITY - hide sensitive columns (like salary)
-- + Single source of truth - one definition, used everywhere
-- + Used by Power BI, Tableau, and other BI tools easily
-- - Does NOT store data - re-runs query every time (can be slow on big tables)
-- - Cannot use ORDER BY inside a view directly
-- - For performance-heavy views, use Indexed Views (advanced topic)

-- ============================================================
-- PART 5: SIDE BY SIDE COMPARISON
-- ============================================================

/*
=======================================================================
| FEATURE          | NORMAL TABLE | TEMP TABLE | CTE        | VIEW    |
=======================================================================
| Stores Data?     | YES          | YES        | NO         | NO      |
| How long lives?  | FOREVER      | This session| This query | FOREVER |
| Who can see?     | Everyone     | Only you   | Only you   | Everyone|
| Survives restart?| YES          | NO         | NO         | YES*    |
| Can add INDEX?   | YES          | YES        | NO         | NO**    |
| Recursive?       | NO           | NO         | YES        | NO      |
| Created with?    | CREATE TABLE | CREATE TABLE #| WITH    | CREATE VIEW|
| Syntax example   | CREATE TABLE | CREATE TABLE #temp| WITH cte AS| CREATE VIEW|
=======================================================================
* View definition survives, but underlying data depends on base tables
** Indexed Views exist but are an advanced/special case
*/

-- ============================================================
-- PART 6: REAL TEAM SCENARIO - WHO USES WHAT AND WHY
-- ============================================================

-- SCENARIO: Monthly Payroll Processing Day at TechCorp
-- Different team members use different tools for their tasks.

-- ------------------------------------
-- TASK 1: HR Admin - "Store new joiner data" → NORMAL TABLE
-- ------------------------------------
INSERT INTO Employees VALUES (9, 'Naveen Raj', 'Engineering', 'Junior Dev', '2024-10-01', 52000, 1);
-- Normal table because this record must be permanent!

-- ------------------------------------
-- TASK 2: Finance - "Calculate this month's payroll" → TEMP TABLE
-- ------------------------------------
-- Long multi-step batch job - use temp table for intermediate results
CREATE TABLE #MonthlyPayroll (
    employee_id     INT,
    employee_name   VARCHAR(100),
    gross_salary    DECIMAL(10,2),
    pf_deduction    DECIMAL(10,2),
    tax_deduction   DECIMAL(10,2),
    net_salary      DECIMAL(10,2)
);

INSERT INTO #MonthlyPayroll (employee_id, employee_name, gross_salary)
SELECT employee_id, employee_name, salary FROM Employees WHERE is_active = 1;

UPDATE #MonthlyPayroll SET pf_deduction = gross_salary * 0.12;
UPDATE #MonthlyPayroll SET tax_deduction = gross_salary * 0.10;
UPDATE #MonthlyPayroll SET net_salary = gross_salary - pf_deduction - tax_deduction;

SELECT * FROM #MonthlyPayroll ORDER BY net_salary DESC;
DROP TABLE IF EXISTS #MonthlyPayroll;

-- ------------------------------------
-- TASK 3: Data Analyst - "Quick analysis for manager meeting" → CTE
-- ------------------------------------
-- One-time complex query, want clean readable code
WITH TopEarners AS (
    SELECT TOP 3 employee_name, department, salary
    FROM Employees
    WHERE is_active = 1
    ORDER BY salary DESC
),
DeptAvg AS (
    SELECT department, AVG(salary) AS avg_sal
    FROM Employees WHERE is_active = 1
    GROUP BY department
)
SELECT
    t.employee_name,
    t.department,
    t.salary,
    d.avg_sal AS dept_avg,
    t.salary - d.avg_sal AS above_dept_avg_by
FROM TopEarners t
JOIN DeptAvg d ON t.department = d.department;

-- ------------------------------------
-- TASK 4: Power BI / Dashboard Team - "Build reports" → VIEW
-- ------------------------------------
-- They just connect Power BI to these views and drag-drop!
SELECT * FROM vw_EmployeeSummary;
SELECT * FROM vw_DepartmentCostReport;
SELECT * FROM vw_ActiveProjectSummary;

-- ============================================================
-- PART 7: GOLDEN RULES - WHEN TO USE WHAT
-- ============================================================

/*
RULE 1: Use NORMAL TABLE when...
  ✓ Data must live permanently (employee, customer, order records)
  ✓ Multiple users/apps need to read/write the data
  ✓ You need foreign keys, indexes, constraints
  ✓ Data must survive server restarts

RULE 2: Use TEMP TABLE when...
  ✓ You are writing a multi-step batch job or ETL process
  ✓ You need to process data in stages (calculate, update, join)
  ✓ You want to avoid running the same subquery multiple times
  ✓ The data is only needed for THIS session (auto-cleanup = good)
  ✓ You want to add index on the intermediate result for faster joins

RULE 3: Use CTE when...
  ✓ Your SQL query is getting complex and nested
  ✓ You want to break your logic into clean readable steps
  ✓ You need a recursive query (org hierarchy, parent-child)
  ✓ The intermediate result is only needed ONCE within the same query
  ✓ You want clean code - CTEs make code like reading English

RULE 4: Use VIEW when...
  ✓ The same complex query is used by many people/teams/reports
  ✓ You want to hide sensitive columns (salary, personal data)
  ✓ Business users or BI tools need a simple "table-like" source
  ✓ You want ONE definition that all queries/dashboards use
  ✓ You want to simplify your complex 10-table JOIN into one name
*/

-- ============================================================
-- QUICK MEMORY TRICK
-- ============================================================

/*
Think of it like this:

  NORMAL TABLE  = Your permanent house            (lives forever, everyone visits)
  TEMP TABLE    = A hotel room                    (yours only, auto-checkout when done)
  CTE           = A sticky note while working     (use it now, gone when done)
  VIEW          = A window into your house        (permanent frame, shows live view inside)

At TechCorp:
  → Employee records?         → Normal Table    (permanent, shared)
  → Monthly payroll script?   → Temp Table      (batch job, session only)
  → Complex one-time report?  → CTE             (clean code, single query)
  → Power BI dashboard feed?  → View            (permanent, reusable, safe)
*/

-- ============================================================
-- END OF FILE
-- Now you know exactly which tool to use in every situation!
-- ============================================================