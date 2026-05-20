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
