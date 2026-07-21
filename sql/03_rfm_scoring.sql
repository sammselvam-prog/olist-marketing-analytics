-- ===================================================================
-- OLIST RFM ANALYSIS: RFM SCORING
-- Scores each customer 1-5 on R, F, M using NTILE(5) and rule-based
-- Recency: lower days = better = higher score 
-- Frequency: higher orders = better = higher score 
-- Monetary: higher spend = better = higher score 
-- Using 'customer_unique_id ASC' as a tie-breaker
-- ===================================================================

CREATE OR REPLACE TABLE `olist_data.rfm_scores` AS
WITH rfm_raw AS (
  SELECT * FROM `olist_data.rfm_base`
  WHERE monetary IS NOT NULL AND monetary > 0 AND recency_days IS NOT NULL
),
rfm_scored AS (
  SELECT
    customer_unique_id,
    recency_days,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency_days DESC, customer_unique_id) AS recency_score,
    -- Rule-based frequency scoring: 97% of customers share frequency=1,
    -- so NTILE's equal-bucket logic produced meaningless splits.
    -- Thresholds set from actual distribution (see freq distribution query).
    CASE
      WHEN frequency = 1 THEN 1
      WHEN frequency = 2 THEN 2
      WHEN frequency = 3 THEN 3
      WHEN frequency BETWEEN 4 AND 5 THEN 4
      WHEN frequency >= 6 THEN 5
    END AS frequency_score,
    NTILE(5) OVER (ORDER BY monetary ASC, customer_unique_id) AS monetary_score
  FROM rfm_raw
)
SELECT
  *,
  (recency_score + frequency_score + monetary_score) AS rfm_total,
  CASE
    WHEN recency_score >= 4 AND frequency_score >= 3 AND monetary_score >= 4 THEN 'Champions'
    WHEN recency_score >= 3 AND frequency_score >= 2 THEN 'Loyal Customers'
    WHEN recency_score >= 4 AND frequency_score = 1 THEN 'Recent Customers'
    WHEN recency_score <= 2 AND frequency_score >= 2 THEN 'At Risk'
    WHEN recency_score <= 2 AND frequency_score = 1 AND monetary_score >= 4 THEN "Can't Lose Them"
    WHEN recency_score <= 2 AND frequency_score = 1 AND monetary_score <= 2 THEN 'Lost'
    ELSE 'Needs Attention'
  END AS customer_segment
FROM rfm_scored;

ALTER TABLE `olist_data.customer_segments`
ALTER COLUMN customer_segment SET OPTIONS(description="Rule-based RFM segment derived from recency/frequency/monetary score thresholds. See dbt model docs for full CASE logic.");

ALTER TABLE `olist_data.customer_segments`
ALTER COLUMN rfm_total SET OPTIONS(description="Sum of recency, frequency, and monetary scores (range 3-15). Used for intra-segment ranking and as an alternate score-based segmentation method.");

