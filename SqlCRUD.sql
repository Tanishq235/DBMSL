CREATE TABLE department (
dept_id SERIAL PRIMARY KEY,
dept_name VARCHAR(100),
dept_location VARCHAR(100)
);

CREATE TABLE employee (
emp_id SERIAL PRIMARY KEY,
emp_fname VARCHAR(100),
emp_lname VARCHAR(100),
dept_id INT REFERENCES department(dept_id),
emp_position VARCHAR(100),
emp_salary DECIMAL(10,2),
emp_joindate DATE
);

INSERT INTO department (dept_name, dept_location)
VALUES
('Computer', 'Pune'),
('IT', 'Mumbai'),
('HR', 'Delhi');

INSERT INTO employee (emp_fname, emp_lname, dept_id, emp_position, emp_salary, emp_joindate)
VALUES
('Sahil', 'Agarwal', 1, 'Developer', 55000, '2022-06-01'),
('A', 'B', 2, 'Tester', 45000, '2021-01-15'),
('B', 'C', 1, 'Analyst', 60000, '2020-07-20'),
('C', 'D', 3, 'HR', 48000, '2023-03-05');


\dt
SELECT * FROM department;

CREATE VIEW emp_dept_view AS
SELECT
e.emp_id,
e.emp_fname,
e.emp_lname,
e.emp_position,
e.emp_salary,
d.dept_name,
d.dept_location
FROM employee e
JOIN department d
ON e.dept_id = d.dept_id;


SELECT * FROM emp_dept_view;


CREATE INDEX idx_emp_lname ON employee(emp_lname);


SELECT * FROM department;


SELECT * FROM employee;


SELECT emp_fname, emp_lname, emp_salary FROM employee WHERE emp_salary > 50000;


UPDATE employee SET emp_salary = 47000 WHERE emp_fname = 'A' AND emp_lname = 'B';
SELECT emp_fname, emp_salary FROM employee;


DELETE FROM employee WHERE emp_fname = 'C' AND emp_lname = 'D';
SELECT * FROM employee;


ALTER TABLE employee ADD COLUMN emp_experience INT;


UPDATE employee SET emp_experience = 2 WHERE emp_fname = 'A' AND emp_lname = 'B';
UPDATE employee SET emp_experience = 3 WHERE emp_fname = 'Sahil' AND emp_lname = 'Agarwal';


SELECT e.emp_fname, e.emp_lname, d.dept_name
FROM employee e
JOIN department d ON e.dept_id = d.dept_id;

SELECT COUNT(*) AS total_employees FROM employee;


SELECT emp_fname, emp_lname, emp_salary FROM employee ORDER BY emp_salary DESC;


\dv
\di
