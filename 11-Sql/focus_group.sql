------------ JOIN
----- we have different type  of joins: inner join, left join, right join, full outer join, cross join
---- The main advantage of a join is that it executes faster. 
--- you can merge different tables also you can take columns in different tables and then you can insert into new table

select A.product_id, A.product_name, B.category_id, B.category_name
from production.products A
inner join production.categories B
on A.category_id = B.category_id


select A.product_id, A.product_name, B.category_id, B.category_name
from production.products A,
 production.categories B
where A.category_id = B.category_id


select A.product_id, A.product_name, B.category_id, B.category_name
from production.products A
left join production.categories B
on A.category_id = B.category_id


SELECT	*
FROM	production.brands A
CROSS JOIN production.categories B
ORDER BY A.brand_id, B.category_id
;


----- having and grouping set

---- having bize verilen kisitlamalar ile kullaniyoruz. For example, eger bir calisanin maasi belli bir sayidan fazla olanlarin bulunmasi isteniyorsa
---- buna ek olarak group by ile aggregate function (SUM, MAX, MIN, AVG, COUNT) kullaniyoruz. 
--- aggregate functiondan once kullandigimiz columnlarin hepsini group by dan sonra yazmamiz gerekiyor.
SELECT	product_id, COUNT (product_id)
FROM	production.products
GROUP BY
		product_id
HAVING COUNT (product_id) > 1


--maximum list price' ı 4000' in üzerinde olan veya minimum list price' ı 500' ün altında olan categori id' leri getiriniz
--category name' e gerek yok.

SELECT     category_id, MAX(list_price) AS max_price
FROM       production.products
GROUP BY   category_id
HAVING     MAX(list_price) > 4000 

--- grouping sets 
--- grouping sets ler different group by sekilleridir. 
--- bu gruplama sekilleri: grouping sets, cube, rollup, pivot table

--- joinlerle uc dort tablodan istedigim columnlari secip bunu inser into ile yeni bir tabloya attim.
SELECT b.brand_name AS brand, c.category_name AS category, p.model_year,

     ROUND (SUM (quantity * i.list_price * (1 - discount)) , 0 ) sales--ROUND fonksiyonu küsüratlı sayıyı yuvarlar

INTO sales.sales_summary--SELECT * INTO yapısıyla istediğimiz verileri yeni bir tabloya kopyaladık
FROM
sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year


	SELECT *
FROM	sales.sales_summary1
ORDER BY	1,2,3



--1. Toplam sales miktarını hesaplayınız.

SELECT SUM(total_sales_price) 
FROM	SALES.sales_summary1



--2. Markaların toplam sales miktarını hesaplayınız


SELECT	Brand, SUM(total_sales_price) 
FROM	SALES.sales_summary
GROUP BY
		brand


--3. Kategori bazında yapılan toplam sales miktarını hesaplayınız

SELECT	category, SUM(total_sales_price) 
FROM	SALES.sales_summary
GROUP BY
		category


--4. Marka ve kategori kırılımındaki toplam sales miktarını hesaplayınız

SELECT	brand, category, SUM(total_sales_price) 
FROM	SALES.sales_summary
GROUP BY
		brand,category


---- grouping sets

SELECT	brand, category, SUM(total_sales_price) 
FROM	SALES.sales_summary
GROUP BY
	GROUPING SETS (
					(brand, category),
					(brand),
					(category),
					()
					)
ORDER BY
	brand, category


--- cube

SELECT	brand, category, model_year, SUM(total_sales_price) 
FROM	SALES.sales_summary
GROUP BY
		CUBE (brand,category, model_year)
ORDER BY
	brand, category

--- rollup 

SELECT	brand, category, model_year, SUM(total_sales_price) 
FROM	SALES.sales_summary
GROUP BY
		ROLLUP (brand,category, model_year)
ORDER BY
	model_year, category

--- pivot 
--- pivot table, tableimizdaki satirlari columnlar haline getirmek icin kullanilir.


SELECT category ,SUM(total_sales_price)
FROM SALES.sales_summary1
GROUP BY category


SELECT *
FROM
			(
			SELECT category , total_sales_price
			FROM SALES.sales_summary1
			) A
PIVOT
(
	SUM(total_sales_price)
	FOR category IN
	(
	[Children Bicycles], 
    [Comfort Bicycles], 
    [Cruisers Bicycles], 
    [Cyclocross Bicycles], 
    [Electric Bikes], 
    [Mountain Bikes], 
    [Road Bikes])
	) AS PIVOT_TABLE


----subqueries

-- Kali	Vargas'ın çalıştığı mağazadaki tüm personelleri listeleyin.
SELECT	*
FROM	sales.staffs
WHERE	store_id = (
					SELECT	store_id
					FROM	sales.staffs
					WHERE	first_name = 'Kali' AND
							last_name = 'Vargas'
					)

-- 'Rowlett Bikes' isimli mağazanın bulunduğu şehirdeki müşterileri listeleyin.
SELECT	*
FROM	sales.customers
WHERE	city = (
				SELECT	city
				FROM	sales.stores
				WHERE	store_name = 'Rowlett Bikes'
				)


	-- Holbrook şehrinde oturan müşterilerin sipariş tarihlerini listeleyin.
SELECT	order_date
FROM	sales.orders
WHERE	customer_id IN (SELECT	customer_id
						FROM	sales.customers
						WHERE	city = 'Holbrook'
						)
;


----- set operations
--- union, union all, intersect
--- The UNION command combines the result set of two or more SELECT statements (only distinct values)
--- The UNION ALL command combines the result set of two or more SELECT statements (allows duplicate values).
---- the INTERSECT statement will return only those rows which will be common to both of the SELECT statements.
-- Sacramento şehrindeki müşteriler ile Monroe şehrindeki müşterilerin soyisimlerini listeleyin
---- union

SELECT	last_name
FROM	sales.customers
WHERE	city = 'Sacramento'
UNION
SELECT	last_name
FROM	sales.customers
WHERE	city = 'Monroe'
;



---- union all 

SELECT	last_name
FROM	sales.customers
WHERE	city = 'Sacramento'
UNION ALL
SELECT	last_name
FROM	sales.customers
WHERE	city = 'Monroe'
;

SELECT	last_name
FROM	sales.customers
WHERE	city IN ('Sacramento', 'Monroe')
;


SELECT	*
FROM	production.brands
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2016
					INTERSECT
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2017
					)
;

---- case expression
-- The CASE expression evaluates a list of conditions and returns one of multiple possible result expressions. The CASE expressions let you use IF ... THEN ... ELSE logic in SQL statements.

-- Generate a new column containing what the mean of the values in the Order_Status column.

-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
--(simple case expression)
SELECT	order_id, order_status, 
		CASE order_status
			WHEN 1 THEN 'Pending'
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			WHEN 4 THEN 'Completed'
		END order_status_desc
FROM	sales.orders
;

--- searched case expression
-- The CASE expression evaluates a list of conditions and returns one of multiple possible result expressions. The CASE expressions let you use IF ... THEN ... ELSE logic in SQL statements.

-- Personellerin çalıştıkları mağaza isimlerini searched case expression ile yazdırınız.
SELECT	*,
CASE
		WHEN store_id = 1 THEN 'Santa Cruz Bikes'
		WHEN store_id = 2 THEN 'Baldwin Bikes'
		WHEN store_id = 3 THEN 'Rowlett Bikes'
		ELSE 'Unknown'
	END Store_name
FROM	sales.staffs
;


----- Window function


---. Herbir kategorideki en ucuz bisikletin fiyatı

SELECT	DISTINCT 
		category_id,
		MIN(list_price) OVER(PARTITION BY category_id) cheap_bike_by_cat
FROM	production.products
ORDER BY category_id
;


-- Herbir kategoride toplam kaç farklı bisikletin bulunduğu


SELECT	DISTINCT category_id,
		COUNT(product_id) OVER(PARTITION BY category_id) num_of_bike_by_cat
FROM	production.products
ORDER BY category_id
;



---- WF with frame


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) numofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) numofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	production.products


ORDER BY category_id, product_id
;













