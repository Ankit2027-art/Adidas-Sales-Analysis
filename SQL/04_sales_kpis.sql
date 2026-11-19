USE adidas_sales_db;

-- Step 1: Calculate Total Sales
USE adidas_sales_db;

-- Step 1: Calculate Total Sales
SELECT
    SUM(Price_per_Unit * Units_Sold) AS Total_sales
FROM adidas_sales;

-- Step 2: Calculate Total Units Sold
SELECT
    SUM(Units_sold) AS Total_units_sold
FROM adidas_sales;

-- Step 3: Calculate Total Operating Profit
SELECT
    SUM(Operating_Profit) AS Total_operating_profit
FROM adidas_sales;

-- Step 4: Calculate Average Operating Margin
SELECT
    ROUND(AVG(Operating_Margin) * 100, 2) AS average_operating_margin_percent
FROM adidas_sales;

-- Step 5: Count Total Orders
SELECT
    COUNT(DISTINCT Invoice_Date) AS total_orders
FROM adidas_sales;
-- Count Unique Retailers
SELECT
    COUNT(DISTINCT Retailer) AS total_retailers
FROM adidas_sales;

-- Step 6: Count Unique Products
SELECT
    COUNT(DISTINCT Product) AS total_products
FROM adidas_sales;

-- Step 7: Calculate Average Price per Unit
SELECT
    ROUND(AVG(Price_per_Unit),2) AS average_price_per_unit
FROM adidas_sales;

-- Step 8: Calculate Average Units Sold per Record
SELECT
    ROUND(AVG(Units_sold), 2) AS average_units_sold
FROM adidas_sales;

-- Step 9: Calculate Sales by Sales Method
SELECT
    Sales_Method,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_sales
FROM adidas_sales
GROUP BY Sales_Method
order by total_sales DESC;

-- Step 10: Calculate Total Sales by Region
SELECT
     Region,
     ROUND(SUM(Price_per_unit * Units_Sold),2)AS total_sales
FROM adidas_sales
GROUP BY Region
ORDER BY total_sales DESC;

-- Step 11: Calculate Total Sales by Product
SELECT
	Product,
    ROUND(SUM(Price_per_unit * Units_Sold),2) AS total_sales
FROM adidas_sales
GROUP BY Product
ORDER BY total_sales DESC;

-- Step 12: Calculate Total Sales by Retailer
SELECT
    Retailer,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_sales
FROM adidas_sales
GROUP BY Retailer
ORDER BY total_sales DESC;

-- Step 13: Calculate Sales by Region and Product
SELECT
    Region,
    Product,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_sales
FROM adidas_sales
GROUP BY Region, Product
ORDER BY Region, total_sales DESC;

-- Step 14: Calculate Total Sales by State
SELECT
    State,
    ROUND(SUM(Price_per_Unit * Units_sold),2) total_sales
FROM adidas_sales
GROUP BY State
ORDER BY total_sales DESC;

-- Step 15: Calculate Total Sales by Year
SELECT
    YEAR(Invoice_Date) As Sales_year,
    ROUND(SUM(Price_per_Unit * Units_Sold),2) AS total_sales
FROM adidas_sales
GROUP BY Sales_year
ORDER BY total_sales DESC;