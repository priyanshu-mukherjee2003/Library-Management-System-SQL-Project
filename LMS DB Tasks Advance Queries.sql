SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;


/*
Task 13: 
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/
-- issued_status == members == books == return_status
-- filter books which is return
-- overdue > 30

SELECT issued_member_id, member_name, book_title, issued_date, DATEDIFF(DAY, ist.issued_date, GETDATE()) AS over_dues_days FROM issued_status AS ist
JOIN members AS m
ON m.member_id = ist.issued_member_id
JOIN books AS bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rst
ON rst.issued_id = ist.issued_id
WHERE (DATEDIFF(DAY, ist.issued_date, GETDATE())) > 30
ORDER BY issued_member_id;


/*    
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
*/

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-451-52994-2';

SELECT * FROM books
WHERE isbn = '978-0-451-52994-2';

INSERT INTO return_status (return_id, issued_id, return_date)
VALUES ('RS125', 'IS130', GETDATE());

SELECT * FROM return_status
WHERE issued_id = 'IS130';

UPDATE books
SET status = 'yes'
WHERE isbn = '978-0-451-52994-2';

-- Using Stored Procedures
CREATE PROCEDURE add_return_records
    @p_return_id NVARCHAR(50),
    @p_issued_id NVARCHAR(50)
AS
BEGIN
    -- Declare variables
    DECLARE @v_isbn NVARCHAR(50);
    DECLARE @v_book_name NVARCHAR(50);

    -- Insert into return_status
    INSERT INTO return_status (return_id, issued_id, return_date)
    VALUES (@p_return_id, @p_issued_id, GETDATE());

    -- Fetch book details
    SELECT 
        @v_isbn = issued_book_isbn,
        @v_book_name = issued_book_name
    FROM issued_status
    WHERE issued_id = @p_issued_id;

    -- Update book status
    UPDATE books
    SET status = 'yes'
    WHERE isbn = @v_isbn;

    -- Print message (equivalent to RAISE NOTICE)
    PRINT 'Thank you for returning the book: ' + @v_book_name;
END;

-- Executing the Stored Procedure
EXEC add_return_records 'RS148', 'IS140';


/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/

SELECT b.branch_id, b.manager_id, COUNT(ist.issued_id) AS number_of_book_issued, COUNT(rst.return_id) AS number_of_book_return, SUM(bk.rental_price) AS total_revenue
FROM issued_status AS ist
JOIN employees AS e
ON e.emp_id = ist.issued_emp_id
JOIN branch AS b
ON e.branch_id = b.branch_id
LEFT JOIN return_status AS rst
ON rst.issued_id = ist.issued_id
JOIN books AS bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY b.branch_id, b.manager_id;


-- Task 16: CTAS: Create a Table of Active Members
-- Use the INTO Function to create a new table active_members containing members who have issued at least one book in the last 2 months.

-- Creating and populating the table
SELECT * INTO active_members FROM members
WHERE member_id IN (SELECT DISTINCT issued_member_id FROM issued_status WHERE issued_date >= DATEADD(MONTH, -2, GETDATE()));

-- View the result:
SELECT * FROM active_members;


/* Task 17: Find Employees with the Most Book Issues Processed.
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch. */

SELECT e.emp_name, b.branch_address, COUNT(ist.issued_id) as no_book_issued FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY e.emp_name, b.branch_address;
