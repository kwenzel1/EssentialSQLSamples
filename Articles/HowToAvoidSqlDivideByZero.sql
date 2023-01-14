--How to Avoid SQL Divide by Zero
--Works with SQL Server, PostgreSQL, and MySQL
--
--In the following code we’ll walk through two solutions that take different
--approaches but solve the sql divide by zero problem the same way.

--See:  https://www.essentialsql.com/how-to-avoid-sql-divide-by-zero/

--sample data
--try to calculate velocity = distance / time:
--where 
--v = velocity
--s = distance traveled
--t = time

select 100 s, 10 t union all
select 110 s, 11 t union all
select 2 s, 0 t union all
select 10 s, 1 t union all
select 120 s, 20 t


--throw error!
--velocity = s / t

select s, t, s/t v
from (
    select 100 s, 10 t union all
    select 110 s, 11 t union all
    select 2 s, 0 t union all
    select 10 s, 1 t union all
    select 120 s, 20 t
) d


--Solution 1 -- Works with SQL Server, PostgreSQL, MySQL
--Use CASE WHEN
--learn more about derrived tables here:  https://www.essentialsql.com/derived-tables/
--learn more about CASE WHEN here: https://www.essentialsql.com/sql-case/

select s, t,
    case when t = 0 then null
          else s/t end v
from (
    select 100 s, 10 t union all
    select 110 s, 11 t union all
    select 2 s, 0 t union all
    select 10 s, 1 t union all
    select 120 s, 20 t
) d



--Solution 2 -- Works with SQL Server, PostgreSQL, MySQL
--Use NULLIF
select s, t,
    s / nullif(t,0) v -- null t when 0,  to return null on v
from (
    select 100 s, 10 t union all
    select 110 s, 11 t union all
    select 2 s, 0 t union all
    select 10 s, 1 t union all
    select 120 s, 20 t
) d
