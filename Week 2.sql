-- WEEK 2: DATA EXPLORATION EXERCISES

-- RECORD COUNTS & DISTINCT VALUES

-- (1) Which actor_id has the most number of unique film_id records in the dvd_rentals.film_actor table?
SELECT
  actor_id,
  COUNT(DISTINCT film_id) as unique_count
FROM dvd_rentals.film_actor
GROUP BY actor_id
ORDER BY unique_count DESC
LIMIT 1;

-- (2) How many distinct fid values are there for the 3rd most common price value in the dvd_rentals.nicer_but_slower_film_list table?
SELECT
  price,
  COUNT(DISTINCT fid) as count_value
FROM dvd_rentals.nicer_but_slower_film_list
GROUP BY price
ORDER BY count_value DESC
LIMIT 3;

-- (3) How many unique country_id values exist in the dvd_rentals.city table?
SELECT
  COUNT(DISTINCT country_id) as unique_countryids
FROM dvd_rentals.city

-- (4) What percentage of overall total_sales does the Sports category make up in the dvd_rentals.sales_by_film_category table?
-- Note, empty over clause in OVER() means over all rows of the result
SELECT
  category,
  ROUND(100 * total_sales::NUMERIC / SUM(total_sales) OVER (), 2) AS percentage
FROM dvd_rentals.sales_by_film_category;

-- (5) What percentage of unique fid values are in the Children category in the dvd_rentals.film_list table?
--Note, SUM(COUNT(DISTINCT fid) is the sum of distinct fid's in the entire original dataset
SELECT
  category,
  ROUND(100 * COUNT(DISTINCT fid)::NUMERIC / SUM(COUNT(DISTINCT fid)) OVER(), 2) as percentage
FROM dvd_rentals.film_list
GROUP by category
ORDER BY category;