CREATE SCHEMA Cfg;
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
    ReportId INT NOT NULL,
    LineNumber SMALLINT NOT NULL,
    ProductID INT NULL,
    UnitPrice MONEY NULL,
    OrderQty SMALLINT NULL,
    ReceivedQty FLOAT NULL,
    RejectedQty FLOAT NULL,
    DueDate DATETIME NULL
);

CREATE TABLE Cfg.Visits (
    PurchaseOrderID INT NOT NULL,
    LineNumber SMALLINT NOT NULL,
    ProductID INT NULL,
    UnitPrice MONEY NULL,
    OrderQty SMALLINT NULL,
    ReceivedQty FLOAT NULL,
    RejectedQty FLOAT NULL,
    DueDate DATETIME NULL
);

