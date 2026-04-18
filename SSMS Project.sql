CREATE DATABASE library_db;

GO

USE library_db;

GO

CREATE TABLE Books(
book_id INT PRIMARY KEY IDENTITY(1,1),
title VARCHAR(100) NOT NULL,
author VARCHAR(100),
publisher VARCHAR(100),
year_published INT,
total_copies INT NOT NULL,
available_copies INT NOT NULL
);

CREATE TABLE Members(
member_id INT PRIMARY KEY IDENTITY(1,1),
name VARCHAR(100) NOT NULL,
phone VARCHAR(15),
email VARCHAR(100),
join_id DATE DEFAULT CAST(GETDATE() AS DATE)
);

CREATE TABLE Transactions(
transaction_id INT PRIMARY KEY IDENTITY(1,1),
book_id INT,
member_id INT,
issue_date DATETIME DEFAULT GETDATE(),
due_date DATE,
return_date DATE,
FOREIGN KEY (book_id) REFERENCES Books(book_id),
FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

INSERT INTO Books (title,author,publisher,year_published,total_copies,available_copies)

VALUES

('The Alchemist', 'Paulo Coelho', 'HarperCollins', 1988,5,5),
('C Programming', 'Dennis Ritchie', 'Prentice Hall', 1978,3,3),
('MySQL Basics', 'Paul DuBois', 'Sams Publishing', 2003,4,4);

INSERT INTO Members (name,phone,email)

VALUES
('Amit Sharma', '9876543210', 'amit@example.com'),
('Sneha Patel', '9123456780', 'sneha@example.com');

SELECT available_copies FROM Books WHERE book_id = 1;

SELECT * from Books;

INSERT INTO Transactions (book_id,member_id,issue_date,due_date)
VALUES (1,1,GETDATE(),DATEADD(DAY,14,GETDATE()));

UPDATE Books
SET available_copies = available_copies -1
WHERE book_id = 1;


UPDATE Transactions
SET return_date = CAST(GETDATE() AS DATE)
WHERE transaction_id =1;

UPDATE Books
SET available_copies=available_copies+1
WHERE book_id = 1;

SELECT t.transaction_id, m.name, b.title, t.due_date
FROM Transactions t
JOIN Members m ON t.member_id = m.member_id
JOIN Books b ON t.book_id = b.book_id
WHERE t.return_date IS NULL
AND t.due_date < CAST(GETDATE() AS DATE);

SELECT title, available_copies
FROM Books
WHERE title = 'The Alchemist';

SELECT title,available_copies FROM Books; -- Error

Select name,join_ID
FROM Members
WHERE join_ID >'2024-01-01'; -- Error

SELECT transaction_id,book_id,member_id,issue_date,due_date
FROM Transactions
WHERE return_date IS NULL;

INSERT INTO Books(title,author,total_copies,available_copies)
VALUES
('C++ Programming','Bjame Stroustrup',5,3),
('Data Structures in Java','Mark Allen',4,0),
('Database Systems','Elmasri & Navathe',6,2),
('Operating System Concepts','Silberschatz',3,1);

SELECT title
FROM Books
WHERE available_copies = 0;

SELECT m.name
FROM Members m
JOIN Transactions t ON m.member_id = t.member_id
JOIN Books b ON t.book_id=b.book_id
WHERE b.title = 'The Alchemist'; -- Error

SELECT b.title,t.issue_date
FROM Books b
JOIN Transactions t ON b.book_id = t.book_id
WHERE MONTH(t.issue_date)=YEAR(GETDATE());

INSERT INTO Transactions(book_id,member_id,issue_date,due_date,return_date)
VALUES (1,2,DATEADD(DAY,-20,GETDATE()),DATEADD(DAY,-10,GETDATE()),NULL);

SELECT b.title,m.name,t.due_date
FROM Transactions t
JOIN Books b ON t.book_id = b.book_id
JOIN Members m ON t.member_id = m.member_id
WHERE t.return_date IS NULL
AND t.due_date < CAST(GETDATE() AS DATE);

SELECT TOP 1 b.title,COUNT(t.transaction_id) AS times_borrowed
FROM Books b
JOIN Transactions t ON b.book_id = t.book_id
GROUP BY b.title
ORDER BY times_borrowed DESC;

INSERT INTO Transactions(book_id,member_id,due_date)VALUES
(1,1,DATEADD(DAY,14,GETDATE())),
(2,1,DATEADD(DAY,14,GETDATE())),
(3,1,DATEADD(DAY,14,GETDATE()));

SELECT m.name, COUNT(t.transactions_id)AS borrowed_count
FROM Members m
JOIN Transactions t ON m.member_id= t.member_id
GROUP BY m.member_id,m.name
HAVING COUNT(t.transaction_id)>2; -- Error