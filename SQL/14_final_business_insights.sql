USE adidas_sales_db;

-- 12.1 Revenue Insights
-- 1.Analyze monthly revenue performance.

SELECT
    YEAR(Invoice_Date) AS sales_year,
    MONTH(Invoice_Date) AS sales_month,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS monthly_revenue
FROM adidas_sales
GROUP BY
    YEAR(Invoice_Date),
    MONTH(Invoice_Date)
ORDER BY
    monthly_revenue DESC;

-- 2. Calculate overall revenue performance metrics.

SELECT
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    ROUND(AVG(Price_per_Unit * Units_Sold), 2) AS average_transaction_revenue,
    ROUND(MIN(Price_per_Unit * Units_Sold), 2) AS lowest_transaction_revenue,
    ROUND(MAX(Price_per_Unit * Units_Sold), 2) AS highest_transaction_revenue,
    COUNT(*) AS total_transactions
FROM adidas_sales;


-- 3.Calculate each month's contribution to total revenue.

WITH MonthlyRevenue AS (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        MONTH(Invoice_Date) AS sales_month,
        SUM(Price_per_Unit * Units_Sold) AS monthly_revenue
    FROM adidas_sales
    GROUP BY
        YEAR(Invoice_Date),
        MONTH(Invoice_Date)
)
SELECT
    sales_year,
    sales_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(
        (monthly_revenue / SUM(monthly_revenue) OVER ()) * 100,
        2
    ) AS revenue_contribution_percentage
FROM MonthlyRevenue
ORDER BY monthly_revenue DESC;

-- Identify the top 3 months by revenue.

SELECT
    YEAR(Invoice_Date) AS sales_year,
    MONTH(Invoice_Date) AS sales_month,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS monthly_revenue
FROM adidas_sales
GROUP BY
    YEAR(Invoice_Date),
    MONTH(Invoice_Date)
ORDER BY monthly_revenue desc
LIMIT 3;

-- Identify the lowest 3 months by revenue.

SELECT
    YEAR(Invoice_Date) AS sales_year,
    MONTH(Invoice_Date) AS sales_month,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS monthly_revenue
FROM adidas_sales
GROUP BY
    YEAR(Invoice_Date),
    MONTH(Invoice_Date)
ORDER BY monthly_revenue ASC
LIMIT 3;

-- Compare total revenue across different years.

SELECT
    YEAR(Invoice_Date) AS sales_year,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    COUNT(*) AS total_transactions
FROM adidas_sales
GROUP BY YEAR(Invoice_Date)
ORDER BY sales_year;

-- Calculate each year's contribution to total revenue.

WITH YearlyRevenue AS (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY YEAR(Invoice_Date)
)
SELECT
    sales_year,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        (total_revenue / SUM(total_revenue) OVER ()) * 100,
        2
    ) AS revenue_contribution_percentage
FROM YearlyRevenue
ORDER BY sales_year;

-- Calculate average monthly revenue for each year.

WITH MonthlyRevenue AS (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        MONTH(Invoice_Date) AS sales_month,
        SUM(Price_per_Unit * Units_Sold) AS monthly_revenue
    FROM adidas_sales
    GROUP BY
        YEAR(Invoice_Date),
        MONTH(Invoice_Date)
)
SELECT
    sales_year,
    COUNT(*) AS active_months,
    ROUND(AVG(monthly_revenue), 2) AS average_monthly_revenue
FROM MonthlyRevenue
GROUP BY sales_year
ORDER BY sales_year;

-- Calculate year-over-year revenue growth percentage.

WITH YearlyRevenue AS (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY YEAR(Invoice_Date)
),
RevenueGrowth AS (
    SELECT
        sales_year,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY sales_year
        ) AS previous_year_revenue
    FROM YearlyRevenue
)
SELECT
    sales_year,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(previous_year_revenue, 2) AS previous_year_revenue,
    ROUND(
        ((total_revenue - previous_year_revenue) /
        NULLIF(previous_year_revenue, 0)) * 100,
        2
    ) AS revenue_growth_percentage
FROM RevenueGrowth
ORDER BY sales_year;

-- Analyze quarterly revenue performance.

SELECT
    YEAR(Invoice_Date) AS sales_year,
    QUARTER(Invoice_Date) AS sales_quarter,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS quarterly_revenue
FROM adidas_sales
GROUP BY
    YEAR(Invoice_Date),
    QUARTER(Invoice_Date)
ORDER BY
    sales_year,
    sales_quarter;
    
-- Identify the highest revenue-generating quarter.

SELECT
    YEAR(Invoice_Date) AS sales_year,
    QUARTER(Invoice_Date) AS sales_quarter,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS quarterly_revenue
FROM adidas_sales
GROUP BY
    YEAR(Invoice_Date),
    QUARTER(Invoice_Date)
ORDER BY quarterly_revenue DESC
LIMIT 1;

-- Calculate each quarter's contribution to total revenue.

WITH QuarterlyRevenue AS (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        QUARTER(Invoice_Date) AS sales_quarter,
        SUM(Price_per_Unit * Units_Sold) AS quarterly_revenue
    FROM adidas_sales
    GROUP BY
        YEAR(Invoice_Date),
        QUARTER(Invoice_Date)
)
SELECT
    sales_year,
    sales_quarter,
    ROUND(quarterly_revenue, 2) AS quarterly_revenue,
    ROUND(
        quarterly_revenue / SUM(quarterly_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percentage
FROM QuarterlyRevenue
ORDER BY quarterly_revenue DESC;

-- Analyze total revenue by calendar month across all years.

SELECT
    MONTH(Invoice_Date) AS month_number,
    MONTHNAME(Invoice_Date) AS month_name,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY
    MONTH(Invoice_Date),
    MONTHNAME(Invoice_Date)
ORDER BY total_revenue DESC;


-- Identify the highest and lowest revenue-generating months.

WITH MonthlyRevenue AS (
    SELECT
        MONTH(Invoice_Date) AS month_number,
        MONTHNAME(Invoice_Date) AS month_name,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY
        MONTH(Invoice_Date),
        MONTHNAME(Invoice_Date)
),
RankedMonths AS (
    SELECT
        month_number,
        month_name,
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) AS highest_rank,
        RANK() OVER (ORDER BY total_revenue ASC) AS lowest_rank
    FROM MonthlyRevenue
)
SELECT
    month_name,
    ROUND(total_revenue, 2) AS total_revenue,
    CASE
        WHEN highest_rank = 1 THEN 'Highest Revenue'
        WHEN lowest_rank = 1 THEN 'Lowest Revenue'
    END AS revenue_status
FROM RankedMonths
WHERE highest_rank = 1 OR lowest_rank = 1;

-- Analyze revenue generated by each sales method.

SELECT
    Sales_Method,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    COUNT(*) AS total_transactions,
    ROUND(AVG(Price_per_Unit * Units_Sold), 2) AS average_transaction_revenue
FROM adidas_sales
GROUP BY Sales_Method
ORDER BY total_revenue DESC;

-- Calculate revenue contribution by sales method.

WITH SalesMethodRevenue AS (
    SELECT
        Sales_Method,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY Sales_Method
)
SELECT
    Sales_Method,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        (total_revenue / SUM(total_revenue) OVER ()) * 100,
        2
    ) AS revenue_contribution_percentage
FROM SalesMethodRevenue
ORDER BY total_revenue DESC;

-- Analyze total revenue generated by each region.

SELECT
    Region,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    COUNT(*) AS total_transactions,
    ROUND(AVG(Price_per_Unit * Units_Sold), 2) AS average_transaction_revenue
FROM adidas_sales
GROUP BY Region
ORDER BY total_revenue DESC;

-- Calculate each region's contribution to total revenue.

WITH RegionalRevenue AS (
    SELECT
        Region,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY Region
)
SELECT
    Region,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        (total_revenue / SUM(total_revenue) OVER ()) * 100,
        2
    ) AS revenue_contribution_percentage
FROM RegionalRevenue
ORDER BY total_revenue DESC;

-- Identify the highest and lowest revenue-generating regions.

WITH RegionalRevenue AS (
    SELECT
        Region,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY Region
),
RankedRegions AS (
    SELECT
        Region,
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) AS highest_rank,
        RANK() OVER (ORDER BY total_revenue ASC) AS lowest_rank
    FROM RegionalRevenue
)
SELECT
    Region,
    ROUND(total_revenue, 2) AS total_revenue,
    CASE
        WHEN highest_rank = 1 THEN 'Highest Revenue'
        WHEN lowest_rank = 1 THEN 'Lowest Revenue'
    END AS revenue_status
FROM RankedRegions
WHERE highest_rank = 1 OR lowest_rank = 1;

-- Analyze revenue generated by each product category.

SELECT
    Product,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    COUNT(*) AS total_transactions,
    SUM(Units_Sold) AS total_units_sold
FROM adidas_sales
GROUP BY Product
ORDER BY total_revenue DESC;

-- Calculate each product category's contribution to total revenue.

WITH ProductRevenue AS (
    SELECT
        Product,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY Product
)
SELECT
    Product,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        (total_revenue / SUM(total_revenue) OVER ()) * 100,
        2
    ) AS revenue_contribution_percentage
FROM ProductRevenue
ORDER BY total_revenue DESC;


-- Calculate Yearly Sales and Year-over-Year (YoY) Growth Percentage
With Yearly_Sales As(
    SELECT
    YEAR(Invoice_Date) AS Year,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS Total_Sales
FROM adidas_sales
GROUP BY Year
)
SELECT
    Year,
    ROUND(Total_Sales, 2) AS Total_Sales,
    ROUND(
        (Total_Sales - LAG(Total_Sales) OVER (ORDER BY Year))
        / LAG(Total_Sales) OVER (ORDER BY Year) * 100,
        2
    ) AS Growth_Percentage
FROM Yearly_Sales;



--  REVENUE INSIGHTS

--  +++++++++++ Key Findings +++++++++++

-- 1. Total revenue was ₹89,96,39,837.
-- 2. 2021 generated 79.76% of the total revenue.
-- 3. Revenue increased by 294.09% in 2021 compared to 2020.
-- 4. July[2021] was the month with the highest revenue.
-- 5. Dec[2020] was the month with the lowest revenue.
-- 6. 2021 Q3 had the highest quarterly revenue of ₹20.99 crore.
-- 7. The West region generated the highest revenue (29.98%).
-- 8. In-store sales generated the highest revenue share (39.64%).
-- 9. Men's Street Footwear was the top-selling category by revenue(23.21%).

--  +++++++++++ Business Insights ++++++++++++

--  Sales were much higher in 2021 than in 2020.
--  July had the highest total revenue among all months.
--  The West region contributed the most revenue.
--  In-store sales performed better than Online and Outlet sales.
--  Men's Street Footwear generated the highest revenue among all product categories.

-- ++++++++++ Business Recommendations ++++++++++

-- 1. Find out what helped increase revenue in 2021.
-- 2. Keep enough stock for July because sales were highest during this month.
-- 3. Focus on improving sales in regions with lower revenue.
-- 4. Improve online sales while continuing to focus on in-store sales.
-- 5. Keep enough stock of Men's Street Footwear because it generates the highest revenue.
-- 6. Check why March[2021] sales were low and try special offers or discounts to increase sales.

-- Calculate Why Sales is Lowest in March[2021]
     -- Unit Sold March[2021]
SELECT
    YEAR(Invoice_Date) AS Year,
    MONTHNAME(Invoice_Date) AS Month,
    SUM(Units_Sold) AS Total_Units_Sold
FROM adidas_sales
WHERE YEAR(Invoice_Date) = 2021
AND MONTH(Invoice_Date) = 3
GROUP BY
    YEAR(Invoice_Date),
    MONTHNAME(Invoice_Date); 
    
         -- Previous year sale Comaprision
SELECT
    MONTHNAME(Invoice_Date) AS Month,
    SUM(Units_Sold) AS Total_Units,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS Total_Sales
FROM adidas_sales
WHERE YEAR(Invoice_Date) = 2021
AND MONTH(Invoice_Date) IN (2, 3)
GROUP BY MONTH(Invoice_Date), MONTHNAME(Invoice_Date)
ORDER BY MONTH(Invoice_Date);

        -- Product-wise Sales Comparison
SELECT
    Product,
    MONTHNAME(Invoice_Date) AS Month,
    SUM(Units_Sold) AS Total_Units,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS Total_Sales
FROM adidas_sales
WHERE YEAR(Invoice_Date) = 2021
AND MONTH(Invoice_Date) IN (2, 3)
GROUP BY Product, MONTH(Invoice_Date), MONTHNAME(Invoice_Date)
ORDER BY Product, MONTH(Invoice_Date);