<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Attendance Portal</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .attendance-form {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"],
        input[type="date"],
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            box-sizing: border-box;
        }
        input[type="text"]:focus,
        input[type="date"]:focus,
        select:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0,123,255,0.3);
        }
        button {
            background: #007bff;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button:hover {
            background: #0056b3;
        }
        .message {
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
            text-align: center;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .navigation {
            text-align: center;
            margin: 20px 0;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 0 10px;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
        }
        .btn-primary {
            background: #007bff;
            color: white;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .student-list {
            margin-top: 30px;
        }
        .student-item {
            background: #f8f9fa;
            padding: 10px;
            margin: 5px 0;
            border-radius: 4px;
            border-left: 4px solid #007bff;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📚 Student Attendance Portal</h1>
        
        <div class="navigation">
            <a href="attendance.jsp" class="btn btn-primary">Mark Attendance</a>
            <a href="viewAttendance.jsp" class="btn btn-secondary">View Attendance</a>
        </div>

        <div class="attendance-form">
            <h2>Mark Student Attendance</h2>
            
            <!-- Display messages -->
            <%
                String message = (String) request.getAttribute("message");
                String type = (String) request.getAttribute("messageType");
                if (message != null) {
            %>
                <div class="message <%= type %>">
                    <%= message %>
                </div>
            <%
                }
            %>

            <form action="AttendanceServlet" method="POST">
                <div class="form-group">
                    <label for="rollNumber">Student Roll Number:</label>
                    <input type="text" id="rollNumber" name="rollNumber" 
                           placeholder="Enter student roll number (e.g., STU001)" required>
                </div>
                
                <div class="form-group">
                    <label for="attendanceDate">Attendance Date:</label>
                    <%
                        // Set default date to today
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        String today = sdf.format(new Date());
                    %>
                    <input type="date" id="attendanceDate" name="attendanceDate" 
                           value="<%= today %>" required>
                </div>
                
                <div class="form-group">
                    <label for="status">Attendance Status:</label>
                    <select id="status" name="status" required>
                        <option value="">Select Status</option>
                        <option value="Present">Present</option>
                        <option value="Absent">Absent</option>
                    </select>
                </div>
                
                <button type="submit">Submit Attendance</button>
            </form>
        </div>

        <div class="student-list">
            <h3>Available Students</h3>
            <div class="student-item">
                <strong>STU001</strong> - Alice Johnson (Class 10A)
            </div>
            <div class="student-item">
                <strong>STU002</strong> - Bob Smith (Class 10A)
            </div>
            <div class="student-item">
                <strong>STU003</strong> - Carol Davis (Class 10B)
            </div>
            <div class="student-item">
                <strong>STU004</strong> - David Wilson (Class 10B)
            </div>
            <div class="student-item">
                <strong>STU005</strong> - Eva Brown (Class 10A)
            </div>
        </div>
    </div>
</body>
</html>
