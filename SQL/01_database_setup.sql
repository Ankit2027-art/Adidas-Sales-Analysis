-- Adidas Sales Analysis Project

-- Step 1: Create Database
CREATE DATABASE IF NOT EXISTS adidas_sales_db;

-- Step 2: Select Database
USE adidas_sales_db;

-- Step 3: Verify Selected Database
SELECT DATABASE();

-- Step 4: Import the CSV Dataset

-- Import the adidas_sales.csv file using the Table Data Import Wizard in MySQL Workbench.
-- 1. Expand adidas_sales_db under SCHEMAS.
-- 2. Right-click the database and select Table Data Import Wizard.
-- 3. Select your CSV file.
-- 4. Choose to create a new table named adidas_sales.
-- 5. Review the column names and data types.
-- 6. Complete the import.


-- Step 5: Verify the Datsaset
show tables;