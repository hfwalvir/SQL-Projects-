--1. Write a solution to find the ids of products that are both low fat and recyclable.

select product_id from Products
where low_fats = 'Y'
and recyclable = 'Y';


-- 2. Find Customer Referee (SELECT — Easy):

select name 
from Customer
where referee_id <> 2
or referee_id is null

-- 3. Big Countries (SELECT — Easy):

select name,population, area
from World
where population >= 25000000
or area >= 3000000; 

--4. Article Views I (SELECT — Easy):

select distinct author_id as id
from Views
where author_id = viewer_id
order by 1

--5.  Invalid Tweets (SELECT — Easy):

select tweet_id
from Tweets
where length(content) >15

--6. Replace Employee ID with the Unique Identifier (Basic Joins — Easy)
select coalesce(unique id,null) as unique id,
       name
from Employees e
left join EmployeeUni EU
on e.id = EU.id ;

--7. Product Sales Analysis I (Basic Joins — Easy):
select product_name, year, price 
from Sales S
left join Products P on
S.sale_id = P.product_id;

-- 8. Customer Who Visited But Did Not Make Any Transactions (Basic Joins — Easy):

with no_trans as (
            select * 
            from Visits
            where visit_id not in (
			select visit_id from Transactions)
	       )
select distinct customer id,count(visit_id) as count_no_trans
from no_trans
group by 1

-- 2nd way
select customer_id, count(visit_id) as count_no_trans
from Visits c
left join Transactions t
on v.visit_id = t.visit_id
where t.visit_id is null 
group by 1;

-- 3rd way 
select * 
from (select customer_id, 
	         sum(case when transaction_id is null then 1 else 0 end) as 
	         count_no_trans
	         from Visits v
	         left join Transactions t
	         on v.visit_id = t.visit_id
             group by 1) x
where x.count_no_trans > 0 ;

-- 9. Rising Temperature (Basic Joins — Easy):
select a.id, 
from Weather a
join Weather b on a.id = b.id
where datediff(a.recordDate,b.recordDate)=1
and a.teperature>b.temperature;

--10. Average Time of Process Per Machine (Basic Joins — Easy):

select a.machine_id,round(sum(b.timestamp-a.timestamp)/count(a.process_id),3) as process_time
from Activity a
join Activity b 
on a.machine_id = b.machine_id
and a.process_id = b.process_id
where a.activity_type = "start"
and b.activity_type = "end"
group by 1

--11.Employee Bonus (Basic Joins — Easy):

select e.name,coalesce(n.bonus,null) as bonus
from Employee e
left join Bonus b on e.empId = b.empId
where b.bonus < 1000
or b.bonus is null

--12. Students and Examinations (Basic Joins — Easy):

select s.student_id, s.student_name , sub.subject_name , count(e.subject_name) as attended_exams
from Students s
CROSS JOIN subject sub 
left join examinations e on s.student_id = e.student_id
sub.subject_name = e.subject_name
group by 1,2,3
order by 1,2

--13. Managers with at Least 5 Direct Reports (Basic Joins — Medium):

select name 
from Employee
where id in 
          (
          select managerId
          from Employee
          group by 1
          having count(id)>=5
	      );
		  
-- 14. Confirmation Rate
with cte as (
            select a.user_id, 
            sum(case when caction="confirmed" then 1 else 0 end)as confirmed,
	        count(c.action) as total
	        from Signups s
	        left join confirmations c on s.user_id = c.user_id
	        group by 1
            )
select user_id, round(coalesce(confirmed/total),0),2) as confirmation_rate
from cte
group by 1


--15. Not Boring Movies (Basic Aggregate Functions — Easy):
select * 
from cinema 
where id%2 != 0 
and description != 'boring'
order by rating desc 

--16. Average Selling Price (Basic Aggregate Functions — Easy):

select product_id, round(coalesce(sum(price*units)/sum(units)),0),2) as average_price
from Prices p
left join UnitsSold us
on p.product_id = us.product_id
where us.purchase_date between p.start_date and p.end_date
group by 1; 

--17. Project Employees I (Basic Aggregate Functions — Easy):

select project_id, round(avg(experience_years),2) as average_years
from Project p
left join employee on p.employee_id = e. employee_id
group by 1 
order by 1 ;

--18. Percentage of Users Attended a Contest (Basic Aggregate Functions — Easy):

--1st method 
with cte as (
        select count(user_id) as total
        from Users)

select contest_id, round(100*count(user_id)/total,2) as percentage
from cte
join Register r on cte.user_id = r.user_id
group by 1
order by 2 desc, 1 asc

--2nd method
select contest_id, round(100* count(user_id) /(select count(user_id) from Users),2) as percentage
from Register
group by 1 
order by 2 desc, 1


---19.Queries Quality and Percentage (Basic Aggregate Functions — Easy):
select query_name, round(sum(rating/position)/count(query_name),2) as quality,
       round(sum(case when rating < 3 then 1 else 0 end),2) as poor_query_percentage
from Queries
group by 1;

--20. Monthly Transactions I(Basic Aggregate Functions — Medium):

select left(trans_date,7) as month, 
country , count(id) as trans_count, 
sum(case when state='approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
from Transactions
group by 1, 2 

--21. Imediate Food Delivery II(Basic Aggregate Functions — Medium):

with first_order as (
      select deliver_id, customer_id ,
	  min(order_date) as first_order_date,
	  min(customer_pref_delivery_date) as first_delivery_date
	  from Delivery
	  group by 2)
select round(100*sum(case when first_order_date = first_delivery_date then 1 else 0 end)/count(delivery_id),2) as immediate_percentage
from first_order

--2nd method
with first_order as(
      select delivery_id, customer_id,
	  min(order_date) over( parition by customer_id) as first_order_date,
	  customer_pref_delivery_date 
	  from Delivery
      )

select round(sum(case when first_order_date=customer_pref_delivery_date then 1 else end)/count(distinct customer_id),2) as immediate_percentage
from first_order;

-- 22)Game Play Analysis IV (Basic Aggregate Functions — Medium):
	  
with login as (
     select player_id, device_id,
	 min(event_date) over (partition by player_id) as first_log,
	 games_played
	 from Activity)

select round(sum(case when datediff(event_date,first_log)=1 then 1 else 0 end)/count(distinct player_id),2) as fraction
from login

--23) Number of Unique Subjects Taught by Each Teacher (Sorting and Grouping — Easy):

select teacher_id, count(distinct subject_id) as cnt
from Teacher
group by 1; 

--24) User Activity for the Past 30 Days I (Sorting and Grouping — Easy):

select activity_date as day, count(distinct user_id) as active_users
from Activity
where activity_date in between '2019-06-28' and '2019-07-27'
group by 1;

--25) Product Sales Analysis III (Sorting and Grouping — Medium):

select product_id, year as first_year, quantity, price
from  Sales
where (product_id, first_year) in (select product_id, min(year) as first_year
								   from Sales
								   group by 1)
								   
								   
-- 26)Classes More Than 5 Students (Sorting and Grouping — Easy):

select class
from (select count(student) as num, class from Courses
      group by 2) x
where x.num > = 5

-- 27. Find Followers Count (Sorting and Grouping — Easy):

select user_id, count(follower_id) as followers_count
from Followers
group by 1
order by 1;

-- 28. Biggest Single Number (Sorting and Grouping — Easy):

with cte as 
          (select num, count(num) as count
		   from MyNumbers
		   group by 1
		   having count(num) = 1)
	
select max(num) as num
from cte; 

-- 29. Customers Who Bought All Products (Sorting and Grouping — Medium):
--1st method
select customer_id
from Customer
group by 1 
having count(distinct product_key) = ( select count(product_key)
									  from Product )
									  
-- 2nd method
select customer_id
from (select customer_id, count(distinct product_key) as num_bought
	  from Customer
	  group by 1
	  having count (distinct product_key) = select count(product_key)
	                                        from Product) z

--30. The Number of Employees Which Report to Each Employee (Advanced Select and Joins — Easy):
	
select man.employee_id as employee_id,
       man.name as name,
	   count(emp.reports_to) as reports_count,
	   round(avg(emp.age),0) as average_age
from Employees emp
join Employees man 
on emp.reports_to = man.employee_id
group by 1,2
order by 1; 

--31. Primary Department for Each Employee (Advanced Select and Joins — Easy):
select employee_id,
department_id
from Employee
group by 1
having count(department_id) =1 
union 
select employee_id, department_id
from Employee
where primary_flag = 'Y';

-- 32. Primary Department for Each Employee (Advanced Select and Joins — Easy):

select * , case when x+y > z and x+z>y and y+z >x
                then 'Yes' else 'No' end as triangle
from Triangle;

-- 33. Consecutive Numbers (Advanced Select and Joins — Medium):

with a as 
        (select id, num, lead(num,1) over() as second_num,
		 lead(num,2) over () as third_num
		 from Logs)
select distinct num as ConsecutiveNums
from a 
where num = second_num
and nu = third_num ; 

--34. Product Price at a Given Date (Advanced Select and Joins — Medium):

with cte as 
        (select product_id.
		       change_date,
		        rank() over (partition by product_id order by change_date desc) as day_rank,
		        new_price
		from Products
		where change_date <='2019-08-16')
select product_id, new_price as price
from cte
where rank_date = 1
union 
select product id, 10 as price
from Products
where product_id not in (select product_id from cte)

--35. Last Person to Fit in the Bus (Advanced Select and Joins — Medium):

with cte as (
         select * 
         from (
		       select * , sum(weight) over (order by turn) as cumu_weight)
	           from Queue ) x
		where cumu_weight <= 1000)
		
select person_name 
from cte
where turn = (select max(turn) from cte)


-- 36. Count Salary Categories (Advanced Select and Joins — Medium):

select 'Low Salary' as category, 
        count(account_id) as accounts_count
from Accounts
where income < 20000
union
select 'Average Salary' as category,
        count(account_id) as accounts_count
where income between 20000 and 50000
union select 'High Salary' as caregory,
       count(account_id) as accounts_count
from Accounts
where income > 50000


-- 37. Employees Whose Manager Left the Company (Subqueries — Easy):

select employee_id
from Employees
where salary < 3000
and manager_id not in (select employee_id from Employees)
order by 1

-- 38. Exchange Seats (Subqueries — Medium):
select id, 
       case when id%2 = 0 then lag(student,1)over (order by id)
	        when id%2 <> 0 then coalesce(lead(student,1) over (order by id), student) end as student
from Seat;

-- 39. Movie Rating (Subqueries — Medium):
with user_rate as (
     select name, count(movie_id) as rate_count
	 from MovieRating MR
	 left join Users b 
	 on MR.User_id = b.user_id
	 group by 1
	 order by 2 desc,1
),
	
	movie_rate as (
	   select title, avg(rating) as avg_rate,
	   from MovieRating MR
	   left join Movies b
	   on MR.user_id = b.user_id
	   where left(created_at,7) = '2020-02'
	   group by 1
	   order by 2 desc, 1)
	   
(select name as results
 from user_rate
 limit 1)
 union all
(select title as results
from movie_rate
limit 1);

-- 40. Restaurant Growth (Subqueries — Medium):

select visited_on,
(select sum(amount) from Customer where visited_on between date_sub(c.visited_on, interval 6 day) and
 c.visited_on) as amount,
 (select round(sum(amount)/7),2)
 from Customer where visited_on between date_sub(c.visited_on, interval 6 day) and
 c.visited_on) as amount) as avg_amount
 from Customer c
 where visited_on >= (select date_add(min(visited_on), interval 6 day)
					 from Customer)
group by 1 
order by 1; 
	

--41. Friend Requests II: Who has the most friends (Subqueries — Medium):

select id, count(id) as num
from ( 
	 select request_id as id
	 from RequestAccepted
	 union all
	 select accepter_id as id
	 from RequestAccepted
	 order by 1
	) x
group by 1 
order by 2 desc
limit 1 ;

-- 42 . Investment in 2016 (Subqueries — Medium):
with investment_info as (
     select pid, tiv_2016, lat, lon
	 from Insurance
	where tiv_2015 in 
	(select tiv_2015 
	 from Insurance 
	 group by 1 
	 having count(tiv_2015)>1) 
), 
loc as (
    select lat, lon from Insurance
    group by 1,2
    having count(lat) =1
    and count(lon) =1)
)
select round(sum(tiv_2016),2) as tiv_2016
from loc a 
join investment_info b
where a.lat = b.lat
and a.lob = b.lon; 

--43. Department Top 3 Salaries (Subqueries — Hard):
select d.name as Department, 
       x.name as Employee,
	   salary
from (
     select name, departmentId, salary,
     dense_rank() over (parition by departmentId order by salary desc) as salary_rank
	from Employee
) x
left join Department d
on x.departmentId  = d.if
where salary_rank <= 3 ; 

-- 44. Fix Names in a Table (Advanced String Functions / Regex / Clause — Easy):

select user_id,
       concat (upper(left(name,1)), lower(substr(name,2,length(name)))) as name
from Users
order by 1 ; 

-- 45. Patients with a Condition (Advanced String Functions / Regex / Clause — Easy):
			  
select patient_id, patient_name, conditions
from Patients
where conditions like '% DIAB1%' or 
conditions like '$DIAB1'; 

-- 46. Delete Duplicate Emails (Advanced String Functions / Regex / Clause — Easy):

	
delete b.*
from Person a
join Person b
on a.email = b.email 
and a.id < b.id ; 

-- 47. Second Highest Salary (Advanced String Functions / Regex / Clause — Medium):
with cte as (
      select id, salary, dense_rank() over (order by salary desc) as salary_rank
      from Employee)
	  
select max(salary) as SeondHighestSalary
from cte
where salary_rank = 2

--2nd method
with cte as (
     select id, slary,dense_rank() over (order by salary desc) as salary_rank
     from Employee
)
select 
case when (select count(id)>1 from cte)
     then (select distinct salary from cte where salary_rank =2)
	 else null end as SecondHighestSalary ; 
	 
	 

-- 48.  Group Sold Products By Date (Advanced String Functions / Regex / Clause — Easy):

select sell_date, count(distinct product) as num_sold,
       group_concat(distinct product order by product asc seperator ',') as products
from Activities
group by 1; 

-- 49. Lists the Products Ordered in a Period (Advanced String Functions / Regex / Clause — Easy):

with cte as (
         select product_id, sum(unit) as unit
         from Orders
         where left(order_date,7)= '2020-02'
         group by 1
         having unit >= 100
)
select product_name, unit
from cte c
left join Products p 
on c.product_id = p.product_id; 

-- 50. Find Users with Valid Emails (Advanced String Functions / Regex / Clause — Easy):

select * 
from Users
where mail REGEXP '^[a-zA-Z][a-zA-Z0-9_\.\-]*@leetcode\.com'
and mail not like '%?%' ; 

