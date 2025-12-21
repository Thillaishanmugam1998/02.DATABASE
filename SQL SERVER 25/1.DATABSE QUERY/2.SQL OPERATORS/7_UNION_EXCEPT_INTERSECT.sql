/*========================================================
 FILE NAME : UNION_EXCEPT_INTERSECT.sql
 TOPIC     :
   - UNION
   - UNION ALL
   - EXCEPT
   - INTERSECT
 DB        : SQL Server
 PURPOSE   :
   - Combine result sets
   - Understand set-based operators
   - Learn differences, rules, and performance
   - Prepare for interview questions
========================================================*/


/*========================================================
 1) SAMPLE TABLE SETUP
========================================================*/

DROP TABLE IF EXISTS IT_Employees;
DROP TABLE IF EXISTS HR_Employees;
GO

CREATE TABLE IT_Employees
(
    EmpId   INT,
    EmpName NVARCHAR(50)
);
GO

CREATE TABLE HR_Employees
(
    EmpId   INT,
    EmpName NVARCHAR(50)
);
GO

INSERT INTO IT_Employees VALUES
(1, 'Arun'),
(2, 'Bala'),
(3, 'Charan'),
(4, 'Deepak');
GO

INSERT INTO HR_Employees VALUES
(3, 'Charan'),
(4, 'Deepak'),
(5, 'Ezhil'),
(6, 'Farooq');
GO


/*========================================================
 VIEW DATA
========================================================*/
SELECT * FROM IT_Employees;
SELECT * FROM HR_Employees;
GO


/*========================================================
 IMPORTANT RULES FOR SET OPERATORS
========================================================*/
/*
 1) Number of columns must be SAME
 2) Data types must be COMPATIBLE
 3) Column order must be SAME
 4) ORDER BY allowed only at the END
*/


/*========================================================
 2) UNION OPERATOR
========================================================*/
/*
 UNION:
 - Combines result sets
 - Removes duplicate rows
 - Uses DISTINCT internally
*/

SELECT EmpId, EmpName
FROM IT_Employees

UNION

SELECT EmpId, EmpName
FROM HR_Employees;
GO

/*
 RESULT:
 - All unique employees from both tables
 - Duplicate rows removed
*/


/*========================================================
 3) UNION ALL OPERATOR
========================================================*/
/*
 UNION ALL:
 - Combines result sets
 - DOES NOT remove duplicates
 - Faster than UNION
*/

SELECT EmpId, EmpName
FROM IT_Employees

UNION ALL

SELECT EmpId, EmpName
FROM HR_Employees;
GO

/*
 RESULT:
 - All rows from both tables
 - Duplicate rows included
*/


/*========================================================
 4) UNION vs UNION ALL (INTERVIEW FAVORITE)
========================================================*/
/*
 UNION      → Removes duplicates (slower)
 UNION ALL  → Keeps duplicates (faster)

 Best Practice:
 Use UNION ALL when duplicates are acceptable
*/


/*========================================================
 5) EXCEPT OPERATOR
========================================================*/
/*
 EXCEPT:
 - Returns rows from first query
 - That are NOT present in second query
 - Removes duplicates
*/

SELECT EmpId, EmpName
FROM IT_Employees

EXCEPT

SELECT EmpId, EmpName
FROM HR_Employees;
GO

/*
 RESULT:
 - Employees only in IT
 - Common employees removed
*/


/*========================================================
 6) EXCEPT (REVERSE ORDER)
========================================================*/

SELECT EmpId, EmpName
FROM HR_Employees

EXCEPT

SELECT EmpId, EmpName
FROM IT_Employees;
GO

/*
 RESULT:
 - Employees only in HR
*/


/*========================================================
 7) INTERSECT OPERATOR
========================================================*/
/*
 INTERSECT:
 - Returns only COMMON rows
 - Removes duplicates
*/

SELECT EmpId, EmpName
FROM IT_Employees

INTERSECT

SELECT EmpId, EmpName
FROM HR_Employees;
GO

/*
 RESULT:
 - Employees present in BOTH tables
*/


/*========================================================
 8) REAL-TIME USE CASES
========================================================*/
/*
 UNION ALL   → Log tables, history tables
 UNION       → Master reports
 EXCEPT      → Mismatch / audit reports
 INTERSECT   → Common users, permissions
*/


/*========================================================
 9) PERFORMANCE NOTES (INTERVIEW GOLD)
========================================================*/

-- UNION uses DISTINCT → slower
-- UNION ALL is fastest
-- EXCEPT and INTERSECT remove duplicates
-- Indexes improve performance


/*========================================================
 10) QUICK INTERVIEW QUESTIONS
========================================================*/

-- Q1: Which is faster UNION or UNION ALL?
-- A : UNION ALL

-- Q2: Does INTERSECT remove duplicates?
-- A : Yes

-- Q3: Can ORDER BY be used in UNION queries?
-- A : Yes, only at the END


/*========================================================
 11) FINAL SUMMARY
========================================================*/

-- UNION       → Combine + remove duplicates
-- UNION ALL   → Combine + keep duplicates
-- EXCEPT      → First result minus second
-- INTERSECT   → Common rows only


/*========================================================
 END OF FILE
========================================================*/
