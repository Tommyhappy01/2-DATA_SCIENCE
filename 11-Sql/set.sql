--set operatörler birden fazla tabloyu düzenlemek için kullanýlýr.

UNION  birleþim yapar  biraz yavaþ ortaklar teke düþer SET ya
UNION ALL birleþim yapar hýzlý tekrarlarda olabilir. SET deðil gibi
ÝNTERSECT kesiþenleri alýr

-------------------------
-- Question: Sacramento þehrindeki müþteriler ile Monroe þehrindeki müþterilerin soy isimlerini listeleyin
SELECT last_name
FROM sales.customers AS A
WHERE city='Sacramento'
UNION ALL
SELECT last_name
FROM sales.customers AS A
WHERE city='Monroe'
---------------------
SELECT first_name,last_name
FROM sales.customers AS A
WHERE city='Sacramento'
UNION 
SELECT first_name,last_name
FROM sales.customers AS A
WHERE city='Monroe'
---------------------
SELECT first_name,last_name
FROM sales.customers AS A
WHERE city='Sacramento' or city='Monroe'

-------------------------
SELECT first_name,last_name
FROM sales.customers AS A
WHERE city in('Sacramento','Monroe')

-----------------------------------------------
---bir taraftan city bir taraftan state geldi.
SELECT city
FROM sales.stores
UNION ALL
SELECT state
FROM sales.stores
-----
SELECT city, 'STATE' as state
FROM sales.stores
UNION ALL
SELECT state, 1 as city  -- OLMADI HATA VERDÝ TYPE LAR AYNI DEÐÝL
FROM sales.stores
---------------

SELECT A.brand_name
FROM production.brands A, production.products B
WHERE A.brand_id = B.brand_id
AND B.model_year = 2016
INTERSECT
SELECT A.brand_name
FROM production.brands A, production.products B
WHERE A.brand_id = B.brand_id
AND B.model_year = 2017 
------- 2.yol
select*
from production.brands
where brand_id in
		(
		SELECT brand_id
		FROM production.products 
		WHERE model_year=2016
		intersect
		SELECT brand_id
		FROM production.products 
		WHERE model_year=2017
		)
order by brand_id desc;-- ORDER BY en sona yazýlýr
------------------------------
SELECT A.first_name, A.last_name FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id and year(order_date) = 2018
INTERSECT
SELECT A.first_name, A.last_name FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id and year(order_date) = 2017
INTERSECT
SELECT A.first_name, A.last_name FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id and year(order_date) = 2016
-----------------------------
SELECT	first_name, last_name
FROM	sales.customers
WHERE	customer_id IN (
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2016-01-01' AND '2016-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2017-01-01' AND '2017-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'
						)
--------------------------------
EXCEPT t1 tablosunu t2 den çýkar A'nýn B'den farký
sütün isimleri önemli deðil, sýra çok önemli
sadece  ilk tabloda olanlarý getirir.
----------------------------------
SELECT brand_name
FROM production.brands
where brand_id in
(
SELECT brand_id
FROM production.products 
WHERE model_year = 2016

except

SELECT brand_id
FROM production.products 
WHERE model_year = 2017
)

----------------------------

SELECT A.product_id, A.product_name
FROM production.products A, sales.orders B, sales.order_items C
WHERE A.product_id = C.product_id
AND B.order_id = C.order_id AND YEAR(order_date) = 2017

EXCEPT

SELECT A.product_id, a.product_name
FROM production.products A, sales.orders B, sales.order_items C
WHERE A.product_id = C.product_id
AND B.order_id = C.order_id AND YEAR(order_date) != 2017
---
SELECT	product_id, product_name
FROM	production.products
WHERE	product_id IN (
					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date BETWEEN '2017-01-01' AND '2017-12-31'
					EXCEPT
					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date NOT BETWEEN '2017-01-01' AND '2017-12-31'
					)



--------------------
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
SELECT order_status,
		CASE order_status WHEN 1 THEN 'Pending'
						  WHEN 2 THEN 'Processing'
						  WHEN 3 THEN 'Rejected'
						  WHEN 4 THEN 'Completed'
		END AS MEAN_OF_STATUS
FROM sales.orders

----------------------
- Create a new column containing the labels of the customers
 email service providers ( "Gmail", "Hotmail", "Yahoo" or 
"Other" )


FROM sales.customers
SELECT email,
		CASE        WHEN email LIKE '%gmail%' THEN 'GMAIL'
					WHEN email LIKE '%hotmail%' THEN 'HOTMAIL'
					WHEN email LIKE '%yahoo%' THEN 'YAHOO'
					ELSE 'OTHER'
		END AS email_service_providers
FROM sales.customers
