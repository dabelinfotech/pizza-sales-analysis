-- =============================================================
-- Pizza Sales Analysis — SQL Queries
-- Source table: pizza_sales (loaded from pizza_sales.csv)
-- Note: order_date is stored as DD-MM-YYYY text. Adjust the date
--       parsing (STR_TO_DATE / CONVERT / TO_DATE) to your engine.
--       Examples below use MySQL syntax.
-- =============================================================


-- =============================================================
-- A. KEY PERFORMANCE INDICATORS (KPIs)
-- =============================================================

-- 1. Total Revenue
SELECT ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales;

-- 2. Average Order Value
SELECT ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM pizza_sales;

-- 3. Total Pizzas Sold
SELECT SUM(quantity) AS total_pizzas_sold
FROM pizza_sales;

-- 4. Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales;

-- 5. Average Pizzas Per Order
SELECT ROUND(SUM(quantity) / COUNT(DISTINCT order_id), 2) AS avg_pizzas_per_order
FROM pizza_sales;


-- =============================================================
-- B. CHART QUERIES
-- =============================================================

-- 1. Daily Trend for Total Orders (orders by day of week)
SELECT
    DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_day,
    COUNT(DISTINCT order_id)                     AS total_orders
FROM pizza_sales
GROUP BY DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y')),
         DAYOFWEEK(STR_TO_DATE(order_date, '%d-%m-%Y'))
ORDER BY DAYOFWEEK(STR_TO_DATE(order_date, '%d-%m-%Y'));

-- 2. Monthly Trend for Total Orders
SELECT
    MONTHNAME(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_month,
    COUNT(DISTINCT order_id)                       AS total_orders
FROM pizza_sales
GROUP BY MONTHNAME(STR_TO_DATE(order_date, '%d-%m-%Y')),
         MONTH(STR_TO_DATE(order_date, '%d-%m-%Y'))
ORDER BY MONTH(STR_TO_DATE(order_date, '%d-%m-%Y'));

-- 2b. Hourly Trend for Total Orders (peak hours)
SELECT
    HOUR(order_time)         AS order_hour,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY HOUR(order_time)
ORDER BY order_hour;

-- 3. Percentage of Sales by Pizza Category
SELECT
    pizza_category,
    ROUND(SUM(total_price), 2)                                   AS total_revenue,
    ROUND(SUM(total_price) * 100.0 /
        (SELECT SUM(total_price) FROM pizza_sales), 2)           AS pct_of_total_sales
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_revenue DESC;

-- 4. Percentage of Sales by Pizza Size
SELECT
    pizza_size,
    ROUND(SUM(total_price), 2)                                   AS total_revenue,
    ROUND(SUM(total_price) * 100.0 /
        (SELECT SUM(total_price) FROM pizza_sales), 2)           AS pct_of_total_sales
FROM pizza_sales
GROUP BY pizza_size
ORDER BY total_revenue DESC;

-- 5. Total Pizzas Sold by Category
SELECT
    pizza_category,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_pizzas_sold DESC;


-- =============================================================
-- C. TOP / BOTTOM SELLERS
-- =============================================================

-- Top 5 pizzas by Revenue
SELECT pizza_name, ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Bottom 5 pizzas by Revenue
SELECT pizza_name, ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue ASC
LIMIT 5;

-- Top 5 pizzas by Quantity
SELECT pizza_name, SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity DESC
LIMIT 5;

-- Bottom 5 pizzas by Quantity
SELECT pizza_name, SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity ASC
LIMIT 5;

-- Top 5 pizzas by Total Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders DESC
LIMIT 5;

-- Bottom 5 pizzas by Total Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders ASC
LIMIT 5;
