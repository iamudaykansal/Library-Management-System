
-- Create Database
CREATE DATABASE IF NOT EXISTS LibraryManagementSystem;
USE LibraryManagementSystem;

-- =====================================================
-- TABLE CREATION
-- =====================================================

-- 1. Authors Table
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    AuthorName VARCHAR(255) NOT NULL,
    AuthorEmail VARCHAR(255),
    AuthorPhone VARCHAR(20),
    AuthorAddress TEXT,
    BirthDate DATE,
    Nationality VARCHAR(100),
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categories Table
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Publishers Table
CREATE TABLE Publishers (
    PublisherID INT AUTO_INCREMENT PRIMARY KEY,
    PublisherName VARCHAR(255) NOT NULL,
    PublisherAddress TEXT,
    PublisherPhone VARCHAR(20),
    PublisherEmail VARCHAR(255),
    Website VARCHAR(255),
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Books Table
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    ISBN VARCHAR(20) UNIQUE NOT NULL,
    Title VARCHAR(500) NOT NULL,
    AuthorID INT,
    CategoryID INT,
    PublisherID INT,
    PublicationYear YEAR,
    Language VARCHAR(50) DEFAULT 'English',
    Pages INT,
    Price DECIMAL(10,2),
    TotalCopies INT DEFAULT 1,
    AvailableCopies INT DEFAULT 1,
    ShelfLocation VARCHAR(50),
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID)
);

-- 5. Members Table
CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    MembershipNumber VARCHAR(20) UNIQUE NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    Phone VARCHAR(20),
    Address TEXT,
    DateOfBirth DATE,
    Gender ENUM('Male', 'Female', 'Other'),
    MembershipType ENUM('Student', 'Faculty', 'Public') DEFAULT 'Public',
    JoinDate DATE DEFAULT (CURRENT_DATE),
    ExpiryDate DATE,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Librarians Table
CREATE TABLE Librarians (
    LibrarianID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeNumber VARCHAR(20) UNIQUE NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Address TEXT,
    HireDate DATE DEFAULT (CURRENT_DATE),
    Position VARCHAR(100),
    Salary DECIMAL(10,2),
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Book Issues Table
CREATE TABLE BookIssues (
    IssueID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    LibrarianID INT NOT NULL,
    IssueDate DATE DEFAULT (CURRENT_DATE),
    DueDate DATE NOT NULL,
    ReturnDate DATE NULL,
    Status ENUM('Issued', 'Returned', 'Overdue') DEFAULT 'Issued',
    FineAmount DECIMAL(8,2) DEFAULT 0.00,
    Notes TEXT,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (LibrarianID) REFERENCES Librarians(LibrarianID)
);

-- 8. Reservations Table
CREATE TABLE Reservations (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    ReservationDate DATE DEFAULT (CURRENT_DATE),
    Status ENUM('Active', 'Fulfilled', 'Cancelled') DEFAULT 'Active',
    ExpiryDate DATE,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- 9. Fines Table
CREATE TABLE Fines (
    FineID INT AUTO_INCREMENT PRIMARY KEY,
    IssueID INT NOT NULL,
    FineAmount DECIMAL(8,2) NOT NULL,
    FineDate DATE DEFAULT (CURRENT_DATE),
    PaymentDate DATE NULL,
    PaymentStatus ENUM('Unpaid', 'Paid') DEFAULT 'Unpaid',
    Notes TEXT,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (IssueID) REFERENCES BookIssues(IssueID)
);
 

CREATE INDEX idx_books_isbn ON Books(ISBN);
CREATE INDEX idx_books_title ON Books(Title);
CREATE INDEX idx_books_author ON Books(AuthorID);
CREATE INDEX idx_members_membership ON Members(MembershipNumber);
CREATE INDEX idx_issues_member ON BookIssues(MemberID);
CREATE INDEX idx_issues_book ON BookIssues(BookID);
CREATE INDEX idx_issues_status ON BookIssues(Status);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

-- Insert Authors
INSERT INTO Authors (AuthorName, AuthorEmail, Nationality) VALUES
('J.K. Rowling', 'jk.rowling@example.com', 'British'),
('George Orwell', 'g.orwell@example.com', 'British'),
('Harper Lee', 'harper.lee@example.com', 'American'),
('Agatha Christie', 'agatha.christie@example.com', 'British'),
('Stephen King', 'stephen.king@example.com', 'American');

-- Insert Categories
INSERT INTO Categories (CategoryName, Description) VALUES
('Fiction', 'Novels and fictional stories'),
('Science Fiction', 'Science fiction and fantasy books'),
('Mystery', 'Mystery and thriller books'),
('Biography', 'Biographical and autobiographical books'),
('Academic', 'Academic and educational books'),
('History', 'Historical books and documentation'),
('Technology', 'Technology and computer science books');

-- Insert Publishers
INSERT INTO Publishers (PublisherName, PublisherAddress) VALUES
('Penguin Random House', '1745 Broadway, New York, NY 10019'),
('HarperCollins', '195 Broadway, New York, NY 10007'),
('Simon & Schuster', '1230 Avenue of the Americas, New York, NY'),
('Macmillan Publishers', '120 Broadway, New York, NY 10271'),
('Oxford University Press', 'Great Clarendon Street, Oxford, UK');

-- Insert Books
INSERT INTO Books (ISBN, Title, AuthorID, CategoryID, PublisherID, PublicationYear, Price, TotalCopies, AvailableCopies) VALUES
('978-0439708180', 'Harry Potter and the Sorcerer''s Stone', 1, 2, 1, 1997, 12.99, 5, 3),
('978-0452284234', '1984', 2, 1, 2, 1949, 13.99, 3, 2),
('978-0060935467', 'To Kill a Mockingbird', 3, 1, 3, 1960, 14.99, 4, 4),
('978-0062073488', 'And Then There Were None', 4, 3, 2, 1939, 11.99, 2, 1),
('978-1501142970', 'The Institute', 5, 3, 4, 2019, 16.99, 3, 3);

-- Insert Members
INSERT INTO Members (MembershipNumber, FirstName, LastName, Email, Phone, MembershipType, ExpiryDate) VALUES
('LIB001', 'John', 'Doe', 'john.doe@email.com', '9876543210', 'Student', '2025-12-31'),
('LIB002', 'Jane', 'Smith', 'jane.smith@email.com', '9876543211', 'Faculty', '2026-06-30'),
('LIB003', 'Robert', 'Johnson', 'robert.j@email.com', '9876543212', 'Public', '2025-08-31'),
('LIB004', 'Emily', 'Davis', 'emily.davis@email.com', '9876543213', 'Student', '2025-12-31'),
('LIB005', 'Michael', 'Wilson', 'michael.w@email.com', '9876543214', 'Public', '2025-10-31');

-- Insert Librarians
INSERT INTO Librarians (EmployeeNumber, FirstName, LastName, Email, Position, Salary) VALUES
('EMP001', 'Alice', 'Brown', 'alice.brown@library.com', 'Head Librarian', 50000.00),
('EMP002', 'David', 'Clark', 'david.clark@library.com', 'Assistant Librarian', 35000.00),
('EMP003', 'Sarah', 'Miller', 'sarah.miller@library.com', 'Circulation Librarian', 40000.00);

-- Insert Sample Book Issues
INSERT INTO BookIssues (MemberID, BookID, LibrarianID, IssueDate, DueDate, Status) VALUES
(1, 1, 1, '2024-08-01', '2024-08-15', 'Returned'),
(2, 2, 2, '2024-08-05', '2024-08-19', 'Issued'),
(3, 3, 1, '2024-08-10', '2024-08-24', 'Issued'),
(1, 4, 3, '2024-08-12', '2024-08-26', 'Overdue'),
(4, 5, 2, '2024-08-14', '2024-08-28', 'Issued');

-- Update return date for returned book
UPDATE BookIssues SET ReturnDate = '2024-08-14' WHERE IssueID = 1;

-- Insert Sample Reservations
INSERT INTO Reservations (MemberID, BookID, ExpiryDate) VALUES
(5, 1, '2024-08-30'),
(2, 4, '2024-09-01');

-- Insert Sample Fines
INSERT INTO Fines (IssueID, FineAmount, Notes) VALUES
(4, 15.00, 'Book returned 3 days late');

-- Q1: Display all books with their authors and categories
SELECT 
    b.BookID,
    b.ISBN,
    b.Title,
    a.AuthorName,
    c.CategoryName,
    p.PublisherName,
    b.PublicationYear,
    b.Price,
    b.AvailableCopies
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID
JOIN Categories c ON b.CategoryID = c.CategoryID
JOIN Publishers p ON b.PublisherID = p.PublisherID
ORDER BY b.Title;

-- Q2: Show all available books (copies > 0)
SELECT 
    b.Title,
    a.AuthorName,
    b.AvailableCopies,
    c.CategoryName
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID
JOIN Categories c ON b.CategoryID = c.CategoryID
WHERE b.AvailableCopies > 0
ORDER BY b.Title;

-- Q3: List all active members
SELECT 
    MemberID,
    MembershipNumber,
    CONCAT(FirstName, ' ', LastName) AS FullName,
    Email,
    Phone,
    MembershipType,
    JoinDate,
    ExpiryDate
FROM Members
WHERE IsActive = TRUE
ORDER BY LastName, FirstName;

-- Q4: Display currently issued books
SELECT 
    bi.IssueID,
    CONCAT(m.FirstName, ' ', m.LastName) AS MemberName,
    b.Title,
    a.AuthorName,
    bi.IssueDate,
    bi.DueDate,
    DATEDIFF(CURDATE(), bi.DueDate) AS DaysOverdue
FROM BookIssues bi
JOIN Members m ON bi.MemberID = m.MemberID
JOIN Books b ON bi.BookID = b.BookID
JOIN Authors a ON b.AuthorID = a.AuthorID
WHERE bi.Status = 'Issued'
ORDER BY bi.DueDate;

-- =====================================================
-- ADVANCED QUERIES
-- =====================================================

-- Q5: Books issued by each member (with count)
SELECT 
    CONCAT(m.FirstName, ' ', m.LastName) AS MemberName,
    m.MembershipType,
    COUNT(bi.IssueID) AS TotalBooksIssued,
    COUNT(CASE WHEN bi.Status = 'Issued' THEN 1 END) AS CurrentlyIssued
FROM Members m
LEFT JOIN BookIssues bi ON m.MemberID = bi.MemberID
WHERE m.IsActive = TRUE
GROUP BY m.MemberID, m.FirstName, m.LastName, m.MembershipType
ORDER BY TotalBooksIssued DESC;

-- Q6: Most popular books (by issue count)
SELECT 
    b.Title,
    a.AuthorName,
    c.CategoryName,
    COUNT(bi.IssueID) AS TimesIssued
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID
JOIN Categories c ON b.CategoryID = c.CategoryID
LEFT JOIN BookIssues bi ON b.BookID = bi.BookID
GROUP BY b.BookID, b.Title, a.AuthorName, c.CategoryName
ORDER BY TimesIssued DESC
LIMIT 10;

-- Q7: Overdue books with fine calculation
SELECT 
    bi.IssueID,
    CONCAT(m.FirstName, ' ', m.LastName) AS MemberName,
    m.Phone,
    b.Title,
    bi.IssueDate,
    bi.DueDate,
    DATEDIFF(CURDATE(), bi.DueDate) AS DaysOverdue,
    CASE 
        WHEN DATEDIFF(CURDATE(), bi.DueDate) > 0 
        THEN DATEDIFF(CURDATE(), bi.DueDate) * 2.00 
        ELSE 0 
    END AS FineAmount
FROM BookIssues bi
JOIN Members m ON bi.MemberID = m.MemberID
JOIN Books b ON bi.BookID = b.BookID
WHERE bi.Status IN ('Issued', 'Overdue') 
  AND bi.DueDate < CURDATE()
ORDER BY DaysOverdue DESC;

-- Q8: Category-wise book distribution
SELECT 
    c.CategoryName,
    COUNT(b.BookID) AS TotalBooks,
    SUM(b.TotalCopies) AS TotalCopies,
    SUM(b.AvailableCopies) AS AvailableCopies,
    SUM(b.TotalCopies) - SUM(b.AvailableCopies) AS IssuedCopies
FROM Categories c
LEFT JOIN Books b ON c.CategoryID = b.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY TotalBooks DESC;

-- Q9: Member activity report
SELECT 
    CONCAT(m.FirstName, ' ', m.LastName) AS MemberName,
    m.MembershipType,
    COUNT(bi.IssueID) AS TotalIssues,
    MAX(bi.IssueDate) AS LastIssueDate,
    SUM(CASE WHEN bi.Status = 'Returned' THEN 1 ELSE 0 END) AS BooksReturned,
    SUM(CASE WHEN bi.Status = 'Issued' THEN 1 ELSE 0 END) AS CurrentlyHolding,
    COALESCE(SUM(f.FineAmount), 0) AS TotalFines
FROM Members m
LEFT JOIN BookIssues bi ON m.MemberID = bi.MemberID
LEFT JOIN Fines f ON bi.IssueID = f.IssueID
WHERE m.IsActive = TRUE
GROUP BY m.MemberID, m.FirstName, m.LastName, m.MembershipType
ORDER BY TotalIssues DESC;

-- Q10: Books never issued
SELECT 
    b.BookID,
    b.Title,
    a.AuthorName,
    c.CategoryName,
    b.PublicationYear,
    b.TotalCopies
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID
JOIN Categories c ON b.CategoryID = c.CategoryID
LEFT JOIN BookIssues bi ON b.BookID = bi.BookID
WHERE bi.BookID IS NULL
ORDER BY b.PublicationYear DESC;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Procedure to issue a book
DELIMITER //
CREATE PROCEDURE IssueBook(
    IN p_MemberID INT,
    IN p_BookID INT,
    IN p_LibrarianID INT,
    IN p_DueDays INT
)
BEGIN
    DECLARE v_AvailableCopies INT;
    DECLARE v_DueDate DATE;

    -- Check if book is available
    SELECT AvailableCopies INTO v_AvailableCopies
    FROM Books WHERE BookID = p_BookID;

    IF v_AvailableCopies > 0 THEN
        SET v_DueDate = DATE_ADD(CURDATE(), INTERVAL p_DueDays DAY);

        -- Insert issue record
        INSERT INTO BookIssues (MemberID, BookID, LibrarianID, DueDate)
        VALUES (p_MemberID, p_BookID, p_LibrarianID, v_DueDate);

        -- Update available copies
        UPDATE Books 
        SET AvailableCopies = AvailableCopies - 1
        WHERE BookID = p_BookID;

        SELECT 'Book issued successfully' AS Message;
    ELSE
        SELECT 'Book not available' AS Message;
    END IF;
END //
DELIMITER ;

-- Procedure to return a book
DELIMITER //
CREATE PROCEDURE ReturnBook(
    IN p_IssueID INT
)
BEGIN
    DECLARE v_BookID INT;
    DECLARE v_DueDate DATE;
    DECLARE v_FineAmount DECIMAL(8,2);

    -- Get book details
    SELECT BookID, DueDate INTO v_BookID, v_DueDate
    FROM BookIssues WHERE IssueID = p_IssueID;

    -- Calculate fine if overdue
    IF CURDATE() > v_DueDate THEN
        SET v_FineAmount = DATEDIFF(CURDATE(), v_DueDate) * 2.00;
    ELSE
        SET v_FineAmount = 0;
    END IF;

    -- Update issue record
    UPDATE BookIssues 
    SET ReturnDate = CURDATE(), 
        Status = 'Returned',
        FineAmount = v_FineAmount
    WHERE IssueID = p_IssueID;

    -- Update available copies
    UPDATE Books 
    SET AvailableCopies = AvailableCopies + 1
    WHERE BookID = v_BookID;

    -- Insert fine record if applicable
    IF v_FineAmount > 0 THEN
        INSERT INTO Fines (IssueID, FineAmount, Notes)
        VALUES (p_IssueID, v_FineAmount, 'Late return fine');
    END IF;

    SELECT CONCAT('Book returned. Fine: Rs. ', v_FineAmount) AS Message;
END //
DELIMITER ;

 
-- View for book catalog
CREATE VIEW BookCatalog AS
SELECT 
    b.BookID,
    b.ISBN,
    b.Title,
    a.AuthorName,
    c.CategoryName,
    p.PublisherName,
    b.PublicationYear,
    b.Language,
    b.Pages,
    b.Price,
    b.TotalCopies,
    b.AvailableCopies,
    CASE WHEN b.AvailableCopies > 0 THEN 'Available' ELSE 'Not Available' END AS Status
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID
JOIN Categories c ON b.CategoryID = c.CategoryID
JOIN Publishers p ON b.PublisherID = p.PublisherID;

-- View for current issues
CREATE VIEW CurrentIssues AS
SELECT 
    bi.IssueID,
    m.MembershipNumber,
    CONCAT(m.FirstName, ' ', m.LastName) AS MemberName,
    m.Phone,
    b.Title,
    a.AuthorName,
    bi.IssueDate,
    bi.DueDate,
    CASE 
        WHEN bi.DueDate < CURDATE() THEN 'Overdue'
        WHEN DATEDIFF(bi.DueDate, CURDATE()) <= 3 THEN 'Due Soon'
        ELSE 'On Time'
    END AS Status,
    CASE 
        WHEN bi.DueDate < CURDATE() 
        THEN DATEDIFF(CURDATE(), bi.DueDate) * 2.00 
        ELSE 0 
    END AS FineAmount
FROM BookIssues bi
JOIN Members m ON bi.MemberID = m.MemberID
JOIN Books b ON bi.BookID = b.BookID
JOIN Authors a ON b.AuthorID = a.AuthorID
WHERE bi.Status = 'Issued';

-- View for library statistics
CREATE VIEW LibraryStats AS
SELECT 
    (SELECT COUNT(*) FROM Books) AS TotalBooks,
    (SELECT SUM(TotalCopies) FROM Books) AS TotalCopies,
    (SELECT SUM(AvailableCopies) FROM Books) AS AvailableCopies,
    (SELECT COUNT(*) FROM Members WHERE IsActive = TRUE) AS ActiveMembers,
    (SELECT COUNT(*) FROM BookIssues WHERE Status = 'Issued') AS CurrentIssues,
    (SELECT COUNT(*) FROM BookIssues WHERE Status = 'Overdue') AS OverdueBooks,
    (SELECT COALESCE(SUM(FineAmount), 0) FROM Fines WHERE PaymentStatus = 'Unpaid') AS UnpaidFines;



-- Trigger to update book status when issued
DELIMITER //
CREATE TRIGGER after_book_issue
AFTER INSERT ON BookIssues
FOR EACH ROW
BEGIN
    UPDATE Books 
    SET AvailableCopies = AvailableCopies - 1
    WHERE BookID = NEW.BookID;
END //
DELIMITER ;

-- Trigger to update overdue status
DELIMITER //
CREATE TRIGGER update_overdue_status
BEFORE UPDATE ON BookIssues
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Issued' AND NEW.DueDate < CURDATE() THEN
        SET NEW.Status = 'Overdue';
    END IF;
END //
DELIMITER ;
