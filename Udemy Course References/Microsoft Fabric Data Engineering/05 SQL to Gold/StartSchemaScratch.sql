
    --Model Dimension
    --See https://learn.microsoft.com/en-us/fabric/data-warehouse/generate-unique-identifiers on how to make an ID
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

Selli

    --Transmission Type
    drop table if exists Gold.TransmissionType
    create table Gold.TransmissionType
    as
    select row_number() over(order by (select null)) TransmissionTypeId, d.* 
    from (
        select distinct Transmission TransmissionTypeName
        from Silver.CarPrices
    ) d


    --Fact
    drop table if exists Gold.CarSales
    create table Gold.CarSales
    as
    Select ModelYear, m.ModelId, s.SellerId, k.ColorId, t.TransmissionTypeId
        Vin, SalesState, SalesDate, Condition, Miles, ManheirMarketReportValue, SellingPrice,
        case when SellingPrice > ManheirMarketReportValue then 1 else 0 end SoldOverMarketValue,
        (SellingPrice - ManheirMarketReportValue) AbsoluteDifference,
        Round(cast(SellingPrice - ManheirMarketReportValue as float) / cast(ManheirMarketReportValue as float) * 100, 1) PercentDifference
        from Silver.CarPrices c
            inner join Gold.Model m on c.Make = m.Make and c.Model = m.Model and c.Trim = m.Trim and c.Body = m.Body
            inner join Gold.Seller s on c.Seller = s.Seller
            inner join Gold.Color k on c.BodyColor = k.BodyColor and c.InteriorColor = k.InteriorColor
            inner join Gold.TransmissionType t on c.Transmission = t.TransmissionTypeName