CREATE DATABASE  ahmad

CREATE TABLE Department(
	dept_id INT,
	[name] VARCHAR(20),
	PRIMARY KEY (dept_id)
);

CREATE TABLE Student(
	roll_no INT PRIMARY KEY, 
	[name] VARCHAR(20), 
	dept_id INT, 
	batch INT,
	FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Course (
	course_id INT PRIMARY KEY, 
	[name] VARCHAR(20), 
	credit_hrs INT, 
	dept_id INT,
	FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Section (
	section_id INT PRIMARY KEY, 
	course_id INT, 
	capacity INT,
	FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Enrolled (
	student_roll_no INT, 
	section_id INT,
	FOREIGN KEY (student_roll_no) REFERENCES Student(roll_no),
	FOREIGN KEY (section_id) REFERENCES Section(section_id)
);

CREATE TABLE Faculty(
	faculty_id INT PRIMARY KEY, 
	[name] VARCHAR(20), 
	dept_id INT,
	FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

SELECT * FROM Enrolled;
SELECT * FROM Faculty;
SELECT * FROM Section;
SELECT * FROM Course;
SELECT * FROM Student;
SELECT * FROM Department;

INSERT INTO Department VALUES (10, 'CS');
INSERT INTO Department VALUES (20, 'EE');
INSERT INTO Department VALUES (30, 'MG');
INSERT INTO Department VALUES (40, 'CV');
select *from department
INSERT INTO Faculty VALUES (1, 'sarim baig', 10);
INSERT INTO Faculty VALUES (2, 'Saddam', 10);
INSERT INTO Faculty VALUES (3, 'sameen iftikhar', 30);
INSERT INTO Faculty VALUES (4, 'hamza', 20);
select *from faculty
INSERT INTO COURSE VALUES (1, 'oop', 3, 10);
INSERT INTO COURSE VALUES (2, 'Ap', 3, 20);
INSERT INTO COURSE VALUES (3, 'DATABASE SYSTEMS', 3, 30);
INSERT INTO COURSE VALUES (4, 'pf', 1, 10);
select *from Course
INSERT INTO Section VALUES (1, 1, 40);
INSERT INTO Section VALUES (2, 4, 10);
INSERT INTO Section VALUES (3, 3, 22);
INSERT INTO Section VALUES (4, 2, 5);
select *from Section
INSERT INTO Student VALUES (1244,'ali',10,2018);
INSERT INTO Student VALUES (1081,'ahmad',10,2018);
INSERT INTO Student VALUES (1019,'zain',30,2016);
INSERT INTO Student VALUES (0940,'abdullah',20,2017);
select *from Student
INSERT INTO Enrolled VALUES (1244,1);
INSERT INTO Enrolled VALUES (1081,2);
INSERT INTO Enrolled VALUES (0940,4);
 
--1
CREATE TABLE Auditing (
	audit_id INT NOT NULL IDENTITY (1,1) UNIQUE,
	Last_change_on DATE
);

SELECT * FROM Auditing;

GO 

CREATE TRIGGER q1 
ON Student
AFTER UPDATE, INSERT
AS
BEGIN
	INSERT INTO Auditing VALUES(GETDATE());
END;

UPDATE Student
SET [name] = 'fahad'
WHERE [name] = 'ahmad';

GO

CREATE TRIGGER q1d 
ON Department
AFTER UPDATE, INSERT
AS
BEGIN
	INSERT INTO Auditing VALUES(GETDATE());
END;

GO

CREATE TRIGGER q1f 
ON Faculty
AFTER UPDATE, INSERT
AS
BEGIN
	INSERT INTO Auditing VALUES(GETDATE());
END;

--2
ALTER TABLE Auditing ADD Discription VARCHAR(20);
SELECT * FROM Auditing;

GO

ALTER TRIGGER q1
ON Student
AFTER UPDATE, INSERT
AS
BEGIN
	INSERT INTO Auditing VALUES (GETDATE(), 'Student table');
END;

UPDATE Student
SET batch = 2015
WHERE roll_no = 0940;

SELECT * FROM Auditing;

GO

ALTER TRIGGER q1d
ON Department
AFTER UPDATE, INSERT
AS
BEGIN
	INSERT INTO Auditing VALUES (GETDATE(), 'Department table');
END;

GO

ALTER TRIGGER q1f
ON Faculty
AFTER UPDATE, INSERT
AS
BEGIN
	INSERT INTO Auditing VALUES (GETDATE(), 'Faculty table');
END;

UPDATE Faculty
SET dept_id = 40
WHERE faculty_id = 4;

SELECT * FROM Faculty;
SELECT * FROM Auditing;

--3
GO

CREATE VIEW q3 
AS 
SELECT section_id , Course.[name], Section.capacity FROM Section 
JOIN Course ON Section.course_id = Course.course_id;

SELECT * FROM q3 WHERE section_id = 1;
--4
GO

CREATE PROCEDURE q4
@section_id INT
AS
BEGIN
	IF EXISTS (SELECT section_id FROM Section WHERE section_id = @section_id)
	BEGIN
		SELECT section_id, Course.course_id, capacity, [name], credit_hrs, dept_id FROM Section 
		JOIN Course ON Section.course_id = Course.course_id
		WHERE section_id = @section_id;
	END
	ELSE 
	BEGIN
		PRINT 'data not found ';
	END
END;

DECLARE @id INT;
SET @id = 1;

EXECUTE q4 @id;

--5
GO
CREATE TRIGGER q5
ON Department
INSTEAD OF UPDATE, DELETE, INSERT
AS
BEGIN
	PRINT 'YOU CANNOT DELETE UPDATE AND INSERT DEPARAMENT TABLE'	
END;

DELETE FROM Department;
INSERT INTO Department VALUES(50,'AF');
SELECT * FROM Department;

--6
GO

CREATE TRIGGER q6
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
BEGIN
	PRINT 'you can not modify or drop any table';
END;

ALTER TABLE Student ADD r INT;
DROP TABLE Auditing;