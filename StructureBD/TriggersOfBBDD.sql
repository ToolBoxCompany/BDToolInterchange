SELECT * FROM DELIVERY
GO

CREATE OR ALTER TRIGGER EstimatedDateCalculation
ON DELIVERY INSTEAD OF INSERT
AS
BEGIN

	DECLARE @idOrder INT,
	@idDelivery INT,
	@depurateDate DATE,
	@estimatedDate DATE,
	@deliveryDate DATE
	
	SET @idOrder = (SELECT inserted.idOrder FROM inserted)
	SET @idDelivery = (SELECT inserted.idDelivery FROM inserted)
	SET @depurateDate = (SELECT inserted.departureDate FROM inserted)
	SET @estimatedDate = (SELECT inserted.idOrder FROM inserted)
	SET @deliveryDate = (SELECT inserted.idOrder FROM inserted)

	DECLARE @reservationDate DATE = (SELECT O.reservationStart FROM ORDERS O WHERE O.idOrder = @idOrder)
	
	IF ()
	BEGIN

		

	END

END

GO

CREATE OR ALTER TRIGGER PriceOfOrder
ON ORDERS AFTER INSERT
AS
BEGIN

	

END
