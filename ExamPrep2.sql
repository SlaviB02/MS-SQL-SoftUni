CREATE DATABASE Boardgames

USE Boardgames

--CREATE

CREATE TABLE Categories
(
Id int identity primary key,
Name varchar(50) not null
);

Create Table Addresses(
Id int identity primary key,
StreetName nvarchar(100) not null,
StreetNumber int not null,
Town varchar(30) not null,
Country varchar(50) not null,
ZIP int not null
);

CREATE TABLE Publishers(
Id int identity primary key,
Name varchar(30) not null,
AddressId int not null,
Foreign key (AddressId) REFERENCES Addresses(Id),
Website nvarchar(40),
Phone nvarchar(20)
);

CREATE TABLE PlayersRanges(
Id int identity primary key,
PlayersMin int not null,
PlayersMax int not null
);

CREATE TABLE Boardgames(
Id int identity primary key,
Name nvarchar(30) not null,
YearPublished int not null,
Rating decimal(18,2) not null,
CategoryId int not null,
Foreign key(CategoryId) REFERENCES Categories(Id),
PublisherId int not null,
Foreign key(PublisherId) REFERENCES Publishers(Id),
PlayersRangeId int not null,
Foreign key(PlayersRangeId)REFERENCES PlayersRanges(Id)
);

CREATE TABLE Creators
(
Id int identity primary key,
FirstName nvarchar(30) not null,
LastName nvarchar(30) not null,
Email nvarchar(30) not null
);

CREATE TABLE CreatorsBoardgames(
CreatorId int not null,
BoardgameId int not null,
primary key(CreatorId,BoardgameId),
Foreign key (CreatorId) REFERENCES Creators(Id),
Foreign key (BoardgameId) REFEREnces Boardgames(Id)
);


--INSERT

INSERT INTO Boardgames
VALUES('Deep Blue',2019,5.67,1,15,7),
('Paris',2016,9.78,7,1,5),
('Catan: Starfarers',2021,9.87,7,13,6),
('Bleeding Kansas',2020,3.25,3,7,4),
('One Small Step',2019,5.75,5,9,2)

Insert into Publishers
Values('Agman Games',5,'www.agmangames.com','+16546135542'),
('Amethyst Games',7,'www.amethystgames.com','+15558889992'),
('BattleBooks',13,'www.battlebooks.com','+12345678907')


--UPDATE

UPDATE PlayersRanges
SET PlayersMax+=1
WHERE Id=1

UPDATE Boardgames
SET Name=Name + 'V2'
WHERE YearPublished>=2020


--DELETE

DELETE FROM CreatorsBoardgames
WHERE BoardgameId IN (1,16,31,47)

DELETE FROM Boardgames
WHERE PublisherId=1 OR PublisherId=16

DELETE FROM Publishers
WHERE AddressId=5

DELETE FROM Addresses
WHERE Town LIKE 'L%'



--SELECT

SELECT Name,Rating FROM Boardgames
ORDER BY YearPublished,Name DESC

SELECT BG.Id,BG.Name,YearPublished,C.Name AS 'CategoryName' FROM 
Boardgames BG JOIN Categories C ON BG.CategoryId=C.Id
WHERE C.Name='Strategy Games' OR C.Name='Wargames'
ORDER BY YearPublished DESC

SELECT Id,CONCAT(C.FirstName,' ',C.LastName) AS 'CreatorName',Email 
FROM Creators C LEFT JOIN CreatorsBoardgames CBG ON C.Id=CBG.CreatorId
WHERE CBG.BoardgameId IS NULL
ORDER BY CreatorName

SELECT top(5) BG.Name,Rating,C.Name AS 'CategoryName' 
FROM Boardgames BG JOIN Categories C ON BG.CategoryId=C.Id 
JOIN PlayersRanges PR ON BG.PlayersRangeId=PR.Id
WHERE (Rating>7.00 AND BG.Name LIKE '%a%')
OR (Rating>7.50 AND PR.PlayersMin=2 AND PR.PlayersMax=5)
ORDER BY BG.Name,Rating DESC

SELECT CONCAT(C.FirstName,' ',C.LastName) AS 'FullName',
Email,MAX(Rating) AS 'Rating'  FROM Creators C 
JOIN CreatorsBoardgames CBG ON C.Id=CBG.CreatorId
JOIN Boardgames BG ON CBG.BoardgameId=BG.Id
WHERE RIGHT(Email,4)='.com'
GROUP BY Email,FirstName,LastName
ORDER BY FullName

SELECT LastName,CEILING(AVG(Rating)) AS 'AverageRating',
P.Name AS 'PublisherName'
FROM Creators C 
LEFT JOIN CreatorsBoardgames CBG ON C.Id=CBG.CreatorId
JOIN Boardgames BG ON CBG.BoardgameId=BG.Id
JOIN Publishers P ON BG.PublisherId=P.Id
WHERE CBG.BoardgameId IS NOT NULL AND PublisherId=5
GROUP BY LastName,P.Name
ORDER BY AVG(RATING) DESC



--FUNCTION

CREATE FUNCTION udf_CreatorWithBoardgames(@name nvarchar(50))
RETURNS int
AS
BEGIN
Declare @games int;
Declare @creatorId int;
SET @creatorId=(
SELECT id FROM Creators
WHERE @name=FirstName
)
SET @games=(
SELECT COUNT(*) FROM Boardgames BG JOIN CreatorsBoardgames CBG
ON BG.Id=CBG.BoardgameId
WHERE CBG.CreatorId=@creatorId
)
RETURN @games
END



SELECT dbo.udf_CreatorWithBoardgames('Bruno')



--PROCEDURE

CREATE PROCEDURE usp_SearchByCategory(@category varchar(50))
AS
SELECT BG.Name,YearPublished,Rating,C.Name AS 'CategoryName',
P.Name AS 'PublisherName',CONCAT(PlayersMin,' people') AS 'MinPlayers',
CONCAT(PlayersMax,' people') AS 'MaxPlayers'
FROM Boardgames BG 
JOIN Categories C ON BG.CategoryId=C.Id
JOIN PlayersRanges PR ON BG.PlayersRangeId=PR.Id
JOIN Publishers P ON BG.PublisherId=P.Id
WHERE @category=C.Name
ORDER BY PublisherName,YearPublished DESC


EXEC usp_SearchByCategory 'Wargames'



