/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.sql.Connection;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.PreparedStatement;

/**
 *
 * @author apple
 */
@WebServlet(urlPatterns = {"/Assign_Operator"})
public class Assign_Operator extends HttpServlet {

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
        
                 HttpSession sess = request.getSession(false);
                 String report_id = (String) sess.getAttribute("report_id");
                 String operator_id = (String) sess.getAttribute("operator_id");
                 
                 try{
                     
                       Connection cn = Database.getConnection();
                       PreparedStatement ps=cn.prepareStatement("insert into report_assignments(report_id,operator_id) values(?,?)");
            ps.setString(1, report_id);
            ps.setString(2, operator_id);
            

            
            boolean b=ps.execute();
                    
                    if (b==false)
                    {
                       PreparedStatement pss=cn.prepareStatement("update reports set Status=? where report_id=?");
                        pss.setString(2,report_id);
                        pss.setString(1, "assigned");
                        int row=pss.executeUpdate();
                       if(row>0){
                            out.println("Assigned successfully");
                       }                        
                    }
            cn.close();

                     
                 }

            catch(Exception e) {
            out.println("<div style='color: red; text-align: center; margin: 20px;'>Error: " + e.getMessage() + "</div>");
            
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
