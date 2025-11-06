CREATE DATABASE exp7;
\c exp7

DROP TABLE IF EXISTS library_audit;
DROP TABLE IF EXISTS library;

CREATE TABLE library (
book_id SERIAL PRIMARY KEY,
book_name VARCHAR(50),
status VARCHAR(20)
);

CREATE TABLE library_audit (
audit_id SERIAL PRIMARY KEY,
event_time TIMESTAMP,
book_name VARCHAR(50),
old_status VARCHAR(20),
new_status VARCHAR(20),
action VARCHAR(20),
trigger_type VARCHAR(30)
);

INSERT INTO library (book_name, status) VALUES
('DARK MATTER', 'AVAILABLE'),
('SILENT HILL', 'UNAVAILABLE'),
('GOD OF WAR', 'AVAILABLE'),
('SPIDER-MAN', 'UNAVAILABLE'),
('UNCHARTED', 'AVAILABLE');

CREATE OR REPLACE FUNCTION row_audit_func()
RETURNS TRIGGER AS $$
BEGIN
IF TG_OP = 'UPDATE' THEN
INSERT INTO library_audit (event_time, book_name, old_status, new_status, action, trigger_type)
VALUES (NOW(), OLD.book_name, OLD.status, NEW.status, 'UPDATE', 'ROW-LEVEL AFTER');
ELSIF TG_OP = 'DELETE' THEN
INSERT INTO library_audit (event_time, book_name, old_status, new_status, action, trigger_type)
VALUES (NOW(), OLD.book_name, OLD.status, NULL, 'DELETE', 'ROW-LEVEL AFTER');
END IF;

```
RETURN NULL;
```

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER row_level_audit
AFTER UPDATE OR DELETE ON library
FOR EACH ROW
EXECUTE FUNCTION row_audit_func();


CREATE OR REPLACE FUNCTION stmt_audit_func()
RETURNS TRIGGER AS $$
BEGIN
INSERT INTO library_audit (event_time, book_name, old_status, new_status, action, trigger_type)
VALUES (NOW(), NULL, NULL, NULL, TG_OP, 'STATEMENT-LEVEL BEFORE');
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER stmt_level_audit
BEFORE UPDATE OR DELETE ON library
FOR EACH STATEMENT
EXECUTE FUNCTION stmt_audit_func();


UPDATE library SET status = 'UNAVAILABLE' WHERE book_name = 'UNCHARTED';

DELETE FROM library WHERE book_name = 'SILENT HILL';

SELECT * FROM library;

SELECT * FROM library_audit ORDER BY audit_id;
