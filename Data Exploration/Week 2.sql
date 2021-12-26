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

 actor_id | unique_count
----------+--------------
      107 |           42

-- (2) How many distinct fid values are there for the 3rd most common price value in the dvd_rentals.nicer_but_slower_film_list table?
SELECT
  price,
  COUNT(DISTINCT fid) as count_value
FROM dvd_rentals.nicer_but_slower_film_list
GROUP BY price
ORDER BY count_value DESC
LIMIT 3;

 price | count_value
-------+-------------
  0.99 |         340
  4.99 |         334
  2.99 |         323

-- (3) How many unique country_id values exist in the dvd_rentals.city table?
SELECT
  COUNT(DISTINCT country_id) as unique_countryids
FROM dvd_rentals.city;

 unique_countryids
-------------------
               109

-- (4) What percentage of overall total_sales does the Sports category make up in the dvd_rentals.sales_by_film_category table?
-- Note, empty over clause in OVER() means over all rows of the result
SELECT
  category,
  ROUND(100 * total_sales::NUMERIC / SUM(total_sales) OVER (), 2) AS percentage
FROM dvd_rentals.sales_by_film_category;

  category   | percentage
-------------+------------
 Sports      |       7.88
 Sci-Fi      |       7.06
 Animation   |       6.91
 Drama       |       6.80
 Comedy      |       6.50
 Action      |       6.49
 New         |       6.46
 Games       |       6.35
 Foreign     |       6.33
 Family      |       6.28
 Documentary |       6.26
 Horror      |       5.52
 Children    |       5.42
 Classics    |       5.40
 Travel      |       5.27
 Music       |       5.07

-- (5) What percentage of unique fid values are in the Children category in the dvd_rentals.film_list table?
--Note, SUM(COUNT(DISTINCT fid) is the sum of distinct fid's in the entire original dataset
SELECT
  category,
  ROUND(100 * COUNT(DISTINCT fid)::NUMERIC / SUM(COUNT(DISTINCT fid)) OVER(), 2) as percentage
FROM dvd_rentals.film_list
GROUP by category
ORDER BY category;

  category   | percentage
-------------+------------
 Action      |       6.42
 Animation   |       6.62
 Children    |       6.02
 Classics    |       5.72
 Comedy      |       5.82
 Documentary |       6.82
 Drama       |       6.12
 Family      |       6.92
 Foreign     |       7.32
 Games       |       6.12
 Horror      |       5.62
 Music       |       5.12
 New         |       6.32
 Sci-Fi      |       6.12
 Sports      |       7.32
 Travel      |       5.62