-- ================================================
-- OLIST RFM ANALYSIS: SANITY CHECK(Segment Dsitribution)
-- Verifies no segment dominates or is too small
-- ================================================

SELECT 
      customer_segment,
      COUNT(*)AS customer_count,
      ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total,
      ROUND(AVG(recency_days), 2) AS average_recency,
      ROUND(AVG(frequency), 2) AS average_frequency,
      ROUND(AVG(monetary), 2) AS average_monetary
FROM `olist_data.customer_segments`
GROUP BY customer_segment
ORDER BY customer_count DESC;
