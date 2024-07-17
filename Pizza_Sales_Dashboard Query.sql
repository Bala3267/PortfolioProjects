/* 
	Pizza Sales Data Analysis Reporet for Power BI Visualization

*/

-- Creating New Database 
Create Database Pizza_sales

use Pizza_sales
select * from orders
select * from order_details
where quantity>1

use pizza_sales


--Pizza Sales KPI
-----------------------------------------------------------------------------------------------------

-- Total Revenue 
select round(sum(quantity * price),2) as Total_Revenue from orders o
join order_details od on o.order_id=od.order_id
join pizzas p on od.pizza_id=p.pizza_id

-- Total Pizza Sold
select sum(quantity) as total_pizza_sold from order_details

--Total Pizza orders
select count(distinct order_id) as Total_Orders from order_details

-- Average Order value
select round(sum(quantity * price)/COUNT(distinct order_id),2) as Average_Value_Per_Order 
from order_details od
join pizzas p on od.pizza_id=p.pizza_id

-- Average Pizz Sold Per Order
select round(cast(sum(quantity) as float)/cast(COUNT(distinct order_id) as float),2) as Average_Pizza_Sold_Per_Order 
from order_details

--How does the total number of orders vary by day and month?
-- a) How does the total number of order vary by day?
select DATENAME(WEEKDAY,o.date) as Days,count(distinct od.order_id) as Total_Orders from order_details od
join orders o on od.order_id=o.order_id
join pizzas p on od.pizza_id=p.pizza_id
group by  DATENAME(WEEKDAY,o.date)
order by Total_Orders desc;

-- How does the total number of orders vary by month?
select DATENAME(MONTH,o.date) as Days,count(distinct od.order_id) as Total_Orders from order_details od
join orders o on od.order_id=o.order_id
join pizzas p on od.pizza_id=p.pizza_id
group by  DATENAME(MONTH,o.date)
order by Total_Orders desc;

--What are the percentages of sales by pizza category and size?

-- a) What are the percentages of sales by pizza category?

select pt.category as Category,
	round(sum(quantity * price)/(select sum(quantity * price) as Total_Revenue from order_details od
								 join pizzas p on od.pizza_id = p.pizza_id)*100,2) as Category_Percentage 
from order_details od
join pizzas p on od.pizza_id=p.pizza_id
join pizza_types pt on p.pizza_type_id=pt.pizza_type_id
group by pt.category
order by Category_Percentage desc

-- b) What are the percetage of sales by pizza size
select p.size as Size,
		round(sum(quantity * price)/(select sum(quantity * price) as Total_Revenue from order_details od
							    join pizzas p on od.pizza_id = p.pizza_id)*100,2) as Total_Quantity_percentage
from order_details od
join pizzas p on od.pizza_id=p.pizza_id
group by p.size
order by Total_Quantity_percentage desc;

--What are the top 5 and bottom 5 pizzas by revenue, quantity, and orders?

-- a) What are the top 5 pizza by revenue?
select top 5 pt.name as Pizza_Name,round(sum(od.quantity *p.price),2) as Total_Revenue 
from order_details od
	join pizzas p on od.pizza_id=p.pizza_id
	join pizza_types pt on p.pizza_type_id= pt.pizza_type_id
group by pt.name
order by Total_Revenue desc

-- b) What are the bottom 5 by pizza by revenue?
select top 5 pt.name as Pizza_Name,round(sum(od.quantity *p.price),2) as Total_Revenue 
from order_details od
	join pizzas p on od.pizza_id=p.pizza_id
	join pizza_types pt on p.pizza_type_id= pt.pizza_type_id
group by pt.name
order by Total_Revenue asc 

-- c) What are the top 5 pizza by quantity?
select top 5 p.pizza_id,sum(quantity) as Total_Quantity from order_details od
	join pizzas p on od.pizza_id= p.pizza_id
	group by p.pizza_id
	order by Total_Quantity desc;
-- d) What are the bottom 5 pizza by quantity?
select top 5 p.pizza_id,sum(quantity) as Total_Quantity from order_details od
	join pizzas p on od.pizza_id= p.pizza_id
	group by p.pizza_id
	order by Total_Quantity asc;

-- e) What are the top 5 pizza by Orders?
select * from order_details od
join orders o on od.order_id=o.order_id



-- f) What are the bottom 5 pizza by Orders?
select * from order_details
select * from orders


/*   ------Project Has been Completed -------------*/