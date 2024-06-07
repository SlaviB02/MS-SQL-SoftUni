CREATE DATABASE NationalTouristSitesOfBulgaria;

USE NationalTouristSitesOfBulgaria

--CREATE

CREATE TABLE Categories
(
Id int identity primary key,
Name varchar(50) not null
);

CREATE TABLE Locations
(
Id int identity primary key,
Name varchar(50) not null,
Municipality varchar(50),
Province varchar(50)
);

CREATE TABLE Sites
(
Id int identity primary key,
Name varchar(100) not null,
LocationId int not null foreign key
REFERENCES Locations(Id),
CategoryId int not null foreign key
REFERENCES Categories(Id),
Establishment varchar(15)
);

CREATE TABLE Tourists
(
Id int identity primary key,
Name varchar(50) not null,
Age int not null
CHECK(Age>=0 AND Age<=120),
PhoneNumber varchar(20) not null,
Nationality varchar(30) not null,
Reward varchar(20)
);

CREATE TABLE SitesTourists
(
TouristId int not null foreign key
REFERENCES Tourists(Id),
SiteId int not null foreign key
REFERENCES Sites(Id),
primary key(TouristId,SiteId)
);

CREATE TABLE BonusPrizes
(
Id int identity primary key,
Name varchar(50) not null
)

CREATE TABLE TouristsBonusPrizes
(
TouristId int not null foreign key
REFERENCES Tourists(Id),
BonusPrizeId int not null foreign key
REFERENCES BonusPrizes(Id),
primary key(TouristId,BonusPrizeId)
)

--INSERT

INSERT INTO Tourists
VALUES('Borislava Kazakova',52,'+359896354244','Bulgaria',NULL),
('Peter Bosh',48,'+447911844141','UK',NULL),
('Martin Smith',29,'+353863818592','Ireland','Bronze badge'),
('Svilen Dobrev',49,'+359986584786','Bulgaria','Silver badge'),
('Kremena Popova',38,'+359893298604','Bulgaria',NULL)

INSERT INTO Sites
VALUES('Ustra fortress',90,7,'X'),
('Karlanovo Pyramids',65,7,NULL),
('The Tomb of Tsar Sevt',63,8,'V BC'),
('Sinite Kamani Natural Park',17,1,NULL),
('St. Petka of Bulgaria – Rupite',92,6,'1994')

--UPDATE

UPDATE Sites
SET Establishment='not defined'
WHERE Establishment IS NULL

--DELETE


DELETE FROM TouristsBonusPrizes
WHERE BonusPrizeId=5

DELETE FROM BonusPrizes
WHERE ID=5


--SELECT 

SELECT Name,Age,PhoneNumber,Nationality FROM Tourists
ORDER BY Nationality,Age DESC,Name


SELECT S.Name AS 'Site',L.Name AS 'Location',
Establishment,C.Name AS 'Category'
FROM Sites S 
JOIN Locations L ON S.LocationId=L.Id
JOIN Categories C ON S.CategoryId=C.Id
ORDER BY Category DESC,Location,Site

SELECT L.Province,L.Municipality,L.Name AS 'Location',
COUNT(S.Id) AS 'CountOfSites' 
FROM Locations L JOIN Sites S ON S.LocationId=L.Id
WHERE Province='Sofia'
GROUP BY L.Province,L.Municipality,L.Name
ORDER BY CountOfSites DESC,Location

SELECT S.Name as 'Site',L.Name AS 'Location',L.Municipality,
L.Province,S.Establishment
FROM Sites S 
JOIN Locations L ON S.LocationId=L.Id
WHERE LEFT(L.Name,1) NOT IN('B','M','D') 
AND RIGHT(S.Establishment,2)='BC'
ORDER BY Site

SELECT T.Name,Age,PhoneNumber,Nationality,
CASE 
WHEN TBR.BonusPrizeId IS NULL THEN '(no bonus prize)'
WHEN TBR.BonusPrizeId IS NOT NULL THEN BR.Name
END
AS 'Reward'
FROM Tourists T
LEFT JOIN TouristsBonusPrizes TBR ON T.Id=TBR.TouristId
LEFT JOIN BonusPrizes BR ON TBR.BonusPrizeId=BR.Id
ORDER BY T.Name


SELECT DISTINCT SUBSTRING(T.Name,CHARINDEX(' ', T.Name) + 1,
LEN(T.Name) - CHARINDEX(' ', T.Name)) AS Lastname,
Nationality,Age,PhoneNumber
FROM Tourists T 
JOIN  SitesTourists ST ON T.Id=ST.TouristId
JOIN Sites S ON ST.SiteId=S.Id
JOIN Categories C ON S.CategoryId=C.Id
WHERE C.Name='History and archaeology'
ORDER BY Lastname


--FUNCTION

CREATE FUNCTION udf_GetTouristsCountOnATouristSite 
(
@Site varchar(50)
)
RETURNS int
AS
BEGIN 
DECLARE @CountTourists int;
SET @CountTourists=
(
SELECT COUNT(T.Id) FROM Sites S
JOIN SitesTourists ST ON S.Id=ST.SiteId
JOIN Tourists T ON ST.TouristId=T.Id
WHERE S.Name=@Site
)
Return @CountTourists
END


SELECT dbo.udf_GetTouristsCountOnATouristSite ('Regional History Museum – Vratsa')


--PROCEDURE


CREATE PROCEDURE usp_AnnualRewardLottery
(
@TouristName varchar(50)
)
AS

DECLARE @CountSites int;
SET @CountSites=
(
SELECT Count(ST.SiteId) FROM Tourists T 
JOIN SitesTourists ST ON T.Id=ST.TouristId
WHERE T.Name=@TouristName
)
UPDATE Tourists
SET REWARD=
CASE
WHEN @CountSites>=100 THEN 'Gold badge'
WHEN @CountSites>=50 THEN 'Silver badge'
WHEN @CountSites>=25 THEN 'Bronze badge'
END
WHERE Name=@TouristName

SELECT Name,Reward FROM Tourists
WHERE Name=@TouristName


EXEC usp_AnnualRewardLottery 'Teodor Petrov'

