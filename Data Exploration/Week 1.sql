-- WEEK 1: DATA EXPLORATION EXERCISES

-- SELECT & SORT DATA

-- (1) What is the name of the category with the highest category_id in the dvd_rentals.category table?
SELECT
    name,
    category_id
FROM dvdrentals.category
ORDER BY category_id DESC
LIMIT 1;

-- (2) For the films with the longest length, what is the title of the “R” rated film with the lowest replacement_cost in dvd_rentals.film table?
SELECT
    title,
    length,
    replacement_cost,
    rating
FROM dvd_rentals.film
WHERE rating = 'R'
ORDER BY
    length DESC,
    replacement_cost
LIMIT 1;

-- (3) Who was the manager of the store with the highest total_sales in the dvd_rentals.sales_by_store table?
SELECT
    manager,
    store,
    total_sales
FROM dvd_rentals.sales_by_store
ORDER BY total_sales DESC
LIMIT 1;

-- (4) What is the postal_code of the city with the 5th highest city_id in the dvd_rentals.address table?
-- This solution shows 5 top cities -> How to list only the 5th highest?
SELECT
    city_id,
    postal_code
FROM dvd_rentals.address
ORDER BY city_id DESC
LIMIT 5;