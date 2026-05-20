SELECT Store, SUM(Weekly_Sales) AS Total_Weekly_Sales FROM Walmart_Sales
GROUP BY Store
ORDER BY Total_Weekly_Sales DESC
