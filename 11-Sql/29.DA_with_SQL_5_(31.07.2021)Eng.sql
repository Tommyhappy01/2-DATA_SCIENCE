-- GET DATA TYPES FROM BIKESTORES DATABASE

SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_catalog = 'BikeStores';

-->

SELECT DATA_TYPE, COUNT(*) 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_catalog = 'BikeStores'
GROUP BY DATA_TYPE;

-- LET'S BUILD A TABLE THAT INCLUDES ALL THE DATE AND TIME  FORMATS WE NEED

CREATE TABLE t_date_time (
						  A_time time,
						  A_date date,
						  A_smalldatetime smalldatetime,
						  A_datetime datetime,
						  A_datetime2 datetime2,
						  A_datetimeoffset datetimeoffset

						  )

-->

/* right-click on table > script table as > create to > new query

USE [BikeStores]
GO

/****** Object:  Table [dbo].[t_date_time]    Script Date: 31.07.2021 16:26:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_date_time](
	[A_time] [time](7) NULL,
	[A_date] [date] NULL,
	[A_smalldatetime] [smalldatetime] NULL,
	[A_datetime] [datetime] NULL,
	[A_datetime2] [datetime2](7) NULL,
	[A_datetimeoffset] [datetimeoffset](7) NULL
) ON [PRIMARY]
GO */

-- INSERT VALUES TO THE TABLE

INSERT INTO dbo.t_date_time (
							 A_time,
							 A_date,
							 A_smalldatetime,
							 A_datetime,
							 A_datetime2,
							 A_datetimeoffset
							 )
VALUES (
		'12:00:00',
		'2021-07-17',
		'2021-07-17',
		'2021-07-17',
		'2021-07-17',
		'2021-07-17'
		)

-->

SELECT * 
FROM dbo.t_date_time

-- LET'S USE CONSTRUCT FUNCTIONS FOR INSERTING DATA

INSERT INTO dbo.t_date_time (A_time)
VALUES (TIMEFROMPARTS(12,0,0,0,0));

-- INSERT TIME FORMATTED VALUE FOR 12:10:30 INTO COLUMN A_time

INSERT INTO dbo.t_date_time (A_time)
VALUES (TIMEFROMPARTS(12,10,30,0,0));

-- INSERT TIME FORMATTED VALUE FOR 20:30:15 INTO COLUMN A_time

INSERT INTO t_date_time (A_time) 
VALUES (TIMEFROMPARTS(20,30,15,0,0));

-- INSERT TIME FORMATTED VALUE FOR TODAY INTO COLUMN A_date

INSERT INTO t_date_time (A_date) 
VALUES (DATEFROMPARTS(2021,07,31));

-- INSERT DATETIME FORMATTED VALUE FOR TODAY AT 15:30:20 INTO COLUMN A_datetime

INSERT INTO t_date_time (A_datetime) 
VALUES (DATETIMEFROMPARTS(2021,07,31,15,30,020,0));

-- INSERT DATETIMEOFFSET FORMATTED VALUE FOR TODAY AT 15:30:20 OFFSET=2 HOURS INTO COLUMN A_datetimeoffset

INSERT INTO t_date_time (A_datetimeoffset) 
VALUES (DATETIMEOFFSETFROMPARTS(2021,07,31, 15,30,20,0, 0,0,0));

/* -- DELETE

DELETE dbo.t_date_time
WHERE A_datetimeoffset = '2021-07-31 15:30:20.0000000 +00:00'

-- DELETE

DELETE dbo.t_date_time
WHERE A_datetime = '2021-07-21 15:30:20.000' */

-- RETURN FUNCTIONS

--RETURN FUNCTIONS

SELECT A_date,
		DATENAME(DW,A_date) as date_name,
		DAY(A_date) as [day],
		DATEPART(MONTH,A_date) as [datepart],
		DATENAME(MONTH,A_date) as [datename]
FROM dbo.t_date_time

-->

SELECT A_date, 
	   DATENAME(DW, A_date) AS day_name, 
	   DAY(A_date) AS which_day_number,
	   DATEPART(MONTH, A_date) AS which_month_number,
	   DATENAME(MONTH, A_date) AS month_name
FROM dbo.t_date_time

-->

SELECT *,DATENAME(DW,order_date) as order_date
		,DATENAME(DW,required_date) as required_date
		,DATENAME(DW,shipped_date) as shipped_date
FROM sales.orders

-->

SELECT A_date, 
	   DATENAME(DW, A_date) AS day_name, 
	   DAY(A_date) AS which_day_number,
	   DATEPART(MONTH, A_date) AS which_month_number,
	   DATENAME(MONTH, A_date) AS month_name
FROM dbo.t_date_time

--> These two below are giving same results

SELECT
      DATEPART(year, '2018-05-10') [datepart], 
      DATENAME(year, '2018-05-10') [datename];

-- ISDATE, GETDATE(), CURRENT_TIMESTAMP, GETUTCDATE()

SELECT ISDATE('2021-22-29') -- you will get zero, cause it's not a real date.
SELECT ISDATE('2021-01-31')

SELECT GETDATE()
SELECT CURRENT_TIMESTAMP
SELECT GETUTCDATE()

INSERT INTO t_date_time VALUES (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE());

-- 

SELECT * 
FROM t_date_time

-- DATEDIFF, DATEADD, EOMONTH FUNCTIONS

SELECT *, 
	   DATENAME(DW, order_date) AS order_day, 
	   DATEDIFF(D, order_date, shipped_date) AS [day_diff]
FROM sales.orders;
--> DATEDIFF vs DATEDIFF_BIG (if you have huge number of differences)

-- DATEADD AND EOMONTH FUNCTIONS

SELECT EOMONTH('2021-02-15')
SELECT EOMONTH('2020-02-15')
SELECT DAY(EOMONTH('2020-02-15'))
SELECT DAY(EOMONTH('2021-02-15'))

SELECT DATEADD (M,3,'2020-01-01') -- add 3 months
SELECT DATEADD (WEEK,3,'2020-01-01') -- add 3 weeks
SELECT DATEADD (D,-5,'2020-01-01') -- go back 5 days


-- QUESTION: Create a new column that contains labels of the shipping speed of products.
-- 1. If the product has not been shipped yet, it will be marked as "Not Shipped"
-- 2. If the product was shipped in 1 day of order, it will be labeled as "Fast"
-- 3. If the product is shipped in 3 days after the order day, it will be labeled as "Normal"
-- 4. If the product was shipped 3 or more days after the day of order, it will be labeled as "Slow" 
-- (ORDER STATUS <> 4 THAT MEANS THIS ORDER IS NOT SHIPPED)

SELECT *, DATENAME(DW, order_date) AS order_day, 
		  DATEDIFF(D, order_date, shipped_date) AS [day_diff],
		  CASE WHEN order_status <> 4 THEN 'Not Shipped'
		  WHEN DATEDIFF(D, order_date, shipped_date) = 1 THEN 'Fast' -- DATEDIFF ( DAY, order_date, shipped_date) = 0 THAN 'Fast' it counts the current dates also.
		  WHEN DATEDIFF(DAY, order_date, shipped_date) = 2 THEN 'Normal' -- No longer than 2 days --> BETWEEN 1 AND 2 / instead of = 2
		  ELSE 'Slow' -- other options
		  END AS Shipping_Speed
FROM sales.orders

-- QUESTION: Write a query returns orders that are shipped more than two days after the ordered date.

SELECT *, DATEDIFF (DAY, order_date, shipped_date) AS difference_date
FROM sales.orders
WHERE DATEDIFF (DAY, order_date, shipped_date) > 2

-- QUESTION: Write o query that returns the number distributions of the orders in the previous query result, according to the days of the week.

SELECT 	SUM(CASE WHEN DATENAME (DW, order_date) = 'Monday' THEN 1 ELSE 0 END) AS mondays,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Tuesdat' THEN 1 ELSE 0 END) AS tuesdays,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Wednesday' THEN 1 ELSE 0 END) AS wednesdays,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Thursday' THEN 1 ELSE 0 END) AS thursdays,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Friday' THEN 1 ELSE 0 END) AS fridays,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Saturday' THEN 1 ELSE 0 END) AS saturdays,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Sunday' THEN 1 ELSE 0 END) AS sunday
FROM sales.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2
GROUP BY


-- QUESTION: Write a query that returns the order numbers of the states by months.

SELECT C.state, 
				YEAR(O.order_date) AS [Year],
				MONTH(O.order_date) AS [MONTH],
				COUNT(DISTINCT O.order_id) AS NUM_OF_ORDERS
FROM sales.orders AS O, sales.customers AS C
WHERE O.customer_id = C.customer_id 
GROUP BY C.state, YEAR(O.order_date), MONTH(O.order_date)
ORDER BY C.state, [Year];

SELECT C.state, 
				YEAR(O.order_date) AS [Year],
				MONTH(O.order_date) AS [MONTH],
				COUNT(O.order_id) AS NUM_OF_ORDERS
FROM sales.orders AS O, sales.customers AS C
WHERE O.customer_id = C.customer_id 
GROUP BY C.state, YEAR(O.order_date), MONTH(O.order_date)
ORDER BY C.state, [Year];