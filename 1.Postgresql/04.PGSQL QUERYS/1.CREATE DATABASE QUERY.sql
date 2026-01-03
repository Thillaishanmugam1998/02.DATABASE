-------------------------------
--1. CREATE DATABASE SCRIPT:
-------------------------------
CREATE DATABASE "DATABASE NAME"
	WITH
	OWNER = postgres
	ENCODING = 'UTF8'
	TABLESPACE = "PGSQOL_LEARN"
	CONNECTION LIMIT = -1

COMMENT ON DATABASE "DATABASE NAME"
	IS 'DATABASE PURPOSE OF COMMEND..' 

-------------------	
--2. DROP DATABASE:
-------------------
DROP DATABASE IF EXISTS "DATABASE NAME"
--------------------------------------------------------------------------------------------------

