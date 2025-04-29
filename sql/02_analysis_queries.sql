-- Basic data exploration
-- Check data structure and sample records
SELECT * FROM socio_data LIMIT 10;

-- Get data summary
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT "Education") AS education_levels,
    COUNT(DISTINCT "Occupation") AS occupation_types,
    COUNT(DISTINCT "Marital status") AS marital_statuses
FROM socio_data;

-- Income distribution
SELECT 
    "Income", 
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM socio_data), 2) AS percentage
FROM socio_data
GROUP BY "Income"
ORDER BY "Income";

-- Income analysis by education level
SELECT 
    "Education",
    COUNT(*) AS people_count,
    ROUND(AVG("Income"), 2) AS avg_income,
    MIN("Income") AS min_income,
    MAX("Income") AS max_income
FROM socio_data
GROUP BY "Education"
ORDER BY avg_income DESC;

-- Gender income gap analysis
SELECT 
    CASE 
        WHEN "Sex" = '0' THEN 'Female'
        WHEN "Sex" = '1' THEN 'Male'
        ELSE 'Other/Unknown'
    END AS gender,
    COUNT(*) AS count,
    ROUND(AVG("Income"), 2) AS avg_income,
    ROUND(AVG("Age"), 2) AS avg_age
FROM socio_data
GROUP BY "Sex"
ORDER BY "Sex";

-- Gender income gap by occupation
SELECT 
    "Occupation",
    ROUND(AVG(CASE WHEN "Sex" = '0' THEN "Income" END), 2) AS female_avg_income,
    ROUND(AVG(CASE WHEN "Sex" = '1' THEN "Income" END), 2) AS male_avg_income,
    COUNT(CASE WHEN "Sex" = '0' THEN 1 END) AS female_count,
    COUNT(CASE WHEN "Sex" = '1' THEN 1 END) AS male_count,
    ROUND(
        AVG(CASE WHEN "Sex" = '1' THEN "Income" END) - 
        AVG(CASE WHEN "Sex" = '0' THEN "Income" END), 2
    ) AS income_gap
FROM socio_data
GROUP BY "Occupation"
ORDER BY income_gap DESC;

-- Settlement size impact on income
SELECT 
    "Settlement size" AS settlement_size_code,
    COUNT(*) AS population,
    ROUND(AVG("Income"), 2) AS avg_income,
    ROUND(AVG("Age"), 2) AS avg_age
FROM socio_data
GROUP BY "Settlement size"
ORDER BY "Settlement size";

-- Age group analysis
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
ORDER BY 
    CASE 
        WHEN age_group = 'Under 25' THEN 1
        WHEN age_group = '25-34' THEN 2
        WHEN age_group = '35-44' THEN 3
        WHEN age_group = '45-54' THEN 4
        WHEN age_group = '55-64' THEN 5
        ELSE 6
    END;

-- Marital status and income
SELECT 
    "Marital status",
    COUNT(*) AS count,
    ROUND(AVG("Income"), 2) AS avg_income,
    ROUND(AVG("Age"), 2) AS avg_age
FROM socio_data
GROUP BY "Marital status"
ORDER BY avg_income DESC;
