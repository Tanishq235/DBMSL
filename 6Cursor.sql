CREATE DATABASE exp6;
\c exp6


DROP TABLE IF EXISTS new_roll;
DROP TABLE IF EXISTS old_roll;


CREATE TABLE new_roll (
    roll INT PRIMARY KEY,
    name VARCHAR(10)
);

CREATE TABLE old_roll (
    roll INT PRIMARY KEY,
    name VARCHAR(10)
);

INSERT INTO new_roll VALUES (2, 'AJAY'), (5, 'MAYA'), (1, 'MONA');
INSERT INTO old_roll VALUES (4, 'SHRAVANI'), (3, 'SONA'), (1, 'MONA'), (5, 'MAYA');

SELECT * FROM new_roll ORDER BY roll;
SELECT * FROM old_roll ORDER BY roll;


CREATE OR REPLACE PROCEDURE roll1_list()
LANGUAGE plpgsql
AS $$
DECLARE
    v_roll INT;
    v_name VARCHAR(10);
    v_exists INT;
    cur_old CURSOR FOR SELECT roll, name FROM old_roll;
BEGIN
    OPEN cur_old;
    LOOP
        FETCH cur_old INTO v_roll, v_name;
        EXIT WHEN NOT FOUND;

        
        SELECT COUNT(*) INTO v_exists FROM new_roll WHERE roll = v_roll;

        IF v_exists = 0 THEN
            INSERT INTO new_roll (roll, name) VALUES (v_roll, v_name);
        END IF;
    END LOOP;

    CLOSE cur_old;
    RAISE NOTICE 'Data merged successfully!';
END;
$$;


CALL roll1_list();

SELECT * FROM new_roll ORDER BY roll;
