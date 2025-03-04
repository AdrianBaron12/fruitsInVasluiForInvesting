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

  1. Time Series Visuals:
     
     Line charts displaying nominal and real (inflation-adjusted) prices over time.
  
  2. Comparison Charts:

      Column or bar charts comparing average price and price volatility by commodity and locality
     
  3. Scatter Plots:

      Visuals correlating average price with weather metrics (e.g. average temperature, temperature range).
     
  4. KPI Cards:
  
      Key metrics such as Average Price, Price Volatility, Real Price and ROI estimates.
     
  5. Filters 

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

