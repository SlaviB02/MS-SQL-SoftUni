USE SoftUni

SELECT FirstName,LastName FROM Employees
WHERE FirstName LIKE 'Sa%'

SELECT FirstName,LastName FROM Employees
WHERE LastName LIKE '%ei%'

SELECT FirstName FROM Employees
WHERE (DepartmentID=3 OR DepartmentID=10) AND DATEPART(YEAR,HireDate) BETWEEN 1995 AND 2005

SELECT FirstName,LastName FROM Employees
WHERE JobTitle NOT LIKE'%engineer%'

SELECT Name FROM Towns
WHERE LEN(Name)=5 OR LEN(Name)=6
ORDER BY Name

SELECT TownID,Name FROM Towns
WHERE Name LIKE '[MKBE]%'
ORDER BY Name

SELECT TownID,Name FROM Towns
WHERE Name LIKE '[^RBD]%'
ORDER BY Name

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName,LastName FROM Employees
WHERE DATEPART(YEAR,HireDate)>2000

SELECT FirstName,LastName FROM Employees
WHERE LEN(LastName)=5

SELECT EmployeeID,FirstName,LastName,Salary,
DENSE_RANK() OVER (
	PARTITION BY Salary
	ORDER BY EmployeeID
) AS Rank
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

SELECT * FROM
(
SELECT EmployeeID,FirstName,LastName,Salary,
DENSE_RANK() OVER (
	PARTITION BY Salary
	ORDER BY EmployeeID
) AS Rank
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
) AS myTable
WHERE Rank=2
ORDER BY Salary DESC

USE Geography

SELECT CountryName,IsoCode FROM Countries
WHERE CountryName LIKE '%A%A%A%'
ORDER BY IsoCode

USE Diablo

SELECT top(50) Name,FORMAT(Start,'yyyy-MM-dd') AS Start FROM Games
WHERE DATEPART(YEAR,Start)=2011 OR DATEPART(YEAR,Start)=2012
ORDER BY Start ASC,Name ASC

SELECT Username,SUBSTRING(Email,CHARINDEX('@', Email)+1,LEN(Email)-CHARINDEX('@', Email)) AS 'Email Provider'  FROM Users
ORDER BY [Email Provider],Username

SELECT Username,IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

SELECT Name AS Game,
CASE
WHEN DATEPART(hour,Start) BETWEEN 0 AND 11 THEN 'Morning'
WHEN DATEPART(hour,Start) BETWEEN 12 AND 17 THEN 'Afternoon'
WHEN DATEPART(hour,Start) BETWEEN 18 AND 23 THEN 'Evening'
END AS 'Part of the Day',
CASE
WHEN Duration<=3 THEN 'Extra Short'
WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
WHEN Duration>6 THEN 'Long'
WHEN Duration IS NULL THEN 'Extra Long'
END as 'Duration' FROM Games
ORDER BY Name,[Duration],[Part of the Day]

USE Orders

SELECT ProductName,OrderDate,
DATEADD(day,3,OrderDate) AS 'Pay Due',
DATEADD(MONTH,1,OrderDate) AS 'Deliver Due' FROM Orders

