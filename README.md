# WalmartSalesAnalysis
Project Overview This project analyses Walmart's weekly sales data across 45 stores from 2010 to 2012 using SQL Server. The goal was to uncover how store performance, pricing, and macroeconomic indicators like inflation and unemployment relate to retail sales — a period of particular interest given the post-2008 financial recovery context.

Dataset
Source: Kaggle — Walmart Sales Forecasting Dataset
Key columns:

Store — Store number (1–45)
Date — Week of sales
Weekly_Sales — Total sales for that store and week
Holiday_Flag — 1 if the week contains a major holiday
Temperature — Regional temperature
Fuel_Price — Regional fuel price
CPI — Consumer Price Index (inflation indicator)
Unemployment — Regional unemployment rate


Data Cleaning Decisions
Before loading the data into SQL Server, the following cleaning steps were applied:

21 rows dropped due to null values in economic indicator columns (Temperature, CPI, Fuel Price, Unemployment). This represented less than 0.5% of the dataset and was deemed negligible for analysis.

Unemployment data noted to vary weekly, likely interpolated from monthly regional reports. Values were used as a relative indicator of local economic conditions rather than precise measurements.
CPI used as an inflation proxy — averaged by month across all stores to track inflation trends over time.


**Queries & Analysis**
**1. Which stores generate the most revenue?**
Aggregates total weekly sales by store and ranks them highest to lowest.
Skills: SUM, GROUP BY, ORDER BY

**2. How do holiday weeks impact sales?**
Compares average weekly sales during holiday vs non-holiday weeks across all stores.
Skills: AVG, CASE WHEN, GROUP BY

**3. Fuel price impact on sales**
Stores were grouped into fuel price tiers (Cheap, Mid, Expensive) using the 25th and 75th percentile as thresholds. Average weekly sales were compared across tiers to assess whether higher fuel costs correlate with lower consumer spending.
Skills: PERCENTILE_CONT, CROSS JOIN, CTEs, CASE WHEN

**4. Month over month sales growth**
Tracks total monthly sales across all stores and calculates month over month growth percentage to identify seasonal trends and sales trajectory over the 2010–2012 period.
Skills: YEAR(), MONTH(), LAG(), window functions, CTEs

**5. How does regional unemployment affect store sales?**
Store level unemployment rates were averaged to smooth weekly noise, then grouped into tiers by using quartiles:

Low: Bottom 25%
Moderate: Middle 50%
High: Top 25%

Average weekly sales were compared across tiers to assess the relationship between local labor market conditions and retail performance.
Skills: CTEs, AVG, CASE WHEN, GROUP BY

**6. Which stores are underperforming?**
Each store's average weekly sales are compared against the overall store average. Stores are flagged as Underperforming or Above Average, with the exact dollar difference shown.
Skills: CTEs, CROSS JOIN, CASE WHEN, subqueries

**7. Inflation (CPI) vs sales over time**
Tracks monthly CPI alongside total monthly sales to identify whether rising inflation correlates with changes in consumer spending at Walmart. Given Walmart's positioning as a value retailer, the analysis explores the trade-down effect — where consumers shift spending to lower cost retailers during inflationary periods.
Skills: LAG(), window functions, time series analysis, CTEs

**Key Findings**

- Holiday weeks showed a notable uplift in average weekly sales compared to non-holiday weeks
- Stores in high unemployment regions tended to have lower average weekly sales, consistent with reduced consumer spending power
- The CPI time series analysis revealed that as inflation rose through 2011–2012, Walmart sales remained resilient — consistent with the trade-down effect where consumers favour value retailers during inflationary periods
 - A subset of stores consistently underperformed the chain average, suggesting regional economic conditions or store-level factors worth further investigation
