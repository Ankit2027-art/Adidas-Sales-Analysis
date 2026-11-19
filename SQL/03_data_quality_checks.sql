USE adidas_sales_db;

-- Step 1: Correct the column name affected by CSV encoding
ALTER TABLE adidas_sales RENAME COLUMN `ï»¿Retailer` TO Retailer;

-- Step 2: Check missing values in all columns
SELECT
    SUM(CASE WHEN Retailer IS NULL THEN 1 ELSE 0 END) AS missing_retailer,
    SUM(CASE WHEN Retailer_ID IS NULL THEN 1 ELSE 0 END) AS missing_retailer_id,
    SUM(CASE WHEN Invoice_Date IS NULL THEN 1 ELSE 0 END) AS missing_invoice_date,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS missing_region,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS missing_state,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS missing_city,
    SUM(CASE WHEN Product IS NULL THEN 1 ELSE 0 END) AS missing_product,
    SUM(CASE WHEN Price_per_Unit IS NULL THEN 1 ELSE 0 END) AS missing_price_per_unit,
    SUM(CASE WHEN Units_Sold IS NULL THEN 1 ELSE 0 END) AS missing_units_sold,
    SUM(CASE WHEN Operating_Profit IS NULL THEN 1 ELSE 0 END) AS missing_operating_profit,
    SUM(CASE WHEN Operating_Margin IS NULL THEN 1 ELSE 0 END) AS missing_operating_margin,
    SUM(CASE WHEN Sales_Method IS NULL THEN 1 ELSE 0 END) AS missing_sales_method
FROM adidas_sales;

-- Step 3: Check for duplicate records
SELECT
    Retailer,
    Invoice_Date,
    Product,
    Region,
    Units_Sold,
    COUNT(*) AS duplicate_count
FROM adidas_sales
GROUP BY
    Retailer,
    Invoice_Date,
    Product,
    Region,
    Units_Sold
HAVING COUNT(*) > 1;
 
 -- Step 4: Check invalid or zero values in sales columns
 SELECT * FROM adidas_sales
 WHERE Price_per_Unit <= 0
    OR Units_Sold <= 0
    OR Operating_Profit <= 0
    OR Operating_Margin <= 0
    OR Operating_Margin > 1;
    
-- Step 5: Count records with zero units sold
SELECT COUNT(*) AS zero_units_records
FROM adidas_sales
WHERE Units_Sold = 0;
    
-- Step 6: Check records with negative sales values
SELECT *
FROM adidas_sales
WHERE Price_per_Unit < 0
   OR Units_Sold < 0;
   
-- Step 7: Check records with negative operating profit
SELECT COUNT(*) AS negative_profit_records
FROM adidas_sales
WHERE Operating_Profit < 0;

-- Step 8: Check for invalid operating margin values
SELECT COUNT(*) AS invalid_margin_records
FROM adidas_sales
WHERE Operating_Margin < 0
   OR Operating_Margin > 1;
   
-- Step 9: Check blank values in text columns
SELECT COUNT(*) AS blank_retailer_records
FROM adidas_sales
WHERE TRIM(Retailer) = '';

-- Step 10: Check blank values in text columns
SELECT
    SUM(CASE WHEN TRIM(Retailer) = '' THEN 1 ELSE 0 END) AS blank_retailer,
    SUM(CASE WHEN TRIM(Region) = '' THEN 1 ELSE 0 END) AS blank_region,
    SUM(CASE WHEN TRIM(State) = '' THEN 1 ELSE 0 END) AS blank_state,
    SUM(CASE WHEN TRIM(City) = '' THEN 1 ELSE 0 END) AS blank_city,
    SUM(CASE WHEN TRIM(Product) = '' THEN 1 ELSE 0 END) AS blank_product,
    SUM(CASE WHEN TRIM(Sales_Method) = '' THEN 1 ELSE 0 END) AS blank_sales_method
FROM adidas_sales;

-- Step 11: Count exact duplicate records
SELECT COUNT(*) AS exact_duplicate_groups
FROM (
    SELECT
        Retailer,
        Retailer_ID,
        Invoice_Date,
        Region,
        State,
        City,
        Product,
        Price_per_Unit,
        Units_Sold,
        Operating_Profit,
        Operating_Margin,
        Sales_Method
    FROM adidas_sales
    GROUP BY
        Retailer,
        Retailer_ID,
        Invoice_Date,
        Region,
        State,
        City,
        Product,
        Price_per_Unit,
        Units_Sold,
        Operating_Profit,
        Operating_Margin,
        Sales_Method
    HAVING COUNT(*) > 1
) AS duplicates;

-- Step 12: Check the date range of sales records
SELECT
     MIN(Invoice_Date) AS first_invoice_date,
     MAX(Invoice_Date) AS last_invoice_date
FROM adidas_sales;

-- Step 13: Count sales records by year
SELECT
    YEAR(Invoice_Date) AS sales_year,
    COUNT(*) AS total_records
FROM adidas_sales
GROUP BY YEAR(Invoice_Date)
ORDER BY sales_year;



