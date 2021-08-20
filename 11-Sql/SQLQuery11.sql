Window Functions
Introduction
In this part, we'll learn a very important and very powerful concept in SQL data analysis, 
the window function. They are also known as analytic functions. Let's start with the definition 
of "window function" using some official documents. 

A window function is an SQL function where the input values are taken from a "window" of one or 
more rows in the results set of a SELECT statement.

Window functions are distinguished from other SQL functions by the presence of an OVER clause.
If a function has an OVER clause, then it is a window function. If it lacks an OVER clause, then
it is an ordinary aggregate or scalar function. Window functions might also have a FILTER clause
in between the function and the OVER clause.