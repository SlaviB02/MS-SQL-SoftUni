USE SoftUni

SELECT top(5) EmployeeID,JobTitle,B.AddressID,AddressText  
FROM Employees A JOIN Addresses B ON A.AddressID=B.AddressID
ORDER BY B.AddressID

SELECT top(50) FirstName,LastName,Towns.Name AS Town,AddressText  
FROM Employees A JOIN Addresses B ON A.AddressID=B.AddressID JOIN Towns ON B.TownID=Towns.TownID
ORDER BY FirstName,LastName

SELECT EmployeeID,FirstName,LastName,B.Name 
FROM Employees A JOIN Departments B ON A.DepartmentID=B.DepartmentID 
WHERE B.Name='Sales'
ORDER BY EmployeeID

SELECT top(5) EmployeeID,FirstName,Salary,B.Name 
FROM Employees A JOIN Departments B ON A.DepartmentID=B.DepartmentID 
WHERE Salary>15000
ORDER BY B.DepartmentID

SELECT top(3) A.EmployeeID,FirstName 
FROM Employees A FULL JOIN EmployeesProjects B ON A.EmployeeID=B.EmployeeID
WHERE B.EmployeeID IS NULL
Order BY EmployeeID

SELECT FirstName,LastName,HireDate,B.Name AS DeptName 
FROM Employees A JOIN Departments B ON A.DepartmentID=B.DepartmentID
WHERE HireDate>'1.1.1999' AND (B.Name='Sales' OR B.Name='Finance')
ORDER BY HireDate

SELECT top(5) A.EmployeeID,FirstName, C.Name as 'ProjectName' 
FROM Employees A JOIN EmployeesProjects B ON A.EmployeeID=B.EmployeeID 
JOIN Projects C ON B.ProjectID=C.ProjectID
WHERE C.StartDate>'2002.08.13' AND C.EndDate IS NULL 
ORDER BY A.EmployeeID

SELECT A.EmployeeID,FirstName,
CASE
WHEN C.StartDate>='2005' THEN NULL
ELSE C.Name
END AS 'ProjectName'
FROM Employees A JOIN EmployeesProjects B ON A.EmployeeID=B.EmployeeID 
JOIN Projects C ON B.ProjectID=C.ProjectID
WHERE A.EmployeeID=24

SELECT A.EmployeeID,A.FirstName,B.EmployeeID AS 'ManagerID',B.FirstName AS 'ManagerName' 
FROM Employees A JOIN Employees B ON B.EmployeeID=A.ManagerID
WHERE A.ManagerID=3 OR A.ManagerID=7
ORDER BY A.EmployeeID

SELECT top(50) A.EmployeeID,A.FirstName+' '+A.LastName AS 'EmployeeName',B.FirstName+' '+B.LastName AS 'ManagerName',C.Name AS 'DepartmentName'
FROM Employees A INNER JOIN Employees B ON B.EmployeeID=A.ManagerID INNER JOIN Departments C ON C.DepartmentID=A.DepartmentID
ORDER BY A.EmployeeID

SELECT Min(a.AverageSalary) AS 'MinAverageSalary' 
FROM 
(SELECT e.DepartmentID,
 AVG(e.Salary) AS AverageSalary
 FROM Employees AS e
 GROUP BY e.DepartmentID
) AS aUSE GeographySELECT CountryCode,MountainRange,PeakName,Elevation FROM MountainsCountries A JOIN Mountains B ON A.MountainId=B.Id JOIN Peaks C ON B.Id=C.MountainIdWHERE CountryCode='BG' AND Elevation>2835ORDER BY Elevation DESCSELECT A.CountryCode,Count(C.MountainRange) AS 'MountainRanges'FROM Countries A JOIN MountainsCountries B ON A.CountryCode=B.CountryCode JOIN Mountains C ON B.MountainId=C.IdWHERE A.CountryName IN ('United States', 'Russia', 'Bulgaria')GROUP BY A.CountryCodeSELECT top(5) CountryName,RiverNameFROM Countries A LEFT JOIN CountriesRivers B ON A.CountryCode=B.CountryCode LEFT JOIN Rivers C ON B.RiverId=C.IdWHERE A.ContinentCode='AF'ORDER BY CountryNameSELECT Count(A.CountryCode) AS 'Count' FROM Countries A LEFT JOIN MountainsCountries B ON A.CountryCode=B.CountryCodeWHERE B.MountainId IS NULL