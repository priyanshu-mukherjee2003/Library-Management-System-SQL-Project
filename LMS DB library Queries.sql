-- Creating DATABASE
CREATE DATABASE [LMS DB];

-- Creating TABLES:-
-- Create table "Branch"
CREATE TABLE branch
(
            branch_id NVARCHAR(50) PRIMARY KEY,
            manager_id VARCHAR(50),
            branch_address NVARCHAR(50),
            contact_no BIGINT
);


-- Create table "Employee"
CREATE TABLE employees
(
            emp_id VARCHAR(50) PRIMARY KEY,
            emp_name NVARCHAR(50),
            position NVARCHAR(50),
            salary FLOAT,
            branch_id NVARCHAR(50), -- FK
);


-- Create table "Members"
CREATE TABLE members
(
            member_id NVARCHAR(50) PRIMARY KEY,
            member_name NVARCHAR(50),
            member_address NVARCHAR(50),
            reg_date DATE
);



-- Create table "Books"
CREATE TABLE books
(
            isbn NVARCHAR(50) PRIMARY KEY,
            book_title NVARCHAR(100),
            category NVARCHAR(50),
            rental_price FLOAT,
            status NVARCHAR(50),
            author NVARCHAR(50),
            publisher NVARCHAR(50)
);



-- Create table "IssueStatus"
CREATE TABLE issued_status
(
            issued_id NVARCHAR(50) PRIMARY KEY,
            issued_member_id NVARCHAR(50), -- FK
            issued_book_name NVARCHAR(100),
            issued_date DATE,
            issued_book_isbn NVARCHAR(50), -- FK
            issued_emp_id NVARCHAR(50) -- FK
);



-- Create table "ReturnStatus"
CREATE TABLE return_status
(
            return_id NVARCHAR(50) PRIMARY KEY,
            issued_id NVARCHAR(50),
            return_book_name NVARCHAR(50),
            return_date DATE,
            return_book_isbn NVARCHAR(50),
);


-- FOREIGN KEY
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);
