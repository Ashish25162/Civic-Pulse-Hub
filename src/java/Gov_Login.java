/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
/**
 *
 * @author apple
 */
@WebServlet(urlPatterns = {"/Gov_Login"})
public class Gov_Login extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        boolean loginSuccess = false;
         String role = request.getParameter("role");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try{
            
       
        
        Connection cn = Database.getConnection();
       
        String table = "";
            switch (role) {
                case "admin":
                    table = "admin";
                    break;
                case "operator":
                    table = "operator";
                    break;
                
                default:
                    table = "";
            }
            
                String sql = "SELECT * FROM " + table + " WHERE email=? AND password=?";
                PreparedStatement ps = cn.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, password); 
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    loginSuccess = true;
                }
                 if (loginSuccess) {
                     
                     
                     
            // Save session info
              HttpSession gov_session = request.getSession(true);
              gov_session.setAttribute("full_name", rs.getString("full_name"));
              gov_session.setAttribute("email", rs.getString("email"));
              gov_session.setAttribute("phone", rs.getString("phone"));
              



            // Redirect to role
            switch (role) {
                case "admin":
                    gov_session = request.getSession(true);
                    gov_session.setAttribute("created_at", rs.getString("created_at"));
                    response.sendRedirect("admin-dashboard.jsp");
                    break;
                case "operator":
                                  gov_session = request.getSession(true);
                                  gov_session.setAttribute("operator_id", rs.getInt("operator_id"));
                    response.sendRedirect("operator-Dashboard.jsp");
                    break;
                case "worker":
                    response.sendRedirect("worker-Dashboard.jsp");
                    break;
            }
        } else {
            // Login failed
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("gov-login.html").forward(request, response);
        }
        }
        
        catch(Exception e) {
            out.println("<div style='color: red; text-align: center; margin: 20px;'>Error: " + e.getMessage() + "</div>");
            RequestDispatcher rd = request.getRequestDispatcher("gov_login.html");
            rd.include(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
