CREATE TABLE Passports(
PassportID int identity primary key,
PassportNumber varchar(20) not null
);

CREATE TABLE Persons(
PersonID int identity primary key,
FirstName varchar(30) not null,
Salary decimal(2) not null,
PassportID int not null,
Foreign key (PassportID) REFERENCES Passports(PassportID)
);

CREATE TABLE Manufacturers
(
             ManufacturerID INT IDENTITY primary key,
             Name VARCHAR(50) NOT NULL,
             EstablishedOn  DATE,           
);

CREATE TABLE Models
(
             ModelID  INT primary key,
             Name  VARCHAR(50) NOT NULL,
             ManufacturerID INT NOT NULL,
             FOREIGN KEY(ManufacturerID) REFERENCES Manufacturers(ManufacturerID)
);

CREATE TABLE Students(
StudentID INT IDENTITY PRIMARY KEY,
Name NVARCHAR(255) NOT NULL
); 

CREATE TABLE Exams(
ExamID INT PRIMARY KEY,
Name NVARCHAR(255) NOT NULL

);

CREATE TABLE StudentsExams
(
             StudentID INT NOT NULL,
              ExamID    INT NOT NULL,
              PRIMARY KEY(StudentID, ExamID),
             FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
             FOREIGN KEY(ExamID) REFERENCES Exams(ExamID)
);

CREATE TABLE Teachers(
TeacherID int primary key,
Name varchar(20) not null,
ManagerID int ,
Foreign Key (ManagerID) REFERENCES Teachers(TeacherID)
);


CREATE TABLE ItemTypes(
ItemTypeID int identity primary key,
Name varchar(20) not null
);

CREATE TABLE Items(
ItemID int identity primary key,
Name varchar(20) not null,
ItemTypeID int not null,
Foreign key(ItemTypeID) REFERENCES ItemTypes(ItemTypeID)
);

CREATE TABLE Cities(
CityID int identity primary key,
Name varchar(20) not null,
);

CREATE TABLE Customers(
CustomerID int identity primary key,
Name varchar(20) not null,
Birthday date not null,
CityID int not null,
Foreign key(CityID) REFERENCES Cities(CityID)
);

CREATE TABLE Orders(
OrderID int identity primary key,
CustomerID int not null,
Foreign key(CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems(
OrderID int not null,
ItemID int not null,
primary key(OrderID,ItemID),
Foreign key(OrderID) REFERENCES Orders(OrderID),
Foreign key(ItemID) REFERENCES Items(ItemID)
);

CREATE TABLE Majors
(
             MajorID INT PRIMARY KEY,
             Name NVARCHAR(50),
            
);

CREATE TABLE Students
(
             StudentID INT PRIMARY KEY,
             StudentNumber INT NOT NULL,
             StudentName   NVARCHAR(255),
             MajorID INT,
             FOREIGN KEY(MajorID) REFERENCES Majors(MajorID)
);

CREATE TABLE Payments
(
             PaymentID  INT PRIMARY KEY,
             PaymentDate   DATE ,
             PaymentAmount DECIMAL(2) NOT NULL,
             StudentID     INT NOT NULL,
             FOREIGN KEY(StudentID) REFERENCES Students(StudentID)
);

CREATE TABLE Subjects
(
             SubjectID   INT PRIMARY KEY,
             SubjectName NVARCHAR(255) NOT NULL,
);

CREATE TABLE Agenda
(
             StudentID INT NOT NULL,
             SubjectID INT NOT NULL,
             PRIMARY KEY(StudentID, SubjectID),
             FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
             FOREIGN KEY(SubjectID) REFERENCES Subjects(SubjectID)
); 

USE Geography

SELECT MountainRange,PeakName,Elevation 
FROM Mountains A JOIN Peaks B ON A.Id=B.MountainId
WHERE MountainRange='Rila'
ORDER BY Elevation DESC
