USE adidas_sales_db;

-- 11.1 CASE WHEN
-- Classify sales records based on revenue.
SELECT
    Product,
    Price_per_Unit,
    Units_Sold,
    (Price_per_Unit * Units_Sold) AS revenue,
    CASE
        WHEN (Price_per_Unit * Units_Sold) >= 500000
            THEN 'Very High Revenue'
        WHEN (Price_per_Unit * Units_Sold) >= 300000
            THEN 'High Revenue'
        WHEN (Price_per_Unit * Units_Sold) >= 150000
            THEN 'Medium Revenue'
        WHEN (Price_per_Unit * Units_Sold) >= 50000
            THEN 'Low Revenue'
        ELSE 'Very Low Revenue'
    END AS revenue_category
FROM adidas_sales
ORDER BY revenue DESC;



-- 11.2 Revenue Classification
-- Classify products based on their total revenue.

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
    CASE
        WHEN total_revenue >= 500000
            THEN 'Very High Revenue'
        WHEN total_revenue >= 300000
            THEN 'High Revenue'
        WHEN total_revenue >= 150000
            THEN 'Medium Revenue'
        WHEN total_revenue >= 50000
            THEN 'Low Revenue'
        ELSE 'Very Low Revenue'
    END AS revenue_category
FROM ProductRevenue
ORDER BY total_revenue DESC;

-- 11.3 Profit Classification
-- Classify products based on their total operating profit.
WITH ProductProfit AS (
   SELECT
       Product,
       SUM(Operating_Profit) AS total_profit
   FROM adidas_sales
   GROUP BY Product
)
SELECT
    Product,
    ROUND(SUM(Operating_Profit), 2) AS total_profit,
    CASE
        WHEN SUM(Operating_Profit) >= 70000000
            THEN 'Very High Profit'
        WHEN SUM(Operating_Profit) >= 60000000
            THEN 'High Profit'
        WHEN SUM(Operating_Profit) >= 50000000
            THEN 'Medium Profit'
        WHEN SUM(Operating_Profit) >= 40000000
            THEN 'Low Profit'
        ELSE 'Very Low Profit'
    END AS profit_category
FROM adidas_sales
GROUP BY Product
ORDER BY total_profit DESC;

-- 11.4 Subqueries
-- Find products with above-average revenue.
SELECT
    Product,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY Product
HAVING SUM(Price_per_Unit * Units_Sold) > (
    SELECT AVG(product_revenue)
    FROM (
       SELECT
           SUM(Price_per_Unit * Units_Sold) AS product_revenue
	   FROM  adidas_sales
       GROUP BY Product
       ) AS revenue_data
) 
ORDER BY total_revenue DESC;



-- 11.5 Average Revenue Comparison
-- Compare product-wise revenue with average product revenue.
SELECT
    Product,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    ROUND(AVG(SUM(Price_per_Unit * Units_Sold)) OVER(), 2) AS average_revenue,
    CASE 
	    WHEN SUM(Price_per_Unit * Units_Sold) > 
            AVG(SUM(Price_per_Unit* Units_Sold)) OVER()
		   THEN 'Above Average'
		WHEN SUM(Price_per_Unit * Units_Sold) <
            AVG(SUM(Price_per_Unit * Units_Sold)) OVER()
		   THEN 'Below Average'
		ELSE 'Equal to Average'
	END AS revenue_comparison
FROM adidas_sales
GROUP BY Product
ORDER BY total_revenue DESC;

-- 11.6 CTE
-- Calculate product-wise revenue using a CTE.

WITH ProductSales AS(
    SELECT
        Product,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
	FROM adidas_sales 
    GROUP BY Product
)
SELECT
    Product,
    ROUND(total_revenue,2) as Total_revenue
FROM ProductSales
ORDER BY Total_revenue DESC;
  
-- 11.7 Multiple CTEs
-- Compare product-wise revenue and operating profit.

WITH ProductRevenue AS (
    SELECT
        Product,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY Product
),
ProductProfit AS (
    SELECT
        Product,
        SUM(Operating_Profit) AS total_profit
    FROM adidas_sales
    GROUP BY Product
)
SELECT
    r.Product,
    ROUND(r.total_revenue, 2) AS total_revenue,
    ROUND(p.total_profit, 2) AS total_operating_profit
FROM ProductRevenue r
JOIN ProductProfit p
    ON r.Product = p.Product
ORDER BY r.total_revenue DESC;

-- 11.8 RANK()
-- Rank products based on total revenue.
SELECT 
    Product,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    RANK() OVER(
        ORDER BY SUM(Price_per_Unit * Units_Sold) DESC
        ) As revenue_rank
FROM adidas_sales 
GROUP BY Product
ORDER BY revenue_rank;

-- 11.9 DENSE_RANK()
-- Rank products based on total operating profit.
SELECT
    Product,
    ROUND(SUM(Operating_Profit), 2) AS total_opearting_profit,
    DENSE_RANK() OVER(
	   ORDER BY SUM(Operating_Profit) DESC
       ) AS Profit_Rank
FROM adidas_sales 
GROUP BY Product
ORDER BY Profit_Rank;

-- 11.10 ROW_NUMBER()
-- Assign unique row numbers to products based on revenue.
SELECT
    Product,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    ROW_NUMBER() OVER(
    ORDER BY SUM(Price_per_Unit * Units_Sold) DESC
    ) AS row_num
FROM adidas_sales 
GROUP BY Product
ORDER BY row_num;

-- 11.11 Top Product per Region
-- Identify the highest revenue product in each region.
WITH productRegion AS (
   SELECT
       Region,
       Product,
       SUM(Price_per_Unit * Units_Sold) AS total_revenue
	FROM adidas_sales 
    GROUP BY Region, Product
),
 RankesProducts AS(
    SELECT
        Region,
        Product,
        total_revenue,
        ROW_NUMBER() OVER(
            PARTITION BY Region
            ORDER BY total_revenue DESC
            ) AS product_rank
		FROM ProductRegion
)
SELECT
    Region,
    Product,
    ROUND(total_revenue, 2) AS total_revenue
FROM RankesProducts
WHERE product_rank  = 1
ORDER BY Region,Product;

-- 11.12 Top Retailer per Region
-- Identify the highest revenue retailer in each region.
WITH RetailerRegion AS (
    SELECT
        Region,
        Retailer,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY Region, Retailer
),
RankedRetailers AS (
    SELECT
        Region,
        Retailer,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY Region
            ORDER BY total_revenue DESC
        ) AS retailer_rank
    FROM RetailerRegion
)
SELECT
	Region,
    Retailer,
    ROUND(total_revenue, 2) AS total_revenue
FROM RankedRetailers
WHERE retailer_rank = 1
ORDER BY Region;

-- 11.13 LAG()
-- Compare current monthly revenue with previous month's revenue.
USE adidas_sales_db;

-- 11.13 LAG()
-- Compare current monthly revenue with previous month's revenue.

WITH MonthlySales AS (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        MONTH(Invoice_Date) AS sales_month,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY
        YEAR(Invoice_Date),
        MONTH(Invoice_Date)
)
SELECT
    sales_year,
    sales_month,
    ROUND(total_revenue, 2) AS current_revenue,
    ROUND(
        LAG(total_revenue) OVER (
            ORDER BY sales_year, sales_month
        ), 2
    ) AS previous_revenue
FROM MonthlySales
ORDER BY sales_year, sales_month;



-- 11.15 Month-over-Month Growth
-- Calculate monthly revenue growth percentage.

WITH MonthlySales AS (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        MONTH(Invoice_Date) AS sales_month,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY
        YEAR(Invoice_Date),
        MONTH(Invoice_Date)
),
RevenueComparison AS (
    SELECT
        sales_year,
        sales_month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY sales_year, sales_month
        ) AS previous_revenue
    FROM MonthlySales
)
SELECT
    sales_year,
    sales_month,
    ROUND(total_revenue, 2) AS current_revenue,
    ROUND(previous_revenue, 2) AS previous_revenue,
    ROUND(
        ((total_revenue - previous_revenue) /
        NULLIF(previous_revenue, 0)) * 100,
        2
    ) AS mom_growth_percentage
FROM RevenueComparison
ORDER BY sales_year, sales_month;

-- 11.16 Running Total Revenue
-- Calculate cumulative revenue month by month.
WITH MonthlySales AS (
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
		SUM(monthly_revenue) OVER (
        ORDER BY sales_year, sales_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
	) AS running_total_revenue
FROM monthlySales
ORDER BY sales_year, sales_month;


-- 11.16 Running Total Revenue
-- Calculate cumulative revenue month by month.

WITH MonthlySales AS (
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
        SUM(monthly_revenue) OVER (
            ORDER BY sales_year, sales_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS running_total_revenue
FROM MonthlySales
ORDER BY sales_year, sales_month;

USE adidas_sales_db;

-- 11.17 Running Total Profit
-- Calculate cumulative operating profit month by month.

WITH MonthlyProfit AS (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        MONTH(Invoice_Date) AS sales_month,
        SUM(Operating_Profit) AS monthly_profit
    FROM adidas_sales
    GROUP BY
        YEAR(Invoice_Date),
        MONTH(Invoice_Date)
)
SELECT
    sales_year,
    sales_month,
    ROUND(monthly_profit, 2) AS monthly_profit,
    ROUND(
        SUM(monthly_profit) OVER (
            ORDER BY sales_year, sales_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS running_total_profit
FROM MonthlyProfit
ORDER BY sales_year, sales_month;


-- 11.18 Advanced Combined Analysis
-- Combine monthly revenue, profit, growth and running totals.

WITH MonthlySummary AS (
    SELECT
        YEAR(Invoice_Date) AS sales_year,
        MONTH(Invoice_Date) AS sales_month,
        SUM(Price_per_Unit * Units_Sold) AS monthly_revenue,
        SUM(Operating_Profit) AS monthly_profit
    FROM adidas_sales
    GROUP BY
        YEAR(Invoice_Date),
        MONTH(Invoice_Date)
),
AdvancedAnalysis AS (
    SELECT
        sales_year,
        sales_month,
        monthly_revenue,
        monthly_profit,

        LAG(monthly_revenue) OVER (
            ORDER BY sales_year, sales_month
        ) AS previous_revenue,

        SUM(monthly_revenue) OVER (
            ORDER BY sales_year, sales_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_revenue,

        SUM(monthly_profit) OVER (
            ORDER BY sales_year, sales_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_profit

    FROM MonthlySummary
)
SELECT
    sales_year,
    sales_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(monthly_profit, 2) AS monthly_profit,
    ROUND(previous_revenue, 2) AS previous_revenue,

    ROUND(
        ((monthly_revenue - previous_revenue) /
        NULLIF(previous_revenue, 0)) * 100,
        2
    ) AS mom_growth_percentage,

    ROUND(running_revenue, 2) AS running_total_revenue,
    ROUND(running_profit, 2) AS running_total_profit

FROM AdvancedAnalysis
ORDER BY sales_year, sales_month;