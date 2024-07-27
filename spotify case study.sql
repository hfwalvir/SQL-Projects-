--purchase and install on the same day
select * from activity; 

select event_date, count(new_user) as no_of_users from(
select user_id, event_date,
case when count(distinct event_name) = 2 then user_id else null end as new_user 
from activity
group by user_id, event_date ) X
group by event_date

-- total active users
select event_date, count(distinct user_id) as no_of_active_users
from activity
group by event_date

-- total weekly active users

select datepart(week,event_date), count(distinct user_id) as no_of_active_users
from activity
group by datepart(week,event_date)

--country wise percentage of paid users in india usa and other countries as others
with cte as(
select 
case when country in ('India','USA') then country else 'others' end as country_name
, count (distinct user_id) as no_of_users
from activity
where event_name = 'app-purchase'
group by case when country in ('India','USA') then country else 'others' end),
cte1 as(
select sum(no_of_users) as total_users from cte)
select country_name, no_of_users*100.0/total_users as perc_users
from cte,cte1

--who installed but didnt purchase in the very next day
--only 1 day gap
with prev_data as(
select *,
lag(event_name,1) over (partition by user_id order by event_date) as prev_event_name
, lag (event_date,1) over (partition by user_id order by event_date) as prev_event_date
from activity)

select event_date, count(distinct user_id) as no_of_users
from prev_data
where event_name = 'app-purchase' and prev_event_name = 'app-installed' and datediff(day, prev_event_date, event_date) = 1
group by event_date