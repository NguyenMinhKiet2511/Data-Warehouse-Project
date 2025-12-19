-- Find the date of first and last order --
-- Find how many year/month/day of sales are available
SELECT MIN(order_date) first_order_date, MAX(order_date) last_order_date,
DATEDIFF(day,MIN(order_date),MAX(order_date)) AS order_date_range
FROM gold.fact_sales
-- 29/12/2010 - 28/01/2014 --

-- Find the youngest and oldest customers --
SELECT MIN(birthdate) AS youngest_customer,
       DATEDIFF(year,MIN(birthdate),GETDATE()) AS youngest_age,
       MAX(birthdate) AS oldest_customer,
       DATEDIFF(year,MAX(birthdate),GETDATE()) AS oldest_age
FROM gold.dim_customers