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
