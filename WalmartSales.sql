
SELECT * FROM Walmart_Sales

--Which stores generate the most revenue---

SELECT Store, SUM(Weekly_Sales) AS Total_Weekly_Sales FROM Walmart_Sales
GROUP BY Store
ORDER BY Total_Weekly_Sales DESC

--How do holiday weeks impact sales?---

SELECT Holiday_Flag AS Holiday, AVG(Weekly_Sales) AS Average_Weekly_Sales FROM Walmart_Sales
GROUP BY Holiday_Flag;

--Fuel Price Impact On Sales--
WITH percentiles AS (
    SELECT 
        DISTINCT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Fuel_Price) OVER() AS q3,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Fuel_Price) OVER() AS q1
    FROM Walmart_Sales
),
fc AS (
    SELECT 
        w.Weekly_Sales AS WS,
        CASE 
            WHEN w.Fuel_Price > p.q3 THEN 'Expensive'
            WHEN w.Fuel_Price < p.q1 THEN 'Cheap'
            ELSE 'Mid'
        END AS Fuel_Price_Category
    FROM Walmart_Sales w
    CROSS JOIN percentiles p
)
SELECT 
    Fuel_Price_Category, 
    AVG(WS) AS Average_Weekly_Sales 
FROM fc
GROUP BY Fuel_Price_Category;
--What does monthly sales growth look like--

WITH monthly_sales AS (
    SELECT 
        YEAR(Date) AS sales_year,
        MONTH(Date) AS sales_month,
        SUM(Weekly_Sales) AS total_monthly_sales
    FROM Walmart_Sales
    GROUP BY YEAR(Date), MONTH(Date)
),
mom_growth AS (
    SELECT 
        sales_year,
        sales_month,
        total_monthly_sales,
        LAG(total_monthly_sales) OVER (ORDER BY sales_year, sales_month) AS prev_month_sales
    FROM monthly_sales
)
SELECT 
    sales_year,
    sales_month,
    total_monthly_sales,
    prev_month_sales,
    ROUND(((total_monthly_sales - prev_month_sales) / prev_month_sales) * 100, 2) AS mom_growth_pct
FROM mom_growth
WHERE prev_month_sales IS NOT NULL
ORDER BY sales_year, sales_month;
--How does the unemployment rate affect weekly sales--
WITH store_averages AS (
    SELECT 
        Store,
        AVG(Unemployment) AS avg_unemployment,
        AVG(Weekly_Sales) AS avg_weekly_sales
    FROM Walmart_Sales
    GROUP BY Store
),
categorized AS (
    SELECT 
        Store,
        avg_unemployment,
        avg_weekly_sales,
        CASE 
            WHEN avg_unemployment < (SELECT DISTINCT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY avg_unemployment) OVER() FROM store_averages)  THEN 'Low'
            WHEN avg_unemployment > (SELECT DISTINCT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY avg_unemployment) OVER() FROM store_averages) THEN 'High'
            ELSE 'Moderate'
        END AS unemployment_category
    FROM store_averages
)
SELECT 
    unemployment_category,
    COUNT(Store) AS num_stores,
    ROUND(AVG(avg_unemployment), 2) AS avg_unemployment_rate,
    ROUND(AVG(avg_weekly_sales), 2) AS avg_weekly_sales
FROM categorized
GROUP BY unemployment_category
ORDER BY avg_unemployment_rate;
--Which stores are underpreforming?---
WITH store_avg AS (
    SELECT 
        Store,
        AVG(Weekly_Sales) AS avg_store_sales
    FROM Walmart_Sales
    GROUP BY Store
),
overall_avg AS (
    SELECT AVG(Weekly_Sales) AS overall_avg_sales
    FROM Walmart_Sales
)
SELECT 
    s.Store,
    ROUND(s.avg_store_sales, 2) AS avg_store_sales,
    ROUND(o.overall_avg_sales, 2) AS overall_avg_sales,
    ROUND(s.avg_store_sales - o.overall_avg_sales, 2) AS difference,
    CASE 
        WHEN s.avg_store_sales < o.overall_avg_sales THEN 'Underperforming'
        ELSE 'Above Average'
    END AS performance_flag
FROM store_avg s
CROSS JOIN overall_avg o
ORDER BY avg_store_sales DESC;
-- Effects Of CPI on Sales --
WITH monthly_data AS (
    SELECT 
        YEAR(Date) AS sales_year,
        MONTH(Date) AS sales_month,
        AVG(CPI) AS avg_cpi,
        SUM(Weekly_Sales) AS total_monthly_sales
    FROM Walmart_Sales
    GROUP BY YEAR(Date), MONTH(Date)
)
SELECT 
    sales_year,
    sales_month,
    ROUND(avg_cpi, 2) AS avg_cpi,
    ROUND(total_monthly_sales, 2) AS total_monthly_sales,
    LAG(avg_cpi) OVER (ORDER BY sales_year, sales_month) AS prev_month_cpi,
    ROUND(avg_cpi - LAG(avg_cpi) OVER (ORDER BY sales_year, sales_month), 2) AS cpi_change
FROM monthly_data
ORDER BY sales_year, sales_month;
--Do seasonal temperature changes affect weekly sales?--
WITH seasonal_sales AS (
    SELECT 
        Store,
        Weekly_Sales,
        Temperature,
        CASE 
            WHEN Temperature < 40 THEN 'Winter'
            WHEN Temperature BETWEEN 40 AND 60 THEN 'Spring/Fall'
            WHEN Temperature > 60 THEN 'Summer'
        END AS season
    FROM Walmart_Sales
)
SELECT 
    season,
    COUNT(*) AS num_weeks,
    ROUND(AVG(Weekly_Sales), 2) AS avg_weekly_sales,
    ROUND(AVG(Temperature), 2) AS avg_temperature
FROM seasonal_sales
GROUP BY season
ORDER BY avg_weekly_sales DESC