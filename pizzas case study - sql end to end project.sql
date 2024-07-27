create table orders ( order_id int not null, 
order_date date not null , order_time time not null,
primary key (order_id) )


select * from pizzahut.orders

create table orders_details (order_details_id int not null,
 order_id int not null, 
 pizza_id text not null,
 quantity int not null,
primary key (order_details_id) )

-- Retrieve the total number of orders placed
select count(order_id) as total_orders 
from orders
-- Calculate total revenue generated from pizza sales 
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id; 
-- identify the  highest priced pizza

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1


-- most common pizza size ordered

SELECT 
    pizzas.size, COUNT(order_details.order_details_id)
FROM
    pizzas
        JOIN
    orders_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY quantity
 
 -- most ordered pizza types along with quantities
 SELECT 
    pizza_types.name,
    SUM(order_details.quantity_ordered) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id; 
 group by pizza_types.name
 order by sum(order_details.quantity_ordered) desc limit 5 ;
 
 -- total qty of each pizza category ordered
SELECT 
    pizza_types.category,
    SUM(order_details.quantity_ordered) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY SUM(order_details.quantity_ordered) DESC
 
 -- Determine distribution of orders by hours of the day:
 
 SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time); 
 
 --  join relevant tables ot find category-wise distribution of pizzas
 select category, count(name) from pizza_types
 group by category 
 
 -- group orders by date and calculate average number of pizzas ordered per day
 
 select round avg(quantity),0) as avg_quantity_ordered from(
 select orders.order_date,
 sum(order_details.quantity) as quantity
 from orders 
 join order_details
 on orders.order_id = order_details.order_id
 group by  orders.order_date) x ; 
 
 -- top 3 most ordered pizza based on revenue 
 select pizza_types.name, 
 sum(order_details.quantity * pizzas.price) as revenue
 from pizza_types join pizzas
 on pizzas.pizza_type_id = pizza_types.pizza_type_id
 join order_details
 on order_details.pizza_id = pizzas.pizza_id
 group by pizza_types.name
 order by revenue desc limit 3; 
 
 -- %contribution of each pizza type(category) to total revenue
 select pizza_types.category
 , round(sum(order_details.quantity*pizzas.price)/(SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales 
            FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id) *100,2) as revenue
 from pizza_types
 join pizzas 
 on pizza_types.pizza_type_id = pizzas.pizza_type_id
 join order_details
 on order_details.pizza_id = pizzas.pizza_id
 group by pizza_types.category
 order by revenue desc ; 
 
 -- cumulative revenue generated over time
 select order_date,
 sum(revenue) over (order by order_date) as cum_revenue from
 (select orders.order_date, 
 sum(order_details.quantity * pizzas.price) as revenue
 from order_details
 join pizzas on order_details.pizza_id = pizzas.pizza_id
 join orders on orders.order_id = order_details.order_id
 group by orders.order_date) as sales;
 
-- Determine top 3 pizza ordered types 
-- based on revenue for each pizza category :
select name, revenue from 
(select category, name,revenue,
rank() over (partition by category order by revenue desc) as rn 
from
(select pizza_types.category, pizza_types.name,
sum((order_details.quantity)*pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
 join order_details
 on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name
order by revenue) as a) as b
where rn <=3;


