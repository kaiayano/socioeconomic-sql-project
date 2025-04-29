# Socioeconomic Data Analysis Project

## Overview
This project provides a comprehensive SQL framework for analyzing socioeconomic factors and their relationship with income. The repository contains SQL scripts for database setup, basic analysis, and advanced statistical queries on socioeconomic data.

## Data Structure
The project uses a dataset (`sgdata.csv`) with 2000 records containing the following fields:

| Column Name      | Data Type | Description                               |
|------------------|-----------|-------------------------------------------|
| ID               | INTEGER   | Unique identifier for each record          |
| Sex              | TEXT      | Gender ('0' = Female, '1' = Male)          |
| Marital status   | TEXT      | Marital status of the individual           |
| Age              | INTEGER   | Age in years                               |
| Education        | TEXT      | Education level                            |
| Income           | INTEGER   | Income level (numeric encoding)            |
| Occupation       | TEXT      | Job or profession                          |
| Settlement size  | INTEGER   | Size category of residence area            |

## SQL Files

### 1. Database Setup (`01_create_tables.sql`)
This script creates the main table structure and supporting indices:
- Creates the `socio_data` table with appropriate data types
- Sets up indices for commonly queried columns to improve performance
- Creates a view for common demographic analysis
- Adds documentation comments to the table and key columns

### 2. Basic Analysis Queries (`02_analysis_queries_.sql`)
Contains SQL queries for exploratory data analysis:
- Basic data structure exploration and summary statistics
- Income distribution analysis
- Education-based income analysis
- Gender income gap analysis
- Settlement size impact on income
- Age group analysis
- Marital status and income relationship

### 3. Advanced Statistical Analysis (`03_advanced_queries_.sql`)
Provides more sophisticated statistical queries:
- Income percentile calculations
- Income quintile distribution
- Correlation analysis (Age vs Income)
- Educational attainment income ratios by gender
- Multivariate demographic analysis
- Age cohort analysis with education level
- Income distribution characteristics by occupation

## Getting Started

### Prerequisites
- A SQL database system that supports standard SQL features (PostgreSQL recommended)
- The socioeconomic dataset (`sgdata.csv`)

### Setup Instructions
1. Create the database structure:
   ```bash
   psql -d your_database -f create-tables-sql.sql
   ```

2. Import the CSV data into the created table:
   ```bash
   # Using PostgreSQL's COPY command (example)
   psql -d your_database -c "\COPY socio_data FROM 'sgdata.csv' CSV HEADER"
   ```

3. Run basic analysis queries:
   ```bash
   psql -d your_database -f analysis-queries-sql.sql
   ```

4. Run advanced statistical analysis:
   ```bash
   psql -d your_database -f advanced-queries-sql.sql
   ```

## Analysis Capabilities

### Basic Analysis
- Demographic distributions
- Income averages by demographic groups
- Gender pay gap analysis
- Age-based income trends

### Advanced Analysis
- Statistical measures (median, percentiles, standard deviation)
- Income inequality metrics
- Correlation analysis
- Multi-factor demographic comparisons

## Example Queries

### Gender Income Gap
```sql
SELECT 
    "Occupation",
    ROUND(AVG(CASE WHEN "Sex" = '0' THEN "Income" END), 2) AS female_avg_income,
    ROUND(AVG(CASE WHEN "Sex" = '1' THEN "Income" END), 2) AS male_avg_income,
    ROUND(
        AVG(CASE WHEN "Sex" = '1' THEN "Income" END) - 
        AVG(CASE WHEN "Sex" = '0' THEN "Income" END), 2
    ) AS income_gap
FROM socio_data
GROUP BY "Occupation"
ORDER BY income_gap DESC;
```

### Age Cohort Analysis
```sql
SELECT 
    CASE 
        WHEN "Age" < 25 THEN 'Under 25'
        WHEN "Age" BETWEEN 25 AND 34 THEN '25-34'
        WHEN "Age" BETWEEN 35 AND 44 THEN '35-44'
        WHEN "Age" BETWEEN 45 AND 54 THEN '45-54'
        WHEN "Age" BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    COUNT(*) AS count,
    ROUND(AVG("Income"), 2) AS avg_income
FROM socio_data
GROUP BY age_group
ORDER BY age_group;
```

## Notes
- The SQL scripts are compatible with PostgreSQL but may require minor adjustments for other SQL database systems.
- Column names use double quotes to preserve capitalization and spaces.
- The "Sex" column uses text values ('0' and '1') rather than integers for gender encoding.

## Extension Possibilities
- Create visualizations based on the query results
- Add time-series analysis if temporal data becomes available
- Implement predictive models using SQL's machine learning extensions
- Create dashboards for interactive exploration
