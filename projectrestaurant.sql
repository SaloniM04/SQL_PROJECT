

--                                               PROJECT

--  AIM- In this project, I aim to have to pred=ict the restaurant revenue based on the  independent features using SQL.

--                                            BASIC QUERIES

--Calculate the no of restaurants in each city.

select city, count(*) as no_of_restaurants from revenue_prediction1
group by city
order by city

--How many restaurants have franchise in Bangalore?

select count(franchise) as no_of_restaurants_with_franchise from revenue_prediction1
where city='Bangalore' and franchise=1

--Calculate the total revenue of restaurants of each city.

select city, sum(revenue) as Total_revenue from  revenue_prediction1
group by city

--which restaurant is generating highest revenue where the category of food is 'Mexican'?

 select top 1 name as restaurant from revenue_prediction1
 where category='Mexican'
 order by revenue desc

 --                                         MODERATE QUERIES

--Find restaurants with revenue greater than the average revenue.

select name as restaurant from revenue_prediction1
where revenue > (select avg(revenue) as avg_revenue from revenue_prediction1)

--Find the average number of items for franchise and non-franchise restaurants.

select avg(no_of_item) as avg_no_of_items , franchise2 as Franchise from revenue_prediction1 as r1
where  franchise=1
group by franchise2
union
select avg(no_of_item) as avg_no_of_items, franchise2 as Franchise from revenue_prediction1
where  franchise=0
group by franchise2

--Calculate the percentage of revenue contributed by each category to the total revenue.

select category, sum(revenue) as categoryrevenue, round((sum(cast(revenue as decimal(19,2)))*100.0)/(select sum(cast(revenue as decimal(19,2))) from revenue_prediction1) ,2)
as Percentage_of_revenue from revenue_prediction1
group by category

--Find the top 1 city with the highest total revenue:
 
 select top 1 city from (
 select city, sum(revenue) as total_revenue from revenue_prediction1
 group by city                         
 ) as t
 order by total_revenue desc
--                                               ADVANCE QUERIES 

--Find the restaurant with the highest revenue in each city.

select name, city from
(select *, dense_rank() over (partition by city order by revenue desc) as ranked_city from revenue_prediction1) as t
where ranked_city=1
order by ranked_city

-- which restaurant gets highest no of orders in each city.

with cte as(
select *, dense_rank() over(partition by city order by order_placed desc) as c from revenue_prediction1
)
select city as City, string_agg(name,' , ') as Restaurant from cte
where c=1
group by city

--which category of food is popular in each city?

with 
 ranked_items as(
    select city, category, sum(no_of_item) as total_items from revenue_prediction1
    group by city, category
   ),
 cte as(
    select city, category, dense_rank() over (partition by city order by total_items desc) as d 
	from ranked_items
   )
	select city, category as food_popularity from cte
	where d=1


-- Find the restaurants with 3rd highest revenue in each city.

with top3 as(
select name,city,revenue, row_number() over (partition by city order by revenue desc) as t from revenue_prediction1
) 
select name, city from top3
where t=3 





