--WinCode - Windows Function Coding Exercises Database
--create database...
DROP DATABASE IF EXISTS WinCode;
CREATE DATABASE WinCode;

use Wincode; -- don't use in PostgeSQL.

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



CREATE TABLE StockPrice (
    StockSymbol varchar(10),
    TradeDate date,
    ClosingPrice NUMERIC(10,2)
);


INSERT INTO StockPrice (StockSymbol, TradeDate, ClosingPrice)
VALUES
('TSLA', '2023-01-03', 108.099998),
('TSLA', '2023-01-04', 113.639999),
('TSLA', '2023-01-05', 110.339996),
('TSLA', '2023-01-06', 113.059998),
('TSLA', '2023-01-09', 119.769997),
('TSLA', '2023-01-10', 118.849998),
('TSLA', '2023-01-11', 123.220001),
('TSLA', '2023-01-12', 123.559998),
('TSLA', '2023-01-13', 122.400002),
('TSLA', '2023-01-17', 131.490005),
('TSLA', '2023-01-18', 128.779999),
('TSLA', '2023-01-19', 127.169998),
('TSLA', '2023-01-20', 133.419998),
('TSLA', '2023-01-23', 143.75),
('TSLA', '2023-01-24', 143.889999),
('TSLA', '2023-01-25', 144.429993),
('TSLA', '2023-01-26', 160.270004),
('TSLA', '2023-01-27', 177.899994),
('TSLA', '2023-01-30', 166.660004),
('TSLA', '2023-01-31', 173.220001),
('TSLA', '2023-02-01', 181.410004),
('TSLA', '2023-02-02', 188.270004),
('TSLA', '2023-02-03', 189.979996),
('TSLA', '2023-02-06', 194.759995),
('TSLA', '2023-02-07', 196.809998),
('TSLA', '2023-02-08', 201.289993),
('TSLA', '2023-02-09', 207.320007),
('TSLA', '2023-02-10', 196.889999),
('TSLA', '2023-02-13', 194.639999),
('TSLA', '2023-02-14', 209.25),
('TSLA', '2023-02-15', 214.240005),
('TSLA', '2023-02-16', 202.039993),
('TSLA', '2023-02-17', 208.309998),
('TSLA', '2023-02-21', 197.369995),
('TSLA', '2023-02-22', 200.860001),
('TSLA', '2023-02-23', 202.070007),
('TSLA', '2023-02-24', 196.880005),
('TSLA', '2023-02-27', 207.630005);



-----------------------------------------------------------
-- For teaching Joins
-- Create Course table
-- Create Course table
CREATE TABLE Course (
    CourseName VARCHAR(50),
    Semester VARCHAR(50),
    Department VARCHAR(50),
    Instructor VARCHAR(50),
    CreditHours INT
);

-- Populate Course table
INSERT INTO Course (CourseName, Semester, Department, Instructor, CreditHours)
VALUES
    ('Algebra', 'Fall', 'Math', 'John Smith', 3),
    ('Geometry', 'Fall', 'Math', 'Jane Doe', 3),
    ('Biology', 'Fall', 'Science', 'Sarah Johnson', 4),
    ('Chemistry', 'Fall', 'Science', 'Michael Brown', 4),
    ('History', 'Fall', 'Social Studies', 'Emily Wilson', 3),
    ('Art', 'Fall', 'Fine Arts', 'Laura Anderson', 2),
    ('Drafting', 'Fall', 'Fine Arts', 'David Miller', 3),
    ('Music', 'Fall', 'Fine Arts', 'Robert Taylor', 2),
    ('Algebra', 'Spring', 'Math', 'John Smith', 3),
    ('Geometry', 'Spring', 'Math', 'Jane Doe', 3),
    ('Biology', 'Spring', 'Science', 'Sarah Johnson', 4),
    ('Chemistry', 'Spring', 'Science', 'Michael Brown', 4),
    ('History', 'Spring', 'Social Studies', 'Emily Wilson', 3),
    ('Art', 'Spring', 'Fine Arts', 'Laura Anderson', 2),
    ('Drafting', 'Spring', 'Fine Arts', 'David Miller', 3),
    ('Music', 'Spring', 'Fine Arts', 'Robert Taylor', 2),
    ('Weaving', 'Spring', 'Fine Arts', 'Robert Taylor', 2),
    ('Earth Science', 'Fall', 'Science', 'Tera Planut', 2);  

-- Create Student table
CREATE TABLE Schedule (
    CourseName VARCHAR(50),
    Semester VARCHAR(50),
    StudentName VARCHAR(50)
);

-- Populate Student table
INSERT INTO Schedule (CourseName, Semester, StudentName)
VALUES
    ('Algebra', 'Fall', 'Bob'),
    ('Geometry', 'Fall', 'Bob'),
    ('Biology', 'Fall', 'Sally'),
    ('Chemistry', 'Fall', 'Sally'),
    ('History', 'Fall', 'Sally'),
    ('Algebra', 'Spring', 'Omar'),
    ('Geometry', 'Spring', 'Omar'),
    ('Biology', 'Spring', 'Fleur'),
    ('Chemistry', 'Spring', 'Fleur'),
    ('History', 'Spring', 'Fleur'),
    ('Art', 'Fall', 'Sally'),
    ('Music', 'Spring', 'Sally'),
    ('Art', 'Spring', 'Fleur'),
    ('Music', 'Fall', 'Fleur');
