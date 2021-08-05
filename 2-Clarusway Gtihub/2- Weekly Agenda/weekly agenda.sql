----------WEEKLY AGENDA 7..-----------------
USE BIKE STORE DB

-- 1. Find the customers  /  who placed at least two orders per year.
SELECT * FROM sales.customers

select first_name,last_name,YEAR(order_date), COUNT(order_id) as number_of_orders
from sales.customers A,sales.orders B
where A.customer_id = B.customer_id
group by YEAR(order_date),first_name,last_name
having COUNT(order_id) >1
order by YEAR(order_date),number_of_orders desc

2. If the total amount of order            less then 500 then "very low"    between 500 - 1000 then "low"    between 1000 - 5000 then "medium"    between 5000 - 10000 then "high"    more then 10000 then "very high"


select ((list_price- (list_price*discount))*quantity) as total_amount,
			case
				when ((list_price- (list_price*discount))*quantity) < 500 then 'very low'
				when ((list_price- (list_price*discount))*quantity)  < 1000 then 'low' 
				when ((list_price- (list_price*discount))*quantity)  < 5000 then 'medium'
				when ((list_price- (list_price*discount))*quantity) < 10000 then 'high'
				else 'very high' end
				as amount_rate
	from sales.order_items A, sales.orders B
	where A.order_id = B.order_id
	and YEAR(order_date) = 2018


If the total amount of order    
    
    less then 500 then "very low"
    between 500 - 1000 then "low"
    between 1000 - 5000 then "medium"
    between 5000 - 10000 then "high"
    more then 10000 then "very high" 

3. By using Exists Statement find all customers who have placed more than two orders.

SELECT  *
FROM sales.customers X
WHERE EXISTS
(select distinct first_name,last_name, COUNT(order_id) as number_of_orders
from sales.customers A, sales.orders B
where A.customer_id = B.customer_id
AND X.customer_id=B.customer_id
group by first_name,last_name
having COUNT(order_id) > 2);
-------------correleated subquery çok önemliiiiiiiiii-----------

4. Show all the products and their list price, that were sold with more than two units in a sales order.
----------952 satır-----------select distinct a.order_id, count(a.quantity)from sales.order_items a, production.products bwhere a.product_id = b.product_id GROUP by a.order_idHAVING count(a.quantity) > 2
------------ farklı çözüm  33 satır---------------​select distinct b.product_name, a.list_price, a.order_id, count(a.product_id)from sales.order_items a, production.products bwhere a.product_id = b.product_id GROUP by a.order_id, b.product_name, a.list_priceHAVING count(a.product_id) >= 2

----------cevap bu-----------SELECT  product_name, list_priceFROM   production.productsWHERE  product_id = ANY (  SELECT product_id        FROM  sales.order_items        WHERE  quantity >= 2    )ORDER BY product_name;

------ Show all the products and their list price, that were sold with more than two units in a sales order.​select distinct b.product_name, a.list_price, a.order_id, a.quantityfrom sales.order_items a, production.products bwhere a.product_id = b.product_id and a.quantity >= 2GROUP by a.order_id, b.product_name, a.list_price, a.quantityselect *from sales.order_items​select distinct b.product_name, a.list_price, a.order_id, count(a.product_id)from sales.order_items a, production.products bwhere a.product_id = b.product_id GROUP by a.order_id, b.product_name, a.list_priceHAVING count(a.product_id) >= 2




5. Show the total count of orders per product for all times. 
--(Every product will be shown in one line and the total order count will be shown besides it)
-------------291 satır--------- left join--------
select product_name, COUNT(A.product_name) as total_sold
from production.products A
left join sales.order_items B
on A.product_id = B.product_id
group by product_name


6. Find the products whose list prices are more than the average list price of products of all brands

select product_name,list_price,(select AVG(list_price) from production.products) as avg_price
from production.products 
where list_price > (select AVG(list_price) from production.products)


7. In how many ways, a group of 3 boys and 2 girls can be formed out of a total of 5 boys and 5 girls?

p(5,3) * p(5,2)

8.A woman has 6 blouses, 4 skirts, and 5 pairs of shoes. How many different outfits consisting of a blouse, a skirt, and a pair of shoes can she wear?

c(6,1) * c(4,1)* c(5,1)

9. Serena Williams won the 2010 Wimbledon Ladies’ Singles Championship. For the seven matches she played in the tournament, her total number of first serves was 379, total number of good first serves was 256, and total number of double faults was 15.

a. Find the probability that her first serve is good.
256/379
b. Find the conditional probability of double faulting, given that her first serve resulted in a fault.

p( d | f )=p ( d n f ) / p( f ))= p( d )/ 1 p ( f )  
15/379 / 1-0.675=0.122

c. On what percentage of her service points does she double fault?

10. Suppose that in the world exist a very rare disease. The chance for anyone to have this disease is 0.1%. You want to know whether you are infected so you go take a test, and the test results come positive. The accuracy of the test is 99%, meaning that 99% of the people who have the disease will test positive, and 99% of the people who do not have the disease will test negative. What is the chance that you are actually infected? .......Bayes Theory.....

In this problem:
𝑃(H|E) = 𝑃(H) × 𝑃(E|H) / 𝑃(E)
𝑃(H|E) = 𝑃(H) × P(E|H) / (𝑃(E|H) × 𝑃(H) + 𝑃(E|Hc) × 𝑃(Ec) )
𝑃(H|E) = 0,99*0,001 / (0,001*0,99 + 0,999*0,01) = 0,9 = 9%