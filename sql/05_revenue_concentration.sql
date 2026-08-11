-- ================================================
-- OLIST RFM ANALYSIS: REVENUE CONCENTRATION
-- Revenue Overview
-- ================================================

SELECT
  customer_segment,
  COUNT(*) AS customer_count,
  ROUND(SUM(monetary), 2) AS total_revenue,
  ROUND(SUM(monetary) / SUM(SUM(monetary)) OVER () * 100, 2) AS revenue_pct,
  ROUND(AVG(monetary), 2) AS avg_spend_per_customer
FROM `olist_data.customer_segments`
GROUP BY customer_segment
ORDER BY total_revenue DESC;
