
CREATE DATABASE exp2;


CREATE TABLE student (
student_id SERIAL PRIMARY KEY,
student_fname VARCHAR(100),
student_lname VARCHAR(100),
city VARCHAR(100),
age INT
);

CREATE TABLE course (
course_id SERIAL PRIMARY KEY,
course_name VARCHAR(100),
course_duration VARCHAR(50)
);

CREATE TABLE enrollment (
enroll_id SERIAL PRIMARY KEY,
student_id INT REFERENCES student(student_id),
course_id INT REFERENCES course(course_id),
enroll_date DATE
);

\
INSERT INTO student (student_fname, student_lname, city, age) VALUES
('Sahil', 'Agarwal', 'Pune', 21),
('A', 'B', 'Mumbai', 22),
('B', 'C', 'Delhi', 20),
('C', 'D', 'Pune', 23);

INSERT INTO course (course_name, course_duration) VALUES
('DBMS', '3 Months'),
('OS', '2 Months'),
('Networks', '4 Months');

INSERT INTO enrollment (student_id, course_id, enroll_date) VALUES
(1, 1, '2023-05-10'),
(2, 2, '2023-06-01'),
(3, 1, '2023-06-15'),
(4, 3, '2023-07-01');


\dt
SELECT * FROM student;
SELECT * FROM course;
SELECT * FROM enrollment;



SELECT s.student_fname, s.student_lname, c.course_name
FROM student s
INNER JOIN enrollment e ON s.student_id = e.student_id
INNER JOIN course c ON e.course_id = c.course_id;


SELECT s.student_fname, s.student_lname, c.course_name
FROM student s
LEFT JOIN enrollment e ON s.student_id = e.student_id
LEFT JOIN course c ON e.course_id = c.course_id;


SELECT s.student_fname, s.student_lname, c.course_name
FROM student s
RIGHT JOIN enrollment e ON s.student_id = e.student_id
RIGHT JOIN course c ON e.course_id = c.course_id;


SELECT s.student_fname, s.student_lname, c.course_name
FROM student s
FULL JOIN enrollment e ON s.student_id = e.student_id
FULL JOIN course c ON e.course_id = c.course_id;


SELECT * FROM student
WHERE age = (SELECT MAX(age) FROM student);


SELECT * FROM student
WHERE city IN (SELECT city FROM student WHERE student_fname = 'Sahil');


SELECT s.student_fname, s.student_lname
FROM student s
WHERE EXISTS (SELECT 1 FROM enrollment e WHERE e.student_id = s.student_id);



CREATE OR REPLACE VIEW student_course_view AS
SELECT
s.student_fname,
s.student_lname,
c.course_name,
e.enroll_date
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
JOIN course c ON e.course_id = c.course_id;
r
SELECT * FROM student_course_view;

SELECT * FROM student;


SELECT * FROM course;

SELECT * FROM student WHERE city = 'Pune';

SELECT COUNT(*) AS total_enrolled FROM enrollment;

UPDATE student SET city = 'Nashik' WHERE student_fname = 'A' AND student_lname = 'B';

DELETE FROM course WHERE course_name = 'OS';

SELECT * FROM course;

SELECT s.student_fname, s.student_lname
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
JOIN course c ON e.course_id = c.course_id
WHERE c.course_name = 'DBMS';

SELECT AVG(age) AS average_age FROM student;

SELECT * FROM student ORDER BY age DESC;

\dv
SELECT * FROM student_course_view;
