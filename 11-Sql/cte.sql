-----------CTE-----------------
--iç  içe sorgu yapmamamýzý saðlar
--WITH önemli ORDINARY ve RECURSÝVE CTE types
------------------
--WITH query_name [(column_name,...)] AS
--(SELECT ...)--CTE definition

--SQL statement
---------------------
--WITH query_name [(column_name,...)] AS
--(SELECT ...)--CTE definition

-- anchor member
--initial_query
--UNION ALL
--Recursive member

--SQL statement
--------------------------------------------------------
Question: List customers who have an order prior to the
last order of a customer named Sharyn Hopkins and are residents
of the city of San Diego.
------------------------
WITH T1 AS
(
	select MAX(b.order_date) LAST_ORDER
	from sales.customers a , sales.orders b
	where a.customer_id = b.customer_id
	and a.first_name = 'Sharyn'
	and a.last_name = 'Hopkins'
)

SELECT a.customer_id,first_name,city,order_date 
FROM sales.customers A , sales.orders B, T1 C 
WHERE A.customer_id = B.customer_id
AND B.order_date < C.LAST_ORDER
AND A.city = 'San Diego'
----------------------------------------
-- Question: 0'dan 9'a kadar herbir rakam bir satýrda olacak þekilde bir tablo olusturun.
WITH T1 AS
		  (
		  SELECT 0 AS number  -- 0 oluþtur column number olsun
		  UNION ALL           -- tablolarýn hepsini birleþitr.
		  SELECT number + 1   -- tekrar 2. sorgu 1 ekle
		  FROM T1			  -- T1 tablosunu kullan
		  WHERE number <= 8   -- 8'e kadar kullan
		  )
SELECT *
FROM T1

---------------





