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
	
	IF (@depurateDate > @reservationDate OR @estimatedDate > @reservationDate OR @deliveryDate > @reservationDate)
	BEGIN

		print 'The date is bigger than the reservation limit'
		
		UPDATE ORDERS SET
		orderStatus = 'Cancelled'
		WHERE ORDERS.idOrder = @idOrder

	END
	
	ELSE
	BEGIN

		INSERT INTO DELIVERY (idOrder, departureDate , estimatedDate , deliveryDate) 
		VALUES (@idOrder , @depurateDate , @estimatedDate , @deliveryDate)

	END

END -- No se puede insertar fechas despues de la reserva.

GO

CREATE OR ALTER TRIGGER PriceOfOrder
ON ORDERS AFTER INSERT
AS
BEGIN

	DECLARE @idOrder INT,
	@idTool INT,
	@quantity SMALLINT,
	@pricePerDay SMALLMONEY,
	@daysReserved INT;

	SET @idOrder = (SELECT inserted.idOrder FROM inserted)
	SET @idTool = (SELECT inserted.idTool FROM inserted)
	SET @quantity = (SELECT inserted.Quantity FROM inserted)
	SET @pricePerDay = (SELECT T.pricePerDay FROM TOOL T WHERE T.idTool = @idTool)
	SET @daysReserved = (SELECT DATEDIFF(DAY,(SELECT O.reservationStart FROM ORDERS O WHERE O.idOrder = @idOrder),(SELECT O.reservationEnd FROM ORDERS O WHERE O.idOrder = @idOrder)))

	UPDATE ORDERS SET
	totalAmount = ( ( @pricePerDay * @daysReserved ) * @quantity )
	WHERE idOrder = @idOrder

END -- Ajustamos el precio de la Order al precio real segun los datos de la bbdd.

GO

CREATE OR ALTER TRIGGER StockOfTheTools
ON ORDERS INSTEAD OF INSERT
AS
BEGIN

	DECLARE @idOrder INT = (SELECT inserted.idOrder FROM inserted)
	DECLARE @idTool INT = (SELECT inserted.idTool FROM inserted)
	DECLARE @idUser INT = (SELECT inserted.idUser FROM inserted)
	DECLARE @idPaymethod INT = (SELECT inserted.idPaymethod FROM inserted)
	DECLARE @totalAmount SMALLMONEY = (SELECT inserted.totalAmount FROM inserted)
	DECLARE @quantity SMALLINT = (SELECT inserted.Quantity FROM inserted)
	DECLARE @reservationStart DATE = (SELECT inserted.reservationStart FROM inserted)
	DECLARE @reservationEnd DATE = (SELECT inserted.reservationEnd FROM inserted)
	
	IF (SELECT COUNT(*) FROM ORDERS O WHERE O.idTool = @idTool AND O.orderStatus NOT IN ('Cancelled','Closed')) > (SELECT T.stock FROM TOOL T WHERE T.idTool = @idTool)
	BEGIN

		print 'You dont have stock of ' + (SELECT T.nameTool FROM TOOL T WHERE idTool = @idTool) + ' , so we cant make a order'
		return;

	END

	ELSE
	BEGIN

		INSERT INTO ORDERS (idTool, idUser, idPaymethod, totalAmount, Quantity, reservationStart, reservationEnd)
		VALUES (@idTool, @idUser, @idPaymethod, @totalAmount, @quantity, @reservationStart, @reservationEnd)

	END

END -- Si no hay stock para hacer un insert , no se hace.