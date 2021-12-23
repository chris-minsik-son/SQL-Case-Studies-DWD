-- Weight Summary Statistics
SELECT
    ROUND(MIN(measure_value), 2) AS minimum_value,
    ROUND(MAX(measure_value), 2) AS maximum_value,
    ROUND(AVG(measure_value), 2) AS mean_value,
    ROUND(CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY measure_value) AS NUMERIC), 2) AS median_value,
    -- CAST function converts data from one data type to another, here we want to convert the output's data
    -- type to NUMERIC so it is compatible with the ROUND function
    ROUND(MODE() WITHIN GROUP (ORDER BY measure_value), 2) AS mode_value,
    ROUND(STDDEV(measure_value), 2) AS std_dev,
    ROUND(VARIANCE(), 2) AS variance_value
FROM health.user_logs
WHERE measure = 'weight';

-- Output from above query, few observations
-- minimum_value⋮ 0.00                       - Too small
-- maximum_value⋮ 39642120.00                - Too big
-- mean_value⋮ 28786.85                      - Consequence of an outlier?
-- median_value⋮ 75.98
-- mode_value⋮ 68.49                         - An individual with lots of records
-- std_dev⋮ 1062759.55                       - Very large
-- variance_value⋮ 1129457862383.41          - Very large


-- Data Algorithm
-- 1. Sort values ascending
-- 2. Assign 1-100 percentile value
-- 3. For each percentile aggregate: (a) Calculate floor & ceiling values, (b) Calculate record count
SELECT
    measure_value,
    -- NTILE() generates percentile 1-100 for each value
    NTILE(100) OVER (ORDER BY measure_value) AS percentile -- OVER() is a window function (aka analytical function)
FROM health.user_logs
WHERE measure = 'weight';

-- Created a CTE with the above query
WITH percentile_values AS (
    SELECT
        measure_value,
        NTILE(100) OVER (ORDER BY measure_value) AS percentile
    FROM health.user_logs
    WHERE measure = 'weight'
)
SELECT
    percentile,
    MIN(measure_value) AS floor_value,
    MAX(measure_value) AS ceiling_value,
    COUNT(*) AS percentile_count
FROM percentile_values
GROUP BY percentile
ORDER BY percentile;

-- Now, we noticed that we had outlier observations so let's clean it and also show a visualisation
DROP TABLE IF EXISTS clean_weight_logs;
CREATE TEMP TABLE clean_weight_logs AS (
    SELECT *
    FROM health.user_logs
    WHERE
        measure = 'weight'
        AND measure_value > 0
        AND measure_value < 201
);

WITH percentile_values AS (
    SELECT
        measure_value,
        NTILE(100) OVER (ORDER BY measure_value) AS percentile
    FROM clean_weight_logs
)
SELECT
    percentile,
    MIN(measure_value) AS floor_value,
    MAX(measure_value) AS ceiling_value,
    COUNT(*) AS percentile_count
FROM percentile_values
GROUP BY percentile
ORDER BY percentile;
-- ^ ... Configure visualisation on SQLPad with the query above

-- WIDTH_BUCKET() function for bucketing data
-- 0 < Range < 200, 50 bins, column is measure_value
SELECT
    WIDTH_BUCKET(measure_value, 0, 200, 50) AS bucket,
    AVG(measure_value) AS measure_value,
    COUNT(*) AS frequency
FROM clean_weight_logs
GROUP BY bucket
ORDER BY bucket;







