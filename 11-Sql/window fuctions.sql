
-------WİNDOW FUNCTİON---ANALYTİC AGGREGATE FUNC.-----------------
-- group by tek atır halinde getirir, dıstınct kullanılmaz, tablo oluşturur,slowly,invalid,dependent
-- agg yapılır fakat satır sayısı teke düşmez window function--dıstınct kullanılabilir,faster,valid,independent

--WINDOW FRAME; hangi satırları kapsasın,
-- UNBOUNDED PRECEDİNG  tüm satırların öncesine bak -- UNBOUNDED FOLLOWİNG tüm satıralrın sonrasına bak
--n PRECEDİNG  biz rows u kullanacaz.between ile başlar
--satırların bir öncesine  ve bir sonrakine bakıp  işlem yapar.
Veri setinde mevcut satırla bir şekilde ilişkili olan bir dizi satırda bir işlem gerçekleştirmemizi
sağlar. Group by fonksiyonundan farklı olarak diğer satırlardaki verileri de hesaplamaya dahil 
edebiliriz. Hareketli ortalama-kümülatif toplam gibi işlemleri bu fonksiyonlarla grup bazında 
kolayca yapabiliriz.


--QERY TİME--
--ürünlerin stock sayılarını bulunuz
SELECT	product_id, SUM(quantity)
FROM	production.stocks
GROUP BY product_id

SELECT	product_id
FROM	production.stocks
GROUP BY product_id
ORDER BY 1
----------------
-- Markalara göre ortalama bisiklet fiyatlarını hem Group By hem de window Functions ile 
--hesaplayınız.
SELECT  distinct brand_id,AVG(list_price) OVER(PARTITION BY brand_id) avg_price
FROM production.products

SELECT  brand_id,AVG(list_price) avg_price
FROM production.products
GROUP by Brand_id
----------------------------------------------------
-- Tüm bisikletler arasında en ucuz bisikletin fiyatı

SELECT distinct MIN(list_price) OVER() min_price
FROM production.products

SELECT TOP 1 product_name, MIN(list_price) OVER()
FROM production.products
-------------------------------------------------------
--2. Herbir kategorideki en ucuz bisikletin fiyatı
SELECT distinct category_id, MIN(list_price) OVER(PARTITION BY category_id) min_price
FROM production.products
------------------------------------------------------
--product tablosunda toplam kaç farklı bisiklet bulunduğu

SELECT distinct  COUNT(product_id) OVER() num_of_bike
FROM production.products
----------------------------------------------------
--Order_items tablosunda toplam kaç farklı bisiklet olduğu

SELECT  COUNT(distinct product_id)
FROM sales.order_items
---
SELECT DISTINCT COUNT(product_id) OVER() order_num_of_bike
FROM (
		SELECT DISTINCT product_id
		FROM sales.order_items
	) A
	--------------------------------------------
----herbir aktegoride toplam kaç farklı ürün bulunduğu

SELECT distinct category_id, COUNT(product_id) OVER(PARTITION BY category_id)
FROM production.products
-------------------------------------------------
-- Herbir kategorideki herbir  markada kaç farklı bisikletin bulunduğu
SELECT distinct category_id,brand_id, COUNT(product_id) OVER(PARTITION BY category_id,brand_id)
FROM production.products
-------------------------
SELECT distinct category_id,brand_id, COUNT(product_id) OVER(PARTITION BY category_id,brand_id)
FROM production.products
------------------------------------
--Can we calculate how many different brands are in each category in this query with WF?


SELECT DISTINCT category_id, count (brand_id) over (partition by category_id)
FROM
(
SELECT	DISTINCT category_id, brand_id
FROM	production.products
) A
-----------------------------------------------------------------------------------------
---- 2. ANALYTIC NAVIGATION FUNCTIONS

--first_value() - last_value() - lead() - lag()

--Order tablosuna aşağıdaki gibi yeni bir sütun ekleyiniz:

--1. Herbir personelin bir önceki satışının sipariş tarihini yazdırınız (LAG fonksiyonunu kullanınız)

select *,LAG(order_date,1) OVER (PARTITION BY staff_id ORDER BY order_date,order_id) prev_order_date
from sales.orders
--staff id leri partitionla grupladı aldı order id ye göre grupladı LAG bir öncekini aldı.
------------------------------------------------------------
--Order tablosuna aşağıdaki gibi yeni bir sütun ekleyiniz:
--2. Herbir personelin bir sonraki satışının sipariş tarihini yazdırınız (LEAD fonksiyonunu kullanınız)
SELECT	*,
		LEAD(order_date, 1) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) next_ord_date
FROM	sales.orders
-- LEAD, current row'dan belirtilen argümandaki rakam kadar sonraki değeri getiriyor
-- Niye iki sütunu order by yaptık? çünkü ayın aynı gününde birden fazla sipariş verilmiş olabilir.
	-- o yüzden tarihe ilave olarak bir de order_id ye göre sıralama yaptırdık
--GENELLİKLE LEAD VE LAG FONKSİYONLARI SIRALANMIŞ BİR LİSTEYE UYGULANIR!!! O YÜZDEN ORDER BY KULLANILMALIDIR!!

--burda da staff_id :2 olanların son satırının NULL olduğuna dikkat ! (orada ilk pencere bitiyor)


-----------WİNDOW FRAME------------------

SELECT category_id,product_id,
	COUNT(*) OVER() TOTAL
FROM production.products

SELECT DISTINCT category_id,product_id
	COUNT(*) OVER() TOTAL_ROW,
	COUNT(*) OVER(PARTITION BY category_id ORDER BY prdoduct_id) num_of_rows
FROM production.products

--- bu da biraz farklı

SELECT DISTINCT category_id, product_id,
	   COUNT(*) OVER() AS total_row,      ---satırları say
	   COUNT(*) OVER(PARTITION BY category_id) AS num_of_row,--cumulatif toplam
	   COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) AS num_of_row  --cumulatif toplam
FROM production.products

---
SELECT category_id,
	   COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS prev_with_curve
FROM production.products
-- öncekiyle beraber getiriyor.

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id
----------
SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id
------------
SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id

--yukarıda bir önceki ve bir sonrakini hesaba katıyo
--------------------------------------------------------------------------------
SELECT	category_id,                          -- kendiside var unutma
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id

-------------------------
--FİRST_VALUE---

--1. Tüm bisikletler arasında en ucuz bisikletin adı (FIRST_VALUE fonksiyonunu kullanınız)
SELECT distinct FIRST_VALUE(product_name) OVER (order by list_price)
FROM production.products
--ürünün yanına list price' ini nasıl eklersiniz?

SELECT distinct FIRST_VALUE (product_name) OVER ( ORDER BY list_price),min(list_price) over()
FROM production.products 

-------------------------------------------------------
--2. Herbir kategorideki en ucuz bisikletin adı (FIRST_VALUE fonksiyonunu kullanınız)


SELECT distinct category_id,FIRST_VALUE (product_name) OVER (partition by category_id  ORDER BY list_price)
FROM production.products
--------------------------------------------

--1. Tüm bisikletler arasında en ucuz bisikletin adı (LAST_VALUE fonksiyonunu kullanınız)
SELECT distinct
       FIRST_VALUE(product_name) OVER (order by list_price),
	   LAST_VALUE(product_name) OVER (order by list_price desc)
FROM production.products



--1. Tüm bisikletler arasında en ucuz bisikletin adı (LAST_VALUE fonksiyonunu kullanınız)
SELECT	DISTINCT
		FIRST_VALUE(product_name) OVER ( ORDER BY list_price),
		LAST_VALUE(product_name) OVER (	ORDER BY list_price ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	production.products

---------------------------------------------------------------------

--1. Herbir kategori içinde bisikletlerin fiyat sıralamasını yapınız (artan fiyata göre 1'den başlayıp birer birer artacak)

SELECT category_id, list_price,
	   ROW_NUMBER () OVER(PARTITION BY category_id ORDER BY list_price) AS ROW_NUM
FROM production.products


--2. Aynı soruyu aynı fiyatlı bisikletler aynı sıra numarasını alacak şekilde yapınız (RANK fonksiyonunu kullanınız)
SELECT category_id, list_price,
ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM
FROM production.products

--built-in function RANKO RETURNS bigint (edited) 


SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM
FROM	production.products
---------------------------------------------

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) CUME_DIST
FROM	production.products


--4. Herbir kategori içinde bisikletierin fiyatlarına göre bulundukları yüzdelik dilimleri yazdırınız. (CUME_DIST fonksiyonunu kullanınız)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		round(CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price),2) CUME_DIST
FROM	production.products

--5. Herbir kategori içinde bisikletierin fiyatlarına göre bulundukları yüzdelik dilimleri yazdırınız. (PERCENT_RANK fonksiyonunu kullanınız)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK
FROM	production.products
-- cume dist en yuksek değere 1 verir,  percent_rank 0 dan başlar
-------------------------------------------------------------------------
 -6. Herbir kategorideki bisikletleri artan fiyata göre 4 gruba ayırın. Mümkünse her grupta aynı sayıda bisiklet olacak.
--(NTILE fonksiyonunu kullanınız)
SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK,
		NTILE(4) OVER (PARTITION BY category_id ORDER BY list_price) ntil
FROM	production.products




------------------------------------------------------------------
----------------------------------------------------------------
-----------------------------------------------------------------


----------- 2021-08-05 DAwSQL Session 7 Window Functions------------



--ürünlerin stock sayýlarýný bulunuz


SELECT	product_id, SUM(quantity)
FROM	production.stocks
GROUP BY product_id


SELECT	product_id
FROM	production.stocks
GROUP BY product_id
ORDER BY 1



SELECT	*, SUM(quantity) OVER (PARTITION BY product_id) 
FROM	production.stocks


SELECT	DISTINCT product_id, SUM(quantity) OVER (PARTITION BY product_id) 
FROM	production.stocks



-- Markalara göre ortalama bisiklet fiyatlarýný hem Group By hem de Window Functions ile hesaplayýnýz.


SELECT	brand_id, AVG(list_price) avg_price
FROM	production.products
GROUP BY brand_id



SELECT	DISTINCT brand_id, AVG(list_price) OVER (PARTITION BY brand_id) avg_price
FROM	production.products



-- 1. ANALYTIC AGGREGATE FUNCTIONS --


--MIN() - MAX() - AVG() - SUM() - COUNT()


--1. Tüm bisikletler arasýnda en ucuz bisikletin fiyatý


SELECT	DISTINCT MIN (list_price) OVER ()
FROM	production.products


--2. Herbir kategorideki en ucuz bisikletin fiyatý


SELECT	DISTINCT category_id, MIN (list_price) OVER (PARTITION BY category_id)
FROM	production.products



--3. Products tablosunda toplam kaç faklý bisikletin bulunduðu


SELECT	DISTINCT COUNT (product_id) OVER () NUM_OF_BIKE
FROM	production.products


--Order_items tablosunda toplam kaç farklý bisiklet olduðu


SELECT DISTINCT COUNT(product_id) OVER() order_num_of_bike
FROM sales.order_items



SELECT DISTINCT COUNT(product_id) OVER() order_num_of_bike
FROM (
		SELECT DISTINCT product_id
		FROM sales.order_items
	) A



SELECT COUNT (DISTINCT product_id)
FROM sales.order_items



--4. Herbir kategoride toplam kaç farklý bisikletin bulunduðu


SELECT	DISTINCT category_id, COUNT (product_id) OVER (PARTITION BY category_id)
FROM	production.products 


--5. Herbir kategorideki herbir markada kaç farklý bisikletin bulunduðu



SELECT	DISTINCT category_id, brand_id, COUNT (product_id) OVER (PARTITION BY category_id, brand_id)
FROM	production.products 




--Soru: WF ile tek select' te herbir kategoride kaç farklý marka olduðunu hesaplayabilir miyiz?



select distinct category_id, COUNT(brand_id) over(partition by category_id) num_of_brand
from (

select distinct category_id, brand_id
from	production.products

) A


---- 2. ANALYTIC NAVIGATION FUNCTIONS --


--first_value() - last_value() - lead() - lag()


--Order tablosuna aþaðýdaki gibi yeni bir sütun ekleyiniz:
--1. Herbir personelin bir önceki satýþýnýn sipariþ tarihini yazdýrýnýz (LAG fonksiyonunu kullanýnýz)



SELECT	*, 
		LAG(order_date, 1) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) prev_ord_date
FROM	sales.orders



--Order tablosuna aþaðýdaki gibi yeni bir sütun ekleyiniz:
--2. Herbir personelin bir sonraki satýþýnýn sipariþ tarihini yazdýrýnýz (LEAD fonksiyonunu kullanýnýz)


SELECT	*, 
		LEAD(order_date, 1) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) next_ord_date
FROM	sales.orders



SELECT	*, 
		LEAD(order_date, 2) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) next_ord_date
FROM	sales.orders



-- Window Frame --



SELECT 
		COUNT (*) OVER () TOTAL_ROW
from	production.products


---


SELECT  DISTINCT category_id,  
		COUNT (*) OVER () TOTAL_ROW,
		COUNT (*) OVER (PARTITION BY category_id) num_of_row,
		COUNT (*) OVER (PARTITION BY category_id ORDER BY product_id) num_of_row
from	production.products


---


SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current
from	production.products


---

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id





SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id



--


SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id


--


SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id



--

SELECT	category_id,
		COUNT(*) OVER( ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id



---


--1. Tüm bisikletler arasýnda en ucuz bisikletin adý (FIRST_VALUE fonksiyonunu kullanýnýz)


SELECT	FIRST_VALUE(product_name) OVER ( ORDER BY list_price)
FROM	production.products


--ürünün yanýna list price' ýný nasýl eklersiniz?

SELECT	 DISTINCT FIRST_VALUE(product_name) OVER ( ORDER BY list_price) , min (list_price) over ()
FROM	production.products




--2. Herbir kategorideki en ucuz bisikletin adý (FIRST_VALUE fonksiyonunu kullanýnýz)



select distinct category_id, FIRST_VALUE(product_name) over (partition by category_id order by list_price)
from production.products



--1. Tüm bisikletler arasýnda en ucuz bisikletin adý (LAST_VALUE fonksiyonunu kullanýnýz)


SELECT	DISTINCT 
		FIRST_VALUE(product_name) OVER ( ORDER BY list_price),
		LAST_VALUE(product_name) OVER (	ORDER BY list_price desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	production.products





-- 3. ANALYTIC NUMBERING FUNCTIONS --


--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()



--1. Herbir kategori içinde bisikletlerin fiyat sýralamasýný yapýnýz (artan fiyata göre 1'den baþlayýp birer birer artacak)


SELECT	category_id, list_price, 
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM
FROM	production.products



--2. Ayný soruyu ayný fiyatlý bisikletler ayný sýra numarasýný alacak þekilde yapýnýz (RANK fonksiyonunu kullanýnýz)


SELECT	category_id, list_price, 
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM
FROM	production.products


--3. Ayný soruyu ayný fiyatlý bisikletler ayný sýra numarasýný alacak þekilde yapýnýz (DENSE_RANK fonksiyonunu kullanýnýz)

SELECT	category_id, list_price, 
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM
FROM	production.products



--4. Herbir kategori içinde bisikletierin fiyatlarýna göre bulunduklarý yüzdelik dilimleri yazdýrýnýz. (CUME_DIST fonksiyonunu kullanýnýz)

--5. Herbir kategori içinde bisikletierin fiyatlarýna göre bulunduklarý yüzdelik dilimleri yazdýrýnýz. (PERCENT_RANK fonksiyonunu kullanýnýz)

SELECT	category_id, list_price, 
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK
FROM	production.products


--6. Herbir kategorideki bisikletleri artan fiyata göre 4 gruba ayýrýn. Mümkünse her grupta ayný sayýda bisiklet olacak. 
--(NTILE fonksiyonunu kullanýnýz)


SELECT	category_id, list_price, 
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK,
		NTILE(4) OVER (PARTITION BY category_id ORDER BY list_price) ntil
FROM	production.products


---

--maðazalarýn 2016 yýlýna ait haftalýk hareketli sipariþ sayýlarýný hesaplayýnýz






--'2016-03-12' ve '2016-04-12' arasýnda satýlan ürün sayýsýnýn 7 günlük hareketli ortalamasýný hesaplayýn.


------------------------------------------------------------------
--------------------------------------------------------------------
------------------------------------------------------------------











SELECT order_id, order_date, customer_name, city, order_amount
,SUM(order_amount) OVER(PARTITION BY ....ORDER BY .... WINDOW FRAME) as grand_total 
-- topla şehirlere göre grupla
FROM [dbo].[Orde]

select *
from orde
------SUM İLE
TOPLA()

SUM() toplama işlevini hepimiz biliyoruz. Belirtilen grup (şehir, eyalet, 
ülke vb. gibi) veya grup belirtilmemişse tüm tablo için belirtilen alanın
toplamını yapar. Normal SUM() toplama işlevinin ve pencere SUM() toplama 
işlevinin çıktısının ne olacağını göreceğiz.

Aşağıdaki, normal bir SUM() toplama işlevi örneğidir. Her şehir için sipariş
tutarını toplar.

Sonuç kümesinden, normal bir toplama işlevinin birden çok satırı tek bir 
çıktı satırında gruplandırdığını ve bu da tek tek satırların kimliklerini 
kaybetmesine neden olduğunu görebilirsiniz.

SELECT city, sum(order_amount) as total_prd_amount
from orde
group by city

-------WİNDOW İLE
Bu, pencere toplama işlevlerinde gerçekleşmez. Satırlar kimliklerini korur 
ve ayrıca her satır için toplu bir değer gösterir. Aşağıdaki örnekte sorgu 
aynı şeyi yapıyor, yani her şehir için verileri topluyor ve her biri için 
toplam sipariş tutarının toplamını gösteriyor. Ancak, sorgu artık toplam 
sipariş miktarı için başka bir sütun ekler, böylece her satır kendi kimliğini
korur. Grand_total olarak işaretlenen sütun, aşağıdaki örnekteki yeni 
sütundur.

SELECT order_id, order_date, customer_name, city, order_amount
,SUM(order_amount) OVER(PARTITION BY city) as grand_total -- topla şehirlere göre grupla
FROM [dbo].[Orde]

---AVG----

AVG veya Ortalama, bir Pencere işleviyle tam olarak aynı şekilde çalışır.
Aşağıdaki sorgu size her bir şehir ve her ay için ortalama sipariş miktarını 
verecektir 
(her ne kadar basit olması için verileri yalnızca bir ayda kullandık).
Bölüm listesinde birden fazla alan belirterek birden fazla ortalama 
belirtiyoruz.
Ayrıca aşağıdaki sorguda gösterildiği gibi MONTH(order_date) gibi listelerdeki
ifadeleri de kullanabileceğinizi belirtmekte fayda var. 
 
SELECT order_id, order_date, customer_name, city, order_amount
 ,AVG(order_amount) OVER(PARTITION BY city, MONTH(order_date)) as   average_order_amount 
FROM [dbo].[Orde]


---MIN()---------------
MIN toplama işlevi, belirtilen bir grup veya grup belirtilmemişse tüm tablo için minimum 
değeri bulur.
Örneğin, aşağıdaki sorguyu kullanacağımız her şehir için en küçük siparişi (minimum sipariş)
arıyoruz.

SELECT order_id, order_date, customer_name, city, order_amount
 ,MIN(order_amount) OVER(PARTITION BY city) as minimum_order_amount 
FROM [dbo].[Orde]
------------------------------------
MAX()her şehir için en büyük siparişi (maksimum sipariş miktarını) bulalım.


SELECT order_id, order_date, customer_name, city, order_amount
 ,MAX(order_amount) OVER(PARTITION BY city) as maximum_order_amount 
FROM [dbo].[Orde] 
-------------------------
---COUNT ()--------------
COUNT() işlevi kayıtları/satırları sayar.

DISTINCT öğesinin COUNT() işleviyle desteklenmediğini, ancak normal COUNT() işlevi için 
desteklendiğini unutmayın. DISTINCT, belirtilen bir alanın farklı değerlerini bulmanıza yardımcı 
olur.

Örneğin Nisan 2017 de kaç müşterinin sipariş verdiğini görmek istiyorsak, tüm müşterileri 
doğrudan sayamayız. Aynı müşterinin aynı ayda birden fazla sipariş vermesi mümkündür.

COUNT(customer_name) kopyaları sayacağı için size yanlış bir sonuç verecektir. 
Oysa COUNT(DISTINCT müşteri_adı) her benzersiz müşteriyi yalnızca bir kez saydığı için size 
doğru sonucu verecektir.

Normal COUNT() işlevi için geçerlidir:
---------
SELECT city,COUNT(DISTINCT customer_name) number_of_customers
FROM [dbo].[Orde] 
GROUP BY city
--------------
--yanlış----
SELECT order_id, order_date, customer_name, city, order_amount
 ,COUNT(DISTINCT customer_name) OVER(PARTITION BY city) as number_of_customers
FROM [dbo].[Orde] 
------doğru---------
SELECT order_id, order_date, customer_name, city, order_amount
 ,COUNT(order_id) OVER(PARTITION BY city) as total_orders
FROM [dbo].[Orde]
 
 --------
Sıralama Penceresi İşlevleri
Pencere toplama işlevlerinin belirli bir alanın değerini toplaması gibi, RANKING işlevleri de 
belirtilen bir alanın değerlerini sıralayacak ve sıralamalarına göre kategorilere ayıracaktır.

SIRALAMA işlevlerinin en yaygın kullanımı, belirli bir değere göre en üstteki (N) kayıtları 
bulmaktır. Örneğin, En yüksek ücretli 10 çalışan, İlk 10 sıradaki öğrenci, En büyük 50 sipariş vb.

Aşağıdakiler desteklenen "SIRALAMA" işlevleridir:

RANK(), DENSE_RANK(), ROW_NUMBER(), NTILE(),CUSE_DIST,PERCENT_RANK


RANK() işlevi, örneğin maaş, sipariş tutarı vb. gibi belirli bir değere dayalı olarak her 
kayda benzersiz bir sıralama vermek için kullanılır.

İki kayıt aynı değere sahipse, RANK() işlevi bir sonraki sırayı atlayarak her iki kayda da 
aynı sırayı atayacaktır. Bunun anlamı – eğer 2. seviyede iki özdeş değer varsa, her iki kayda 
da aynı 2. dereceyi atayacak ve sonra 3. sırayı atlayacak ve 4. sırayı bir sonraki kayda 
atayacaktır.

1-2-3-3-5 oldu
SELECT order_date,order_id,customer_name,city,
rank() over(order by order_amount desc) as rank
from orde

SELECT order_id,order_date,customer_name,city, 
RANK() OVER(ORDER BY order_amount DESC) [Rank]
FROM [dbo].[Orde]
 
 ----
DENSE_RANK() işlevi, herhangi bir sıra atlamaması dışında RANK() işleviyle aynıdır. 
Bunun anlamı, iki özdeş kayıt bulunursa, DENSE_RANK() her iki kayda aynı sırayı atayacaktır, 
ancak atlamadan sonraki sırayı atlamayacaktır.

1-2-3-3-4 oldu
SELECT order_id,order_date,customer_name,city, order_amount,
DENSE_RANK() OVER(ORDER BY order_amount DESC) [Rank]
FROM [dbo].[Orde]
 -----
--PARTITION BY olmadan ROW_ NUMBER()

SELECT order_id,order_date,customer_name,city, order_amount,
ROW_NUMBER() OVER(ORDER BY order_id) [row_number]
FROM [dbo].[Orde]

--PARTITION BY ile ROW_NUMBER()
 
SELECT order_id,order_date,customer_name,city, order_amount,
ROW_NUMBER() OVER(PARTITION BY city ORDER BY order_amount DESC) [row_number]
FROM [dbo].[Orde]
--Bölmeyi şehir üzerinde yaptığımızı unutmayın. Bu, her şehir için sıra numarasının sıfırlandığı 
--ve böylece tekrar 1 den yeniden başladığı anlamına gelir. Ancak, sıraların sırası sipariş miktarına
--göre belirlenir, böylece herhangi bir şehir için en büyük sipariş tutarı ilk satır olur ve böylece
--satır numarası 1 olarak atanır.
---------
NTILE() çok yararlı bir pencere işlevidir. Belirli bir satırın hangi yüzdelik dilime 
(veya çeyreğe veya başka bir alt bölüme) düştüğünü belirlemenize yardımcı olur.

Bu, 100 satırınız varsa ve belirli bir değer alanına göre 4 çeyrek oluşturmak istiyorsanız, 
bunu kolayca yapabilir ve her bir çeyreğe kaç satır düştüğünü görebilirsiniz.

Bir örnek görelim. Aşağıdaki sorguda sipariş miktarına göre dört çeyrek oluşturmak istediğimizi 
belirtmiştik. Ardından, her bir çeyreğe kaç siparişin düştüğünü görmek isteriz.
 
SELECT order_id,order_date,customer_name,city, order_amount,
NTILE(4) OVER(ORDER BY order_amount) [row_number]
FROM [dbo].[Orde]
---
--Value window functions are used to find first, last, previous and next values. 
The functions that can be used are LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()

LAG() and LEAD()


Bu aşağıdaki bir giriş makalesi olduğundan, bunların nasıl kullanılacağını göstermek için 
çok basit bir örneğe bakıyoruz.

LAG işlevi, herhangi bir SQL birleşimi kullanmadan aynı sonuç kümesindeki önceki satırdaki 
verilere erişmeyi sağlar. Aşağıdaki örnekte, önceki sipariş tarihini bulduğumuz LAG fonksiyonunu
kullanarak görebilirsiniz.

LAG() işlevini kullanarak önceki sipariş tarihini bulmak için komut dosyası:
 
SELECT order_id,customer_name,city, order_amount,order_date,
 --in below line, 1 indicates check for previous row of the current row
 LAG(order_date,3) OVER(ORDER BY order_date) prev_order_date
FROM [dbo].[Orde]
-----
LEAD işlevi, herhangi bir SQL birleştirmesi kullanmadan aynı sonuç kümesindeki bir sonraki 
satırdaki verilere erişmeyi sağlar. Aşağıdaki örnekte görebilirsiniz, leadfonksiyonunu 
kullanarak sonraki sipariş tarihini bulduk.

LEAD() işlevini kullanarak bir sonraki sipariş tarihini bulmak için komut dosyası:

SELECT order_id,customer_name,city, order_amount,order_date,
 --in below line, 1 indicates check for next row of the current row
 LEAD(order_date,1) OVER(ORDER BY order_date) next_order_date
FROM [dbo].[Orde]

--FIRST_VALUE() ve LAST_VALUE()

Bu işlevler, PARTITION BY belirtilmemişse, bir bölüm veya tüm tablo içindeki ilk ve son kaydı 
belirlemenize yardımcı olur .

Mevcut veri kümemizden her şehrin ilk ve son sırasını bulalım. Not ORDER BY yan tümcesi FIRST_VALUE
() ve LAST_VALUE() işlevleri için zorunludur

 
SELECT order_id,order_date,customer_name,city, order_amount,
FIRST_VALUE(order_date) OVER(PARTITION BY city ORDER BY city) first_order_date,
LAST_VALUE(order_date) OVER(PARTITION BY city ORDER BY city) last_order_date
FROM [dbo].[Orde]
























