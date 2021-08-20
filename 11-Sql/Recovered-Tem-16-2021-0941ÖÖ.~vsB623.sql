select * from dbo.transactions

select A.sender,B.receiver,sum(A.amount)
from dbo.transactions A, dbo.transactions B
where A.sender=B.receiver
group by 
grouping sets((sender)(receiver))

debits as (
SELECT sender, sum(amount) as debited
FROM transactions
GROUP BY sender ),
credits as (
SELECT receiver, sum(amount) as credited
FROM transactions
GROUP BY receiver )
-- full (outer) join debits and credits tables on user id, taking net change as difference between credits and debits, coercing nulls to zeros with coalesce()
SELECT coalesce(sender, receiver) AS user, 
coalesce(credited, 0) - coalesce(debited, 0) AS net_change 
FROM SELECT sender, sum(amount) as debited
FROM transactions
GROUP BY sender d
FULL JOIN SELECT receiver, sum(amount) as credited
FROM transactions
GROUP BY receiver c
ON d.sender = c.receiver
ORDER BY 2 DESC