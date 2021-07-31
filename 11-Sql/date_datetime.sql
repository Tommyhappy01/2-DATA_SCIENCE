---DATE AND TÝME FUNCTÝONS---

Time Strings
YYYY-MM-DD
YYYY-MM-DD HH:MM
YYYY-MM-DD HH:MM:SS
YYYY-MM-DD HH:MM:SS.SSS
YYYY-MM-DDTHH:MM
YYYY-MM-DDTHH:MM:SS
YYYY-MM-DDTHH:MM:SS.SSS
HH:MM
HH:MM:SS
HH:MM:SS.SSS
now
DDDDDDDDDD


SELECT date('now')

SELECT datetime('now','localtime')

select julianday('1982-03-27') - julianday('now')as date_time
-------
--julianday()
--datetime()
--current_timestamp() This is a SQL Server date&time function.  
	--It returns a datetime value containing the date and time of the
	--computer on which the instance of SQL Server runs. 
--date()
--time()
---------------------
SELECT DATE('now','start of month','+1 month','-1 day') AS last_day;


SELECT DATE('2020-05-02','-1 month');

SELECT DATE('2020-05-02','-1 day');

SELECT DATE('2020-05-02','-1 year');

SELECT TIME() AS current_time;

SELECT TIME('2020-05-01 12:20:45.005432') AS extracted_time;


SELECT TIME('now') AS current_time,
TIME('now', '+30 minutes') AS after_thirty_minutes

SELECT DATETIME('now') AS current_date_time;

SELECT DATETIME('now') AS current_date_time,
DATETIME('now', '+800 minutes') AS date_time;


SELECT JULIANDAY('2020-05-01') as julian_day;

SELECT TIME('now') AS current_time;

SELECT JULIANDAY('1939-09-01') - JULIANDAY('1918-10-11') AS elapsed_days;
----------------------------

STRFTIME(format, timestring, modifier, modifier, ...)

%d	 day of month: 00
%f	 fractional seconds: SS.SSS
%H	 hour: 00-24
 %j	 day of year: 001-366
 %J	 Julian day number
 %m	 month: 01-12
 %M	 minute: 00-59
 %s	 seconds since 1970-01-01
 %S	 seconds: 00-59
 %w	 day of week 0-6 with Sunday==0
 %W	 week of year: 00-53
 %Y	 year: 0000-9999
 %%	 %
 -----------------------------------
 SELECT STRFTIME('%Y %m %d', 'now');

 SELECT STRFTIME('%d/%m/%Y', 'now');

 SELECT STRFTIME('%H %M %S %s','now') AS time_format;

 SELECT STRFTIME('%s','now') - STRFTIME('%s','2019-10-07 02:34:56');

 SELECT hire_date,
       STRFTIME('%Y', hire_date) AS year,
       STRFTIME('%m', hire_date) AS month,
       STRFTIME('%d', hire_date) AS day
FROM employees

--------------------------------------------------
datefromparts(year, month, day) bu þekliyle ekler

datetimefromparts(year, month, day,hour,minute,seconds,milliseconds) 

datetimeoffsetfromparts(year, month, day) eksik kaldý

timefromparts(year, month, day) bu þekliyle ekler

---------------------------------

CREATE TABLE t_date_time (
	A_time time, --saat dakika saniye 7 dijit sadise
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)
---------------------	
SELECT *
FROM t_date_time
---------------------
--https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/
---------------------
insert into t_date_time(A_time,	A_date,	A_smalldatetime, A_datetime,A_datetime2,
	A_datetimeoffset)
	VALUES
	('12:00:00','2021-07-17','2021-07-17','2021-07-17','2021-07-17','2021-07-17')

SELECT *
FROM t_date_time
-------------------

datename   datename(datepart,date)  nvarchar
datepart   datepart(datepart.date)  int
day           day(date)				int
month         month(date)			int
year          year (date)	     	int


-----------------
insert dbo.t_date_time (A_time)
values (timefromparts(12,00,00,0,0))

SELECT *
FROM t_date_time
----------

insert dbo.t_date_time (A_date)
values (datefromparts(2021,05,17)) -- yýl-ay-gün yaptý

-----------
select convert(varchar,getdate(),6) --format deðiþikliði

-------------

insert dbo.t_date_time (A_datetime)
values (datetimefromparts(2021,05,17,20,0,0,0)) -- yýl-ay-gün yaptý saatid girdi

SELECT *
FROM t_date_time
--------------
insert dbo.t_date_time (A_datetimeoffset)
values (datetimeoffsetfromparts(2021,05,17,20,0,0,0, 2,0,0)) -- yýl-ay-gün yaptý saat saniye sadise  girdi

SELECT *
FROM t_date_time

----------------------------

SELECT A_time,
		datename(D,A_date) AS DAY  -- 2 argüman alýr ne istersin, nerden istersein
FROM t_date_time


SELECT A_date,
		datename(D,A_date) AS DAY  -- 2 argüman alýr ne istersin, nerden istersein
FROM t_date_time


SELECT A_date,
		datename(DW,A_date) AS DAY  -- 2 argüman alýr ne istersin, nerden istersin DW hafta günü
FROM t_date_time

SELECT A_date,
		datename(DW,A_date) AS DAY,  -- 2 argüman alýr ne istersin, nerden istersin DW hafta günü
		DAY (A_date) [day2],
		MONTH (A_date),
		YEAR (A_date),
		A_time,
		DATEPART (NANOSECOND,A_time)
	
FROM t_date_time

--------------------------------------
datedýff(datepart.atsrtdate,enddate)     int

---------------query time--------------

SELECT A_date,A_datetime,
  datediff (DAY,A_date,A_datetime) as dýff
FROM t_date_time

------------
SElect datediff (day,order_date,shipped_date),order_date,shipped_date  --büyük tarih sonra
from sales.orders
where order_id=1
--------------------
SElect datediff (day,order_date,shipped_date),order_date,shipped_date,datediff (day,shipped_date,order_date)  --büyük tarih sonra
from sales.orders
where order_id=1       -- tersinde -2 gün fark geldi


--------------------------
dateadd(datepart,number,date)

eomonth(start_date[,month_to_add])  -- ayýn en son günü gelir date olarak
                   --^^^^^^ temmuzdan 2 ay sonraki ayýn son günü
^--------------------------
SELECT dateadd(D,5,order_date)  --gün ekle,,, 5 tane ekle,,, þuna ekle
FROM sales.orders
where order_id=1
-----------------------------
SELECT dateadd(YEAR,5,order_date)  -yýl ekle,,, 5 tane ekle,,, þuna ekle
FROM sales.orders
where order_id=1
------------------------------

SELECT dateadd(YEAR,5,order_date) as year_eklendi, --yýl ekle,,, 5 tane ekle,,, þuna ekle
        dateadd(day,-5,order_date) as gün_çýktý  --gün çýkar,, 5 tane ekle,,, þuna ekle
FROM sales.orders
where order_id=1
----------------------------
SELECT eomonth(order_date) as ay_son_günü,order_date  --oerder date ayýn en son buymuþ
FROM sales.orders
-----------------------
SELECT eomonth(order_date),order_date
FROM sales.orders
where order_id=1
--------------------------
isdate        isdate(expression)        int(boolen)
---------------------------
SELECT isdate(cast(order_date as nvarchar)),order_date
FROM sales.orders    --isdate  date olup olmadýðýný denetler
where order_id=1

select isdate('where')  -- tarih   mi?

select isdate('2021')  -- tarih   mi?

select isdate('2021215484151') -- tarih   mi?
------------------------------------------------------
current_timestamp  datetime

getdate            datetime

getutcdate         datetime
--------------------------------------------------------
select isdate('2021-12-02') -- tarih   mi? evet

select isdate('2021.12.02') -- tarih   mi? evet
--------------------------------------------------------

select getdate()  --server tarih saat nano seviyede dönderdi ÖNEMLÝ kullanýlýr

select current_timestamp ---server tarih saat nano seviyede dönderdi ÖNEMLÝ kullanýlýr

select getutcdate()
----------------------üstteki 3 sorgu da aynýdýr--------------------------------

--------------------------------------------
select*
from t_date_time

insert t_date_time
values (getdate(),getdate(),getdate(),getdate(),getdate(),getdate())
-- bu örnek incelendiðinde tabloda görünür net olarak

GETDATE aklimiza gelmezse ne yapiyoruz? Google’a  “SQL SERVER TODAY” yaziyoruz :smile:
--------------------------------------------
Question: Create a new column that contains labels of the shipping speed of products.
If the product has not been shipped yet, it will be marked as "Not Shipped",
If the product was shipped on the day of order, it will be labeled as "Fast".
If the product is shipped no later than two days after the order day, it will be labeled as "Normal"
If the product was shipped three or more days after the day of order, it will be labeled as "Slow"


Soruyu tekrar ifade edeyim: sipariþlerin hýzlarýný etiketlemek istiyoruz. 
orders tablosuna yeni bir sütun oluþturup bu etiketleri orada belirteceðiz.

select *,
      case   -- yeni sütün açtýk or... 4 e eþit  olmadýðýnda  no.. yaz
	   when order_status <> 4 then 'NOT SHÝPPED'
	   when order_date=shipped_date then 'FAST' --datediff(day,order_date,shipped_date)=0 then 'fast'
	   when datediff (day,order_date,shipped_date) between 1 and 2 then 'NORMAL'
	   else 'SLOW'
	  end as order_label,
	  datediff (day,order_date,shipped_date) datedif
from sales.orders
order by datedif
-----
select *,
case 
		when order_status  =  4 then 'not shipped'
		when order_status  in (1,2,3) then 'shipped' end as 'Cargo Status'
from sales.orders
-----
select order_date, shipped_date,
	case 
	when shipped_date is null then 'Not Shipped'
	when order_date=shipped_date then 'Fast'
	when datediff(day, order_date, shipped_date)<=2 then 'Normal'
	when datediff(day, order_date, shipped_date )>=3 then 'Slow'
	end as speed
from sales.orders
-----
select order_date, shipped_date,
case
when order_status <> 4 then 'Not Shipped'
when DATEDIFF(day, order_date, shipped_date) = 0 then 'Fast'
when DATEDIFF(day, order_date, shipped_date) <= 2 then 'Normal'
when DATEDIFF(day, order_date, shipped_date) >= 3 then 'Slow' 
end as Status
from sales.orders
------------------------query time

select *,datediff(day,order_date,shipped_date) as date_diff
from sales.orders
where datediff(day,order_date,shipped_date) > 2
-----
--Write a query that returns the number distributions of the orders in the previous query result, 
--according to the days of the week.
select 
sum(case when datename(dw,order_date) = 'Monday' then 1 else 0 end) as monday,  --burda bitti
sum(case when datename(dw,order_date) = 'Tuesday' then 1 else 0 end) as Tuesday,
sum(case when datename(dw,order_date) = 'Wednesday' then 1 else 0 end) as Wednesday,
sum(case when datename(dw,order_date) = 'Thursday' then 1 else 0 end) as Thursday,
sum(case when datename(dw,order_date) = 'Friday' then 1 else 0 end) as Friday,
sum(case when datename(dw,order_date) = 'Saturday' then 1 else 0 end) as Saturday,
sum(case when datename(dw,order_date) = 'Sunday' then 1 else 0 end) as Sunday
from sales.orders
where datediff(day,order_date,shipped_date) > 2
-- tek tek sorguladýk order_date hafta gününü aldýk saydýk topladýk 
---
SELECT DATENAME(DW,A.order_date),COUNT(*)
FROM
(SELECT order_date,shipped_date,DATEDIFF(DAY,order_date,shipped_date) AS DATE_DIFF
FROM sales.orders
WHERE DATEDIFF(DAY,order_date,shipped_date)>2) A
GROUP BY DATENAME(DW,A.order_date)
-------------------------------------------------
--Write a query that returns the order numbers of the states by months.

select A.state,year(B.order_date) years ,month(B.order_date) months, count(distinct order_id) num_of_orders
from sales.customers as A, sales.orders as B
where  A.customer_id=B.customer_id 
group by A.state, year(B.order_date),MONTH(B.order_date)
order by state,years,months

----------bravo....tommy












-- List customers who bought both 'Electric Bikes' and 'Comfort Bicycles' and 'Children Bicycles' in the same order.

SELECT *
FROM production.categories
WHERE category_name='Electric Bikes'
-----
SELECT	A.customer_id, A.first_name, A.last_name
FROM	sales.customers A, sales.orders B
WHERE	A.customer_id = B.customer_id
AND		B.order_id IN (
					SELECT	B.order_id
					FROM	production.products A, sales.order_items B
					WHERE	A.product_id = B.product_id
					AND		A.category_id = (
												SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Electric Bikes'
											)
					INTERSECT
					SELECT	B.order_id
					FROM	production.products A, sales.order_items B
					WHERE	A.product_id = B.product_id
					AND		A.category_id = (
												SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Comfort Bicycles'
											)
					INTERSECT
					SELECT	B.order_id
					FROM	production.products A, sales.order_items B
					WHERE	A.product_id = B.product_id
					AND		A.category_id = (
												SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Children Bicycles'
											)
					)
---------------