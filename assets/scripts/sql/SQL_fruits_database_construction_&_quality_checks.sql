USE fruit_sales_in_Vaslui_db

SELECT *
FROM data_complete_periods a
LEFT JOIN IPCperMonth i ON a.Period=i.Period
LEFT JOIN weatherData w ON a.Period=i.Period

SELECT FORMAT(CONVERT(date, a.Period), 'MMMM yyyy') as Formated_period,
a.County,
a.Locality,
a.Product,
ROUND(a.Price,2) as Rounded_Price,
ROUND(i.IPC,2) as inflation_rate,
ROUND(w.tavg,2) as avg_temp,
ROUND(w.tmin,2) as min_temp,
ROUND(w.tmax,2) AS max_temp
FROM data_complete_periods a
LEFT JOIN IPCperMonth i ON CONVERT(date, a.Period)=CONVERT(date, i.Period)
LEFT JOIN weatherData w ON CONVERT(date,a.Period)=CONVERT(date,w.Period)
WHERE TRY_CONVERT(date, a.Period) IS NOT NULL
ORDER BY Product ASC, Locality DESC

SELECT Period
FROM data_complete_periods
WHERE TRY_CONVERT(date,Period) is NULL

-- Update Period of data_complete_periods, IPCperMonth & weatherData into a data format 
--0 rows ->
UPDATE data_complete_periods
SET Period = LTRIM(RTRIM(Period))
WHERE Period <> LTRIM(RTRIM(Period))

--all of them are not date 
SELECT Period
FROM data_complete_periods
WHERE ISDATE(Period) = 0;

--add a good data format
ALTER TABLE data_complete_periods
ADD DatePeriods date;

UPDATE data_complete_periods
SET DatePeriods = 
	CASE WHEN ISDATE(Period) = 0 THEN CAST (Period AS date)
	ELSE NULL
	END;

SELECT Period, DatePeriod
FROM data_complete_periods
WHERE DatePeriod IS NULL

SELECT * FROM data_complete_periods

SELECT
County,
Product,
Locality,
FORMAT(DatePeriod, 'MMMM yyyy') AS PeriodFormatted,
Price
FROM data_complete_periods

ALTER TABLE data_complete_periods
DROP COLUMN DatePeriod, DatePeriods


SELECT 
FORMAT(TRY_PARSE('01' + REPLACE(Period, '-', ' ') AS date USING 'en-US'), 'MMM yy') AS CleanPeriod
FROM data_complete_periods
WHERE ISDATE(Period) = 0

ALTER TABLE data_complete_periods
ADD CleanPeriod date;

UPDATE data_complete_periods
SET CleanPeriod = TRY_PARSE('01' + REPLACE(Period, '-', ' ') AS date USING 'en-US')

SELECT Period, CleanPeriod
FROM data_complete_periods
WHERE CleanPeriod IS NULL OR Period IS NULL;


SELECT * FROM data_complete_periods

'
ALTER TABLE data_complete_periods
DROP COLUMN Period
'

SELECT * FROM IPCperMonth

ALTER TABLE IPCperMonth
ADD CleanPeriod date

UPDATE IPCperMonth
SET CleanPeriod = TRY_PARSE('01' + REPLACE(Period, '-', ' ') AS date USING 'en-US')

SELECT Period, CleanPeriod
FROM IPCperMonth
WHERE CleanPeriod IS NULL OR Period IS NULL;

SELECT Period FROM weatherData
WHERE ISDATE(Period) = 0

SELECT * FROM weatherData

SELECT * FROM weatherData

ALTER TABLE weatherData
ADD CleanPeriod date

ALTER TABLE weatherData
DROP COLUMN CleanPeriod

SELECT * FROM weatherData

EXEC sp_rename 'IPCperMonth.CleanPeriod', 'period_IPC','COLUMN';

SELECT * FROM IPCperMonth

ALTER TABLE IPCperMonth
DROP COLUMN Period


--good one
ALTER VIEW MergedAgroData AS 
SELECT 
a.CleanPeriod,
a.County,
a.Locality,
a.Product,
ROUND(a.Price,2) as Rounded_Price,
ROUND(i.IPC,2) as inflation_rate,
ROUND(w.tavg,2) as avg_temp,
ROUND(w.tmin,2) as min_temp,
ROUND(w.tmax,2) AS max_temp,
a.Unit
FROM data_complete_periods a
LEFT JOIN IPCperMonth i ON a.CleanPeriod=i.period_IPC
LEFT JOIN weatherData w ON a.CleanPeriod=w.Period


ALTER VIEW MergedAgroData AS
SELECT Unit
FROM data_complete_periods

--Quality checks : Row Count Checks (OK)
SELECT 
Product,
Locality,
COUNT(*) AS RecordCount
FROM data_complete_periods
GROUP BY Product, Locality

--Quality checks : Data Coverage (OK)

SELECT 
a.Product,
a.Locality,
FORMAT(a.CleanPeriod, 'MMM yyyy') AS FormattedPeriod
FROM data_complete_periods a
LEFT JOIN weatherData w ON a.CleanPeriod=w.Period
LEFT JOIN IPCperMonth i ON a.CleanPeriod=i.period_IPC
ORDER BY CleanPeriod ASC

--Consistency checks : Data Type Validation (OK)

SELECT
COLUMN_NAME,
DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'MergedAgroData'

--Consistency checks : Duplicate Count Validation all tables (OK)

SELECT Product ,COUNT(*) as DuplicateCount
FROM MergedAgroData
GROUP BY Product
HAVING COUNT(*)>1

--Consistency checks : Duplicate Count Validation Fruits table (OK)

SELECT 
Product,
Locality,
CleanPeriod,
COUNT(*) AS DuplicateCount
FROM data_complete_periods
GROUP BY Product,Locality,CleanPeriod
HAVING COUNT(*) > 1

--Consistency checks : Duplicate Count Validation Inflation table (OK)

SELECT IPC,
period_IPC, 
COUNT(*) AS DuplicateCount
FROM IPCperMonth
GROUP BY IPC, period_IPC
HAVING COUNT(*)>1

--Consistency checks : Duplicate Count Validation Weather table (OK)

SELECT Period,
tavg,
tmin,
tmax,
COUNT(*) as DuplicateCount
FROM weatherData
GROUP BY Period, tavg,tmin,tmax 
HAVING COUNT(*) > 1


--Consistency checks : Period field consistency (OK)

SELECT DISTINCT FORMAT(CleanPeriod, 'MMM yyyy') AS FormattedPeriod
FROM data_complete_periods
ORDER BY FormattedPeriod

SELECT DISTINCT FORMAT(Period, 'MMM yyyy') AS FormattedPeriod
FROM weatherData
ORDER BY FormattedPeriod

SELECT DISTINCT FORMAT(period_IPC, 'MMM yyyy') AS FormattedPeriod
FROM IPCperMonth
ORDER BY FormattedPeriod

--Price volatility by product and locality
SELECT 
Product,
Locality,
COUNT(*) AS TotalMonths,
AVG(Rounded_Price) AS AvgPrice,
STDEV(Rounded_Price) as PriceVolatility,
AVG(inflation_rate) AS AvgInflation,
AVG(avg_temp) AS AvgTemp,
AVG (max_temp - min_temp) AS AvgTempRange
FROM MergedAgroData
GROUP BY Product, Locality
ORDER BY PriceVolatility


