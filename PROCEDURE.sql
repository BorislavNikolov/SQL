CREATE PROC usp_MoveVehicle(@vehicleId INT, @officeId INT) 
AS
BEGIN
	DECLARE @carsInOffice INT;
	DECLARE @freeParkingPlaces INT;

	SET @carsInOffice = (SELECT COUNT(v.Id) 
								FROM Vehicles AS v
								JOIN Offices AS o ON o.Id = v.OfficeId
								WHERE o.Id = @officeId);
	SET @freeParkingPlaces = (SELECT ParkingPlaces FROM Offices WHERE Id = @officeId) - @carsInOffice;

	IF(@freeParkingPlaces <= 0)
	BEGIN;
		THROW 51000, 'Not enough room in this office!', 1;
	END

	UPDATE Vehicles
	SET OfficeId = @officeId
	WHERE Id = @vehicleId;
END

EXEC usp_MoveVehicle 7, 32;
SELECT OfficeId FROM Vehicles WHERE Id = 7
