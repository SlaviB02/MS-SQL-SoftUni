CREATE DATABASE RailwaysDb;

USE RailwaysDb

--CREATE

CREATE TABLE Passengers
(
Id int identity primary key,
Name nvarchar(80) not null
);

Create Table Towns
(
Id int identity primary key,
Name varchar(30) not null
);

Create table RailwayStations
(
Id int identity primary key,
Name varchar(50) not null,
TownId int not null foreign key
REFERENCES Towns(Id)
);

CReate table Trains
(
Id int identity primary key,
HourOfDeparture varchar(5) not null,
HourOfArrival varchar(5) not null,
DepartureTownId int not null foreign key
REFERENCES Towns(Id),
ArrivalTownId int not null foreign key
REFERENCES Towns(Id)
);

CREATE TABLE TrainsRailwayStations
(
TrainId int not null foreign key
REFERENCES Trains(Id),
RailwayStationId int not null foreign key
REFERENCES RailwayStations(Id),
primary key(TrainId,RailwayStationId)
);

CREATE TABLE MaintenanceRecords
(
Id int identity primary key,
DateOfMaintenance Date not null,
Details varchar(2000) not null,
TrainId int not null foreign key
REFERENCES Trains(Id)
);

CREATE TABLE Tickets
(
Id int identity primary key,
Price decimal(10,2) not null,
DateOfDeparture Date not null,
DateOfArrival Date not null,
TrainId int not null foreign key
REFERENCES Trains(Id),
PassengerId int not null foreign key
REFERENCES Passengers(Id)
);


--INSERT

INSERT INTO Trains
VALUES('07:00','19:00',1,3),
('08:30','20:30',5,6),
('09:00','21:00',4,8),
('06:45','03:55',27,7),
('10:15','12:15',15,5)

INSERT INTO TrainsRailwayStations
VALUES (36,1),(37,60),(39,3),
(36,4),(37,16),(39,31),
(36,31),(38,10),(39,19),
(36,57),(38,50),(40,41),
(36,7),(38,52),(40,7),
(37,13),(38,22),(40,52),
(37,54),(39,68),(40,13)

INSERT INTO Tickets
VALUES(90.00,'2023-12-01','2023-12-01',36,1),
(115.00,'2023-08-02','2023-08-02',37,2),
(160.00,'2023-08-03','2023-08-03',38,3),
(255.00,'2023-09-01','2023-09-02',39,21),
(95.00,'2023-09-02','2023-09-03',40,22)


--UPDATE

UPDATE Tickets
SET DateOfDeparture=DATEADD(day,7,DateOfDeparture),
DateOfArrival=DATEADD(day,7,DateOfArrival)
WHERE DateOfDeparture>'2023-10-31'

--DELETE

DELETE FROM MaintenanceRecords
WHERE TrainId=7

DELETE FROM TrainsRailwayStations
WHERE TrainId=7

DELETE FROM Tickets
WHERE TrainId=7

DELETE FROM Trains
WHERE DepartureTownId=3


--SELECT


SELECT DateOfDeparture,Price AS 'TicketPrice' FROM Tickets
ORDER BY Price,DateOfDeparture DESC


SELECT P.Name AS 'PassengerName',Price AS 'TicketPrice',DateOfDeparture,TrainId
FROM Tickets T JOIN Passengers P ON T.PassengerId=P.Id
ORDER BY Price DESC,P.Name


SELECT T.Name AS 'Town',RS.Name AS 'RailwayStation'
FROM RailwayStations RS JOIN Towns T ON RS.TownId=T.Id LEFT JOIN TrainsRailwayStations TRS
ON RS.Id=TRS.RailwayStationId
WHERE TRS.TrainId IS NULL
ORDER BY T.Name,RS.Name


SELECT top(3) Tr.Id as 'TrainId',HourOfDeparture,
Price AS 'TicketPrice',Tow.Name AS 'Destination'
FROM Trains Tr JOIN Tickets Ti ON Tr.Id=Ti.TrainId 
JOIN Towns Tow ON Tr.ArrivalTownId=Tow.Id 
WHERE cast(HourOfDeparture as time) BETWEEN '8:00' AND '8:59'
AND price>50.00
ORDER BY Price


SELECT Tow.Name AS 'TownName',Count(*) AS 'PassengersCount' 
FROM Passengers P 
Join Tickets Ti ON P.Id=Ti.PassengerId
JOIN Trains Tr ON Ti.TrainId=Tr.Id
JOIN Towns Tow ON Tow.Id=Tr.ArrivalTownId
WHERE Price>76.99
GROUP BY Tow.Name
ORDER BY Tow.Name


SELECT TR.Id AS 'TrainID',Tow.Name AS 'DepartureTown',Details
FROM MaintenanceRecords MR 
JOIN Trains TR ON MR.TrainId=TR.Id
JOIN Towns Tow ON Tow.Id=TR.DepartureTownId
WHERE Details LIKE '%inspection%'
ORDER BY TR.Id


--FUNCTION

CREATE FUNCTION udf_TownsWithTrains(
@name varchar(50)
)
RETURNS int
AS 
BEGIN
Declare @CountTrains int;
SET @CountTrains=
(
SELECT Count(DepartureTownId+ArrivalTownId) FROM Trains Tr 
JOIN Towns Tow ON Tr.ArrivalTownId=Tow.Id
JOIN Towns Toww ON Toww.Id=Tr.DepartureTownId
WHERE Tow.Name=@name OR Toww.Name=@name
)

RETURN @CountTrains
END

SELECT dbo.udf_TownsWithTrains('Paris')


--PROCEDURE

CREATE PROCEDURE usp_SearchByTown(
@townName varchar(50)
)
AS
SELECT P.Name AS 'PassengerName',DateOfDeparture,HourOfDeparture
FROM Passengers P 
JOIN Tickets Ti ON P.Id=Ti.PassengerId
JOIN Trains Tr ON Ti.TrainId=Tr.Id
JOIN Towns Tow ON Tow.Id=Tr.ArrivalTownId
WHERE Tow.Name=@townName
ORDER BY DateOfDeparture DESC,P.Name


EXEC usp_SearchByTown 'Berlin'