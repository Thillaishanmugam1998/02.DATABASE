select * from sales

--1. Category-wise total sales amount (எந்த பொருள் வகையில் எவ்வளவு வியாபாரம்?)

SELECT 
    Category,
    COUNT(*) AS NumberOfSales,
    SUM(Amount) AS TotalAmount,
    AVG(Amount) AS AvgSaleAmount
FROM Sales
GROUP BY Category;


--2. Region-wise sales performance (பகுதி வாரியாக எவ்வளவு விற்பனை?)
SELECT 
    Region,
    SUM(Amount) AS TotalRevenue,
    SUM(Quantity) AS TotalUnitsSold,
    COUNT(*) AS NumberOfTransactions
FROM Sales
GROUP BY Region
ORDER BY TotalRevenue DESC;

--3.Customer Type மற்றும் Category wise (புது / பழைய வாடிக்கையாளர்கள் எந்த பொருள் வகையில் எவ்வளவு செலவு செய்தாங்க?)
SELECT 
    CustomerType,
    Category,
    SUM(Amount) AS TotalSpent,
    COUNT(*) AS Purchases
FROM Sales
GROUP BY CustomerType, Category
ORDER BY CustomerType, TotalSpent DESC;

--4.Month-wise sales trend (ஒவ்வொரு மாதமும் எவ்வளவு வியாபாரம்?)
select month(saleDate),count(saledate),sum(amount),avg(amount)
from sales 
group by month(saleDate)

