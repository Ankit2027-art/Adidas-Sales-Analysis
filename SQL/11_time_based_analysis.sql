USE adidas_sales_db;

-- Step 1: Calculate Year-wise Revenue
SELECT
    YEAR(Invoice_Date) AS sales_year,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY YEAR(Invoice_Date)
ORDER BY sales_year;

-- Step 2: Calculate Year-wise Units Sold
SELECT
    YEAR(Invoice_Date) AS sales_year,
    SUM(Units_Sold) AS total_units_sold
FROM adidas_sales
GROUP BY YEAR(Invoice_Date)
ORDER BY sales_year;

-- Step 3: Calculate Year-wise Operating Profit
SELECT
    YEAR(Invoice_Date) AS sales_year,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY YEAR(Invoice_Date)
ORDER BY sales_year;

-- Step 4: Calculate Quarter-wise Revenue
SELECT
    YEAR(Invoice_Date) AS sales_year,
    QUARTER(Invoice_Date) AS sales_quarter,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY YEAR(Invoice_Date), QUARTER(Invoice_Date)
ORDER BY sales_year, sales_quarter;

-- Step 5: Calculate Month-wise Revenue
SELECT
    MONTH(Invoice_Date) AS sales_month,
    MONTHNAME(Invoice_Date) AS month_name,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY MONTH(Invoice_Date), MONTHNAME(Invoice_Date)
ORDER BY sales_month;

-- Step 6: Calculate Year and Month-wise Revenue
SELECT
    YEAR(Invoice_Date) AS sales_year,
    MONTH(Invoice_Date) AS sales_month,
    MONTHNAME(Invoice_Date) AS month_name,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY
    YEAR(Invoice_Date),
    MONTH(Invoice_Date),
    MONTHNAME(Invoice_Date)
ORDER BY sales_year, sales_month;

-- Step 7: Calculate Day-wise Revenue
SELECT
    DAYNAME(Invoice_Date) AS day_name,
    DAYOFWEEK(Invoice_Date) AS day_number,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY
    DAYNAME(Invoice_Date),
    DAYOFWEEK(Invoice_Date)
ORDER BY day_number;

-- Step 8: Calculate Daily Revenue
SELECT
    Invoice_Date,
    ROUND(SUM(Price_per_Unit * Units_Sold),2) AS total_revenue
FROM adidas_sales 
GROUP BY Invoice_Date
ORDER BY Invoice_Date DESC;

-- Step 9: Identify the Highest Revenue Month
SELECT
    YEAR(Invoice_Date) AS sales_year,
    MONTHNAME(Invoice_Date) AS month_name,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY YEAR(Invoice_Date), MONTH(Invoice_Date), MONTHNAME(Invoice_Date)
ORDER BY total_revenue DESC
LIMIT 1;

-- Step 10: Identify the Lowest Revenue Month
SELECT
    YEAR(Invoice_Date) AS sales_year,
    MONTHNAME(Invoice_Date) AS month_name,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY YEAR(Invoice_Date), MONTH(Invoice_Date), MONTHNAME(Invoice_Date)
ORDER BY total_revenue ASC
LIMIT 1;

-- Step 11: Calculate Year-over-Year Revenue Growth
WITH yearly_sales AS (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY YEAR(Invoice_Date)
),
sales_with_previous_year AS (
    SELECT
        sales_year,
        total_revenue,
        LAG(total_revenue) OVER (ORDER BY sales_year) AS previous_year_revenue
    FROM yearly_sales
)
SELECT
    sales_year,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(previous_year_revenue, 2) AS previous_year_revenue,
    ROUND(
        (total_revenue - previous_year_revenue) * 100.0 /
        NULLIF(previous_year_revenue, 0),
        2
    ) AS yoy_growth_percent
FROM sales_with_previous_year
ORDER BY sales_year;

-- Step 12: Calculate Month-over-Month Revenue Growth
WITH monthly_sales AS (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        MONTH(Invoice_Date) AS sales_month,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY YEAR(Invoice_Date), MONTH(Invoice_Date)
),
sales_with_previous_month AS (
    SELECT
        sales_year,
        sales_month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY sales_year, sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    sales_year,
    sales_month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        (total_revenue - previous_month_revenue) * 100.0 /
        NULLIF(previous_month_revenue, 0),
        2
    ) AS mom_growth_percent
FROM sales_with_previous_month
ORDER BY sales_year, sales_month;

-- Step 13: Calculate Average Monthly Revenue
WITH monthly_sales AS (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        MONTH(Invoice_Date) AS sales_month,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY YEAR(Invoice_Date), MONTH(Invoice_Date)
)
SELECT
    ROUND(AVG(total_revenue), 2) AS average_monthly_revenue
FROM monthly_sales;

-- Step 14: Identify the Highest Revenue Date
SELECT
    Invoice_Date,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY Invoice_Date
ORDER BY total_revenue DESC
LIMIT 1;

-- Step 15: Calculate Year-wise Average Operating Margin
SELECT
    YEAR(Invoice_Date) AS sales_year,
    ROUND(AVG(Operating_Margin) * 100, 2) AS avg_operating_margin_percent
FROM adidas_sales
GROUP BY YEAR(Invoice_Date)
ORDER BY sales_year;

-- Step 16: Create Year-wise Sales Performance Summary
SELECT
    YEAR(Invoice_Date) AS sales_year,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit,
    ROUND(AVG(Operating_Margin) * 100, 2) AS avg_operating_margin_percent,
    COUNT(*) AS total_records
FROM adidas_sales
GROUP BY YEAR(Invoice_Date)
ORDER BY sales_year;


-- ++++++++++ 12.7 Overall Business Performance Insights ++++++++++

-- Key Findings:
-- 1. Total revenue increased from ₹18.21 crore in 2020 to ₹71.76 crore in 2021.
-- 2. Revenue grew by 294.09% in 2021 compared to 2020.
-- 3. Units sold increased from 33,23,719 in 2020 to 1,45,58,147 in 2021.
-- 4. Operating profit increased from ₹6.34 crore to ₹26.87 crore.
-- 5. Average operating margin improved from 40.37% to 42.62%.
-- 6. July 2021 was the highest-revenue month, generating ₹7.83 crore.
-- 7. December 2020 was the lowest-revenue month, generating ₹80.27 lakh.
-- 8. 2021 Q3 recorded the highest quarterly revenue of ₹20.99 crore.
-- 9. July 16, 2021 recorded the highest daily revenue of ₹1.23 crore.
-- 10. January 2021 recorded the highest MoM growth of 587.77%.
-- 11. March 2021 revenue declined by 15.06% compared to February 2021.
-- 12. Friday recorded the highest revenue among weekdays.

-- Business Insights:
-- 1. Business performance improved significantly in 2021 across revenue, units sold and operating profit.
-- 2. Average operating margin also improved in 2021.
-- 3. The third quarter of 2021 was the strongest quarter.
-- 4. Monthly revenue showed fluctuations instead of consistent growth.
-- 5. July was the strongest month, showing an opportunity for seasonal sales planning.
-- 6. Friday generated the highest revenue among weekdays.

-- Business Recommendations:
-- 1. Identify the factors behind strong business growth in 2021.
-- 2. Plan inventory and marketing campaigns before the July sales period.
-- 3. Investigate the reasons behind lower revenue in March 2021 and December 2020.
-- 4. Study the factors behind strong Q3 performance.
-- 5. Monitor monthly revenue and growth to identify declining sales early.
-- 6. Focus on increasing sales while maintaining healthy operating margins.
-- 7. Analyze weekday sales patterns to improve sales planning.
-- 1
SELECT
    Product,
    SUM(CASE WHEN YEAR(Invoice_Date) = 2020
        THEN Price_per_Unit * Units_Sold ELSE 0 END) AS Revenue_2020,
    SUM(CASE WHEN YEAR(Invoice_Date) = 2021
        THEN Price_per_Unit * Units_Sold ELSE 0 END) AS Revenue_2021
FROM adidas_sales
GROUP BY Product
ORDER BY Revenue_2021 DESC;

-- 2 
SELECT
    Product,
    SUM(Units_Sold) AS Total_Units_Sold,
    SUM(Price_per_Unit * Units_Sold) AS Total_Revenue
FROM adidas_sales
WHERE MONTH(Invoice_Date) = 7
GROUP BY Product
ORDER BY Total_Units_Sold DESC;

-- 3
SELECT
    Product,
    SUM(CASE WHEN YEAR(Invoice_Date) = 2020
              AND MONTH(Invoice_Date) = 12
        THEN Price_per_Unit * Units_Sold ELSE 0 END) AS Dec_2020_Revenue,
    SUM(CASE WHEN YEAR(Invoice_Date) = 2021
              AND MONTH(Invoice_Date) = 3
        THEN Price_per_Unit * Units_Sold ELSE 0 END) AS Mar_2021_Revenue
FROM adidas_sales
GROUP BY Product
ORDER BY Mar_2021_Revenue ASC;

-- 4
SELECT
    Product,
    SUM(Units_Sold) AS Total_Units_Sold,
    SUM(Price_per_Unit * Units_Sold) AS Total_Revenue
FROM adidas_sales
WHERE YEAR(Invoice_Date) = 2021
  AND QUARTER(Invoice_Date) = 3
GROUP BY Product
ORDER BY Total_Revenue DESC;

-- 5
WITH Monthly_Sales AS (
    SELECT
        DATE_FORMAT(Invoice_Date, '%Y-%m') AS Sales_Month,
        SUM(Price_per_Unit * Units_Sold) AS Revenue
    FROM adidas_sales
    GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
),
Previous_Sales AS (
    SELECT
        Sales_Month,
        Revenue,
        LAG(Revenue) OVER (ORDER BY Sales_Month) AS Previous_Month_Revenue
    FROM Monthly_Sales
)
SELECT
    Sales_Month,
    Revenue,
    Previous_Month_Revenue,
    ROUND(
        (Revenue - Previous_Month_Revenue)
        / NULLIF(Previous_Month_Revenue, 0) * 100, 2
    ) AS Growth_Percentage
FROM Previous_Sales;
-- 6
SELECT
    Product,
    SUM(Price_per_Unit * Units_Sold) AS Total_Revenue,
    SUM(Operating_Profit) AS Total_Operating_Profit,
    ROUND(AVG(Operating_Margin) * 100, 2) AS Avg_Operating_Margin
FROM adidas_sales
GROUP BY Product
ORDER BY Total_Operating_Profit DESC;
-- 7
SELECT
    DAYNAME(Invoice_Date) AS Day_Name,
    SUM(Price_per_Unit * Units_Sold) AS Total_Revenue,
    SUM(Units_Sold) AS Total_Units_Sold,
    COUNT(*) AS Transaction_Records
FROM adidas_sales
GROUP BY DAYOFWEEK(Invoice_Date), DAYNAME(Invoice_Date)
ORDER BY DAYOFWEEK(Invoice_Date);