-- 1. Total Sales & Profit
SELECT 
    SUM(p.sales) AS total_sales,
    SUM(p.profit) AS total_profit
FROM orders o
JOIN products p ON o.product_id = p.product_id;


-- 2. Sales by Category
SELECT 
    p.category,
    SUM(p.sales) AS total_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;


-- 3. Top 10 Products
SELECT 
    p.product_name,
    SUM(o.quantity) AS total_quantity
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 10;


