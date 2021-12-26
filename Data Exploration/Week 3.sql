-- WEEK 3: DATA EXPLORATION EXERCISES

-- IDENTIFYING DUPLICATE RECORDS

-- (1) Which id value has the most number of duplicate records in the health.user_logs table?
-- First retrieve all records and then sum the distinct records
-- Note, we set frequency > 1 as we only want to get the cumulative frequency of DUPLICATE id's
WITH groupby_counts AS (
  SELECT
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic,
    COUNT(*) AS frequency
  FROM health.user_logs
  GROUP BY
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic
)
SELECT
  id,
  SUM(frequency) AS total_duplicate_rows
FROM groupby_counts
WHERE frequency > 1
GROUP BY id
ORDER BY total_duplicate_rows DESC
LIMIT 1;

                    id                    | total_duplicate_rows
------------------------------------------+----------------------
 054250c692e07a9fa9e62e345231df4b54ff435d |                17279

-- (2) Which log_date value had the most duplicate records after removing the max duplicate id value from question 1?
WITH groupby_counts AS (
  SELECT
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic,
    COUNT(*) AS frequency
  FROM health.user_logs
  GROUP BY
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic
)
SELECT
  log_date,
  SUM(frequency) AS total_duplicate_rows
FROM groupby_counts
WHERE frequency > 1 AND id != '054250c692e07a9fa9e62e345231df4b54ff435d'
GROUP BY log_date
ORDER BY total_duplicate_rows DESC
LIMIT 1;

  log_date  | total_duplicate_rows
------------+----------------------
 2019-12-11 |                   55

-- (3) Which measure_value had the most occurences in the health.user_logs value when measure = 'weight'?
SELECT
  measure,
  measure_value,
  COUNT(*) AS frequency
FROM health.user_logs
WHERE measure = 'weight'
GROUP BY measure_value, measure
ORDER BY frequency DESC
LIMIT 1;

 measure | measure_value | frequency
---------+---------------+-----------
 weight  |   68.49244787 |       109

-- (4) How many single duplicated rows exist when measure = 'blood_pressure' in the health.user_logs? How about the total number of duplicate records in the same table?
WITH groupby_counts AS (
  SELECT
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic,
    COUNT(*) AS frequency -- Sets all records' frequency to 1
  FROM health.user_logs
  WHERE measure = 'blood_pressure'
  GROUP BY
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic
)
SELECT
  COUNT(*) as single_duplicate_rows, -- Counts all the records with frquency >= 2
  SUM(frequency) as total_duplicate_records -- Sums all the frequencies of those record i.e. total
FROM groupby_counts
WHERE frequency > 1;

 single_duplicate_rows | total_duplicate_records
-----------------------+-------------------------
                   147 |                     301

-- (5) What percentage of records measure_value = 0 when measure = 'blood_pressure' in the health.user_logs table? How many records are there also for this same condition?
-- SUM(COUNT(*)) OVER() since we want to add the counts of each measure value for when measure = 'blood_pressure'
WITH measure_bp AS (
  SELECT
    measure_value,
    COUNT(*) AS bp_count,
    SUM(COUNT(*)) OVER() AS total_count
  FROM health.user_logs
  WHERE measure = 'blood_pressure'
  GROUP by measure_value
)
SELECT
  measure_value,
  bp_count,
  total_count,
  ROUND(100 * bp_count::NUMERIC / total_count, 2) AS PERCENTAGE
FROM measure_bp
WHERE measure_value = 0;

 measure_value | bp_count | total_count | percentage
---------------+----------+-------------+------------
             0 |      562 |        2417 |      23.25

-- (6) What percentage of records are duplicates in the health.user_logs table?
-- In the case statement below,  subtract 1 from the frequency to count the actual duplicates
WITH groupby_freq AS (
  SELECT
    id,
    measure,
    measure_value,
    systolic,
    diastolic,
    COUNT(*) AS frequency
  FROM health.user_logs
  GROUP BY
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic
)
SELECT ROUND(100 * SUM(CASE
                      WHEN frequency > 1
                      THEN frequency - 1
                      ELSE 0
                      END)::NUMERIC / SUM(frequency), 2)
AS duplicate_percentage
FROM groupby_freq;

 duplicate_percentage
----------------------
                29.36



-- Exploring the Health Analytics Data:
SELECT * FROM health.user_logs LIMIT 10;

                    id                    |  log_date  |    measure     | measure_value | systolic | diastolic
------------------------------------------+------------+----------------+---------------+----------+-----------
 fa28f948a740320ad56b81a24744c8b81df119fa | 2020-11-15 | weight         |      46.03959 |          |
 1a7366eef15512d8f38133e7ce9778bce5b4a21e | 2020-10-10 | blood_glucose  |            97 |        0 |         0
 bd7eece38fb4ec71b3282d60080d296c4cf6ad5e | 2020-10-18 | blood_glucose  |           120 |        0 |         0
 0f7b13f3f0512e6546b8d2c0d56e564a2408536a | 2020-10-17 | blood_glucose  |           232 |        0 |         0
 d14df0c8c1a5f172476b2a1b1f53cf23c6992027 | 2020-10-15 | blood_pressure |           140 |      140 |       113
 0f7b13f3f0512e6546b8d2c0d56e564a2408536a | 2020-10-21 | blood_glucose  |           166 |        0 |         0
 0f7b13f3f0512e6546b8d2c0d56e564a2408536a | 2020-10-22 | blood_glucose  |           142 |        0 |         0
 87be2f14a5550389cb2cba03b3329c54c993f7d2 | 2020-10-12 | weight         | 129.060012817 |        0 |         0
 0efe1f378aec122877e5f24f204ea70709b1f5f8 | 2020-10-07 | blood_glucose  |           138 |        0 |         0
 054250c692e07a9fa9e62e345231df4b54ff435d | 2020-10-04 | blood_glucose  |           210 |          |

-- How many rows in the data?
SELECT COUNT(*) FROM health.user_logs;

 count
-------
 43891

-- Count on the unique entries in the measures column
SELECT
    measure,
    COUNT(*) AS frequency
FROM health.user_logs
GROUP BY measure;

    measure     | frequency
----------------+-----------
 blood_glucose  |     38692
 blood_pressure |      2417
 weight         |      2782

-- Number of unique customers
SELECT COUNT(DISTINCT id) FROM health.user_logs;

 count
-------
   554

-- Find the top 10 customers by record count
SELECT
    id,
    COUNT(*) AS row_count
FROM health.user_logs
GROUP BY id
ORDER BY row_count DESC
LIMIT 10;

                    id                    | row_count
------------------------------------------+-----------
 054250c692e07a9fa9e62e345231df4b54ff435d |     22325
 0f7b13f3f0512e6546b8d2c0d56e564a2408536a |      1589
 ee653a96022cc3878e76d196b1667d95beca2db6 |      1235
 abc634a555bbba7d6d6584171fdfa206ebf6c9a0 |      1212
 576fdb528e5004f733912fae3020e7d322dbc31a |      1018
 87be2f14a5550389cb2cba03b3329c54c993f7d2 |       747
 46d921f1111a1d1ad5dd6eb6e4d0533ab61907c9 |       651
 fba135f6a50a2e3f371e47f943b025705f9d9617 |       633
 d696925de5e9297694ef32a1c9871f3629bec7e5 |       597
 6c2f9a8372dac248192c50219c97f9087ab778ba |       582

-- Inspecting data where measure_value = 0
SELECT *
FROM health.user_logs
WHERE measure_value = 0
LIMIT 10;

                    id                    |  log_date  |    measure     | measure_value | systolic | diastolic
------------------------------------------+------------+----------------+---------------+----------+-----------
 ee653a96022cc3878e76d196b1667d95beca2db6 | 2020-03-18 | blood_pressure |             0 |      115 |        76
 ee653a96022cc3878e76d196b1667d95beca2db6 | 2020-03-15 | blood_pressure |             0 |      115 |        76
 ee653a96022cc3878e76d196b1667d95beca2db6 | 2020-02-03 | blood_pressure |             0 |      105 |        70
 0f7b13f3f0512e6546b8d2c0d56e564a2408536a | 2020-02-24 | blood_pressure |             0 |      136 |        87
 c7af488f4c8efc0ecdfd6d0c427e7c133bf2f2d9 | 2020-02-06 | blood_pressure |             0 |      164 |        84
 c7af488f4c8efc0ecdfd6d0c427e7c133bf2f2d9 | 2020-02-10 | blood_pressure |             0 |      190 |        94
 0f7b13f3f0512e6546b8d2c0d56e564a2408536a | 2020-02-07 | blood_pressure |             0 |      125 |        79
 0f7b13f3f0512e6546b8d2c0d56e564a2408536a | 2020-02-19 | blood_pressure |             0 |      136 |        84
 0f7b13f3f0512e6546b8d2c0d56e564a2408536a | 2020-02-15 | blood_pressure |             0 |      135 |        89
 0f7b13f3f0512e6546b8d2c0d56e564a2408536a | 2020-02-27 | blood_pressure |             0 |      138 |        85

SELECT
    measure,
    COUNT(*) AS record_count
FROM health.user_logs
WHERE measure_value = 0
GROUP BY measure;

    measure     | record_count
----------------+--------------
 blood_glucose  |            8
 blood_pressure |          562
 weight         |            2

-- Checking NULL values in the systolic column
SELECT COUNT(*)
FROM health.user_logs
WHERE systolic IS NULL;

 count
-------
 26023

-- Removing duplicates and counting unique entries
-- CTE: (preferred method over subquery)
WITH deduped_logs AS (
    SELECT DISTINCT *
    FROM health.user_logs
)
SELECT COUNT(*)
FROM deduped_logs;

-- Subquery:
SELECT COUNT(*)
FROM (
    SELECT DISTINCT *
    FROM health.user_logs
) AS subquery;

-- Removing unique values: Duplicate data
SELECT
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic,
    COUNT(*) AS record_count
FROM health.user_logs
GROUP BY
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic
HAVING COUNT(*) > 1;

WITH duplicate_data AS (
    SELECT
        id,
        log_date,
        measure,
        measure_value,
        systolic,
        diastolic,
        COUNT(*) AS record_count
    FROM health.user_logs
    GROUP BY
        id,
        log_date,
        measure,
        measure_value,
        systolic,
        diastolic
    HAVING COUNT(*) > 1
)
SELECT
    id,
    SUM(record_count) AS total_count
FROM duplicate_data
WHERE record_count > 1
GROUP BY id
ORDER BY total_count DESC;