---------------------------------------------------------
--PostgreSQL
---------------------------------------------------------
--This script creates the PizzaDB sample database.  The
--general strategy is first drop any existing objects,
--and then recreate.

--create database...
DROP DATABASE IF EXISTS PizzaDB;
CREATE DATABASE PizzaDB;


--\c PizzaDB;


---------------------------------------------------------
-- Build Tables for Udemy Exercises
---------------------------------------------------------
create table Shop
(
   ShopID int not null,
   ShopName varchar(20) not null,
   constraint pkShopID primary key (ShopID),
   constraint ukShopName unique (ShopName)
);
create index idxShop on Shop(ShopID);


create table Employee
(
   EmployeeID int not null,
   FirstName varchar(20) not null,
   LastName varchar(20) not null,
   constraint pkEmployeeID primary key (EmployeeID)
);
create index idxEmployee on Employee(EmployeeID);


create table EmployeeHistory
(
   EmployeeHistoryID int not null,
   EmployeeID int not null,
   ShopID int null,
   StartDate date not null,
   TerminationDate date null,
   constraint pkEmployeeHistoryID primary key (EmployeeHistoryID),
   constraint fkEmployeeHistoryEmployeeID foreign key (EmployeeID) references Employee (EmployeeID),   
   constraint fkEmployeeHistoryShopID foreign key (ShopID) references Shop (ShopID)
);
create index idxEmployeeHistory on EmployeeHistory(EmployeeHistoryID);


create table Customer
(
    CustomerID int not null,
    PhoneNumber varchar(15),
    Email varchar(40),
    LastName varchar(40),
    StreetAddress varchar(40),
    City Varchar(20),
    StateProvidence Varchar(10),
    PostalCode Varchar(15),
    constraint pkCustomerID primary key (CustomerID)
);
create index idxCustomer on Customer(CustomerID);


create table Coupon
(
    CouponID int not null,
    CouponName varchar(20)  unique not null,
    CouponDescription varchar(80),
    PercentDiscount int not null,
    ExpirationDate date not null,
    constraint pkCouponID primary key (CouponID)
);
create index idxCoupon on Coupon(CouponID);


create table Product
(
    ProductID int not null,
    ProductName varchar(20) not null,
    ProductType varchar(5) not null,
    Price decimal(12,2) not null,
    constraint pkProductID primary key (ProductID),
    constraint ukProductName unique (ProductName)
);
create index idxProduct on Product(ProductID);


create table CustomerOrder
(
    CustomerOrderID int not null,
    CustomerID int not null,
    OrderTakerID int not null,
    OrderDate date not null,
    CouponID int,
    constraint pkCustomerOrderID primary key (CustomerOrderID),
    constraint fkCustomerOrderCustomerID foreign key (CustomerID) references Customer (CustomerID),
    constraint fkCustomerOrderOrderTakerID foreign key (OrderTakerID) references Employee (EmployeeID),
    constraint fkCouponID foreign key (CouponID) references Coupon (CouponID)
);
create index idxCustomerOrder on CustomerOrder(CustomerOrderID);


create table CustomerOrderItem
(
    CustomerOrderItemID int not null,
    CustomerOrderID int not null,
    ProductID int not null,
    Quantity int not null,
    SpecialInstructions varchar(60),
    constraint pkCustomerOrderItemId primary key (CustomerOrderItemID),
    constraint fkCustomerOrderItemCustomerOrderID foreign key (CustomerOrderID) references CustomerOrder (CustomerOrderID),
    constraint fkCustomerOrderItemProductID foreign key (ProductID) references Product (ProductID)
);
create index idxCustomerOrderItem on CustomerOrderItem(CustomerOrderItemID);



create  view CustomerOrderDetail
as
select o.CustomerOrderID, o.OrderDate, c.CustomerID, c.LastName CustomerName,
    p.ProductName, p.Price, i.Quantity, i.Quantity * p.Price PurchaseAmount
from CustomerOrder o
    inner join Customer c on o.CustomerID = c.CustomerID
    inner join CustomerOrderItem i on  o.CustomerOrderID = i.CustomerOrderID
    inner join Product p on i.ProductID = p.ProductID;


create view CustomerOrderSummary
as
select o.CustomerOrderID, o.OrderDate, c.CustomerID, c.LastName, 
   Sum(i.Quantity * p.Price) OrderPrice,
   Sum(i.Quantity * p.Price) * coalesce(cp.PercentDiscount ,0) / 100.0 DiscountAmount,
   Sum(i.Quantity * p.Price) * (1.00 - (coalesce(cp.PercentDiscount ,0) / 100.0)) FinalOrderPrice
from CustomerOrder o
    inner join Customer c on o.CustomerID = c.CustomerID
    inner join CustomerOrderItem i on o.CustomerOrderID = i.CustomerOrderID
    inner join Product p on i.ProductID = p.ProductID
    left  join Coupon cp on o.CouponID = cp.CouponID
group by o.CustomerOrderID, o.OrderDate, c.CustomerID, c.LastName, cp.PercentDiscount;


create view DailySalesSummary
as
select OrderDate, Sum(FinalOrderPrice) DailySales
from CustomerOrderSummary
group by OrderDate;


create view EmployeeDetail
as
select h.EmployeeHistoryID, e.EmployeeID, s.ShopName, e.FirstName, e.LastName, h.StartDate, h.TerminationDate,
    case when TerminationDate is null then 1 else 0 end IsActive
from Employee e
    inner join EmployeeHistory h on e.EmployeeID = h.EmployeeID
    inner join Shop s on h.ShopId = s.ShopID;


---------------------------------------------------------
-- Insert Sample Data
---------------------------------------------------------
insert into Shop ( ShopID, ShopName) values (1, 'Main Street');
insert into Shop ( ShopID, ShopName) values (2, 'West Side');


insert into Employee (EmployeeID, FirstName, LastName) values (1, 'Noah',   'Washington');
insert into Employee (EmployeeID, FirstName, LastName) values (2, 'Brandy', 'Saunders');
insert into Employee (EmployeeID, FirstName, LastName) values (3, 'Ciam',   'Sawyer');
insert into Employee (EmployeeID, FirstName, LastName) values (4, 'Ivan',   'Sara');
insert into Employee (EmployeeID, FirstName, LastName) values (5, 'Chad',   'Tedford');


insert into EmployeeHistory (EmployeeHistoryID,  EmployeeID, ShopID, StartDate, TerminationDate) values (1, 1,1, '2018-05-03', '2018-08-31');
insert into EmployeeHistory (EmployeeHistoryID,  EmployeeID, ShopID, StartDate, TerminationDate) values (2, 1,1, '2019-02-03', null);
insert into EmployeeHistory (EmployeeHistoryID,  EmployeeID, ShopID, StartDate, TerminationDate) values (3, 2,2, '2019-02-03', null);
insert into EmployeeHistory (EmployeeHistoryID,  EmployeeID, ShopID, StartDate, TerminationDate) values (4, 3,1, '2019-02-03', '2020-03-03');
insert into EmployeeHistory (EmployeeHistoryID,  EmployeeID, ShopID, StartDate, TerminationDate) values (5, 4,2, '2019-08-02', null);
insert into EmployeeHistory (EmployeeHistoryID,  EmployeeID, ShopID, StartDate, TerminationDate) values (6, 5,1, '2020-01-29', null);


insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (1, '249-124-4223', 'duffy@coolmail.com', 'Duffy', '120 Magnolia', 'Plainwill', 'MI', '49000');
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (2, '249-124-4323', null, 'Miller', null, null, null, null);
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (3, null, null, 'Raheem', '121 Elm', 'Plainwill', 'MI', '49000');
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (4, '249-124-7323', null, 'D''Hers', null, null, null, null);
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (5, '249-124-4323','Gaviny@jmail.com', 'Galvin', '345 Beech', 'Plainwill', 'MI', '49000');
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (6, null, null, 'Sullivan', null, null, null, null);
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (7, '249-424-4323', null, 'Salavaria', '374 Oak', 'Plainwill', 'MI', '49000');
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (8, null, null, 'Bradley', null, null, null, null);
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (9, '249-424-4723', 'bbronw@lookout.com', 'Brown', '2945 Maple', 'Plainwill', 'MI', '49000');
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (10, null, null, 'Wood', null, null, null, null);
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (11, '249-424-7238', null, 'Dempsey', '325 Box Wood', 'Plainwill', 'MI', '49080');
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (12, null, 'f4324@@lookout.com', 'Benshoof', null, null, null, null);
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (13, '249-124-6525', null, 'Eminhizer', '342 Willow', 'Plainwill', 'MI', '49080');
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (14, null, null, 'McArthur', null, null, null, null);
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (15, '249-124-5634', 'shoopthecoopw@coolmail.com', 'Shoop', '865 Ironwood', 'Plainwill', 'MI', '49080');
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (16, null, null, 'Laszio', null, null, null, null);
insert into Customer (CustomerID, PhoneNumber, Email, LastName, StreetAddress, City, StateProvidence, PostalCode) values (17, '249-425-934', null, 'Tuberson', '237 Oakmont', 'Plaiwill Township', 'MI', '49081');

insert into Coupon (CouponID, CouponName, CouponDescription, PercentDiscount, ExpirationDate) values (1, '15P', '15% off order', 15, '2022-03-31');
insert into Coupon (CouponID, CouponName, CouponDescription, PercentDiscount, ExpirationDate) values (2, '10P', '10% off order', 10, '2022-03-15');
insert into Coupon (CouponID, CouponName, CouponDescription, PercentDiscount, ExpirationDate) values (3, '10PS', '10% off order', 10, '2022-05-15');


insert into Product (ProductID, ProductName, ProductType, Price) values (1 ,'Smelt Pizza','P',10.99);
insert into Product (ProductID, ProductName, ProductType, Price) values (2 ,'Pan Pizza','P',14.89);
insert into Product (ProductID, ProductName, ProductType, Price) values (3 ,'Large Pizza','P',16.89);
insert into Product (ProductID, ProductName, ProductType, Price) values (4 ,'Small Pizza','P',9.89);
insert into Product (ProductID, ProductName, ProductType, Price) values (5 ,'Medium Pizza','P',11.99);
insert into Product (ProductID, ProductName, ProductType, Price) values (6 ,'Calazone','S',6.5);
insert into Product (ProductID, ProductName, ProductType, Price) values (7 ,'2 Liter Coke','B',4.5);
insert into Product (ProductID, ProductName, ProductType, Price) values (8 ,'2 Liter Diet Coke','B',4.5);
insert into Product (ProductID, ProductName, ProductType, Price) values (9 ,'Extra Cheese','I',1.5);
insert into Product (ProductID, ProductName, ProductType, Price) values (10 ,'Extra Pepperoni','I',1.5);
insert into Product (ProductID, ProductName, ProductType, Price) values (11 ,'Delivery','S',5.0);


insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (1,1,1,'20220301',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (2,2,2,'20220301',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (3,3,3,'20220301',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (4,4,4,'20220301',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (5,5,5,'20220301', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (6,6,1,'20220301', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (7,7,2,'20220301', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (8,8,3,'20220301', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (9,9,4,'20220301', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (10,10,5,'20220310', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (11,11,1,'20220310',2);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (12,12,2,'20220310', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (13,13,3,'20220310', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (14,14,4,'20220310', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (15,15,5,'20220310', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (16,16,1,'20220310',2);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (17,2,2,'20220310', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (18,4,3,'20220310', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (19,6,4,'20220310', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (20,8,5,'20220301', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (21,9,1,'20220301', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (22,10,2,'20220301', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (23,1,3,'20220303', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (24,5,4,'20220303',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (25,3,5,'20220313', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (26,1,1,'20220313',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (27,2,2,'20220313',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (28,3,3,'20220313',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (29,4,4,'20220313',2);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (30,5,5,'20220313', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (31,6,1,'20220313', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (32,7,2,'20220303', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (33,9,4,'20220303', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (34,10,5,'20220303', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (35,11,1,'20220303',2);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (36,12,2,'20220313', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (37,14,4,'20220303', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (38,15,5,'20220313', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (39,16,1,'20220313',2);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (40,2,2,'20220303', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (41,6,4,'20220303', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (42,8,5,'20220303', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (43,9,1,'20220313', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (44,10,2,'20220313', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (45,5,4,'20220313',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (46,3,5,'20220303', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (47,1,1,'20220304',2);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (48,2,2,'20220304',2);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (49,3,3,'20220304',2);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (50,4,4,'20220304',2);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (51,5,5,'20220304', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (52,6,1,'20220304', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (53,7,2,'20220314', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (54,8,3,'20220314', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (55,9,4,'20220304', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (56,10,5,'20220314', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (57,11,1,'20220314',2);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (58,12,2,'20220314', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (59,13,3,'20220314', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (60,14,4,'20220304', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (61,15,5,'20220304', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (62,16,1,'20220304',2);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (63,2,2,'20220304', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (64,4,3,'20220314', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (65,6,4,'20220314', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (66,8,5,'20220314', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (67,9,1,'20220314', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (68,10,2,'20220314', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (69,1,3,'20220305', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (70,5,4,'20220305',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (71,3,5,'20220305', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (72,1,1,'20220305',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (73,2,2,'20220315',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (74,3,3,'20220315',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (75,4,4,'20220315',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (76,5,5,'20220315', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (77,6,1,'20220315', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (78,7,2,'20220305', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (79,9,4,'20220305', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (80,10,5,'20220315', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (81,11,1,'20220315',2);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (82,12,2,'20220315', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (83,14,4,'20220315', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (84,15,5,'20220315', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (85,16,1,'20220305',2);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (86,2,2,'20220305', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (87,6,4,'20220305', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (88,8,5,'20220305', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (89,9,1,'20220305', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (90,10,2,'20220315', null);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (91,5,4,'20220305',1);
insert into CustomerOrder (CustomerOrderID, CustomerID, OrderTakerID,  OrderDate, CouponID) values (92,3,5,'20220305', null);

insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(1,1,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(2,2,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(3,3,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(4,4,3,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(5,4,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(6,5,4,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(7,5,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(8,6,4,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(9,6,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(10,7,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(11,7,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(12,8,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(13,8,10,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(14,8,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(15,9,2,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(16,9,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(17,9,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(18,10,1,1,'Extra Smelt Please!');
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(19,10,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(20,10,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(21,11,5,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(22,11,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(23,11,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(24,12,5,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(25,12,10,3,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(26,12,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(27,13,3,3,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(28,13,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(29,13,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(30,14,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(31,14,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(32,14,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(33,15,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(34,15,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(35,15,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(36,16,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(37,16,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(38,16,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(39,17,4,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(40,17,10,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(41,17,7,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(42,18,4,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(43,18,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(44,18,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(45,19,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(46,19,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(47,19,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(48,20,2,3,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(49,20,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(50,20,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(51,21,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(52,21,10,3,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(53,21,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(54,22,1,1,'Add Salt');
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(55,22,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(56,22,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(57,23,5,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(58,23,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(59,23,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(60,24,5,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(61,24,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(62,24,7,3,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(63,25,3,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(64,25,10,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(65,25,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(66,26,3,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(67,26,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(68,26,7,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(69,27,3,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(70,27,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(71,27,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(72,28,3,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(73,28,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(74,28,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(75,29,4,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(76,29,10,3,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(77,29,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(78,30,4,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(79,30,11,1,'Dog is nice, he won''t bite.');
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(80,30,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(81,30,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(82,30,9,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(83,30,8,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(84,31,2,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(85,31,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(86,31,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(87,31,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(88,32,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(89,32,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(90,32,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(91,32,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(92,33,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(93,33,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(94,33,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(95,33,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(96,34,1,3,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(97,34,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(98,34,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(99,34,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(100,35,5,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(101,35,11,1,'We are in the upstairs unit.');
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(102,35,10,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(103,35,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(104,36,5,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(105,36,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(106,36,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(107,36,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(108,37,3,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(109,37,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(110,37,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(111,37,8,3,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(112,38,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(113,38,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(114,38,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(115,38,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(116,39,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(117,39,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(118,39,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(119,39,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(120,40,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(121,40,11,1,'Knock hard, door bell is broken');
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(122,40,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(123,40,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(124,41,4,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(125,41,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(126,41,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(127,41,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(128,42,4,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(129,42,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(130,42,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(131,42,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(132,43,2,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(133,43,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(134,43,10,3,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(135,43,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(136,44,2,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(137,44,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(138,44,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(139,44,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(140,45,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(141,45,11,1,'It is the drive way by the two pine trees');
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(142,45,10,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(143,45,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(144,46,1,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(145,46,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(146,46,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(147,46,8,4,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(148,47,5,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(149,47,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(150,47,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(151,47,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(152,48,5,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(153,48,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(154,48,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(155,48,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(156,49,3,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(157,49,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(158,49,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(159,49,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(160,50,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(161,50,11,1,'Drive carefully!');
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(162,50,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(163,50,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(164,51,3,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(165,51,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(166,51,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(167,51,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(168,52,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(169,52,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(170,52,10,4,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(171,52,8,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(172,53,4,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(173,53,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(174,53,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(175,53,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(176,54,4,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(177,54,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(178,54,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(179,54,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(180,55,2,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(181,55,11,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(182,55,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(183,55,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(184,56,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(185,56,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(186,56,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(187,57,2,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(188,57,10,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(189,57,8,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(190,58,1,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(191,58,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(192,59,5,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(193,59,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(194,60,5,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(195,60,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(196,61,3,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(197,61,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(198,62,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(199,62,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(200,63,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(201,63,10,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(202,64,3,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(203,64,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(204,65,4,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(205,65,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(206,66,4,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(207,66,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(208,67,2,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(209,67,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(210,68,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(211,68,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(212,69,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(213,69,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(214,70,1,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(215,70,10,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(216,70,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(217,71,5,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(218,71,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(219,71,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(220,72,5,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(221,72,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(222,72,9,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(223,73,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(224,73,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(225,73,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(226,74,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(227,74,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(228,74,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(229,75,3,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(230,75,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(231,75,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(232,76,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(233,76,10,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(234,76,9,3,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(235,77,4,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(236,77,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(237,77,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(238,78,4,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(239,78,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(240,78,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(241,79,2,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(242,79,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(243,79,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(244,80,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(245,80,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(246,80,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(247,81,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(248,81,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(249,81,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(250,82,1,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(251,82,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(252,82,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(253,83,5,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(254,83,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(255,83,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(256,84,5,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(257,84,10,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(258,84,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(259,85,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(260,85,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(261,85,9,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(262,86,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(263,86,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(264,86,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(265,87,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(266,87,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(267,87,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(268,88,3,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(269,88,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(270,88,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(271,89,4,2,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(272,89,10,4,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(273,89,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(274,90,4,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(275,90,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(276,90,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(277,91,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(278,91,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(279,91,9,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(280,92,2,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(281,92,10,1,null);
insert into CustomerOrderItem (CustomerOrderItemID, CustomerOrderID, ProductID, Quantity, SpecialInstructions) values(282,92,9,1,null);

