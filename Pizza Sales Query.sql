/*	Question Set 1 - Easy */

/* Q1: Retrieve the total number of orders placed. */

SELECT 
    COUNT(order_id) AS total_orders
FROM
    pizzahut.orders;


/* Q2: Calculate the total revenue generated from pizza sales. */

SELECT 
    ROUND(SUM(orders_details.quantity * pizzas.price),2) AS total_sales
FROM
    pizzahut.orders_details
        JOIN
    pizzahut.pizzas ON orders_details.pizza_id = pizzas.pizza_id


/* Q3: Identify the highest-priced pizza. */

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizzahut.pizza_types
        JOIN
    pizzahut.pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


/* Q4: Identify the most common pizza size ordered. */

SELECT 
    pizzas.size,
    COUNT(orders_details.order_details_id) AS most_ordered_size
FROM
    pizzahut.orders_details
        JOIN
    pizzahut.pizzas ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.size
ORDER BY most_ordered_size DESC;


/* Q5: List the top 5 most ordered pizza types along with their quantities.*/

SELECT 
    pizza_types.name,
    SUM(orders_details.quantity) AS total_quantity
FROM
    pizzahut.pizza_types
        JOIN
    pizzahut.pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    pizzahut.orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total_quantity DESC
LIMIT 5




/* Question Set 2 - Moderate */

/* Q1: Join the necessary tables to find the total quantity of each pizza category ordered. */

SELECT 
    pizza_types.category,
    SUM(orders_details.quantity) AS quantity
FROM
    pizzahut.orders_details
        JOIN
    pizzahut.pizzas ON orders_details.pizza_id = pizzas.pizza_id
        JOIN
    pizzahut.pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.category
ORDER BY quantity DESC

/* Q2: Determine the distribution of orders by hour of the day. */

SELECT 
    HOUR(order_time) AS hours, COUNT(order_id) AS order_count
FROM
    pizzahut.orders
GROUP BY hours


/* Q3: Join relevant tables to find the category-wise distribution of pizzas. */

SELECT 
    category, COUNT(name) AS pizza_categories
FROM
    pizzahut.pizza_types
GROUP BY category


/* Q4: Group the orders by date and calculate the average number of pizzas ordered per day. */

SELECT 
    ROUND(AVG(quantity), 0)
FROM
    (SELECT 
        orders.order_date, SUM(orders_details.quantity) AS quantity
    FROM
        pizzahut.orders
    JOIN pizzahut.orders_details ON orders.order_id = orders_details.order_id
    GROUP BY orders.order_date) AS order_quantity;


/* Q5: Determine the top 3 most ordered pizza types based on revenue. */

SELECT 
    pizza_types.name,
    SUM(orders_details.quantity * pizzas.price) AS revenue
FROM
    pizzahut.pizza_types
        JOIN
    pizzahut.pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    pizzahut.orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;




/* Question Set 3 - Advance */

/* Q1: Calculate the percentage contribution of each pizza type to total revenue. */

SELECT 
    pizza_types.category,
    ROUND(SUM(orders_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(orders_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    pizzahut.orders_details
                        JOIN
                    pizzahut.pizzas ON orders_details.pizza_id = pizzas.pizza_id) * 100,
            2) AS revenue
FROM
    pizzahut.pizza_types
        JOIN
    pizzahut.pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    pizzahut.orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

/* Q2: Analyze the cumulative revenue generated over time. */

select order_date,
round(sum(revenue) over (order by order_date),2) as cum_revenue
from
(select orders.order_date,
sum(orders_details.quantity*pizzas.price) as revenue
from pizzahut.orders join pizzahut.orders_details
on orders.order_id = orders_details.order_id
join pizzahut.pizzas
on orders_details.pizza_id = pizzas.pizza_id
group by orders.order_date) as sales


/* Q3: Determine the top 3 most ordered pizza types based on revenue for each pizza category. */

select name, revenue
from
(select category, revenue, name,
rank () over(partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name,
sum(orders_details.quantity * pizzas.price) as revenue
from pizzahut.pizza_types join pizzahut.pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join pizzahut.orders_details on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where rn <=3;



/* Thank You :) */
