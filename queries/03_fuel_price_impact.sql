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
