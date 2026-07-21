-- ================================================
-- OLIST RFM ANALYSIS: RFM BASE VIEW
-- Calculates Recency, Frequency, Monetary per customer
-- Reference date: 2018-10-17 (last order in dataset)
-- Filtered to delivered orders only
-- Note: customer_unique_id used instead of customer_id
-- because Olist assigns new customer_id per order
-- ================================================

CREATE OR REPLACE VIEW `olist_data.rfm_base` AS
SELECT
  c.customer_unique_id,
  MAX(DATE(o.order_purchase_timestamp)) AS last_purchase_date,
  DATE_DIFF(DATE('2018-10-17'), MAX(DATE(o.order_purchase_timestamp)), DAY) AS recency_days,
  COUNT(DISTINCT o.order_id) AS frequency,
  ROUND(SUM(p.payment_value), 2) AS monetary
FROM `olist_data.customers` c
LEFT JOIN `olist_data.orders` o
  ON c.customer_id = o.customer_id
LEFT JOIN `olist_data.order_payments` p
  ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id;
