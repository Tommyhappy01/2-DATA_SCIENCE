---I would like to present my respects to C8162 - AZIZ.
---We can create a database in SQL Server Management Studio by using the following options:
            --- Option 1 ---
CREATE DATABASE TABLE_NAME
            --- Option 2 ---
CREATE DATABASE CancellationRatesCREATE TABLE CancellationRates.dbo.users (User_id INT NOT NULL,Action TEXT NOT NULL,date DATE NOT NULL,);
            --- Option 3 ---
---By manually:
---Under the Object Explorer on the left-hand-side of our screen, we’ll see the Databases Folder. 
---Right click on that folder and then select New Database… from the drop-down list. 
---Now we’ll be able to create our database by typing the name of our database in the entry box. 
---Once we’re done click on OK: 
---If we expand the Databases folder under the Object Explorer or refresh the Databases, 
---we’ll see our newly created database. We can then add tables to our database.

            --- SOLUTION ---
---a. Create above table and insert values,

---We have used the second method to create our database in this assignment.
---We created CancellationRates Databse and its columns we have checked if they have existed.

SELECT*
FROM users;

---We have inserted the values into the columns

INSERT INTO CancellationRates.dbo.users (User_id, Action, date) 
VALUES 
(1,'start', CAST('1-1-20' AS date)), 
(1,'cancel', CAST('1-2-20' AS date)), 
(2,'start', CAST('1-3-20' AS date)), 
(2,'publish', CAST('1-4-20' AS date)), 
(3,'start', CAST('1-5-20' AS date)), 
(3,'cancel', CAST('1-6-20' AS date)), 
(1,'start', CAST('1-7-20' AS date)), 
(1,'publish', CAST('1-8-20' AS date))

---We have checked if the values are inserted into columns.

SELECT*
FROM users;

---b. Retrieve count of starts, cancels, and publishes for each user,
---c. Calculate publication, cancelation rate for each user by dividing by number of starts,
---casting as float by multiplying by 1.0
---All these methods are true but we tried to retrieve float results

			--- METHOD 1 ---
---We have retrieved the number of "start", "cancel" and "publish" for each user 
---by creating a new table named "rates". 

SELECT User_id,
sum(CASE WHEN Action like 'start' THEN 1 ELSE 0 END) as starts,
sum(CASE WHEN Action like 'cancel' THEN 1 ELSE 0 END) as cancels, 
sum(CASE WHEN Action like 'publish' THEN 1 ELSE 0 END) as publishes
INTO rates
FROM users
GROUP BY User_id

---We have checked the new table

select*
from rates

---We have calculated publication and cancelation rates for each user 
---by dividing by number of starts, casting as float by multiplying by 1.0 

SELECT  User_id,
		CAST(publishes AS FLOAT)/CAST(starts AS FLOAT) AS Publish_rate,
		CAST(cancels AS FLOAT)/CAST(starts AS FLOAT) AS Cancel_rate 
FROM rates
ORDER BY User_id ASC
---------------------------------------------------------------------------------------

			--- METHOD 2 --- WITH USING 'CAST' AS DECIMAL ---

SELECT  User_id,
		CAST(publishes AS DECIMAL (2,1))/CAST(starts AS DECIMAL (2,1)) AS Publish_rate,
		CAST(cancels AS DECIMAL (2,1))/CAST(starts AS DECIMAL (2,1)) AS Cancel_rate 
FROM rates
ORDER BY User_id ASC

---------------------------------------------------------------------------------------

			--- METHOD 3 --- WITH USING 'CONVERT', 'CAST AS NUMERIC' & 'ROUND' ---

SELECT *
FROM rates

SELECT  User_id,
		CONVERT(NUMERIC(5,1), starts) AS Starts,
		CONVERT(NUMERIC(5,1), cancels) AS Cancels,
		CONVERT(NUMERIC(5,1), publishes) AS Publishes
INTO total
FROM rates

SELECT *
FROM total

SELECT User_id, publishes/starts AS Publish_rate, cancels/starts AS Cancel_rate
FROM total

SELECT User_id, 
	   CAST(ROUND(publishes/starts, 1) AS NUMERIC(36,1)) AS Publish_rate,
	   CAST(ROUND(cancels/starts, 1) AS NUMERIC(36,1)) AS Cancel_rate
FROM total

---------------------------------------------------------------------------------------

			--- METHOD 4 --- WITH USING 'CAST' & 'AS DECIMAL' ---

SELECT  User_id,
		CAST(publishes AS decimal (2,1))/CAST(starts AS decimal (2,1)) AS Publish_rate,
		CAST(cancels AS decimal (2,1))/CAST(starts AS decimal (2,1)) AS Cancel_rate 
FROM rates
ORDER BY User_id ASC
---------------------------------------------------------------------------------------

			--- METHOD 5 --- WITH MULTIPLYING BY 1.0 ---

SELECT User_id, 1.0*publishes/starts AS Publish_rate, 1.0*cancels/starts AS Cancel_rate
FROM rates

----------------------------------------------------------------------------------------

			--- METHOD 6 --- WITH USING 'FORMAT' ---

SELECT User_id, 
	   FORMAT(publishes/starts, '0.0') AS Publish_rate,
	   FORMAT(cancels/starts, '0.0') AS Cancel_rate
FROM total

---OR---

SELECT User_id, 
	   FORMAT(publishes/starts, 'N1') AS Publish_rate,
	   FORMAT(cancels/starts, 'N1') AS Cancel_rate
FROM total