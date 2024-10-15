DROP DATABASE IF EXISTS Hogwarts_Events_Management;
CREATE DATABASE Hogwarts_Events_Management;

USE Hogwarts_Events_Management;

-- Creating Events, Customers, & Requests table
CREATE TABLE Events (
	EventID VARCHAR(10) PRIMARY KEY,
    Room VARCHAR(50) NOT NULL,
    EventDate Date NOT NULL,
    Occasion VARCHAR(50),
    RoomCapacity INT NOT NULL,
    NumberOfGuests INT NOT NULL
);

CREATE TABLE Customers (
	CustomerID VARCHAR(10) PRIMARY KEY,
    EventID VARCHAR(10) NOT NULL,
    CustomerName VARCHAR(50) NOT NULL,
    MobileNumber VARCHAR(20) NOT NULL,
    Address VARCHAR(100) NOT NULL,
    IsRegularCustomer BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

CREATE TABLE Requests (
	EventDate VARCHAR(10) NOT NULL,
    CustomerName VARCHAR(50) NOT NULL,
    MobileNumber VARCHAR(20) NOT NULL,
    Address VARCHAR(100) NOT NULL,
    Occasion VARCHAR(50),
    NumberOfGuests INT NOT NULL,
    DealtWith BOOLEAN DEFAULT FALSE
);

-- Insert example data into Events
INSERT INTO Events (EventID, Room, EventDate, Occasion, RoomCapacity, NumberOfGuests)
VALUES
('E001', 'Great Hall', '2024-10-31', 'Halloween Feast', 500, 450),
('E002', 'Room of Requirement', '2024-12-25', 'Yule Ball', 300, 250),
('E003', 'Forbidden Forest', '2024-11-15', 'Care of Magical Creatures', 100, 80);

-- Insert example data into Customers
INSERT INTO Customers (CustomerID, EventID, CustomerName, MobileNumber, Address, IsRegularCustomer)
VALUES
('C001', 'E001', 'Harry Potter', '0790-123-4567', '4 Privet Drive, Little Whinging, Surrey, CR3 0AA', TRUE),
('C002', 'E002', 'Hermione Granger', '0790-987-6543', '42 Diagon Alley, London, W1A 1AA', FALSE),
('C003', 'E003', 'Rubeus Hagrid', '0790-555-1234', 'Hut by the Forbidden Forest, Hogwarts, Scotland, HP3 4TH', TRUE);

-- Insert example data into Requests
INSERT INTO Requests (EventDate, CustomerName, MobileNumber, Address, Occasion, NumberOfGuests, DealtWith)
VALUES
('2024-10-31', 'Harry Potter', '0790-123-4567', '4 Privet Drive, Little Whinging, Surrey, CR3 0AA', 'Halloween Feast', 450, TRUE),
('2024-12-25', 'Hermione Granger', '0790-987-6543', '42 Diagon Alley, London, W1A 1AA', 'Yule Ball', 250, TRUE),
('2024-11-15', 'Rubeus Hagrid', '0790-555-1234', 'Hut by the Forbidden Forest, Hogwarts, Scotland, HP3 4TH', 'Care of Magical Creatures', 80, TRUE);

