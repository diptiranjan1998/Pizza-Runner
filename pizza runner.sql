CREATE SCHEMA pizza_runner;
SET search_path = pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER PRIMARY KEY UNIQUE NOT NULL,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER PRIMARY KEY UNIQUE NOT NULL,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance_km" DECIMAL,
  "duration_minute" INTEGER,
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance_km", "duration_minute", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20', '32', ''),
  ('2', '1', '2020-01-01 19:10:54', '20', '27', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4', '20', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', NULL, NULL, 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25', '25', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4', '15', 'null'),
  ('9', '2', 'null', NULL, NULL, 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10', '10', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
-- Checking the tables
select * from customer_orders;
select * from pizza_names;
select * from pizza_recipes;
select * from pizza_toppings;
select * from runner_orders;
select * from runners;

-- CASE STUDY

-- A. Pizza Metrics
-- 1. How many pizzas were ordered?
SELECT COUNT(*) AS total_pizzas_ordered
FROM customer_orders;

-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS unique_customer_orders
FROM customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(*) AS successful_orders
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT pn.pizza_name, COUNT(co.order_id) AS total_delivered
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
WHERE ro.cancellation IS NULL
GROUP BY pn.pizza_name;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
    co.customer_id,
    pn.pizza_name,
    COUNT(co.order_id) AS total_orders
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
WHERE pn.pizza_name IN ('Vegetarian', 'Meatlovers')
GROUP BY co.customer_id, pn.pizza_name
ORDER BY co.customer_id, pn.pizza_name;

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT MAX(pizza_count) AS max_pizzas_in_single_order
FROM (
    SELECT co.order_id, COUNT(co.pizza_id) AS pizza_count
    FROM customer_orders co
    JOIN runner_orders ro ON co.order_id = ro.order_id
    WHERE ro.cancellation IS NULL
    GROUP BY co.order_id
) AS order_counts;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
    co.customer_id,
    SUM(CASE 
        WHEN (co.exclusions IS NOT NULL OR co.extras IS NOT NULL) THEN 1 
        ELSE 0 
    END) AS pizzas_with_changes,
    SUM(CASE 
        WHEN (co.exclusions IS NULL AND co.extras IS NULL) THEN 1 
        ELSE 0 
    END) AS pizzas_without_changes
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY co.customer_id
ORDER BY co.customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(*) AS pizzas_with_exclusions_and_extras
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
  AND co.exclusions IS NOT NULL
  AND co.extras IS NOT NULL;

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
    EXTRACT(HOUR FROM order_time) AS order_hour,
    COUNT(*) AS total_pizzas_ordered
FROM customer_orders
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY order_hour;

-- 10. What was the volume of orders for each day of the week?
SELECT 
    EXTRACT(DOW FROM order_time) AS day_of_week,
    COUNT(*) AS total_orders
FROM customer_orders
GROUP BY EXTRACT(DOW FROM order_time)
ORDER BY day_of_week;


-- B. Runner and Customer Experience
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT 
    DATE_TRUNC('week', registration_date) AS week_start,
    COUNT(*) AS new_runners_signed_up
FROM runners
WHERE registration_date >= '2021-01-01' -- Start date
GROUP BY DATE_TRUNC('week', registration_date)
ORDER BY week_start;

-- 2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT
    ro.runner_id,
    ROUND(AVG(EXTRACT(EPOCH FROM (ro.pickup_time::TIMESTAMP - co.order_time::TIMESTAMP)) / 60),2) AS average_pickup_time_minutes
FROM
    runner_orders ro
JOIN 
	customer_orders co
ON
	ro.order_id=co.order_id
WHERE
    ro.cancellation IS NULL
GROUP BY
    ro.runner_id;
	
-- 3.Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT pizza_id, COUNT(pizza_id) AS num_pizzas, ROUND(AVG(CAST(duration_minute AS INTEGER)),2) AS avg_duration
FROM customer_orders
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
GROUP BY pizza_id
ORDER BY num_pizzas;
-- Observation: Less preparation time leads to more orders.

-- 4.What was the average distance travelled for each customer?
SELECT
    customer_id,
    COUNT(DISTINCT co.order_id) AS num_orders,
    SUM(ro.distance_km) AS total_distance,
    ROUND(SUM(ro.distance_km) / COUNT(DISTINCT co.order_id),2) AS avg_distance_per_order
FROM
    customer_orders co
JOIN
    runner_orders ro ON co.order_id = ro.order_id
GROUP BY
    customer_id
ORDER BY
    customer_id;
	
-- 5. What was the difference between the longest and shortest delivery times for all orders?
WITH order_delivery_times AS (
    SELECT
        ro.order_id,
		ro.pickup_time::TIMESTAMP - co.order_time::TIMESTAMP AS delivery_time
    FROM
        runner_orders ro
        JOIN customer_orders co ON ro.order_id = co.order_id
	WHERE ro.pickup_time is not NULL and ro.pickup_time != 'null' and co.order_time is not NULL
)
SELECT
    MAX(delivery_time) - MIN(delivery_time) AS time_difference
FROM
    order_delivery_times;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
WITH delivery_speeds AS (
    SELECT
        ro.order_id,
        ro.runner_id,
        ro.distance_km,
        ro.duration_minute,
        ROUND(ro.distance_km / ro.duration_minute, 2) AS average_speed
    FROM
        runner_orders ro
)
SELECT
    runner_id,
    order_id,
    distance_km,
    duration_minute,
    average_speed
FROM
    delivery_speeds;

-- 7. What is the successful delivery percentage for each runner?
WITH delivery_counts AS (
    SELECT
        runner_id,
        COUNT(*) AS total_deliveries,
        SUM(CASE WHEN cancellation != '"Restaurant Cancellation"' THEN 1
				 WHEN cancellation != 'Customer Cancellation' THEN 1
				 ELSE 0 END) AS successful_deliveries
    FROM
        runner_orders
    GROUP BY
        runner_id
)
SELECT
    runner_id,
    successful_deliveries,
    total_deliveries,
    cast((successful_deliveries::float / total_deliveries) * 100 AS VARCHAR) || '%' AS successful_delivery_percentage
FROM
    delivery_counts;

-- C. Ingredient Optimisation
-- 1. What are the standard ingredients for each pizza?
SELECT
    pn.pizza_name,
    pr.toppings
FROM
    pizza_names pn
    JOIN pizza_recipes pr ON pn.pizza_id = pr.pizza_id;

-- 2. What was the most commonly added extra?
WITH extra_counts AS (
    SELECT
        extras,
        COUNT(*) AS extra_count
    FROM
        customer_orders
    WHERE
        extras IS NOT NULL
    GROUP BY
        extras
)
SELECT
    extras,
    extra_count
FROM
    extra_counts
ORDER BY
    extra_count DESC
LIMIT 1;

-- 3. What was the most common exclusion?
WITH exclusion_counts AS (
    SELECT
        exclusions,
        COUNT(*) AS exclusion_count
    FROM
        customer_orders
    WHERE
        exclusions IS NOT NULL
    GROUP BY
        exclusions
)
SELECT
    exclusions,
    exclusion_count
FROM
    exclusion_counts
ORDER BY
    exclusion_count DESC
LIMIT 1;

-- 4. Generate an order item for each record in the customers_orders table
SELECT
    co.order_id,
    pn.pizza_name || 
        CASE
            WHEN co.exclusions IS NOT NULL THEN ' - Exclude ' || string_agg(pt.topping_name, ', ')
            ELSE ''
        END ||
        CASE
            WHEN co.extras IS NOT NULL THEN ' - Extra ' || string_agg(pt.topping_name, ', ')
            ELSE ''
        END AS order_item
FROM
    customer_orders co
JOIN
    pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN
    pizza_recipes pr ON co.pizza_id = pr.pizza_id
JOIN
    pizza_toppings pt ON pt.topping_id = ANY(ARRAY(SELECT UNNEST(string_to_array(pr.toppings, ', '))::INTEGER))
GROUP BY
    co.order_id, pn.pizza_name, co.exclusions, co.extras;

-- 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
SELECT
    co.order_id,
    pn.pizza_name || ': ' ||
        string_agg(
            CASE
                WHEN pt.topping_name IN (SELECT UNNEST(string_to_array(pr.toppings, ', '))) THEN '2x' || pt.topping_name
                ELSE pt.topping_name
            END,
            ', ' ORDER BY pt.topping_name
        ) AS ingredient_list
FROM
    customer_orders co
JOIN
    pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN
    pizza_recipes pr ON co.pizza_id = pr.pizza_id
JOIN
    pizza_toppings pt ON pt.topping_id = ANY(ARRAY(SELECT UNNEST(string_to_array(pr.toppings, ', '))::INTEGER))
GROUP BY
    co.order_id, pn.pizza_name
ORDER BY
    co.order_id;

-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
WITH delivered_pizzas AS (
    SELECT DISTINCT co.order_id
    FROM customer_orders co
    JOIN runner_orders ro ON co.order_id = ro.order_id
    WHERE ro.cancellation IS NULL
),
pizza_ingredients AS (
    SELECT
        co.order_id,
        pt.topping_id,
        pt.topping_name,
        COUNT(pt.topping_id) AS quantity
    FROM
        delivered_pizzas dp
    JOIN
        customer_orders co ON dp.order_id = co.order_id
    JOIN
        pizza_recipes pr ON co.pizza_id = pr.pizza_id
    JOIN
        pizza_toppings pt ON pt.topping_id = ANY(ARRAY(SELECT UNNEST(string_to_array(pr.toppings, ', '))::INTEGER))
    GROUP BY
        co.order_id, pt.topping_id, pt.topping_name
)
SELECT
    topping_name,
    SUM(quantity) AS total_quantity
FROM
    pizza_ingredients
GROUP BY
    topping_name
ORDER BY
    total_quantity DESC;

-- D. Pricing and Ratings
-- 1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
WITH delivered_pizzas AS (
    SELECT DISTINCT co.order_id
    FROM customer_orders co
    JOIN runner_orders ro ON co.order_id = ro.order_id
    WHERE ro.cancellation IS NULL
),
pizza_prices AS (
    SELECT
        co.order_id,
        pn.pizza_name,
        CASE
            WHEN pn.pizza_name = 'Meatlovers' THEN 12
            WHEN pn.pizza_name = 'Vegetarian' THEN 10
            ELSE 0
        END AS price
    FROM
        delivered_pizzas dp
    JOIN
        customer_orders co ON dp.order_id = co.order_id
    JOIN
        pizza_names pn ON co.pizza_id = pn.pizza_id
)
SELECT
    SUM(price) AS total_revenue
FROM
    pizza_prices;

-- 2. What if there was an additional $1 charge for any pizza extras?
-- Add cheese is $1 extra
WITH delivered_pizzas AS (
    SELECT DISTINCT co.order_id
    FROM customer_orders co
    JOIN runner_orders ro ON co.order_id = ro.order_id
    WHERE ro.cancellation IS NULL
),
pizza_prices AS (
    SELECT
        co.order_id,
        pn.pizza_name,
        CASE
            WHEN pn.pizza_name = 'Meatlovers' THEN 12
            WHEN pn.pizza_name = 'Vegetarian' THEN 10
            ELSE 0
        END +
        CASE
            WHEN co.extras LIKE '%1%' THEN 1
            ELSE 0
        END AS price
    FROM
        delivered_pizzas dp
    JOIN
        customer_orders co ON dp.order_id = co.order_id
    JOIN
        pizza_names pn ON co.pizza_id = pn.pizza_id
)
SELECT
    SUM(price) AS total_revenue
FROM
    pizza_prices;

-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
CREATE TABLE IF NOT EXISTS runner_ratings (
    rating_id SERIAL PRIMARY KEY,
    order_id INTEGER ,
    runner_id INTEGER,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    rating_date DATE,
    FOREIGN KEY (order_id) REFERENCES runner_orders(order_id),
    FOREIGN KEY (runner_id) REFERENCES runners(runner_id)
);

INSERT INTO runner_ratings (order_id, runner_id, rating, rating_date)
SELECT
    co.order_id,
    ro.runner_id,
    floor(random() * 5) + 1 AS rating,
    current_date AS rating_date
FROM
    customer_orders co
JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    ro.cancellation IS NULL
    AND co.order_id NOT IN (SELECT order_id FROM runner_ratings);

SELECT * FROM runner_ratings;

-- 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
WITH successful_deliveries AS (
    SELECT
        co.customer_id,
        co.order_id,
        ro.runner_id,
        ra.rating,
        co.order_time,
        ro.pickup_time,
        ro.distance_km,
        ro.duration_minute
    FROM
        customer_orders co
    JOIN
        runner_orders ro ON co.order_id = ro.order_id
    LEFT JOIN
        runner_ratings ra ON co.order_id = ra.order_id
    WHERE
        ro.cancellation IS NULL
)
SELECT
    sd.customer_id,
    sd.order_id,
    sd.runner_id,
    sd.rating,
    sd.order_time,
    sd.pickup_time,
    ROUND(EXTRACT(EPOCH FROM (sd.pickup_time::TIMESTAMP - sd.order_time::TIMESTAMP))/60,2) AS time_between_order_and_pickup_minute,
    sd.duration_minute AS delivery_duration_minute,
    CASE
        WHEN sd.duration_minute > 0 THEN ROUND((sd.distance_km / sd.duration_minute)*60, 2)
		when sd.duration_minute is NULL THEN NULL
        ELSE NULL
    END AS average_speed_km_per_hr,
    COUNT(co.order_id) AS total_number_of_pizzas
FROM
    successful_deliveries sd
JOIN
    customer_orders co ON sd.order_id = co.order_id
GROUP BY
    sd.customer_id,
    sd.order_id,
    sd.runner_id,
    sd.rating,
    sd.order_time,
    sd.pickup_time,
    sd.duration_minute,
    sd.distance_km
ORDER BY
    sd.order_id;

-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
WITH delivery_costs AS (
    SELECT
        ro.order_id,
        ro.runner_id,
        ro.distance_km,
        ro.duration_minute,
        0.30 * ro.distance_km AS runner_cost
    FROM
        runner_orders ro
    WHERE
        ro.cancellation IS NULL
),
pizza_prices AS (
    SELECT
        co.order_id,
        CASE
            WHEN pn.pizza_name = 'Meatlovers' THEN 12
            WHEN pn.pizza_name = 'Vegetarian' THEN 10
            ELSE 0
        END AS pizza_price
    FROM
        customer_orders co
    JOIN
        pizza_names pn ON co.pizza_id = pn.pizza_id
)
SELECT
    SUM(pp.pizza_price) AS total_pizza_revenue,
    SUM(dc.runner_cost) AS total_runner_expenses,
    SUM(pp.pizza_price) - SUM(dc.runner_cost) AS money_left_over
FROM
    pizza_prices pp
JOIN
    delivery_costs dc ON pp.order_id = dc.order_id;


-- THANK YOU