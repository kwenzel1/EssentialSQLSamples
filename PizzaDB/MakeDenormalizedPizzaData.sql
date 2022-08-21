select  s.StoreName, e.LastName OrderTaker, c.LastName Name, c.StreetAddress Street, c.PhoneNumber Phone, 
    co.OrderDate, cp.PercentDiscount CouponDiscount, string_agg(p.ProductName, ',') ProductsOrdered, sum(p.Price * coi.Quantity) [TotalPrice], string_agg(coi.SpecialInstructions, ',') SpecialInstructions
from Customer c
    left join CustomerOrder co on c.CustomerID = co.CustomerID
    left join Employee e on co.OrderTakerID = e.EmployeeID
    left join Coupon cp on co.CouponID = cp.couponID
    left join CustomerOrderItem coi on co.CustomerOrderID = coi.CustomerOrderID
    left join Store s on e.StoreID = s.StoreID
    left join Product p on coi.ProductID = p.ProductID
group by s.StoreName, e.LastName, c.LastName, c.StreetAddress, c.PhoneNumber, co.OrderDate, cp.PercentDiscount

