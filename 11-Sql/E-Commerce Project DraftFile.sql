

--DAwSQL Session -8 

--E-Commerce Project Solution



--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

SELECT Customer_Name,Province,Region,A.Cust_id,B.Ord_id,D.Prod_id,E.Ship_id,Sales,Discount
		order_quantity,Product_Base_Margin,Order_Date,Order_Priority,Product_Category,Product_Sub_Category,Order_ID
		,Ship_Mode,Ship_Date

into combined_table

from cust_dimen A, market_fact B, orders_dimen C, prod_dimen D, shipping_dimen E
		where A.Cust_id = B.Cust_id
		and B.Ord_id = C.Ord_id
		and B.Prod_id = D.Prod_id
		and B.Ship_id = E.Ship_id



		

--///////////////////////


--2. Find the top 3 customers who have the maximum count of orders.

select top 3 customer_name, COUNT(ord_id) as number_of_orders from combined_table
group by Customer_Name
order by number_of_orders desc

select top 3 customer_name, COUNT(Order_ID) as number_of_orders from combined_table
group by Customer_Name
order by number_of_orders desc

--/////////////////////////////////



--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.

SET DATEFORMAT dmy  -- year month day olan formatý day month year olarak tanttýk
-- SELECT datediff(D, CAST(order_date as Date), CAST(ship_date as date)) as A from combined_table 

create view tablo as 
select *, datediff(D, CAST(order_date as Date), CAST(ship_date as date)) as DaysTakenForDelivery
from combined_table 

select * from tablo






--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"
SET DATEFORMAT dmy
select top 1 Customer_Name, Order_Date, Ship_Date, DaysTakenForDelivery
from tablo
order by DaysTakenForDelivery desc 





--////////////////////////////////



--5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
--You can use such date functions and subqueries

SET DATEFORMAT dmy
-- Count the total number of unique customers in January
select count(distinct Cust_id) as uniqu_customer_in_January
from tablo
where MONTH(cast(Order_Date as datetime)) = 1

-- how many of them came back every month over the entire year in 2011
select datename(Month,cast(order_date as datetime)) as month, COUNT(cust_id) as come_back 
from tablo
where cust_id in (
select distinct Cust_id
from tablo
where MONTH(cast(Order_Date as datetime)) = 1)
and year(cast(order_date as datetime)) = 2011
group by datename(Month,cast(order_date as datetime))
order by datename(Month,cast(order_date as datetime))









--////////////////////////////////////////////


--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions

SELECT ord_id, order_date, customer_name, Region
 ,min(order_date) OVER(partition BY region) as order_date 
FROM tablo




--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.
--Use CASE Expression, CTE, CAST AND such Aggregate Functions




--/////////////////



--CUSTOMER RETENTION ANALYSIS



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.




--//////////////////////////////////


--2. Create a view that keeps the number of monthly visits by users. (Separately for all months from the business beginning)
--Don't forget to call up columns you might need later.






--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can number the months with "DENSE_RANK" function.
--then create a new column for each month showing the next month using the numbering you have made. (use "LEAD" function.)
--Don't forget to call up columns you might need later.



--/////////////////////////////////



--4. Calculate the monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.







--/////////////////////////////////////////


--5.Categorise customers using time gaps. Choose the most fitted labeling model for you.
--  For example: 
--	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--	Labeled as regular if the customer has made a purchase every month.
--  Etc.








--/////////////////////////////////////




--MONTH-WÝSE RETENTÝON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps





--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Total Number of Customers in The Previous Month / Number of Customers Retained in The Next Nonth

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.







---///////////////////////////////////
--Good luck!