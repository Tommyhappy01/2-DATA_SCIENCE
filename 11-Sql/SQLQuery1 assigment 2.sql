insert into dbo.users (user_id, action, date) 
VALUES 
(1,'start', CAST('01-01-20' AS date)), 
(1,'cancel', CAST('01-02-20' AS date)), 
(2,'start', CAST('01-03-20' AS date)), 
(2,'publish', CAST('01-04-20' AS date)), 
(3,'start', CAST('01-05-20' AS date)), 
(3,'cancel', CAST('01-06-20' AS date)), 
(1,'start', CAST('01-07-20' AS date)), 
(1,'publish', CAST('01-08-20' AS date))

drop table users
--------
select *
from users
-------------
select User_id, sum(Action)
from users
group by User_id
--------------
users AS (
SELECT User_id, 
			sum(CASE WHEN Action = 'Start' THEN 1 ELSE 0 END) AS starts, 
			sum(CASE WHEN Action = 'Cancel' THEN 1 ELSE 0 END) AS cancels, 
			sum(CASE WHEN Action = 'Publish' THEN 1 ELSE 0 END) AS publishes
FROM users
GROUP BY User_id
ORDER BY 1)

----
SELECT user_id, 1.0*publishes/starts AS publish_rate, 1.0*cancels/starts AS cancel_rate
FROM users
