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

## Customer Segmentation Rules(Hierarchical RFM)

To translate behavioral analytics into business strategy, customers were classified into distinct risk and loyalty segments using a Hierarchical CASE Evaluation in SQL.

  +--------------------------------------------------------------------------+
  
  |                   Hierarchical Segment Progression                       |
  
  +--------------------------------------------------------------------------+
  
  | [1] Champions         --> R >= 4, F >= 3, M >= 4                         |
  
  | [2] Loyal Customers   --> R >= 3, F >= 2                                 |
  
  | [3] Recent Customers  --> R >= 4, F == 1                                 |
  
  | [4] At Risk           --> R <= 2, F >= 2                                 |
  
  | [5] Can't Lose Them   --> R <= 2, F == 1, M >= 4                         |
  
  | [6] Lost              --> R <= 2, F == 1, M <= 2                         |
  
  | [7] Needs Attention   --> Default (Fallback Segment)                     |
  
  +--------------------------------------------------------------------------+

## Statistical Exploratory Data Analysis (Python)

To ensure analytical rigor before building business dashboards, statistical distribution checks were executed in Python (`pandas`, `seaborn`, `matplotlib`, `scipy`).

### 1. Metric Orthogonality (Correlation Heatmap)
Computing Pearson correlation coefficients across $R, F,$ and $M$ confirmed near-zero linear dependence:
<img width="450" height="300" alt="CorrHeatmap" src="https://github.com/user-attachments/assets/ebd47db4-8e26-4048-b055-aacb80f60763" />
* $r(\text{Recency}, \text{Frequency}) = -0.022$
* $r(\text{Recency}, \text{Monetary}) = -0.0044$
* $r(\text{Frequency}, \text{Monetary}) = 0.12$

> **Key Finding:** The three dimensions are **statistically orthogonal**, proving that Recency, Frequency, and Monetary metrics capture completely non-redundant behavioral signals.

### 2. Distribution Profiling & Transformations
<p float="left">
<img width="300" height="250" alt="Monetary Log Dist(Hist)" src="https://github.com/user-attachments/assets/e8c9208a-9376-4371-a3b3-702bbe1d73fe" />
<img width="300" height="250" alt="Recency Dist(Hist)" src="https://github.com/user-attachments/assets/98da168b-7498-4b53-b8f2-719cc9c038f9" /> 
<img width="300" height="250" alt="Frequency Dist(Hist)" src="https://github.com/user-attachments/assets/a7710572-7d0e-4daa-8b24-07f2037f4176" />
  </p>

* **Monetary ($M$):** Highly right-skewed on raw scale with outliers exceeding $R\$ 10,000$. Applying a $\log_{10}$ transformation revealed a pristine **Log-Normal distribution** centered at the median of $R\$ 108$.
* **Recency ($R$):** Right-skewed distribution with a primary peak at 50–100 days and a secondary promotional acquisition peak at 300–350 days ($Median = 267\text{ days}$).
* **Frequency ($F$):** Extreme point-mass distribution at $F=1$ ($>97\%$).

### 3. Z-Score Segment Fingerprinting

<img width="450" height="300" alt="Segment Fingerprint Heatmap" src="https://github.com/user-attachments/assets/7efb3c4e-ca55-44b5-bfe8-f326b1b2a797" />


Standardizing RFM scores ($z = \frac{x - \mu}{\sigma}$) isolates distinct behavioral profiles across segments:
* **Champions ($z_F = +2.04, z_R = +1.23, z_M = +1.14$):** Exceptional repeat purchase frequency; highest value anchor.
* **Can't Lose Them ($z_M = +0.82, z_R = -1.04, z_F = -0.76$):** High monetary spend paired with severe recency lapse.
* **Lost ($z_M = -1.92, z_R = -1.05, z_F = -0.76$):** Lowest monetary score; candidate for budget suppression.

### 4. Marketing Action Quadrants (Recency vs. Monetary)
<img width="600" height="350" alt="Recency vs Monetary(Qaudrant plot)" src="https://github.com/user-attachments/assets/042c5dc2-1ede-4117-a559-1701110c9b9b" />

* **Protect Zone(Recent & High Spend):** High priority retention; line of defense against competitor poaching.
* **Win-Back Zone (Lapsed & High-Spend):** Highest financial upside per marketing dollar spent ($R\$ 4.24\text{M}$ locked).
* **Grow Zone (Recent & Low-Spend):** Onboarding focus to expand basket size and order frequency.
* **Deprioritize Zone (Lapsed & Low-Spend):** Minimal marketing allocation; low customer lifetime value.

## Tableau Dashboard Suite Progress Tracker
  **Interactive Tableau Workbook:** [Access Dashboard Story](https://public.tableau.com/app/profile/sam.rose.maria.selvam/viz/Dashboard-SegmentOverview/SegmentOverview)

* **Dashboard 1: Customer Segment Overview**(Completed✅)
  
  Executive view showing macro KPIs (93k users, R$15.42M revenue), segment volume distribution, dynamic metric switching, and Segment Fingerprint scores.
* **Dashboard 2: Revenue Concentration & Pareto Analysis**(In Progress🔄)
  
  Interactive Pareto curves and cumulative spend distribution across customer tiers.
* **Dashboard 3: Order Trends & Temporal Dynamics** (Planned)


## Reproduction Steps
* **BigQuery Integration:** Execute scripts ``` 01_data_exploration.sql ``` through ``` 05_revenue_concentration.sql ```
* **Python Analysis:** Run ``` notebooks/Phase2_RFM_Statistical_Analysis.ipynb ``` in Colab or Jupyter to generate statistical distribution models, heatmaps, and Z-score tables.
* **Tableau Public:** Connect the processed ``` olist_data.customer_segments ``` table to Tableau to interact with the executive dashboard suite.

### Built with:
BigQuery, Python(Colab), Tableau

### Author
Sam Rose M

Data Analyst
