CREATE DATABASE TableRelationsDemos

CREATE TABLE Passports (
       PassportID INT NOT NULL IDENTITY(101, 1),
       PassportNumber CHAR(8) NOT NULL,

       CONSTRAINT PK_Passports PRIMARY KEY (PassportID)
)

CREATE TABLE Persons (
       PersonID INT NOT NULL IDENTITY(1, 1),
       FirstName NVARCHAR(50) NOT NULL,
       Salary DECIMAL(9, 2) NOT NULL,
       PassportID INT NOT NULL,

       CONSTRAINT PK_Persons PRIMARY KEY (PersonID),
       CONSTRAINT FK_Persons_Passports FOREIGN KEY (PassportID) REFERENCES Passports(PassportID),
)

INSERT INTO Passports (PassportNumber) 
       VALUES ('N34FG21B'),
              ('K65LO4R7'),
              ('ZE657QP2')

INSERT INTO Persons (FirstName, Salary, PassportID) 
       VALUES ('Roberto', 43300, 102),
              ('Tom', 56100, 103),
              ('Yana', 60200, 101)

--------------------------------
CREATE TABLE Manufacturers (
			ManufacturerID INT NOT NULL IDENTITY,
			[Name] NVARCHAR(30) NOT NULL,
			EstablishedOn DATE NOT NULL

			CONSTRAINT PK_Manufacturers
			PRIMARY KEY (ManufacturerID)
);

CREATE TABLE Models (
		ModelID INT IDENTITY(101, 1),
		[Name] NVARCHAR(30) NOT NULL,
		ManufacturerID INT NOT NULL,

		CONSTRAINT PK_Models
		PRIMARY KEY (ModelID),

		CONSTRAINT FK_Models_Manufacturers
		FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers(ManufacturerID)
);

INSERT INTO Manufacturers (Name, EstablishedOn) 
       VALUES ('BMW', '07/03/1916'),
              ('Tesla', '01/01/2003'),
              ('Lada', '01/05/1966')

INSERT INTO Models (Name, ManufacturerID) 
       VALUES ('X1', 1),
              ('i6', 1),
              ('Model S', 2),
	      ('Model X', 2),
	      ('Model 3', 2),
	      ('Nova', 3)

-----------------------------------------
CREATE TABLE Students (
		StudentID INT IDENTITY NOT NULL,
		[Name] NVARCHAR(50) NOT NULL

		CONSTRAINT PK_Students
		PRIMARY KEY (StudentID)
);

CREATE TABLE Exams (
		ExamID INT NOT NULL IDENTITY(101, 1),
		[Name] NVARCHAR(50) NOT NULL

		CONSTRAINT PK_Exams
		PRIMARY KEY (ExamID)
);

CREATE TABLE StudentsExams (
		StudentID INT NOT NULL,
		ExamID INT NOT NULL

		CONSTRAINT PK_StudentsExams
		PRIMARY KEY(StudentID, ExamID),

		CONSTRAINT PK_StudentsExams_Exams
		FOREIGN KEY (ExamID) REFERENCES Exams(ExamID),

		CONSTRAINT PK_StudentsExams_Students
		FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

INSERT INTO Students (Name)
       VALUES ('Mila'),
              ('Toni'),
              ('Ron')

INSERT INTO Exams (Name)
       VALUES ('SpringMVC'),
              ('Neo4j'),
              ('Oracle 11g')

INSERT INTO StudentsExams (StudentID, ExamID)
       VALUES (1, 101),
              (1, 102),
              (2, 101),
              (3, 103),
              (2, 102),
              (2, 103)

--------------------------------------------
CREATE TABLE Teachers (
       TeacherID INT NOT NULL IDENTITY(101, 1),
       Name NVARCHAR(50) NOT NULL,
       ManagerID INT,

       CONSTRAINT PK_Teachers PRIMARY KEY (TeacherID),
       CONSTRAINT FK_Teachers FOREIGN KEY (ManagerID) REFERENCES Teachers(TeacherID)
);

INSERT INTO Teachers (Name, ManagerID)
       VALUES ('John', NULL),
              ('Maya', 106),
              ('Silvia', 106),
              ('Ted', 105),
              ('Mark', 101),
              ('Greta', 101)

--------------------------------------------------
CREATE TABLE Majors (
		MajorID INT NOT NULL IDENTITY,
		[Name] NVARCHAR(50) NOT NULL

		CONSTRAINT PK_Majors
		PRIMARY KEY (MajorID)
);

CREATE TABLE Students (
	   StudentID INT NOT NULL IDENTITY(1, 1),
       StudentNumber NVARCHAR(10) NOT NULL,
       StudentName NVARCHAR(50) NOT NULL,
       MajorID INT NOT NULL,

       CONSTRAINT PK_Students PRIMARY KEY (StudentID),
       CONSTRAINT FK_Students_Majors FOREIGN KEY (MajorID) REFERENCES Majors(MajorID)
);

CREATE TABLE Subjects (
	   SubjectID INT NOT NULL IDENTITY(1, 1),
       SubjectName NVARCHAR(50) NOT NULL,

       CONSTRAINT PK_Subjects PRIMARY KEY (SubjectID)
);

CREATE TABLE Payments (
	   PaymentID INT NOT NULL IDENTITY(1, 1),
       PaymentDate DATE NOT NULL,
       PaymentAmount DECIMAL(9, 2) NOT NULL,
       StudentID INT NOT NULL,

       CONSTRAINT PK_Payments PRIMARY KEY (PaymentID),
       CONSTRAINT FK_Payments_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

CREATE TABLE Agenda (
	   StudentID INT NOT NULL,
       SubjectID INT NOT NULL,

       CONSTRAINT PK_Agenda PRIMARY KEY (StudentID, SubjectID),
       CONSTRAINT FK_Agenda_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
       CONSTRAINT FK_Agenda_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

------------------------------------
CREATE TABLE Cities (
       CityID INT NOT NULL IDENTITY(1, 1),
       Name VARCHAR(50) NOT NULL,

       CONSTRAINT PK_Cities PRIMARY KEY (CityID)
)

CREATE TABLE Customers (
       CustomerID INT NOT NULL IDENTITY(1, 1),
       Name VARCHAR(50) NOT NULL,
       Birthday DATE NOT NULL,
       CityID INT NOT NULL,

       CONSTRAINT PK_Customers PRIMARY KEY (CustomerID),
       CONSTRAINT FK_Customers_Cities FOREIGN KEY (CityID) REFERENCES Cities(CityID)
)

CREATE TABLE Orders (
       OrderID INT NOT NULL IDENTITY(1, 1),
       CustomerID INT NOT NULL,

       CONSTRAINT PK_Orders PRIMARY KEY (OrderID),
       CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)

CREATE TABLE ItemTypes (
       ItemTypeID INT NOT NULL IDENTITY(1, 1),
       Name VARCHAR(50) NOT NULL,

       CONSTRAINT PK_ItemTypes PRIMARY KEY (ItemTypeID)
)

CREATE TABLE Items (
       ItemID INT NOT NULL IDENTITY(1, 1),
       Name VARCHAR(50) NOT NULL,
       ItemTypeID INT NOT NULL,

       CONSTRAINT PK_Items PRIMARY KEY (ItemID),
       CONSTRAINT FK_Items_ItemTypes FOREIGN KEY (ItemTypeID) REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE OrderItems (
       OrderID INT NOT NULL,
       ItemID INT NOT NULL,

       CONSTRAINT PK_OrderItems PRIMARY KEY (OrderID, ItemID),
       CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
       CONSTRAINT FK_OrderItems_Items FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
)