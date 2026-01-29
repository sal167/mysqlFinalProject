create database School_Management;
/* I am creating a school management system for Werevu School using mysql */
use School_Management;

/* we will have 6 tables in the database. 
I. Students
II. Teachers
III. Classes
IV. Subjects
V. Enrollment
VI. Exams & Marks */

/* This is the table that will store the students data */ 
CREATE TABLE Students (
    StudentId INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE,
    Gender ENUM('Male','Female','Other'),
    Phone VARCHAR(15),
    Email VARCHAR(100)
);

INSERT INTO Students (FirstName, LastName, DateOfBirth, Gender, Phone, Email) VALUES
('John', 'Smith', '2010-05-12', 'Male', '1234567890', 'john@email.com'),
('Emma', 'Johnson', '2011-03-22', 'Female', '9876543210', 'emma@email.com'),
('Liam', 'Brown', '2010-11-02', 'Male', '5556667777', 'liam@email.com');

/* This table will store data related to teachers */
CREATE TABLE Teachers (
    TeacherId INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

INSERT INTO Teachers (FirstName, LastName, Email, Phone) VALUES
('Alice', 'Williams', 'alice@werevuschool.com', '1112223333'),
('Robert', 'Davis', 'robert@werevuschool.com', '4445556666'),
('Moha', 'grafix', 'moha@werevuschool.com','112233445566');

/* The subjects data will be stored on the subjects table */
CREATE TABLE Subjects (
    SubjectId INT AUTO_INCREMENT PRIMARY KEY,
    SubjectName VARCHAR(100) NOT NULL
);

INSERT INTO Subjects (SubjectName) VALUES
('Mathematics'),
('Science'),
('Kiswahili'),
('Biology'),
('History'),
('Geography'),
('Agriculture'),
('Science'),
('English');

/* This is where the number of training rooms will be stored. */
CREATE TABLE Classes (
    ClassId INT AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(50) NOT NULL,
    AcademicYear YEAR NOT NULL
);
INSERT INTO Classes (ClassName, AcademicYear) VALUES
('Grade 1', 2025),
('Grade 2', 2025),
('Grade 3', 2025),
('Grade 4', 2025),
('Grade 5', 2025),
('Grade 6', 2025),
('Grade 7', 2025),
('Grade 8', 2025);

/* A student can only be in one class per year. */
CREATE TABLE Enrollments (
    EnrollmentId INT AUTO_INCREMENT PRIMARY KEY,
    StudentId INT,
    ClassId INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentId) REFERENCES Students(StudentId),
    FOREIGN KEY (ClassId) REFERENCES Classes(ClassId)
);

INSERT INTO Enrollments (StudentId, ClassId, EnrollmentDate) VALUES
(1, 1, '2025-06-01'),
(2, 1, '2025-06-04'),
(1, 2, '2025-06-05'),
(2, 3, '2025-06-07'),
(1, 4, '2025-06-09'),
(2, 5, '2025-06-11'),
(3, 6, '2025-06-21');

/* subjects are taught in a class, and by a teacher. */
CREATE TABLE ClassSubjects (
    ClassSubjectId INT AUTO_INCREMENT PRIMARY KEY,
    ClassId INT,
    SubjectId INT,
    TeacherId INT,
    FOREIGN KEY (ClassId) REFERENCES Classes(ClassId),
    FOREIGN KEY (SubjectId) REFERENCES Subjects(SubjectId),
    FOREIGN KEY (TeacherId) REFERENCES Teachers(TeacherId)
);

/* Who teaches what */
INSERT INTO ClassSubjects (ClassId, SubjectId, TeacherId) VALUES
(1, 1, 1), -- Math Grade 8A by Alice
(1, 2, 2), -- Science Grade 8A by Robert
(2, 1, 1); -- Math Grade 9A by Alice

/* This table will store Exams details. */
CREATE TABLE Exams (
    ExamId INT AUTO_INCREMENT PRIMARY KEY,
    ExamName VARCHAR(100),
    ExamDate DATE,
    ClassSubjectId INT,
    FOREIGN KEY (ClassSubjectId) REFERENCES ClassSubjects(ClassSubjectId)
);

/* This will insert exam data into the table */
INSERT INTO Exams (ExamName, ExamDate, ClassSubjectId) VALUES
('Midterm English', '2025-09-15', 1),
('Midterm Kiswahili', '2025-09-15', 1),
('Midterm Biology', '2025-09-15', 1),
('Midterm Physics', '2025-09-15', 1),
('Midterm Math', '2025-09-15', 1),
('Midterm Art', '2025-09-16', 2);

/* This will store the data the student scores per exam */
CREATE TABLE Marks (
    MarkId INT AUTO_INCREMENT PRIMARY KEY,
    ExamId INT,
    StudentId INT,
    MarksObtained DECIMAL(5,2),
    FOREIGN KEY (ExamId) REFERENCES Exams(ExamId),
    FOREIGN KEY (StudentId) REFERENCES Students(StudentId)
);

INSERT INTO Marks (ExamId, StudentId, MarksObtained) VALUES
(1, 1, 88.5),
(1, 2, 92.0),
(2, 1, 79.0),
(2, 2, 85.5);

/* The Student Report Card */
SELECT 
s.FirstName, 
s.LastName,
sub.SubjectName,
e.ExamName, 
m.MarksObtained FROM Marks m JOIN Students s 
ON m.StudentId = s.StudentId JOIN Exams e 
ON m.ExamId = e.ExamId JOIN ClassSubjects cs 
ON e.ClassSubjectId = cs.ClassSubjectId JOIN Subjects sub 
ON cs.SubjectId = sub.SubjectId WHERE s.StudentId = 1;

/* Class Toppers per Exam */
SELECT 
e.ExamName,
 s.FirstName, 
 s.LastName, 
 MAX(m.MarksObtained) AS TopMarks 
 FROM Marks m JOIN Students s 
 ON m.StudentId = s.StudentId JOIN Exams e 
 ON m.ExamId = e.ExamId GROUP BY e.ExamId;
 
 /*The Students in a Classroom */
SELECT 
c.ClassName,
s.FirstName,
s.LastName FROM Enrollments en JOIN Students s 
ON en.StudentId = s.StudentId JOIN Classes c 
ON en.ClassId = c.ClassId WHERE c.ClassId = 1;

/* The Attendance Table */
CREATE TABLE Attendance (
    AttendanceId INT AUTO_INCREMENT PRIMARY KEY,
    StudentId INT,
    ClassId INT,
    Date DATE,
    Status ENUM('Present','Absent','Late'),
    FOREIGN KEY (StudentId) REFERENCES Students(StudentId),
    FOREIGN KEY (ClassId) REFERENCES Classes(ClassId)
);

INSERT INTO Attendance (StudentId, ClassId, Date, Status) VALUES
(1, 1, '2025-07-01', 'Present'),
(2, 1, '2025-07-01', 'Absent'),
(1, 1, '2025-07-02', 'Late');

/* To produce an Attendance report */
SELECT s.FirstName, s.LastName,
       SUM(Status='Present') AS Presents,
       SUM(Status='Absent') AS Absents,
       SUM(Status='Late') AS Lates 
       FROM Attendance a JOIN Students s ON a.StudentId = s.StudentId 
       GROUP BY s.StudentId;
       
 /* The Fees Structure */
CREATE TABLE Fees (
    FeeId INT AUTO_INCREMENT PRIMARY KEY,
    ClassId INT,
    FeeAmount DECIMAL(10,2),
    FOREIGN KEY (ClassId) REFERENCES Classes(ClassId)
);

/* The Student Payments */
CREATE TABLE Payments (
    PaymentId INT AUTO_INCREMENT PRIMARY KEY,
    StudentId INT,
    AmountPaid DECIMAL(10,2),
    PaymentDate DATE,
    FOREIGN KEY (StudentId) REFERENCES Students(StudentId)
);      

INSERT INTO Fees (ClassId, FeeAmount) VALUES
(1, 500.00),
(2, 600.00);

INSERT INTO Payments (StudentId, AmountPaid, PaymentDate) VALUES
(1, 300.00, '2025-06-10'),
(1, 200.00, '2025-07-10'),
(2, 500.00, '2025-06-15');

/* Outstanding Fees Report */
SELECT s.FirstName, s.LastName,
       f.FeeAmount,
       IFNULL(SUM(p.AmountPaid),0) AS Paid,
       (f.FeeAmount - IFNULL(SUM(p.AmountPaid),0)) AS Balance FROM Students s 
       JOIN Enrollments e ON s.StudentId = e.StudentId 
       JOIN Fees f ON e.ClassId = f.ClassIdLEFT JOIN Payments p 
       ON s.StudentId = p.StudentId 
       GROUP BY s.StudentId;
