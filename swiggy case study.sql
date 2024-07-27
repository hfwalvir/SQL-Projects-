-- Create users table
create table users (user_id int, name varchar(255),email varchar(255),
 password varchar);
 
INSERT INTO users (user_id, name, email, password) VALUES
(1, 'Nitish', 'nitish@gmail.com', 'p252h'),
(3, 'Vartika', 'vartika@gmail.com', '9hu7j'),
(4, 'Ankit', 'ankit@gmail.com', 'lkko3'),
(5, 'Anuj', 'anuj@gmail.com', '3i7qm'),
(6, 'Krish', 'krish@gmail.com', '46rdw2'),
(7, 'Rishi', 'rishi@gmail.com', '4sw123');

create table restaurants (r_id int,
        r_name varchar(255),
        cuisine varchar(255));
		
insert into restaurants values
(1,'Olive Essence','Italian'),
(2,'KFC','American'),
(3,'box8','North Indian'),
(4,'Dosa Plaza','South Indian'),
(5,'China Town', 'Chinese');


create table food (f_id int,
       f_name varchar(255),
       type varchar(255));
	   
insert into food values
(1, 'Non-veg Pizza','Non-veg'),
(2, 'Veg Pizza', 'Veg'),
(3, 'Choco Lava cake', 'Veg'),
(4, 'Chicken Wings', 'Non-veg'),
(5, 'Chicken Popcorn', 'Non-veg'),
(6, 'Rice Meal', 'Veg'),
(7, 'Roti meal', 'Veg'),
(8, 'Masala Dosa', 'Veg'),
(9, 'Rava Idli', 'Veg'),
(10,'Schezwan Noodles', 'Veg'),
(11,'Veg Manchurian','Veg');

create table menu (menu_id int,
       r_id int,
       f_id int,
       price int);

INSERT INTO menu (menu_id, r_id, f_id, price) VALUES
(1, 1, 1, 450),
(2, 1, 2, 400),
(3, 1, 3, 100),
(4, 2, 3, 115),
(5, 2, 4, 230),
(6, 2, 5, 300),
(7, 3, 3, 80),
(8, 3, 6, 160),
(9, 3, 7, 140),
(10, 4, 6, 230),
(11, 4, 8, 180),
(12, 4, 9, 120),
(13, 5, 6, 250),
(14, 5, 10, 220),
(15, 5, 11, 180);

create table orderss(order_id int,
     user_id int,
     r_id int,
     amount int,
     date date, 
     partner_id int,
     delivery_time int,
     delivery_rating int,
     restaurant_rating int);

INSERT INTO orderss(order_id, user_id, r_id, amount, date, partner_id, delivery_time, delivery_rating, restaurant_rating) VALUES
(1001, 1, 1, 550, '2022-05-10', 1, 25, 5, 3),
(1002, 1, 2, 415, '2022-05-26', 1, 19, 5, 2),
(1003, 1, 3, 240, '2022-06-15', 5, 29, 4, NULL),
(1004, 1, 3, 240, '2022-06-29', 4, 42, 3, 5),
(1005, 1, 3, 220, '2022-07-10', 1, 58, 1, 4),
(1006, 2, 1, 950, '2022-06-10', 2, 16, 5, NULL),
(1007, 2, 2, 530, '2022-06-23', 3, 60, 1, 5),
(1008, 2, 3, 240, '2022-07-07', 5, 33, 4, 5),
(1009, 2, 4, 300, '2022-07-17', 4, 41, 1, NULL),
(1010, 2, 5, 650, '2022-07-31', 1, 67, 1, 4),
(1011, 3, 1, 450, '2022-05-10', 2, 25, 3, 1),
(1012, 3, 4, 180, '2022-05-20', 5, 33, 4, 1),
(1013, 3, 2, 230, '2022-05-30', 4, 45, 3, NULL),
(1014, 3, 2, 230, '2022-06-11', 2, 55, 1, 2),
(1015, 3, 2, 230, '2022-06-22', 3, 21, 5, NULL),
(1016, 4, 4, 300, '2022-05-15', 3, 31, 5, 5),
(1017, 4, 4, 300, '2022-05-30', 1, 50, 1, NULL),
(1018, 4, 4, 400, '2022-06-15', 2, 40, 3, 5),
(1019, 4, 5, 400, '2022-06-30', 1, 70, 2, 4),
(1020, 4, 5, 400, '2022-07-15', 3, 26, 5, 3),
(1021, 5, 1, 550, '2022-07-01', 5, 22, 2, NULL),
(1022, 5, 1, 550, '2022-07-08', 1, 34, 5, 1),
(1023, 5, 2, 645, '2022-07-15', 4, 38, 5, 1),
(1024, 5, 2, 645, '2022-07-21', 2, 58, 2, 1),
(1025, 5, 2, 645, '2022-07-28', 2, 44, 4, NULL);

CREATE TABLE delivery_partners (
  partner_id INT,
  partner_name VARCHAR(50)
);

INSERT INTO delivery_partners (partner_id, partner_name) VALUES
(1, 'Suresh'),
(2, 'Amit'),
(3, 'Lokesh'),
(4, 'Kartik'),
(5, 'Gyandeep');

CREATE TABLE order_details (
  id INT,
  order_id INT,
  f_id INT
);
INSERT INTO order_details (id, order_id, f_id) VALUES
(1, 1001, 1),
(2, 1001, 3),
(3, 1002, 4),
(4, 1002, 3),
(5, 1003, 6),
(6, 1003, 3),
(7, 1004, 6),
(8, 1004, 3),
(9, 1005, 7),
(10, 1005, 3),
(11, 1006, 1),
(12, 1006, 2),
(13, 1006, 3),
(14, 1007, 4),
(15, 1007, 3),
(16, 1008, 6),
(17, 1008, 3),
(18, 1009, 8),
(19, 1009, 9),
(20, 1010, 10),
(21, 1010, 11),
(22, 1010, 6),
(23, 1011, 1),
(24, 1012, 8),
(25, 1013, 4),
(26, 1014, 4),
(27, 1015, 4),
(28, 1016, 8),
(29, 1016, 9),
(30, 1017, 8),
(31, 1017, 9),
(32, 1018, 10),
(33, 1018, 11),
(34, 1019, 10),
(35, 1019, 11),
(36, 1020, 10),
(37, 1020, 11),
(38, 1021, 1),
(39, 1021, 3),
(40, 1022, 1),
(41, 1022, 3),
(42, 1023, 3),
(43, 1023, 4),
(44, 1023, 5),
(45, 1024, 3),
(46, 1024, 4),
(47, 1024, 5),
(48, 1025, 3),
(49, 1025, 4),
(50, 1025, 5);


--writing queries
--1) customers who never ordered
select name from users
where user_id not in (select user_id from orders);

--2) Average Price per dish (desc order)
select * from food;
select * from menu;
select f_name, AVG(me.price)
from menu me
join food fo on me.f_id = fo.f_id 
group by fo.f_name, me.f_id
order by AVG(me.price) desc;

--3) top rstaurant in terms of the number of orders for a given month

select * from orderss
select * from restaurants
select r.r_name, o.r_id, COUNT(*) as count_of_orders
from orderss o
join restaurants r
on o.r_id = r.r_id
where extract(month from date) = 6
group by o.r_id, r.r_name
order by count_of_orders
limit 1

--4 Resaurant sales greater than a amount(600) in the month of July

select r.r_name, o.r_id, sum(amount) as "revenue"
from orderss o
join restaurants r 
on o.r_id = r.r_id 
where extract(month from date) = 7
group by o.r_id, r.r_name
having sum(amount) > 600;

-- 5) details of orders for a customer in a particular date range
select * from order_details;
select o.order_id, r.r_name, f.f_name
from orderss  o
join restaurants r
on o.r_id = r.r_id
join order_details od 
on od.order_id=o.order_id
join food f 
on f.f_id = od.f_id
where user_id = (select user_id from users where user_id =5 LIMIT 1)
and date>'2022-07-01' and date < '2022-09-01';

--6) restaurants with max repeated customers
select r.r_name, x.r_id, count(*) as "count_of_loyal_cust"
from (
   select r_id, user_id, count(*) as "no_of_visits" 
  from orderss
   group by r_id, user_id
   having count(*)>1) x
join restaurants as r
on x.r_id = r.r_id
group by x.r_id, r.r_name
order by count_of_loyal_cust desc
limit 1;

-- 7 ) most loyal customers for all restaurants 
select * from users
select * from restaurants
select * from orderss
select r.r_name, count(*) total_loyal_customers, u.name
from (
      select r_id, user_id, count(*) no_of_visits
      from orderss
       group by r_id, user_id
       having count(*)>1 ) j
join restaurants r
on j.r_id = r.r_id
join users u
on j.user_id = u.user_id 
group by j.r_id, r.r_name, u.name
order by total_loyal_customers desc;

--8) Month-over-month revenue growth of Swiggy
select * from orderss
with sales as 
         (
		 select extract(month from date) as mon, sum(amount) as sale
		 from orderss 
		 group by extract(month from date)
		 order by extract(month from date) asc
		 )
select mon, sale,prev, (sale-prev)/prev::numeric*100 as growth_percent
from (
      select mon,sale,lag(sale,1) over (order by sale asc) as prev
	  from sales) x 
	  
--9) month-over-month revenue growth of a restaurant

with sales as
         ( 
		 select extract(month from date) as mon,
		 r.r_name,
		 sum(amount) as SALE
		 from orderss o
		 join restaurants r on o.r_id= r.r_id
		 where r.r_id = 2
		 group by o.r_id, r.r_name, mon
		 order by mon asc)

select j.mon, j.SALE, j.prev, (j.sale-j.prev)::numeric*100 as growth
from (select mon, SALE, lag(SALE,1) over (order by SALE asc) as prev
	 from sales) j

-- 10) fav food of customers :

select * from order_details;
with food_details as (
      select o.user_id, od.f_id, count(*) as Frequency 
	from orderss o
	join order_details od
	on o.order_id = od.order_id
	group by o.user_id, od.f_id
	order by o.user_id asc)

select u.name, fd.user_id, f.f_name, Frequency 
from food_details as fd
join users u on fd.user_id = u.user_id
join food f on fd.f_id = f.f_id
where fd.Frequency = 
(select max(Frequency)
from food_details fd1
where fd.user_id = fd1.user_id);


-- 11) Top selling items across all restaurants :
select f.f_name, COUNT(od.id) as no_of_orders
from food f
join order_details od on f.f_id = od.f_id
group by f.f_name
order by no_of_orders desc
limit 6;

--12) Delivery time by delivery partner
select dp.partner_name, sum(o.delivery_time) as delivery_time
from orderss o 
join delivery_partners dp on o.partner_id = dp.partner_id
group by dp.partner_name; 

--13) Customer satisfaction ratings for each restaurant :
select r.r_name, sum(o.restaurant_rating) as rating
from orderss o
join restaurants r on o.r_id = r.r_id
where o.restaurant_rating is NOT NULL
group by r.r_name
ORDER BY rating;

--14) Customer retention rate by month and restaurant
with monthlycust as (
                       select 
	                   extract(month from o.date) as mon,
	                   o.r_id, r.r_name,
	                   count(distinct o.user_id) as total_customers
	                   from orderss o
	                   join restaurants r on o.r_id = r.r_id
	                   group by mon, o.r_id, r.r_name)
					   
select mon,r_id, r_name, total_customers, (total_customers/sum(total_customers) OVER (PARTITION BY mon)) AS retention_rate
from monthlycust
order by mon;

--15)Busiest Day of the Week:
Select to_char(o.date,'Day') as day_of_week,count(*) as total_orders
from orderss o
group by day_of_week
order by total_orders desc
LIMIT 3;

--16)Generating Customer Lifetime Value (CLV)
  select o.user_id,r.r_name, AVG(o.amount)* COUNT(DISTINCT o.order_id) as clv
  from orderss o
  join restaurants r on o.r_id = r.r_id
  group by user_id, r.r_name
  order by clv desc;
  
--17) RFM Analysis (Recency, Frequency, Monetary):
select
      o.user_id,
	  EXTRACT (DAY FROM AGE(current_date, max(o.date)))as recency,
	  count(distinct o.order_id) as frequency,
	  sum(o.amount) as monetary
from orderss o
group by o.user_id
order by recency desc, frequency desc, monetary desc;


--18) 
with pivot_data as (
         from crosstab
  
 
 
