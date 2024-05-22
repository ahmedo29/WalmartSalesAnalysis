# WalmartSalesAnalysis

This project aims to explore the Walmart Sales data to understand top performing branches and products, sales trend of of different products, customer behaviour. The aims is to study how sales strategies can be improved and optimized. The dataset was obtained from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting).

## Purposes Of The Project

The major aim of thie project is to gain insight into the sales data of Walmart to understand the different factors that affect sales of the different branches.

## About Data

The dataset was obtained from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting). This dataset contains sales transactions from a three different branches of Walmart, respectively located in Mandalay, Yangon and Naypyitaw. The data contains 17 columns and 1000 rows:

| Column                  | Description                             | Data Type      |
| :---------------------- | :-------------------------------------- | :------------- |
| invoice_id              | Invoice of the sales made               | VARCHAR(30)    |
| branch                  | Branch at which sales were made         | VARCHAR(5)     |
| city                    | The location of the branch              | VARCHAR(30)    |
| customer_type           | The type of the customer                | VARCHAR(30)    |
| gender                  | Gender of the customer making purchase  | VARCHAR(10)    |
| product_line            | Product line of the product solf        | VARCHAR(100)   |
| unit_price              | The price of each product               | DECIMAL(10, 2) |
| quantity                | The amount of the product sold          | INT            |
| VAT                 | The amount of tax on the purchase       | FLOAT(6, 4)    |
| total                   | The total cost of the purchase          | DECIMAL(10, 2) |
| date                    | The date on which the purchase was made | DATE           |
| time                    | The time at which the purchase was made | TIMESTAMP      |
| payment_method                 | The total amount paid                   | DECIMAL(10, 2) |
| cogs                    | Cost Of Goods sold                      | DECIMAL(10, 2) |
| gross_margin_percentage | Gross margin percentage                 | FLOAT(11, 9)   |
| gross_income            | Gross Income                            | DECIMAL(10, 2) |
| rating                  | Rating                                  | FLOAT(2, 1)    |

### Analysis List

1. Product Analysis

> Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines that need to be improved.

2. Sales Analysis

> This analysis aims to answer the question of the sales trends of product. The result of this can help use measure the effectiveness of each sales strategy the business applies and what modificatoins are needed to gain more sales.

3. Customer Analysis

> This analysis aims to uncover the different customers segments, purchase trends and the profitability of each customer segment.

## Approach Used

1. **Data Wrangling:** This is the first step where inspection of data is done to make sure **NULL** values and missing values are detected and data replacement methods are used to replace, missing or **NULL** values.

> 1. Build a database
> 2. Create table and insert the data.
> 3. Select columns with null values in them. There are no null values in our database as in creating the tables, we set **NOT NULL** for each field, hence null values are filtered out.

2. **Feature Engineering:** This will help use generate some new columns from existing ones.

> 1. Add a new column named `time_of_day` to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.

> 2. Add a new column named `day_name` that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.

> 3. Add a new column named `month_name` that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.

2. **Exploratory Data Analysis (EDA):** Exploratory data analysis is done to answer the listed questions and aims of this project.

3. **Conclusion:**

## Business Questions To Answer

### Generic Question

1. How many unique cities does the data have?
2. In which city is each branch?

### Product

1. How many unique product lines does the data have?
2. What is the most common payment method?
3. What is the most selling product line?
4. What is the total revenue by month?
5. What month had the largest COGS?
6. What product line had the largest revenue?
5. What is the city with the largest revenue?
6. What product line had the largest VAT?
7. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
8. Which branch sold more products than average product sold?
9. What is the most common product line by gender?
12. What is the average rating of each product line?

### Sales

1. Number of sales made in each time of the day per weekday
2. Which of the customer types brings the most revenue?
3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
4. Which customer type pays the most in VAT?

### Customer

1. How many unique customer types does the data have?
2. How many unique payment methods does the data have?
3. What is the most common customer type?
4. Which customer type buys the most?
5. What is the gender of most of the customers?
6. What is the gender distribution per branch?
7. Which time of the day do customers give most ratings?
8. Which time of the day do customers give most ratings per branch?
9. Which day fo the week has the best avg ratings?
10. Which day of the week has the best average ratings per branch?

## Code

## Data Wrangling

```sql
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

```

## Feature Engineering

```sql
*
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

```

## Creating the view

```sql
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

```

## Exploratory Data Analysis (EDA)

```sql
*/ 
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

```
