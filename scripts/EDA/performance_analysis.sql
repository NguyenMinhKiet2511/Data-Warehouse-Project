/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

-- Create temporary table --
WITH yearly_product_sale AS (
    SELECT 
    YEAR(f.order_date) AS order_year,
    p.product_name,
    SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p 
    ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY YEAR(f.order_date),p.product_name
)

SELECT 
    order_year,
    product_name,
    current_sales,
    -- Comparing each year’s sales to the product’s average sales--
    AVG(current_sales) OVER (PARTITION BY product_name) AS average_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS average_diff,
    CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0
         THEN 'Above_Average'
         WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0
         THEN 'Below_Average'
         ELSE 'Average'
    END AS average_change,

    -- Comparing each year’s sales to the previous year --
    -- LAG(): access value of previous row --
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS pre_sales,
    current_sales -  LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS yearly_sales_diff,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS sale_change

FROM yearly_product_sale