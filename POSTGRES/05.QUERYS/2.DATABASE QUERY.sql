1. Database Management Commands
-------------------------------
1.1 Create a Database
	
	>	CREATE DATABASE database_name;

1.2 Delete (Drop) a Database

	>	DROP DATABASE database_name;

1.3 Alter a Database
--You can alter various properties of a database, such as renaming it or changing its owner.

Rename a Database:
	>	ALTER DATABASE old_database_name RENAME TO new_database_name;
Change the Owner of a Database:
	>	ALTER DATABSE old_database_owner OWNER TO new_database_owner;