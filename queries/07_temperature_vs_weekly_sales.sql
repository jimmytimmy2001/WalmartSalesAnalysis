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
