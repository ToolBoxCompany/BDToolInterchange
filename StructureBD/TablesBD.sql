CREATE DATABASE [TOOL_INTERCHANGE]

GO

USE [TOOL_INTERCHANGE]

GO

CREATE TABLE COMUNITY (

	idComunity INT IDENTITY PRIMARY KEY,
	name VARCHAR(100)

);

CREATE TABLE CITY (

	idCity INT IDENTITY PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	postalCode CHAR(5) NOT NULL,
	idComunity INT,
	province VARCHAR(100),
	FOREIGN KEY (idComunity) REFERENCES COMUNITY(idComunity) 

);

GO

CREATE TABLE DIRECTION (

	idDirection INT IDENTITY PRIMARY KEY,
	street VARCHAR(150) NOT NULL,
	postalCode CHAR(5) NOT NULL,
	Number INT NOT NULL,
	idCity INT,
	DoorNumber VARCHAR(5),
	StairNumber VARCHAR(5),
	FOREIGN KEY (idCity) REFERENCES CITY(idCity)
	
);

GO

CREATE TABLE USERS (

	idUser INT IDENTITY PRIMARY KEY,
	nameUser VARCHAR(40) NOT NULL,
	firtSurname VARCHAR(40) NOT NULL,
	lastSurname VARCHAR(40) NOT NULL,
	mail VARCHAR(100) NOT NULL,
	phoneNumber CHAR(9) NOT NULL CHECK (phoneNumber NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	dateOfBirth DATE NOT NULL CHECK (dateOfBirth <= GETDATE()),
	isSeller BIT NOT NULL,
	idDirection INT,

	FOREIGN KEY (idDirection) REFERENCES DIRECTION(idDirection),

);

CREATE TABLE CATEGORY (

	idCategory INT IDENTITY PRIMARY KEY,
	 nameCategory VARCHAR(50) NOT NULL
);


CREATE TABLE TOOL (

	idTool INT IDENTITY PRIMARY KEY,
	nameTool VARCHAR(100) NOT NULL,
	stock SMALLINT NOT NULL CHECK (stock >= 0),
	idCategory INT,
	pricePerDay MONEY NOT NULL,

	CHECK (pricePerDay > 0),

	FOREIGN KEY (idCategory) REFERENCES CATEGORY(idCategory)

);

CREATE TABLE PAYMETHOD (

	idPaymethod INT IDENTITY PRIMARY KEY,
	namePaymethod VARCHAR(50)

);

CREATE TABLE ORDERS (

	idOrder INT IDENTITY PRIMARY KEY,
	idUser INT,
	idTool INT,
	idPaymethod INT,
	totalAmount smallmoney,
	Quantity SMALLINT NOT NULL CHECK (Quantity > 0),
	reservationStart DATE NOT NULL,
	reservationEnd DATE NOT NULL,
	orderStatus VARCHAR(9) NOT NULL DEFAULT 'New',

	CHECK (reservationEnd > reservationStart),
	CHECK (orderStatus IN ('New','Paid','Cancelled','Sended','Returned','Closed')),

	FOREIGN KEY (idUser) REFERENCES USERS(idUser),
	FOREIGN KEY (idTool) REFERENCES TOOL(idTool),
	FOREIGN KEY (idPaymethod) REFERENCES PAYMETHOD(idPaymethod)

);


CREATE TABLE DELIVERY (

	idDelivery INT IDENTITY PRIMARY KEY,
	idOrder INT,
	departureDate DATE NOT NULL,
	estimatedDate DATE NOT NULL,
	deliveryDate DATE,

	CHECK (deliveryDate > departureDate),

	FOREIGN KEY (idOrder) REFERENCES ORDERS(idOrder),


);

CREATE TABLE ASSESSMENT (

	idAssessment INT IDENTITY PRIMARY KEY,
	idOrder INT,
	mark CHAR(1) NOT NULL,
	comment TEXT,

	CHECK (mark BETWEEN '1' AND '5'),

	FOREIGN KEY (idOrder) REFERENCES ORDERS(idOrder)

);

--Inserts base de prueba.

INSERT INTO COMUNITY (name) VALUES ('Andaluc�a');

GO

INSERT INTO CITY (name, postalCode, idComunity, province)
VALUES 
	('Sevilla', '41001', 1, 'Sevilla'),
	('Granada', '18001', 1, 'Granada'),
	('M�laga', '29001', 1, 'M�laga'),
	('C�rdoba', '14001', 1, 'C�rdoba');

GO

INSERT INTO DIRECTION (street, postalCode, Number, idCity, DoorNumber, StairNumber)
VALUES 
	('Calle Sol', '41001', 25, 1, '2B', 'A'),
	('Av. Constituci�n', '18001', 10, 2, '1A', 'B'),
	('Calle Larios', '29001', 15, 3, '3C', 'A'),
	('Ronda de los Tejares', '14001', 8, 4, '2D', 'C');

GO

INSERT INTO USERS (nameUser, firtSurname, lastSurname, dateOfBirth, isSeller, idDirection)
VALUES ('Juan', 'P�rez', 'G�mez', '1990-05-20', 1, 1);

GO

INSERT INTO USERS (nameUser, firtSurname, lastSurname, dateOfBirth, isSeller, idDirection)
VALUES ('Luc�a', 'Mart�nez', 'Rey', '1985-09-12', 0, 2);

GO

INSERT INTO USERS (nameUser, firtSurname, lastSurname, dateOfBirth, isSeller, idDirection)
VALUES ('Carlos', 'Fern�ndez', 'L�pez', '1993-03-05', 1, 3);

GO

INSERT INTO USERS (nameUser, firtSurname, lastSurname, dateOfBirth, isSeller, idDirection)
VALUES ('Ana', 'Garc�a', 'Morales', '2000-07-30', 0, 4);

GO

INSERT INTO CATEGORY (nameCategory) VALUES ('Jardiner�a');

GO

INSERT INTO CATEGORY (nameCategory) VALUES ('Carpinter�a');

GO

INSERT INTO TOOL (nameTool, idCategory, stock)
VALUES ('Cortac�sped el�ctrico', 1, 3);

GO

INSERT INTO TOOL (nameTool, idCategory, stock) VALUES 
	('Taladro inal�mbrico', 2 , 5),
	('Lijadora el�ctrica', 2, 2);

GO

INSERT INTO PAYMETHOD (namePaymethod)
VALUES 
	('Tarjeta de cr�dito'),
	('Bizum'),
	('Efectivo'),
	('Transferencia');

GO

INSERT INTO ORDERS (idUser, idTool, idPaymethod, totalAmount, Quantity, reservationStart, reservationEnd)
VALUES 
	(1, 1, 1, 49.99, 1, '2025-05-08', '2025-05-14'),
	(2, 2, 1, 39.99, 1, '2025-05-10', '2025-05-12'),
	(2, 3, 2, 59.95, 1, '2025-05-13', '2025-05-15'),
	(4, 3, 1, 59.95, 1, '2025-05-16', '2025-05-18'),
	(4, 2, 2, 44.50, 1, '2025-05-18', '2025-05-21');

GO

INSERT INTO DELIVERY (idOrder, departureDate, estimatedDate, deliveryDate) VALUES 
	(1, '2025-05-10', '2025-05-12', '2025-05-11'),
	(2, '2025-05-11', '2025-05-13', '2025-05-12'),
	(3, '2025-05-12', '2025-05-14', '2025-05-13'),
	(4, '2025-05-13', '2025-05-15', '2025-05-14'),
	(5, '2025-05-13', '2025-05-15', '2025-05-14');

GO

INSERT INTO ASSESSMENT (idOrder, mark, comment) VALUES
	(1, '5', 'Herramienta en excelentes condiciones. Muy recomendable.'),
	(2, '4', 'Buen estado, pero faltaba una pieza menor.'),
	(3, '5', 'Perfecto funcionamiento y entrega r�pida.'),
	(4, '3', 'Cumple su funci�n, aunque algo usada.'),
	(5, '5', 'Excelente herramienta, como nueva.');