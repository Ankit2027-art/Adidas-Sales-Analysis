USE adidas_sales_db;


-- 10.1 Best Product Overall
-- Identify the product generating the highest revenue.
SELECT 
    Product,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY Product
ORDER BY total_revenue DESC
LIMIT 1;


-- 10.2 Best Product in Each Region
WITH ProductRegion AS (
    SELECT
        Region,
        Product,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY Region, Product
),
RankedProducts AS(
    SELECT
        Region,
        Product,
        total_revenue,
        DENSE_RANK() OVER(
            PARTITION BY Region
            ORDER BY total_revenue DESC
            ) AS Product_Rank
		FROM ProductRegion
)
SELECT
    Region,
    Product,
    ROUND(total_revenue,2) AS total_revenue
FROM RankedProducts
WHERE Product_rank = 1
ORDER BY Region;


-- 10.3 Best Product in Each State
WITH ProductState AS(
   SELECT
	   State,
       Product,
	   SUM(Price_per_Unit * Units_Sold) AS total_revenue
	FROM adidas_sales
    GROUP BY State, Product
),
RankedProduct AS(
   SELECT
       State,
       Product,
       total_revenue,
       DENSE_RANK() OVER(
       PARTITION BY State
       ORDER BY total_revenue DESC
       ) AS Product_Rank
	FROM ProductState
)
SELECT
    State,
    Product,
    ROUND(total_revenue,2) As total_revenue
FROM RankedProduct
WHERE Product_Rank = 1
ORDER BY State;
    
    

-- 10.4 Best Retailer Overall
-- Identify the retailer generating the highest revenue.
SELECT
    Retailer,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY Retailer
ORDER BY total_revenue DESC
LIMIT 1;


-- 10.5 Best Retailer in Each Region
WITH RetailerRegion AS(
   SELECT
      Region,
      Retailer,
      SUM(Price_per_Unit * Units_Sold) AS total_revenue
   FROM adidas_sales
   GROUP BY Region,Retailer
),
RankedRetailers AS (
    SELECT
        Region,
        Retailer,
        total_revenue,
        DENSE_RANK() OVER (
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


-- 10.6 Best Sales Method Overall
-- Identify the sales method generating the highest revenue.
SELECT
    Sales_Method,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    ROUND(SUM(Operating_Profit), 2) AS total_profit
FROM adidas_sales
GROUP BY Sales_Method
ORDER BY total_revenue DESC
LIMIT 1;


-- 10.7 Best Sales Method in Each Region
WITH RegionMethod AS(
   SELECT
      Region,
      Sales_Method,
      SUM(Price_per_Unit * Units_Sold) As total_revenue
      FROM adidas_sales 
      GROUP BY Region,Sales_Method
),
RankedMethod AS(
     SELECT
         Region,
         Sales_Method,
         total_revenue,
         DENSE_RANK() OVER(
            PARTITION BY Region
            ORDER BY total_revenue DESC
            ) AS Method_Rank
	FROM RegionMethod
)
SELECT
    Region,
    Sales_Method,
    ROUND(total_revenue, 2) as total_revenue
FROM RankedMethod
Where Method_Rank = 1
ORDER BY Region;
    
		
-- 10.8 Highest Revenue City in Each State
WITH CityRevenue AS (
    SELECT
        State,
        City,
        SUM(Price_per_Unit * Units_Sold) AS total_revenue
    FROM adidas_sales
    GROUP BY State, City
),
RankedCities AS (
    SELECT
        State,
        City,
        total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY State
            ORDER BY total_revenue DESC
        ) AS city_rank
    FROM CityRevenue
)
SELECT
    State,
    City,
    ROUND(total_revenue, 2) AS total_revenue
FROM RankedCities
WHERE city_rank = 1
ORDER BY State;


-- 10.9 Highest Profit Product
SELECT
    Product,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit
FROM adidas_sales
GROUP BY Product
ORDER BY total_operating_profit DESC
LIMIT 1;


-- 10.10 High Sales but Low Profit Products
-- Compare each product against average product revenue and profit.
WITH ProductPerformence AS(
   SELECT
       Product,
       SUM(Price_per_Unit * Units_Sold) AS total_revenue,
       SUM(Operating_Profit) AS total_profit
	FROM adidas_sales
    GROUP BY Product
)
SELECT
    Product,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(total_profit, 2) AS total_profit
FROM ProductPerformence
WHERE total_revenue > (
	SELECT AVG(total_revenue)
    FROM ProductPerformence
)
AND total_profit < (
    SELECT AVG(total_profit)
    FROM productperformence
)
ORDER BY total_revenue DESC;



-- 10.11 Low Sales but High Margin Products
-- Identify products with below-average revenue
-- but above-average operating margin.
WITH ProductPerformence AS(
   SELECT
        Product,
        SUM(Price_per_Unit * Units_sold) AS total_revenue,
        AVG(Operating_Margin) * 100 AS average_margin
	FROM adidas_sales
    GROUP BY Product
)
SELECT
    Product,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(average_margin, 2) AS average_margin_pct
FROM ProductPerformence
WHERE total_revenue < (
    SELECT AVG(total_revenue)
    FROM ProductPerformence
)
AND average_margin > (
    SELECT AVG(average_margin)
    FROM ProductPerformence
)
ORDER BY average_margin DESC;

-- 10.12 High Profit Retailers
-- Identify the top 10 retailers by operating profit.
SELECT
    Retailer,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue
FROM adidas_sales
GROUP BY Retailer
ORDER BY total_operating_profit DESC
LIMIT 10;


-- 10.13 Regional Product Performance
-- Compare product revenue, units, and profit across regions.
SELECT
    Region,
    Product,
    ROUND(SUM(Price_per_Unit * Units_Sold), 2) AS total_revenue,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Operating_Profit), 2) AS total_operating_profit,
    ROUND(AVG(Operating_Margin) * 100, 2) AS average_margin_pct
FROM adidas_sales
GROUP BY Region, Product
ORDER BY Region, total_revenue DESC;