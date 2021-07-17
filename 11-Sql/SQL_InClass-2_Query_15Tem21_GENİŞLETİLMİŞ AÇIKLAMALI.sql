-- 15.07.2021 DawSQL Sessinon 2

-- CROSS JOIN
-- Write a query that returns the table to be used to add products that are in the Products table 
-- but not in the stocks table to the stocks table with quantity = 0. 
-- (Do not forget to add products to all stores.)
-- Expected columns: store_id, product_id, quantity

SELECT B.store_id, A.product_id, A.product_name, 0 quantity -- quantity adýnda sütun oluþturup içine 0 giriyor
FROM production.products AS A
CROSS JOIN sales.stores AS B
WHERE A.product_id NOT IN (SELECT product_id FROM production.stocks)
ORDER BY A.product_id, B.store_id

----- CROSS JOIN-----

-- Soru1: Hangi markada hangi kategoride kaçar ürün olduðu bilgisine ihtiyaç duyuluyor
-- Ürün sayýsý hesaplamadan sadece marka * kategori ihtimallerinin hepsini içeren bir tablo oluþturun
-- Çýkan sonucu daha kolay yorumlamak için brand_id ve category_id alanlarýna göre sýralayýn.

SELECT *
FROM production.brands
CROSS JOIN production.categories
ORDER BY brand_id  -- ORDER BY production.brands.brand_id olarak da uzun yazýlabilir.

----- SELF JOIN------

-- Soru2: Write a query that returns the staff with their managers.
-- Expected columns: staff first name, staff last name, manager name

SELECT *
FROM sales.staffs

SELECT *
FROM sales.staffs AS A
JOIN sales.staffs AS B
ON A.manager_id = B.staff_id

SELECT *
FROM sales.staffs

SELECT A.first_name AS Staff_Name, A.last_name AS Staff_Last, B.first_name AS Manager
FROM sales.staffs A, sales.staffs B
WHERE  A.manager_id = B.staff_id


---- GROUPBY / HAVING ----

--GROUPING OPERATION SORU1-- 
--Write a query that checks if any product id is repeated in more than one row in the products table.
--TR: Ürünler tablosunda herhangi bir ürün kimliðinin birden fazla satýrda tekrarlanýp tekrarlanmadýðýný kontrol eden bir sorgu yazýn

SELECT product_name, COUNT(product_name)
FROM production.products
GROUP BY product_name
HAVING COUNT(product_name) >1; --HAVING’DE kullandýðýn sütun Aggregate te kullandýðýn sütun ismiyle ayný olmalý. 

-- hocanýn çözümü:
-- önce products larý görelim.
SELECT TOP 20* 
FROM production.products

SELECT product_id, COUNT(*) AS CNT_PRODUCT  -- count(*) tüm rowlarý say demek. Burda count(product_id) de ayný iþi görür.
FROM production.products
GROUP BY 
		product_id  -- bütün product_id lerin product tablosunda birer kere geçtiðini gördüm.


SELECT product_id, COUNT(*) AS CNT_PRODUCT 
FROM production.products
GROUP BY 
		product_id
HAVING               
		COUNT(*) > 1  --HAVING’DE kullandýðýn sütun Aggregate te kullandýðýn sütun ismiyle ayný olmalý. 

-- product_name e göre yapalým
SELECT product_name, COUNT(*) AS CNT_PRODUCT  -- count(*) tüm rowlarý say demek. Burda count(product_id) de ayný iþi görür.
FROM production.products
GROUP BY 
		product_name
HAVING 
		COUNT (*) > 1
-- aþaðýdaki gibi de kullanabiliriz.
SELECT product_name, COUNT(product_id) AS CNT_PRODUCT  -- count(*) tüm rowlarý say demek. count(product_id) de ayný iþi görür.
FROM production.products
GROUP BY 
		product_name
HAVING 
		COUNT (product_id) > 1

-- Bir sayma iþlemi bir gruplandýrma, aggregate iþlemi yapýyorsan isimle deðil de ID ile yap.
-- Id ler birer defa geçer. Ýsimler tekrar edebilir. 

SELECT product_id, product_name, COUNT (*) CNT_PRODUCT
FROM production.products
GROUP BY
		product_name
HAVING 
		COUNT (*) > 1
-- select te yazdýðýn sütunlar group by da olmasý gerekiyor. production_id group by da olmadýðý için hata verdi.

SELECT product_id, product_name, COUNT (*) CNT_PRODUCT
FROM production.products
GROUP BY
		product_name, product_id
HAVING 
		COUNT (*) > 1


SELECT	product_id, COUNT (*) AS CNT_PRODUCT
FROM	production.products
GROUP BY
		product_id
HAVING
		COUNT (*) > 1


--GROUPING OPERATION SORU 2-- 
-- Write a query that returns category ids with a maximum list price above 4000 or a minimum list price below 500
--TR: Maksimum liste fiyatý 4000'in üzerinde veya minimum liste fiyatý 500'ün altýnda olan kategori kimliklerini döndüren bir sorgu yazýn

SELECT category_id, MIN(list_price) AS min_price, MAX(list_price) AS max_price -- grupladýðýmýz þey category_id olduðu için SELECT'te onu getiriyoruz
FROM production.products
-- ana tablo içinde herhangi bir kýsýtlamam var mý yani where iþlemi var mý? yok. O zaman devam ediyorum
GROUP BY
		category_id
HAVING
		MIN(list_price) < 500 OR MAX(list_price) > 4000


--GROUPING OPERATION SORU 3-- 
-- Find the average product prices of the brands. TR: Markalarýn ortalama ürün fiyatlarýný bulun
-- As a result of the query, the average prices should be displayed in descending order.
--TR: Sorgu sonucunda ortalama fiyatlar azalan sýrada görüntülenmelidir.

SELECT A.brand_name, AVG(B.list_price) AS AVG_PRICE
FROM production.brands A, production.products B  
-- buradaki virgül INNER JOIN ile ayný iþi yapýyor! virgülle beraber WHERE kullanýyoruz.
WHERE A.brand_id = B.brand_id
GROUP BY 
		A.brand_name
ORDER BY
		AVG_PRICE DESC

-- (virgül + WHERE yerine--> INNER JOIN ile çözüm)
SELECT A.brand_name, AVG(B.list_price) AS AVG_PRICE
FROM production.brands AS A
INNER JOIN production.products AS B
ON A.brand_id = B.brand_id
GROUP BY 
		A.brand_name
ORDER BY 
		AVG_PRICE DESC
-- ORDER BY 2 DESC olarak da yazabilirdik. Burada 2 --> SELECT'teki ikinci belirtilen veriyi temsil ediyor.


--GROUPING OPERATION SORU 4-- 
-- Write a query that returns BRANDS with an average product price more than 1000
-- TR: Ortalama ürün fiyatý 1000'den fazla olan MARKALARI döndüren bir sorgu yazýn.

-- Virgül + WHERE kullanarak çözümü:
SELECT A.brand_name, AVG(B.list_price) AS AVG_PRICE
FROM production.brands A, production.products B  
WHERE A.brand_id = B.brand_id
GROUP BY 
		A.brand_name
HAVING AVG(B.list_price) > 1000
ORDER BY
		2 DESC

-- INNER JOIN ile çözümü:
SELECT B.brand_name, AVG(list_price) as avg_price
FROM production.products as A
INNER JOIN production.brands as B
ON A.brand_id = B.brand_id
GROUP BY brand_name
HAVING AVG (list_price) > 1000
ORDER BY avg_price ASC;


--GROUPING OPERATION SORU 5-- 
--Write a query that returns the net price paid by the customer for each order. (Don't neglect discounts and quantities)
--TR: Her sipariþ için müþterinin ödediði net fiyatý döndüren bir sorgu yazýn. (Ýndirimleri ve miktarlarý ihmal etmeyin)

SELECT *, (quantity * list_price * (1-discount)) as net_price -- (list_price-list_price*discount) olarak da yazýlabilirdi.
FROM sales.order_items
-- bu query ile önce her bir item_id için list_price ile indirim uygulanmýþ net_price larý görüyoruz.

-- order'larda birden fazla ürün sipariþ verilmiþ olduðunu görmüþtüm. (order_id'lerin birden fazla item_id'leri var.)
-- O yüzden ürünleri order_id olarak gruplandýrýp her grup için toplama (SUM) yaparak
-- her order_id için TOPLAM net_price'ý görmüþ olacaðým.

SELECT order_id, SUM(quantity * list_price * (1-discount)) as net_price
FROM sales.order_items
GROUP BY 
		order_id



-------- CREATING SUMMARY TABLE INTO OUR EXISTING TABLE -------

SELECT *
INTO NEW_TABLE     -- INTO SATIRINDAKÝ TABLO ÝSMÝ ÝLE YENÝ BÝR TABLO OLUÞTURUYORUZ.
FROM SOURCE_TABLE  -- FROM'DAN SONRASI KAYNAK TABLOMUZ
WHERE ...


SELECT C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
-- brands tablosundan brand_name, categories tablosundan category_name, products tablosundan model_year
-- sütunlarýný seçiyoruz, bunlara indirim uygulanmýþ net fiyatlarý yuvarlayarak ve total_sales_price ismi vererek
-- oluþturduðumuz sütunu ekliyoruz.
INTO sales.sales_summary  -- INTO ile bu satýrda ismini belirlediðimiz "sales_summary" tablosunu oluþturuyoruz. Tablonun sütunlarýný SELECT satýrýncda belirledik.
FROM sales.order_items A, production.products B, production.brands C, production.categories D  --SELECT satýrýnda seçtiðimiz sütunlara ait tablolar.
WHERE A.product_id = B.product_id --A ile B'yi birleþtirdik.
AND B.brand_id = C.brand_id  -- B ile C'yi birleþtirdik
AND B.category_id = D.category_id --B ile D'yi birleþtirdik. Hepsi birleþmiþ oldu.
GROUP BY
C.brand_name, D.category_name, B.model_year  --group by satýrýnda gruplandýrdýðýmýz sütunlar SELECT'te aynen olmalý!!

--!!!! DÝKKAT.. DAHA ÖNCE BU KOD ÇALIÞTIRILDIÐI VE sales_summary ÝSMÝNDE TABLO OLUÞTURULDUÐU ÝÇÝN TEKRAR ÇALIÞTIRIRSAN HATA ALIRSIN!

SELECT *
FROM sales.sales_summary
ORDER BY 1,2,3


-- BUNDAN SONRA BU TABLOYU KULLANACAÐIM!

----------- GROUPING SETS ----------

-- 1. Toplam satýþ miktarýný hesaplayýnýz.
SELECT SUM(total_sales_price)
FROM sales.sales_summary

-- 2. Markalarýn toplam satýþ miktarýný hesaplayýnýz.
SELECT Brand, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Brand

-- 3. Kategori bazýnda toplam satýþ miktarýný hesaplayýnýz
SELECT Category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Category

-- 4. Marka ve kategori kýrýlýmlarýndaki toplam sales miktarlarýný hesaplayýnýz
SELECT Brand, Category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Brand, Category

--- Þimdi bu iþlemleri GROUPING SETS yöntemi ile yapalým :---

SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY
		GROUPING SETS(
						(Brand),
						(category),
						(brand, category),
						()      -- boþ parantez gruplandýrma olmayan durumlarý getirir. 
						)
ORDER BY
		1, 2


------- ROLLUP VE CUBE ile GRUPLAMA------

-- ROLLUP, en ayrýntýlýdan genel toplama kadar ihtiyaç duyulan herhangi bir toplama düzeyinde alt toplamlar oluþturur.
-- CUBE, ROLLUP’a benzer ama tek bir ifadenin tüm olasý alt toplam kombinasyonlarýný hesaplamasýný saðlar


----- ROLLUP GRUPLAMA-----
SELECT
		d1,
		d2,
		d3, 
		aggregate_function
FROM
		table_name
GROUP BY
		ROLLUP (d1,d2,d3);

		-- önce tüm sütuýnlarý alýyor sonra saðdan baþlayarak teker teker silerek her defasýnda yeniden bir gruplama yapýyor;
		-- önce üç sütuna göre grupluyor, sonra sondakini atýp ilk 2 sütuna göre grupluyor
		-- sonra sondakini yine atýp ilk sütuna göre grupluyor
		-- sonra hiç gruplamýyor.-- 

SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY
		ROLLUP (Brand, Category)
ORDER BY
		1,2
		;


------ CUBE GRUPLAMA--------
SELECT
		d1,
		d2,
		d3, 
		aggregate_function
FROM
		table_name
GROUP BY
		CUBE (d1,d2,d3);

--- önce önce üç sütunu birden grupluyor.
-- sonra kalanlarý 2'þer 2'þer 3 defa gruplama yapýyor.
-- sonra kalanlarý teker teker grupluyor.
-- en son gruplamýyor.

SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY
		CUBE (Brand, Category)
ORDER BY
		1,2
	;

----ilave-----
	SELECT b.brand_name AS brand, c.category_name AS category, p.model_year,
     ROUND (SUM (quantity * i.list_price * (1 - discount)) , 0 ) total_sales_price
INTO sales.sales_summary
FROM
sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year


Send a message to student-zone-tr

