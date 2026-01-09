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
import java.sql.Date;

@WebServlet(urlPatterns = {"/Add"})
public class Add extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
                String employeeType = request.getParameter("employeeType");
        PreparedStatement ps = null;
               Connection cn=null;

        
        try{
                         cn = Database.getConnection();

                    
                    if ("operator".equalsIgnoreCase(employeeType)) {
                // Handle operator insertion
                addOperator(cn, request, out);
            } else if ("worker".equalsIgnoreCase(employeeType)) {
                // Handle worker insertion
                addWorker(cn, request,response, out);
            } else {
                out.println("<h3>Error: Invalid employee type</h3>");
            }
            
        } catch (Exception e) {
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    private void addOperator(Connection conn, HttpServletRequest request, PrintWriter out) 
            throws Exception {
        
        // Get operator details from form
        String full_name = request.getParameter("name");
        String email = request.getParameter("email");
        String department = request.getParameter("department");
        String phone = request.getParameter("phone");
         String password="12345678";
        
        String sql = "INSERT INTO operator (full_name, email,phone,password,department) VALUES (?, ?, ?, ?,?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, full_name);
            pstmt.setString(2, email);
            pstmt.setString(5, department);
            pstmt.setString(3,phone);
            pstmt.setString(4,password);

            
            int rowsInserted = pstmt.executeUpdate();
            
            if (rowsInserted > 0) {
                out.println("<h3>Operator added successfully!</h3>");
                out.println("<p>Name: " + full_name + "</p>");
                out.println("<p>Email: " + email + "</p>");
                out.println("<p>Email: " + phone + "</p>");
                out.println("<p>Department: " + department + "</p>");
            } else {
                out.println("<h3>Failed to add operator</h3>");
            }
        }
    }
    
    private void addWorker(Connection conn, HttpServletRequest request,HttpServletResponse response, PrintWriter out) 
            throws Exception {
        
        // Get worker details from form
        String full_name = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String department = request.getParameter("department");
        String password="12345678";
        
        String sql = "INSERT INTO worker (full_name, email, phone,password,department) " +
                    "VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, full_name);
            pstmt.setString(2, email);
            pstmt.setString(4, password);
            pstmt.setString(3, phone);
            pstmt.setString(5, department);
            
           
            
            int rowsInserted = pstmt.executeUpdate();
            
            if (rowsInserted > 0) {
                out.println("<h3>Worker added successfully!</h3>");
                out.println("<p>Name: " + full_name + "</p>");
                out.println("<p>Email: " + email + "</p>");
                out.println("<p>Phone: " + phone + "</p>");
            } else {
                out.println("<h3>Failed to add worker</h3>");
            }
        
                    
        }

        catch(Exception e) {
            out.println("<div style='color: red; text-align: center; margin: 20px;'>Error: " + e.getMessage() + "</div>");
            RequestDispatcher rd = request.getRequestDispatcher("user_login.html");
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
    }
}
// </editor-fold>


