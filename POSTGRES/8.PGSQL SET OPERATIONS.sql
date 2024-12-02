Section 5. Set Operations
Union – combine result sets of multiple queries into a single result set.
Intersect – combine the result sets of two or more queries and return a single result set containing rows that appear in both result sets.
Except – return the rows from the first query that do not appear in the output of the second query.
----------------------------------------------------------------------------------------------------------------
--01.UNION EXAMPLE:

CREATE TABLE top_rated_films(
title VARCHAR NOT NULL,
release_year SMALLINT
);

CREATE TABLE most_popular_films(
title VARCHAR NOT NULL,
release_year SMALLINT
);

DROP TABLE top_rated_films
	
INSERT INTO top_rated_films(title,release_year)
	VALUES 
	('Dear',2023),
	('Thangalayan',2023),
	('Rayan',2024),
	('D.colony',2024)

 INSERT INTO most_popular_films(title,release_year)
	VALUES 
	('Amaran',2024),
	('Rayan',2024),
	('Valimai',2024),
	('Thunivu',2024)


SELECT * FROM top_rated_films
SELECT * FROM most_popular_films

	
SELECT * FROM top_rated_films
UNION
SELECT * FROM most_popular_films


SELECT * FROM top_rated_films
UNION ALL
SELECT * FROM most_popular_films
ORDER BY title
***********************************************************************************************************
--Summary
Use the UNION to combine result sets of two queries and return distinct rows.
Use the UNION ALL to combine the result sets of two queries but retain the duplicate rows.
***********************************************************************************************************

02.INTERSECT EXAMPLE:

SELECT * FROM top_rated_films
INTERSECT
SELECT * FROM most_popular_films
ORDER BY title

***********************************************************************************************************
--Summary
Use the PostgreSQL INTERSECT operator to combine two result sets and return a single result set containing rows appearing in both.
Place the ORDER BY clause after the second query to sort the rows in the result set returned by the INTERSECT operator.
***********************************************************************************************************

--03. EXCEPT EXAMPLE:

SELECT * FROM top_rated_films
EXCEPT
SELECT * FROM most_popular_films
ORDER BY title

SELECT * FROM most_popular_films
EXCEPT
SELECT * FROM top_rated_films
ORDER BY title