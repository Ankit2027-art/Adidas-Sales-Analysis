USE adidas_sales_db;

-- Step 1: Calculate State-wise Revenue
SELECT
    State,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY State
ORDER BY total_revenue DESC;

-- Step 2: Calculate City-wise Revenue
SELECT
    State,
    City,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY State, City
ORDER BY total_revenue DESC;

-- Step 3: Calculate State-wise Units Sold
SELECT
    State,
    SUM(Units_Sold) AS total_units_sold
FROM adidas_sales
GROUP BY State
ORDER BY total_units_sold DESC;

-- Step 4: Calculate State-wise Operating Profit
SELECT
    State,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY State
ORDER BY total_operating_profit DESC;

-- Step 5: Calculate State-wise Average Operating Margin
SELECT
    State,
    ROUND(AVG(Operating_Margin) * 100, 2) AS avg_operating_margin_percent
FROM adidas_sales
GROUP BY State
ORDER BY avg_operating_margin_percent DESC;

-- Step 6: Calculate City-wise Units Sold
SELECT
    State,
    City,
    SUM(Units_Sold) AS total_units_sold
FROM adidas_sales
GROUP BY State, City
ORDER BY total_units_sold DESC;

-- Step 7: Calculate City-wise Operating Profit
SELECT
    State,
    City,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY State, City
ORDER BY total_operating_profit DESC;

-- Step 7: Calculate City-wise Operating Profit
SELECT
    State,
    City,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY State, City
ORDER BY total_operating_profit DESC;

-- Step 8: Calculate City-wise Average Operating Margin
SELECT
    State,
    City,
    ROUND(AVG(Operating_Margin) * 100, 2) AS avg_operating_margin_percent
FROM adidas_sales
GROUP BY State, City
ORDER BY avg_operating_margin_percent DESC;

-- Step 9: Calculate State-wise Sales Contribution
SELECT
    State,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    ROUND(
        SUM(Price_per_Unit * Units_Sold) * 100.0 /
        NULLIF(
            (SELECT SUM(Price_per_Unit * Units_Sold)
             FROM adidas_sales),
            0
        ),
        2
    ) AS sales_contribution_percent
FROM adidas_sales
GROUP BY State
ORDER BY sales_contribution_percent DESC;

-- Step 10: Identify the Top 10 Cities by Revenue
SELECT
    State,
    City,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY State, City
ORDER BY total_revenue DESC
LIMIT 10;

-- Step 11: Rank States by Total Revenue
WITH state_sales AS (
    SELECT
        State,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY State
)
SELECT
    State,
    ROUND(total_revenue, 2) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM state_sales
ORDER BY revenue_rank;


-- Step 12: Rank Cities by Revenue Within Each State
WITH city_sales AS (
    SELECT
        State,
        City,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY State, City
)
SELECT
    State,
    City,
    ROUND(total_revenue, 2) AS total_revenue,
    DENSE_RANK() OVER (
        PARTITION BY State
        ORDER BY total_revenue DESC
    ) AS city_rank
FROM city_sales
ORDER BY State, city_rank;

-- Final Step: Summarize State and City Sales Performance
SELECT
    State,
    City,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit,
    ROUND(AVG(Operating_Margin) * 100, 2) AS avg_operating_margin_percent
FROM adidas_sales
GROUP BY State, City
ORDER BY total_revenue DESC;


-- ++++++++++ 12.5 STATE & CITY INSIGHTS ++++++++++

-- Key Findings:
-- 1. New York generated the highest state-wise revenue of ₹6.42 crore.
-- 2. Nebraska generated the lowest state-wise revenue of ₹59.29 lakh.
-- 3. New York contributed 7.14% of total revenue.
-- 4. New York recorded the highest units sold at 12,02,745 units.
-- 5. New York generated the highest operating profit of ₹2.33 crore.
-- 6. Alabama had the highest average operating margin at 55.36%.
-- 7. Hawaii had the lowest average operating margin at 31.96%.
-- 8. New York City generated the highest city-wise revenue of ₹3.98 crore.
-- 9. Miami recorded the highest city-wise units sold at 5,89,600 units.
-- 10. New York City generated the highest city-wise operating profit of ₹1.39 crore.
-- 11. Birmingham had the highest city-wise average operating margin at 55.36%.
-- 12. Honolulu had the lowest city-wise average operating margin at 31.96%.

-- Business Insights:
-- 1. New York is the strongest state in revenue, units sold and operating profit.
-- 2. California and Florida are also major revenue-generating states.
-- 3. Nebraska, Minnesota and Iowa are among the lowest revenue-generating states.
-- 4. New York City is the strongest city in revenue and operating profit.
-- 5. Miami and Charleston show strong sales volume.
-- 6. Alabama has the highest average operating margin, while Hawaii has the lowest.
-- 7. High revenue does not always mean high operating margin.
-- 8. State and city performance varies, so business strategies should consider local performance.

-- Business Recommendations:
-- 1. Continue focusing on New York due to its strong sales performance.
-- 2. Maintain product availability in California and Florida.
-- 3. Investigate lower-performing states to identify growth opportunities.
-- 4. Maintain strong inventory and marketing in top-performing cities.
-- 5. Study Alabama's pricing and cost structure to understand its high margin.
-- 6. Review Hawaii's operating margin and identify ways to improve profitability.
-- 7. Monitor both revenue and operating margin across states and cities.
-- 8. Regularly review city-level performance to identify growth opportunities.
