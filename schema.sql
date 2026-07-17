-- =====================================================================
-- ALU_DB — Play with SQL Basics (RDBMS) Peer Group Activity
-- Shared team file. Everyone commits their OWN section directly to git.
-- Do not squash everyone's work into one commit — commit per table/query.
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
-- MEMBER A — Gary (gkarenzi-lang) — Students table
-- ---------------------------------------------------------------------
-- TODO (Gary): write your own CREATE TABLE here, matching the diagram:
--   student_id     INT           PK
--   name           VARCHAR(100)
--   email          VARCHAR(100)
--   classroom_id   INT           FK -> Classroom(classroom_id)
--   enrollment_date DATE
--
-- Then below it add:
--   - 5+ INSERT INTO Students sample rows (use student_id 1-5)
--   - 1 UPDATE statement, 1 DELETE statement  (comment: -- Gary: UPDATE / -- Gary: DELETE)
--   - 1 SELECT with a WHERE clause            (comment: -- Gary: SELECT)


-- ---------------------------------------------------------------------
-- MEMBER B — Ketia (kmugishate-cell) — Classroom table
-- ---------------------------------------------------------------------
-- TODO (Ketia): write your own CREATE TABLE here, matching the diagram:
--   classroom_id INT           PK
--   room_number  VARCHAR(10)
--   building     VARCHAR(50)
--   capacity     INT
--
-- No foreign keys needed for this table — build it first.
-- Then below it add 5+ INSERT rows (classroom_id 1-5), 1 UPDATE, 1 DELETE,
-- 1 SELECT with WHERE, each labeled "-- Ketia: ..."


-- ---------------------------------------------------------------------
-- MEMBER C — Nicia — Faculty table
-- ---------------------------------------------------------------------
-- TODO (Nicia): write your own CREATE TABLE here, matching the diagram:
--   faculty_id INT           PK
--   name       VARCHAR(100)
--   email      VARCHAR(100)
--   department VARCHAR(50)
--
-- No foreign keys needed — build alongside Classroom.
-- IMPORTANT: use faculty_id 1-5, since Courses (Noah) and
-- Extra_Curricular_Activities (Don) reference these IDs.
-- Then add 5+ INSERT rows, 1 UPDATE, 1 DELETE, 1 SELECT with WHERE,
-- each labeled "-- Nicia: ..."


-- ---------------------------------------------------------------------
-- MEMBER D — Noah — Courses table
-- ---------------------------------------------------------------------
-- TODO (Noah): write your own CREATE TABLE here, matching the diagram:
--   course_id    INT           PK
--   course_name  VARCHAR(100)
--   credits      INT
--   faculty_id   INT           FK -> Faculty(faculty_id)
--   classroom_id INT           FK -> Classroom(classroom_id)
--
-- Depends on Faculty (Nicia) and Classroom (Ketia) already existing.
-- Use course_id 1-5, and reference faculty_id/classroom_id values that
-- Nicia and Ketia actually inserted (1-5).
-- Then add 5+ INSERT rows, 1 UPDATE, 1 DELETE, 1 SELECT with WHERE,
-- each labeled "-- Noah: ..."


-- ---------------------------------------------------------------------
-- MEMBER E — Don — Extra_Curricular_Activities + junction tables
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
-- TODO: Discuss as a team — does any table repeat data that should live
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
