-- Advanced Statistical Analysis

-- Income percentiles across the dataset
SELECT
    percentile_cont(0.25) WITHIN GROUP (ORDER BY "Income") AS income_25th_percentile,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY "Income") AS income_median,
    percentile_cont(0.75) WITHIN GROUP (ORDER BY "Income") AS income_75th_percentile,
    AVG("Income") AS income_mean,
    STDDEV("Income") AS income_stddev
FROM socio_data;

-- Income quintiles distribution
WITH income_quintiles AS (
    SELECT 
        ntile(5) OVER (ORDER BY "Income") AS quintile,
        "ID"
    FROM socio_data
)
SELECT 
    q.quintile,
    COUNT(*) AS count,
    ROUND(MIN(s."Income"), 2) AS min_income,
    ROUND(MAX(s."Income"), 2) AS max_income,
    ROUND(AVG(s."Income"), 2) AS avg_income
FROM income_quintiles q
JOIN socio_data s ON q."ID" = s."ID"
GROUP BY q.quintile
ORDER BY q.quintile;

-- Correlation analysis - Age vs Income using window functions
WITH stats AS (
    SELECT 
        COUNT(*) as n,
        SUM("Age") as sum_x,
        SUM("Income") as sum_y,
        SUM("Age"*"Age") as sum_x2,
        SUM("Income"*"Income") as sum_y2,
        SUM("Age"*"Income") as sum_xy
    FROM socio_data
)
SELECT 
    (n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y)) AS age_income_correlation
FROM stats;

-- Educational attainment income ratio by gender
WITH income_by_edu_gender AS (
    SELECT 
        "Education",
        ROUND(AVG(CASE WHEN "Sex" = '0' THEN "Income" END), 2) AS female_avg_income,
        ROUND(AVG(CASE WHEN "Sex" = '1' THEN "Income" END), 2) AS male_avg_income
    FROM socio_data
    GROUP BY "Education"
)
SELECT 
    "Education",
    female_avg_income,
    male_avg_income,
    CASE 
        WHEN female_avg_income > 0 THEN 
            ROUND(male_avg_income / female_avg_income, 2)
        ELSE NULL
    END AS male_to_female_ratio
FROM income_by_edu_gender
ORDER BY male_to_female_ratio DESC NULLS LAST;

-- Multivariate analysis by combining factors
SELECT 
    "Education",
    "Marital status",
    CASE WHEN "Sex" = '0' THEN 'Female' ELSE 'Male' END AS gender,
    COUNT(*) AS count,
    ROUND(AVG("Income"), 2) AS avg_income,
    ROUND(STDDEV("Income"), 2) AS income_stddev
FROM socio_data
GROUP BY "Education", "Marital status", "Sex"
HAVING COUNT(*) >= 5 -- Only show groups with sufficient sample size
ORDER BY avg_income DESC;

-- Age cohort analysis with education level
WITH age_cohorts AS (
    SELECT 
        CASE 
            WHEN "Age" < 25 THEN 'Under 25'
            WHEN "Age" BETWEEN 25 AND 34 THEN '25-34'
            WHEN "Age" BETWEEN 35 AND 44 THEN '35-44'
            WHEN "Age" BETWEEN 45 AND 54 THEN '45-54'
            WHEN "Age" BETWEEN 55 AND 64 THEN '55-64'
            ELSE '65+'
        END AS age_group,
        "Education",
        "Income"
    FROM socio_data
)
SELECT 
    age_group,
    "Education",
    COUNT(*) AS count,
    ROUND(AVG("Income"), 2) AS avg_income
FROM age_cohorts
GROUP BY age_group, "Education"
HAVING COUNT(*) >= 5
ORDER BY 
    CASE 
        WHEN age_group = 'Under 25' THEN 1
        WHEN age_group = '25-34' THEN 2
        WHEN age_group = '35-44' THEN 3
        WHEN age_group = '45-54' THEN 4
        WHEN age_group = '55-64' THEN 5
        ELSE 6
    END,
    avg_income DESC;

