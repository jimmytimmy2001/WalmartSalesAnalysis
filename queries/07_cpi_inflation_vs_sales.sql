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
