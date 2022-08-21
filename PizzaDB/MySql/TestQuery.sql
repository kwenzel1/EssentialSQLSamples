select o.OrderDate, c.LastName, o.CustomerOrderID, p.ProductName, i.Quantity, p.Price, i.SpecialInstructions, p.ProductType
from CustomerOrder o
    inner join CustomerOrderItem i on o.CustomerOrderID = i.CustomerOrderID
    inner join Product p on i.ProductID = p.ProductID
    inner join Customer c on o.CustomerID = c.CustomerID
    order by o.CustomerOrderID