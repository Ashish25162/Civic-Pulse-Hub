

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.security.MessageDigest;

@WebServlet("/ProfileServlet")
@MultipartConfig
public class ProfileServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("operator_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            int operatorId = (Integer) session.getAttribute("operator_id");
            
            // Get database connection using your Database class
            conn = Database.getConnection();
            
            // Fetch operator details
            String sql = "SELECT full_name, email, phone, department, DATE_FORMAT(created_at, '%Y-%m-%d %H:%i:%s') as created_at FROM operator WHERE operator_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, operatorId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                request.setAttribute("fullName", rs.getString("full_name"));
                request.setAttribute("email", rs.getString("email"));
                String phone = rs.getString("phone");
                request.setAttribute("phone", phone != null ? phone : "");
                request.setAttribute("department", rs.getString("department"));
                request.setAttribute("createdAt", rs.getString("created_at"));
                request.setAttribute("operatorId", operatorId);
            }
            
            // Check for success/error messages
            if (session.getAttribute("successMessage") != null) {
                request.setAttribute("successMessage", session.getAttribute("successMessage"));
                session.removeAttribute("successMessage");
            }
            
            if (session.getAttribute("errorMessage") != null) {
                request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
                session.removeAttribute("errorMessage");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading profile: " + e.getMessage());
        } finally {
            closeResources(rs, pstmt, conn);
        }
        
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("operator_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("updateProfile".equals(action)) {
            updateProfile(request, response);
        } else if ("changePassword".equals(action)) {
            changePassword(request, response);
        } else {
            response.sendRedirect("ProfileServlet");
        }
    }
    
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        HttpSession session = request.getSession();
        
        try {
            int operatorId = (Integer) session.getAttribute("operator_id");
            String fullName = request.getParameter("full_name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String department = request.getParameter("department");
            
            // Validate inputs
            if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                department == null || department.trim().isEmpty()) {
                session.setAttribute("errorMessage", "All required fields must be filled");
                response.sendRedirect("ProfileServlet");
                return;
            }
            
            conn = Database.getConnection();
            
            // Check if email already exists (excluding current user)
            String checkEmailSql = "SELECT COUNT(*) FROM operator WHERE email = ? AND operator_id != ?";
            pstmt = conn.prepareStatement(checkEmailSql);
            pstmt.setString(1, email);
            pstmt.setInt(2, operatorId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                session.setAttribute("errorMessage", "Email already exists. Please use a different email.");
                response.sendRedirect("ProfileServlet");
                return;
            }
            
            // Update profile
            String updateSql = "UPDATE operator SET full_name = ?, email = ?, phone = ?, department = ? WHERE operator_id = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, fullName);
            pstmt.setString(2, email);
            pstmt.setString(3, (phone == null || phone.trim().isEmpty()) ? null : phone.trim());
            pstmt.setString(4, department);
            pstmt.setInt(5, operatorId);
            
            int rowsUpdated = pstmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                // Update session attributes
                session.setAttribute("full_name", fullName);
                session.setAttribute("email", email);
                session.setAttribute("phone", phone);
                
                session.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update profile. Please try again.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error updating profile: " + e.getMessage());
        } finally {
            closeResources(null, pstmt, conn);
            response.sendRedirect("ProfileServlet");
        }
    }
    
    private void changePassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        HttpSession session = request.getSession();
        
        try {
            int operatorId = (Integer) session.getAttribute("operator_id");
            String currentPassword = request.getParameter("current_password");
            String newPassword = request.getParameter("new_password");
            String confirmPassword = request.getParameter("confirm_password");
            
            // Validate passwords
            if (currentPassword == null || currentPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
                session.setAttribute("errorMessage", "All password fields are required");
                response.sendRedirect("ProfileServlet");
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("errorMessage", "New passwords do not match");
                response.sendRedirect("ProfileServlet");
                return;
            }
            
            if (newPassword.length() < 8) {
                session.setAttribute("errorMessage", "New password must be at least 8 characters long");
                response.sendRedirect("ProfileServlet");
                return;
            }
            
            conn = Database.getConnection();
            
            // Get current password from database
            String getPasswordSql = "SELECT password FROM operator WHERE operator_id = ?";
            pstmt = conn.prepareStatement(getPasswordSql);
            pstmt.setInt(1, operatorId);
            ResultSet rs = pstmt.executeQuery();
            
            if (!rs.next()) {
                session.setAttribute("errorMessage", "Operator not found!");
                response.sendRedirect("ProfileServlet");
                return;
            }
            
            String storedPassword = rs.getString("password");
            
            // Verify current password (assuming plain text for now - you should use hashing)
            if (!storedPassword.equals(currentPassword)) {
                // If not plain text, try hashed comparison
                String currentPasswordHash = hashPassword(currentPassword);
                if (!storedPassword.equals(currentPasswordHash)) {
                    session.setAttribute("errorMessage", "Current password is incorrect!");
                    response.sendRedirect("ProfileServlet");
                    return;
                }
            }
            
            // Update password (hash it)
            String newPasswordHash = hashPassword(newPassword);
            String updateSql = "UPDATE operator SET password = ? WHERE operator_id = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, newPasswordHash);
            pstmt.setInt(2, operatorId);
            
            int rowsUpdated = pstmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                session.setAttribute("successMessage", "Password changed successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to change password. Please try again.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error changing password: " + e.getMessage());
        } finally {
            closeResources(null, pstmt, conn);
            response.sendRedirect("ProfileServlet");
        }
    }
    
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes("UTF-8"));
            
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
            
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    
    private void closeResources(ResultSet rs, PreparedStatement pstmt, Connection conn) {
        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
        try { if (conn != null) conn.close(); } catch (SQLException e) {}
    }
}