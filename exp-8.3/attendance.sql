-- Create database
CREATE DATABASE student_attendance;
USE student_attendance;

-- Create students table
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    roll_number VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    class VARCHAR(50)
);

-- Create attendance table
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    attendance_date DATE NOT NULL,
    status ENUM('Present', 'Absent') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Insert sample students
INSERT INTO students (roll_number, name, email, class) VALUES
('STU001', 'Alice Johnson', 'alice.johnson@school.com', 'Class 10A'),
('STU002', 'Bob Smith', 'bob.smith@school.com', 'Class 10A'),
('STU003', 'Carol Davis', 'carol.davis@school.com', 'Class 10B'),
('STU004', 'David Wilson', 'david.wilson@school.com', 'Class 10B'),
('STU005', 'Eva Brown', 'eva.brown@school.com', 'Class 10A');
