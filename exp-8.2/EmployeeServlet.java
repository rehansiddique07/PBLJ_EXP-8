import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class EmployeeServlet extends HttpServlet {
    
    // Database configuration
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/employee_db";
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String empId = request.getParameter("empId");
        
        try {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Employee Results</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f4; }");
            out.println(".container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
            out.println(".employee-table { width: 100%; border-collapse: collapse; margin-top: 20px; }");
            out.println(".employee-table th, .employee-table td { border: 1px solid #ddd; padding: 12px; text-align: left; }");
            out.println(".employee-table th { background-color: #007bff; color: white; }");
            out.println(".employee-table tr:nth-child(even) { background-color: #f2f2f2; }");
            out.println(".message { padding: 10px; margin: 10px 0; border-radius: 4px; }");
            out.println(".success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }");
            out.println(".error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }");
            out.println(".btn { display: inline-block; padding: 8px 16px; margin-right: 10px; text-decoration: none; border-radius: 4px; background: #007bff; color: white; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<div class='container'>");
            out.println("<h1>Employee Records</h1>");
            out.println("<a href='employee.html' class='btn'>Back to Search</a>");
            out.println("<br><br>");
            
            if (empId != null && !empId.trim().isEmpty()) {
                // Search for specific employee
                searchEmployeeById(out, empId.trim());
            } else {
                // Display all employees
                displayAllEmployees(out);
            }
            
            out.println("</div>");
            out.println("</body>");
            out.println("</html>");
            
        } catch (Exception e) {
            out.println("<div class='message error'>");
            out.println("<h3>Database Error</h3>");
            out.println("<p>" + e.getMessage() + "</p>");
            out.println("</div>");
        } finally {
            out.close();
        }
    }
    
    private void searchEmployeeById(PrintWriter out, String empId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            String sql = "SELECT * FROM employees WHERE emp_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(empId));
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                out.println("<h3>Employee Details</h3>");
                out.println("<table class='employee-table'>");
                out.println("<tr><th>ID</th><th>Name</th><th>Email</th><th>Department</th><th>Salary</th><th>Hire Date</th></tr>");
                
                out.println("<tr>");
                out.println("<td>" + rs.getInt("emp_id") + "</td>");
                out.println("<td>" + rs.getString("name") + "</td>");
                out.println("<td>" + rs.getString("email") + "</td>");
                out.println("<td>" + rs.getString("department") + "</td>");
                out.println("<td>$" + String.format("%,.2f", rs.getDouble("salary")) + "</td>");
                out.println("<td>" + rs.getDate("hire_date") + "</td>");
                out.println("</tr>");
                
                out.println("</table>");
            } else {
                out.println("<div class='message error'>");
                out.println("<h3>Employee Not Found</h3>");
                out.println("<p>No employee found with ID: " + empId + "</p>");
                out.println("</div>");
            }
            
        } catch (NumberFormatException e) {
            out.println("<div class='message error'>");
            out.println("<h3>Invalid Input</h3>");
            out.println("<p>Please enter a valid numeric Employee ID</p>");
            out.println("</div>");
        } catch (SQLException e) {
            out.println("<div class='message error'>");
            out.println("<h3>Database Error</h3>");
            out.println("<p>" + e.getMessage() + "</p>");
            out.println("</div>");
        } finally {
            closeResources(conn, pstmt, rs);
        }
    }
    
    private void displayAllEmployees(PrintWriter out) {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM employees ORDER BY emp_id";
            rs = stmt.executeQuery(sql);
            
            out.println("<h3>All Employees</h3>");
            out.println("<table class='employee-table'>");
            out.println("<tr><th>ID</th><th>Name</th><th>Email</th><th>Department</th><th>Salary</th><th>Hire Date</th></tr>");
            
            int count = 0;
            while (rs.next()) {
                count++;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("emp_id") + "</td>");
                out.println("<td>" + rs.getString("name") + "</td>");
                out.println("<td>" + rs.getString("email") + "</td>");
                out.println("<td>" + rs.getString("department") + "</td>");
                out.println("<td>$" + String.format("%,.2f", rs.getDouble("salary")) + "</td>");
                out.println("<td>" + rs.getDate("hire_date") + "</td>");
                out.println("</tr>");
            }
            
            out.println("</table>");
            out.println("<p><strong>Total Employees: " + count + "</strong></p>");
            
        } catch (SQLException e) {
            out.println("<div class='message error'>");
            out.println("<h3>Database Error</h3>");
            out.println("<p>" + e.getMessage() + "</p>");
            out.println("</div>");
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
    }
    
    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
