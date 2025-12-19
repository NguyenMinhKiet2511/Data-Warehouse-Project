--Segment products into cost ranges and count how many product fall into each segment--

WITH product_segment AS (
    SELECT 
    product_key,
    product_name,
    cost,
    CASE 
        WHEN cost < 100 THEN 'Below 100'
        WHEN cost BETWEEN 100 AND 500 THEN '100-500'
        WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
        ELSE 'Above 1000'
    END AS cost_range
    FROM gold.dim_products
)

SELECT 
cost_range,
COUNT(cost_range) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH customer_segment AS (
SELECT 
c.customer_key,
SUM(f.sales_amount) AS total_spending,
MAX(f.order_date) AS first_order,
MIN(f.order_date) AS last_order,
DATEDIFF(month,MIN(f.order_date),MAX(f.order_date)) AS lifespan,
CASE
    WHEN DATEDIFF(month,MIN(f.order_date),MAX(f.order_date)) >= 12 AND SUM(f.sales_amount) > 5000 THEN 'VIP'
    WHEN DATEDIFF(month,MIN(f.order_date),MAX(f.order_date)) >= 12 AND SUM(f.sales_amount) <= 5000 THEN 'Regular'
    ELSE 'New'
END AS customer_type
FROM gold.fact_sales f 
LEFT JOIN gold.dim_customers c 
ON f.customer_key = c.customer_key
GROUP BY c.customer_key)

SELECT 
customer_type,
COUNT(customer_type) AS total_customers
FROM customer_segment
GROUP BY customer_type
ORDER BY COUNT(customer_type) DESC