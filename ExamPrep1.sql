CREATE DATABASE Accounting

USE Accounting


--CREATE DATABASE AND TABLES

CREATE TABLE Countries(
Id int identity primary key,
Name varchar(10) not null
);

Create Table Addresses(
Id int identity primary key,
StreetName nvarchar(20) not null,
StreetNumber int,
PostCode int not null,
City varchar(25) not null,
CountryId int not null,
foreign key (CountryId) REFERENCES Countries(Id)
);



Create Table Vendors(
Id int identity primary key,
Name nvarchar(25) not null,
NumberVAT nvarchar(15) not null,
AddressId int not null,
foreign key (AddressId) REFERENCES Addresses(Id)
);

CREATE TABLE Clients(
Id int identity primary key,
Name nvarchar(25) not null,
NumberVAT nvarchar(15) not null,
AddressId int not null,
foreign key (AddressId) REFERENCES Addresses(Id)
);

CREATE TABLE Categories(
Id int identity primary key,
Name varchar(10) not null
);

CREATE TABLE Products(
Id int identity primary key,
Name nvarchar(35) not null,
Price decimal(18,2) not null,
CategoryId int not null,
VendorId int not null,
foreign key(CategoryId) REFERENCES Categories(Id),
foreign key (VendorId) REFERENCES Vendors(Id)
);

CREATE TABLE Invoices(
Id int identity primary key,
Number int not null UNIQUE,
IssueDate DATETIME2 not null,
DueDate DATETIME2 not null,
Amount decimal(18,2) not null,
Currency varchar(5) not null,
ClientId int not null,
foreign key (ClientId) REFERENCES Clients(Id)
);

CREATE TABLE ProductsClients(
ProductId int not null,
ClientId int not null,
foreign key (ProductId) REFERENCES Products(Id),
foreign key (ClientId) REFERENCES Clients(Id),
primary key(ProductId,ClientId)
);


--INSERT

INSERT INTO Products
VALUES('SCANIA Oil Filter XD01',78.69,1,1),
('MAN Air Filter XD01',97.38,1,5),
('DAF Light Bulb 05FG87',55.00,2,13),
('ADR Shoes 47-47.5',49.85,3,5),
('Anti-slip pads S',5.87,5,7)

INSERT INTO Invoices
VALUES (1219992181,'2023-03-01','2023-04-30',180.96,'BGN',3),
(1729252340,'2022-11-06','2023-01-04',158.18,'EUR',13),
(1950101013,'2023-02-17','2023-04-18',615.15,'USD',19)

--UPDATE

UPDATE Invoices
SET DueDate='2023-04-01'
WHERE month(IssueDate)=11 AND year(IssueDate)=2022

UPDATE Clients
SET AddressId=3
WHERE Name LIKE '%CO%'

--DELETE

DELETE FROM Invoices WHERE ClientId=11
DELETE FROM ProductsClients WHERE ClientId=11
DELETE FROM Clients
WHERE LEFT(NumberVAT,2)='IT'

--SELECT

SELECT Number,Currency FROM Invoices
ORDER BY Amount DESC,DueDate

SELECT A.Id,A.Name,Price,B.Name AS 'CategoryName'
From Products A JOIN Categories B ON A.CategoryId=B.Id
WHERE B.Name='ADR' OR B.Name='Others'
ORDER BY Price DESC

SELECT A.Id,A.Name AS 'Clients',
C.StreetName+' '+Convert(varchar(20),C.StreetNumber)+', '+C.City+', '+Convert(varchar(20),C.PostCode)+', '+D.Name AS 'Address' 
FROM Clients A LEFT JOIN ProductsClients B ON a.Id=B.ClientId
JOIN Addresses C ON a.AddressId=C.Id JOIN Countries D ON C.CountryId=D.Id
WHERE B.ClientId IS NULL
ORDER BY A.Name

SELECT top(7) Number,Amount,B.Name AS 'Client' 
FROM Invoices A JOIN Clients B ON A.ClientId=B.Id 
WHERE (IssueDate<'2023-01-01' AND A.Currency='EUR') 
OR  (Amount>500.00 AND LEFT(NumberVAT,2)='DE')
ORDER BY A.Number,Amount DESC

SELECT A.Name AS 'Client',Max(Price) AS 'Price',NumberVAT AS 'VAT Number'
FROM Clients A JOIN ProductsClients B ON A.Id=B.ClientId 
JOIN Products C ON B.ProductId=C.Id
WHERE A.Name NOT LIKE '%KG'
GROUP BY A.Name,A.NumberVAT
ORDER BY Max(Price) DESC

SELECT A.Name AS 'Client',FLOOR(AVG(C.price)) AS 'Average Price'
FROM Clients A LEFT JOIN ProductsClients B ON A.Id=B.ClientId 
JOIN Products C ON B.ProductId=C.Id JOIN Vendors D ON C.VendorId=D.Id
WHERE B.ClientId IS NOT NULL AND D.NumberVAT LIKE '%FR%'
GROUP BY A.Name
ORDER BY AVG(price),A.Name DESC

--FUNCTION

CREATE Function udf_ProductWithClients(@name nvarchar(35))
RETURNS int
AS
BEGIN
DECLARE @Count int=(
SELECT Count(B.ClientId) 
FROM Products A JOIN ProductsClients B ON A.Id=B.ProductId
WHERE A.name=@name
)
RETURN @Count
END


SELECT dbo.udf_ProductWithClients('DAF FILTER HU12103X')

--PROCEDURE

CREATE PROCEDURE usp_SearchByCountry
@country varchar(30)
AS
SELECT A.Name AS 'Vendor',
NumberVAT AS 'VAT',
B.StreetName+' '+Convert(varchar(30),B.StreetNumber) AS 'Street Info',
B.City+' '+Convert(varchar(30),B.PostCode) AS 'City Info' 
FROM Vendors A JOIN Addresses B ON A.AddressId=B.Id 
JOIN Countries C ON B.CountryId=C.Id
WHERE @country=C.Name
ORDER BY A.Name,City

EXEC usp_SearchByCountry 'France'