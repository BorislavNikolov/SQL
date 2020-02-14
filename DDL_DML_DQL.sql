--1
CREATE DATABASE School

CREATE TABLE Students (
       Id INT IDENTITY(1, 1) PRIMARY KEY,
       FirstName NVARCHAR(30) NOT NULL,
       MiddleName NVARCHAR(25),
       LastName NVARCHAR(30) NOT NULL,
       Age INT CHECK(Age >= 5 AND Age <= 100),
       Address NVARCHAR(50),
       Phone NCHAR(10)
)

CREATE TABLE Subjects (
       Id INT IDENTITY(1, 1) PRIMARY KEY,
       Name NVARCHAR(20) NOT NULL,
       Lessons INT CHECK(Lessons > 0) NOT NULL
)

CREATE TABLE StudentsSubjects (
       Id INT IDENTITY(1, 1) PRIMARY KEY,
       StudentId INT NOT NULL REFERENCES Students(Id),
       SubjectId INT NOT NULL REFERENCES Subjects(Id),
       Grade Decimal(3, 2) CHECK(Grade >= 2 AND Grade <= 6) NOT NULL
)

CREATE TABLE Exams (
       Id INT IDENTITY(1, 1) PRIMARY KEY,
       Date DATETIME2,
       SubjectId INT NOT NULL REFERENCES Subjects(Id)
)

CREATE TABLE StudentsExams (
       StudentId INT NOT NULL REFERENCES Students(Id),
       ExamId INT NOT NULL REFERENCES Exams(Id),
       Grade Decimal(3, 2) CHECK(Grade >= 2 AND Grade <= 6) NOT NULL

       PRIMARY KEY(StudentId, ExamId)
)

CREATE TABLE Teachers (
       Id INT IDENTITY(1, 1) PRIMARY KEY,
       FirstName NVARCHAR(20) NOT NULL,
       LastName NVARCHAR(20) NOT NULL,
       Address NVARCHAR(20) NOT NULL,
       Phone NCHAR(10),
       SubjectId INT NOT NULL REFERENCES Subjects(Id)
)

CREATE TABLE StudentsTeachers (
       StudentId INT NOT NULL REFERENCES Students(Id),
       TeacherId INT NOT NULL REFERENCES Teachers(Id)

       PRIMARY KEY(StudentId, TeacherId)
)
--2
INSERT INTO Teachers(FirstName, LastName, Address, Phone, SubjectId)
	   VALUES ('Ruthanne', 'Bamb', '84948 Mesta Junction', '3105500146', 6),
			  ('Gerrard', 'Lowin', '370 Talisman Plaza', '3324874824', 2),
			  ('Merrile', 'Lambdin', '81 Dahle Plaza', '4373065154', 5),
			  ('Bert', 'Ivie', '2 Gateway Circle', '4409584510', 4)

INSERT INTO Subjects(Name, Lessons)
	   VALUES ('Geometry', 12),
			  ('Health', 10),
			  ('Drama', 7),
			  ('Sports', 9)
--3
UPDATE StudentsSubjects
   SET Grade = 6.00
 WHERE SubjectId IN (1, 2) AND Grade >= 5.50
--4
DELETE 
  FROM StudentsTeachers
 WHERE TeacherId IN (SELECT t.Id
					   FROM Teachers t
					  WHERE t.Phone LIKE '%72%')

DELETE 
  FROM Teachers
 WHERE Phone LIKE '%72%'
--5
 SELECT s.FirstName,
	     s.LastName,
	     s.Age
    FROM Students s
   WHERE s.Age >= 12
ORDER BY s.FirstName,
		 s.LastName
--6
SELECT s.FirstName,
	     s.LastName,
	     COUNT(st.TeacherId) AS TeachersCount
    FROM Students s
	JOIN StudentsTeachers st
	  ON st.StudentId = s.Id
GROUP BY s.FirstName,
		 s.LastName
--7
 SELECT s.FirstName + ' ' + s.LastName AS [Full Name]
    FROM Students s
   WHERE s.Id NOT IN (SELECT se.StudentId
						FROM StudentsExams se)
ORDER BY [Full Name]
--8
SELECT TOP 10
		 s.FirstName,
	     s.LastName,
		 CAST(ROUND(AVG(se.Grade), 2) AS DECIMAL(3,2)) AS Grade
    FROM Students s
	JOIN StudentsExams se
	  ON se.StudentId = s.Id
GROUP BY s.FirstName,
		 s.LastName
ORDER BY Grade DESC,
		 s.FirstName,
		 s.LastName
--9
SELECT s.FirstName + ' ' + ISNULL(s.MiddleName + ' ', '') + s.LastName AS [Full Name]
    FROM Students s
   WHERE s.Id NOT IN (SELECT ss.StudentId
						FROM StudentsSubjects ss)
ORDER BY [Full Name]
--10
SELECT s.Name,
		 AVG(ss.Grade)
	FROM Subjects s
	JOIN StudentsSubjects ss
	  ON ss.SubjectId = s.Id
GROUP BY s.Id,
		 s.Name
ORDER BY s.Id
--11
CREATE FUNCTION udf_ExamGradesToUpdate(@studentId INT, @grade DECIMAL(3, 2))
RETURNS NVARCHAR(100)
  BEGIN
		DECLARE @studentFirstName NVARCHAR(30) = (SELECT s.FirstName
													FROM Students s
												   WHERE s.Id = @studentId)

		IF(@studentFirstName IS NULL)
		BEGIN
		      RETURN 'The student with provided id does not exist in the school!'
		END

		IF(@grade > 6)
		BEGIN
		      RETURN 'Grade cannot be above 6.00!'
		END

		DECLARE @countOfGrades INT = (SELECT COUNT(se.Grade)
										FROM StudentsExams se
									   WHERE se.StudentId = @studentId
									     AND se.Grade >= @grade
										 AND se.Grade <= @grade + 0.5)

		RETURN CONCAT('You have to update ', @countOfGrades, ' grades for the student ', @studentFirstName)
    END
--12
CREATE PROC usp_ExcludeFromSchool(@StudentId INT)
     AS
DECLARE @id INT = (SELECT s.Id
					 FROM Students s
					WHERE s.Id = @studentId)

IF (@id IS NULL)
BEGIN
	  RAISERROR('This school has no student with the provided id!', 16, 1)
      RETURN
END

DELETE
  FROM StudentsSubjects
 WHERE StudentId = @StudentId

DELETE
FROM StudentsExams
WHERE StudentId = @StudentId

DELETE
  FROM StudentsTeachers
 WHERE StudentId = @StudentId

DELETE
  FROM Students
 WHERE Id = @StudentId