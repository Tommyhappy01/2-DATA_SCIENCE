----------- 16.07.2021 DAwSQL Lab 1 ---------
--Write a query that returns the average prices according to brands and categories.
		SELECT A.brand_name, B.category_name, AVG(C.list_price) AVG_price
FROM production.brands A, production.categories B,production.products C
where A.brand_id= c.brand_id   -- a ile c eþitlendi
and B.category_id=c.category_id --b ile c yi eþitledik
group by A.brand_name, B.category_name-- select e yazýlan group by a yazýlýr
order by 3 desc  -- 3. sütüna göre sýrala tersten


-------------//////////////////
--Write a query that returns the store which has the most sales quantity in 2016.
SELECT TOP 20*
FROM	sales.orders
SELECT TOP 20 *
FROM sales.order_items
SELECT *
FROM	sales.stores
SELECT	TOP 1 C.store_id, C.store_name, SUM (B.quantity) TOTAL_PRODUCT
FROM	SALES.orders A, sales.order_items B, sales.stores C
WHERE	A.order_id = B.order_id
AND		A.store_id = C.store_id
AND		A.order_date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY
		C.store_id, C.store_name
ORDER BY
		TOTAL_PRODUCT DESC
SELECT	TOP 1 C.store_id, C.store_name, SUM  (B.quantity) TOTAL_PRODUCT
FROM	SALES.orders A, sales.order_items B, sales.stores C
WHERE	A.order_id = B.order_id
AND		A.store_id = C.store_id
AND		A.order_date LIKE '%2016%'
GROUP BY
		C.store_id, C.store_name
ORDER BY
		TOTAL_PRODUCT DESC;
--------------
SELECT TOP 1 C.store_id, C.store_name,SUM(B.quantity) TOTAL_PRODUCT
FROM sales.orders A, sales.order_items B, sales.stores C
WHERE A.order_id = B.order_id
AND   A.store_id = C.store_id
AND A.order_date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY C.store_id, C.store_name
ORDER BY TOTAL_PRODUCT DESC
-- top 1 sadece 1 tane getirdi c.den store,c den store name sonra sum
-- fromlar a b c
-- where le eþitle kalaný and ile eþitle
--devam adn ile between þart
--group by ile select
--order by agg de kini yazdýk
SELECT TOP 1 C.store_id, C.store_name,SUM(B.quantity) TOTAL_PRODUCT
FROM sales.orders A, sales.order_items B, sales.stores C
WHERE A.order_id = B.order_id
AND   A.store_id = C.store_id
AND A.order_date like '%2016%'
GROUP BY C.store_id, C.store_name
ORDER BY TOTAL_PRODUCT DESC

-----------------------------------------------
--'Trek Remedy 9.8 - 2017' satýþý yapýlmayan state neresidir.

SELECT E.state, COUNT(product_id) CNT_PRODUCT
FROM
	(
	SELECT C.order_id, C.customer_id, A.product_id, product_name
	FROM production.products A,
		sales.order_items B,
		sales.orders C
	WHERE A.product_id = B.product_id
	AND	  B.order_id = C.order_id
	AND   A.product_name = 'Trek Remedy 9.8 - 2017'
	) D
RIGHT JOIN
sales.customers E ON D.customer_id = E.customer_id
GROUP BY E.state
HAVING count(PRODUCT_ÝD) = 0