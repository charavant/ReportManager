DROP TABLE Cfg.Members;
DROP TABLE Cfg.Visits;
DROP TABLE Cfg.Reports;
DROP TABLE Cfg.Installations;
DROP TABLE Cfg.Cities;

--CREATE SCHEMA Cfg;
go

CREATE TABLE Cfg.Reports (
    Id INT NOT NULL,
    Name VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    Address VARCHAR(50) NULL,
    City VARCHAR(50) NULL,
    Need TINYINT NULL,
    Active BIT NULL,
    Details NVARCHAR(MAX)
);

CREATE TABLE Cfg.Members (
    Id INT NOT NULL PRIMARY KEY,
    Connector INT NOT NULL,
    [Member] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    YearOfBirth INT NULL,
    Age SMALLINT NULL,
    Details NVARCHAR(MAX) NULL
);

CREATE TABLE Cfg.Visits (
    Id INT NOT NULL PRIMARY KEY,
    Connector INT NOT NULL,
    KSowner SMALLINT NOT NULL,
    KSwent INT NULL,
    Details NVARCHAR(MAX) NULL,
    Visitor NVARCHAR(MAX) NULL,
    DateOfVisit DATETIME NULL
);

CREATE TABLE Cfg.Installations (
    Id INT NOT NULL PRIMARY KEY,
    CityId INT NOT NULL,
    [Name] NVARCHAR(MAX) NULL
);

CREATE TABLE Cfg.Cities (
    Id INT NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(50) NULL
);

