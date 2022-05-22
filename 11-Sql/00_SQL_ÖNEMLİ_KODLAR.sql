-----------SQL SERVER ÖNEMLİ KODLAR ---------------
-- kaynak:   https://www.sqlkodlari.com/31-sql-primary-key-kullanimi.asp
-- Kaynak  : https://sqlserveregitimleri.com/sql-server-primary-key-constraint-kullanimi

-- INDEX
--		1. DATABASE CREATE ETME 
--		2. TABLO CREATE ETME
--		3. INSERT INTO İLE TABLOYA VERİ GİRMEK
--		4. INSERT INTO İLE BİR TABLODAKİ VERİLERİ ALIP VAROLAN BİR TABLO İÇİNE KOPYALAMAK
--		5. PRIMARY KEY TANIMLAMAK
--		6. PRIMARY KEY ALANINI KALDIRMAK
--		7. FOREIGN KEY TANIMLAMAK
--		8. FOREIGN KEY ALANINI KALDIRMAK
--		9. ALTER TABLE
--		10.DROP
--		11.DELETE
--		12.CONVERT KULLANIMI
--		13.CREATE VIEW ...AS
--		14.CTE COMMON TABLE EXPRESSIONS 
--		15.CREATE INDEX
--		16.LIKE



-- 1. DATABASE CREATE ETME-----------------------------------------------------------------------------------
	-- Bu işlemi yapabilmek için mevcut kullanıcımızın veritabanı oluşturma yetkisine sahip olması gerekmektedir.

CREATE DATABASE veritabani_adi


-- 2. TABLO CREATE ETME---------------------------------------------------------------------------------------
	-- Bu işlemi yapabilmek için mevcut kullanıcımızın tablo oluşturma yetkisine sahip olması gerekmektedir.

CREATE TABLE tablo_adı
(
alan_adi1 veri_tipi(boyut) Constraint_Adı,
alan_adi2 veri_tipi(boyut),
alan_adi3 veri_tipi(boyut),
....
)
-- CONSTRAINT'LER:


--NOT NULL   : Alanında boş geçilemeyeceğini belirtir.
--UNIQUE     : Bu alana girilecek verilerin hiç biri birbirine benzeyemez. Yani tekrarlı kayıt içeremez.
--PRIMERY KEY: Not Null ve Unique kriterlerinin her ikisini birden uygulanmasıdır.
--FOREIGN KEY: Başka bir tablodaki kayıtlarla eşleştirmek için alandaki kayıtların tutarlılığını belirtir.
--CHECK      : Alandaki değerlerin belli bir koşulu sağlaması için kullanılır.
--DEFAULT    : Alan için herhangi bir değer girilmezse, varsıyalan olarak bir değer giremeyi sağlar.

-- örnek:
CREATE TABLE Personel
(
id int,
adi_soyadi varchar(25),
sehir varchar(15),
bolum varchar(15),
medeni_durum bolean
)


-- 3. INSERT INTO İLE TABLOYA VERİ GİRMEK-----------------------------------------------------------------------

	-- Burada dikkat edeceğimiz nokta eklenecek değer tablomuzdaki alan sırasına göre olmalıdır.
	-- Values ifadesinden yazılacak değerler sırası ile işlenir.

INSERT INTO  tablo_adi
VALUES (deger1, deger2, ...)

-- diğer yöntem:
	--Bu yöntemde ise eklenecek alanları ve değerleri kendimiz belirtiriz. 
	-- Burada dikkat edilmesi gereken şey; yazdığımız alan adının sırasına göre değerleri eklememiz olacaktır.
INSERT INTO  tablo_adi (alan_adi1, alan_adi2, alan_adi3)
VALUES (deger1, deger2, deger3)

--örnek1 (tablonun tüm sütunlarına veri girişi)
INSERT INTO Personel 
VALUES (3, 'Serkan ÖZGÜREL', 'Erzincan', 'Muhasebe', 3456789)
-- örnek2 (tablonun yalnızca 3 alanına veri girişi) 
INSERT INTO Personel (id, adi_soyadi, sehir)
VALUES (3, 'Serkan ÖZGÜREL', 'Erzincan')



-- 4. INSERT INTO İLE BİR TABLODAKİ VERİLERİ ALIP VAROLAN BİR TABLO İÇİNE KOPYALAMAK-----------------------------

	-- Hedefte belirttiğimiz tablonun var olması gerekmektedir. 
	-- Hedef tabloda var olan alanlar silinmez. Var olan alanların yanına yeni alanlar eklenir.

INSERT INTO Hedef_tablo (alan_adi1,alan_adi2...)
SELECT alan_adi1,alan_adi2...
FROM tablo1

---- 4. a. Tüm sütunları kopyalama
INSERT INTO personel_yedek
SELECT *
FROM personel

---- 4. b. Sütun isimlerini değiştirerek kopyalama
INSERT INTO personel_yedek (isim, sehir)
SELECT  ad_soyad, sehir
FROM personel

---- 4. c. Belirli kriterlere göre kopyalama 
INSERT INTO istanbul_personelleri (isim)
SELECT ad_soyad
FROM personel
WHERE sehir='istanbul'

-- 5. PRIMARY KEY TANIMLAMAK ----------------------------------------------------------------------------

----- 5. a. TABLO OLUŞTURURKEN TANIMLAMAK

---------5. a. (1) sadece bir alanda kullanım biçimine örnek
CREATE TABLE Personel
(
id int NOT NULL PRIMARY KEY,
adi_soyadi varchar(20) ,
Sehir varchar(20)
)

--------5. a. (2) birden fazla alanda kullanım biçimine örnek
CREATE TABLE Personel
(
id int NOT NULL,
adi_soyadi varchar(20) NOT NULL ,
Sehir varchar(20),
CONSTRAINT id_no PRIMARY KEY  (id,adi_soyadi)
)
-- Burada görüleceği üzere birden fazla alan PRIMARY KEY yapısı içine alınıyor. 
	-- CONSTRAINT ifadesi ile bu işleme bir tanım giriliyor. Aslında bu tanım bizim tablomuzun index alanını oluşturmaktadır. 
	-- İndexleme sayesinde tablomuzdaki verilerin bütülüğü daha sağlam olurken aramalarda da daha hızlı sonuçlar elde ederiz. 
	-- Ayrıca kullandığınz uygulama geliştirme ortamlarında (ör .Net) tablo üzerinde daha etkin kullanım imkanınız olacaktır.
	-- PRIMARY KEY ifadesinden sonra ise ilgili alanları virgül ile ayırarak yazarız.


-----5. b. PRIMARY KEY TANIMLAMAK (VAR OLAN BİR TABLOYA)

--------5. b. (1) Sadece bir alanda (sütunda) kullanım biçimine örnek:
ALTER TABLE Personel
ADD PRIMARY KEY (id)

-- VEYA:
ALTER TABLE Calisanlar
ADD CONSTRAINT PK_CalisanID PRIMARY KEY (ID); 
--Kodu çalıştırdığımız zaman Calisanlar tablomuzdaki ID alanını Primary Key olarak yapmış oluyoruz. 
	--PK_CalisanID ifadesi ise bu primary key ifadesine verdiğimiz isimdir. İstediğiniz ismi verebilirsiniz. 
	-- Ben primary key alanı belli olsun diye PK ifadesi koydum ve 
	-- sonrasında CalisanID diyerek çalışan id değeri olduğunu belirttim.


--------5. b. (2) Birden fazla alanda (sütunda) kullanım biçimine örnek:
ALTER TABLE Personel
ADD CONSTRAINT  id_no PRIMARY KEY (id,adi_soyadi)

-- Burada dikkat edilecek nokta; ALTER ile sonradan bir alana PRIMARY KEY kriteri tanımlanırken 
	-- ilgili alanda veya alanlarda NULL yani boş kayıt olmamalıdır.


-------5. b. (3) Tabloya yeni bir sütun ekleyerek PRIMARY KEY tanımlamak:
ALTER TABLE market_fact
ADD Market_ID INT PRIMARY KEY IDENTITY(1,1)


--6. PRIMARY KEY ALANINI KALDIRMAK---------------------------------------------------------------------------
ALTER TABLE Personel
DROP  CONSTRAINT id_no

--!!! Burada dikkat edilmesi gereken nokta eğer çoklu alanda PRIMARY KEY işlemi yaptıysak, 
	-- CONSTRAINT ifadesinden sonra tablomuzdaki alan adı değil, oluşturduğumuz "index adı" yazılmalıdır. 
	-- Eğer tek bir alanda oluşturduysak o zaman CONSTRAINT  ifadesinden sonra sadece alana adını yazabiliriz.


-- 7. FOREIGN KEY TANIMLAMAK---------------------------------------------------------------------------------

	--Temel olarak FOREIGN KEY yardımcı index oluşturmak için kullanılır. 
	-- Bir tabloda "id" alanına PRIMARY KEY uygulayabiliriz. Ancak aynı tablodaki başka bir alan farklı bir tablodaki kayda bağlı çalışabilir
	-- İşte bu iki tablo arasında bir bağ kurmak gerektiği durumlarda FOREIGN KEY devreye giriyor.
	-- Böylece tablolar arası veri akışı daha hızlı olduğu gibi ileride artan kayıt sayısı sonucu veri bozulmalarının önüne geçilmiş olunur.

------ 7. a. Tablo oluştururken FOREIGN KEY tanımlama:
CREATE TABLE Satislar
(
id int NOT NULL PRIMARY KEY,
Urun varchar(20) ,
Satis_fiyati varchar(20),
satan_id int CONSTRAINT fk_satici FOREIGN KEY References Personel(id)
)
-- !! FOREIGN KEY tanımlaması yapılırken hangi tablodaki hangi alanla ilişkili oldğunu 
	-- REFERENCES ifadesinden sonra yazmak gerekir!!
--  CONSTRAINT ile ona bir isim veriliyor. Böylece daha sonra bu FOREIGN KEY yapısını kaldırmak istersek 
	-- bu verdiğimiz ismi kullanmamız gerekecektir.

------ 7. b. Var olan tabloya FOREIGN KEY tanımlama:
ALTER TABLE Satislar
ADD CONSTRAIN fk_satici FOREIGN KEY (satan_id) REFERENCES Personel(id)

ALTER TABLE [dbo].[market_fact] 
ADD CONSTRAIN FK_PROPID FOREIGN KEY ([Prod_id]) REFERENCES [dbo].[prod_dimen]



--8. FOREIGN KEY ALANINI KALDIRMAK ---------------------------------------------------------------------------

ALTER TABLE Satislar
DROP  CONSTRAINT fk_satici



--9. ALTER TABLE -----------------------------------------------------------------------------------------

---- 9. a. Sütun eklemek için:
ALTER TABLE tablo_adi
ADD alan_adi veri_tipi

ALTER TABLE dbo.doc_exa 
ADD column_b VARCHAR(20) NULL, 
	column_c INT NULL ;

---- 9. b. Sütun silmek için:
ALTER TABLE tablo_adi
DROP COLUMN alan_adi

---- 9. c. Sütun tipini değiştirmek:
ALTER TABLE tablo_adi
ALTER COLUMN  alan_adi  veri_tipi



--10.  DROP -----------------------------------------------------------------------------------------------

	-- DROP yapısı ile indexler, alanlar, tablolar ve veritabanları kolaylıkla silinebilir. 
	-- DELETE yapısı ile karıştırılabilir. DELETE ile sadece tablomuzdaki kayıtları silebiliriz. 
	-- Eğer tablomuzu veya veritabanımızı silmek istiyorsak DROP yapısını kullanmamız gerekmektedir.

DROP INDEX tablo_adi.index_adi
DROP TABLE tablo_adi
DROP DATABASE veritabani_adi
ALTER TABLE dbo.doc_exb DROP COLUMN column_b;

--TRUNCATE TABLE Kullanım Biçimi
	--Eğer tablomuzu değilde sadece içindeki kayıtları silmek istiyorsak yani tablomuzun içini boşaltmak istiyorsak 
	--aşağıdaki kodu kullanabiliriz:
TRUNCATE TABLE tablo_adi
--Truncate yapısında parametre girilmez direkt olarak tüm kayıtları siler. Yeni kayıt yapılırsa numarası 1 den başlar.
-- Delete ile bütün kayıtları sildiğimiz zaman otomatik numara sırası baştan başlamaz.
	-- örneğin 150 kayıt silindiğinde ve yeni kayıt eklediğimizde bu 151 olur.



--11. DELETE -------------------------------------------------------------------------------------------

	-- Burada dikkat edilecek nokta WHERE ifadesi ile belli bir kayıt seçilip silinir. 
	-- Eğer WHERE ifadesini kullanmadan yaparsak tablodaki bütün kayıtları silmiş oluruz.

DELETE  FROM tablo_adi
WHERE secilen_alan_adi=alan_degeri

DELETE FROM Personel 
WHERE Sehir='İstanbul'
AND id = 3



--12. CONVERT KULLANIMI-----------------------------------------------------------------------------------
	--tarih alanını farklı biçimlerde ekrana yazdırmak için:

SELECT  CONVERT(hedef_veri_tipi, alan_adi, gosterim_formati)
FROM tablo_adi

-- örnek:
SELECT ad_soyad, CONVERT(VARCHAR(11), dogum_tar, 106) AS [Doğum Tarihi] 
FROM Personel

CONVERT(VARCHAR(19),GETDATE())
CONVERT(VARCHAR(10),GETDATE(),10)
CONVERT(VARCHAR(10),GETDATE(),110)
CONVERT(VARCHAR(11),GETDATE(),6)
CONVERT(VARCHAR(11),GETDATE(),106)
CONVERT(VARCHAR(24),GETDATE(),113)

Çıktısı:
Nov 04 2014 11:45 PM
11-04-14
11-04-2014
04 Nov 14
04 Nov 2014
04 Nov 2014 11:45:34:243



-- 13. CREATE VIEW ...AS ---------------------------------------------------------------------------------

---- 13. a. Yeni VIEW oluşturmak:
CREATE VIEW view_adi AS
Select * From Tablo_adi
Where sorgulama_sartlari

---- 13. b. Var olan bir VIEW üzerinde değişiklik yapmak (CREATE OR REPLACE VIEW .. AS)
CREATE OR REPLACE VIEW view_adi AS
Select * From Tablo_adi
Where sorgulama_sartlari

---- 13. c. VIEW silmek:
DROP VIEW view_adi


-- 14. CTE - COMMON TABLE ESPRESSIONS ------------------------------------------------------------------

-- Subquery mantığı ile aynı. Subquery'de içerde bir tablo ile ilgileniyorduk CTE'de yukarda yazıyoruz.

--(CTE), başka bir SELECT, INSERT, DELETE veya UPDATE deyiminde başvurabileceğiniz veya içinde kullanabileceğiniz geçici bir sonuç kümesidir. 
-- Başka bir SQL sorgusu içinde tanımlayabileceğiniz bir sorgudur. Bu nedenle, diğer sorgular CTE'yi bir tablo gibi kullanabilir. 
-- CTE, daha büyük bir sorguda kullanılmak üzere yardımcı ifadeler yazmamızı sağlar.


-----14. a. ORDINARY CTE

	--subquery den hiç bir farkı yok. subquery içerde kullanılıyor, Ordinary CTE yukarda WITH ile oluşturuluyor.

WITH query_name [(column_name1, ....)] AS
	(SELECT ....)   -- CTE Definition

SQL_Statement

-- sadece WITH kısmını yazarsan tek başına çalışmaz. WITH ile belirttiğim query'yi birazdan kullanacağım demek bu. 
-- asıl SQL statement içinde bunu kullanıyoruz.

---- 14. B. RECURSIVE CTE

	-- UNION ALL ile kullanılıyor.

WITH table_name (colum_list)
AS
(
	-- Anchor member
	initial_query
	UNION ALL
	-- Recursive member that references table_name.
	recursive_query
)
-- references table_name
SELECT *
FROM table_name

-- WITH ile yukarda tablo oluşturuyor, aşağıda da SELECT FROM ile bu tabloyu kullanıyor




--15. CREATE INDEX--------------------------------------------------------------------------------------------

	-- Eğer tablomuza index tanımı yaparsak yazacağımız uygulamada kayıt arama esnasında bütün veritabanını taramak yerine
	-- indexleri kullanarak daha hızlı sonuçlar elde ederiz

	-- Tekrar eden değerlere sahip alana index tanımı yapılacaksa:
CREATE INDEX index_adi
ON tablo_adi(alan_adi)

	-- "id" gibi tekrar etmeyen numaraları barındıran bir alana index tanımı yapılacak ise :
CREATE UNIQUE INDEX index_adi
ON tablo_adi(alan_adi)




--16. LIKE -------------------------------------------------------------------------------------------------

SELECT *
FROM Personel 
WHERE Sehir LIKE 'İ%'
--Sehir alanında İ harfi ile başlayan kayıtlar seçilmiştir. 
SELECT *
FROM Personel 
WHERE Bolum LIKE '%Yönetici%'
--Bolum alanının herhangi bir yerinde (başında, ortasında veya sonunda) Yönetici kelimesini seçer.
SELECT *
FROM Personel 
WHERE Bolum NOT LIKE '%Yönetici%'
--Bolum alanının herhangi bir yerinde Yönetici yazmayan kayıtları seçer
SELECT *
FROM Personel 
WHERE Sehir  LIKE 'İzmi_'
--İzmi ile başlayan ve son harfi ne olursa olsun farketmeyen
SELECT *
FROM Personel 
WHERE Adi_soyadi  LIKE '[S,A]%'
--ilk harfi S veya A ile başlayan kayıtları seçer. 
SELECT *
FROM Personel 
WHERE Adi_soyadi  LIKE '[A-K]%'
--ilk harfi A ile K harfleri arasında ki herhangi bir harf ile başlayan
SELECT *
FROM Personel 
WHERE Adi_soyadi  LIKE '%[A-K]'
-- A ile K harfleri arasında ki herhangi bir harf ile biten


