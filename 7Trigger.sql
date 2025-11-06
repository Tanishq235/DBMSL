
CREATE TABLE library (
  book_id   SERIAL PRIMARY KEY,
  book_name TEXT NOT NULL,
  status    TEXT
);

CREATE TABLE library_audit (
  audit_id   SERIAL PRIMARY KEY,
  book_id    INT,
  book_name  TEXT,
  action     TEXT,       
  old_status TEXT,
  new_status TEXT,
  changed_at TIMESTAMP DEFAULT now()
);

INSERT INTO library (book_name, status) VALUES
('DARK MATTER', 'AVAILABLE'),
('SILENT HILL', 'UNAVAILABLE'),
('GOD OF WAR', 'AVAILABLE'),
('SPIDER-MAN', 'UNAVAILABLE'),
('UNCHARTED', 'AVAILABLE');

CREATE OR REPLACE FUNCTION library_audit_trigger()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO library_audit(book_id, book_name, action, old_status, new_status, changed_at)
    VALUES (OLD.book_id, OLD.book_name, 'UPDATE', OLD.status, NEW.status, now());
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO library_audit(book_id, book_name, action, old_status, new_status, changed_at)
    VALUES (OLD.book_id, OLD.book_name, 'DELETE', OLD.status, NULL, now());
  END IF;
  RETURN NULL; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_library_audit
AFTER UPDATE OR DELETE ON library
FOR EACH ROW
EXECUTE FUNCTION library_audit_trigger();


UPDATE library SET status = 'UNAVAILABLE' WHERE book_name = 'UNCHARTED';
DELETE FROM library WHERE book_name = 'SILENT HILL';


SELECT * FROM library;
SELECT * FROM library_audit ORDER BY audit_id;
