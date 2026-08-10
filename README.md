# E-Commerce Customer Lifecycle & RFM Segmentation Analytics

![Data Warehouse](https://img.shields.io/badge/Data_Warehouse-Google_BigQuery-4285F4?logo=googlecloud&logoColor=white)
![Data Analysis](https://img.shields.io/badge/Data_Analysis-Python_Colab-F9AB00?logo=googlecolab&logoColor=white)
![Visualization](https://img.shields.io/badge/Visualization-Tableau_Public-E97627?logo=tableau&logoColor=white)
[![SQL Engine](https://img.shields.io/badge/SQL-Standard_SQL-003B57?logo=sqlite&logoColor=white)](./sql)

An end-to-end data Marketing Analytics portfolio project processing **93,357 unique Brazilian e-commerce customers** and **R$ 15.42M in transaction value** (2016–2018). Implements a custom **Hybrid RFM Model**, rigorous **Python statistical distribution profiling**, and an **Executive Tableau Dashboard Suite** to solve high-churn e-commerce mechanics.

---

## Quick Links & Navigation
*  **Tableau Interactive Dashboard Suite:** [View Live on Tableau Public](https://public.tableau.com/app/profile/sam.rose.maria.selvam/viz/Dashboard-SegmentOverview/SegmentOverview) (1 out of 3 ongoing Tableau Analysis )
*  **Python Exploratory Notebook:** [`notebooks/Phase2_RFM_Statistical_Analysis.ipynb`](./notebooks)
*  **BigQuery SQL Data Pipeline:** [`sql/`](./sql)

---

##  Executive Summary & Key Business Highlights

E-commerce marketplaces often suffer from low repeat purchase rates and inefficient marketing spend when treating customer bases homogenously. This project engineered an end-to-end analytics solution to segment Olist's customer base, identify high-value churn risks, and maximize retention marketing ROI.

### Core Strategic Findings:
1. **The 97% Single-Buyer Trap:** Over 97% of Olist customers made only **1 purchase**. Converting just **5%** of the 61,422 buyers sitting in *Recent Customers* ($N=36,141$) and *Needs Attention* ($N=25,281$) into repeat buyers represents a higher ROI than cold acquisition.
2. **Protecting R$ 4.24M in "Can't Lose Them":** 13,786 customers spent heavily ($z_M = +0.82$) but lapsed into severe inactivity ($z_R = -1.04$). Reactivating this single group recovers **27.5% of total platform revenue**.
3. **Balanced Revenue Concentration (Pareto):** The top 20% of customers drive **~54% of cumulative revenue**. While lower than the classic 80/20 rule, it indicates a comparatively healthy revenue model not overly dependent on a tiny group of extreme whale accounts.


### Technical Architecture & Workflow:
1. **BigQuery Data Warehouse:** Multi-table schema joins, dynamic date anchoring, and hybrid SQL scoring tables.
2. **Python Statistical EDA:** Log-scale distribution fitting, orthogonality matrix, and Z-score standardized profiling.
3. **Tableau Executive Dashboards:** Dynamic KPI switching, segment fingerprint heatmaps, and interactive drill-downs.


## Hybrid RFM Scoring Methodology
Standard quantile binning (`NTILE(5)`) fails on e-commerce datasets with extreme frequency skew because SQL arbitrarily forces identical single-purchase records ($F=1$) into different buckets.

To solve this, a **Hybrid Scoring Framework** was engineered:

## $$\text{RFM Score} = \text{NTILE}_5(\text{Recency}) \quad \vert \quad \text{Rule-Based}(\text{Frequency}) \quad \vert \quad \text{NTILE}_5(\text{Monetary})$$

```sql
-- Frequency Hybrid Logic implemented in BigQuery SQL
CASE
  WHEN frequency = 1 THEN 1
  WHEN frequency = 2 THEN 2
  WHEN frequency = 3 THEN 3
  WHEN frequency BETWEEN 4 AND 5 THEN 4
  WHEN frequency >= 6 THEN 5
END AS frequency_score
```


## Statistical Exploratory Data Analysis (Python)

To ensure analytical rigor before building business dashboards, statistical distribution checks were executed in Python (`pandas`, `seaborn`, `matplotlib`, `scipy`).

### 1. Metric Orthogonality (Correlation Heatmap)
Computing Pearson correlation coefficients across $R, F,$ and $M$ confirmed near-zero linear dependence:
<img width="515" height="435" alt="CorrHeatmap" src="https://github.com/user-attachments/assets/ebd47db4-8e26-4048-b055-aacb80f60763" />
* $r(\text{Recency}, \text{Frequency}) = -0.022$
* $r(\text{Recency}, \text{Monetary}) = -0.0044$
* $r(\text{Frequency}, \text{Monetary}) = 0.12$

