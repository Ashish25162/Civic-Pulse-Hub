import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(urlPatterns = {"/User_Login"})
public class User_Login extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String email = request.getParameter("mail"); 
            String password = request.getParameter("password");
            
            

            // Load the driver
           //Class.forName("com.mysql.cj.jdbc.Driver");
           
            // Make the connection object
            Connection cn = Database.getConnection();
            
            // Query to get user details
            String query = "SELECT user_id, name, email, Mobile, address, registration_date FROM user WHERE email=? AND password=?";
            PreparedStatement ps = cn.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
                    
            if (rs.next()) {
                // Create session and store user data
                HttpSession session = request.getSession(true);
                
                // Store all user details in session
                session.setAttribute("user_id", rs.getInt("user_id"));
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("password", password);
                session.setAttribute("mobile", rs.getString("mobile"));
                session.setAttribute("address", rs.getString("address"));
                session.setAttribute("registration_date", rs.getString("registration_date"));
                
                // Redirect to JSP dashboard (not HTML)
                response.sendRedirect("User_Dashboard.jsp");
            } else {
                out.print("<div style='color: red; text-align: center; margin: 20px;'>Invalid email or password!</div>");
                RequestDispatcher rd = request.getRequestDispatcher("user_login.html");
                rd.include(request, response);
            }
            
            cn.close();
        } catch(Exception e) {
            out.println("<div style='color: red; text-align: center; margin: 20px;'>Error: " + e.getMessage() + "</div>");
            RequestDispatcher rd = request.getRequestDispatcher("user_login.html");
            rd.include(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}