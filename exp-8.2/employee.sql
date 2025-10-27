-- Create database
CREATE DATABASE employee_db;
USE employee_db;

-- Create employee table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

-- Insert sample data
INSERT INTO employees (name, email, department, salary, hire_date) VALUES
('John Smith', 'john.smith@company.com', 'IT', 75000.00, '2020-03-15'),
('Sarah Johnson', 'sarah.johnson@company.com', 'HR', 65000.00, '2019-07-22'),
('Mike Wilson', 'mike.wilson@company.com', 'Finance', 82000.00, '2018-11-30'),
('Emily Brown', 'emily.brown@company.com', 'Marketing', 70000.00, '2021-01-10'),
('David Lee', 'david.lee@company.com', 'IT', 68000.00, '2022-05-05');
