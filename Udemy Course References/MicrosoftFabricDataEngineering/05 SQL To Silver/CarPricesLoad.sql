create proc Silver.CarPricesLoad
as
begin

    drop table if exists  Silver.CarPrices

    create table Silver.CarPrices
    as
    select try_cast([year] as int) ModelYear,
        lower(make) Make,
        lower(model) Model,
        lower(trim) Trim,
        lower(body) Body,
        lower(transmission) Transmission,
        lower(vin) Vin,
        lower([state]) SalesState,
        case when condition <= 5 then cast(condition as decimal(4,1)) else cast(condition as decimal(4,1)) / 10.0 end  Condition,
        try_cast(odometer as int) Miles,
        lower(color) BodyColor,
        lower(interior) InteriorColor,
        lower(seller) Seller,
        try_cast(mmr as int) ManheirMarketReportValue,
        try_cast(sellingprice as int) SellingPrice,
        cast(replace(try_cast(left(substring(saledate,5,200),11) as date),'-','') as int) SalesDate
    from BronzeLayer.dbo.car_prices
    where isnumeric(color) <> 1 -- filter our bad volkwagen rows

end   


create table dbo.test (a varchar(10))