/*==========================================================
    SQL SERVER BASIC DATABASE NOTES
    For Beginners (YouTube Class Friendly)

    File Type   : .sql
    Purpose     : Learn What is Database + Why we need it
                  + Types of Databases
                  + Basic Database Commands

==========================================================*/


/*==========================================================
    WHAT IS A DATABASE?
==========================================================*/
/*
    A Database is a place where data is stored
    in an organized and secure way.

    Example (Real Life):
    --------------------
    - School stores student details
    - Bank stores customer & transaction details
    - YouTube stores videos, likes, comments
    - WhatsApp stores messages and contacts

    All this data is stored inside DATABASES.
*/


/*==========================================================
    WHY DO WE NEED A DATABASE?
==========================================================*/
/*
    Without a database:
    -------------------
    - Data will be lost
    - No security
    - Hard to search
    - Cannot handle large data

    With a database:
    ----------------
    - Data is safe and secure
    - Fast searching
    - Multiple users can access data
    - Easy backup and recovery
*/


/*==========================================================
    TYPES OF DATABASES (WITH REAL-TIME EXAMPLES)
==========================================================*/
/*
    1. Relational Database (RDBMS)
       ----------------------------
       - Data stored in tables (rows & columns)
       - Uses SQL language

       Examples:
       - SQL Server
       - MySQL
       - Oracle

       Real-Time Use:
       - Banking systems
       - School management
       - Employee records


    2. NoSQL Database
       ----------------
       - Data not stored in table format
       - Used for big data & fast applications

       Examples:
       - MongoDB
       - Cassandra

       Real-Time Use:
       - Facebook
       - Instagram
       - Amazon


    3. Cloud Database
       ----------------
       - Database stored on cloud (internet)

       Examples:
       - Azure SQL Database
       - Amazon RDS

       Real-Time Use:
       - Online apps
       - Web applications


    4. In-Memory Database
       -------------------
       - Data stored in RAM (very fast)

       Example:
       - Redis

       Real-Time Use:
       - Live chat apps
       - Gaming applications
*/


/*==========================================================
    DATABASE CREATION
    Syntax: CREATE DATABASE <DatabaseName>
==========================================================*/
CREATE DATABASE TestDB;
GO


/*==========================================================
    RENAME DATABASE
    Method 1 (Recommended):
    ALTER DATABASE
==========================================================*/
/*
    We are renaming database:
    Old Name : TestDB
    New Name : TestDatabase
*/
ALTER DATABASE TestDB MODIFY NAME = TestDatabase;
GO


/*==========================================================
    RENAME DATABASE
    Method 2 (Old Method):
    sp_renamedb (Stored Procedure)
==========================================================*/
/*
    This method still works but NOT recommended
    for new projects.
*/
EXEC sp_renamedb 'TestDatabase', 'TestDB';
GO


/*==========================================================
    IMPORTANT NOTE ABOUT DATABASE LOCKING
==========================================================*/
/*
    SQL Server will NOT allow rename or delete
    if users are connected to the database.

    Solution:
    ----------
    Set database to SINGLE_USER mode.
    This disconnects all users immediately.
*/


/*==========================================================
    SET DATABASE TO SINGLE_USER MODE
==========================================================*/
ALTER DATABASE TestDB
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO


/*==========================================================
    DROP DATABASE
    (Delete Database Completely)
==========================================================*/
/*
    WARNING:
    --------
    This command permanently deletes the database.
*/
DROP DATABASE TestDB;
GO


/*==========================================================
    SET DATABASE BACK TO MULTI_USER MODE
==========================================================*/
/*
    After rename or maintenance,
    allow multiple users again.
*/
ALTER DATABASE TestDatabase
SET MULTI_USER;
GO


/*==========================================================
    USE DATABASE
==========================================================*/
/*
    This command tells SQL Server
    which database you want to work with.
*/
USE TestDatabase;
GO
