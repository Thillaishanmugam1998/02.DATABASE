/*========================================================
 FILE NAME : IN_BETWEEN_LIKE_ALL_ANY_EXISTS.sql
 TOPIC     :
   - IN Operator
   - BETWEEN Operator
   - LIKE Operator
   - ALL Operator
   - ANY Operator
   - SOME Operator
   - EXISTS Operator
 DB        : SQL Server
 PURPOSE   :
   - Learn filtering operators
   - Understand subquery-based operators
   - Prepare for interviews with examples
========================================================*/


/*========================================================
 1) SAMPLE TABLE SETUP
========================================================*/

DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
GO

CREATE TABLE Departments
(
    DeptId   INT,
    DeptName NVARCHAR(20)
);
GO

CREATE TABLE Employees
(
    EmpId   INT,
    EmpName NVARCHAR(50),
    Salary  INT,
    DeptId  INT,
    City    NVARCHAR(20)
);
GO

INSERT INTO Departments VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Admin');
GO

INSERT INTO Employees VALUES
(1, 'Arun',   30000, 1, 'Chennai'),
(2, 'Bala',   18000, 2, 'Madurai'),
(3, 'Charan', 25000, 1, 'Chennai'),
(4, 'Deepak', 15000, 3, 'Trichy'),
(5, 'Ezhil',  22000, 2, 'Chennai');
GO


/*========================================================
 2) IN OPERATOR
========================================================*/
/*
 IN is used to match multiple values
 Alternative to multiple OR conditions
*/

SELECT *
FROM Employees
WHERE DeptId IN (1, 2);
GO

/*
 Equivalent to:
 DeptId = 1 OR DeptId = 2
*/


/*========================================================
 3) BETWEEN OPERATOR
========================================================*/
/*
 BETWEEN is inclusive (includes start and end)
*/

SELECT *
FROM Employees
WHERE Salary BETWEEN 20000 AND 30000;
GO

/*
 Includes:
 Salary = 20000
 Salary = 30000
*/


/*========================================================
 4) LIKE OPERATOR
========================================================*/
/*
 Used for pattern matching
 %  → any number of characters
 _  → exactly one character
*/

-- Names starting with 'A'
SELECT *
FROM Employees
WHERE EmpName LIKE 'A%';
GO

-- Names ending with 'n'
SELECT *
FROM Employees
WHERE EmpName LIKE '%n';
GO

-- Names with exactly 5 characters
SELECT *
FROM Employees
WHERE EmpName LIKE '_____';
GO


/*========================================================
 5) ALL OPERATOR
========================================================*/
/*
 ALL compares a value with ALL values returned
 by a subquery
*/

-- Employees earning more than ALL HR salaries
SELECT *
FROM Employees
WHERE Salary > ALL
(
    SELECT Salary
    FROM Employees
    WHERE DeptId = 2
);
GO

/*
 Meaning:
 Salary > every salary in HR department
*/


/*========================================================
 6) ANY OPERATOR
========================================================*/
/*
 ANY compares a value with ANY ONE value
 returned by a subquery
*/

-- Employees earning more than ANY HR salary
SELECT *
FROM Employees
WHERE Salary > ANY
(
    SELECT Salary
    FROM Employees
    WHERE DeptId = 2
);
GO

/*
 Meaning:
 Salary > at least one HR salary
*/


/*========================================================
 7) SOME OPERATOR
========================================================*/
/*
 SOME is exactly same as ANY in SQL Server
*/

SELECT *
FROM Employees
WHERE Salary > SOME
(
    SELECT Salary
    FROM Employees
    WHERE DeptId = 2
);
GO

/*
 NOTE:
 SOME = ANY (no difference)
*/


/*========================================================
 8) EXISTS OPERATOR
========================================================*/
/*
 EXISTS checks whether subquery returns rows
 Returns TRUE or FALSE
 Stops checking after first match (fast)
*/

-- Employees whose department exists
SELECT *
FROM Employees E
WHERE EXISTS
(
    SELECT 1
    FROM Departments D
    WHERE D.DeptId = E.DeptId
);
GO


/*========================================================
 9) NOT EXISTS EXAMPLE
========================================================*/

-- Employees without a valid department
SELECT *
FROM Employees E
WHERE NOT EXISTS
(
    SELECT 1
    FROM Departments D
    WHERE D.DeptId = E.DeptId
);
GO


/*========================================================
 10) INTERVIEW COMPARISON SUMMARY
========================================================*/

-- IN       → Match multiple values
-- BETWEEN  → Range filtering (inclusive)
-- LIKE     → Pattern matching
-- ALL      → Compare with all values in subquery
-- ANY      → Compare with any one value
-- SOME     → Same as ANY
-- EXISTS   → Checks existence (returns TRUE/FALSE)


/*========================================================
 11) PERFORMANCE NOTES (INTERVIEW GOLD)
========================================================*/

-- EXISTS is usually faster than IN for large datasets
-- BETWEEN is inclusive (common interview trap)
-- SOME and ANY are identical in SQL Server
-- ALL fails if subquery returns NULL (important)


/*========================================================
 END OF FILE
========================================================*/
