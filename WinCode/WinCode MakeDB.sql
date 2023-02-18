--WinCode - Windows Function Coding Exercises Database
--create database...
DROP DATABASE IF EXISTS WinCode;
CREATE DATABASE WinCode;

create table Sales
(
   SalesDate date not null,
   Product varchar(20) not null,
   Amount float not null
);

insert into Sales (SalesDate, Product, Amount) values
('20220105', 'Radio',150),
('20220105', 'TV',140),
('20220105', 'CD Player',120),
('20220112', 'Radio',160),
('20220112', 'TV',180),
('20220112', 'CD Player',190),
('20220119', 'Radio',170),
('20220119', 'TV',170),
('20220119', 'CD Player',210),
('20220126', 'Radio',150),
('20220126', 'TV',130),
('20220126', 'CD Player',160),
('20220202', 'Radio',130),
('20220202', 'TV',130),
('20220202', 'CD Player',130),
('20220209', 'Radio',160),
('20220209', 'TV',170),
('20220209', 'CD Player',170),
('20220216', 'Radio',180),
('20220216', 'TV',150),
('20220216', 'CD Player',120),
('20220223', 'Radio',200),
('20220223', 'TV',130),
('20220223', 'CD Player',140),
('20220302', 'Radio',180),
('20220302', 'TV',130),
('20220302', 'CD Player',190),
('20220309', 'Radio',190),
('20220309', 'TV',200),
('20220309', 'CD Player',120),
('20220316', 'Radio',210),
('20220316', 'TV',210),
('20220316', 'CD Player',160),
('20220323', 'Radio',200),
('20220323', 'TV',200),
('20220323', 'CD Player',140),
('20220330', 'Radio',190),
('20220330', 'TV',130);


create table WeeklySales
(
   SalesDate date not null,
   Product varchar(20) not null,
   Amount float not null
);

insert into WeeklySales (SalesDate, Product, Amount) values
('20220105', 'Radio',150),
('20220105', 'TV',140),
('20220105', 'CD Player',120),
('20220112', 'Radio',160),
('20220112', 'TV',180),
('20220112', 'CD Player',190),
('20220119', 'Radio',170),
('20220119', 'TV',170),
('20220119', 'CD Player',210),
('20220126', 'Radio',150),
('20220126', 'TV',130),
('20220126', 'CD Player',160),
('20220202', 'Radio',130),
('20220202', 'TV',130),
('20220202', 'CD Player',130),
('20220209', 'Radio',160),
('20220209', 'TV',170),
('20220209', 'CD Player',170),
('20220216', 'Radio',180),
('20220216', 'TV',150),
('20220216', 'CD Player',120),
('20220223', 'Radio',200),
('20220223', 'TV',130),
('20220223', 'CD Player',140),
('20220302', 'Radio',180),
('20220302', 'TV',130),
('20220302', 'CD Player',190),
('20220309', 'Radio',190),
('20220309', 'TV',200),
('20220309', 'CD Player',120),
('20220316', 'Radio',210),
('20220316', 'TV',210),
('20220316', 'CD Player',160),
('20220323', 'Radio',200),
('20220323', 'TV',200),
('20220323', 'CD Player',140),
('20220330', 'Radio',190),
('20220330', 'TV',130);

create table InventoryForecast
(
   SalesDate date not null,
   Product varchar(20) not null,
   InventoryIn int not null,
   InventoryOut int not null
);

insert into InventoryForecast (SalesDate, Product, InventoryIn, InventoryOut) values
('20220105', 'Radio',500,200),
('20220105', 'TV',500,100),
('20220105', 'CD Player',500,150),
('20220112', 'Radio',0,100),
('20220112', 'TV',0,200),
('20220112', 'CD Player',0,200),
('20220119', 'Radio',200,200),
('20220119', 'TV',100,50),
('20220119', 'CD Player',200,200),
('20220126', 'Radio',200,200),
('20220126', 'TV',100,50),
('20220126', 'CD Player',100,200),
('20220202', 'Radio',200,150),
('20220202', 'TV',100,100),
('20220202', 'CD Player',200,100),
('20220209', 'Radio',100,200),
('20220209', 'TV',100,50),
('20220209', 'CD Player',100,50),
('20220216', 'Radio',200,50),
('20220216', 'TV',100,150),
('20220216', 'CD Player',200,100),
('20220223', 'Radio',100,100),
('20220223', 'TV',200,100),
('20220223', 'CD Player',100,50),
('20220302', 'Radio',100,150),
('20220302', 'TV',100,100),
('20220302', 'CD Player',0,150),
('20220309', 'Radio',0,100),
('20220309', 'TV',0,100),
('20220309', 'CD Player',200,100),
('20220316', 'Radio',100,200),
('20220316', 'TV',100,50),
('20220316', 'CD Player',100,150),
('20220323', 'Radio',200,150),
('20220323', 'TV',200,100),
('20220323', 'CD Player',100,100),
('20220330', 'Radio',200,50),
('20220330', 'TV',100,50)

drop table Teams
create table Teams (
    Team varchar(40),
    Points int,
    Conference varchar(40)
);

insert into Teams (Team, Points, Conference) values
    ('Lion', 20, 'East'),
    ('Panther', 18, 'West'),
    ('Cougar', 18, 'East'),
    ('Falcon', 18, 'West'),
    ('Grizzly', 16, 'East'),
    ('Bear', 8, 'West'),
    ('Mustang', 10, 'East'),
    ('Jaguar', 10, 'West'),
    ('Moose', 10, 'East'),
    ('Thunder', 15, 'West'),
    ('Wolf', 16, 'East'),
    ('Stallion', 4, 'West'),
    ('Eagle', 3, 'East'),
    ('Elk', 4, 'West'),
    ('Lightning', 5, 'East'),
    ('Tiger', 1, 'West'),
    ('Bull', 1, 'East'),
    ('Wildcat', 1, 'West'),
    ('Hawk', 1, 'East'),
    ('Sabre', 1, 'West');


create table TestScores (
  StudentName varchar(255),
  Grade int
);


insert into TestScores(StudentName, Grade)
values
  ('Alice', 90),
  ('Bob', 80),
  ('Charlie', 70),
  ('Dave', 85),
  ('Eve', 75),
  ('Frank', 95),
  ('Grace', 92),
  ('Henry', 87),
  ('Isla', 84),
  ('Jack', 82),
  ('Karen', 89),
  ('Liam', 76),
  ('Maddie', 94),
  ('Nathan', 83),
  ('Olivia', 91),
  ('Patrick', 80),
  ('Quinn', 86),
  ('Rachel', 73),
  ('Sam', 88),
  ('Tess', 79),
  ('Uma', 78),
  ('Victor', 90),
  ('Wendy', 85),
  ('Xander', 70),
  ('Yara', 81),
  ('Zoe', 92),
  ('Abby', 93),
  ('Blake', 74),
  ('Cameron', 79),
  ('Dylan', 96);
