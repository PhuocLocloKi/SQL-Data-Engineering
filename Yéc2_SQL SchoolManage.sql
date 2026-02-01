/*
 * PROJECT: STUDENT MANAGEMENT SYSTEM
 * PURPOSE: Database Schema, Data Seeding, and Analytical Queries
 */

-- =====================================================
-- 1. DATABASE & SCHEMA SETUP (DDL)
-- =====================================================
CREATE DATABASE YEC2_StudentManagement;
GO
USE YEC2_StudentManagement;
GO

-- Table: Major (Academic Disciplines)
CREATE TABLE Major (
   Major_ID CHAR(2) NOT NULL,
   Major_Name VARCHAR(30) NOT NULL,
   CONSTRAINT PK_Major_ID PRIMARY KEY (Major_ID),
   CONSTRAINT UQ_Major_Name UNIQUE (Major_Name)
);

-- Table: Student
CREATE TABLE Student (
   Student_ID CHAR(8) NOT NULL,
   Student_Name VARCHAR(30) NOT NULL,
   Mid CHAR(2) NOT NULL, -- Major ID
   CONSTRAINT PK_Student_ID PRIMARY KEY (Student_ID),
   CONSTRAINT FK_Student_MID_Major_ID FOREIGN KEY (Mid) REFERENCES Major(Major_ID)
);

-- Table: Teacher
CREATE TABLE Teacher (
   Teacher_ID CHAR(8) NOT NULL,
   Teacher_Name VARCHAR(30) NOT NULL,
   CONSTRAINT PK_Teacher_ID PRIMARY KEY (Teacher_ID)
);

-- Table: Room (Classroom Assignments / Schedule)
-- Represents the relationship between Student, Teacher, and Room
CREATE TABLE Room (
   SEQ INT IDENTITY(1,1) NOT NULL,
   RoomName CHAR(4) NOT NULL,
   Student_ID CHAR(8) NOT NULL,
   Teacher_ID CHAR(8) NOT NULL,
   CONSTRAINT PK_Room_SEQ PRIMARY KEY (SEQ),
   CONSTRAINT FK_Room_Student FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID),
   CONSTRAINT FK_Room_Teacher FOREIGN KEY (Teacher_ID) REFERENCES Teacher(Teacher_ID)
);

-- =====================================================
-- 2. DATA SEEDING (DML)
-- =====================================================

-- Insert Majors
INSERT INTO Major VALUES ('SB', 'Business Administration');
INSERT INTO Major VALUES ('SE', 'Software Engineering');
INSERT INTO Major VALUES ('GD', 'Graphic Design');

-- Insert Students
INSERT INTO Student VALUES ('S1', 'Hung', 'SB');
INSERT INTO Student VALUES ('S2', 'Kiet', 'SB');
INSERT INTO Student VALUES ('S3', 'Tuan', 'SE');
INSERT INTO Student VALUES ('S4', 'Huong', 'SE');
INSERT INTO Student VALUES ('S5', 'Tam', 'SE');
INSERT INTO Student VALUES ('S6', 'Phuoc', 'GD');
INSERT INTO Student VALUES ('S7', 'Phuong', 'GD');

-- Insert Teachers
INSERT INTO Teacher VALUES ('T1', 'Hoang');
INSERT INTO Teacher VALUES ('T2', 'Khanh');
INSERT INTO Teacher VALUES ('T3', 'Hoa');

-- Insert Room Assignments (Who studies with whom in which room)
INSERT INTO Room VALUES ('R001', 'S1', 'T1');
INSERT INTO Room VALUES ('R001', 'S2', 'T1');
INSERT INTO Room VALUES ('R002', 'S4', 'T1');
INSERT INTO Room VALUES ('R002', 'S3', 'T2');
INSERT INTO Room VALUES ('R002', 'S4', 'T2');
INSERT INTO Room VALUES ('R003', 'S5', 'T3');
INSERT INTO Room VALUES ('R003', 'S6', 'T3');
INSERT INTO Room VALUES ('R003', 'S7', 'T3');

-- =====================================================
-- 3. ANALYTICAL QUERIES
-- =====================================================

-- 1. List all students taught by teacher 'Hoang'
-- Approach: Subquery to filter by Teacher Name within the Room table.
SELECT Student_Name
FROM Student
WHERE Student_ID IN (
    SELECT Student_ID FROM Room
    WHERE Teacher_ID = (SELECT Teacher_ID FROM Teacher WHERE Teacher_Name = 'Hoang')
);

-- 2. List students taught by 'Hoang' who are NOT in the 'SE' major
-- Logic: Find students of Hoang, then filter out those with Mid = 'SE'.
SELECT * FROM Student
WHERE Student_ID IN (
    SELECT Student_ID FROM Room
    WHERE Teacher_ID = (SELECT Teacher_ID FROM Teacher WHERE Teacher_Name = 'Hoang')
)
AND Mid <> 'SE';

-- 3. Count the total number of students studying under teacher 'Hoang'
-- (Note: Original comment said 'Khanh', but code said 'Hoang'. Corrected to match code).
SELECT COUNT(Student_ID) 
FROM Room
WHERE Teacher_ID = (SELECT Teacher_ID FROM Teacher WHERE Teacher_Name = 'Hoang');

-- 4. Calculate the number of distinct students per teacher
-- Uses JOINs to display Teacher Name instead of ID.
SELECT t.Teacher_Name, COUNT(DISTINCT r.Student_ID) AS Student_Count
FROM Room r
JOIN Teacher t ON r.Teacher_ID = t.Teacher_ID
GROUP BY t.Teacher_Name;

-- 6. List all students along with the teachers they study with
-- Uses LEFT JOIN to include students even if they aren't assigned a room/teacher.
SELECT S.*, T.*
FROM Student S 
LEFT JOIN Room R ON S.Student_ID = R.Student_ID
LEFT JOIN Teacher T ON R.Teacher_ID = T.Teacher_ID;

-- 7. List information of teachers for the student with ID 'S4'
SELECT S.Student_Name, T.Teacher_Name
FROM Student S 
LEFT JOIN Room R ON S.Student_ID = R.Student_ID
LEFT JOIN Teacher T ON R.Teacher_ID = T.Teacher_ID
WHERE S.Student_ID = 'S4';

-- 8. Identify the teacher with the highest number of students
-- Logic: Group by teacher, Count students, then filter using HAVING >= ALL (Counts).
SELECT t.Teacher_Name, COUNT(DISTINCT r.Student_ID) AS Student_Count
FROM Room r
JOIN Teacher t ON r.Teacher_ID = t.Teacher_ID
GROUP BY t.Teacher_Name
HAVING COUNT(DISTINCT r.Student_ID) >= ALL (
    SELECT COUNT(DISTINCT r2.Student_ID)
    FROM Room r2
    GROUP BY r2.Teacher_ID
);



-- 9. Identify the classroom with the highest student occupancy
SELECT RoomName, COUNT(Student_ID) AS SL
FROM Room
GROUP BY RoomName
HAVING COUNT(Student_ID) >= ALL (
    SELECT COUNT(Student_ID)
    FROM Room
    GROUP BY RoomName
);

-- 10. Identify the teacher who teaches the highest number of 'SE' major students
-- Logic: Join Student to Room to check Major, Group by Teacher, Find Max Count.
SELECT R.Teacher_ID, COUNT(S.Student_ID) AS SL
FROM Student S 
RIGHT JOIN Room R ON S.Student_ID = R.Student_ID
WHERE S.Mid = 'SE'
GROUP BY R.Teacher_ID
HAVING COUNT(S.Student_ID) >= ALL (
    SELECT COUNT(S2.Student_ID)
    FROM Student S2 
    RIGHT JOIN Room R2 ON S2.Student_ID = R2.Student_ID
    WHERE S2.Mid = 'SE'
    GROUP BY R2.Teacher_ID
);