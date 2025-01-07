-- Drop Tables if they already exist to avoid errors
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Clients;
DROP TABLE IF EXISTS Agents;
DROP TABLE IF EXISTS Properties;

-- Create Properties Table
CREATE TABLE Properties (
    PropertyID INT PRIMARY KEY,
    Address VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Type VARCHAR(50) CHECK (Type IN ('Residential', 'Commercial', 'Industrial')),
    Size INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('Available', 'Sold', 'Rented'))
);

-- Create Agents Table
CREATE TABLE Agents (
    AgentID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(15) UNIQUE,
    CommissionRate DECIMAL(5,2) CHECK (CommissionRate > 0 AND CommissionRate <= 15)
);

-- Create Clients Table
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Preferences TEXT
);

-- Create Transactions Table
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    PropertyID INT,
    AgentID INT,
    ClientID INT,
    TransactionType VARCHAR(10) CHECK (TransactionType IN ('Buy', 'Sell', 'Rent')),
    Date DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID) ON DELETE CASCADE,
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID) ON DELETE CASCADE,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID) ON DELETE CASCADE
);

-- Insert Sample Data into Properties
INSERT INTO Properties (PropertyID, Address, City, Type, Size, Price, Status) VALUES
(1, '123 Main St', 'Kampala', 'Residential', 2000, 300000.00, 'Available'),
(2, '456 Elm St', 'Kampala', 'Commercial', 5000, 500000.00, 'Available'),
(3, '789 Oak St', 'Jinja', 'Industrial', 10000, 1000000.00, 'Rented'),
(4, '101 Pine St', 'Entebbe', 'Residential', 2500, 350000.00, 'Available'),
(5, '202 Cedar St', 'Mbarara', 'Commercial', 4000, 450000.00, 'Sold'),
(6, '303 Maple St', 'Kampala', 'Industrial', 8000, 850000.00, 'Available'),
(7, '404 Birch St', 'Kampala', 'Residential', 3000, 320000.00, 'Rented'),
(8, '505 Walnut St', 'Gulu', 'Commercial', 6000, 600000.00, 'Available'),
(9, '606 Spruce St', 'Kampala', 'Industrial', 12000, 1500000.00, 'Available'),
(10, '707 Ash St', 'Kampala', 'Residential', 1800, 280000.00, 'Available');

-- Insert Sample Data into Agents
INSERT INTO Agents (AgentID, Name, ContactNumber, CommissionRate) VALUES
(1, 'John Doe', '0701234567', 5.0),
(2, 'Jane Smith', '0712345678', 10.0),
(3, 'Alice Johnson', '0723456789', 7.5);

-- Insert Sample Data into Clients
INSERT INTO Clients (ClientID, Name, ContactNumber, Email, Preferences) VALUES
(1, 'Mike Brown', '0734567890', 'mike.brown@example.com', 'Kampala, Residential'),
(2, 'Sara White', '0745678901', 'sara.white@example.com', 'Industrial'),
(3, 'Tom Black', '0756789012', 'tom.black@example.com', 'Commercial');

-- Insert Sample Data into Transactions
INSERT INTO Transactions (TransactionID, PropertyID, AgentID, ClientID, TransactionType, Date, Amount) VALUES
(1, 1, 1, 1, 'Buy', '2025-01-01', 300000.00),
(2, 3, 2, 2, 'Rent', '2025-01-02', 1000000.00),
(3, 5, 3, 3, 'Sell', '2025-01-03', 450000.00);

-- Retrieve All Properties Available for Sale in a Specific City
SELECT * FROM Properties WHERE City = 'Kampala' AND Status = 'Available';

-- Update the Status of a Property After It Has Been Sold
UPDATE Properties SET Status = 'Sold' WHERE PropertyID = 1;

-- Ensure Custom Constraints:
-- Property Status Check
ALTER TABLE Properties ADD CONSTRAINT chk_status CHECK (Status IN ('Available', 'Sold', 'Rented'));

-- Commission Rate Check
ALTER TABLE Agents ADD CONSTRAINT chk_commission CHECK (CommissionRate BETWEEN 1 AND 15);

-- Transaction Amount Cannot Exceed Property Price
-- Use a trigger for enforcing this rule (if supported by your database system).
