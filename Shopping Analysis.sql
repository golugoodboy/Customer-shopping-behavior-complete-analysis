--create database shopping;


--select * from customer_shopping_behavior_modifiedsss

-- Q-1. What is the total revenue generated male vs female 
/*select gender,sum(cast(purchase_amount as int)) as revenue from customer_shopping_behavior_modifiedsss
group by gender 
*/

--Q -2, which customer used a discount but still spend more than the average purchase amount.
/*select * from customer_shopping_behavior_modifiedsss
where discount_applied = 'Yes' and 
								(select avg(cast(purchase_amount as int)) from customer_shopping_behavior_modifiedsss) < purchase_amount
								*/
--Q.3, which are the top 5 products with the highest average review rating 

/*select top 5 item_purchased,round(avg(cast(review_rating as float)),2) as average_review from customer_shopping_behavior_modifiedsss
group by item_purchased 
order by average_review desc 
*/

--Q.4 Compare the average purchase amount between standard and express
/*select shipping_type,avg(cast(purchase_amount as int)) as average_shipping_amount from customer_shopping_behavior_modifiedsss
group by shipping_type
Having shipping_type in ('Express','Standard')

*/

--Q.5 compare average spend and total revenue between subscription_status
/*
select 
subscription_status,
avg(cast(purchase_amount as int)) as average_spend,
sum(cast(purchase_amount as int)) as total_revenue
from customer_shopping_behavior_modifiedsss
group by subscription_status
*/

--Q.6 which 5 products have the highest percentage of purchases with discount applied.
/*
select top 5 item_purchased,
(100 *sum(case when discount_applied = 'Yes' then 1.0 else 0 end)/count(*)) as percentage_of_buying 
from customer_shopping_behavior_modifiedsss
group by item_purchased 
order by percentage_of_buying desc
*/

--Q.7 segment customer into new, returning, and loyal total no. of customer segment
/*
with cte as 
(
select customer_id,previous_purchases,
(case 
	when previous_purchases = 1 then 'new'
	when previous_purchases between 2 and 10 then 'returning'
	when previous_purchases > 10 then 'loyal'
 end) as customer_segment
from customer_shopping_behavior_modifiedsss
)

select customer_segment,count(customer_id) as no_count from cte
group by customer_segment
order by no_count
*/

--Q.8 what are the top 3 most purchased products within each category?

/*
with cte as 
(
select category,item_purchased,count(*) as number_of_sales,
rank() over(partition by category order by count(*) desc) as ranking_of_sales
from customer_shopping_behavior_modifiedsss
group by category,item_purchased
)

select category,item_purchased,number_of_sales from cte
where ranking_of_sales in (1,2,3)
order by category
*/


--Q.9 are customer who are repeat buyers also likely to subscribe?
/*
with cte as 
(
select * from customer_shopping_behavior_modifiedsss
where previous_purchases > 5
)

select 
(select count(*) from cte where subscription_status = 'Yes') as loyal_customer_who_are_subscribed,
(select count(*) from cte where subscription_status = 'No') as loyal_customer_who_are_not_subscribed

*/

--Q.10 what is the revenue contribution of each group?

select age_group,sum(cast(purchase_amount as int)) as revenue from customer_shopping_behavior_modifiedsss
group by age_group
order by sum(cast(purchase_amount as int))








