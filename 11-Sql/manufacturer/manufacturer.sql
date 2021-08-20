create database manufacture;

use manufacture

create table product
(
prod_id int,
prod_name varchar(max),
quantity int
primary key (prod_id)
)
------------

create table component
(
comp_id int primary key,
comp_name varchar(max),
[description] varchar(max),
quantity int
)
------------
create table suplier
(
supp_id int ,
supp_name varchar(max),
is_active bit,
primary key (supp_id)
)
---------
create table prod_comp
(
prod_id int,
comp_id  int,
primary key (prod_id, comp_id),
foreign key (prod_id) references product (prod_id),
foreign key (comp_id) references component (comp_id)
)
-------------
create  table comp_supp
(
comp_id int,
supp_id int,
order_date date,
order_quantity int,
primary key (comp_id,supp_id),
foreign key (supp_id) references suplier (supp_id),
foreign key (comp_id) references component (comp_id)
)

-----------owen hocanın notları--------------------------------//////////-
--//////////////////////////////////////////////////////////////////--

CREATE DATABASE Manufactur;
​
USE Manufactur
​
​
CREATE TABLE Product
(
PROD_ID INT,
PROD_NAME VARCHAR(MAX),
QUANTITY INT
PRIMARY KEY (PROD_ID)
)
​
​
---
​
CREATE TABLE COMPONENT
(
COMP_ID INT PRIMARY KEY,
COMP_NAME VARCHAR(MAX),
[DESCRIPTION] VARCHAR(MAX),
QUANTITY INT 
);
​
​
----
​
​
CREATE TABLE SUPPLIER
(
SUPP_ID INT,
SUPP_NAME VARCHAR(MAX),
ISACTIVE BIT,
PRIMARY KEY (SUPP_ID)
)
​
​
---
​
CREATE TABLE PROD_COMP
(
PROD_ID INT,
COMP_ID INT,
PRIMARY KEY (PROD_ID, COMP_ID),
FOREIGN KEY (PROD_ID) REFERENCES PRODUCT (PROD_ID),
FOREIGN KEY (COMP_ID) REFERENCES COMPONENT (COMP_ID)
)
​
---
​
​
CREATE TABLE COMP_SUPP
(
COMP_ID INT,
SUPP_ID INT,
ORDER_DATE DATE,
ORDER_QUANTITY INT,
PRIMARY KEY (COMP_ID, SUPP_ID),
FOREIGN KEY (SUPP_ID) REFERENCES SUPPLIER (SUPP_ID),
FOREIGN KEY (COMP_ID) REFERENCES COMPONENT (COMP_ID)
)