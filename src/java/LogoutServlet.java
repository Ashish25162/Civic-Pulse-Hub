import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Show confirmation page before logging out
        if (session != null) {
            request.setAttribute("fullName", session.getAttribute("full_name"));
            request.setAttribute("operatorId", session.getAttribute("operator_id"));
            request.getRequestDispatcher("logout.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Perform actual logout
        performLogout(request, response);
    }
    
    private void performLogout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            try {
                // Store session info for logging before invalidating
                String fullName = (String) session.getAttribute("full_name");
                Integer operatorId = (Integer) session.getAttribute("operator_id");
                
                // Log the logout (you can add database logging here)
                System.out.println("Operator " + fullName + " (ID: " + operatorId + ") logged out at " + 
                                  new java.util.Date());
                
                // Invalidate the session - removes all session attributes
                session.invalidate();
                
                // Clear client-side cookies
                Cookie[] cookies = request.getCookies();
                if (cookies != null) {
                    for (Cookie cookie : cookies) {
                        cookie.setMaxAge(0);
                        cookie.setValue(null);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                    }
                }
                
                // Redirect to login page with success message
                request.setAttribute("logoutMessage", "You have been successfully logged out.");
                request.getRequestDispatcher("gov-login.html").forward(request, response);
                
            } catch (Exception e) {
                e.printStackTrace();
                // If something goes wrong, still redirect to login
                response.sendRedirect("login.jsp");
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}