USE adidas_sales_db;

-- Step 1: Calculate Product-wise Revenue
SELECT
    Product,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY Product
ORDER BY total_revenue DESC;

-- 4.2 Product-wise Units Sold
SELECT
    Product,
    SUM(Units_Sold) AS total_units_sold
FROM adidas_sales
GROUP BY Product
ORDER BY total_units_sold DESC;

-- 4.3 Product-wise Operating Profit
SELECT
    Product,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY Product
ORDER BY total_operating_profit DESC;

-- 4.4 Product-wise Average Price
SELECT
    Product,
    ROUND(AVG(Price_per_Unit), 2) AS average_price
FROM adidas_sales
GROUP BY Product
ORDER BY average_price DESC;

-- 4.5 Product-wise Average Operating Margin
SELECT
    Product,
    ROUND(AVG(Operating_Margin) * 100, 2) AS average_operating_margin_pct
FROM adidas_sales
GROUP BY Product
ORDER BY average_operating_margin_pct DESC;

-- 4.6 Product-wise Transaction Count
SELECT
    Product,
    COUNT(*) AS transaction_records
FROM adidas_sales
GROUP BY Product
ORDER BY transaction_records DESC;

-- 4.7 Top 10 Products by Revenue
SELECT
    Product,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY Product
ORDER BY total_revenue DESC
LIMIT 10;

-- 4.8 Top 10 Products by Units Sold
SELECT
    Product,
    SUM(Units_Sold) AS total_units_sold
FROM adidas_sales
GROUP BY Product
ORDER BY total_units_sold DESC
LIMIT 10;

-- 4.9 Top 10 Products by Operating Profit
SELECT
    Product,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY Product
ORDER BY total_operating_profit DESC
LIMIT 10;

-- 4.10 Top Products by Operating Margin
SELECT
    Product,
    ROUND(AVG(Operating_Margin) * 100, 2) AS average_operating_margin_pct
FROM adidas_sales
GROUP BY Product
ORDER BY average_operating_margin_pct DESC
LIMIT 10;

-- 4.11 Lowest Revenue Products
SELECT
    Product,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY Product
ORDER BY total_revenue ASC
LIMIT 10;

-- 4.12 Lowest Profit Products
SELECT
    Product,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY Product
ORDER BY total_operating_profit ASC
LIMIT 10;

-- 4.13 Product Performance Comparison
SELECT
    Product,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit,
    ROUND(AVG(Price_per_Unit), 2) AS average_price,
    ROUND(AVG(Operating_Margin) * 100, 2) AS average_operating_margin_pct,
    COUNT(*) AS transaction_records
FROM adidas_sales
GROUP BY Product
ORDER BY total_revenue DESC;


-- ++++++++++ 12.2 PRODUCT INSIGHTS ++++++++++

-- ++++++++++ Key Findings ++++++++++

-- 1. Men's Street Footwear generated the highest revenue (₹20.88 crore).
-- 2. Women's Athletic Footwear generated the lowest revenue (₹10.66 crore).
-- 3. Men's Street Footwear had the highest units sold (43,09,906).
-- 4. Men's Apparel had the lowest units sold (22,11,518).
-- 5. Men's Street Footwear generated the highest operating profit (₹8.28 crore).
-- 6. Women's Athletic Footwear generated the lowest operating profit (₹3.90 crore).
-- 7. Women's Apparel had the highest average selling price (₹51.61).
-- 8. Men's Street Footwear had the highest average operating margin (44.63%).
-- 9. Men's Athletic Footwear had the lowest average operating margin (40.25%).
-- 10. All six product categories had almost the same number of transaction records.

-- ++++++++++ Business Insights ++++++++++

-- 1. Men's Street Footwear is the best-performing category in terms of revenue, units sold and operating profit.
-- 2. Women's Athletic Footwear has the lowest revenue and operating profit among all categories.
-- 3. Men's Apparel has the lowest unit sales, but it does not have the lowest revenue.
-- 4. Women's Apparel has the highest average selling price.
-- 5. Men's Street Footwear has a strong operating margin compared to other categories.
-- 6. Men's Athletic Footwear needs attention because it has the lowest average operating margin.

-- ++++++++++ Business Recommendations ++++++++++

-- 1. Focus more on Men's Street Footwear because it performs well in sales and profit.
-- 2. Find out why Women's Athletic Footwear has low revenue and profit, and work on improving its sales.
-- 3. Use offers and promotions to increase Men's Apparel sales.
-- 4. Continue promoting Women's Apparel because it has the highest average selling price.
-- 5. Try to improve the operating margin of Men's Athletic Footwear by reviewing costs and pricing.
-- 6. Keep checking the sales and profit of all product categories to understand their performance.

-- Find out why Women's Athletic Footwear has low revenue and profit
-- Step 1: Category-wise Revenue & Profit
SELECT
    Product,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS Revenue,
    ROUND(SUM((Price_per_Unit - (Price_per_Unit * Operating_Margin)) * Units_Sold), 2) AS Profit
FROM adidas_sales
GROUP BY Product
ORDER BY Revenue DESC;

-- Step 2: Check Total Units Sold
SELECT
    Product,
    SUM(Units_Sold) AS Total_Units_Sold
FROM adidas_sales
GROUP BY Product
ORDER BY Total_Units_Sold DESC;

-- Step 3: Average Selling Price Analysis
SELECT
    Product,
    ROUND(
        SUM(Price_per_Unit * Units_Sold) / SUM(Units_Sold),
        2
    ) AS Average_Selling_Price
FROM adidas_sales
GROUP BY Product
ORDER BY Average_Selling_Price DESC;

-- Step 4: Profit Margin Analysis
SELECT
    Product,
    ROUND(
        SUM((Price_per_Unit - (Price_per_Unit * Operating_Margin)) * Units_Sold)
        / SUM(Price_per_Unit * Units_Sold) * 100,
        2
    ) AS Profit_Margin_Percentage
FROM adidas_sales
GROUP BY Product
ORDER BY Profit_Margin_Percentage DESC;

-- Step 5: Final recoomandation

/*1. Women's Athletic Footwear has the lowest revenue (₹10.66 Cr).
2. Units sold are second lowest (22,79,782).
3. Average selling price is second lowest (₹46.76).
4. Profit margin is 63.45%, so low profit margin is not the main issue.
Main observation: Low sales volume and comparatively low average selling price are possible reasons for lower revenue.
*/

-- Step 6: Improvement Strategy
/*
Project ke liye ye recommendations likh sakte ho:
- Introduce special discounts and promotional offers.
- Run targeted marketing campaigns for Women's Athletic Footwear.
- Offer combo deals to increase sales volume.
- Promote popular products through online and in-store campaigns.
*/