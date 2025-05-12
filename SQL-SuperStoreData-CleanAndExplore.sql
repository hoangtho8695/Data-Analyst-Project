SELECT *
FROM store_sales;

ALTER TABLE store_sales 
MODIFY COLUMN Order_Date DATE;
UPDATE store_sales
SET Order_date = STR_TO_DATE(Order_Date, '%Y-%m-%d');

ALTER TABLE store_sales 
MODIFY COLUMN Ship_Date DATE;
UPDATE store_sales
SET ship_date = STR_TO_DATE(ship_Date, '%d/%m/%Y');

ALTER TABLE store_sales
ADD COLUMN order_month TEXT,
ADD COLUMN order_year INT,
ADD COLUMN ship_month TEXT,
ADD COLUMN ship_year INT;

UPDATE store_sales
SET
	order_month_text = LEFT(MONTHNAME(order_date),3),
    order_year = YEAR(order_date),
    ship_month_text = LEFT(MONTHNAME(ship_date),3),
    ship_year = YEAR(ship_date);

ALTER TABLE store_sales
ADD COLUMN month_order_num INT;
UPDATE store_sales
SET month_order_num = MONTH(Order_Date);

ALTER TABLE store_sales
ADD COLUMN month_ship_num INT;
UPDATE store_sales
SET month_ship_num = MONTH(ship_Date);

-- Data Exploration
-- Segment-based

-- How customer, corparate and home office compare in total sales
SELECT
  segment,
  COUNT(*) AS total_orders,
  ROUND(SUM(sales),2) AS total_sales
FROM store_sales
GROUP BY segment;

-- Most purchased product in each category
SELECT
    Category,
    Product_Name,
    ROUND(total_sales, 2) AS total_sales
FROM (
    SELECT 
        Category,
        Product_Name,
        SUM(Sales) AS total_sales,
        ROW_NUMBER() OVER(PARTITION BY Category ORDER BY SUM(Sales) DESC) AS ranked
    FROM store_sales
    GROUP BY Category, Product_Name
) AS sub
WHERE ranked = 1;

--  Sales growth over time in general
SELECT
  DATE_FORMAT(Order_date, '%Y-%m') AS month_total,
  ROUND(SUM(Sales), 2) AS total_sales
FROM store_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month_total DESC;

-- Most sales in each state
SELECT
	Country,
    State,
    City,
    ROUND(total_sales, 2) AS total_sales
FROM (
    SELECT 
		country,
        state,
        city,
        SUM(Sales) AS total_sales,
        ROW_NUMBER() OVER(PARTITION BY state ORDER BY SUM(Sales) DESC) AS ranked
    FROM store_sales
    GROUP BY state,country, city
) AS sub
WHERE ranked = 1
ORDER BY total_sales DESC
LIMIT 20;

-- Average sales per region
SELECT
	region,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales),2) as total_region_sales,
    ROUND(AVG(sales),2) as avg_region_sales_value
FROM store_sales
GROUP BY Region
ORDER BY total_orders DESC;

-- Most common shipping mode
SELECT
	region,
    ship_mode,
    COUNT(*) As total_orders
FROM store_sales
GROUP BY region, ship_mode
ORDER BY total_orders DESC;

-- Average sales per shipping mode by region
SELECT
	region,
    ship_mode,
    COUNT(*) AS total_orders,
    ROUND(AVG(Sales),2) as avg_sales
FROM store_sales
GROUP BY Region, Ship_Mode
ORDER BY region, Ship_Mode, avg_sales DESC;