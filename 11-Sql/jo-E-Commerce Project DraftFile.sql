
--DAwSQL Session -8 

--E-Commerce Project Solution

--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)
-- bütün tablolarý baðladýk  SELECT * ÝNTO olark ta kullanýlýr
drop table combined_table
SELECT Customer_Name,Province,Region,Customer_Segment, A.Cust_id,B.Ord_id,D.Prod_id,E.Ship_id,Sales,Discount
		order_quantity,Product_Base_Margin,Order_Date,Order_Priority,Product_Category,Product_Sub_Category,Order_ID
		,Ship_Mode,Ship_Date

into combined_table  --oluþturmak istediðimiz dosyayý yazdýk

from cust_dimen A, market_fact B, orders_dimen C, prod_dimen D, shipping_dimen E
		where A.Cust_id = B.Cust_id
		and B.Ord_id = C.Ord_id
		and B.Prod_id = D.Prod_id
		and B.Ship_id = E.Ship_id
-------------owen hoca
SELECT *
INTO
combined_table
FROM
(
SELECT
cd.Cust_id, cd.Customer_Name, cd.Province, cd.Region, cd.Customer_Segment,
mf.Ord_id, mf.Prod_id, mf.Sales, mf.Discount, mf.Order_Quantity, mf.Product_Base_Margin,
od.Order_Date, od.Order_Priority,
pd.Product_Category, pd.Product_Sub_Category,
sd.Ship_id, sd.Ship_Mode, sd.Ship_Date
FROM market_fact mf
INNER JOIN cust_dimen cd ON mf.Cust_id = cd.Cust_id
INNER JOIN orders_dimen od ON od.Ord_id = mf.Ord_id
INNER JOIN prod_dimen pd ON pd.Prod_id = mf.Prod_id
INNER JOIN shipping_dimen sd ON sd.Ship_id = mf.Ship_id
) A;
------------------------------
select * 
		
		from cust_dimen A, market_fact B, orders_dimen C, prod_dimen D, shipping_dimen E
		where A.Cust_id = B.Cust_id
		and B.Ord_id = C.Ord_id
		and B.Prod_id = D.Prod_id
		and B.Ship_id = E.Ship_id

		

--///////////////////////


--2. Find the top 3 customers who have the maximum count of orders.

select top 3 customer_name, COUNT(ord_id) as number_of_orders 
from combined_table
group by Customer_Name
order by number_of_orders desc

select top 3 customer_name, COUNT(*) as number_of_orders 
from combined_table
group by Customer_Name
order by number_of_orders desc

select top 3 cust_id, COUNT(Ord_id) as number_of_orders 
from combined_table
group by Cust_id
order by number_of_orders desc

-----owen hoca
SELECT	TOP(3)cust_id, COUNT (Ord_id) total_ord
FROM	combined_table
GROUP BY Cust_id
ORDER BY total_ord desc
--/////////////////////////////////



--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.

select order_date from combined_table -- dmy olarak tarih çevrilecek.

---önemliiii----
SET DATEFORMAT dmy  -- year month day olan formatý day month year olarak tanttýk

--SELECT datediff(D, CAST(order_date as Date), CAST(ship_date as date)) as A from combined_table 

update combined_table set order_date =  CONVERT(DATE,order_date,103) -- sütunlarýn tür dönüþümlerini yaptýk
update combined_table set Ship_Date =  CONVERT(DATE,Ship_Date,103)  -- sütunlarýn tür dönüþümlerni yaptýk
select order_date, ship_date, DATEDIFF(D, order_Date, ship_date) from combined_table  -- tür dönüþümü iþlemi baþarýlý

-- DaysTakenForDelivery adýnda yeni bir sütun oluþturduk
alter table combined_table add DaysTakenForDelivery int
-- oluturduðumuz yeni sütuna deðerlerimizi atýyoruz
update combined_table set DaysTakenForDelivery = DATEDIFF(D,Order_Date, Ship_Date)
-- sütun deðerlerini kontrol ediyoruz. 

select Order_Date,Ship_Date, DaysTakenForDelivery, DATEDIFF(D,Order_Date,Ship_Date) as date_diff
from combined_table  -- deðerler uyuþuyor
order by date_diff
--------------------------owen hoca

-- alter table combined_table  add DaysTakenForDelivery INT;  -- sütün ekleme sytax ý integer sayý olacak
-- select * from combined_table
-- update combined_table  SET DaysTakenForDelivery = DATEDIFF(D,Order_Date, Ship_Date)  -- sütünü ayarladýk
----------------------

/* create view tablo as 
select *, datediff(D, CAST(order_date as Date), CAST(ship_date as date)) as DaysTakenForDelivery
from combined_table */ -- cast anlýk deðiþim yapar
-----------------------------


--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"



select top 1 Customer_Name, Order_Date, Ship_Date, DaysTakenForDelivery
from combined_table
order by DaysTakenForDelivery desc 
----
SELECT TOP 1 FIRST_VALUE(customer_name) OVER(ORDER BY DaysTakenForDelivery DESC)
FROM combined_table
----
SELECT MAX(DaysTakenForDelivery), Customer_Name
FROM combined_table
GROUP BY Customer_Name
HAVING MAX(DaysTakenForDelivery) = (SELECT MAX(DaysTakenForDelivery)
								    FROM combined_table
								    )

---------------owen hoca
SELECT cust_id,order_date,Ship_date,DaysTakenForDelivery
FROM combined_table
where DaysTakenForDelivery=(
SELECT  MAX(DaysTakenForDelivery)
FROM combined_table)



--////////////////////////////////



--5. Count the total number of unique customers in January / and how many of them came back every month over the entire year in 2011
--You can use such date functions and subqueries


-- Count the total number of unique customers in January
select count(distinct Cust_id) as unique_customer_in_January
from combined_table
--where MONTH(Order_Date ) = 1
where DATENAME(MONTH,Order_Date) = 'January'

-- how many of them came back every month over the entire year in 2011

select datename(Month,order_date) as month_name,Month(order_date) as month_number,  COUNT(cust_id) as come_back 
from combined_table
where cust_id in (
select distinct Cust_id
from combined_table
where MONTH(Order_Date ) = 1)        -- 1.ayda gelenler
and year(order_date ) = 2011         -- yýlda 2011 olacak
group by datename(Month,order_date),Month(order_date)
order by Month(order_date)

-------owen hoca
select count(DISTINCT cust_id) num_of_cust
from combined_table
where year(Order_date)=2011
and month(order_date)=1     -- ana tablo bu kullanacaz
--------------------------- owen hoca
SELECT MONTH(order_date) [month], COUNT(DISTINCT cust_id) MONTHLY_NUM_OF_CUST
FROM	Combined_table A
WHERE
EXISTS
(
SELECT  Cust_id
FROM	combined_table B
WHERE	YEAR(Order_Date) = 2011
AND		MONTH (Order_Date) = 1
AND		A.Cust_id = B.Cust_id
)
AND	year(Order_Date) = 2011
GROUP BY MONTH(order_date)


--////////////////////////////////////////////


--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions
CREATE VIEW first AS (
					  SELECT * 
					  FROM (
							SELECT cust_id,Customer_Name, order_date, 
							ROW_NUMBER() OVER(partition by customer_name order by order_date) AS rownum1
							FROM combined_table
							) AS F
					  where F.rownum1 = 1
					  )
CREATE VIEW third AS(
					 SELECT * 
					 FROM (
						   SELECT cust_id,Customer_Name, order_date, 
						   ROW_NUMBER() OVER(partition by customer_name order by order_date ) AS rownum3
						   FROM combined_table) AS F
					 WHERE F.rownum3 = 3
					 )



create view first as
(select * from (
				select cust_id,Customer_Name, order_date, ROW_NUMBER() OVER(partition by customer_name order by order_date ) [rownum1]
				from combined_table) F  --alias olmak zorunda
where F.rownum1 = 1)  --row num  1. satýrlar


create view third as
(select * from (
					select cust_id,Customer_Name, order_date, ROW_NUMBER() OVER(partition by customer_name order by order_date ) [rownum3]
					from combined_table) F
where F.rownum3 = 3)  --row num  3. satýrlar

select T.Customer_Name, DATEDIFF(D,f.Order_Date, T.Order_Date) as elapsed_time_from_orders 
from first F, third T
where F.Cust_id = T.Cust_id
order by  elapsed_time_from_orders desc
------------------------
CREATE VIEW first AS (
					  SELECT * 
					  FROM (
							SELECT cust_id,Customer_Name, order_date, 
							ROW_NUMBER() OVER(partition by customer_name order by order_date) AS rownum1
							FROM combined_table
							) AS F
					  where F.rownum1 = 1
					  )

CREATE VIEW third AS(
					 SELECT * 
					 FROM (
						   SELECT cust_id,Customer_Name, order_date, 
						   ROW_NUMBER() OVER(partition by customer_name order by order_date ) AS rownum3
						   FROM combined_table) AS F
					 WHERE F.rownum3 = 3
					 )
F
					WHERE F.rownum3 = 3
					)

SELECT T.Customer_Name, 
	   DATEDIFF(D,f.Order_Date, T.Order_Date) AS elapsed_time_from_orders
FROM first_with AS F, third_with AS T
WHERE F.Cust_id = T.Cust_id
From joseph forest to Everyone:  01:35 AM
create view first as
(select * from (
				select cust_id,Customer_Name, order_date, ROW_NUMBER() OVER(partition by customer_name order by order_date ) [rownum1]
				from combined_table) F
where F.rownum1 = 1)


create view third as
(select * from (
				select cust_id,Customer_Name, order_date, ROW_NUMBER() OVER(partition by customer_name order by order_date ) [rownum3]
				from combined_table) F
where F.rownum3 = 3)

select T.Customer_Name, DATEDIFF(D,f.Order_Date, T.Order_Date) as elapsed_time_from_orders from first F, third T
where F.Cust_id = T.Cust_id
order by elapsed_time_from_orders desc

----------owen hoca

select *
from combined_table
where cust_id='cust_1000'  -- örnwek getirdik
order by Order_Date













-----------------------------------
--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions

--lead sýradan geöer satýrlarda yanlýþ getirir çünkü 2 3 ve 4 ayný sipariþ
-- row number da sýradan  o da olmaz

-- CTE table ile

WITH first_with AS (
					  SELECT * 
					  FROM (
							SELECT cust_id,Customer_Name, order_date, 
							ROW_NUMBER() OVER(partition by customer_name order by order_date) AS rownum1
							FROM combined_table
							) AS F
					  where F.rownum1 = 1
					  ),

third_with AS(
			  SELECT * 
			  FROM (
				    SELECT cust_id,Customer_Name, order_date, 
					ROW_NUMBER() OVER(partition by customer_name order by order_date ) AS rownum3
					FROM combined_table) AS F
					WHERE F.rownum3 = 3
					)

SELECT T.Customer_Name, 
	   DATEDIFF(D,f.Order_Date, T.Order_Date) AS elapsed_time_from_orders
FROM first_with AS F, third_with AS T
WHERE F.Cust_id = T.Cust_id
ORDER BY elapsed_time_from_orders DESC

-- VIEW ile

-- create first view
CREATE VIEW first_view AS  (
							SELECT * 
							FROM   (
									SELECT
elapsed_time_from_orders DESC
--------------------owen hoca-------------- doðru cevap ta bu
SELECT DISTINCT
		cust_id,
		order_date,
		dense_number,
		FIRST_ORDER_DATE,
		DATEDIFF(day, FIRST_ORDER_DATE, order_date) DAYS_ELAPSED
FROM	
		(
		SELECT	Cust_id, ord_id, order_DATE,
				MIN (Order_Date) OVER (PARTITION BY cust_id) FIRST_ORDER_DATE,
				DENSE_RANK () OVER (PARTITION BY cust_id ORDER BY Order_date) dense_number
		FROM	combined_table
		) A
WHERE	dense_number = 3
-- group by Cust_id      --window func ile kullanýlmaz

--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.
--Use CASE Expression, CTE, CAST AND such Aggregate Functions

-- 11 ve 14 ürünleri alan müþteriler

select cust_id,Customer_Name
from combined_table
where Prod_id = 'Prod_11'
intersect
select cust_id,Customer_Name
from combined_table
where Prod_id = 'Prod_14'

-- 11 ve 14 ü alanlarýn aldýklarý toplam ürün sayýsý

WITH cte AS (
			 SELECT Prod_id, Cust_id, Customer_Name, COUNT(Order_ID) as number_of_orders
			 FROM combined_table
			 WHERE Cust_id IN (
							   SELECT DISTINCT cust_id
							   FROM combined_table
							   WHERE Prod_id = 'Prod_11'
							   INTERSECT
							   SELECT DISTINCT Cust_id
							   FROM combined_table
							   WHERE Prod_id = 'Prod_14')
			 GROUP BY Prod_id, Cust_id, Customer_Name)
SELECT SUM(number_of_orders) AS number_of_customer_11
FROM cte
WHERE Prod_id = 'Prod_11'
UNION
SELECT SUM(number_of_orders) AS number_of_customer_14
FROM cte
WHERE Prod_id = 'Prod_14' 

-- oranlarý
select 210.0 /448
select cast(210 as float) / 448
-- 11 ve 14 ten aldýklarý adet sayýsý

---------------------owen hoca 
WITH T1 AS
(
SELECT	Cust_id,
		SUM (CASE WHEN Prod_id = 'Prod_11' THEN Order_Quantity ELSE 0 END) P11,
		SUM (CASE WHEN Prod_id = 'Prod_14' THEN Order_Quantity ELSE 0 END) P14,
		SUM (Order_Quantity) TOTAL_PROD
FROM	combined_table
GROUP BY Cust_id
HAVING
		SUM (CASE WHEN Prod_id = 'Prod_11' THEN Order_Quantity ELSE 0 END) >= 1 AND
		SUM (CASE WHEN Prod_id = 'Prod_14' THEN Order_Quantity ELSE 0 END) >= 1
)
SELECT	Cust_id, P11, P14, TOTAL_PROD,
		CAST (1.0*P11/TOTAL_PROD AS NUMERIC (3,2)) AS RATIO_P11,
		CAST (1.0*P14/TOTAL_PROD AS NUMERIC (3,2)) AS RATIO_P14
FROM T1


--/////////////////



--CUSTOMER RETENTION ANALYSIS



--1. Create a view that keeps visit logs of customers on a monthly basis. 
(For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.
create view tablo as 
select Cust_id, YEAR(Order_Date) as year, MONTH(Order_Date) as month
from combined_table;

select * from tablo

---------------owen hoca-------------

create view customer_logs AS 

select  cust_id,               --deðerler hangi tablodan gelecekse
        year(order_date) [YEAR],
		month(order_date) [MONTH]  -- hangi yýlýn ayý olduðunu bilemez
from combined_table

order by 1,2,3  -- viewle kullanýlmaz



--//////////////////////////////////


--2. Create a view that keeps the number of monthly visits by users. (Separately for all months from the business beginning)
--Don't forget to call up columns you might need later.

create view number_of_monthly_visits as

select Cust_id, month(Order_Date) as month ,count(MONTH(Order_Date)) as number_of_visit
from combined_table
group by Cust_id, month(Order_Date)
------------------owen hoca

create view num_of_visits AS

select cust_id, [MONTH], [YEAR], count(*) num_of_log
from customer_logs
group by cust_id, [MONTH], [YEAR]



--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can number the months with "DENSE_RANK" function.
--then create a new column for each month showing the next month using the numbering you have made. (use "LEAD" function.)
--Don't forget to call up columns you might need later.
create view next_month_visit
select 
	*, 
	lead(monthh,1) over(partition by customer_name order by monthh) as next_visit_month
from (
	  select 
		Customer_Name,
		MONTH(order_date) as monthh, 
		dense_rank() over(partition by customer_name order by MONTH(order_date)) dens
	  from combined_table
	  ) as a
  ---------------------owen hoca  
  
  select distinct [YEAR],[MONTH],                         --her satýra numaralandrýma yaptýk 48 aya sýralama verdik
			dense_rank () over ( order by [YEAR],[MONTH]) --bunu kullanacaðýz
  from num_of_visits
  order by 3 
  ----
  CREATE VIEW NEXT_VISIT AS
SELECT *,
		LEAD(CURRENT_MONTH, 1) OVER (PARTITION BY Cust_id ORDER BY CURRENT_MONTH) NEXT_VISIT_MONTH
FROM
(
SELECT  *,
		DENSE_RANK () OVER (ORDER BY [YEAR] , [MONTH]) CURRENT_MONTH
		
FROM	next_visit_month
) A   
----------------owen hoca 3 ve 4
--3. For each visit of customers, create the next month of the visit as a separate column.
--You can number the months with "DENSE_RANK" function.
--then create a new column for each month showing the next month using the numbering you have made. (use "LEAD" function.)
--Don't forget to call up columns you might need later.
CREATE VIEW NEXT_VISIT AS
SELECT *,
		LEAD(CURRENT_MONTH, 1) OVER (PARTITION BY Cust_id ORDER BY CURRENT_MONTH) NEXT_VISIT_MONTH
FROM
(
SELECT  *,
		DENSE_RANK () OVER (ORDER BY [YEAR] , [MONTH]) CURRENT_MONTH
		
FROM	num_of_visits
) A
--/////////////////////////////////
--4. Calculate the monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.
CREATE VIEW time_gaps AS
SELECT *,
		NEXT_VISIT_MONTH - CURRENT_MONTH time_gaps
FROM	NEXT_VISIT

--dikkat et buralarda---------tommy

--////////////////////////////////////


--5.Categorise customers using time gaps. Choose the most fitted labeling model for you.
--  For example: 
--	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--	Labeled as regular if the customer has made a purchase every month.
--  Etc. rime _gaps e göre when case ile yaptýk

SELEC *
FROM next_month_visit


SELECT cust_id, avg_time_gap,
		CASE WHEN avg_time_gap = 1 THEN 'retained'
			WHEN avg_time_gap > 1 THEN 'irregular'
			WHEN avg_time_gap IS NULL THEN 'Churn'
			ELSE 'UNKNOWN DATA' END CUST_LABELS
FROM
		(
		SELECT Cust_id, AVG(time_gaps) avg_time_gap
		FROM	time_gaps
		GROUP BY Cust_id
		) A

--/////////////////////////////////////


--MONTH-WÝSE RETENTÝON RATE   

--Find month-by-month customer retention rate  since the start of the business.

--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps          geri gelme sayýsý her ayýn müþ geri kazaným nedir yüzde olarak.

SELECT	DISTINCT cust_id, [YEAR],
		[MONTH],
		CURRENT_MONTH,
		NEXT_VISIT_MONTH,
		time_gaps,
		COUNT (cust_id)	OVER (PARTITION BY NEXT_VISIT_MONTH) RETENTITON_MONTH_WISE
FROM	time_gaps
where	time_gaps =1
ORDER BY cust_id, NEXT_VISIT_MONTH

--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Total Number of Customers in The Previous Month / Number of Customers Retained in The Next Nonth

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.

-- önceki ayda 100 müþteri þimdi ayda 50 oran nasýl? her ay ne akdar müþteri gelmiþ ona baktýk

create view current_num_of_cust as
SELECT	DISTINCT cust_id, [YEAR],
		[MONTH],
		CURRENT_MONTH,
		
		COUNT (cust_id)	OVER (PARTITION BY CURRENT_MONTH) RETENTITON_MONTH_WISE
FROM	time_gaps

--þimdi sonraki aydan  gelen müþterileri bulacaz

create view next_num_of_cust as
--drop view next_num_of_cust
SELECT	DISTINCT cust_id, [YEAR],
		[MONTH],
		CURRENT_MONTH,
		
		COUNT (cust_id)	OVER (PARTITION BY  NEXT_VISIT_MONTH) RETENTITON_MONTH_WISE
FROM	time_gaps
where time_gaps=1
and CURRENT_MONTH>1  --1. aydan baþlayarak



select distinct B.[YEAR],
				B.[MONTH],
				B.next_visit_month,
				A.CURRENT_MONTH,
				1.0 * B.RETENTITON_MONTH_WISE / A.RETENTITON_MONTH_WISE
from current_num_of_cust A left join next_num_of_cust B  --left join kullanmamýz gerek
on A.CURRENT_MONTH+1 =B.CURRENT_MONTH  -- a dak iab deki aya eþit olsun ama b deki ay a daki aydan bir sonraki a oslun dikkatttttt
                                      -- current ayýna bir ekle b de ki aya eþitle

-------------------owen hoca

--2. Calculate the month-wise retention rate.
--Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Next Nonth / Total Number of Customers in The Previous Month
--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View.
--You can also use CTE or Subquery if you want.
--You should pay attention to the join type and join columns between your views or tables.
CREATE VIEW CURRENT_NUM_OF_CUST AS
SELECT	DISTINCT cust_id, [YEAR],
		[MONTH],
		CURRENT_MONTH,
		COUNT (cust_id)	OVER (PARTITION BY CURRENT_MONTH) RETENTITON_MONTH_WISE
FROM	time_gaps


SELECT *
FROM	CURRENT_NUM_OF_CUST
---
--DROP VIEW NEXT_NUM_OF_CUST
CREATE VIEW NEXT_NUM_OF_CUST AS
SELECT	DISTINCT cust_id, [YEAR],
		[MONTH],
		CURRENT_MONTH,
		NEXT_VISIT_MONTH,
		COUNT (cust_id)	OVER (PARTITION BY NEXT_VISIT_MONTH) RETENTITON_MONTH_WISE
FROM	time_gaps
WHERE	time_gaps = 1
AND		CURRENT_MONTH > 1


SELECT DISTINCT
		B.[YEAR],
		B.[MONTH],
		B.CURRENT_MONTH,
		B.NEXT_VISIT_MONTH,
		1.0 * B.RETENTITON_MONTH_WISE / A.RETENTITON_MONTH_WISE RETENTION_RATE
FROM	CURRENT_NUM_OF_CUST A LEFT JOIN NEXT_NUM_OF_CUST B
ON		A.CURRENT_MONTH + 1 = B.NEXT_VISIT_MONTH





---///////////////////////////////////
--Good luck! tommy
