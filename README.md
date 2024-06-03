# Pizza Runner

## Project Overview
Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

## Data Description
Danny provided the date of his restaurant that contains 3 following tables:

1. **`Pizza_names:`** This table contains data about pizza_id and pizza_name.

2. **`pizza_recipes:`** This table contains data about pizza_id and toppings.

3. **`pizza_toppings:`** This table contains data about topping_id and topping_name.

4. **`runners:`** This table contains data about runner_id and registration_date.

5. **`customer_orders:`** This table contains data about order_id, customer_id, pizza_id, exclusions and extrasorder_time.

6. **`runner_orders:`** This table contains data about order_id, runner_id, pickup_time, distance_km, duration_minute and cancellation.

![Screenshot 2024-06-03 111721](https://github.com/diptiranjan1998/Pizza-Runner/assets/126856016/8de9b940-664d-4ff2-85a6-798cf7d59be9)

## Case Studies
Each of the following case study questions provides Danny with some valuable business insights:

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

  * Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program. The rough example given below:

![Screenshot 2024-06-03 104954](https://github.com/diptiranjan1998/Danny-s-Dinner/assets/126856016/6fcc6b57-9617-4efd-8569-5ce4fbcfb906)

### Run this [SQL Script](https://drive.google.com/file/d/1rBo6b2IgJsUx2KQh6EIYwzPj6UdiftYr/view?usp=drive_link) to get the comprehensive answers to above case study questions.

## THANK YOU
