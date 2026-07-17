-- =====================================================================
-- ALU_ Play with SQL Basics (RDBMS) Peer Group ActivityDB
-- Shared team file. Everyone commits their OWN section directly to git.
-- Do not squash everyone's work into one  commit per table/query.commit
-- =====================================================================

-- =====================================================================
-- 0. DATABASE
-- =====================================================================
CREATE DATABASE IF NOT EXISTS alu_db;
USE alu_db;

-- =====================================================================
-- 1. CREATE TABLE STATEMENTS (dependency order: A, B, C, D, E)
-- =====================================================================

-- ---------------------------------------------------------------------
-- MEMBER  Gary (gkarenzi- Students tablelang) A 
-- ---------------------------------------------------------------------
-- Depends on Classroom (Ketia) already existing.
-- Uses student_id 1-6, referencing classroom_id 1-5 that Ketia is
-- expected to insert.

-- Gary: CREATE TABLE
CREATE TABLE Students (
    student_id      INT PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    email           VARCHAR(100) UNIQUE,
    classroom_id    INT,
    enrollment_date DATE,
    FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id)
);

-- Gary: INSERT
INSERT INTO Students (student_id, name, email, classroom_id, enrollment_date) VALUES
(1, 'Gary Karenzi',  'gary.karenzi@alustudent.com',   1, '2026-01-10'),
(2, 'Ketia Mugisha', 'ketia.mugisha@alustudent.com',  2, '2026-01-10'),
(3, 'Nicia Agasaro', 'nicia.agasaro@alustudent.com',  3, '2026-01-11'),
(4, 'Noah Mugabo',   'noah.mugabo@alustudent.com',    4, '2026-01-11'),
(5, 'Don Uwase',     'don.uwase@alustudent.com',      5, '2026-01-12'),
(6, 'Alice Uwera',   'alice.uwera@alustudent.com',    1, '2026-01-12');

-- Gary: UPDATE
UPDATE Students
SET email = 'g.karenzi@alustudent.com'
WHERE student_id = 1;

-- Gary: DELETE
-- (student_id 6 is a "spare" row not referenced by any junction table,
-- so deleting it doesn't break Student_Courses/Student_Activities' FK
-- on student_id 1-5)
DELETE FROM Students
WHERE student_id = 6;

-- Gary: SELECT
SELECT student_id, name, email, enrollment_date
FROM Students
WHERE classroom_id = 1;


-- ---------------------------------------------------------------------
-- MEMBER  Ketia (kmugishate- Classroom tablecell) B
-- ---------------------------------------------------------------------
-- TODO (Ketia): write your own CREATE TABLE here, matching the diagram:
--   classroom_id INT           PK
--   room_number  VARCHAR(10)
--   building     VARCHAR(50)
--   capacity     INT
--
-- No foreign keys needed for this  build it first.table
-- Then below it add 5+ INSERT rows (classroom_id 1-5), 1 UPDATE, 1 DELETE,
-- 1 SELECT with WHERE, each labeled "-- Ketia: ..."


-- ---------------------------------------------------------------------
-- ---------------------------------------------------------------------
-- ---------------------------------------------------------------------
-- Faculty table (Nicia)
-- ---------------------------------------------------------------------
CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department VARCHAR(50)
);

INSERT INTO Faculty (faculty_id, name, email, department) VALUES
(1, 'Gary Karenzi', 'gary.karenzi@alustudent.com', 'Computer Science'),
(2, 'Ketia Mugisha', 'ketia.mugisha@alustudent.com', 'Mathematics'),
(3, 'Nicia Agasaro', 'nicia.agasaro@alustudent.com', 'Business'),
(4, 'Noah Mugabo', 'noah.mugabo@alustudent.com', 'Agriculture'),
(5, 'Don Uwase', 'don.uwase@alustudent.com', 'Computer Science');

UPDATE Faculty
SET department = 'Data Science'
WHERE faculty_id = 5;

INSERT INTO Faculty (faculty_id, name, email, department) VALUES
(6, 'Alice Uwera', 'alice.uwera@alustudent.com', 'Temp Dept');
DELETE FROM Faculty
WHERE faculty_id = 6;

SELECT name, email
FROM Faculty
WHERE department = 'Computer Science';



-- ---------------------------------------------------------------------
-- MEMBER   Courses tableNoah D
-- ---------------------------------------------------------------------
-- Depends on Faculty (Nicia) and Classroom (Ketia) already existing.
-- Uses course_id 1-6, referencing faculty_id/classroom_id 1-5 that
-- Nicia and Ketia are expected to insert.

CREATE TABLE Courses (
    course_id    INT PRIMARY KEY,
    course_name  VARCHAR(100) NOT NULL,
    credits      INT,
    faculty_id   INT,
    classroom_id INT,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id),
    FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id)
);

-- -- Noah: INSERT
INSERT INTO Courses (course_id, course_name, credits, faculty_id, classroom_id) VALUES
(1, 'Introduction to Databases',       3, 1, 1),
(2, 'Calculus I',                      4, 2, 2),
(3, 'Data Structures and Algorithms',  4, 3, 3),
(4, 'Academic Writing',                2, 4, 4),
(5, 'Physics I',                       3, 5, 5),
(6, 'Introduction to Economics',       3, 1, 2);

-- -- Noah: UPDATE
UPDATE Courses
SET credits = 5
WHERE course_name = 'Data Structures and Algorithms';

-- -- Noah: DELETE
-- (course_id 6 is a "spare" row not referenced by any junction table,
-- so deleting it doesn't break Student_Courses' FK on course_id 1-5)
DELETE FROM Courses
WHERE course_id = 6;

-- -- Noah: SELECT
SELECT course_name, credits
FROM Courses
WHERE credits >= 4;


-- ---------------------------------------------------------------------
-- MEMBER   Extra_Curricular_Activities + junction tablesDon E
-- ---------------------------------------------------------------------
-- Depends on Faculty, Students, and Courses already existing.
-- Assumes faculty_id 1-5 (Faculty), student_id 1-5 (Students),
-- course_id 1-5 (Courses) exist per teammates' inserts above.

CREATE TABLE Extra_Curricular_Activities (
    activity_id       INT PRIMARY KEY AUTO_INCREMENT,
    activity_name     VARCHAR(100) NOT NULL,
    category          VARCHAR(50),
    faculty_advisor_id INT,
    FOREIGN KEY (faculty_advisor_id) REFERENCES Faculty(faculty_id)
);

-- Junction table: Students <-> Courses (many-to-many)
CREATE TABLE Student_Courses (
    student_course_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id  INT NOT NULL,
    course_id   INT NOT NULL,
    enrolled_on DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id)  REFERENCES Courses(course_id)
);

-- Junction table: Students <-> Extra_Curricular_Activities (many-to-many)
CREATE TABLE Student_Activities (
    student_activity_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id  INT NOT NULL,
    activity_id INT NOT NULL,
    joined_on   DATE,
    FOREIGN KEY (student_id)  REFERENCES Students(student_id),
    FOREIGN KEY (activity_id) REFERENCES Extra_Curricular_Activities(activity_id)
);

-- =====================================================================
-- 2. INSERT STATEMENTS
-- =====================================================================

-- -- Don: INSERT (Extra_Curricular_Activities)
INSERT INTO Extra_Curricular_Activities (activity_name, category, faculty_advisor_id) VALUES
('Debate Club',        'Academic',   1),
('Football Team',      'Sports',     2),
('Coding Society',     'Technology', 3),
('Drama Club',         'Arts',       4),
('Community Outreach', 'Volunteer',  5);

-- -- Don: INSERT (Student_Courses junction)
INSERT INTO Student_Courses (student_id, course_id, enrolled_on) VALUES
(1, 1, '2026-01-15'),
(2, 2, '2026-01-15'),
(3, 3, '2026-01-16'),
(4, 4, '2026-01-16'),
(5, 5, '2026-01-17');

-- -- Don: INSERT (Student_Activities junction)
INSERT INTO Student_Activities (student_id, activity_id, joined_on) VALUES
(1, 1, '2026-02-01'),
(2, 2, '2026-02-01'),
(3, 3, '2026-02-02'),
(4, 4, '2026-02-02'),
(5, 5, '2026-02-03');

-- =====================================================================
-- 3. INDIVIDUAL UPDATE / DELETE / SELECT (labeled by member)
-- =====================================================================

-- -- Don: UPDATE
UPDATE Extra_Curricular_Activities
SET category = 'STEM'
WHERE activity_name = 'Coding Society';

-- -- Don: DELETE
DELETE FROM Student_Activities
WHERE student_id = 5 AND activity_id = 5;

-- -- Don: SELECT
SELECT activity_name, category
FROM Extra_Curricular_Activities
WHERE category = 'Sports';

-- =====================================================================
-- 4. GROUP TASKS (do together once all 5 tables + junctions have data)
-- =====================================================================

-- --- Normalization check (write as a group, replace this paragraph) ---
-- TODO: Discuss as a  does any table repeat data that should liveteam
-- elsewhere? Do the junction tables correctly avoid many-to-many
-- duplication? Write your agreed answer here as a short paragraph.

-- --- Join query 1: Student enrolled in Course, taught by Faculty, in Classroom ---
SELECT s.name  AS student_name,
       co.course_name,
       f.name  AS faculty_name,
       cl.room_number,
       cl.building
FROM Student_Courses sc
JOIN Students   s  ON sc.student_id = s.student_id
JOIN Courses    co ON sc.course_id  = co.course_id
JOIN Faculty    f  ON co.faculty_id = f.faculty_id
JOIN Classroom  cl ON co.classroom_id = cl.classroom_id;

-- --- Join query 2: Student participates in Activity, advised by Faculty ---
SELECT s.name AS student_name,
       a.activity_name,
       f.name AS faculty_advisor
FROM Student_Activities sa
JOIN Students s ON sa.student_id = s.student_id
JOIN Extra_Curricular_Activities a ON sa.activity_id = a.activity_id
JOIN Faculty f ON a.faculty_advisor_id = f.faculty_id;

-- --- Join query 3: (team's choice) ---
-- TODO: write one more JOIN query as a group.

-- --- Aggregate query: number of students per course ---
SELECT co.course_name, COUNT(sc.student_id) AS num_students
FROM Courses co
LEFT JOIN Student_Courses sc ON co.course_id = sc.course_id
GROUP BY co.course_name;
