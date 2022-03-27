-- Case Study 1 - Danny's Diner Solutions

-- 1. What is the total amount each customer spent at the restaurant?
WITH temp AS (
  SELECT
    s.customer_id,
    m.price
  FROM dannys_diner.sales s
  JOIN dannys_diner.menu m on (s.product_id = m.product_id)
)
SELECT
  customer_id,
  SUM(price) as amount_spent
FROM temp
GROUP BY customer_id
ORDER BY customer_id;

 customer_id | amount_spent
-------------+--------------
 A           |           76
 B           |           74
 C           |           36

-- 2. How many days has each customer visited the restaurant?
WITH temp AS (
  SELECT
    s.customer_id,
    m.price
  FROM dannys_diner.sales s
  JOIN dannys_diner.menu m on (s.product_id = m.product_id)
)
SELECT
  customer_id,
  SUM(price) as amount_spent
FROM temp
GROUP BY customer_id
ORDER BY customer_id;

 customer_id | amount_spent
-------------+--------------
 A           |           76
 B           |           74
 C           |           36

-- 3. What was the first item from the menu purchased by each customer?
WITH temp AS (
  SELECT
    s.customer_id,
    m.product_name,
    s.order_date,
    ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date ASC) AS order_number
  FROM dannys_diner.sales s
  JOIN dannys_diner.menu m on (s.product_id = m.product_id)
)
SELECT
  customer_id,
  product_name
FROM temp
WHERE order_number = 1;

 customer_id | product_name
-------------+--------------
 A           | curry
 B           | curry
 C           | ramen

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

-- 5. Which item was the most popular for each customer?

-- 6. Which item was purchased first by the customer after they became a member?

-- 7. Which item was purchased just before the customer became a member?

-- 8. What is the total items and amount spent for each member before they became a member?

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not
--     just sushi - how many points do customer A and B have at the end of January?
