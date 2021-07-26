----------------------Week-6 (July 26th- July 31st)-------------------------


-- What is the sales quantity of product according to the brands and sort them highest-lowest

select brand_name, SUM(quantity) as total_of_sales 
from sales.order_items A, production.brands B, production.products C
where A.product_id = C.product_id
and B.brand_id = C.brand_id
group by brand_name
order by total_of_sales DESC;

-- 2. WAY

select C.brand_name, SUM(quantity) as total_of_sales 
from sales.order_items A
join production.products AS B
ON A.product_id = B.product_id
join production.brands AS C
ON B.brand_id = C.brand_id
group by brand_name
order by total_of_sales DESC;

-- Select the top 5 most expensive products

SELECT TOP 5 product_name, list_price
FROM production.products
ORDER BY list_price DESC

-- What are the categories that each brand has

SELECT C.brand_name, A.category_name
FROM production.categories AS A, production.products AS B, production.brands AS C
WHERE A.category_id = B.category_id AND B.brand_id = C.brand_id
GROUP BY brand_name, category_name
ORDER BY brand_name DESC;

-- Select the avg prices according to brands and categories

SELECT C.brand_name, A.category_name, AVG(B.list_price) AS average_price
FROM production.categories AS A, production.products AS B, production.brands AS C
WHERE A.category_id = B.category_id AND B.brand_id = C.brand_id
GROUP BY C.brand_name, A.category_name
ORDER BY brand_name DESC, category_name DESC;


-- Select the annual amount of product produced according to brands

SELECT B.model_year, A.brand_name, SUM(C.quantity) AS sum_of_quantity
FROM production.brands AS A, production.products AS B, production.stocks AS C
WHERE A.brand_id = B.brand_id AND B.product_id = C.product_id
GROUP BY B.model_year, A.brand_name

-- Select the least 3 products in stock according to stores. ????????

SELECT B.store_name, C.product_name , SUM(A.quantity) as sum_of_quantity
FROM production.stocks AS A, sales.stores AS B, production.products AS C
WHERE A.store_id = B.store_id AND A.product_id = C.product_id  AND A.quantity != 0
GROUP BY B.store_name, C.product_name
ORDER BY store_name, sum_of_quantity ASC;


-- Select the store which has the most sales quantity in 2016

SELECT TOP 1 C.store_name, SUM(B.quantity) AS sum_of_quantity 
FROM sales.orders AS A, sales.order_items AS B, sales.stores AS C
WHERE A.order_id = B.order_id AND A.store_id = C.store_id AND YEAR(A.order_date) = 2016
GROUP BY C.store_name
ORDER BY sum_of_quantity DESC;

--- 2. WAY

select top 1 C.store_name, SUM(B.quantity) as total_sales 
from sales.orders A, sales.order_items B, sales.stores C
where A.order_id = B.order_id
and A.store_id = C.store_id
and year(order_date) = 2016
group by store_name
order by total_sales DESC;


-- Select the store which has the most sales amount in 2016

SELECT TOP 1 C.store_name, SUM(B.list_price - (B.list_price * B.discount)* B.quantity) AS sum_of_quantity 
FROM sales.orders AS A, sales.order_items AS B, sales.stores AS C
WHERE A.order_id = B.order_id AND A.store_id = C.store_id AND YEAR(A.order_date) = 2016
GROUP BY C.store_name
ORDER BY sum_of_quantity DESC;

---

select top 1 store_name, sum(list_price - (list_price * discount)* quantity) as total_amount  
from sales.orders A, sales.order_items B, sales.stores C
where A.order_id = B.order_id
and A.store_id = C.store_id
and year(order_date) = 2016
group by store_name
order by total_amount desc


-- Select the personnel which has the most sales amount in 2016

SELECT TOP 1 A.first_name+' '+A.last_name AS full_name, SUM(C.list_price - (C.list_price * C.discount)* C.quantity) AS sum_of_net
FROM sales.staffs AS A, sales.orders AS B, sales.order_items AS C
WHERE A.staff_id = B.staff_id AND B.order_id = C.order_id AND YEAR(B.order_date) = 2016
GROUP BY A.first_name+' '+A.last_name
ORDER BY sum_of_net DESC;

--

select C.staff_id,sum(B.list_price - (B.list_price * B.discount)* B.quantity) as total_amount  
from sales.orders A, sales.order_items B, sales.staffs C
where A.order_id = B.order_id
and A.staff_id = C.staff_id
and year(order_date) = 2016
group by c.staff_id
order by total_amount desc


-- Select the least 3 sold products/ in 2016 and 2017/ according to city.

SELECT TOP 3 A.city, SUM(C.quantity) AS sum_quantity
FROM sales.customers AS A, sales.orders AS B, sales.order_items AS C, production.products AS D
WHERE A.customer_id = B.customer_id AND B.order_id = C.order_id AND C.product_id = D.product_id
AND YEAR(B.order_date) IN (2016,2017)
GROUP BY A.city
ORDER BY A.city, sum_quantity ASC;

