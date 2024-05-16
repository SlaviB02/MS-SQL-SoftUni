USE Gringotts

SELECT Count(*) AS 'Count' FROM WizzardDeposits

SELECT Max(MagicWandSize) AS 'LongestMagicWand' FROM WizzardDeposits

SELECT DepositGroup, Max(MagicWandSize) AS 'LongestMagicWand' FROM WizzardDeposits
GROUP BY DepositGroup

SELECT DepositGroup, IsDepositExpired,AVG(DepositInterest) AS 'AverageInterest' FROM WizzardDeposits
WHERE DepositStartDate>'1985.01.01'
GROUP BY IsDepositExpired,DepositGroup
ORDER BY DepositGroup DESC,IsDepositExpired

USE SoftUni

SELECT DepartmentID,SUM(Salary)  AS 'TotalSalary' FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

SELECT DepartmentID,Min(Salary) AS 'MinimumSalary' FROM Employees
WHERE DepartmentID IN (2,5,7) AND HireDate>'2000.01.01'
GROUP BY DepartmentID


SELECT * INTO NewTable FROM Employees
WHERE Salary>30000

DELETE FROM NewTable
WHERE ManagerID=42;

UPDATE NewTable
SET Salary+=5000
WHERE DepartmentID=1

SELECT DepartmentID,AVG(Salary)  AS 'AverageSalary' FROM NewTable
GROUP BY DepartmentID

SELECT DepartmentID,Max(Salary) AS 'MaxSalary' FROM Employees
GROUP BY DepartmentID
HAVING MAX(SALARY) NOT BETWEEN 30000 AND 70000

SELECT Count(*) AS 'Count' FROM Employees
WHERE ManagerID IS NULL
