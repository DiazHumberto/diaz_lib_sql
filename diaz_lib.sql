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