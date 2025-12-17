/*==========================================================
    DATABASE CREATION
    Syntax: CREATE DATABASE <DatabaseName>
==========================================================*/
CREATE DATABASE TestDB;
GO


/*==========================================================
    RENAME DATABASE
    Method 1: ALTER DATABASE (Recommended)
    Syntax: ALTER DATABASE <OldName> MODIFY NAME = <NewName>
==========================================================*/
ALTER DATABASE TestDB MODIFY NAME = TestDatabase;
GO


/*==========================================================
    RENAME DATABASE (Alternative Method)
    Using predefined stored procedure: sp_renamedb
    Syntax: EXEC sp_renamedb '<OldName>', '<NewName>'
==========================================================*/
EXEC sp_renamedb 'TestDB', 'TestDatabase';
GO


/*==========================================================
    IMPORTANT NOTE
    While renaming or dropping a database, SQL Server may
    block the operation if the MDF/LDF files are in use.
    To forcefully disconnect users:
    
    Set database to SINGLE_USER with ROLLBACK IMMEDIATE
==========================================================*/

/* Put Database into SINGLE_USER Mode */
ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO


/*==========================================================
    DROP DATABASE
    Syntax: DROP DATABASE <DatabaseName>
==========================================================*/
DROP DATABASE TestDB;
GO


/*==========================================================
    After renaming a DB, set it back to MULTI_USER mode
    Syntax: ALTER DATABASE <DatabaseName> SET MULTI_USER
==========================================================*/
ALTER DATABASE TestDatabase SET MULTI_USER;
GO


--Use Database Syntax: USE <DATA BASE NAME>
--Example
use TestDatabase;