DROP TABLE IF EXISTS N_RollCall CASCADE;
DROP TABLE IF EXISTS O_RollCall CASCADE;

CREATE TABLE N_RollCall (
  roll INTEGER PRIMARY KEY,
  name VARCHAR(50)
);

CREATE TABLE O_RollCall (
  roll INTEGER PRIMARY KEY,
  name VARCHAR(50)
);

INSERT INTO N_RollCall VALUES (2, 'AJAY');
INSERT INTO N_RollCall VALUES (5, 'MAYA');
INSERT INTO N_RollCall VALUES (1, 'MONA');

INSERT INTO O_RollCall VALUES (4, 'SHRAVANI');
INSERT INTO O_RollCall VALUES (3, 'SONA');
INSERT INTO O_RollCall VALUES (1, 'MONA');
INSERT INTO O_RollCall VALUES (5, 'MAYA');

DO $$
DECLARE
  cur refcursor;
  v_roll INTEGER;
  v_name VARCHAR(50);
  v_exists INTEGER;
  r RECORD;
BEGIN
  FOR r IN SELECT roll FROM O_RollCall LOOP
    OPEN cur FOR SELECT roll, name FROM O_RollCall WHERE roll = r.roll;
    FETCH cur INTO v_roll, v_name;
    CLOSE cur;

    SELECT COUNT(*) INTO v_exists FROM N_RollCall WHERE roll = v_roll;
    IF v_exists = 0 THEN
      INSERT INTO N_RollCall (roll, name) VALUES (v_roll, v_name);
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM N_RollCall ORDER BY roll;
