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
	FOREIGN KEY idComunity REFERENCES idComunity(idComunity) 

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
	FOREIGN KEY idCity REFERENCES idCity(idCity)
	
);

GO

CREATE TABLE USERS (

	idUser INT IDENTITY PRIMARY KEY,
	nameUser VARCHAR(40) NOT NULL,
	firtSurname VARCHAR(40) NOT NULL,
	lastSurname VARCHAR(40) NOT NULL,
	dateOfBirth DATE NOT NULL,
	isSeller BIT NOT NULL,
	idDirection INT,


	FOREIGN KEY idDirection REFERENCES idDirection(idDirection)
);

CREATE TABLE CATEGORY(

	idCategory INT IDENTITY PRIMARY KEY,
	 nameCategory VARCHAR(50) NOT NULL
);


CREATE TABLE TOOL(

	idTool INT IDENTITY PRIMARY KEY,
	nameTool VARCHAR(100) NOT NULL,
	idCategory INT,
	
	FOREIGN KEY idCategory REFERENCES idCategory(idCategory)

);

CREATE TABLE PAYMETHOD(

	idPaymethod INT IDENTITY PRIMARY KEY,
	namePaymethod VARCHAR(50)

);

CREATE TABLE ORDERS(

	idOrder INT IDENTITY PRIMARY KEY,
	idUser INT,
	idTool INT,
	idPaymethod INT,
	totalAmount smallmoney,
	Quantity SMALLINT NOT NULL

	FOREIGN KEY idUser REFERENCES idUser(idUser)
	FOREIGN KEY idTool REFERENCES idTool(idTool)
	FOREIGN KEY idPaymethod REFERENCES idPaymethod(idPaymethod)

);

