--This is the commands you can use to create the Silver and Gold schemas.

--https://learn.microsoft.com/en-us/sql/t-sql/statements/create-schema-transact-sql?view=sql-server-ver16
create schema Silver;
create schema Gold;

--This is the script is use to get a sense of the data.
Select top 100 *
from BronzeLayer.dbo.car_prices

--Here I rename the columns.  I normally don't do this as a separate step,
--but did so for you so help show you some of the thinking.
Select top 1000
    [year] ModelYear,
    make Make,
    model Model,
    trim Trim,
    body Body,
    transmission Transmission,
    vin,
    [state] SalesState,
    condition Condition,
    odometer Miles,
    color BodyColor,
    interior InteriorColor,
    seller Seller,
    mmr ManheirMarketReportValue,
    sellingprice SellingPrice,
    saledate SalesDate,
    saledate SalesTime
from BronzeLayer.dbo.car_prices



--in this step I go throught the column and transform each one.
--you see where some columns are cast to a new data type; whereas, others, such as condition are corrected.
--Also since Fabric doesnt support case insensitive collation (e.g. SQL_Latin1_General_CP1_CI_AS), so I lower case all text values.
Select top 1000
    try_cast([year] as int) ModelYear,
    lower(make) Make,
    lower(model) Model,
    lower(trim) Trim,
    lower(body) Body,
    lower(transmission) Transmission,
    lower(vin) Vin,
    lower([state]) SalesState,
    case when condition < 5 then cast(condition as decimal(4,1)) else cast(condition as decimal(4,1)) / 10.0 end  Condition,
    cast(odometer as int) Miles,
    lower(color) BodyColor,
    lower(interior) InteriorColor,
    lower(seller) Seller,
    cast(mmr as int) ManheirMarketReportValue,
    cast(sellingprice as int) SellingPrice,
    saledate SalesDate
    from BronzeLayer.dbo.car_prices
where isnumeric(color) <> 1 -- filter our bad volkwagen rows


--Sales Date
select saledate
from BronzeLayer.dbo.car_prices

--remove day of the week
select top 100 Substring(saledate,5,200)
from BronzeLayer.dbo.car_prices

--123456789012345678901234567890
--May 27 2015 08:05:00 GMT-0700 (PDT)
select top 100  try_cast(left(Substring(saledate,5,200),11) as date) SalesDate
from BronzeLayer.dbo.car_prices

--remove dashes
select top 100 replace(try_cast(left(Substring(saledate,5,200),11) as date),'-','') SalesDate
from BronzeLayer.dbo.car_prices


--add Sales dateto query
Select top 1000
    try_cast([year] as int) ModelYear,
    lower(make) Make,
    lower(model) Model,
    lower(trim) Trim,
    lower(body) Body,
    lower(transmission) Transmission,
    lower(vin) Vin,
    lower([state]) SalesState,
    case when condition < 5 then cast(condition as decimal(4,1)) else cast(condition as decimal(4,1)) / 10.0 end  Condition,
    cast(odometer as int) Miles,
    lower(color) BodyColor,
    lower(interior) InteriorColor,
    lower(seller) Seller,
    cast(mmr as int) ManheirMarketReportValue,
    cast(sellingprice as int) SellingPrice,
    cast(replace(try_cast(left(Substring(saledate,5,200),11) as date),'-','') as int) SalesDate
    from BronzeLayer.dbo.car_prices
where isnumeric(color) <> 1 -- filter our bad volkwagen rows

