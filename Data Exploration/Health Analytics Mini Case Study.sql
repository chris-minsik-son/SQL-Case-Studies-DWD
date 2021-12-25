-- Before we start digging into the SQL script - let’s cover the business questions that we need to help the GM answer!
-- 1. How many unique users exist in the logs dataset?
SELECT COUNT(DISTINCT id) AS "Number of Unique IDs" FROM health.user_logs;

-- Now, let us create a temporary table for the next few questions:
DROP TABLE IF EXISTS user_measure_count;
CREATE TEMP TABLE user_measure_count AS (
  SELECT
    id,
    COUNT(*) AS measure_count
  FROM health.user_logs
  GROUP BY id
)

-- 2. How many total measurements do we have per user on average?
SELECT
  ROUND(AVG(measure_count))
FROM user_measure_count;

-- 3. What about the median number of measurements per user?




-- 4. How many users have 3 or more measurements?
SELECT
  COUNT(*)
FROM user_measure_count
WHERE measure_count >= 3;

-- 5. How many users have 1,000 or more measurements?
SELECT
  COUNT(*)
FROM user_measure_count
WHERE measure_count >= 1000;

-- Looking at the logs data - what is the number and percentage of the active user base who:

-- 6. Have logged blood glucose measurements?
-- 7. Have at least 2 types of measurements?
-- 8. Have all 3 measures - blood glucose, weight and blood pressure?

-- For users that have blood pressure measurements:

-- 9. What is the median systolic/diastolic blood pressure values?
