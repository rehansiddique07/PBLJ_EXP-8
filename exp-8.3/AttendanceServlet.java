import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/AttendanceServlet")
public class AttendanceServlet extends HttpServlet {
    
    // Database configuration
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/student_attendance";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "password"; // Change to your MySQL password
    
    @Override
    public void init() throws ServletException {
        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("MySQL JDBC Driver not found", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String rollNumber = request.getParameter("rollNumber");
        String attendanceDate = request.getParameter("attendanceDate");
        String status = request.getParameter("status");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            
            // First, check if student exists
            String checkStudentSQL = "SELECT student_id FROM students WHERE roll_number = ?";
            pstmt = conn.prepareStatement(checkStudentSQL);
            pstmt.setString(1, rollNumber);
            rs = pstmt.executeQuery();
            
            if (!rs.next()) {
                // Student not found
                request.setAttribute("message", "Error: Student with roll number '" + rollNumber + "' not found!");
                request.setAttribute("messageType", "error");
                RequestDispatcher dispatcher = request.getRequestDispatcher("attendance.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            int studentId = rs.getInt("student_id");
            
            // Check if attendance already exists for this student on this date
            String checkAttendanceSQL = "SELECT attendance_id FROM attendance WHERE student_id = ? AND attendance_date = ?";
            pstmt = conn.prepareStatement(checkAttendanceSQL);
            pstmt.setInt(1, studentId);
            pstmt.setDate(2, Date.valueOf(attendanceDate));
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Update existing attendance
                String updateSQL = "UPDATE attendance SET status = ? WHERE student_id = ? AND attendance_date = ?";
                pstmt = conn.prepareStatement(updateSQL);
                pstmt.setString(1, status);
                pstmt.setInt(2, studentId);
                pstmt.setDate(3, Date.valueOf(attendanceDate));
                pstmt.executeUpdate();
                
                request.setAttribute("message", "Attendance updated successfully for roll number: " + rollNumber);
                request.setAttribute("messageType", "success");
            } else {
                // Insert new attendance record
                String insertSQL = "INSERT INTO attendance (student_id, attendance_date, status) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(insertSQL);
                pstmt.setInt(1, studentId);
                pstmt.setDate(2, Date.valueOf(attendanceDate));
                pstmt.setString(3, status);
                pstmt.executeUpdate();
                
                request.setAttribute("message", "Attendance marked successfully for roll number: " + rollNumber);
                request.setAttribute("messageType", "success");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Database error: " + e.getMessage());
            request.setAttribute("messageType", "error");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "System error: " + e.getMessage());
            request.setAttribute("messageType", "error");
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        // Forward back to the JSP page
        RequestDispatcher dispatcher = request.getRequestDispatcher("attendance.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("search".equals(action)) {
            // Handle search request - forward to viewAttendance.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("viewAttendance.jsp");
            dispatcher.forward(request, response);
        } else {
            // Default behavior - redirect to attendance form
            response.sendRedirect("attendance.jsp");
        }
    }
    
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
    }
    
    private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
