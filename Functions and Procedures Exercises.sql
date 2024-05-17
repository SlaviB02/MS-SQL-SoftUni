USE SoftUni

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName,LastName FROM Employees
WHERE Salary>35000

Exec usp_GetEmployeesSalaryAbove35000

CREATE PROC usp_GetEmployeesSalaryAboveNumber
@number Decimal(18,4)
AS 
SELECT FirstName,LastName FROM Employees
WHERE Salary>=@number

Exec usp_GetEmployeesSalaryAboveNumber 48100

Create Proc usp_GetTownsStartingWith
@string varchar(60)
AS
Select Name AS 'Town' FROM Towns
Where LEFT(Name,LEN(@string))=@string

EXEC usp_GetTownsStartingWith 'b'

CREATE Proc usp_GetEmployeesFromTown
@townName varchar(60)
AS
SELECT FirstName,LastName FROM Employees A JOIN Addresses B 
ON A.AddressID=B.AddressID JOIN Towns C ON B.TownID=C.TownID
WHERE C.Name=@townName


EXEC usp_GetEmployeesFromTown 'Sofia'

CREATE Function ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS Varchar(10)
AS
BEGIN
Declare @Level varchar(10)
IF @salary<30000 
SET @Level='Low'

IF  @salary BETWEEN 30000 AND 50000 
SET @Level='Average'

IF @salary>50000 
SET @Level='High'



Return @Level

END

SELECT dbo.ufn_GetSalaryLevel(13500)  

CREATE PROC usp_EmployeesBySalaryLevel
@Level varchar(10)
AS
SELECT FirstName,LastName FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary)=@Level

EXEC usp_EmployeesBySalaryLevel 'High'

CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
DELETE FROM Employees
WHERE DepartmentID=@departmentId

USE Bank

CREATE PROC usp_GetHoldersFullName
AS
SELECT FirstName+' '+LastName AS 'Full Name ' FROM AccountHolders

EXEC usp_GetHoldersFullName

CREATE PROC usp_GetHoldersWithBalanceHigherThan
@number decimal(18,2)
AS
SELECT FirstName,LastName FROM Accounts A JOIN AccountHolders B ON A.AccountHolderId=B.Id
GROUP BY AccountHolderId,FirstName,LastName
Having SUM(Balance)>@number
ORDER BY FirstName,LastName

EXEC usp_GetHoldersWithBalanceHigherThan 0

CREATE FUNCTION ufn_CalculateFutureValue(@sum decimal(18,2),@InterestRate float,@years int)
RETURNS decimal(18,4)
AS
BEGIN
DECLARE @res decimal(18,4)
SET @res=@sum*POWER((1+@InterestRate),@years)
Return @res
END

CREATE PROC usp_CalculateFutureValueForAccount
@AccId int,@InterestRate float
AS
SELECT B.Id AS 'Account Id',FirstName,LastName,Balance AS 'Current Balance',dbo.ufn_CalculateFutureValue(Balance,@InterestRate,5) AS 'Balance in 5 years'
FROM Accounts A JOIN AccountHolders B ON A.AccountHolderId=B.Id
WHERE A.Id=@AccId

exec usp_CalculateFutureValueForAccount 1,0.1




