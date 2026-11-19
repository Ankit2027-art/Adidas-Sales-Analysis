USE adidas_sales_db;

-- Step 1: Calculate Region-wise Revenue
SELECT
    Region,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY Region
ORDER BY total_revenue DESC;

-- Step 2: Calculate Region-wise Units Sold
SELECT
    Region,
    SUM(Units_Sold) AS total_units_sold
FROM adidas_sales
GROUP BY Region
ORDER BY total_units_sold DESC;


-- Step 3: Calculate Region-wise Operating Profit
SELECT
    Region,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY Region
ORDER BY total_operating_profit DESC;


-- Step 4: Calculate Region-wise Average Operating Margin
SELECT
    Region,
    ROUND(AVG(Operating_Margin) * 100, 2) AS avg_operating_margin_percent
FROM adidas_sales
GROUP BY Region
ORDER BY avg_operating_margin_percent DESC;

-- Step 5: Calculate Region-wise Average Selling Price
SELECT
    Region,
    ROUND(
        SUM(Price_per_Unit * Units_Sold) / NULLIF(SUM(Units_Sold), 0),
        2
    ) AS avg_selling_price
FROM adidas_sales
GROUP BY Region
ORDER BY avg_selling_price DESC;

-- Step 6: Calculate Region-wise Sales Contribution
SELECT
    Region,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    ROUND(
        SUM(Price_per_Unit * Units_Sold) * 100.0 /
        (SELECT SUM(Price_per_Unit * Units_Sold) FROM adidas_sales),
        2
    ) AS sales_contribution_percent
FROM adidas_sales
GROUP BY Region
ORDER BY sales_contribution_percent DESC;

-- Step 7: Count Records in Each Region
SELECT
    Region,
    COUNT(*) AS total_records
FROM adidas_sales
GROUP BY Region
ORDER BY total_records DESC;

-- Step 8: Count Distinct Products in Each Region
SELECT
    Region,
    COUNT(DISTINCT Product) AS unique_products
FROM adidas_sales
GROUP BY Region
ORDER BY unique_products DESC;

USE adidas_sales_db;

-- Step 9: Find the Highest Revenue Product in Each Region
WITH regional_product_sales AS (
    SELECT
        Region,
        Product,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY Region, Product
),
ranked_products AS (
    SELECT
        Region,
        Product,
        total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY Region
            ORDER BY total_revenue DESC
        ) AS product_rank
    FROM regional_product_sales
)
SELECT
    Region,
    Product,
    ROUND(total_revenue, 2) AS total_revenue
FROM ranked_products
WHERE product_rank = 1
ORDER BY Region;


-- Step 10: Find the Lowest Revenue Product in Each Region
WITH regional_product_sales AS (
    SELECT
        Region,
        Product,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY Region, Product
),
ranked_products AS (
    SELECT
        Region,
        Product,
        total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY Region
            ORDER BY total_revenue ASC
        ) AS product_rank
    FROM regional_product_sales
)
SELECT
    Region,
    Product,
    ROUND(total_revenue, 2) AS total_revenue
FROM ranked_products
WHERE product_rank = 1
ORDER BY Region;

- -- Step 11: Create a Region-wise Sales Performance Summary
SELECT
    Region,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit,
    ROUND(AVG(Operating_Margin) * 100, 2) AS avg_operating_margin_percent
FROM adidas_sales
GROUP BY Region
ORDER BY total_revenue DESC;


-- Step 12: Rank Regions by Total Revenue
WITH regional_sales AS (
    SELECT
        Region,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY Region
)
SELECT
    Region,
    ROUND(total_revenue, 2) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM regional_sales
ORDER BY revenue_rank;

-- ++++++++++ 12.4 REGIONAL INSIGHTS ++++++++++

-- ++++++++++ Key Findings ++++++++++

-- 1. West region generated the highest revenue (₹26.97 crore).
-- 2. Midwest region generated the lowest revenue (₹13.58 crore).
-- 3. West region sold the highest number of units (48,43,185).
-- 4. Midwest region sold the lowest number of units (31,51,142).
-- 5. West region generated the highest operating profit (₹8.95 crore).
-- 6. Midwest region generated the lowest operating profit (₹5.28 crore).
-- 7. South region had the highest average operating margin (46.69%).
-- 8. West region had the lowest average operating margin (39.69%).
-- 9. West region contributed the highest share of total revenue (29.98%).
-- 10. All regions had all six product categories available.
-- 11. Men's Street Footwear was the highest revenue-generating category in four regions.
-- 12. Women's Athletic Footwear was the lowest revenue-generating category in all five regions.

-- ++++++++++ Business Insights ++++++++++

-- 1. West is the strongest region in terms of revenue, units sold and operating profit.
-- 2. Midwest has the lowest revenue, units sold and operating profit.
-- 3. South has the highest operating margin, which shows better profit margin performance.
-- 4. West generates the highest revenue but has the lowest operating margin.
-- 5. Men's Street Footwear performs well in most regions.
-- 6. Women's Athletic Footwear needs improvement because it has the lowest revenue in every region.

-- ++++++++++ Business Recommendations ++++++++++

-- 1. Continue focusing on West because it generates the highest revenue and profit.
-- 2. Find ways to improve sales in Midwest because it has the lowest revenue and units sold.
   /*  Company can try these Stratigies
    1. Targeted Marketing Campaigns
	2. Promotional Discounts and Offers
    3. Better Product Availability
    4. Understanding Customer Preferences
    5. Local Retailer Partnerships
   */
-- 3. Study South region's business performance to understand its high operating margin.
-- 4. Review costs and pricing in West to improve its operating margin.
-- 5. Focus on promoting Men's Street Footwear in regions where it performs well.
-- 6. Improve Women's Athletic Footwear sales through better marketing, offers and product promotion.
-- 7. Regularly compare regional sales and profit to identify improvement opportunities.