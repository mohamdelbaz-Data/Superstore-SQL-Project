-- 1. Best Customers Total Spent 
SELECT 
    c.customer_name,
    SUM(p.sales) AS total_spent
FROM orders o
JOIN customers c ON o.customer_name = c.customer_name
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;


-- 2. Sales by Country & Region 
SELECT 
    c.country,
    c.region,
    SUM(p.sales) AS total_sales
FROM orders o
JOIN customers c ON o.customer_name = c.customer_name
JOIN products p ON o.product_id = p.product_id
GROUP BY c.country, c.region
ORDER BY total_sales DESC;


-- 3. Top Product by Category (RANK) 
SELECT 
    p.category,
    p.product_name,
    SUM(o.quantity) AS total_sold,
    RANK() OVER (
        PARTITION BY p.category 
        ORDER BY SUM(o.quantity) DESC
    ) AS rank_in_category
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category, p.product_name;


-- 4. Running Total For Sales
SELECT 
    o.order_date,
    SUM(p.sales) AS daily_sales,
    SUM(SUM(p.sales)) OVER (
        ORDER BY o.order_date
    ) AS running_total
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY o.order_date;


-- 5. Products by Sales Above AVG
SELECT product_name, total_sales
FROM (
    SELECT 
        p.product_name,
        SUM(p.sales) AS total_sales
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.product_name
) t
WHERE total_sales > (
    SELECT AVG(total_sales) 
    FROM (
        SELECT SUM(p.sales) AS total_sales
        FROM orders o
        JOIN products p ON o.product_id = p.product_id
        GROUP BY p.product_name
    ) x
);


-- Business Insight
-- 6. Top 1 Month by Sales
SELECT 
    DATE_FORMAT(STR_TO_DATE(order_date, '%d/%m/%Y'), '%Y-%m') AS month,
    SUM(p.sales) AS total_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY month
ORDER BY total_sales DESC
LIMIT 1;


-- 7. Top 1 Product by Profit
SELECT 
    p.category,
    SUM(p.profit) AS total_profit
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_profit DESC;

