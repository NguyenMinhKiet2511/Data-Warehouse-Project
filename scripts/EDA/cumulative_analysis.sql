SELECT
    order_date,
    total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
    avg_price,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM
(
    SELECT 
        DATEADD(year, DATEDIFF(year, 0, order_date), 0) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATEADD(year, DATEDIFF(year, 0, order_date), 0)
) t



