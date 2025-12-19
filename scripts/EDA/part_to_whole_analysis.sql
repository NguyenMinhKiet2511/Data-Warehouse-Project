--Which categories contribute the most to overall sale--
WITH category_sale AS (
SELECT 
p.category,
SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p 
ON f.product_key = p.product_key
GROUP BY p.category)

SELECT 
category,
total_sales,
SUM(total_sales) OVER() AS over_sales,
CONCAT(ROUND((CAST(total_sales AS float) / SUM(total_sales) OVER())*100,2),'%') AS percent_of_total
FROM category_sale
ORDER BY total_sales DESC

