SELECT top 20 A.product_id,product_name,B.category_name
from production.products as A
inner join production.categories as B
on A.category_id=B.category_id


-- joýnsiz joýn oldu,-- ilk tablo","ikinci tablo--ortak tablolar 
-- joýn olmazsa where yazacaðýz
SELECT top 20 B.first_name, B.last_name, A.store_name
from sales.stores A, sales.staffs B
where A.store_id=B.store_id

--left jýnde virgül olmaz
select A.product_id,product_name,B.category_name
from production.products A
left join production.categories B
on A.category_id = B.category_id

--products tablosundaki id si 310 dan büyük olan 
--tüm ürünlerin stock bilgisini istiyoruz
select A.product_id,A.product_name,B.store_id, B.quantity
from production.products A
left join production.stocks B
on A.product_id = B.product_id
where A.product_id > 310


select A.product_id,A.product_name,B.store_id, B.quantity
from production.stocks B
right join production.products A
on A.product_id = B.product_id
where A.product_id > 310

SELECT A.staff_id, A.first_name,A.last_name, B.*
FROM sales.orders B
RIGHT JOIN sales.staffs A
ON A.staff_id = B.staff_id


select B.product_id,B.store_id,B.quantity,A.product_id,A.list_price,A.order_id
from sales.order_items A
full outer join production.stocks B
on A.product_id=B.product_id
