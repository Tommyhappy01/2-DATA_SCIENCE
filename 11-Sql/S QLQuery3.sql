--Answer the following questions according to bikestore database

--1- What is the sales quantity of product according to the brands and sort them highest-lowest

select brand_name, SUM(quantity) as total_of_sales from sales.order_items A, production.brands B, production.products Cwhere A.product_id = C.product_idand B.brand_id = C.brand_idgroup by brand_name
order by total_of_sales desc;

--2- Select the top 5 most expensive products
select TOP 5 product_name, list_pricefrom production.products order by list_price desc

--3- What are the categories that each brand has

select C.brand_name, A.category_namefrom production.products AS B, production.categories AS A, production.brands AS Cwhere A.category_id=B.category_id and B.brand_id=C.brand_idgroup by C.brand_name, A.category_nameorder by brand_name desc;

--4- Select the avg prices according to brands and categories

select C.brand_name, A.category_name, avg(list_price) as avg_list_pricefrom production.products AS B, production.categories AS A, production.brands AS Cwhere A.category_id=B.category_id and B.brand_id=C.brand_idgroup by C.brand_name, A.category_nameORDER BY brand_name DESC--SELECT C.brand_name, A.category_name, AVG(B.list_price) AS average_priceFROM production.categories AS A, production.products AS B, production.brands AS CWHERE A.category_id = B.category_id AND B.brand_id = C.brand_idGROUP BY C.brand_name, A.category_nameORDER BY brand_name DESC;
--5- Select the annual amount of product produced according to brands

SELECT B.model_year, A.brand_name, SUM(C.quantity) AS sum_of_quantityFROM production.brands AS A, production.products AS B, production.stocks AS CWHERE A.brand_id = B.brand_id AND B.product_id = C.product_idGROUP BY B.model_year, A.brand_name

--6- Select the least 3 products in stock according to stores.

SELECT A.store_name,C.product_name, sum(B.quantity) as sum_of_quantityFROM sales.stores AS A, production.stocks AS B,production.products As CWHERE A.store_id = B.store_id
GROUP BY A.store_name
order by sum(B.quantity) desc;'


--7- Select the store which has the most sales quantity in 2016

select top 1 store_name, SUM(quantity) as total_salesfrom sales.orders A, sales.order_items B, sales.stores Cwhere A.order_id = B.order_idand A.store_id = C.store_idand year(order_date) = 2016group by store_nameorder by total_sales desc


--8- Select the store which has the most sales amount in 2016

select top 1 store_name, (list_price - (list_price * discount)* quantity) as total_amount  from sales.orders A, sales.order_items B, sales.stores Cwhere A.order_id = B.order_idand A.store_id = C.store_idand year(order_date) = 2016group by store_nameorder by total_amount desc


--9- Select the personnel which has the most sales amount in 2016

select top 1 first_name+' '+A.last_name as staff_name, sum(C.list_price - (C.list_price * C.discount)* C.quantity) as sum_of_net  from sales.staffs A, sales.orders B, sales.order_items Cwhere A.staff_id = B.staff_id and B.order_id = C.order_idand year(order_date) = 2016group by first_name+' '+A.last_nameorder by sum_of_net desc


--10- Select the least 3 sold products in 2016 and 2017 according to city.

SELECT A.city, SUM(C.quantity) AS sum_quantity FROM sales.customers AS A, sales.orders AS B, sales.order_items AS C, production.products AS DWHERE A.customer_id = B.customer_id AND B.order_id = C.order_id AND C.product_id = D.product_idAND YEAR(B.order_date) IN (2016,2017)GROUP BY A.cityORDER BY A.city DESC;
