-- ================================================
-- OLIST RFM ANALYSIS: RFM SCORING
-- Scores each customer 1-5 on R, F, M using NTILE(5)
-- Recency: lower days = better = higher score 
-- Frequency: higher orders = better = higher score 
-- Monetary: higher spend = better = higher score 
-- Using 'customer_unique_id ASC' as a tie-breaker
-- ================================================

CREATE OR REPLACE TABLE `olist_data.rfm_scores` AS
WITH rfm_raw AS (
  SELECT * FROM `olist_data.rfm_base`
  WHERE monetary IS NOT NULL AND monetary > 0 AND recency_days IS NOT NULL
)
SELECT
  customer_unique_id,
  recency_days,
  frequency,
  monetary,
  NTILE(5) OVER (ORDER BY recency_days DESC, customer_unique_id) AS recency_score,
  NTILE(5) OVER (ORDER BY frequency ASC, customer_unique_id) AS frequency_score,
  NTILE(5) OVER (ORDER BY monetary ASC, customer_unique_id) AS monetary_score
FROM rfm_raw;
