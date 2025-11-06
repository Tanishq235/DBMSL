
CREATE DATABASE library_db;

\c library_db;


CREATE TABLE Borrower (
    Roll_no INTEGER PRIMARY KEY,
    Name VARCHAR(50),
    DateofIssue DATE,
    NameofBook VARCHAR(100),
    Status CHAR(1)  
);

CREATE TABLE Fine (
    Roll_no INTEGER,
    Date DATE,
    Amt NUMERIC
);

INSERT INTO Borrower VALUES (101, 'Dhiraj', '2025-10-01', 'Math Book', 'I');
INSERT INTO Borrower VALUES (102, 'Rahul', '2025-10-15', 'Science Book', 'I');
INSERT INTO Borrower VALUES (103, 'Neha', '2025-09-20', 'English Book', 'I');

COMMIT;


DO
$$
DECLARE
    v_rollno INTEGER := 101;         
    v_book VARCHAR(100) := 'Math Book'; 
    v_issue_date DATE;
    v_status CHAR(1);
    v_days INTEGER;
    v_fine NUMERIC := 0;
BEGIN
   
    SELECT DateofIssue, Status
    INTO v_issue_date, v_status
    FROM Borrower
    WHERE Roll_no = v_rollno AND NameofBook = v_book;

    
    IF v_status = 'R' THEN
        RAISE NOTICE 'Book is already returned!';
        RETURN;
    END IF;

    
    v_days := CURRENT_DATE - v_issue_date;

    IF v_days >= 15 AND v_days <= 30 THEN
        v_fine := v_days * 5;
    ELSIF v_days > 30 THEN
        v_fine := (30 * 5) + ((v_days - 30) * 50);
    ELSE
        v_fine := 0;
    END IF;

   
    UPDATE Borrower
    SET Status = 'R'
    WHERE Roll_no = v_rollno AND NameofBook = v_book;

   
    IF v_fine > 0 THEN
        INSERT INTO Fine(Roll_no, Date, Amt)
        VALUES(v_rollno, CURRENT_DATE, v_fine);
        RAISE NOTICE 'Fine of Rs % has been added.', v_fine;
    ELSE
        RAISE NOTICE 'No fine. Book returned successfully.';
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'Error: Book not found for this Roll No.';
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END
$$;
