select *
from orde
------SUM ÝLE
TOPLA()

SUM() toplama iþlevini hepimiz biliyoruz. Belirtilen grup (þehir, eyalet, 
ülke vb. gibi) veya grup belirtilmemiþse tüm tablo için belirtilen alanýn
toplamýný yapar. Normal SUM() toplama iþlevinin ve pencere SUM() toplama 
iþlevinin çýktýsýnýn ne olacaðýný göreceðiz.

Aþaðýdaki, normal bir SUM() toplama iþlevi örneðidir. Her þehir için sipariþ
tutarýný toplar.

Sonuç kümesinden, normal bir toplama iþlevinin birden çok satýrý tek bir 
çýktý satýrýnda gruplandýrdýðýný ve bu da tek tek satýrlarýn kimliklerini 
kaybetmesine neden olduðunu görebilirsiniz.

SELECT city, sum(order_amount) as total_prd_amount
from orde
group by city

-------WÝNDOW ÝLE
Bu, pencere toplama iþlevlerinde gerçekleþmez. Satýrlar kimliklerini korur 
ve ayrýca her satýr için toplu bir deðer gösterir. Aþaðýdaki örnekte sorgu 
ayný þeyi yapýyor, yani her þehir için verileri topluyor ve her biri için 
toplam sipariþ tutarýnýn toplamýný gösteriyor. Ancak, sorgu artýk toplam 
sipariþ miktarý için baþka bir sütun ekler, böylece her satýr kendi kimliðini
korur. Grand_total olarak iþaretlenen sütun, aþaðýdaki örnekteki yeni 
sütundur.

SELECT order_id, order_date, customer_name, city, order_amount
,SUM(order_amount) 
OVER(PARTITION BY city) as grand_total -- topla þehirlere göre grupla
FROM [dbo].[Orde]

---AVG----

AVG veya Ortalama, bir Pencere iþleviyle tam olarak ayný þekilde çalýþýr.
Aþaðýdaki sorgu size her bir þehir ve her ay için ortalama sipariþ miktarýný 
verecektir 
(her ne kadar basit olmasý için verileri yalnýzca bir ayda kullandýk).
Bölüm listesinde birden fazla alan belirterek birden fazla ortalama 
belirtiyoruz.
Ayrýca aþaðýdaki sorguda gösterildiði gibi MONTH(order_date) gibi listelerdeki
ifadeleri de kullanabileceðinizi belirtmekte fayda var. 
 
SELECT order_id, order_date, customer_name, city, order_amount
 ,AVG(order_amount) OVER(PARTITION BY city, MONTH(order_date)) as   average_order_amount 
FROM [dbo].[Orde]


---MIN()---------------
MIN toplama iþlevi, belirtilen bir grup veya grup belirtilmemiþse tüm tablo için minimum 
deðeri bulur.
Örneðin, aþaðýdaki sorguyu kullanacaðýmýz her þehir için en küçük sipariþi (minimum sipariþ)
arýyoruz.

SELECT order_id, order_date, customer_name, city, order_amount
 ,MIN(order_amount) OVER(PARTITION BY city) as minimum_order_amount 
FROM [dbo].[Orde]
------------------------------------
MAX()her þehir için en büyük sipariþi (maksimum sipariþ miktarýný) bulalým.


SELECT order_id, order_date, customer_name, city, order_amount
 ,MAX(order_amount) OVER(PARTITION BY city) as maximum_order_amount 
FROM [dbo].[Orde] 
-------------------------
---COUNT ()--------------
COUNT() iþlevi kayýtlarý/satýrlarý sayar.

DISTINCT öðesinin COUNT() iþleviyle desteklenmediðini, ancak normal COUNT() iþlevi için 
desteklendiðini unutmayýn. DISTINCT, belirtilen bir alanýn farklý deðerlerini bulmanýza yardýmcý 
olur.

Örneðin Nisan 2017 de kaç müþterinin sipariþ verdiðini görmek istiyorsak, tüm müþterileri 
doðrudan sayamayýz. Ayný müþterinin ayný ayda birden fazla sipariþ vermesi mümkündür.

COUNT(customer_name) kopyalarý sayacaðý için size yanlýþ bir sonuç verecektir. 
Oysa COUNT(DISTINCT müþteri_adý) her benzersiz müþteriyi yalnýzca bir kez saydýðý için size 
doðru sonucu verecektir.

Normal COUNT() iþlevi için geçerlidir:
---------
SELECT city,COUNT(DISTINCT customer_name) number_of_customers
FROM [dbo].[Orde] 
GROUP BY city
--------------
--yanlýþ----
SELECT order_id, order_date, customer_name, city, order_amount
 ,COUNT(DISTINCT customer_name) OVER(PARTITION BY city) as number_of_customers
FROM [dbo].[Orde] 
------doðru---------
SELECT order_id, order_date, customer_name, city, order_amount
 ,COUNT(order_id) OVER(PARTITION BY city) as total_orders
FROM [dbo].[Orde]
 
 --------
Sýralama Penceresi Ýþlevleri
Pencere toplama iþlevlerinin belirli bir alanýn deðerini toplamasý gibi, RANKING iþlevleri de 
belirtilen bir alanýn deðerlerini sýralayacak ve sýralamalarýna göre kategorilere ayýracaktýr.

SIRALAMA iþlevlerinin en yaygýn kullanýmý, belirli bir deðere göre en üstteki (N) kayýtlarý 
bulmaktýr. Örneðin, En yüksek ücretli 10 çalýþan, Ýlk 10 sýradaki öðrenci, En büyük 50 sipariþ vb.

Aþaðýdakiler desteklenen SIRALAMA iþlevleridir:

RANK(), DENSE_RANK(), ROW_NUMBER(), NTILE()


RANK() iþlevi, örneðin maaþ, sipariþ tutarý vb. gibi belirli bir deðere dayalý olarak her 
kayda benzersiz bir sýralama vermek için kullanýlýr.

Ýki kayýt ayný deðere sahipse, RANK() iþlevi bir sonraki sýrayý atlayarak her iki kayda da 
ayný sýrayý atayacaktýr. Bunun anlamý – eðer 2. seviyede iki özdeþ deðer varsa, her iki kayda 
da ayný 2. dereceyi atayacak ve sonra 3. sýrayý atlayacak ve 4. sýrayý bir sonraki kayda 
atayacaktýr.

1-2-3-3-5 oldu
SELECT order_date,order_id,customer_name,city,
rank() over(order by order_amount desc) as rank
from orde

SELECT order_id,order_date,customer_name,city, 
RANK() OVER(ORDER BY order_amount DESC) [Rank]
FROM [dbo].[Orde]
 
 ----
DENSE_RANK() iþlevi, herhangi bir sýra atlamamasý dýþýnda RANK() iþleviyle aynýdýr. 
Bunun anlamý, iki özdeþ kayýt bulunursa, DENSE_RANK() her iki kayda ayný sýrayý atayacaktýr, 
ancak atlamadan sonraki sýrayý atlamayacaktýr.

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
--Bölmeyi þehir üzerinde yaptýðýmýzý unutmayýn. Bu, her þehir için sýra numarasýnýn sýfýrlandýðý 
--ve böylece tekrar 1 den yeniden baþladýðý anlamýna gelir. Ancak, sýralarýn sýrasý sipariþ miktarýna
--göre belirlenir, böylece herhangi bir þehir için en büyük sipariþ tutarý ilk satýr olur ve böylece
--satýr numarasý 1 olarak atanýr.
---------
NTILE() çok yararlý bir pencere iþlevidir. Belirli bir satýrýn hangi yüzdelik dilime 
(veya çeyreðe veya baþka bir alt bölüme) düþtüðünü belirlemenize yardýmcý olur.

Bu, 100 satýrýnýz varsa ve belirli bir deðer alanýna göre 4 çeyrek oluþturmak istiyorsanýz, 
bunu kolayca yapabilir ve her bir çeyreðe kaç satýr düþtüðünü görebilirsiniz.

Bir örnek görelim. Aþaðýdaki sorguda sipariþ miktarýna göre dört çeyrek oluþturmak istediðimizi 
belirtmiþtik. Ardýndan, her bir çeyreðe kaç sipariþin düþtüðünü görmek isteriz.
 
SELECT order_id,order_date,customer_name,city, order_amount,
NTILE(4) OVER(ORDER BY order_amount) [row_number]
FROM [dbo].[Orde]
---
--Value window functions are used to find first, last, previous and next values. 
The functions that can be used are LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()

LAG() and LEAD()


Bu aþaðýdaki bir giriþ makalesi olduðundan, bunlarýn nasýl kullanýlacaðýný göstermek için 
çok basit bir örneðe bakýyoruz.

LAG iþlevi, herhangi bir SQL birleþimi kullanmadan ayný sonuç kümesindeki önceki satýrdaki 
verilere eriþmeyi saðlar. Aþaðýdaki örnekte, önceki sipariþ tarihini bulduðumuz LAG fonksiyonunu
kullanarak görebilirsiniz.

LAG() iþlevini kullanarak önceki sipariþ tarihini bulmak için komut dosyasý:
 
SELECT order_id,customer_name,city, order_amount,order_date,
 --in below line, 1 indicates check for previous row of the current row
 LAG(order_date,3) OVER(ORDER BY order_date) prev_order_date
FROM [dbo].[Orde]
-----
LEAD iþlevi, herhangi bir SQL birleþtirmesi kullanmadan ayný sonuç kümesindeki bir sonraki 
satýrdaki verilere eriþmeyi saðlar. Aþaðýdaki örnekte görebilirsiniz, leadfonksiyonunu 
kullanarak sonraki sipariþ tarihini bulduk.

LEAD() iþlevini kullanarak bir sonraki sipariþ tarihini bulmak için komut dosyasý:

SELECT order_id,customer_name,city, order_amount,order_date,
 --in below line, 1 indicates check for next row of the current row
 LEAD(order_date,1) OVER(ORDER BY order_date) next_order_date
FROM [dbo].[Orde]

--FIRST_VALUE() ve LAST_VALUE()

Bu iþlevler, PARTITION BY belirtilmemiþse, bir bölüm veya tüm tablo içindeki ilk ve son kaydý 
belirlemenize yardýmcý olur .

Mevcut veri kümemizden her þehrin ilk ve son sýrasýný bulalým. Not ORDER BY yan tümcesi FIRST_VALUE
() ve LAST_VALUE() iþlevleri için zorunludur

 
SELECT order_id,order_date,customer_name,city, order_amount,
FIRST_VALUE(order_date) OVER(PARTITION BY city ORDER BY city) first_order_date,
LAST_VALUE(order_date) OVER(PARTITION BY city ORDER BY city) last_order_date
FROM [dbo].[Orde]
























