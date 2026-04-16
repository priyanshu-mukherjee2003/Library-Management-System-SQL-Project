-- TABLES of Library Management System DATABASE:-

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;



-- PROJECT TASKS:-

-- Task 1. Create a New Book Record "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'"
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

-- Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = '130 Main St'
WHERE member_id = 'C101'

-- Task 3: Delete a Record from the Issued Status Table.  Objective: Delete the record with issued_id = 'IS107' from the issued_status table.
DELETE FROM issued_status
WHERE issued_id = 'IS107';

-- Task 4: Retrieve All Books Issued by a Specific Employee.  Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book.  Objective: Use GROUP BY to find members who have issued more than one book.
SELECT issued_emp_id, COUNT(issued_id) AS total_book_issued FROM issued_status
GROUP BY issued_emp_id;

-- Task 6(CTAS): Create Summary Tables: Used CTAS to generate new tables based on query results, each book and total book_issued_cnt**
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
INTO book_issued_cnt
FROM issued_status AS ist
JOIN books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

SELECT * FROM book_issued_cnt

-- Task 7: Retrieve All Books in a Specific Category:
SELECT * FROM books
WHERE category = 'Classic';
    
-- Task 8: Find Total Rental Income by Category:
SELECT category, SUM(rental_price) AS total_rental FROM books
GROUP BY category;

-- Task 9: List Members Who Registered in the Last 180 Days:
SELECT * FROM members
WHERE reg_date >= DATEADD(DAY, -180, GETDATE());

INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C118', 'Sam', '145 Main St', '2026-06-01'),
('C119', 'John', '133 Main St', '2026-05-01');

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:
SELECT e1.*, b.manager_id, e2.emp_name as manager
FROM employees as e1
JOIN branch as b
ON b.branch_id = e1.branch_id
JOIN employees as e2
ON b.manager_id = e2.emp_id

-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold 7USD:
SELECT * INTO books_price_greater_than_seven FROM books
WHERE rental_price > 7

SELECT * FROM 
books_price_greater_than_seven

-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT DISTINCT ist.issued_book_name FROM issued_status as ist
LEFT JOIN return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL
