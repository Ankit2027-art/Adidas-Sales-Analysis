USE adidas_sales_db;

-- Step 1: Calculate Total Sales by Month
SELECT
    YEAR(Invoice_Date) AS sales_year,
    MONTH(Invoice_Date) AS sales_month,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_sales
FROM adidas_sales
GROUP BY sales_year, sales_month
ORDER BY sales_year, sales_month;

-- Step 2: Calculate Month-over-Month Sales Growth
WITH monthly_sales AS (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        MONTH(Invoice_Date) AS sales_month,
        SUM(Price_per_Unit * Units_Sold) AS total_sales
    FROM adidas_sales
    GROUP BY
        YEAR(Invoice_Date),
        MONTH(Invoice_Date)
),
sales_with_previous_month AS (
    SELECT
        sales_year,
        sales_month,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY sales_year, sales_month
        ) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    sales_year,
    sales_month,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(previous_month_sales, 2) AS previous_month_sales,
    ROUND(
        (total_sales - previous_month_sales)
        / NULLIF(previous_month_sales, 0) * 100,
        2
    ) AS sales_growth_percent
FROM sales_with_previous_month
ORDER BY sales_year, sales_month;

-- Step 3: Identify the Month with the Highest Sales
SELECT
    DATE_FORMAT(Invoice_Date, '%y-%m') AS sales_month,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS Total_sales
FROM adidas_sales
GROUP BY DATE_FORMAT(Invoice_Date,'%y-%m')
ORDER BY total_sales DESC
LIMIT 1;

-- Step 4: Identify the Month with the Lowest Sales
SELECT
    DATE_FORMAT(Invoice_Date, '%Y-%m') AS sales_month,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_sales
FROM adidas_sales
GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
ORDER BY total_sales ASC
LIMIT 1;

-- Step 5: Calculate Average Monthly Sales
SELECT
    ROUND(AVG(monthly_total), 2) AS average_monthly_sales
FROM (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        MONTH(Invoice_Date) AS sales_month,
        SUM(Price_per_Unit * Units_Sold) AS monthly_total
    FROM adidas_sales
    GROUP BY
        YEAR(Invoice_Date),
        MONTH(Invoice_Date)
) AS monthly_sales;

-- Step 6: Calculate Total Units Sold Each Month
SELECT
    DATE_FORMAT(Invoice_Date, '%Y-%m') AS sales_month,
    SUM(Units_Sold) AS total_units_sold
FROM adidas_sales
GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
ORDER BY sales_month;

-- Step 7: Calculate Monthly Operating Profit
SELECT
    DATE_FORMAT(Invoice_Date, '%Y-%m') AS sales_month,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
ORDER BY sales_month;

-- Step 8: Compare Monthly Sales and Operating Profit
SELECT
    DATE_FORMAT(Invoice_Date, '%Y-%m') AS sales_month,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_sales,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
ORDER BY sales_month;

-- Step 9: Calculate Monthly Average Operating Margin
SELECT
    DATE_FORMAT(Invoice_Date, '%Y-%m') AS sales_month,
    ROUND(AVG(Operating_Margin) * 100, 2) AS average_operating_margin_percent
FROM adidas_sales
GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
ORDER BY sales_month;

-- Step 10: Identify the Month with the Highest Units Sold
SELECT
    DATE_FORMAT(Invoice_Date, '%Y-%m') AS sales_month,
    SUM(Units_Sold) AS total_units_sold
FROM adidas_sales
GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
ORDER BY total_units_sold DESC
LIMIT 1;

-- Step 11: Identify the Month with the Highest Operating Profit
SELECT
    DATE_FORMAT(Invoice_Date, '%Y-%m') AS sales_month,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
ORDER BY total_operating_profit DESC
LIMIT 1;

-- Step 12: Calculate Monthly Average Selling Price
SELECT
    DATE_FORMAT(Invoice_Date, '%Y-%m') AS sales_month,
    ROUND(
        SUM(Price_per_Unit * Units_Sold) / NULLIF(SUM(Units_Sold), 0),
        2
    ) AS average_selling_price
FROM adidas_sales
GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
ORDER BY sales_month;

-- Step 13: Compare Monthly Sales with Average Monthly Sales
SELECT
    sales_month,
    total_sales,
    ROUND(AVG(total_sales) OVER (), 2) AS average_monthly_sales
FROM (
    SELECT
        DATE_FORMAT(Invoice_Date, '%Y-%m') AS sales_month,
        SUM(Price_per_Unit * Units_Sold) AS total_sales
    FROM adidas_sales
    GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
) AS monthly_data
ORDER BY sales_month;