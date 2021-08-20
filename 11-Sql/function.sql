-------------------STORED PROCEDURE--------------
---librry_1 altýnda programmingde 
CREATE PROC sp_sampleproc_1
AS                   -- baþlamasý bu þekilde
BEGIN
	SELECT 'HELLO WORLD'

	END;
------çalýþtýrma-------------
EXECUTE sp_sampleproc_1

EXEC sp_sampleproc_1
----------------------------------
--deðiþtireceðim
ALTER PROC sp_sampleproc_1
AS                   -- baþlamasý bu þekilde
BEGIN
	SELECT 'QUEY COMPLEED' RESULT

	END;              -- bitiþi bu þekilde
--çalýþtýrma 
EXEC sp_sampleproc_1
-------------/////////////////--------------------------
--Tablo oluþurduk..
CREATE TABLE ORDER_TBL
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date   tahmini teslimat zamaný
);
INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 )
-------verileri içine koyduk
select* from order_tbl

-------------------
CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);
SET NOCOUNT ON
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
						(2, GETDATE()-2 ),
						(3, GETDATE()-2 ),
						(4, GETDATE() ),
						(5, GETDATE()+2 ),
						(6, GETDATE()+3 ),
						(7, GETDATE()+5 ),
						(8, GETDATE()+5 )


select* from ORDER_DELIVERY
------------------
create proc sp_sumorder  -- 8 di  sonuç prosedür oluþtu
as
begin
	select count(ORDER_ID) from order_tbl
end;
--execute etme
sp_sumorder  -- güncellendikçe bu da deðiþecek
----------------------
create proc sp_wanted_dayorder (@DAY  DATE)
as
begin

	select count(ORDER_ID) 
	from order_tbl
	where ORDER_DATE = @DAY    --@ parametre demek

end;  -- hangi tarihi istersem onun güncel tarihini getir örnek

select * from order_tbl

exec sp_wanted_dayorder '2021-08-14'
------------------------------------------- --
DECLARE @P1 INT , @P2 INT , @SUM INT -- int olsun dedik
SET @P1 = 5				-- SET  bu þekilde de olur
SELECT @P2 = 4			-- SELECT bu þekilde de olur
SELECT @SUM = @P1+@P2
SELECT @SUM   -- çaðýrmak istediðimiz parametreyi bu þekilde çaðýrdýk
-- DEÐER ATAMAK ÝÇÝN SET VEYA SELECT,
-- PARAMETREYÝ ÇAÐIRMAK ÝÇÝN SELECT

-----------------------------------------------
declare @CUST_ID int

select @CUST_ID = 5

SELECT *
FROM order_tbl
where customer_id =@CUST_ID
------parametreli sorguydu yukarý
------------///////////////////////////////////--------------
--3 ten küçükse
--3 e eþitse
--3 ten büyükse

DECLARE @CUST_ID INT  --declare ettik

SET @CUST_ID = 3     -- setle atadýk

IF @CUST_ID < 3      --koþullu þart saðladýk
BEGIN
	SELECT *
	FROM ORDER_TBL
	WHERE	CUSTOMER_ID= @CUST_ID
END
ELSE IF @CUST_ID > 3
BEGIN
	SELECT *
	FROM ORDER_TBL
	WHERE	CUSTOMER_ID= @CUST_ID	
END
ELSE
	PRINT 'CUSTOMER ID EQUAL TO 3'

	------//////////------
-- WHILE  python gibi

DECLARE @NUM_OF_ITER INT = 50, @NCOUNTER INT = 0

WHILE @NUM_OF_ITER >  @NCOUNTER  -- counter 50 den küçükse çalýþtýr
BEGIN

	SELECT @NCOUNTER 
	SET @NCOUNTER += 1  -- countera bir ekle her defasýnda @NCOUNTER = @NCOUNTER+1

END

--
-- BELÝRTÝLEN ÞART SAÐLANDIÐI SÜRECE ÝÞLEME DEVAM EDER.
-- DÝKKAT EDÝLMESÝ GEREKEN NOKTA: (ÝÇÝNDE PARAMETRE VAR ÝSE) BELÝRTTÝÐÝNÝZ PARAMETRENÝN BÝTECEÐÝ YERÝ SÖYLEMENÝZ GEREKÝYOR
	-- YOKSA SONSUZ DÖNGÜYE GÝRECEKTÝR.
DECLARE @NUM_OF_ITER INT = 50, @COUNTER INT = 0
WHILE @NUM_OF_ITER > @COUNTER --COUNTER 50'YE GELENE KADAR BEGIN-END KODUNU ÇALIÞTIRACAK.
BEGIN  -- WHILE ÝLE DE BEGIN KULLANIYORUM.
	SELECT @COUNTER
	SET @COUNTER += 1 --- DÖNGÜYÜ BU ÞEKÝLDE KONTROL EDÝYORUM. ÝTERASYONU SAÐLAYAN SATIR BU SATIR.
END

------------///////////////////////////////////------------------------
---FUNCTÝON
--sclaer value function----------

CREATE FUNCTION fn_uppertext
 (
	@inputtext varchar(max)
 )
 RETURNS VARCHAR(MAX)
 AS
 BEGIN
		return upper(@inputtext)
 END
---------------
 SELECT dbo.fn_uppertext('whatsapp')  --büyüttük
---------------
 SELECT dbo.fn_uppertext(Customer_name)  --tablo deðerlerini uyguladýk
 from ORDER_TBL
 -------------

 ------------///////////////////////////////////------------------------
---FUNCTÝON
--table valued function----------
--begin end kalýbý yoookkkkk----

CREATE FUNCTION fn_order_detail(@DATE DATE)
RETURNS TABLE  -- tablo döndüreceksin...
AS
	 RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE= @DATE
--çaðýralým
SELECT *
FROM fn_order_detail('2021-08-17')  --fromda çaðýrýlacak
------

------------DDL TRÝGGERS  AND DML TRÝGGERS---------------
