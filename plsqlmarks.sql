
CREATE TABLE Stud_Marks (
    Roll SERIAL PRIMARY KEY,
    Name VARCHAR(50),
    Total_Marks INT
);

CREATE TABLE Result (
    Roll INT,
    Name VARCHAR(50),
    Class VARCHAR(50),
    FOREIGN KEY (Roll) REFERENCES Stud_Marks(Roll)
);


CREATE OR REPLACE PROCEDURE proc_Grade(IN p_roll INT, IN p_name VARCHAR, IN p_marks INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_class VARCHAR(50);
BEGIN
  
    IF p_marks BETWEEN 990 AND 1500 THEN
        v_class := 'Distinction';
    ELSIF p_marks BETWEEN 900 AND 989 THEN
        v_class := 'First Class';
    ELSIF p_marks BETWEEN 825 AND 899 THEN
        v_class := 'Higher Second Class';
    ELSE
        v_class := 'Pass';
    END IF;

    INSERT INTO Result(Roll, Name, Class)
    VALUES (p_roll, p_name, v_class);

    RAISE NOTICE 'Student % with Roll % is categorized as %', p_name, p_roll, v_class;
END;
$$;


INSERT INTO Stud_Marks(Name, Total_Marks) VALUES
('Alice', 1200),
('Bob', 950),
('Charlie', 870),
('David', 800);


DO $$
DECLARE
    rec RECORD;
BEGIN
    
    FOR rec IN SELECT * FROM Stud_Marks LOOP
        CALL proc_Grade(rec.Roll, rec.Name, rec.Total_Marks);
    END LOOP;
END;
$$;	


SELECT * FROM Result;
