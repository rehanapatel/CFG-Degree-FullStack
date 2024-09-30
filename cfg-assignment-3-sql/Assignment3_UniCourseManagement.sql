DROP DATABASE UniversityCourseManagement;
SET SQL_SAFE_UPDATES = 0; -- For when we update a false record later! 
CREATE DATABASE UniversityCourseManagement;
USE UniversityCourseManagement;

-- This Database is to help the admin department at a university manage course allocations and track progress of students. 
-- This Database will:
-- Help organise and determine department resources by querying how many students are expected to be attending the university this year 
-- Enable easy investigation/ alteration of false/incorrect records within the data
-- Use aggregate and built-in functions as well as joins to manipulate and query the data as needed for the admin team to carry out their tasks 
-- Creates 3 tables: Students, Courses, & Enrollments

CREATE TABLE Students (
	StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL, -- Cannot be left empty
    Degree VARCHAR(100) NOT NULL, 
    IsActive BOOLEAN DEFAULT TRUE,
    EndOfUniEnrollment DATE
);

CREATE TABLE Courses (
	CourseID VARCHAR(5) PRIMARY KEY,
    Degree VARCHAR(100),
    CourseName VARCHAR(100) UNIQUE,
    Credits INT CHECK (10 <= Credits <= 40), -- The university does not offer any course beyond 40 credits or under 10 credits
    Semester INT
);

CREATE TABLE Enrollments (
	EnrollmentID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID VARCHAR(5) NOT NULL,
    EnrollmentStatus VARCHAR(50) DEFAULT 'Ongoing',
    Grade VARCHAR(3) DEFAULT 'TBD',
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID), -- Establishing StudentID and CourseID as foreign keys
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Populating the Above Tables With Data
INSERT INTO Students (StudentID, StudentName, Degree, IsActive, EndOfUniEnrollment)
VALUES
(001, 'John Wick', 'Social Science', DEFAULT, '2025-07-29'),
(002, 'Harry Potter', 'Politics', DEFAULT, '2025-07-29'),
(003, 'Hermione Granger', 'English Literature', DEFAULT, '2025-07-29'),
(004, 'Ron Weasley', 'Business', DEFAULT, '2025-07-29'),
(005, 'Severus Snape', 'Software Engineering', FALSE, '1990-07-29'),
(006, 'Minerva McGonaagall', 'English & History', FALSE, '1960-07-29'),
(007, 'Rubeus Hagrid', 'Wildlife Conservation', FALSE, '1975-07-29'),
(008, 'Albus Dumbledore', 'Philosophy', FALSE, '1960-06-30'),
(009, 'Bruce Wayne', 'Criminology', FALSE, '2025-07-29'), -- Incorrect data entry where EndOfEnrollment implies the student is active but the status is set to FALSE              
(010, 'Peter Parker', 'Physics', TRUE, NULL),            
(011, 'Nathan Drake', 'Archaeology', TRUE, NULL),             
(012, 'Alex Munday', 'Mechanical Engineering', TRUE, NULL),   
(013, 'Natalie Cook', 'Sports Science', TRUE, NULL),          
(014, 'Dylan Sanders', 'Criminal Justice', TRUE, NULL),
(015, 'John Smith', 'Biology', FALSE, NULL); -- Planted incorrect/outlier record

INSERT INTO Courses (CourseID, Degree, CourseName, Credits, Semester)
VALUES
('C01', 'Criminology', 'Forensic Psychology', 20, 1),
('C02', 'Criminology', 'Crime Scene Investigation', 15, 2),
('C03', 'Criminology', 'Criminal Law', 25, 1),
('Phy01', 'Physics', 'Thermodynamics', 20, 1),
('Phy02', 'Physics', 'BioPhysics', 15, 2),
('Phy03', 'Physics', 'Quantum Computing', 25, 2),
('A01', 'Archaeology', 'Ancient Civilizations', 20, 1),
('A02', 'Archaeology', 'Field Methods in Archaeology', 15, 2),
('A03', 'Archaeology', 'Cultural Heritage Management', 25, 1),
('ME01', 'Mechanical Engineering', 'System Thermodynamics', 20, 1),
('ME02', 'Mechanical Engineering', 'Fluid Mechanics', 15, 2),
('ME03', 'Mechanical Engineering', 'Mechanical Design', 25, 2),
('SS01', 'Sports Science', 'Exercise Physiology', 20, 1),
('SS02', 'Sports Science', 'Biomechanics', 15, 2),
('SS03', 'Sports Science', 'Sports Nutrition', 25, 1),
('CJ01', 'Criminal Justice', 'Law Enforcement Ethics', 20, 1),
('CJ02', 'Criminal Justice', 'Corrections and Rehabilitation', 15, 2),
('CJ03', 'Criminal Justice', 'Criminal Procedures', 25, 1),
('SSci1', 'Social Science', 'Sociology of Violence', 20, 1),
('SSci2', 'Social Science', 'Human Behavior Studies', 15, 2),
('SSci3', 'Social Science', 'Conflict Resolution', 25, 1),
('P01', 'Politics', 'Political Theory', 20, 1),
('P02', 'Politics', 'International Relations', 15, 2),
('P03', 'Politics', 'Constitutional Law', 25, 1),
('E01', 'English Literature', 'Shakespearean Studies', 20, 1),
('E02', 'English Literature', 'Victorian Literature', 15, 2),
('E03', 'English Literature', 'Modernist Fiction', 25, 2),
('WC01', 'Wildlife Conservation', 'Animal Behavior', 20, 1),
('WC02', 'Wildlife Conservation', 'Ecosystem Management', 15, 2),
('WC03', 'Wildlife Conservation', 'Endangered Species Conservation', 25, 1),
('PH01', 'Philosophy', 'Ethics & Moral Philosophy', 20, 1),
('PH02', 'Philosophy', 'Philosophy & the Mind', 15, 2),
('PH03', 'Philosophy', 'Metaphysics & Epistemology', 25, 1);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentStatus, Grade)
VALUES
(1, 001, 'SSci1', 'Incomplete', 'TBD'),
(2, 001, 'SSci2', 'Ongoing', 'TBD'),
(3, 001, 'SSci3', 'Incomplete', 'TBD'),
(4, 002, 'P01', 'Completed', 'A'),
(5, 002, 'P02', 'Ongoing', 'TBD'),
(6, 002, 'P03', 'Failed', 'F'),
(7, 003, 'E01', 'Completed', 'A*'),
(8, 003, 'E02', 'Ongoing', 'TBD'),
(9, 003, 'E03', 'Ongoing', 'TBD'),
(10, 004, 'SS01', 'Completed', 'A'),
(11, 004, 'SS02', 'Ongoing', 'TBD'),
(12, 004, 'SS03', 'Completed', 'B'),
(13, 005, 'ME01', 'Completed', 'A*'),
(14, 005, 'ME02', 'Completed', 'A'),
(15, 005, 'ME03', 'Completed', 'A'),
(16, 006, 'E01', 'Completed', 'A*'),
(17, 006, 'E02', 'Completed', 'A*'),
(18, 006, 'E03', 'Completed', 'A*'),
(19, 007, 'WC01', 'Completed', 'B'),
(20, 007, 'WC02', 'Completed', 'B'),
(21, 007, 'WC03', 'Completed', 'B'),
(22, 008, 'PH01', 'Completed', 'A*'),
(23, 008, 'PH02', 'Completed', 'A*'),
(24, 008, 'PH03', 'Completed', 'A*'),
(25, 009, 'C01', 'Completed', 'A'),
(26, 009, 'C02', 'Ongoing', 'TBD'),
(27, 009, 'C03', 'Completed', 'A*'),
(28, 010, 'Phy01', 'Completed', 'A*'),
(29, 010, 'Phy02', 'Ongoing', 'TBD'),
(30, 010, 'Phy03', 'Ongoing', 'TBD'),
(31, 011, 'A01', 'Completed', 'A'),
(32, 011, 'A02', 'Ongoing', 'TBD'),
(33, 011, 'A03', 'Completed', 'B'),
(34, 012, 'ME01', 'Ongoing', 'TBD'),
(35, 012, 'ME02', 'Ongoing', 'TBD'),
(36, 012, 'ME03', 'Ongoing', 'TBD'),
(37, 013, 'SS01', 'Ongoing', 'TBD'),
(38, 013, 'SS02', 'Ongoing', 'TBD'),
(39, 013, 'SS03', 'Ongoing', 'TBD'),
(40, 014, 'CJ01', 'Completed', 'A*'),
(41, 014, 'CJ02', 'Ongoing', 'TBD'),
(42, 014, 'CJ03', 'Completed', 'A');

-- Querying the database -------------------------------------------------------------------------------------------------------------------------------------------
-- Which students are active & What degree are they doing? (currently at the university)
SELECT s.StudentName, s.Degree
FROM Students s
WHERE IsActive = TRUE
ORDER BY s.Degree ASC; -- Alphabetical order

-- Which courses run during semester 1? 
SELECT c.CourseName, c.Semester
FROM Courses c
WHERE Semester = 1
ORDER BY c.CourseName ASC; 

-- What courses have been completed?
SELECT e.CourseID, e.EnrollmentStatus
FROM Enrollments e
WHERE EnrollmentStatus ='Completed'
ORDER BY e.CourseID ASC;

-- Which students are registered as inactive (isActive = False) but their EndOfUniEnrollment is a future date?
SELECT s.StudentName, s.EndOfUniEnrollment, s.IsActive
FROM Students s
WHERE s.IsActive = False AND s.EndOfUniEnrollment > current_date(); -- in-built function
-- This query identifies the incorrect record planted earlier!
-- Let's change that incorrect record now
UPDATE Students
SET Students.IsActive = TRUE
WHERE Students.StudentName = 'Bruce Wayne';
 
 -- Are there any students not registered in the Enrollments table?
SELECT s.StudentID, s.StudentName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID -- Joins the tables Students & Enrollments
WHERE e.studentID IS NULL;
 -- This query identifies the outlier record, let's go ahead and delete it.
DELETE FROM Students
WHERE StudentID = 015; -- You can also delete using his StudentName but given the purpose of a StudentID is that it is unique, it's better this way so as not delete all John Smiths! 
 
 -- We need a list of the 2025 graduation cohort with their names capitalised to pass on to the leaver's comittee who are organising leavers hoodies
SELECT UPPER(s.StudentName) -- built-in function
FROM Students s
WHERE EndOfUniEnrollment > current_date()
ORDER BY s.StudentName ASC;
 
 -- How many credits is each student taking? 
SELECT s.StudentID, s.StudentName, SUM(c.Credits) AS TotalCredits -- aggregate function
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID -- inner joins by default
JOIN Courses c ON e.courseID = c.CourseID
GROUP BY s.StudentID
ORDER BY s.StudentID;
 
-- We want to invite back our Alumni and send a fun email that details how many days its been since they left. Who are our Alumni and how many days has it been since they left?
SELECT 
    s.StudentID, 
    s.StudentName, 
    s.EndOfUniEnrollment, 
    DATEDIFF(current_date(), s.EndOfUniEnrollment) AS DaysSinceLeft -- built-in function
FROM 
    Students s
WHERE 
    s.EndOfUniEnrollment < current_date()
ORDER BY s.StudentName ASC;

-- How many students can we expect at the university this year? (how many are currently active & enrolled in the uni)
SELECT COUNT(*) AS TotalActiveStudents -- aggregate function
FROM Students
WHERE IsActive = TRUE;

-- Creating a Stored Procedure --------------------------------------------------------------------------------------------------------------------------------------
-- It's really useful to keep a track of how many credits a student has achieved, let's create a stored procedure to work this out so we can reuse this code easily!
DELIMITER $$

CREATE PROCEDURE GetCompletedCreditsForStudent(IN p_StudentID INT)
BEGIN
    SELECT s.StudentName, SUM(c.Credits) AS TotalCompletedCredits
    FROM Students s
    LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
    LEFT JOIN Courses c ON e.CourseID = c.CourseID AND e.EnrollmentStatus = 'Completed'
    WHERE s.StudentID = p_StudentID
    GROUP BY s.StudentName;
END $$

DELIMITER ;
CALL GetCompletedCreditsForStudent(002);
CALL GetCompletedCreditsForStudent(001);

-- Normalisation ---------------------------------------------------------------------------------------------------------------------------------------------------
-- In order to normalise this data we should:
-- Ensure each table only contains single values & each record is unique, then it's normalised in first form
-- Remove partial dependency for tables with composite keys, then it's normalised in second form
-- Remove transitive dependency such that non-key attributes do not depend on other non-key attributes, then it's normalised in third form
-- This ensures data consistency, reduces redundancy, and improves database efficiency

-- To normalise our tables, we are close but need to remove the field 'Degree' from the Students table. The purpose of the Enrollments table is to link the tables Students & Courses.
-- Therefore, we don't need to repeat this data as we link Students and Courses through the Enrollments table. It's also good practice to link through keys which Degree is not. 
ALTER TABLE Students
DROP COLUMN Degree;
SELECT * FROM Students s ORDER BY s.StudentName ASC;
-- Now there is not any redundant data & we've adhered to normalisation rules! :) 


