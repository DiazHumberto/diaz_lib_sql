SHOW DATABASES;
CREATE DATABASE diaz_lib;
USE diaz_lib;

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
('Unemploymet Canadas problem', 'P. Gilman', 3),
('To Kill a Mockingbird', 'Harper Lee', 5),
('1984', 'George Orwell', 2),
('Moby Dick', 'Herman Melville', 4),
('Pride and Prejudice', 'Jane Austen', 3),
('The Hobbit', 'J.R.R. Tolkien', 6),
('War and Peace', 'Leo Tolstoy', 1),
('Crime and Punishment', 'Fyodor Dostoevsky', 2),
('The Great Gatsby', 'F. Scott Fitzgerald', 4),
('Brave New World', 'Aldous Huxley', 3);

-- Insert members
INSERT INTO members (member_name, member_email, member_phone, join_date) VALUES
('Alice Johnson', 'alice@example.com', '1234567890', '2023-01-10'),
('Bob Smith', 'bob@example.com', '1234567891', '2023-02-15'),
('Charlie Brown', 'charlie@example.com', '1234567892', '2023-03-20'),
('David White', 'david@example.com', '1234567893', '2023-04-25'),
('Emma Black', 'emma@example.com', '1234567894', '2023-05-30'),
('Frank Green', 'frank@example.com', '1234567895', '2023-06-15'),
('Grace Adams', 'grace@example.com', '1234567896', '2023-07-10'),
('Hannah Wright', 'hannah@example.com', '1234567897', '2023-08-05'),
('Ian King', 'ian@example.com', '1234567898', '2023-09-20'),
('Julia Scott', 'julia@example.com', '1234567899', '2023-10-10');
