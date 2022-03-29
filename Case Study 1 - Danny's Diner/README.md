# SQL Case Study 1 - Danny's Diner
[🍦 View My Profile](https://github.com/chris-minsik-son)
[🍰 View Repositories](https://github.com/chris-minsik-son?tab=repositories)
[🍨 View Main Folder](https://github.com/chris-minsik-son/SQL-Code)

## Table of Contents
  - [Context](#context)
  - [Problem Statement](#problem-statement)
  - [Available Data](#available-data)
  - [Case Study Questions](#case-study-questions)
  - [Solutions](#solutions)

<p align="center">
<img src="/Images/case-study-1.png" width=40% height=40%>

## Context
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen. <br>
Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

## Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers. <br>
He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

## Available Data
Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!
<br>
Danny has shared with you 3 key datasets for this case study:
- Sales
- Menu
- Members

### Table 1: Sales
The ```sales``` table captures all ```customer_id``` level purchases with an corresponding ```order_date``` and ```product_id``` information for when and what menu items were ordered.

|customer_id|order_date|product_id|
|-----------|----------|----------|
|A          |2021-01-01|1         |
|A          |2021-01-01|2         |
|A          |2021-01-07|2         |
|A          |2021-01-10|3         |
|A          |2021-01-11|3         |
|A          |2021-01-11|3         |
|B          |2021-01-01|2         |
|B          |2021-01-02|2         |
|B          |2021-01-04|1         |
|B          |2021-01-11|1         |
|B          |2021-01-16|3         |
|B          |2021-02-01|3         |
|C          |2021-01-01|3         |
|C          |2021-01-01|3         |
|C          |2021-01-07|3         |

### Table 2: Menu
The ```menu``` table maps the ```product_id``` to the actual ```product_name``` and ```price``` of each menu item.

|product_id |product_name|price     |
|-----------|------------|----------|
|1          |sushi       |10        |
|2          |curry       |15        |
|3          |ramen       |12        |

### Table 3: Members
The final ```members table``` captures the ```join_date``` when a ```customer_id``` joined the beta version of the Danny’s Diner loyalty program.

|customer_id|join_date |
|-----------|----------|
|A          |1/7/2021  |
|B          |1/9/2021  |

## Case Study Questions
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

## Solutions
**1. What is the total amount each customer spent at the restaurant?**
```sql
WITH temp AS (
  SELECT
    sales.customer_id,
    menu.price
  FROM dannys_diner.sales
  JOIN dannys_diner.menu ON (sales.product_id = menu.product_id)
)
SELECT
  customer_id,
  SUM(price) AS amount_spent
FROM temp
GROUP BY customer_id
ORDER BY customer_id;
```

| customer_id | amount_spent |
|-------------|--------------|
| A           |           76 |
| B           |           74 |
| C           |           36 |

---

**2. How many days has each customer visited the restaurant?**
```sql
SELECT
  customer_id,
  COUNT(distinct order_date) as visits
FROM dannys_diner.sales
GROUP BY customer_id;
```

| customer_id | visits |
|-------------|--------|
| A           |      4 |
| B           |      6 |
| C           |      2 |

---

**3. What was the first item from the menu purchased by each customer?**
```sql
WITH temp AS (
  SELECT
    sales.customer_id,
    menu.product_name,
    sales.order_date,
    ROW_NUMBER() OVER(PARTITION BY sales.customer_id ORDER BY sales.order_date ASC) AS order_number
  FROM dannys_diner.sales
  JOIN dannys_diner.menu ON (sales.product_id = menu.product_id)
)
SELECT
  customer_id,
  product_name
FROM temp
WHERE order_number = 1;
```

| customer_id | product_name |
|-------------|--------------|
| A           | curry        |
| B           | curry        |
| C           | ramen        |

---

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**
```sql
SELECT
  menu.product_name,
  COUNT(menu.product_id)
FROM dannys_diner.sales
JOIN dannys_diner.menu ON (sales.product_id = menu.product_id)
GROUP BY menu.product_name
ORDER BY count DESC;
```

| product_name | count |
|--------------+-------|
| ramen        |     8 |
| curry        |     4 |
| sushi        |     3 |

---

**5. Which item was the most popular for each customer?**
```sql
WITH temp AS (
  SELECT
    sales.customer_id,
    menu.product_name,
    COUNT(menu.product_name),
    RANK() OVER(PARTITION BY sales.customer_id ORDER BY COUNT(menu.product_name) DESC) AS order_rank
  FROM dannys_diner.sales
  JOIN dannys_diner.menu ON (sales.product_id = menu.product_id)
  GROUP BY sales.customer_id, menu.product_name
  ORDER BY sales.customer_id, order_rank ASC
)
SELECT
  customer_id,
  product_name AS most_popular
FROM temp
WHERE order_rank = 1;
```

| customer_id | most_popular |
|-------------|--------------|
| A           | ramen        |
| B           | sushi        |
| B           | curry        |
| B           | ramen        |
| C           | ramen        |

---

**6. Which item was purchased first by the customer after they became a member?**
```sql
WITH temp AS (
  SELECT
    sales.customer_id,
    sales.order_date,
    members.join_date,
    menu.product_name,
    RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date ASC) AS order_rank
  FROM dannys_diner.sales
  JOIN dannys_diner.menu ON (sales.product_id = menu.product_id)
  JOIN dannys_diner.members ON (sales.customer_id = members.customer_id)
  WHERE sales.order_date >= members.join_date
  ORDER BY sales.customer_id, sales.order_date
)
SELECT
  customer_id,
  product_name
FROM temp
WHERE order_rank = 1;
```

| customer_id | product_name |
|-------------|--------------|
| A           | curry        |
| B           | sushi        |

---

**7. Which item was purchased just before the customer became a member?**
```sql
WITH temp AS (
  SELECT
    sales.customer_id,
    sales.order_date,
    members.join_date,
    menu.product_name,
    RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date DESC) AS order_rank
  FROM dannys_diner.sales
  JOIN dannys_diner.menu ON (sales.product_id = menu.product_id)
  JOIN dannys_diner.members ON (sales.customer_id = members.customer_id)
  WHERE sales.order_date < members.join_date
  ORDER BY sales.customer_id, sales.order_date
)
SELECT
  customer_id,
  product_name
FROM temp
WHERE order_rank = 1;
```

| customer_id | product_name |
|-------------|--------------|
| A           | sushi        |
| A           | curry        |
| B           | sushi        |

---

**8. What is the total items and amount spent for each member before they became a member?**
```sql
WITH temp AS (
  SELECT
    sales.customer_id,
    sales.order_date,
    members.join_date,
    menu.product_name,
    menu.price
  FROM dannys_diner.sales
  JOIN dannys_diner.menu ON (sales.product_id = menu.product_id)
  JOIN dannys_diner.members ON (sales.customer_id = members.customer_id)
  WHERE sales.order_date < members.join_date
  ORDER BY sales.customer_id
)
SELECT
  customer_id,
  COUNT(*) AS total_items,
  SUM(price) AS amount_spent
FROM temp
GROUP BY customer_id;
```

| customer_id | total_items | amount_spent |
|-------------|-------------|--------------|
| A           |           2 |           25 |
| B           |           3 |           40 |

---

**9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**
```sql
WITH temp AS (
  SELECT
    sales.customer_id,
    menu.product_name,
    menu.price
  FROM dannys_diner.sales
  JOIN dannys_diner.menu ON (sales.product_id = menu.product_id)
  ORDER BY customer_id
)
SELECT
  customer_id,
  SUM(
    CASE
      WHEN product_name = 'sushi' THEN 20 * price
      ELSE 10 * price
    END
  ) AS points
FROM temp
GROUP BY customer_id;
```

| customer_id | points |
|-------------|--------|
| A           |    860 |
| B           |    940 |
| C           |    360 |

---

**10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**