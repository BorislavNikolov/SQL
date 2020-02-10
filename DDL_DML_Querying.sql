--CREATE DATABASE CarShowroom;

CREATE TABLE Clients (
	Id INT IDENTITY PRIMARY KEY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Gender CHAR(1),
	BirthDate DATETIME,
	CreditCard NVARCHAR(30) NOT NULL,
	CardValidity DATETIME,
	Email NVARCHAR(50) NOT NULL 
);

CREATE TABLE Towns (
	Id INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(50) NOT NULL
);

CREATE TABLE Offices (
	Id INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(40) NOT NULL,
	ParkingPlaces INT,
	TownId INT NOT NULL REFERENCES Towns(Id)
);

CREATE TABLE Models (
	Id INT IDENTITY PRIMARY KEY,
	Manufacturer NVARCHAR(50) NOT NULL,
	Model NVARCHAR(50) NOT NULL,
	ProductionYear DATETIME,
	Seats INT,
	Class NVARCHAR(10),
	Consumption DECIMAL(16,2)
);

CREATE TABLE Vehicles (
	Id INT IDENTITY PRIMARY KEY,
	ModelId INT NOT NULL REFERENCES Models(Id),
	OfficeId INT NOT NULL REFERENCES Offices(Id),
	Mileage INT
);

CREATE TABLE Orders (
	Id INT IDENTITY PRIMARY KEY,
	ClientId INT NOT NULL REFERENCES Clients(Id),
	TownId INT NOT NULL REFERENCES Towns(Id),
	VehicleId INT NOT NULL REFERENCES Vehicles(Id),
	CollectionDate DATETIME NOT NULL,
	CollectionOfficeId INT NOT NULL REFERENCES Offices(Id),
	ReturnDate DATETIME,
	ReturnOfficeId INT REFERENCES Offices(Id),
	Bill DECIMAL(16,2),
	TotalMileage INT
);

INSERT INTO Models (Manufacturer, Model, ProductionYear, Seats, Class, Consumption)
			VALUES ('Chevrolet', 'Astro', '2005-07-27 00:00:00.000', 4, 'Economy', 12.60),
					('Toyota', 'Solara', '2009-10-15 00:00:00.000', 7, 'Family', 13.80),
					('Volvo', 'S40', '2010-10-12 00:00:00.000', 3,'Average', 11.30),
					('Suzuki', 'Swift', '2000-02-03 00:00:00.000', 7, 'Economy', 16.20);

INSERT INTO Orders (ClientId, TownId, VehicleId, CollectionDate, CollectionOfficeId, ReturnDate, ReturnOfficeId, Bill , TotalMileage)
			VALUES (17,	2, 52, '2017-08-08', 30, '2017-09-04', 42, 2360.00, 7434),
					(78, 17, 50, '2017-04-22', 10, '2017-05-09', 12, 2326.00, 7326),
					(27, 13, 28, '2017-04-25', 21, '2017-05-09', 34, 597.00, 1880);

UPDATE Models
SET Class = 'Luxury'
WHERE Consumption > 20;

DELETE Orders
WHERE ReturnDate IS NULL;

SELECT FirstName,
		LastName
FROM Clients
WHERE YEAR(BirthDate) >= 1977 AND YEAR(BirthDate) <= 1994
ORDER BY FirstName ASC,
		LastName ASC,
		Id ASC;

SELECT  t.Name AS 'TownName',
		o.Name AS 'OfficeName',
		o.ParkingPlaces
FROM Offices AS o
JOIN Towns AS t ON t.Id = o.TownId
WHERE o.ParkingPlaces > 25
ORDER BY t.Name ASC,
		o.Id ASC;

SELECT t.Name AS 'TownName',
		COUNT(t.Id) AS 'OfficesNumber'
FROM Offices AS o
JOIN Towns AS t ON t.Id = o.TownId
GROUP BY
	t.Name,
	t.Id
ORDER BY COUNT(t.Id) DESC,
		t.Name ASC;

SELECT m.Manufacturer,
		m.Model,
		COUNT(o.VehicleId) AS 'TimesOrdered'
FROM Models AS m
FULL OUTER JOIN Vehicles AS v ON m.Id = v.ModelId
FULL OUTER JOIN Orders AS o ON o.VehicleId = v.Id
GROUP BY
		m.Manufacturer,
		m.Model 
ORDER BY TimesOrdered DESC,
			m.Manufacturer DESC,
			m.Model ASC;