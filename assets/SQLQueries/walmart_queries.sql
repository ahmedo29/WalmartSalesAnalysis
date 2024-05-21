-- Creating the database
CREATE DATABASE salesDataWalmart;

-- Creating the table
CREATE TABLE sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INTEGER NOT NULL,
    VAT FLOAT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    date DATE NOT NULL,
    time TIMESTAMP NOT NULL,
    payment_method DECIMAL(10,2) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_percentage FLOAT NOT NULL,
    gross_income DECIMAL(10,2) NOT NULL,
    rating FLOAT NOT NULL
);

SELECT
	Invoice_ID,
	Branch,
    City,
    Customer_type,
    Gender,
    Product_line,
    Unit_price,
    Quantity,
    VAT,
    Total,
    Date,
    Time,
    Payment_method,
    cogs,
    gross_margin_percentage,
    gross_income,
    Rating
FROM sales;

/*
	Feature Engineering
	Adding new columns which will help our analysis
	1. time_of_day
	2. day_name
	3. month_name
*/

-- 1.
SELECT
    time,
    (CASE
        WHEN CAST(time AS TIME) BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN CAST(time AS TIME) BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM sales;

-- 2.
SELECT
	date,
	DATENAME(dw, date) AS day_name
FROM sales
ORDER BY date;

-- 3.
SELECT
	date,
	DATENAME(month, date) as month_name
FROM sales;

-- Created a view with the added columns we need
CREATE VIEW sales_view AS 
SELECT
	Invoice_ID,
	Branch,
    City,
    Customer_type,
    Gender,
    Product_line,
    Unit_price,
    Quantity,
    VAT,
    Total,
    Date,
	DATENAME(dw, date) AS day_name,
	DATENAME(month, date) as month_name,
    Time,
	(CASE
        WHEN CAST(time AS TIME) BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN CAST(time AS TIME) BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day,
    Payment_method,
    cogs,
    gross_margin_percentage,
    gross_income,
    Rating
FROM sales;

/* 
	Exploratory Data Analysis (EDA)
	I will be answering a range of business questions using SQL statements
*/

SELECT *
FROM sales_view

-- Generic Questions
-- 1. How many unique cities does the data have?
SELECT
	DISTINCT city
FROM sales_view;

-- 2. Which city is each branch in?
SELECT
	DISTINCT city,
	branch
FROM sales_view;

-- Product Questions
-- 1. How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM sales_view;

-- 2. What is the most common payment method?
SELECT
	payment_method,
	COUNT(payment_method) AS number_of_times_used
FROM sales_view
GROUP BY payment_method;

-- 3. What is the most selling product line?
SELECT
	product_line,
	SUM(quantity) AS number_of_sales
FROM sales_view
GROUP BY product_line
ORDER BY number_of_sales DESC;

-- 4. What is the total revenue by month?
SELECT
	month_name,
	SUM(total) AS total_revenue
FROM sales_view
GROUP BY month_name
ORDER BY total_revenue DESC;

-- 5. What month had the largest COGS?
SELECT TOP (1)
	month_name,
	SUM(cogs) AS total_cogs
FROM sales_view
GROUP BY month_name
ORDER BY total_cogs DESC;

-- 6. What product line had the largest revenue
SELECT
	product_line,
	SUM(total) AS total_revenue
FROM sales_view
GROUP BY product_line
ORDER BY total_revenue DESC;

-- 7. What is the city with the largest revenue?
SELECT
	city,
	SUM(total) AS total_revenue
FROM sales_view
GROUP BY city
ORDER BY total_revenue DESC;

-- 8. What product line had the larges VAT?
SELECT
	product_line,
	ROUND(SUM(VAT),2) AS total_vat
FROM sales_view
GROUP BY product_line
ORDER BY total_vat DESC;

/* 9. Fetch each product line and add a column showing good if the sales > average sales
	and bad if the sales < average sales */
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales_view

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) >= 6 THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM sales_view
GROUP BY product_line;

-- 10. Which branch sold more products than average product sold?
SELECT
	branch,
	SUM(quantity) AS quantity_sold,
	AVG(quantity) AS avg_quantity_sold
FROM sales_view
GROUP BY branch;

-- 11. What is the most common product line by gender?
SELECT
	gender,
	product_line,
	COUNT(gender) AS total_count
FROM sales_view
GROUP BY gender, product_line
ORDER BY total_count DESC;

-- 12. What is the average rating on each product line?
SELECT
	product_line,
	ROUND(AVG(rating),2) AS avg_rating
FROM sales_view
GROUP BY product_line
ORDER BY avg_rating DESC;

-- SALES QUESTIONS
-- 1. Number of sales made in each time of the day per weekday
SELECT
	time_of_day,
	SUM(total) AS total_revenue
FROM sales_view
GROUP BY time_of_day
ORDER BY total_revenue DESC;

-- 2. Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales_view
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
	city,
	SUM(VAT) AS total_VAT
FROM sales_view
GROUP BY city
ORDER BY total_VAT DESC;

-- 4. Which customer type pays the most in VAT?
SELECT
	customer_type,
	SUM(VAT) AS total_vat
FROM sales_view
GROUP BY customer_type
ORDER BY total_vat DESC;

-- CUSTOMER QUESTIONS
-- 1. How many unique customer types does the data have?
SELECT
	COUNT(DISTINCT customer_type) AS unique_customer
FROM sales_view;

-- 2. How many unique payment methods does the data have?
SELECT
	COUNT(DISTINCT payment_method) AS unique_payment_methods
FROM sales_view

-- 3. What is the most common customer type?
SELECT
	customer_type,
	COUNT(customer_type) AS customers
FROM sales_view
GROUP BY customer_type
ORDER BY customers DESC;

-- 4. Which customer type buys the most?
SELECT
	customer_type,
	SUM(quantity) AS qty_bought,
	SUM(total) AS total_sales
FROM sales_view
GROUP BY customer_type
ORDER BY qty_bought DESC;

-- 5. What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) AS total_customers
FROM sales_view
GROUP BY gender;

-- 6. What is the gender distribution per branch?
SELECT
	branch,
	gender,
	COUNT(*) AS total_customers
FROM sales_view
GROUP BY branch, gender
ORDER BY branch;

-- 7. Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	ROUND(AVG(rating),2) AS avg_rating
FROM sales_view
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- 8. Which time of the day do customers give most ratings per branch?
SELECT
	branch,
	time_of_day,
	ROUND(AVG(rating),2) AS avg_rating
FROM sales_view
GROUP BY time_of_day, branch
ORDER BY branch;

-- 9. Which day of the week has the best avg ratings?
SELECT
	day_name,
	ROUND(AVG(rating),2) AS avg_rating
FROM sales_view
GROUP BY day_name
ORDER BY avg_rating DESC;

-- 10. Which day of the week has the best average ratings per branch?
SELECT
    branch,
    day_name,
    avg_rating
FROM (
    SELECT
        branch,
        day_name,
        ROUND(AVG(rating), 2) AS avg_rating,
        RANK() OVER (PARTITION BY branch ORDER BY ROUND(AVG(rating), 2) DESC) AS rank
    FROM sales_view
    GROUP BY branch, day_name
) AS ranked_ratings
WHERE rank = 1
ORDER BY branch;
