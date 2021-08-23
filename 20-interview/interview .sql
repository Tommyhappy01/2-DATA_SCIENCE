--1.soru How many rows in the sales dataset?

SELECT count(*) FROM sales

--2.soru How many columns in the sales dataset?

SELECT count(COLUMN_NAME)

--3- What is the total number of seller?

SELECT count(distinct seller_id)
FROM sales

-- SORU-4 What is the total value of sales in EUR?

--5- Which brand has the highest number of purhase during the period?

SELECT brand,count(brand)
From sales
group by brand
order by count(brand) desc

--6. How many items in the "Jewellery" category have no brand assciateed with them?

SELECT count(Distinct product_code) 
FROM sales
WHERE category = 'Jewellery'
AND brand = ''