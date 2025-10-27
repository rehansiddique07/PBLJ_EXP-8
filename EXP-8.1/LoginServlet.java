import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class LoginServlet extends HttpServlet {
    
    // For ByteXL, try using jakarta packages instead of javax
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        // Get form data
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Login Result</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 50px; }");
        out.println(".success { color: green; }");
        out.println(".error { color: red; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        // Validate credentials (hardcoded for demo)
        if ("admin".equals(username) && "admin123".equals(password)) {
            // Success
            out.println("<h2 class='success'>Welcome, " + username + "!</h2>");
            out.println("<p>Login successful.</p>");
        } else {
            // Failure
            out.println("<h2 class='error'>Login Failed!</h2>");
            out.println("<p>Invalid username or password.</p>");
            out.println("<a href='login.html'>Try Again</a>");
        }
        
        out.println("</body>");
        out.println("</html>");
        out.close();
    }
    
    // Optional: Handle GET requests by redirecting to login form
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("login.html");
    }
}
