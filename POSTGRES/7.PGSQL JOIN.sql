--JOIN EXAMLE:
---------------
--CREATE TABLE QUERY:
CREATE TABLE basket_a(
	a INT PRIMARY KEY,
	fruit_a VARCHAR(100) NOT NULL
);
CREATE TABLE basket_b(
	b INT PRIMARY KEY,
	fruit_b VARCHAR(100) NOT NULL
);

--SELECT QUERY:
SELECT * FROM basket_a;
SELECT * FROM basket_b;


--INSERT QUERY:
INSERT INTO basket_a(a,fruit_a)
VALUES
	(1,'Apple'),
	(2,'Orange'),
	(3,'Banana'),
	(4,'Cucumber');

INSERT INTO basket_b(b,fruit_b)
VALUES
	(1,'Orange'),
	(2,'Apple'),
	(3,'Watermelon'),
	(4,'Pear');


--INNER JOIN
SELECT a,fruit_a,b,fruit_b
FROM basket_a
INNER JOIN basket_b
ON fruit_a = fruit_b

SELECT a,fruit_a,b,fruit_b
FROM basket_b
INNER JOIN basket_a
ON fruit_b = fruit_a

SELECT a,fruit_a,b,fruit_b
FROM basket_b
INNER JOIN basket_a
ON fruit_b = fruit_a
	WHERE fruit_a = 'Apple'
ORDER BY a

	SELECT a,fruit_a,b,fruit_b
FROM basket_b
INNER JOIN basket_a
ON fruit_b = fruit_a
	WHERE fruit_a IN ('Orange','Apple')
ORDER BY a asc
	
	
SELECT 
    basket_a.a AS basket_a_id,
    basket_a.fruit_a,
    basket_b.b AS basket_b_id,
    basket_b.fruit_b
FROM 
    basket_a
INNER JOIN 
    basket_b
ON 
    basket_a.a = basket_b.b


--LEFT JOIN
SELECT a,fruit_a,b,fruit_b
FROM basket_a
LEFT JOIN basket_b
ON fruit_a = fruit_b

SELECT a,fruit_a,b,fruit_b
FROM basket_b
LEFT JOIN basket_a
ON fruit_a = fruit_b

SELECT a,fruit_a,b,fruit_b
FROM basket_b
LEFT JOIN basket_a
ON a = b

--COALESCE
SELECT a,fruit_a, b, COALESCE(fruit_b,'No Match')
FROM basket_a
LEFT JOIN basket_b
ON fruit_a = fruit_b


--RIGHT JOIN
SELECT a,fruit_a,b,fruit_b
FROM basket_a
RIGHT JOIN basket_b
ON fruit_a = fruit_b

--MERGE TWO COLOUMN INTO ONE
SELECT * FROM basket_a

SELECT  a || '-' ||fruit_a  AS ID_FRUIT FROM basket_a
