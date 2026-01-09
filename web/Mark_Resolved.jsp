<%-- 
    Document   : Mark_Resolved
    Created on : [Current Date]
    Author     : administration
--%>

<%@page import="java.sql.*" %>
<%@page import="jakarta.servlet.http.HttpSession" %>
<%@page import="java.net.URLEncoder" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Check if operator is logged in - CORRECTED SESSION VARIABLE NAME
    HttpSession operatorSession = request.getSession(false);
    if (operatorSession == null || operatorSession.getAttribute("email") == null) {
        response.sendRedirect("Operator_Login.html");
        return;
    }
    
    // Get operator data from session - CORRECTED SESSION VARIABLE NAMES
    String operatorName = (String) operatorSession.getAttribute("full_name");
    int operatorId = 0;
    
    if (operatorSession.getAttribute("operator_id") != null) {
        try {
            operatorId = Integer.parseInt(operatorSession.getAttribute("operator_id").toString());
        } catch (Exception e) {
            operatorId = 0;
        }
    }
    
    // Get form parameters
    String assignmentIdStr = request.getParameter("assignment_id");
    String reportIdStr = request.getParameter("report_id");
    String resolutionDetails = request.getParameter("resolution_details");
    String timeTaken = request.getParameter("time_taken");
    String additionalNotes = request.getParameter("additional_notes");
    
    int assignmentId = 0;
    int reportId = 0;
    
    if (assignmentIdStr != null && !assignmentIdStr.isEmpty()) {
        try {
            assignmentId = Integer.parseInt(assignmentIdStr);
        } catch (Exception e) {
            response.sendRedirect("Fetch_Task.jsp?error=Invalid assignment ID");
            return;
        }
    }
    
    if (reportIdStr != null && !reportIdStr.isEmpty()) {
        try {
            reportId = Integer.parseInt(reportIdStr);
        } catch (Exception e) {
            response.sendRedirect("Fetch_Task.jsp?error=Invalid report ID");
            return;
        }
    }
    
    if (assignmentId == 0 || reportId == 0) {
        response.sendRedirect("Fetch_Task.jsp?error=Missing required parameters");
        return;
    }
    
    if (resolutionDetails == null || resolutionDetails.trim().isEmpty()) {
        response.sendRedirect("Fetch_Task.jsp?error=Resolution details are required");
        return;
    }
    
    try {
        // Load the driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Make the connection object
        Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/civic_pulse_hub", "root", "Ashu@@3450");
        
        // Start transaction
        cn.setAutoCommit(false);
        
        try {
            // 1. Update report_assignments table
            PreparedStatement ps1 = cn.prepareStatement(
                "UPDATE report_assignments SET assignment_status = 'resolved' WHERE assignment_id = ? AND operator_id = ?"
            );
            ps1.setInt(1, assignmentId);
            ps1.setInt(2, operatorId);
            int rows1 = ps1.executeUpdate();
            ps1.close();
            
            if (rows1 == 0) {
                throw new Exception("Assignment not found or you don't have permission to update it");
            }
            
            // 2. Update reports table status
            PreparedStatement ps2 = cn.prepareStatement(
                "UPDATE reports SET Status = 'resolved', Updated_at = NOW() WHERE Report_id = ?"
            );
            ps2.setInt(1, reportId);
            int rows2 = ps2.executeUpdate();
            ps2.close();
            
            if (rows2 == 0) {
                throw new Exception("Report not found");
            }
            
            // 3. Create or check for resolution_details table and insert resolution info
            DatabaseMetaData meta = cn.getMetaData();
            ResultSet tables = meta.getTables(null, null, "resolution_details", null);
            
            if (!tables.next()) {
                // Create resolution_details table
                Statement stmt = cn.createStatement();
                String createTableSQL = "CREATE TABLE IF NOT EXISTS resolution_details (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "assignment_id INT NOT NULL, " +
                    "report_id INT NOT NULL, " +
                    "operator_id INT NOT NULL, " +
                    "resolution_details TEXT NOT NULL, " +
                    "time_taken DECIMAL(5,2), " +
                    "additional_notes TEXT, " +
                    "resolved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")";
                stmt.execute(createTableSQL);
                stmt.close();
            }
            tables.close();
            
            // 4. Insert resolution details
            PreparedStatement ps3 = cn.prepareStatement(
                "INSERT INTO resolution_details (assignment_id, report_id, operator_id, resolution_details, time_taken, additional_notes) " +
                "VALUES (?, ?, ?, ?, ?, ?)"
            );
            ps3.setInt(1, assignmentId);
            ps3.setInt(2, reportId);
            ps3.setInt(3, operatorId);
            ps3.setString(4, resolutionDetails);
            
            if (timeTaken != null && !timeTaken.isEmpty()) {
                try {
                    ps3.setDouble(5, Double.parseDouble(timeTaken));
                } catch (Exception e) {
                    ps3.setNull(5, java.sql.Types.DECIMAL);
                }
            } else {
                ps3.setNull(5, java.sql.Types.DECIMAL);
            }
            
            ps3.setString(6, additionalNotes);
            ps3.executeUpdate();
            ps3.close();
            
            // 5. Create or check for grievance_comments table and add resolution comment
            DatabaseMetaData meta2 = cn.getMetaData();
            ResultSet tables2 = meta2.getTables(null, null, "grievance_comments", null);
            
            if (!tables2.next()) {
                // Create grievance_comments table
                Statement stmt2 = cn.createStatement();
                String createTableSQL2 = "CREATE TABLE IF NOT EXISTS grievance_comments (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "report_id INT NOT NULL, " +
                    "comment TEXT NOT NULL, " +
                    "author VARCHAR(100) NOT NULL, " +
                    "type ENUM('user', 'admin', 'operator', 'system') DEFAULT 'operator', " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")";
                stmt2.execute(createTableSQL2);
                stmt2.close();
            }
            tables2.close();
            
            // 6. Add resolution comment
            PreparedStatement ps4 = cn.prepareStatement(
                "INSERT INTO grievance_comments (report_id, comment, author, type) " +
                "VALUES (?, ?, ?, 'operator')"
            );
            String comment = "Report marked as resolved by operator. Resolution details: " + resolutionDetails;
            if (additionalNotes != null && !additionalNotes.trim().isEmpty()) {
                comment += " Additional notes: " + additionalNotes;
            }
            ps4.setInt(1, reportId);
            ps4.setString(2, comment);
            ps4.setString(3, operatorName != null ? operatorName : "Operator");
            ps4.executeUpdate();
            ps4.close();
            
            // 7. Create or check for grievance_history table and add history record
            DatabaseMetaData meta3 = cn.getMetaData();
            ResultSet tables3 = meta3.getTables(null, null, "grievance_history", null);
            
            if (!tables3.next()) {
                // Create grievance_history table
                Statement stmt3 = cn.createStatement();
                String createTableSQL3 = "CREATE TABLE IF NOT EXISTS grievance_history (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "report_id INT NOT NULL, " +
                    "old_status VARCHAR(50) NOT NULL, " +
                    "new_status VARCHAR(50) NOT NULL, " +
                    "changed_by VARCHAR(100) NOT NULL, " +
                    "reason TEXT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")";
                stmt3.execute(createTableSQL3);
                stmt3.close();
            }
            tables3.close();
            
            // 8. Add to grievance history
            PreparedStatement ps5 = cn.prepareStatement(
                "INSERT INTO grievance_history (report_id, old_status, new_status, changed_by, reason) " +
                "VALUES (?, 'assigned', 'resolved', ?, ?)"
            );
            ps5.setInt(1, reportId);
            ps5.setString(2, "operator_" + operatorId);
            ps5.setString(3, "Marked as resolved: " + resolutionDetails);
            ps5.executeUpdate();
            ps5.close();
            
            // Commit transaction
            cn.commit();
            
            response.sendRedirect("Fetch_Task.jsp?success=Report marked as resolved successfully!");
            
        } catch (Exception ex) {
            // Rollback transaction on error
            cn.rollback();
            response.sendRedirect("Fetch_Task.jsp?error=" + URLEncoder.encode("Error marking report as resolved: " + ex.getMessage(), "UTF-8"));
        } finally {
            cn.setAutoCommit(true);
            cn.close();
        }
        
    } catch (Exception ex) {
        response.sendRedirect("Fetch_Task.jsp?error=" + URLEncoder.encode("Database error: " + ex.toString(), "UTF-8"));
    }
%>