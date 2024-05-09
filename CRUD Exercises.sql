SELECT * FROM Departments

SELECT Name FROM Departments

SELECT FirstName,LastName,Salary FROM Employees

SELECT FirstName,MiddleName,LastName FROM Employees

SELECT FirstName+'.'+LastName+'@softuni.bg' AS 'Full Email Address'  FROM Employees

SELECT Distinct Salary  FROM Employees 

SELECT * FROM Employees
WHERE JobTitle='Sales Representative'

SELECT FirstName,LastName,JobTitle FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

SELECT FirstName+' '+MiddleName+' '+LastName AS 'Full Name' FROM Employees
WHERE SALARY IN (25000,14000,12500,23600)

SELECT FirstName,LastName FROM Employees
WHERE ManagerID IS NULL;

SELECT FirstName,LastName,Salary FROM Employees
WHERE salary>50000
ORDER BY Salary DESC

SELECT top(5) FirstName,LastName  FROM Employees
ORDER BY Salary DESC

SELECT FirstName,LastName FROM Employees
WHERE DepartmentID!=4

SELECT * FROM Employees
ORDER BY Salary DESC,FirstName ASC,LastName DESC, MiddleName ASC

CREATE VIEW V_EmployeesSalaries AS
SELECT FirstName,LastName,Salary FROM Employees

CREATE VIEW V_EmployeeNameJobTitle AS
SELECT FirstName+' '+MiddleName+' '+LastName AS 'Full Name',JobTitle AS 'Job Title' FROM Employees

SELECT DISTINCT JobTitle FROM Employees

SELECT top(10) * FROM Projects
ORDER BY StartDate ASC,Name ASC

SELECT top(7) FirstName,LastName,HireDate FROM Employees
ORDER BY HireDate DESC

UPDATE Employees
SET salary=salary+(salary*12/100)
WHERE DepartmentID IN (1,2,4,11)
SELECT salary FROM Employees



SELECT PeakName FROM Peaks
ORDER BY PeakName

SELECT top 30 CountryName,Population FROM Countries
WHERE ContinentCode='EU'
ORDER BY Population DESC,CountryName ASC

SELECT CountryName,CountryCode,
CASE
WHEN CurrencyCode='EUR' THEN 'Euro'
ELSE 'Not Euro'
END AS 'Currency' 
FROM Countries
ORDER BY CountryName

USE Diablo

SELECT Name FRom Characters
ORDER BY Name