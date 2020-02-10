CREATE FUNCTION udf_CheckForVehicle(@townName NVARCHAR(50), @seatsNumber INT)
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @townId INT;
	DECLARE @result NVARCHAR(100);

	SET @townId = (SELECT Id
					FROM Towns
					WHERE Name = @townName);

	SET @result = (SELECT TOP 1
					o.Name + ' - ' + m.Model
					FROM Offices as o
					JOIN Vehicles as v ON v.OfficeId = o.Id
					JOIN Models as m ON m.Id = v.ModelId
					WHERE @townId = o.TownId AND m.Seats = @seatsNumber
					ORDER by o.Name asc);

	IF (@result IS NULL)
	BEGIN
		SET @result = 'NO SUCH VEHICLE FOUND';
	END

	RETURN @result;
END
