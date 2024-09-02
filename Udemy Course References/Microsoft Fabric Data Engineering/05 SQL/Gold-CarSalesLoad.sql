alter proc Gold.CarSalesLoad
as
begin


    --model
    --see  https://learn.microsoft.com/en-us/fabric/data-warehouse/generate-unique-identifiers
    drop table if exists Gold.Model
    create table Gold.Model
    as
    select row_number() over(order by (select null)) ModelId, d.*
    from (
        select distinct Make, Model, Trim, Body
        from Silver.CarPrices
    ) d


    --Seller
    drop table if exists Gold.Seller
    create table Gold.Seller
    as
    select row_number() over(order by (select null)) SellerId, d.* 
    from (
        select distinct Seller
        from Silver.CarPrices
    ) d


    --Color
    drop table if exists Gold.Color
    create table Gold.Color
    as
    select row_number() over(order by (select null)) ColorId, d.* 
    from (
        select distinct BodyColor, InteriorColor
        from Silver.CarPrices
    ) d


    --TransmissionType
    drop table if exists Gold.TransmissionType
    create table Gold.TransmissionType
    as
    select row_number() over(order by (select null)) TransmissionTypeId, d.* 
    from (
        select distinct Transmission
        from Silver.CarPrices
    ) d


    --Date Dimension
    --helpful functions
    --DATEADD https://learn.microsoft.com/en-us/sql/t-sql/functions/dateadd-transact-sql?view=sql-server-ver16
    --DATENAME https://learn.microsoft.com/en-us/sql/t-sql/functions/datename-transact-sql?view=sql-server-ver16
    --DATEPART https://learn.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql?view=sql-server-ver16    
    declare @startDate date = '2010/01/01'
    drop table if exists Gold.DateDimension
    create table Gold.DateDimension
    as
    select cast(format(FullDate,'yyyyMMdd') as int) YYYYMMDD, 
        FullDate, 
        Year(FullDate) Year, Month(FullDate) Month, Day(FullDate) Day, 
        cast(datename(mm, FullDate) as varchar(40)) MonthName,
        cast(datepart(dw, FullDate) as varchar(40)) DayOfWeek,
        cast(datename(weekday, FullDate) as varchar(40)) DayOfWeekName,
        cast(datepart(isowk, FullDate) as varchar(40)) WeekOfYear, 
        cast(datepart(q, FullDate) as varchar(10)) Quarter,
        cast(concat(datepart(yyyy, FullDate), 'Q', datepart(q, FullDate)) as varchar(10)) YearQuarter
    from (
        select dateadd(d, d.Id, @startDate) FullDate
        from (
            select top (11 * 365) row_number() over(order by (select null)) - 1 Id
            from Silver.CarPrices
        ) d
    ) e


    --Fact
    --https://learn.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-develop-ctas
    drop table if exists Gold.CarSales
    create table Gold.CarSales
    as
    select ModelYear, m.ModelId, t.TransmissionTypeId, k.ColorId, SellerId, Vin, SalesState, Condition, Miles, 
        ManheirMarketReportValue, SellingPrice,
        case when SellingPrice > ManheirMarketReportValue then 1 else 0 end SoldOverMarketValue,
        SellingPrice - ManheirMarketReportValue AbsoluteDifference,
        round(cast( (SellingPrice - ManheirMarketReportValue) as float) / cast( ManheirMarketReportValue as float) * 100, 1) PercentDifference,
        SalesDate
        from Silver.CarPrices c -- match back to dimensions to pickup ID's
            inner join Gold.Model m on c.Make = m.Make and c.Model = m.Model and c.Trim = m.Trim and c.Body = m.Body
            inner join Gold.TransmissionType t on c.Transmission = t.Transmission
            inner join Gold.Color k on c.BodyColor = k.BodyColor and c.InteriorColor = k.InteriorColor
            inner join Gold.Seller s on c.Seller = s.Seller
            inner join Gold.DateDimension d on c.SalesDate = d.YYYYMMDD

end
