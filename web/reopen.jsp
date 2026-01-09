<%-- 
    Document   : reopen_grievance
    Created on : [Current Date]
    Author     : administration
--%>

<%@page import="java.sql.*" %>
<%@page import="jakarta.servlet.http.HttpSession" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Civic Pulse - Reopen Grievance</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --primary-color: #2a5c82;
                --primary-light: #3a7ca5;
                --secondary-color: #4a9c7d;
                --accent-color: #e76f51;
                --light-color: #f8f9fa;
                --dark-color: #2d3748;
                --gray-color: #718096;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-color: #f5f7fa;
                color: var(--dark-color);
                line-height: 1.6;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                padding: 20px;
            }

            .container {
                max-width: 800px;
                width: 100%;
            }

            .header {
                background: linear-gradient(135deg, #e9c46a 0%, #f4a261 100%);
                color: white;
                padding: 30px;
                border-radius: 15px 15px 0 0;
                box-shadow: 0 4px 15px rgba(244, 162, 97, 0.2);
            }

            .header h1 {
                font-size: 32px;
                margin-bottom: 10px;
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .header p {
                font-size: 16px;
                opacity: 0.9;
            }

            .reopen-form {
                background-color: white;
                padding: 40px;
                border-radius: 0 0 15px 15px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            }

            .form-group {
                margin-bottom: 25px;
            }

            .form-label {
                display: block;
                font-weight: 600;
                margin-bottom: 8px;
                color: var(--dark-color);
            }

            .form-control {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 16px;
                transition: all 0.3s ease;
            }

            .form-control:focus {
                outline: none;
                border-color: var(--primary-light);
                box-shadow: 0 0 0 3px rgba(58, 124, 165, 0.1);
            }

            textarea.form-control {
                min-height: 120px;
                resize: vertical;
            }

            .btn {
                padding: 12px 30px;
                border-radius: 8px;
                font-weight: 600;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
                font-size: 16px;
                margin-right: 15px;
            }

            .btn-warning {
                background: linear-gradient(135deg, #e9c46a 0%, #f4a261 100%);
                color: white;
            }

            .btn-warning:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 18px rgba(244, 162, 97, 0.3);
            }

            .btn-primary {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
                color: white;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 18px rgba(42, 92, 130, 0.3);
            }

            .btn-secondary {
                background-color: white;
                color: var(--dark-color);
                border: 1px solid #e2e8f0;
            }

            .btn-secondary:hover {
                background-color: #f8fafc;
                transform: translateY(-2px);
            }

            .alert {
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .alert-warning {
                background-color: #fef7e0;
                color: #b08c2c;
                border-left: 4px solid #e9c46a;
            }

            .alert-info {
                background-color: #e8f0fe;
                color: var(--primary-color);
                border-left: 4px solid var(--primary-color);
            }

            .alert-danger {
                background-color: #fce8e6;
                color: var(--accent-color);
                border-left: 4px solid var(--accent-color);
            }

            .alert-success {
                background-color: #e6f4ea;
                color: var(--secondary-color);
                border-left: 4px solid var(--secondary-color);
            }

            .grievance-info {
                background-color: #f8fafc;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 30px;
                border-left: 4px solid #f4a261;
            }

            .grievance-info h3 {
                margin-bottom: 10px;
                color: var(--dark-color);
            }

            .grievance-info p {
                color: var(--gray-color);
                margin-bottom: 5px;
            }

            .back-link {
                display: inline-block;
                margin-top: 20px;
                color: var(--primary-color);
                text-decoration: none;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .back-link:hover {
                text-decoration: underline;
            }

            .success-message {
                text-align: center;
                padding: 40px;
            }

            .success-message i {
                font-size: 64px;
                color: var(--secondary-color);
                margin-bottom: 20px;
            }

            .success-message h2 {
                color: var(--dark-color);
                margin-bottom: 15px;
            }

            .success-message p {
                color: var(--gray-color);
                margin-bottom: 30px;
                max-width: 500px;
                margin-left: auto;
                margin-right: auto;
            }

            .reason-options {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 15px;
                margin-bottom: 20px;
            }

            .reason-option {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 15px;
                background-color: #f8fafc;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .reason-option:hover {
                background-color: #f0f4f8;
            }

            .reason-option input {
                width: 18px;
                height: 18px;
            }

            .reason-option label {
                cursor: pointer;
                font-weight: 500;
                flex: 1;
            }
        </style>
    </head>
    <body>
        <%
            // Check if user is logged in
            HttpSession userSession = request.getSession(false);
            if (userSession == null || userSession.getAttribute("email") == null) {
                response.sendRedirect("User_Login.html");
                return;
            }
            
            // Get user data from session
            String userName = (String) userSession.getAttribute("name");
            int userId = 0;
            
            if (userSession.getAttribute("user_id") != null) {
                try {
                    userId = Integer.parseInt(userSession.getAttribute("user_id").toString());
                } catch (Exception e) {
                    userId = 0;
                }
            }
            
            // Get grievance ID from request parameter
            String grievanceIdParam = request.getParameter("id");
            int grievanceId = 0;
            String grievanceTitle = "";
            String grievanceDescription = "";
            boolean isResolved = false;
            boolean alreadyReopened = false;
            
            if (grievanceIdParam != null && !grievanceIdParam.isEmpty()) {
                try {
                    grievanceId = Integer.parseInt(grievanceIdParam);
                } catch (Exception e) {
                    response.sendRedirect("Grievance_History.jsp");
                    return;
                }
            } else {
                response.sendRedirect("Grievance_History.jsp");
                return;
            }
            
            // Check if grievance exists and is resolved
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/civic_pulse_hub", "root", "Ashu@@3450");
                
                // USING CORRECT COLUMN NAMES
                PreparedStatement ps = cn.prepareStatement(
                    "SELECT title, description, Status FROM reports WHERE Report_id = ? AND User_id = ?"
                );
                ps.setInt(1, grievanceId);
                ps.setInt(2, userId);
                
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    grievanceTitle = rs.getString("title");
                    grievanceDescription = rs.getString("description");
                    isResolved = "resolved".equalsIgnoreCase(rs.getString("Status"));
                    
                    // Check if grievance_history table exists
                    DatabaseMetaData meta = cn.getMetaData();
                    ResultSet tables = meta.getTables(null, null, "grievance_history", null);
                    
                    if (tables.next()) {
                        // Check if already reopened (status changed from resolved to assigned)
                        PreparedStatement psCheck = cn.prepareStatement(
                            "SELECT COUNT(*) as count FROM grievance_history WHERE report_id = ? AND old_status = 'resolved' AND new_status = 'assigned'"
                        );
                        psCheck.setInt(1, grievanceId);
                        ResultSet rsCheck = psCheck.executeQuery();
                        if (rsCheck.next()) {
                            alreadyReopened = rsCheck.getInt("count") > 0;
                        }
                        rsCheck.close();
                        psCheck.close();
                    }
                    tables.close();
                } else {
                    response.sendRedirect("Grievance_History.jsp");
                    return;
                }
                
                rs.close();
                ps.close();
                cn.close();
                
            } catch (Exception ex) {
                out.println("<div class='alert alert-info'><i class='fas fa-exclamation-circle'></i> Error: " + ex.toString() + "</div>");
            }
            
            // Check if form was submitted
            boolean formSubmitted = "POST".equalsIgnoreCase(request.getMethod());
            boolean success = false;
            
            if (formSubmitted && isResolved && !alreadyReopened) {
                String reason = request.getParameter("reason");
                String additionalDetails = request.getParameter("additional_details");
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/civic_pulse_hub", "root", "Ashu@@3450");
                    
                    // Start transaction
                    cn.setAutoCommit(false);
                    
                    try {
                        // Update grievance status
                        PreparedStatement psUpdate = cn.prepareStatement(
                            "UPDATE reports SET Status = 'pending', Updated_at = NOW() WHERE Report_id = ? AND User_id = ?"
                        );
                        psUpdate.setInt(1, grievanceId);
                        psUpdate.setInt(2, userId);
                        int rowsUpdated = psUpdate.executeUpdate();
                        psUpdate.close();
                        
                        if (rowsUpdated > 0) {
                            // Check and create grievance_history table if needed
                            DatabaseMetaData meta = cn.getMetaData();
                            ResultSet tables = meta.getTables(null, null, "grievance_history", null);
                            
                            if (!tables.next()) {
                                // Create grievance_history table
                                Statement stmt = cn.createStatement();
                                String createTableSQL = "CREATE TABLE IF NOT EXISTS grievance_history (" +
                                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                                    "report_id INT NOT NULL, " +
                                    "old_status VARCHAR(50) NOT NULL, " +
                                    "new_status VARCHAR(50) NOT NULL, " +
                                    "changed_by VARCHAR(100) NOT NULL, " +
                                    "reason TEXT, " +
                                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
                                stmt.execute(createTableSQL);
                                stmt.close();
                            }
                            tables.close();
                            
                            // Add to grievance history
                            PreparedStatement psHistory = cn.prepareStatement(
                                "INSERT INTO grievance_history (report_id, old_status, new_status, changed_by, reason) " +
                                "VALUES (?, 'resolved', 'assigned', ?, ?)"
                            );
                            psHistory.setInt(1, grievanceId);
                            psHistory.setString(2, "user_" + userId);
                            psHistory.setString(3, reason + (additionalDetails != null && !additionalDetails.isEmpty() ? ": " + additionalDetails : ""));
                            psHistory.executeUpdate();
                            psHistory.close();
                            
                            // Check and create grievance_comments table if needed
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
                                    "type ENUM('user', 'admin', 'system') DEFAULT 'system', " +
                                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
                                stmt2.execute(createTableSQL2);
                                stmt2.close();
                            }
                            tables2.close();
                            
                            // Add comment about reopening
                            PreparedStatement psComment = cn.prepareStatement(
                                "INSERT INTO grievance_comments (report_id, comment, author, type) " +
                                "VALUES (?, ?, ?, 'system')"
                            );
                            String commentText = "Grievance reopened by user. Reason: " + reason;
                            if (additionalDetails != null && !additionalDetails.isEmpty()) {
                                commentText += " - " + additionalDetails;
                            }
                            psComment.setInt(1, grievanceId);
                            psComment.setString(2, commentText);
                            psComment.setString(3, userName);
                            psComment.executeUpdate();
                            psComment.close();
                            
                            cn.commit();
                            success = true;
                        }
                    } catch (Exception ex) {
                        cn.rollback();
                        throw ex;
                    }
                    
                    cn.close();
                    
                } catch (Exception ex) {
                    out.println("<div class='alert alert-danger'><i class='fas fa-exclamation-circle'></i> Error reopening grievance: " + ex.toString() + "</div>");
                }
            }
        %>
        
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-redo"></i> Reopen Grievance</h1>
                <p>Reopen a resolved grievance if the issue persists or was not properly resolved.</p>
            </div>
            
            <div class="reopen-form">
                <% if (!isResolved) { %>
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                    <div>
                        <strong>Cannot reopen grievance</strong>
                        <p>Only resolved grievances can be reopened. The selected grievance is not in resolved status.</p>
                    </div>
                </div>
                
                <div style="text-align: center; margin-top: 30px;">
                    <a href="Grievance_Details.jsp?id=<%= grievanceId %>" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Grievance Details
                    </a>
                </div>
                
                <% } else if (alreadyReopened && !formSubmitted) { %>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    <div>
                        <strong>Grievance Already Reopened</strong>
                        <p>This grievance has already been reopened and is currently being processed again.</p>
                    </div>
                </div>
                
                <div style="text-align: center; margin-top: 30px;">
                    <a href="Grievance_Details.jsp?id=<%= grievanceId %>" class="btn btn-primary">
                        <i class="fas fa-eye"></i> View Updated Status
                    </a>
                </div>
                
                <% } else if (success) { %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i>
                    <h2>Grievance Reopened Successfully!</h2>
                    <p>Your grievance has been reopened and its status has been changed to "Assigned". The concerned department has been notified.</p>
                    <div style="display: flex; justify-content: center; gap: 15px;">
                        <a href="Grievance_Details.jsp?id=<%= grievanceId %>" class="btn btn-primary">
                            <i class="fas fa-eye"></i> View Updated Status
                        </a>
                        <a href="Grievance_History.jsp" class="btn btn-secondary">
                            <i class="fas fa-history"></i> View History
                        </a>
                    </div>
                </div>
                
                <% } else { %>
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                    <div>
                        <strong>Important Notice</strong>
                        <p>Reopening a grievance will change its status back to "Assigned" and notify the concerned department. Please provide a valid reason for reopening.</p>
                    </div>
                </div>
                
                <div class="grievance-info">
                    <h3><i class="fas fa-file-alt"></i> <%= grievanceTitle %></h3>
                    <p><strong>Grievance ID:</strong> CP-<%= grievanceId %></p>
                    <p><strong>Description:</strong> <%= grievanceDescription.length() > 150 ? grievanceDescription.substring(0, 150) + "..." : grievanceDescription %></p>
                </div>
                
                <form method="POST" action="reopen.jsp?id=<%= grievanceId %>" onsubmit="return confirmReopen()">
                    <div class="form-group">
                        <label class="form-label">Reason for Reopening *</label>
                        <div class="reason-options">
                            <div class="reason-option">
                                <input type="radio" id="reason1" name="reason" value="Issue not fully resolved" required>
                                <label for="reason1">Issue not fully resolved</label>
                            </div>
                            <div class="reason-option">
                                <input type="radio" id="reason2" name="reason" value="Issue reoccurred" required>
                                <label for="reason2">Issue reoccurred</label>
                            </div>
                            <div class="reason-option">
                                <input type="radio" id="reason3" name="reason" value="New information available" required>
                                <label for="reason3">New information available</label>
                            </div>
                            <div class="reason-option">
                                <input type="radio" id="reason4" name="reason" value="Solution was ineffective" required>
                                <label for="reason4">Solution was ineffective</label>
                            </div>
                            <div class="reason-option">
                                <input type="radio" id="reason5" name="reason" value="Other" required>
                                <label for="reason5">Other reason</label>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Additional Details</label>
                        <textarea class="form-control" name="additional_details" placeholder="Please provide additional details about why you are reopening this grievance..." rows="4"></textarea>
                    </div>
                    
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 30px;">
                        <a href="Grievance_Details.jsp?id=<%= grievanceId %>" class="back-link">
                            <i class="fas fa-arrow-left"></i> Cancel and Go Back
                        </a>
                        
                        <button type="submit" class="btn btn-warning">
                            <i class="fas fa-redo"></i> Reopen Grievance
                        </button>
                    </div>
                </form>
                <% } %>
            </div>
        </div>
        
        <script>
            // Form validation and confirmation
            function confirmReopen() {
                const reasonSelected = document.querySelector('input[name="reason"]:checked');
                if (!reasonSelected) {
                    alert('Please select a reason for reopening the grievance.');
                    return false;
                }
                
                return confirm('Are you sure you want to reopen this grievance? This will change its status back to "Assigned" and notify the concerned department.');
            }
            
            // Make reason options clickable
            document.addEventListener('DOMContentLoaded', function() {
                const reasonOptions = document.querySelectorAll('.reason-option');
                reasonOptions.forEach(option => {
                    option.addEventListener('click', function() {
                        const radio = this.querySelector('input[type="radio"]');
                        radio.checked = true;
                        
                        // Visual feedback
                        reasonOptions.forEach(opt => opt.style.backgroundColor = '#f8fafc');
                        this.style.backgroundColor = '#f0f4f8';
                    });
                });
                
                // Check if form has validation errors
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.has('error')) {
                    alert('There was an error processing your request. Please try again.');
                }
            });
        </script>
    </body>
</html>