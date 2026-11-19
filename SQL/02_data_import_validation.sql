-- Step 1: Select the database
USE adidas_sales_db;

-- Step 2: Display the first 10 records
SELECT * FROM adidas_sales LIMIT 10;

-- Step 3: Count the total number of records
SELECT COUNT(*) AS total_records
FROM adidas_sales;

-- Step 4: Check the table structure
DESCRIBE adidas_sales;

-- Step 5: Verify column names and data types
DESCRIBE adidas_sales;

-- Step 6: current date format
-- Create new Column
ALTER TABLE adidas_sales
ADD COLUMN Invoice_Date_New DATE;

SET SQL_SAFE_UPDATES = 0;

-- Update value
UPDATE adidas_sales
SET Invoice_Date_New =str_to_date(Invoice_Date,'%d-%m-%Y');

-- Verify
SELECT Invoice_Date, Invoice_Date_New
FROM adidas_sales
LIMIT 10;
-- Original column replace 
ALTER TABLE adidas_sales
DROP COLUMN Invoice_Date;

ALTER TABLE adidas_sales
CHANGE COLUMN Invoice_Date_New Invoice_Date DATE;

-- verify
SELECT Invoice_Date FROM adidas_sales;


-- Step 7Update Data Types
ALTER TABLE adidas_sales
MODIFY COLUMN Retailer VARCHAR(100),
MODIFY COLUMN Retailer_ID INT,
MODIFY COLUMN Invoice_Date DATE,
MODIFY COLUMN Region VARCHAR(50),
MODIFY COLUMN State VARCHAR(100),
MODIFY COLUMN City VARCHAR(100),
MODIFY COLUMN Product VARCHAR(100),
MODIFY COLUMN Price_per_Unit DECIMAL(10,2),
MODIFY COLUMN Units_Sold INT,
MODIFY COLUMN Operating_Profit DECIMAL(12,2),
MODIFY COLUMN Operating_Margin DECIMAL(5,4),
MODIFY COLUMN Sales_Method VARCHAR(50);

