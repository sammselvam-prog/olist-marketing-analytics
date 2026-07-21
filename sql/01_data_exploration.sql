-- ================================================
-- OLIST RFM ANALYSIS: DATA EXPLORATION
-- Author: Sam Rose Maria Selvam
-- Dataset: Olist Brazilian E-Commerce (BigQuery)
-- ================================================

-- 1. Total number of  customers
SELECT COUNT(*) AS total_customers
FROM `olist_data.customers`;

-- 2. Total revenue across all payments
SELECT ROUND(SUM(payment_value), 2) AS total_revenue
FROM `olist_data.order_payments`;

-- 3. Average, highest and lowest payment value
SELECT
  ROUND(AVG(payment_value), 2) AS avg_payment,
  ROUND(MAX(payment_value), 2) AS highest_single_payment,
  ROUND(MIN(payment_value), 2) AS least_single_payment
FROM `olist_data.order_payments`
WHERE payment_value > 0;

-- 4. Order status distribution
SELECT order_status, COUNT(*) AS order_count
FROM `olist_data.orders`
GROUP BY order_status
ORDER BY order_count DESC;

-- 5. Last order date in the dataset (for RFM reference)
SELECT MAX(DATE(order_purchase_timestamp)) AS last_delivered_date
FROM `olist.data.orders`;

-- 6. Orders per customer using customer_unique_id
SELECT
  c.customer_unique_id,
  COUNT(o.order_id) AS total_orders
FROM `olist_data.orders` o
JOIN `olist_data.customers` c
  ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC
LIMIT 10;

-- 7. Verifying LEFT JOIN vs INNER JOIN on customers and orders
-- Both return 96096 confirming no customers without orders
SELECT COUNT(DISTINCT c.customer_unique_id) AS total_customers_inner
FROM `olist_data.customers` c
JOIN `olist_data.orders` o
  ON c.customer_id = o.customer_id;

SELECT COUNT(DISTINCT c.customer_unique_id) AS total_customers_left
FROM `olist_data.customers` c
LEFT JOIN `olist_data.orders` o
  ON c.customer_id = o.customer_id;
