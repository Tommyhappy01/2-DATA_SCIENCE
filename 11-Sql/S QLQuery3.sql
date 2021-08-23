--Answer the following questions according to bikestore database

--1- What is the sales quantity of product according to the brands and sort them highest-lowest

select brand_name, SUM(quantity) as total_of_sales 
order by total_of_sales desc;

--2- Select the top 5 most expensive products
select TOP 5 product_name, list_price

--3- What are the categories that each brand has

select C.brand_name, A.category_name

--4- Select the avg prices according to brands and categories

select C.brand_name, A.category_name, avg(list_price) as avg_list_price


SELECT B.model_year, A.brand_name, SUM(C.quantity) AS sum_of_quantity

--6- Select the least 3 products in stock according to stores.

SELECT A.store_name,C.product_name, sum(B.quantity) as sum_of_quantity
GROUP BY A.store_name
order by sum(B.quantity) desc;'


--7- Select the store which has the most sales quantity in 2016

select top 1 store_name, SUM(quantity) as total_sales


--8- Select the store which has the most sales amount in 2016

select top 1 store_name, (list_price - (list_price * discount)* quantity) as total_amount  from sales.orders A, sales.order_items B, sales.stores C


--9- Select the personnel which has the most sales amount in 2016

select top 1 first_name+' '+A.last_name as staff_name, sum(C.list_price - (C.list_price * C.discount)* C.quantity) as sum_of_net  


--10- Select the least 3 sold products in 2016 and 2017 according to city.

SELECT A.city, SUM(C.quantity) AS sum_quantity 