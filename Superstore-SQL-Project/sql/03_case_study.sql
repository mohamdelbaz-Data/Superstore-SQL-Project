-- 1. Profit Margin 
SELECT 
    p.product_name,
    SUM(p.sales) AS revenue,
    SUM(p.profit) AS profit,
    ROUND(SUM(p.profit) / SUM(p.sales), 2) AS profit_margin
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY profit_margin DESC;


-- 2. Product With Lose Profit
SELECT 
    p.product_name,
    SUM(p.profit) AS total_profit
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
HAVING total_profit < 0
ORDER BY total_profit;


-- 3. Customer Segmentation
SELECT 
    customer_name,
    total_spent,
    CASE 
        WHEN total_spent > 5000 THEN 'VIP'
        WHEN total_spent > 2000 THEN 'Regular'
        ELSE 'Low'
    END AS segment
FROM (
    SELECT 
        c.customer_name,
        SUM(p.sales) AS total_spent
    FROM orders o
    JOIN customers c ON o.customer_name = c.customer_name
    JOIN products p ON o.product_id = p.product_id
    GROUP BY c.customer_name
) t;


-- 4. Top 3 Products per Category
SELECT *
FROM (
    SELECT 
        p.category,
        p.product_name,
        SUM(o.quantity) AS total_sold,
        RANK() OVER (
            PARTITION BY p.category
            ORDER BY SUM(o.quantity) DESC
        ) AS rnk
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.category, p.product_name
) t
WHERE rnk <= 3;


-- 5. Discount`s Effect ON Profit
SELECT 
    ROUND(o.discount,2) AS discount,
    SUM(p.profit) AS total_profit
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY discount
ORDER BY discount;


-- 6. Month-over-Month Growth
SELECT 
    month,
    revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS growth
FROM (
    SELECT 
        DATE_FORMAT(STR_TO_DATE(order_date, '%d/%m/%Y'), '%Y-%m') AS month,
        SUM(p.sales) AS revenue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY month
) t;

