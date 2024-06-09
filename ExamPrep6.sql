CREATE DATABASE Zoo

USE Zoo

--CREATE

CREATE TABLE Owners
(
Id int identity primary key,
Name varchar(50) not null,
PhoneNumber varchar(15) not null,
Address varchar(50)
)

CREATE TABLE AnimalTypes
(
Id int identity primary key,
AnimalType varchar(30) not null
)

CREATE TABLE Cages
(
Id int identity primary key,
AnimalTypeId int not null foreign key
REFERENCES AnimalTypes(Id)
)

CREATE TABLE Animals
(
Id int identity primary key,
Name varchar(30) not null,
BirthDate Date not null,
OwnerId int  foreign key
REFERENCES Owners(Id),
AnimalTypeId int not null foreign key
REFERENCES AnimalTypes(Id)
)




CREATE TABLE AnimalsCages
(
CageId int not null foreign key
references Cages(Id),
AnimalId int not null foreign key
REFERENCES Animals(Id),
primary key(CageId,AnimalId)
)


CREATE TABLE VolunteersDepartments
(
Id int identity primary key,
DepartmentName varchar(30) not null
)

CREATE TABLE Volunteers
(
Id int identity primary key,
Name varchar(50) not null,
PhoneNumber varchar(15) not null,
Address varchar(50),
AnimalId int foreign key
references Animals(Id),
DepartmentId int not null foreign key
references VolunteersDepartments(Id)
)

--INSERT

INSERT INTO Volunteers
VALUES('Anita Kostova','0896365412','Sofia, 5 Rosa str.',15,1),
('Dimitur Stoev','0877564223',null,42,4),
('Kalina Evtimova','0896321112','Silistra, 21 Breza str.',9,7),
('Stoyan Tomov','0898564100','Montana, 1 Bor str.',18,8),
('Boryana Mileva','0888112233',null,31,5)

INSERT INTO Animals
VALUES('Giraffe','2018-09-21',21,1),
('Harpy Eagle','2015-04-17',15,3),
('Hamadryas Baboon','2017-11-02',null,1),
('Tuatara','2021-06-30',2,4)

--UPDATE

UPDATE Animals
SET OwnerId=4
WHERE OwnerId IS NULL


--DELETE

DELETE FROM Volunteers
WHERE DepartmentId=2


DELETE FROM VolunteersDepartments
WHERE ID=2


--SELECT


SELECT Name,PhoneNumber,Address,AnimalId,DepartmentId FROM Volunteers
ORDER BY Name,AnimalId,DepartmentId


SELECT Name,ATY.AnimalType,
FORMAT(BirthDate,'dd.MM.yyyy') AS 'BirthDate' FROM Animals A 
JOIN AnimalTypes ATY ON A.AnimalTypeId=ATY.Id
ORDER BY Name


SELECT top(5) O.Name AS 'Owner',
Count(*) AS 'CountOfAnimals'  FROM Owners O 
JOIN Animals A ON O.Id=A.OwnerId
GROUP BY O.Name
ORDER BY CountOfAnimals DESC,Owner


SELECT CONCAT(O.Name,'-',A.Name) AS 'OwnersAnimals',
PhoneNumber,CageId
FROM Owners O 
JOIN Animals A ON O.Id=A.OwnerId
JOIN AnimalsCages AC ON A.Id=AC.AnimalId
WHERE A.AnimalTypeId=1
ORDER BY O.Name,A.Name DESC


SELECT V.Name,PhoneNumber,SUBSTRING(Address,CHARINDEX('Sofia', Address) + 7,
LEN(Address) - CHARINDEX('Sofia', Address)) AS 'Address' FROM Volunteers V
JOIN VolunteersDepartments VD ON V.DepartmentId=VD.Id
WHERE VD.DepartmentName='Education program assistant'
AND Address LIKE '%Sofia%'
ORDER BY V.Name 


SELECT Name,YEAR(BirthDate) AS 'BirthYear',AnimalType
FROM Animals A JOIN AnimalTypes ATY ON A.AnimalTypeId=ATY.Id
WHERE OwnerId IS NULL AND DATEDIFF(year,BirthDate,'01-01-2022')<5 AND AnimalTypeId!=3
ORDER BY Name

--FUNCTION


CREATE FUNCTION udf_GetVolunteersCountFromADepartment 
(
@VolunteersDepartment varchar(50)
)
RETURNS int
AS 
BEGIN
DECLARE @CountV int;
SET @CountV=
(
SELECT Count(*) FROM Volunteers V 
JOIN VolunteersDepartments VD ON V.DepartmentId=VD.Id
WHERE DepartmentName=@VolunteersDepartment
)
Return @CountV
END


SELECT dbo.udf_GetVolunteersCountFromADepartment ('Education program assistant')



--PROCEDURE


CREATE PROCEDURE usp_AnimalsWithOwnersOrNot
(
@AnimalName varchar(50)
)
AS
SELECT A.Name,
CASE
WHEN OwnerId IS NULL THEN 'For adoption'
WHEN OwnerId IS NOT NULL THEN O.Name
END
AS 'OwnersName'
FROM Animals A LEFT JOIN Owners O ON A.OwnerId=O.Id
WHERE A.Name=@AnimalName


EXEC usp_AnimalsWithOwnersOrNot 'Pumpkinseed Sunfish'

EXEC usp_AnimalsWithOwnersOrNot 'Hippo'
