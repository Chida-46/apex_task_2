CREATE DATABASE apexplanet_eda;

USE apexplanet_eda;

USE apexplanet_eda;

SHOW TABLES;

SELECT COUNT(*) AS total_rows
FROM sales;

SELECT *
FROM sales
LIMIT 10;

USE apexplanet_eda;

SELECT
    Product,
    SUM(Total_Sales) AS Total_Revenue
FROM sales
GROUP BY Product
ORDER BY Total_Revenue DESC
LIMIT 5;

SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Sales_Month,
    ROUND(SUM(Total_Sales), 2) AS Monthly_Revenue
FROM sales
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Sales_Month;

SELECT
    Category,
    COUNT(*) AS Transaction_Rows,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue
FROM sales
GROUP BY Category
ORDER BY Total_Revenue DESC;
SELECT
    City,
    COUNT(*) AS Transaction_Rows,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue
FROM sales
WHERE City IS NOT NULL
GROUP BY City
ORDER BY Total_Revenue DESC
LIMIT 10;

SELECT
    Gender,
    COUNT(*) AS Transaction_Rows,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue,
    ROUND(AVG(Total_Sales), 2) AS Average_Sale
FROM sales
GROUP BY Gender
ORDER BY Total_Revenue DESC;

SELECT
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        WHEN Age >= 55 THEN '55+'
        ELSE 'Unknown'
    END AS Age_Group,
    COUNT(*) AS Transaction_Rows,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue,
    ROUND(AVG(Total_Sales), 2) AS Average_Sale
FROM sales
GROUP BY Age_Group
ORDER BY Total_Revenue DESC;

SELECT
    Product,
    SUM(Quantity) AS Total_Units_Sold,
    COUNT(*) AS Transaction_Rows,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue
FROM sales
GROUP BY Product
ORDER BY Total_Units_Sold DESC
LIMIT 10;

USE apexplanet_eda;

CREATE TABLE customers AS
SELECT DISTINCT
    Customer_ID,
    Customer_Name,
    Age,
    Gender,
    City
FROM sales;

CREATE TABLE products AS
SELECT DISTINCT
    Product,
    Category,
    Unit_Price
FROM sales;

USE apexplanet_eda;

SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.City,
    p.Product,
    p.Category,
    SUM(s.Quantity) AS Units_Sold,
    ROUND(SUM(s.Total_Sales), 2) AS Total_Revenue
FROM sales s
JOIN customers c
    ON s.Customer_ID = c.Customer_ID
JOIN products p
    ON s.Product = p.Product
GROUP BY
    c.Customer_ID,
    c.Customer_Name,
    c.City,
    p.Product,
    p.Category
ORDER BY Total_Revenue DESC
LIMIT 10;

SELECT
    Customer_ID,
    COUNT(DISTINCT Customer_Name) AS Different_Names
FROM sales
GROUP BY Customer_ID
HAVING COUNT(DISTINCT Customer_Name) > 1;

SELECT
    Product,
    COUNT(DISTINCT Unit_Price) AS Different_Prices
FROM sales
GROUP BY Product
HAVING COUNT(DISTINCT Unit_Price) > 1;

SELECT
    Customer_ID,
    COUNT(DISTINCT Customer_Name) AS Different_Names
FROM sales
GROUP BY Customer_ID
HAVING COUNT(DISTINCT Customer_Name) > 1;

SELECT
    Customer_ID,
    Customer_Name,
    Age,
    Gender,
    City
FROM sales
WHERE Customer_ID IN (
    SELECT Customer_ID
    FROM sales
    GROUP BY Customer_ID
    HAVING COUNT(DISTINCT Customer_Name) > 1
)
ORDER BY Customer_ID, Customer_Name;

DROP TABLE IF EXISTS customers;

CREATE TABLE customers AS
SELECT
    Customer_ID,
    CASE
        WHEN COUNT(DISTINCT Customer_Name) > 1
            THEN CONCAT('Customer_', Customer_ID)
        ELSE MAX(Customer_Name)
    END AS Customer_Name,
    MAX(Age) AS Age,
    MAX(Gender) AS Gender,
    MAX(City) AS City
FROM sales
GROUP BY Customer_ID;

SELECT
    Customer_ID,
    COUNT(*) AS Rows_Per_Customer
FROM customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.City,
    p.Product,
    p.Category,
    SUM(s.Quantity) AS Units_Sold,
    ROUND(SUM(s.Total_Sales), 2) AS Total_Revenue
FROM sales s
JOIN customers c
    ON s.Customer_ID = c.Customer_ID
JOIN products p
    ON s.Product = p.Product
GROUP BY
    c.Customer_ID,
    c.Customer_Name,
    c.City,
    p.Product,
    p.Category
ORDER BY Total_Revenue DESC
LIMIT 10;

SELECT
    ROUND((SELECT SUM(Total_Sales) FROM sales), 2)
        AS Original_Revenue,
    ROUND((
        SELECT SUM(s.Total_Sales)
        FROM sales s
        JOIN customers c
            ON s.Customer_ID = c.Customer_ID
        JOIN products p
            ON s.Product = p.Product
    ), 2) AS Joined_Revenue;
    
SELECT
    Product,
    COUNT(*) AS Rows_Per_Product
FROM products
GROUP BY Product
HAVING COUNT(*) > 1;

DROP TABLE IF EXISTS products;

CREATE TABLE products AS
SELECT
    Product,
    MAX(Category) AS Category,
    MAX(Unit_Price) AS Unit_Price
FROM sales
GROUP BY Product;

SELECT
    ROUND((SELECT SUM(Total_Sales) FROM sales), 2)
        AS Original_Revenue,
    ROUND((
        SELECT SUM(s.Total_Sales)
        FROM sales s
        JOIN customers c
            ON s.Customer_ID = c.Customer_ID
        JOIN products p
            ON s.Product = p.Product
    ), 2) AS Joined_Revenue;
    
SELECT
    ROUND(SUM(Total_Sales), 2) AS Original_Revenue
FROM sales;

SELECT
    ROUND(SUM(s.Total_Sales), 2) AS Joined_Revenue
FROM sales s
JOIN customers c
    ON s.Customer_ID = c.Customer_ID
JOIN products p
    ON s.Product = p.Product;
    
SELECT
    ROUND((SELECT SUM(Total_Sales)
           FROM sales), 2) AS Original_Revenue,
    ROUND((SELECT SUM(s.Total_Sales)
           FROM sales s
           JOIN customers c
             ON s.Customer_ID = c.Customer_ID
           JOIN products p
             ON s.Product = p.Product), 2) AS Joined_Revenue;