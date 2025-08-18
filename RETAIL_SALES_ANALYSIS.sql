--Database creation and table creation
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

--Data exploration and cleaning

--How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

--How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

--how many unique categories do we have?
SELECT DISTINCT category FROM retail_sales

--how many values do we have in our dataset and how to delete them?
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;


--data analysis and findings

--write a sql query to retrieve all columns for sales made on 2022-11-05.
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--retrieve all transactions where category is 'clothing' and the quantity sold is more than 4 in the month of nov-2022.
SELECT * FROM retail_sales
 	WHERE
 	category = 'Clothing'
 	AND
 	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
 	AND
 	quantity >= 4;


--query to calculate the total sales (total sales) for each category.
SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
	
--query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	ROUND(AVG(age), 2) as avg_date
FROM retail_sales
WHERE category = 'Beauty'

--query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000

--query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	category,
	gender,
COUNT(*) as total_trans
FROM retail_sales
GROUP BY 
	category,
	gender
ORDER BY 1

--query to calculate the average sale for each month. find out best selling month each year.
SELECT 
	year,
	month,
	avg_sale
FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT (MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale)DESC)
	FROM retail_sales
	GROUP BY 1,2
) as t1
WHERE rank = '1';
--ORDER BY 1,3 DESC

--query to find the top 5 customers based on the highest total sales.
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id) as unique_customers  
FROM retail_sales
GROUP BY category

--write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >12)
WITH Hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
		END as Shift
FROM retail_sales
)
SELECT 
	Shift,
	COUNT(*) as Total_orders
FROM Hourly_sale
GROUP BY Shift



SELECT EXTRACT(HOUR FROM CURRENT_TIME)





