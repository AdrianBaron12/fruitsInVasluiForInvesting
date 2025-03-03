
--Price Volatility
WITH VolatlityCTE AS (
SELECT 
Product,
Locality,
COUNT(*) AS TotalMonths,
AVG(Price) AS AvgPrice,
STDEVP(Price) AS PriceVolatility
FROM data_complete_periods
WHERE Price IS NOT NULL
GROUP BY Product, Locality
)

SELECT
Product,
Locality,
TotalMonths,
AvgPrice,
PriceVolatility
FROM VolatlityCTE
ORDER BY PriceVolatility DESC;





--Temperature Volatility
WITH MergedData AS (
SELECT 
a.Product,
a.Locality,
a.CleanPeriod,
AVG(a.Price) AS AvgPrice,
AVG(w.tavg) AS AvgTemp
FROM data_complete_periods a
LEFT JOIN weatherData w ON a.CleanPeriod = w.Period
WHERE a.Price IS NOT NULL
GROUP BY 
a.Product, a.Locality,CleanPeriod
)

SELECT 
Product,
Locality,
CleanPeriod,
AvgPrice,
AvgTemp
FROM MergedData
ORDER BY Product,Locality,CleanPeriod


--Seasonal Trends

WITH MonthlyCTE AS (
SELECT a.Product,
DATENAME(MONTH,CleanPeriod) as MonthName,
MONTH(CleanPeriod) as MonthNumber,
AVG(a.Price) AS AvgMonthlyPrice
FROM data_complete_periods a
WHERE a.Price IS NOT NULL 
GROUP BY 
a.Product,
DATENAME(MONTH,a.CleanPeriod),
MONTH(a.CleanPeriod)
)

SELECT
Product,
MonthName,
MonthNumber,
AvgMonthlyPrice
FROM MonthlyCTE
ORDER BY Product,MonthNumber



--Scenario : Investors Potential Return

DECLARE @InitialInvestment MONEY = 100000; --Investor capital
DECLARE @PriceGrowthRate FLOAT = 0.10; --Assuming 10% price increase

WITH CommodityStats AS (
SELECT
Product,
Locality,
AVG(Price) AS AvgPrice,
STDEVP(Price) AS PriceVolatility
FROM data_complete_periods
WHERE Price IS NOT NULL
GROUP BY Product, Locality
)

SELECT 
Product,
Locality,
AvgPrice,
PriceVolatility,
@InitialInvestment AS Investment,
--Estimated Final Price After 10%
(AvgPrice * (1+@PriceGrowthRate)) AS EstimatedFinalPrice,
--Potential Profit
((@InitialInvestment / AvgPrice) * (1 + @PriceGrowthRate) -AvgPrice) AS PotentialProfit
FROM CommodityStats
ORDER BY PotentialProfit DESC