CREATE DATABASE TouristAgency;

USE TouristAgency


--CREATE

CREATE TABLE Countries
(
Id int identity primary key,
Name nvarchar(50) not null
);

CREATE TABLE Destinations
(
Id int identity primary key,
Name varchar(50) not null,
CountryId int not null Foreign Key
REFERENCES Countries(Id)

);

CREATE TABLE Rooms(
Id int identity primary key,
Type varchar(40) not null,
Price decimal(18,2) not null,
BedCount int not null
CHECK(BedCount >0 AND BedCount <=10)
);

Create Table Hotels
(
Id int identity primary key,
Name varchar(50) not null,
DestinationId int not null foreign key
REFERENCES Destinations(Id)
);

CREATE TABLE Tourists
(
Id int identity primary key,
Name nvarchar(80) not null,
PhoneNumber varchar(20) not null,
Email varchar(80),
CountryId int not null foreign key
REFERENCES Countries(Id)
)

CREATE TABLE Bookings
(
Id int identity primary key,
ArrivalDate DateTime2 not null,
DepartureDate DateTime2 not null,
AdultsCount int not null
CHECK(AdultsCount>=1 AND AdultsCount<=10),
ChildrenCount int not null
CHECK(ChildrenCount>=0 AND ChildrenCount<=9),
TouristId int not null foreign key
REFERENCES Tourists(id),
HotelId int not null foreign key
REFERENCES Hotels(Id),
RoomId int not null foreign key
REFERENCES Rooms(Id)
);

CREATE TABLE HotelsRooms
(
HotelId int not null foreign key
REFERENCES Hotels(Id),
RoomId int not null foreign key
REFERENCES Rooms(Id),
primary key(HotelId,RoomId)
)


--INSERT Has to be executed

INSERT INTO Tourists
VALUES('John Rivers','653-551-1555','john.rivers@example.com',6),
('Adeline Aglaé',	'122-654-8726','adeline.aglae@example.com',2),
('Sergio Ramirez','233-465-2876','s.ramirez@example.com',3),
('Johan Müller','322-876-9826','j.muller@example.com',7),
('Eden Smith','551-874-2234','eden.smith@example.com',6)


INSERT INTO Bookings
VALUES('2024-03-01','2024-03-11',1,0,21,3,5),
('2023-12-28','2024-01-06',2,1,22,13,3),
('2023-11-15','2023-11-20',1,2,23,19,7),
('2023-12-05','2023-12-09',4,0,24,6,4),
('2024-05-01','2024-05-07',6,0,25,14,6)


--UPDATE

UPDATE Bookings
SET DepartureDate=DATEADD(day,1,DepartureDATE)
WHERE MONTH(ArrivalDate)=12 AND YEAR(ArrivalDate)=2023

UPDATE Tourists
SET Email=NULL
WHERE Name LIKE '%MA%'

--DELETE

DELETE FROM Bookings
WHERE TouristId IN (6,16,25)

DELETE FROM Tourists
WHERE Id IN (6,16,25)

--SELECT

SELECT FORMAT(ArrivalDate,'yyyy-MM-dd') AS 'ArrivalDate',
AdultsCount,ChildrenCount FROM Bookings JOIN Rooms B ON RoomId=B.Id
ORDER by Price DESC,ArrivalDate


SELECT B.Id,B.Name FROM Bookings JOIN Hotels B ON HotelId=B.Id
JOIN HotelsRooms HR ON B.Id=HR.HotelId
WHERE HR.RoomId=8
GROUP BY B.Id,B.Name
ORDER BY Count(*) DESC

SELECT A.Id,A.Name,PhoneNumber FROM Tourists A LEFT JOIN Bookings B ON A.Id=B.TouristId
WHERE TouristId IS NULL
ORDER BY A.Name

SELECT top(10) H.Name AS 'HotelName',D.Name AS 'DestinationName',
C.Name AS 'CountryName'
FROM Bookings B JOIN Hotels H ON B.HotelId=H.Id
JOIN Destinations D ON H.DestinationId=D.Id
JOIN Countries C ON D.CountryId=C.Id
WHERE ArrivalDate<'2023-12-31' AND H.Id%2!=0
ORDER BY C.Name,ArrivalDate

SELECT H.Name AS 'HotelName' ,Price AS 'RoomPrice'
FROM Tourists T JOIN Bookings B ON T.Id=B.TouristId 
JOIN Hotels H ON B.HotelId=H.Id
JOIN Rooms R ON B.RoomId=R.Id
WHERE RIGHT(T.Name,2)!='ez'
ORDER BY Price DESC

SELECT H.Name AS 'HotelName',Sum(DATEDIFF(DAY,ArrivalDate,DepartureDate)*price) AS 'HotelRevenue' 
FROM Bookings B JOIN Hotels H ON B.HotelId=H.Id
JOIN Rooms R ON R.Id=B.RoomId
GROUP BY H.Name
ORDER BY HotelRevenue DESC

--FUNCTION

CREATE Function udf_RoomsWithTourists(
@name nvarchar(50)
)
RETURNS int
AS
BEGIN


DECLARE @CountPeople int;
SET @CountPeople=(
SELECT SUM(AdultsCount+ChildrenCount) FROM Bookings B JOIN Rooms R
ON B.RoomId=R.Id
WHERE R.Type=@name
)


RETURN @CountPeople
END;


SELECT dbo.udf_RoomsWithTourists('Double Room')


--PROCEDURE

CREATE PROCEDURE usp_SearchByCountry(@country varchar(50))
AS
SELECT T.Name AS 'Name',PhoneNumber,Email,
Count(B.TouristId) AS 'CountOfBookings'
FROM Tourists T 
JOIN Bookings B ON T.Id=B.TouristId
JOIN Countries C ON T.CountryId=C.Id
WHERE @country=C.Name
GROUP BY B.TouristId,T.Name,PhoneNumber,Email
ORDER BY T.Name,CountOfBookings

EXEC usp_SearchByCountry 'Greece'





