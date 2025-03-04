# Data Portfolio: Agricultural Commodity Investment Dashboard

![excel-to-power-bi-animated-gif](assets/images/kaggle_to_powerbi.gif)

# Table of contents

- [Objective](#objective)
- [Data Source](#data-source)
- [User Story](#user-story)
- [Stages](#stages)
- [Design](#design)
  - [Dashboard Components](#dashboard-components)
  - [Mockup](#mockup)
  - [Tools](#tools)
- [Development](#development)
  - [Pseudocode](#pseudocode)
  - [Data Exploration](#data-exploration)
  - [Data Cleaning](#data-cleaning)
  - [Transform the Data](#transform-the-data)
  - [Create the SQL View](#create-the-sql-view)
- [Testing](#testing)
  - [Data Quality Tests](#data-quality-tests)
- [Visualization](#visualization)
  - [Results](#results)
  - [DAX Measures](#dax-measures)
- [Analysis](#analysis)
  - [Price Volatility Analysis](#price-volatility-analysis)
  - [Temperature & Seasonal Trends Analysis](#temperature-and-seasonal-trends-analysis)
- [Recommendations](#recommendations)
  - [Potential ROI](#potential-roi)
  - [Potential Courses of Action](#ponteial-courses-of-action)
- [Conclusion](#conclusion)

# Objective
- Key Pain Point

  Investors need an integrated view of agricultural commodity prices in relation to external economic (inflation) and climatic (weather) factors to make risk-adjusted, informed investment decisions.

- Ideal Solution:

  To create a dynamic dashboard that merges historical commodity pricing (data_complete_periods) with monthly weather (weatherData) and inflation data (period_IPC). This dashboard will provide key performance metrics and visualizations that help investors:
  - Evaluate price stability and volatility.
  - Understand the impact of inflation and weather on commodity prices.
  - Forecast future price trends to optimize investment timing and risk management.

## User Story

  "As an investor, I want to use a dashboard that integrates commodity price data, weather conditions, and inflation information so that I can identify stable investment opportunities, assess seasonal trends, and forecast future prices to maximize ROI."

# Data Sources

  - data_complete_periods :
    Contains monthly historical prices, product names, localities, and counties for agricultural commodities

    Data is coming from INSSE (National Institute of Statistics) : http://statistici.insse.ro:8077/tempo-online/#/pages/tables/insse-table

    - weatherData :
      Provides monthly weather metrics such as average, minimum and maximum temperatures.

    Data is coming from an API of any weather APIs

    - period_IPC:
      Includes monthly inflation percentage that help adjust nominal commodity prices into real values.

    Data is coming from INSSE : https://insse.ro/cms/sites/default/files/com_presa/com_pdf/ipc12r24.pdf

# Stages

- Design
- Development
- Testing
- Analysis
- Recommendations
- Conclusion

# Design

## Dashboard Components

To answer investor questions, the dashboard should include:

  1. **Time Series Visuals**:
     
     Line charts displaying nominal and real (inflation-adjusted) prices over time.
  
  2. **Comparison Charts**:

      Column or bar charts comparing average price and price volatility by commodity and locality
     
  3. **Scatter Plots**:

      Visuals correlating average price with weather metrics (e.g. average temperature, temperature range).
     
  4. **KPI Cards**:
  
      Key metrics such as Average Price, Price Volatility, Real Price and ROI estimates.
     
  5. **Filters**

      Interactive filters for Product, Locality and Period to allow dynamic exploration of the data.

## Mockup

A preliminary mockup could include:
- A header with KPIs.
- A main time-series line chart for price trends.
- A side-by-side column chart for price volatility by commodity and locality.
- A scatter plot comparing average price vs average temperature.
- Filters to dynamically slice of data.

## Tools

| Tool | Purpose |
| ---- | ------- |
| Excel | Data exploration and initial analysis |
| SQL Server (SSMS) | Data cleaning, transformation and creating SQL views |
| Python | Data cleaning, Data fetching |
| Power BI | Interactive dashboard development and DAX-based analysis |
| GitHub | Version control and documentation |
| Power Query | Additional data transformationg within Power BI |

# Development

## Pseudocode

1. Extract and Explore Data:
  
  - Import  data_complete_periods, weatherData and period_IPC into SSMS.
  - Validate and explore data quality, formats and completeness.

2. Data Cleaning:

  - Standardize the Period field across tables (e.g. convert to proper date format)
  - Remove duplicates and irrelevant columns.
  - Ensure numeric columns (Price, IPC <Inflation>, Temperature) are correctly typed.

3. Transform Data and Create SQL Views:

   - Merge the tables on a common Period field.
   - Create a view (e.g. MergedAgroData) that consolidates all key metrics.

4. Load Data into Power BI

   - Connect Power BI to the SQL view.
   - Establish relationships and create calculated columns if needed.
  
5. Develop DAX Measures:

   - Build measures for Avg Price, Price Volatility, Real Price, Temperature Range.

6. Build Visualizations:

  - Create the interactive dashboard with charts, tables and filters.
    
7.  Analysis & Reporting:

  - Analyze trends, seasonal patterns and potential ROI.
  - Document insights and recommendations.

8. Publish and Maintain:

   - Publish the dashboard to Power BI Service.
   - Store documentation and source code on GitHub.

## Data Exploration Notes
   
   - Initial Observations:
      - The data contains all necessary columns for analysis.
      - Date fields and numeric fields require standardization.
      - Some products may show high volatility, while others remain stable.

## Data Cleaning Steps

  - Translating and clean the columns
    
    Translating from Romanian to English all the data and removing the aditional blank spaces from CSV files.

  - Standardize Dates:

    Convert Period to a date type (e.g. using CleanPeriod or period_ipc field)

  - Remove Unnecessary Columns:

    Retain only the relevant columns for the analysis.

  - Check data Quality:

    Validate row counts, column counts, data types and duplicates.

## Transform the Data

```sql
CREATE VIEW MergedAgroData AS 
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
```

# Testing
## Data Quality Tests

Row Count Check

```sql
SELECT 
Product,
Locality,
COUNT(*) AS RecordCount
FROM data_complete_periods
GROUP BY Product, Locality
```

Data Coverage

```sql
SELECT 
a.Product,
a.Locality,
FORMAT(a.CleanPeriod, 'MMM yyyy') AS FormattedPeriod
FROM data_complete_periods a
LEFT JOIN weatherData w ON a.CleanPeriod=w.Period
LEFT JOIN IPCperMonth i ON a.CleanPeriod=i.period_IPC
ORDER BY CleanPeriod ASC
```

Data Type Validation 

```sql
SELECT
COLUMN_NAME,
DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'MergedAgroData'
```

Duplicate Count Validation from all tables

```sql
SELECT Product ,COUNT(*) as DuplicateCount
FROM MergedAgroData
GROUP BY Product
HAVING COUNT(*)>1
```

Duplicate Count Validation Fruits table

```sql
SELECT 
Product,
Locality,
CleanPeriod,
COUNT(*) AS DuplicateCount
FROM data_complete_periods
GROUP BY Product,Locality,CleanPeriod
HAVING COUNT(*) > 1
```

Duplicate Count Validation Inflation table

```sql
SELECT IPC,
period_IPC, 
COUNT(*) AS DuplicateCount
FROM IPCperMonth
GROUP BY IPC, period_IPC
HAVING COUNT(*)>1
```

Duplicate Count Validation Weather table

```sql
SELECT Period,
tavg,
tmin,
tmax,
COUNT(*) as DuplicateCount
FROM weatherData
GROUP BY Period, tavg,tmin,tmax 
HAVING COUNT(*) > 1
```

Period field consistency

```sql
SELECT DISTINCT FORMAT(CleanPeriod, 'MMM yyyy') AS FormattedPeriod
FROM data_complete_periods
ORDER BY FormattedPeriod

SELECT DISTINCT FORMAT(Period, 'MMM yyyy') AS FormattedPeriod
FROM weatherData
ORDER BY FormattedPeriod

SELECT DISTINCT FORMAT(period_IPC, 'MMM yyyy') AS FormattedPeriod
FROM IPCperMonth
ORDER BY FormattedPeriod
```

# Visualization

## DAX Measures

1. Average Price

   ```sql
   Average Price = AVERAGE(MergedAgroData[Rounded_Price]) 
   ```
2. Price Volatility

   ```sql
   Price Volatility =
   STDEV.P(MergedAgroData[Rounded_Price])
   ```
3. Inflation Adjusted Price

   ```sql
   Inflation Ajdusted Price =
   VAR NominalPrice = [Average Price]
   VAR InflationRate = AVERAGE(MergedAgroData[inflation_rate])/100
   RETURN NominalPrice/(1+InflationRate)
   ```
4. Temperature Range

   ```sql
   Temp Range = AVERAGE(MergedAgroData[max_temp]) - AVERAGE(MergedAgroData[min_temp])
   ```

## Dashboard Layout

- Line Chart 📈:
  Plot Average Price per Year
- Table:
  All the informationg regarding the Products
- Scatter Plot:
  Visualize correlations between Average Price and Average Temperature
- KPI Cards 🗂:
  Display key metrics such as Average Price, Price Volatility and Real Price
- Filters/Slicers 📁:
  Allow filtering by Product, Locality and Period
- Column Chart:
  Compare Average Price, Products and Temperature

# Analysis

## Price Volatility Analysis
Using the SQL CTE for Price Volatility, you can identify:

- Which commodities (e.g. Nuts, Apples, Cherries) have the highest/lowest volatility.
  
- Relative volatility as a percentage of average price.
  
- **Investor Insight**:
  Lower volatility implies lower risk. For example, if Apples show relatively low volatility, they might be favored for a stable, long-term investment. In contrast, high volatlity in Cherries may offer higher short-term gains at greater risk.

## Temperature and Seasonal Trends Analysis

Based on the Seasonal Trends table (Product, Month, Month Number, Average Price):

- **Apples** 🍏:
  Prices gradually increase from winter (January-April) to peak in late summer / early autumn (August-September), then decline.
  **Insight**: Seasonal demand or supply factors drive price changes, investors may target buying in early season and selling during peak demand.

- **Apricots & Cherries** 🍒🌸:
  Data shows limited months, but high prices in May for Cherries suggest early-season premiums, followed by decline as supply increases.
  Insight: Timing is critical, early harvest periods might command premium pricing.

- **Nuts** 🥜:
  High average prices with clear fluctuations throughout the year indicate sensivity to market conditions and possibly weather.
  Insight: While high-priced, Nuts may offer more stable returns if price volatility is moderate relative to their high price base.

- **Local Differences**:
  Comparing similar products across localities (if available) reveals microclimatic differences that can affect price stability.

# Overall Investor Insights

  - **Stable, Lower-Risk Investments**:
    Commodities with lower relative volatility (e.g Apples) might be ideal for risk-averse investors
  - **Higher-Risk, Opportunistic Investments:**
    Commodities with higher volatility (e.g. Cherries, Nuts) may offer opportunities for short-term gains but require careful timing.
  - **Seasonality:**
  Recognizing seasonal peaks and troughs in commodity prices helps investors time entry and exit points effectively.

# Recommendations

## Potential ROI

  - **Long-Term Strategy:**
      Focus on commodities with stable, predictable seasonal trends and lower volatility (e.g Apples) which can deliver steady returns.
  - **Short-Term Strategy:**
    Consider more volatile commodities (e.g Cherries) for speculative opportunities, provided that risk is managed with hedging or diversification.
  - **Local Focus:**
    Factor in locality-specific trends, for example, if one locality consistently shows more stable conditions, prioritize investments there.

## Action Plan

1.  **Data Review:**
  Regularity update and validate data quality
2.  **Dashboard Monitoring:**
  Use the Power BI dashboard to continuously track seasonal trends, price volatility and external influences.
3.  **Investments Decisions:**
  Use forecasting and scenario analysis (integrated in Power BI via DAX and built-in forecasting) to guide investment decisions.
4. **Risk Management:**
   Adjust portofolio allocations based on observed volatility and external factors like inflation and weather conditions.

# Conclusion

The Agricultural Commodity Investment Dashboard integrates price, weather and inflation data to provide investors with a comprehensive view of market dynamics. By analyzing price volatility, seasonal trends and temperature effects, investors can identify lower-risk commodities for long-term investments and spot short-term opportunities in more volatile products. With dynamic visualizations and robust DAX measures, this dashboard empowers ivestors to make informed, data-driven, decisions for optimizing their portofolios
   
   
