-- Top 5 product generate highest revenue --
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_rev
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p 
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_rev DESC

-- Using window function --
-- Using subquery --
SELECT *
FROM (
    SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_rev,
    RANK() OVER(ORDER BY SUM(f.sales_amount) DESC) AS rank_product
    FROM gold.fact_sales f 
    LEFT JOIN gold.dim_products p 
    ON f.product_key = p.product_key
    GROUP BY p.product_name
)t WHERE rank_product <=5



-- Top 5 product generate lowest revenue --
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_rev
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p 
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_rev ASC

-- Find top 10 customers who have generated highest revenue --

SELECT TOP 10
c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_rev
FROM gold.fact_sales f 
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_rev DESC


SELECT * 
FROM(
    SELECT 
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_rev,
    ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_customers
    FROM gold.fact_sales f 
    LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
    GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name)t 
WHERE rank_customers <= 10

-- Find top 3 customers who have generated fewest order --
SELECT TOP 3
c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT order_number) AS total_order
FROM gold.fact_sales f 
LEFT JOIN gold.dim_customers c
ON  c.customer_key = f.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_order 