SELECT Holiday_Flag AS Holiday, AVG(Weekly_Sales) AS Average_Weekly_Sales FROM Walmart_Sales
GROUP BY Holiday_Flag;
