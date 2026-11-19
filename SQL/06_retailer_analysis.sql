USE adidas_sales_db;


-- 5.1 Retailer-wise Revenue
SELECT
    Retailer,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY Retailer
ORDER BY total_revenue DESC;


-- 5.2 Retailer-wise Units Sold
SELECT
    Retailer,
    SUM(Units_Sold) AS total_units_sold
FROM adidas_sales
GROUP BY Retailer
ORDER BY total_units_sold DESC;


-- 5.3 Retailer-wise Operating Profit
SELECT
    Retailer,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY Retailer
ORDER BY total_operating_profit DESC;


-- 5.4 Retailer-wise Average Margin
SELECT
    Retailer,
    ROUND(AVG(Operating_Margin) * 100, 2) AS average_operating_margin_pct
FROM adidas_sales
GROUP BY Retailer
ORDER BY average_operating_margin_pct DESC;


-- 5.5 Retailer-wise Transaction Count
SELECT
    Retailer,
    COUNT(*) AS transaction_records
FROM adidas_sales
GROUP BY Retailer
ORDER BY transaction_records DESC;


-- 5.6 Top 10 Retailers by Revenue
SELECT
    Retailer,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY Retailer
ORDER BY total_revenue DESC
LIMIT 10;


-- 5.7 Top 10 Retailers by Units Sold
SELECT
    Retailer,
    SUM(Units_Sold) AS total_units_sold
FROM adidas_sales
GROUP BY Retailer
ORDER BY total_units_sold DESC
LIMIT 10;


-- 5.8 Top 10 Retailers by Profit
SELECT
    Retailer,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY Retailer
ORDER BY total_operating_profit DESC
LIMIT 10;


-- 5.9 Highest Margin Retailers
SELECT
    Retailer,
    ROUND(AVG(Operating_Margin) * 100, 2) AS average_operating_margin_pct
FROM adidas_sales
GROUP BY Retailer
ORDER BY average_operating_margin_pct DESC
LIMIT 10;


-- 5.10 Lowest Performing Retailers
SELECT
    Retailer,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit,
    SUM(Units_Sold) AS total_units_sold
FROM adidas_sales
GROUP BY Retailer
ORDER BY total_revenue ASC, total_operating_profit ASC
LIMIT 10;


-- 5.11 Retailer Performance Comparison
SELECT
    Retailer,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit,
    ROUND(AVG(Operating_Margin) * 100, 2) AS average_operating_margin_pct,
    COUNT(*) AS transaction_records
FROM adidas_sales
GROUP BY Retailer
ORDER BY total_revenue DESC;

-- ++++++++++ 12.3 RETAILER INSIGHTS ++++++++++

-- ++++++++++ Key Findings ++++++++++

-- 1. West Gear generated the highest revenue (₹24.30 crore).
-- 2. Walmart generated the lowest revenue (₹7.46 crore).
-- 3. West Gear sold the highest number of units (45,07,772).
-- 4. Walmart sold the lowest number of units (13,81,940).
-- 5. West Gear generated the highest operating profit (₹8.57 crore).
-- 6. Walmart generated the lowest operating profit (₹2.58 crore).
-- 7. Sports Direct had the highest average operating margin (44.52%).
-- 8. Walmart had the lowest average operating margin (40.65%).
-- 9. Foot Locker had the highest number of transaction records (2,637).
-- 10. Walmart had the lowest number of transaction records (626).

-- ++++++++++ Business Insights ++++++++++

-- 1. West Gear is the best-performing retailer in terms of revenue, units sold and operating profit.
-- 2. Walmart has the lowest revenue, units sold and operating profit among all retailers.
-- 3. Sports Direct has the highest average operating margin.
-- 4. Foot Locker has the highest number of transaction records.
-- 5. Retailer performance varies across revenue, profit and operating margin.

-- ++++++++++ Business Recommendations ++++++++++

-- 1. Continue focusing on West Gear because it generates the highest revenue and profit.
-- 2. Find out why Walmart has low sales and profit, and work on improving its performance.
-- 3. Study the business practices of Sports Direct to understand its high operating margin.
-- 4. Maintain a strong relationship with Foot Locker because it has the highest number of transaction records.
-- 5. Regularly compare retailer performance to identify areas that need improvement.

 --  ++++++++++++++ Walmart Sales and Profit Analysis ++++++++++++++++++++
-- Step 1: Retailer-wise Sales and Profit Comparison.
SELECT
    Retailer,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS Total_Sales,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(Operating_Profit), 2) AS Total_Profit
FROM adidas_sales
GROUP BY Retailer
ORDER BY Total_Sales DESC;

-- Step 2: Analyze Walmart's Average Selling Price
SELECT
    Retailer,
    ROUND(
        SUM(Price_per_Unit * Units_Sold) / SUM(Units_Sold), 2
    ) AS Average_Selling_Price
FROM adidas_sales
GROUP BY Retailer
ORDER BY Average_Selling_Price DESC;

-- Step 3: Analyze Operating Margin
SELECT
    Retailer,
    ROUND(AVG(Operating_Margin) * 100, 2) AS Operating_Margin_Percentage
FROM adidas_sales
GROUP BY Retailer
ORDER BY Operating_Margin_Percentage DESC;

-- Step 4: Analyze Sales Method
SELECT
    Retailer,
    Sales_Method,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS Total_Sales,
    SUM(Units_Sold) AS Total_Units_Sold
FROM adidas_sales
WHERE Retailer = 'Walmart'
GROUP BY Retailer, Sales_Method
ORDER BY Total_Sales DESC;

-- Step 5: Final Findings and Recommendations
/*
Why does Walmart have low sales and profit?
1. Walmart has the lowest total sales among all six retailers.
2. It has the lowest total units sold.
3. Its average selling price is actually the highest ($53.95), so low pricing is not the problem.
4. It has the lowest operating margin (40.65%).
5. Online and In-store channels generate significantly less revenue than Outlet.
*/

-- Recommendations:
/*
- Improve online marketing and promotional campaigns.
- Introduce special discounts on selected products.
- Improve in-store customer engagement.
- Review operating expenses to improve profit margins.
- Focus on increasing sales volume.
*/