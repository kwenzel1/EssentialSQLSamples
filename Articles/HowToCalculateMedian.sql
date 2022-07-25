
select OrderDate, TotalSales, 
    percentile_cont(.5)  within group (order by TotalSales) over() MedianSales
from (
    select OrderDate, sum(FinalOrderPrice) TotalSales
    from CustomerOrderSummary
    group by OrderDate
) d

select (255.53 + 261.96) /2 
