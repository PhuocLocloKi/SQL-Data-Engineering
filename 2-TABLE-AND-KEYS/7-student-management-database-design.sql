--07-student-management-system
--Student Management System
--Enterprise-level database design (educational purpose)

--------------------------------------------------
--Create database
CREATE DATABASE StudentManagement;
GO
USE StudentManagement;
GO

--------------------------------------------------
--MAJOR
--One major can have many students

CREATE TABLE Major (
    MajorID INT IDENTITY PRIMARY KEY,
    MajorCode CHAR(3) NOT NULL UNIQUE,
    MajorName NVARCHAR(100) NOT NULL
);

--------------------------------------------------
--STUDENT
--Stores personal information of students

CREATE TABLE Student (
    StudentID INT IDENTITY PRIMARY KEY,           -- Surrogate key
    StudentCode CHAR(8) NOT NULL UNIQUE,           -- Natural key
    FullName NVARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M','F')),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    MajorID INT NOT NULL,

    CONSTRAINT FK_Student_Major
        FOREIGN KEY (MajorID) REFERENCES Major(MajorID)
);

--Design note:
--Never use StudentCode as FK
--StudentID protects the system from cascading updates

--------------------------------------------------
--SUBJECT
--Course information

CREATE TABLE Subject (
    SubjectID INT IDENTITY PRIMARY KEY,
    SubjectCode CHAR(6) NOT NULL UNIQUE,
    SubjectName NVARCHAR(100) NOT NULL,
    Credit INT NOT NULL CHECK (Credit BETWEEN 1 AND 6)
);

--------------------------------------------------
--SEMESTER
--Separating semester avoids hard-coded values

CREATE TABLE Semester (
    SemesterID INT IDENTITY PRIMARY KEY,
    SemesterCode CHAR(5) NOT NULL UNIQUE,  -- e.g. SP24, FA24
    Year INT NOT NULL,
    Term NVARCHAR(20) NOT NULL              -- Spring, Summer, Fall
);

--------------------------------------------------
--ENROLLMENT (N–N relationship)
--A student enrolls in many subjects per semester

CREATE TABLE Enrollment (
    StudentID INT NOT NULL,
    SubjectID INT NOT NULL,
    SemesterID INT NOT NULL,
    Score DECIMAL(4,2) CHECK (Score BETWEEN 0 AND 10),

    CONSTRAINT PK_Enrollment 
        PRIMARY KEY (StudentID, SubjectID, SemesterID),

    CONSTRAINT FK_Enrollment_Student
        FOREIGN KEY (StudentID) REFERENCES Student(StudentID),

    CONSTRAINT FK_Enrollment_Subject
        FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID),

    CONSTRAINT FK_Enrollment_Semester
        FOREIGN KEY (SemesterID) REFERENCES Semester(SemesterID)
);

--------------------------------------------------
--SAMPLE DATA

INSERT INTO Major VALUES 
('SE', N'Software Engineering'),
('SS', N'Business Administration');

INSERT INTO Student VALUES
('S0000001', N'Nguyen Van AC', '2004-01-01', 'M', 'ac@gmail.com', '0909000001', 1),
('S0000002', N'Tran Thi BD',   '2004-05-12', 'F', 'bd@gmail.com', '0909000002', 2);

INSERT INTO Subject VALUES
('DBI101', N'Database Fundamentals', 3),
('PRJ101', N'Java Project', 4);

INSERT INTO Semester VALUES
('SP24', 2024, N'Spring'),
('FA24', 2024, N'Fall');

INSERT INTO Enrollment VALUES
(1, 1, 1, 8.5),
(1, 2, 1, 7.8),
(2, 1, 1, NULL);

--------------------------------------------------
--This design supports:
--✔ GPA calculation
--✔ Transcript generation
--✔ Multi-semester enrollment
--✔ System scalability
