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
