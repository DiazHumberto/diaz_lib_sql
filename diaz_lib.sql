SHOW DATABASES;
CREATE DATABASE diaz_lib;
USE diaz_lib;

CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    book_title VARCHAR(200) NOT NULL,
    book_author VARCHAR(200) NOT NULL,
    available_copies INT NOT NULL CHECK (available_copies >= 0)
);

CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    member_name VARCHAR(200) NOT NULL,
    member_email VARCHAR(200) UNIQUE NOT NULL,
    member_phone VARCHAR(20) UNIQUE NOT NULL,
    join_date DATE NOT NULL
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE DEFAULT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);

CREATE TABLE overdue_notification (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    notification_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    message TEXT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);

-- Insert books
INSERT INTO books (book_title, book_author, available_copies) VALUES
('Unemployment Canadas problem', 'P. Gilman', 3),
('The Origin of Species', 'Charles Darwin', 5),
('Permiso Jose Delgado, me la saco...', 'Jorge Naranjo Peñafiel', 2),
('JFK', 'Fredrik Logevall', 4),
('Homelessness and Drugs', 'Cara Pito', 3),
('MySQL, How to strive', 'Eleazar Mariduena', 6),
('Analysing Mein Kampf', 'Pirulo Avila', 1),
('El Amor de mi Vida', 'Daniela D. Indarte', 2),
('Amor en Tiempos de Ñengosos', 'El Brayan', 4),
('Arrecho Nunca Muere; y si Muere, Muere Arrecho', 'Jose Delgado', 3);

-- Insert members
INSERT INTO members (member_name, member_email, member_phone, join_date) VALUES
('Alicia Montesdeoca', 'alice@hotmail.com', '1536412065', '2023-02-10'),
('Bob Smith', 'bob@gmail.com', '120149891', '2023-02-19'),
('Carlos Izquierdo', 'charlie@hotmail.com', '1235467092', '2023-03-21'),
('David Zambrano', 'david@outlook.com', '18955103', '2023-04-29'),
('Emilia Bermudez', 'emma@gmail.com', '1699451200', '2023-05-18'),
('Franklin Guerra', 'frank@icloud.com', '1542320212', '2023-07-15'),
('Grace Gallardo', 'grace@yahoo.es', '1988954387', '2023-07-16'),
('John Lennon', 'john_beatles@montana.com', '1563265232', '2023-08-01'),
('Ivan Saquicela', 'ian@ups.edu.ec', '1457241575', '2023-10-20'),
('Julia Cañizares', 'chicha@gmail.com', '1212125862', '2023-11-10');
--
select * FROM BOOKS;
SELECT * FROM members;
SELECT * FROM loans;
select * from overdue_notification;

-- ------------------------CREATING TRIGGERS AND EVENT--------------------------
-- 1. TRIGGER FOR BOOK LOAN PROCESS---------------------------
DELIMITER //
CREATE TRIGGER before_loan_insert
BEFORE INSERT ON loans
FOR EACH ROW
BEGIN
    DECLARE available INT;

    -- Check if the book exists
    SELECT available_copies INTO available FROM books WHERE book_id = NEW.book_id;
    
    IF available IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Book does not exist in the database';
    END IF;

    -- Check if the book is available
    IF available <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The book is currently out of stock.';
    ELSE
        -- Reduce available copies
        UPDATE books SET available_copies = available_copies - 1 WHERE book_id = NEW.book_id;
    END IF;
END;
//
DELIMITER ;


-- 2. AFTER UPDATE Trigger for Book Returns-------------------------
DELIMITER //
CREATE TRIGGER after_book_return
AFTER UPDATE ON loans
FOR EACH ROW
BEGIN
    -- Only update stock when return_date is updated
    IF OLD.return_date IS NULL AND NEW.return_date IS NOT NULL THEN
        UPDATE books 
        SET available_copies = available_copies + 1 
        WHERE book_id = NEW.book_id;
    END IF;
END;
//
DELIMITER ;



-- 3. Scheduled Event for Overdue Notifications----------------------------
DELIMITER //
CREATE EVENT overdue_book_notification
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
    INSERT INTO overdue_notification (member_id, book_id, notification_date, message)
    SELECT l.member_id, l.book_id, NOW(), 'Your book is overdue. Please return it as soon as possible.'
    FROM loans l
    WHERE l.due_date < NOW() AND l.return_date IS NULL;
END;
//
DELIMITER ;


-- -----------------------------TESTING-------------------------------
-- Successful Loan
INSERT INTO loans (member_id, book_id, loan_date, due_date) VALUES 
(1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));

-- Attempt to loan a non-existing book
INSERT INTO loans (member_id, book_id, loan_date, due_date) VALUES 
(1, 999, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));

-- Attempt to loan an out-of-stock book (after multiple loans)
INSERT INTO loans (member_id, book_id, loan_date, due_date) VALUES 
(2, 7, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));





-- Returning a book
UPDATE loans SET return_date = CURDATE() WHERE loan_id = 1;






-- Manually insert an overdue loan
INSERT INTO loans (member_id, book_id, loan_date, due_date) VALUES 
(3, 2, '2024-01-01', '2024-01-10');

-- Wait 30 seconds and check notifications
SELECT * FROM overdue_notification;






