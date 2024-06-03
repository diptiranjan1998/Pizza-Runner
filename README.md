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
1. **Pizza Metrics**
   * How many pizzas were ordered?
   * How many unique customer orders were made?
   * How many successful orders were delivered by each runner?
   * How many of each type of pizza was delivered?
   * How many Vegetarian and Meatlovers were ordered by each customer?
   * What was the maximum number of pizzas delivered in a single order?
   * For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
   * How many pizzas were delivered that had both exclusions and extras?
   * What was the total volume of pizzas ordered for each hour of the day?
   * What was the volume of orders for each day of the week?

2. **Runner and Customer Experience**
    * How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
    * What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
    * Is there any relationship between the number of pizzas and how long the order takes to prepare?
    * What was the average distance travelled for each customer?
    * What was the difference between the longest and shortest delivery times for all orders?
    * What was the average speed for each runner for each delivery and do you notice any trend for these values?
    * What is the successful delivery percentage for each runner?

3. **Ingredient Optimisation**
What are the standard ingredients for each pizza?
What was the most commonly added extra?
What was the most common exclusion?
Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

4. **Pricing and Ratings**
If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra
The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas
If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?



### Run this [SQL Script](https://drive.google.com/file/d/1KY2JVh9CqSKvLnNJ6M3GqRhKY-vrZo2u/view?usp=drive_link) to get the comprehensive answers to above case study questions.

## THANK YOU
