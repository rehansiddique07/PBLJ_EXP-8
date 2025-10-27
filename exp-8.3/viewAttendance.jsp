<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util., java.sql." %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Attendance Records</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 1200px;
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
        .attendance-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .attendance-table th,
        .attendance-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .attendance-table th {
            background-color: #007bff;
            color: white;
        }
        .attendance-table tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .present {
            color: green;
            font-weight: bold;
        }
        .absent {
            color: red;
            font-weight: bold;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 10px 5px;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
        }
        .btn-primary {
            background: #007bff;
            color: white;
        }
        .search-form {
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
        }
        input[type="text"],
        input[type="date"] {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 200px;
        }
        .stats {
            background: #e9ecef;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📊 Attendance Records</h1>
        
        <div style="text-align: center; margin-bottom: 20px;">
            <a href="attendance.jsp" class="btn btn-primary">Mark Attendance</a>
            <a href="viewAttendance.jsp" class="btn btn-primary">View All Records</a>
        </div>

        <div class="search-form">
            <h3>Search Attendance</h3>
            <form method="GET" action="AttendanceServlet">
                <input type="hidden" name="action" value="search">
                <div class="form-group">
                    <label>Search by Roll Number:</label>
                    <input type="text" name="searchRollNumber" placeholder="Enter roll number">
                    <button type="submit">Search</button>
                </div>
            </form>
        </div>

        <div class="stats">
            <h3>Attendance Summary</h3>
            <%
                // Simple statistics
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/student_attendance", "root", "password");
                    
                    // Total records
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT COUNT(*) as total FROM attendance");
                    if (rs.next()) {
                        out.println("<p><strong>Total Records: " + rs.getInt("total") + "</strong></p>");
                    }
                    
                    // Present count
                    rs = stmt.executeQuery("SELECT COUNT(*) as present FROM attendance WHERE status='Present'");
                    if (rs.next()) {
                        out.println("<p><strong>Total Present: " + rs.getInt("present") + "</strong></p>");
                    }
                    
                    // Absent count
                    rs = stmt.executeQuery("SELECT COUNT(*) as absent FROM attendance WHERE status='Absent'");
                    if (rs.next()) {
                        out.println("<p><strong>Total Absent: " + rs.getInt("absent") + "</strong></p>");
                    }
                    
                } catch (Exception e) {
                    out.println("<p>Error loading statistics: " + e.getMessage() + "</p>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) {}
                    try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
                    try { if (conn != null) conn.close(); } catch (SQLException e) {}
                }
            %>
        </div>

        <table class="attendance-table">
            <thead>
                <tr>
                    <th>Record ID</th>
                    <th>Roll Number</th>
                    <th>Student Name</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Class</th>
                </tr>
            </thead>
            <tbody>
            <%
                conn = null;
                stmt = null;
                rs = null;
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/student_attendance", "root", "password");
                    
                    String searchRollNumber = request.getParameter("searchRollNumber");
                    String sql;
                    
                    if (searchRollNumber != null && !searchRollNumber.trim().isEmpty()) {
                        sql = "SELECT a.*, s.roll_number, s.name, s.class " +
                              "FROM attendance a JOIN students s ON a.student_id = s.student_id " +
                              "WHERE s.roll_number = ? ORDER BY a.attendance_date DESC";
                        PreparedStatement pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, searchRollNumber.trim());
                        rs = pstmt.executeQuery();
                    } else {
                        sql = "SELECT a.*, s.roll_number, s.name, s.class " +
                              "FROM attendance a JOIN students s ON a.student_id = s.student_id " +
                              "ORDER BY a.attendance_date DESC, s.roll_number";
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery(sql);
                    }
                    
                    while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getInt("attendance_id") %></td>
                    <td><%= rs.getString("roll_number") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getDate("attendance_date") %></td>
                    <td class="<%= rs.getString("status").toLowerCase() %>">
                        <%= rs.getString("status") %>
                    </td>
                    <td><%= rs.getString("class") %></td>
                </tr>
            <%
                    }
                    
                } catch (Exception e) {
            %>
                <tr>
                    <td colspan="6" style="text-align: center; color: red;">
                        Error loading attendance records: <%= e.getMessage() %>
                    </td>
                </tr>
            <%
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) {}
                    try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
                    try { if (conn != null) conn.close(); } catch (SQLException e) {}
                }
            %>
            </tbody>
        </table>
    </div>
</body>
</html>
