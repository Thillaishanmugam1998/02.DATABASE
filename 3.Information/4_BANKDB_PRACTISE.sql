-- Drop database if it already exists
IF DB_ID('BankDB') IS NOT NULL
BEGIN
    DROP DATABASE BankDB;
END
GO

-- Create database
CREATE DATABASE BankDB;
GO

USE BankDB;
GO


DROP TABLE IF EXISTS Customers;
GO

CREATE TABLE Customers
(
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(100) NOT NULL,
    DOB         DATE NOT NULL,
    Address     NVARCHAR(255),
    Phone       NVARCHAR(15),
    Email       NVARCHAR(100) UNIQUE
);


DROP TABLE IF EXISTS Accounts;
GO

CREATE TABLE Accounts
(
    AccountID   INT IDENTITY(1001,1) PRIMARY KEY,
    CustomerID  INT NOT NULL,
    AccountType NVARCHAR(20) CHECK (AccountType IN ('Savings','Current','Salary')),
    Balance     DECIMAL(18,2) NOT NULL DEFAULT 0,
    OpenDate    DATE NOT NULL,

    CONSTRAINT FK_Accounts_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

DROP TABLE IF EXISTS Transactions;
GO

CREATE TABLE Transactions
(
    TransactionID   INT IDENTITY(1,1) PRIMARY KEY,
    AccountID       INT NOT NULL,
    TransactionType NVARCHAR(20) CHECK (TransactionType IN ('Credit','Debit')),
    Amount           DECIMAL(18,2) NOT NULL CHECK (Amount > 0),
    TransactionDate  DATETIME NOT NULL DEFAULT GETDATE(),
    Description      NVARCHAR(255),

    CONSTRAINT FK_Transactions_Accounts
        FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

DROP TABLE IF EXISTS Loans;
GO

CREATE TABLE Loans
(
    LoanID        INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID    INT NOT NULL,
    LoanType      NVARCHAR(30),
    Amount        DECIMAL(18,2) NOT NULL,
    InterestRate  DECIMAL(5,2),
    StartDate     DATE,
    EndDate       DATE,
    Status        NVARCHAR(20) CHECK (Status IN ('Active','Closed','Defaulted')),

    CONSTRAINT FK_Loans_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

DROP TABLE IF EXISTS Branches;
GO

CREATE TABLE Branches
(
    BranchID    INT IDENTITY(1,1) PRIMARY KEY,
    BranchName  NVARCHAR(100),
    Location    NVARCHAR(100),
    Manager     NVARCHAR(100)
);

DROP TABLE IF EXISTS Employees;
GO

CREATE TABLE Employees
(
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name       NVARCHAR(100),
    BranchID   INT,
    Position   NVARCHAR(50),
    Salary     DECIMAL(18,2),
    HireDate   DATE,

    CONSTRAINT FK_Employees_Branches
        FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

DROP TABLE IF EXISTS ATM;
GO

CREATE TABLE ATM
(
    ATMID     INT IDENTITY(1,1) PRIMARY KEY,
    BranchID  INT,
    Location  NVARCHAR(100),
    Status    NVARCHAR(20) CHECK (Status IN ('Active','Inactive','Maintenance')),

    CONSTRAINT FK_ATM_Branches
        FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

INSERT INTO Customers (Name, DOB, Address, Phone, Email)
VALUES
('Ravi Kumar','1988-05-10','Chennai','9876543210','ravi@gmail.com'),
('Anita Sharma','1992-11-22','Delhi','9876501234','anita@gmail.com'),
('John Mathew','1985-01-15','Bangalore','9988776655','john@gmail.com'),
('Priya Iyer','1990-07-19','Coimbatore','9001122334','priya@gmail.com');

INSERT INTO Accounts (CustomerID, AccountType, Balance, OpenDate)
VALUES
(1,'Savings',55000,'2020-01-01'),
(1,'Current',120000,'2021-06-15'),
(2,'Savings',30000,'2019-03-20'),
(3,'Salary',85000,'2022-02-10'),
(4,'Savings',150000,'2018-11-05');

INSERT INTO Transactions (AccountID, TransactionType, Amount, Description)
VALUES
(1001,'Credit',20000,'Salary Deposit'),
(1001,'Debit',5000,'ATM Withdrawal'),
(1002,'Debit',10000,'Office Rent'),
(1003,'Credit',15000,'Cash Deposit'),
(1004,'Debit',3000,'Online Shopping');

INSERT INTO Loans (CustomerID, LoanType, Amount, InterestRate, StartDate, EndDate, Status)
VALUES
(1,'Home Loan',2500000,8.5,'2019-01-01','2039-01-01','Active'),
(2,'Car Loan',800000,9.2,'2021-05-01','2026-05-01','Active'),
(3,'Personal Loan',300000,12.5,'2020-08-01','2023-08-01','Closed');
