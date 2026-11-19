USE adidas_sales_db;

-- Step 1: Calculate Revenue by Sales Method
SELECT
    Sales_Method,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY Sales_Method
ORDER BY total_revenue DESC;

-- Step 2: Calculate Units Sold by Sales Method
SELECT
    Sales_Method,
    SUM(Units_Sold) AS Total_units_sold
FROM adidas_sales
GROUP BY Sales_Method
ORDER BY Total_units_sold DESC;

-- Step 3: Calculate Operating Profit by Sales Method
SELECT
    Sales_Method,
    ROUND(SUM(Operating_Profit), 2) AS total_Operating_profit
FROM adidas_sales
GROUP BY Sales_Method
ORDER BY total_Operating_profit DESC;

-- Step 4: Calculate Average Operating Margin by Sales Method
SELECT
    Sales_Method,
    ROUND(AVG(Operating_Margin) * 100, 2) AS avg_operating_margin_percent
FROM adidas_sales
GROUP BY Sales_Method
ORDER BY avg_operating_margin_percent DESC;

-- Step 5: Calculate Revenue Contribution by Sales Method
SELECT
    Sales_Method,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    ROUND(
        SUM(Price_per_Unit * Units_Sold) * 100.0 /
        NULLIF(
            (SELECT SUM(Price_per_Unit * Units_Sold)
             FROM adidas_sales), 0
        ),
        2
    ) AS revenue_contribution_percent
FROM adidas_sales
GROUP BY Sales_Method
ORDER BY revenue_contribution_percent DESC;
                 
-- Step 6: Calculate Average Selling Price by Sales Method
SELECT
    Sales_method,
    ROUND(
        SUM(Price_per_Unit * Units_Sold)/
        NULLIF(SUM(Units_Sold),0),
        2
        ) AS avg_selling_price
	FROM adidas_sales
    GROUP BY Sales_Method
    ORDER BY avg_selling_price DESC;
        
-- Step 7: Count Records by Sales Method 
SELECT
    Sales_Method,
    COUNT(*) As total_records
FROM adidas_sales
GROUP BY Sales_Method
ORDER BY total_records DESC;

-- Step 8: Count Unique Products by Sales Method
SELECT
    Sales_Method,
    COUNT(DISTINCT Product) AS Unique_products
FROM adidas_sales
GROUP BY Sales_Method
ORDER BY Unique_products DESC;

-- Step 9: Calculate Product-wise Revenue by Sales Method
SELECT
   Sales_Method,
   ROUND(SUM(Price_per_Unit * Units_Sold), 2)  AS total_revenue
FROM adidas_sales
GROUP BY Sales_Method
ORDER BY Sales_Method, total_revenue DESC;

-- Step 10: Identify Top 5 Products by Revenue in Each Sales Method
WITH product_sales AS (
    SELECT
        Sales_Method,
        Product,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY Sales_Method, Product
),
ranked_products AS (
    SELECT
        Sales_Method,
        Product,
        total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY Sales_Method
            ORDER BY total_revenue DESC
        ) AS product_rank
    FROM product_sales
)
SELECT
    Sales_Method,
    Product,
    ROUND(total_revenue, 2) AS total_revenue,
    product_rank
FROM ranked_products
WHERE product_rank <= 5
ORDER BY Sales_Method, product_rank;

-- Step 11: Rank Sales Methods by Total Revenue
WITH method_sales AS (
    SELECT
        Sales_Method,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY Sales_Method
)
SELECT
    Sales_Method,
    ROUND(total_revenue, 2) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM method_sales
ORDER BY revenue_rank;

-- Step 12: Create Sales Method Performance Summary
SELECT
    Sales_Method,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit,
    ROUND(AVG(Operating_Margin) * 100, 2) AS avg_operating_margin_percent,
    ROUND(
        SUM(Price_per_Unit * Units_Sold) /
        NULLIF(SUM(Units_Sold), 0),
        2
    ) AS avg_selling_price,
    COUNT(*) AS total_records
FROM adidas_sales
GROUP BY Sales_Method
ORDER BY total_revenue DESC;


-- ++++++++++ 12.6 SALES METHOD INSIGHTS ++++++++++

-- Key Findings:
-- 1. In-store generated the highest revenue of ₹35.66 crore.
-- 2. In-store contributed 39.64% of total revenue.
-- 3. Outlet contributed 32.83% of total revenue.
-- 4. Online contributed 27.53% of total revenue.
-- 5. In-store recorded the highest units sold at 68,99,900 units.
-- 6. In-store generated the highest operating profit of ₹12.76 crore.
-- 7. Online had the highest average operating margin at 46.42%.
-- 8. In-store had the lowest average operating margin at 35.61%.
-- 9. In-store had the highest average selling price of ₹51.69.
-- 10. Online had the lowest average selling price of ₹48.10.
-- 11. Online recorded the highest transaction records at 4,889.
-- 12. All three sales methods covered all six product categories.
-- 13. Men's Street Footwear ranked first in revenue across all sales methods.
-- 14. Women's Apparel ranked second in revenue across all sales methods.

-- Business Insights:
-- 1. In-store is the strongest method in revenue, units sold and operating profit.
-- 2. Online generates lower revenue but has the highest average operating margin.
-- 3. Online has more transaction records but lower average revenue per record.
-- 4. Outlet performs between In-store and Online in total revenue.
-- 5. In-store has the highest average selling price but the lowest average operating margin.
-- 6. Men's Street Footwear performs consistently well across all sales methods.
-- 7. Women's Apparel is another strong product category across all sales methods.

-- Business Recommendations:
-- 1. Maintain strong inventory and customer service in In-store channels.
-- 2. Focus on increasing Online revenue while maintaining its high margin.
-- 3. Review In-store costs to identify opportunities to improve operating margin.
-- 4. Use targeted online promotions to increase online sales.
-- 5. Improve Outlet performance through seasonal offers and promotions.
-- 6. Maintain sufficient stock of Men's Street Footwear across all sales methods.
-- 7. Promote Women's Apparel across all sales methods.
-- 8. Regularly compare revenue, profit and operating margin across sales methods.
