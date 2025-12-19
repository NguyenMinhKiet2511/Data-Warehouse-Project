-- Explore all countries customers come from --
SELECT DISTINCT country FROM gold.dim_customers
--> 6 different countries

-- Explore all categories "The major division" --
SELECT DISTINCT category,subcategory,product_name FROM gold.dim_products
ORDER BY 1,2,3
--> 4 different categories, 36 subcategories, 295 products

