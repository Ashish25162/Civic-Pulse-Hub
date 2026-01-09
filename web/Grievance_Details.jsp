<%-- 
    Document   : Grievance_Details
    Created on : [Current Date]
    Author     : administration
--%>

<%@page import="java.io.File"%>
<%@page import="java.sql.*" %>
<%@page import="jakarta.servlet.http.HttpSession" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Civic Pulse - Grievance Details</title>
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
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            .header {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
                color: white;
                padding: 30px;
                border-radius: 15px;
                margin-bottom: 30px;
                box-shadow: 0 4px 15px rgba(42, 92, 130, 0.2);
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

            .back-btn {
                display: inline-block;
                margin-top: 20px;
                padding: 10px 20px;
                background-color: white;
                color: var(--primary-color);
                text-decoration: none;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .back-btn:hover {
                background-color: #f0f4f8;
                transform: translateY(-2px);
            }

            .back-btn i {
                margin-right: 8px;
            }

            .details-container {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 30px;
                margin-bottom: 30px;
            }

            @media (max-width: 768px) {
                .details-container {
                    grid-template-columns: 1fr;
                }
            }

            .card {
                background-color: white;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            }

            .card-title {
                font-size: 20px;
                font-weight: 700;
                color: var(--dark-color);
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 2px solid #f0f4f8;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .card-title i {
                color: var(--primary-color);
            }

            .detail-item {
                margin-bottom: 20px;
            }

            .detail-label {
                font-size: 14px;
                color: var(--gray-color);
                font-weight: 600;
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .detail-value {
                font-size: 16px;
                color: var(--dark-color);
                line-height: 1.5;
            }

            .status-badge {
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                display: inline-block;
            }

            .status-submitted {
                background-color: #e8f0fe;
                color: var(--primary-color);
            }

            .status-in-progress {
                background-color: #fef7e0;
                color: #b08c2c;
            }

            .status-resolved {
                background-color: #e6f4ea;
                color: var(--secondary-color);
            }

            .priority-badge {
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                display: inline-block;
            }

            .priority-high {
                background-color: #fce8e6;
                color: var(--accent-color);
            }

            .priority-medium {
                background-color: #fef7e0;
                color: #b08c2c;
            }

            .priority-low {
                background-color: #e6f4ea;
                color: var(--secondary-color);
            }

            .description-box {
                background-color: #f8fafc;
                padding: 20px;
                border-radius: 8px;
                border-left: 4px solid var(--primary-color);
                margin-top: 10px;
            }

            .timeline {
                margin-top: 30px;
            }

            .timeline-item {
                display: flex;
                margin-bottom: 25px;
                position: relative;
            }

            .timeline-item:not(:last-child)::after {
                content: '';
                position: absolute;
                left: 19px;
                top: 40px;
                bottom: -25px;
                width: 2px;
                background-color: #e2e8f0;
            }

            .timeline-icon {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: var(--primary-light);
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
                z-index: 1;
            }

            .timeline-content {
                flex: 1;
            }

            .timeline-date {
                font-size: 14px;
                color: var(--gray-color);
                margin-bottom: 5px;
            }

            .timeline-text {
                font-size: 15px;
                color: var(--dark-color);
            }

            .action-buttons {
                display: flex;
                gap: 15px;
                margin-top: 30px;
                flex-wrap: wrap;
            }

            .btn {
                padding: 12px 24px;
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
                font-size: 14px;
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

            .btn-success {
                background: linear-gradient(135deg, var(--secondary-color) 0%, #5cb487 100%);
                color: white;
            }

            .btn-success:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 18px rgba(74, 156, 125, 0.3);
            }

            .btn-warning {
                background: linear-gradient(135deg, #e9c46a 0%, #f4a261 100%);
                color: white;
            }

            .btn-warning:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 18px rgba(244, 162, 97, 0.3);
            }

            .btn-danger {
                background: linear-gradient(135deg, var(--accent-color) 0%, #ee6c4d 100%);
                color: white;
            }

            .btn-danger:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 18px rgba(231, 111, 81, 0.3);
            }

            .attachments {
                margin-top: 20px;
            }

            .attachment-item {
                display: flex;
                align-items: center;
                padding: 12px;
                background-color: #f8fafc;
                border-radius: 8px;
                margin-bottom: 10px;
                border: 1px solid #e2e8f0;
            }

            .attachment-icon {
                width: 40px;
                height: 40px;
                border-radius: 8px;
                background-color: #e8f0fe;
                color: var(--primary-color);
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
            }

            .attachment-info {
                flex: 1;
            }

            .attachment-name {
                font-weight: 600;
                color: var(--dark-color);
                margin-bottom: 3px;
            }

            .attachment-size {
                font-size: 12px;
                color: var(--gray-color);
            }

            .download-btn {
                padding: 6px 12px;
                background-color: white;
                color: var(--primary-color);
                border: 1px solid #e2e8f0;
                border-radius: 6px;
                text-decoration: none;
                font-size: 12px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .download-btn:hover {
                background-color: var(--primary-light);
                color: white;
                border-color: var(--primary-light);
            }

            .comments-section {
                margin-top: 30px;
            }

            .comment {
                display: flex;
                margin-bottom: 20px;
                padding-bottom: 20px;
                border-bottom: 1px solid #f0f4f8;
            }

            .comment:last-child {
                border-bottom: none;
                margin-bottom: 0;
                padding-bottom: 0;
            }

            .comment-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: var(--primary-light);
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
                font-weight: 700;
            }

            .comment-content {
                flex: 1;
            }

            .comment-header {
                display: flex;
                justify-content: space-between;
                margin-bottom: 8px;
            }

            .comment-author {
                font-weight: 700;
                color: var(--dark-color);
            }

            .comment-date {
                font-size: 13px;
                color: var(--gray-color);
            }

            .comment-text {
                font-size: 14px;
                color: var(--dark-color);
                line-height: 1.5;
            }

            .no-data {
                text-align: center;
                padding: 40px 20px;
                color: var(--gray-color);
            }

            .no-data i {
                font-size: 48px;
                color: #e2e8f0;
                margin-bottom: 15px;
            }

            .no-data p {
                font-size: 16px;
            }

            .alert {
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .alert-info {
                background-color: #e8f0fe;
                color: var(--primary-color);
                border-left: 4px solid var(--primary-color);
            }

            .alert-warning {
                background-color: #fef7e0;
                color: #b08c2c;
                border-left: 4px solid #e9c46a;
            }

            .alert-danger {
                background-color: #fce8e6;
                color: var(--accent-color);
                border-left: 4px solid var(--accent-color);
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
            String userEmail = (String) userSession.getAttribute("email");
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
            
            // Variables to store grievance details
            String reportId = "";
            String title = "";
            String description = "";
            String category = "";
            String status = "";
            String priority = "";
            Date submittedDate = null;
            Date updatedDate = null;
            String location = "";
            String imagePath = "";
            double latitude = 0;
            double longitude = 0;
            
            // Variable to check if grievance exists and belongs to user
            boolean grievanceFound = false;
        %>
        
        <div class="container">
            <!-- Header -->
            <div class="header">
                <h1><i class="fas fa-file-alt"></i> Grievance Details</h1>
                <p>View complete details of your submitted grievance.</p>
                <a href="Grievance_History.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to History
                </a>
            </div>
            
            <%
                try {
                    // Load the driver
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    
                    // Make the connection object
                    Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/civic_pulse_hub", "root", "Ashu@@3450");
                    
                    // Fetch grievance details - USING CORRECT COLUMN NAMES
                    PreparedStatement ps = cn.prepareStatement("SELECT * FROM reports WHERE Report_id = ? AND User_id = ?");
                    ps.setInt(1, grievanceId);
                    ps.setInt(2, userId);
                    
                    ResultSet rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        grievanceFound = true;
                        
                        // Get grievance details - USING CORRECT COLUMN NAMES
                        reportId = rs.getString("Report_id");
                        title = rs.getString("title");
                        description = rs.getString("description");
                        category = rs.getString("Category_id") != null ? "Category " + rs.getString("Category_id") : "General";
                        status = rs.getString("Status");
                        priority = rs.getString("Priority");
                        submittedDate = rs.getDate("Created_at");
                        updatedDate = rs.getDate("Updated_at");
                        location = rs.getString("Location");
                        imagePath = rs.getString("Image_path");
                        latitude = rs.getDouble("Latitude");
                        longitude = rs.getDouble("Longitude");
                        
                        rs.close();
                        ps.close();
                        
                        cn.close();
                    } else {
                        grievanceFound = false;
                        rs.close();
                        ps.close();
                        cn.close();
                    }
                    
                } catch (Exception ex) {
                    out.println("<div class='alert alert-danger'><i class='fas fa-exclamation-circle'></i> Error: " + ex.toString() + "</div>");
                }
                
                if (!grievanceFound) {
            %>
            <div class="card">
                <div class="no-data">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Grievance Not Found</h3>
                    <p>The grievance you are trying to access does not exist or you don't have permission to view it.</p>
                    <a href="Grievance_History.jsp" class="btn btn-primary" style="margin-top: 20px;">
                        <i class="fas fa-arrow-left"></i> Back to Grievance History
                    </a>
                </div>
            </div>
            <%
                } else {
                    // Determine status class - MATCHING YOUR DATABASE VALUES
                    String statusClass = "";
                    String statusText = status != null ? status.toUpperCase() : "PENDING";
                    
                    if (status != null) {
                        switch(status.toLowerCase()) {
                            case "pending":
                                statusClass = "status-submitted";
                                break;
                            case "assigned":
                                statusClass = "status-in-progress";
                                break;
                            case "resolved":
                                statusClass = "status-resolved";
                                break;
                            default:
                                statusClass = "status-submitted";
                        }
                    }
                    
                    // Determine priority class - MATCHING YOUR DATABASE VALUES
                    String priorityClass = "";
                    String priorityText = priority != null ? priority.toUpperCase() : "MEDIUM";
                    
                    if (priority != null) {
                        switch(priority.toLowerCase()) {
                            case "high":
                            case "critical":
                                priorityClass = "priority-high";
                                break;
                            case "medium":
                                priorityClass = "priority-medium";
                                break;
                            case "low":
                                priorityClass = "priority-low";
                                break;
                            default:
                                priorityClass = "priority-medium";
                        }
                    }
            %>
            
            <!-- Grievance Status Alert -->
            <% if ("resolved".equalsIgnoreCase(status)) { %>
            <div class="alert alert-info">
                <i class="fas fa-check-circle"></i>
                <div>
                    <strong>This grievance has been resolved.</strong>
                    <p>You can provide feedback about the resolution or reopen the grievance if the issue persists.</p>
                </div>
            </div>
            <% } else if ("assigned".equalsIgnoreCase(status)) { %>
            <div class="alert alert-warning">
                <i class="fas fa-spinner"></i>
                <div>
                    <strong>This grievance is currently being processed.</strong>
                    <p>Your grievance is being reviewed by the concerned department.</p>
                </div>
            </div>
            <% } %>
            
            <div class="details-container">
                <!-- Left Column: Grievance Details -->
                <div>
                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-info-circle"></i> Grievance Information
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">Grievance ID</div>
                            <div class="detail-value"><strong>CP-<%= reportId %></strong></div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">Title</div>
                            <div class="detail-value"><%= title %></div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">Description</div>
                            <div class="description-box"><%= description %></div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">Category</div>
                            <div class="detail-value"><%= category %></div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">Location</div>
                            <div class="detail-value"><%= location != null ? location : "Not specified" %></div>
                        </div>
                        
                        <% if (imagePath != null && !imagePath.isEmpty()) { %>
                        <div class="detail-item">
                            <div class="detail-label">Attached Image</div>
                            <div class="detail-value">
                                <% if (imagePath != null && !imagePath.isEmpty()) { 
    // Extract just the filename from the path
    String filename = imagePath;
    if (imagePath.contains(File.separator)) {
        filename = imagePath.substring(imagePath.lastIndexOf(File.separator) + 1);
    }
%>
<a href="<%= request.getContextPath() %>/image/<%= filename %>" target="_blank" class="btn btn-secondary">
    <i class="fas fa-image"></i> View Image
</a>
<% } %>
                            </div>
                        </div>
                        <% } %>
                        
                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <% if ("resolved".equalsIgnoreCase(status)) { %>
                            <a href="user_feedback.jsp?id=<%= grievanceId %>" class="btn btn-success">
                                <i class="fas fa-star"></i> Provide Feedback
                            </a>
                            <a href="reopen.jsp?id=<%= grievanceId %>" class="btn btn-warning">
                                <i class="fas fa-redo"></i> Reopen Grievance
                            </a>
                            <% } %>
                            
                            <a href="Grievance_History.jsp" class="btn btn-secondary">
                                <i class="fas fa-history"></i> Back to History
                            </a>
                            
                            <button onclick="window.print()" class="btn btn-secondary">
                                <i class="fas fa-print"></i> Print Details
                            </button>
                        </div>
                    </div>
                    
                    <!-- Comments/Updates Section -->
                    <div class="card comments-section">
                        <div class="card-title">
                            <i class="fas fa-comments"></i> Updates & Comments
                        </div>
                        
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection cn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/civic_pulse_hub", "root", "Ashu@@3450");
                                
                                // Check if the grievance_comments table exists
                                DatabaseMetaData meta = cn2.getMetaData();
                                ResultSet tables = meta.getTables(null, null, "grievance_comments", null);
                                
                                if (tables.next()) {
                                    // Table exists, fetch comments
                                    PreparedStatement psComments = cn2.prepareStatement(
                                        "SELECT * FROM grievance_comments WHERE report_id = ? ORDER BY created_at DESC"
                                    );
                                    psComments.setInt(1, grievanceId);
                                    ResultSet rsComments = psComments.executeQuery();
                                    
                                    if (rsComments.isBeforeFirst()) {
                                        while (rsComments.next()) {
                                            String commentText = rsComments.getString("comment");
                                            String commentAuthor = rsComments.getString("author");
                                            Date commentDate = rsComments.getDate("created_at");
                                            String commentType = rsComments.getString("type");
                        %>
                        <div class="comment">
                            <div class="comment-avatar">
                                <%= commentAuthor != null && !commentAuthor.isEmpty() ? commentAuthor.charAt(0) : "A" %>
                            </div>
                            <div class="comment-content">
                                <div class="comment-header">
                                    <div class="comment-author"><%= commentAuthor != null ? commentAuthor : "Administrator" %></div>
                                    <div class="comment-date"><%= commentDate %></div>
                                </div>
                                <div class="comment-text"><%= commentText %></div>
                            </div>
                        </div>
                        <%
                                        }
                                    } else {
                        %>
                        <div class="no-data">
                            <i class="far fa-comment"></i>
                            <p>No updates or comments available yet.</p>
                        </div>
                        <%
                                    }
                                    rsComments.close();
                                    psComments.close();
                                } else {
                                    // Table doesn't exist
                        %>
                        <div class="no-data">
                            <i class="far fa-comment"></i>
                            <p>No updates or comments available yet.</p>
                        </div>
                        <%
                                }
                                tables.close();
                                cn2.close();
                            } catch (Exception ex) {
                                // Error handling
                        %>
                        <div class="no-data">
                            <i class="far fa-comment"></i>
                            <p>No updates or comments available yet.</p>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
                
                <!-- Right Column: Status & Timeline -->
                <div>
                    <!-- Status Card -->
                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-chart-line"></i> Grievance Status
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">Current Status</div>
                            <div class="detail-value">
                                <span class="status-badge <%= statusClass %>">
                                    <%= statusText %>
                                </span>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">Priority</div>
                            <div class="detail-value">
                                <span class="priority-badge <%= priorityClass %>">
                                    <%= priorityText %>
                                </span>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">Submitted Date</div>
                            <div class="detail-value"><%= submittedDate %></div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">Last Updated</div>
                            <div class="detail-value"><%= updatedDate != null ? updatedDate : submittedDate %></div>
                        </div>
                    </div>
                    
                    <!-- Timeline Card -->
                    <div class="card timeline">
                        <div class="card-title">
                            <i class="fas fa-stream"></i> Grievance Timeline
                        </div>
                        
                        <div class="timeline-item">
                            <div class="timeline-icon">
                                <i class="fas fa-plus"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-date"><%= submittedDate %></div>
                                <div class="timeline-text">Grievance submitted</div>
                            </div>
                        </div>
                        
                        <% if (updatedDate != null && !updatedDate.equals(submittedDate)) { %>
                        <div class="timeline-item">
                            <div class="timeline-icon">
                                <i class="fas fa-edit"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-date"><%= updatedDate %></div>
                                <div class="timeline-text">Status updated to <strong><%= statusText %></strong></div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    
                    <!-- Attachments Card -->
                    <div class="card">
                        <div class="card-title">
                            <i class="fas fa-paperclip"></i> Attachments
                        </div>
                        
                        <div class="attachments">
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection cn3 = DriverManager.getConnection("jdbc:mysql://localhost:3306/civic_pulse_hub", "root", "Ashu@@3450");
                                    
                                    // Check if the grievance_attachments table exists
                                    DatabaseMetaData meta2 = cn3.getMetaData();
                                    ResultSet tables2 = meta2.getTables(null, null, "grievance_attachments", null);
                                    
                                    if (tables2.next()) {
                                        // Table exists, fetch attachments
                                        PreparedStatement psAttachments = cn3.prepareStatement(
                                            "SELECT * FROM grievance_attachments WHERE report_id = ?"
                                        );
                                        psAttachments.setInt(1, grievanceId);
                                        ResultSet rsAttachments = psAttachments.executeQuery();
                                        
                                        if (rsAttachments.isBeforeFirst()) {
                                            while (rsAttachments.next()) {
                                                String fileName = rsAttachments.getString("file_name");
                                                String filePath = rsAttachments.getString("file_path");
                                                String fileType = rsAttachments.getString("file_type");
                                                long fileSize = rsAttachments.getLong("file_size");
                                                
                                                // Format file size
                                                String formattedSize = "";
                                                if (fileSize < 1024) {
                                                    formattedSize = fileSize + " B";
                                                } else if (fileSize < 1048576) {
                                                    formattedSize = String.format("%.1f KB", fileSize / 1024.0);
                                                } else {
                                                    formattedSize = String.format("%.1f MB", fileSize / 1048576.0);
                                                }
                            %>
                            <div class="attachment-item">
                                <div class="attachment-icon">
                                    <%
                                        String fileIcon = "fa-file";
                                        if (fileType != null) {
                                            if (fileType.contains("image")) {
                                                fileIcon = "fa-file-image";
                                            } else if (fileType.contains("pdf")) {
                                                fileIcon = "fa-file-pdf";
                                            } else if (fileType.contains("word") || fileType.contains("document")) {
                                                fileIcon = "fa-file-word";
                                            } else if (fileType.contains("excel") || fileType.contains("spreadsheet")) {
                                                fileIcon = "fa-file-excel";
                                            }
                                        }
                                    %>
                                    <i class="fas <%= fileIcon %>"></i>
                                </div>
                                <div class="attachment-info">
                                    <div class="attachment-name"><%= fileName %></div>
                                    <div class="attachment-size"><%= formattedSize %> • <%= fileType != null ? fileType : "Unknown type" %></div>
                                </div>
                                <a href="<%= filePath %>" class="download-btn" download>
                                    <i class="fas fa-download"></i>
                                </a>
                            </div>
                            <%
                                            }
                                        } else {
                            %>
                            <div class="no-data">
                                <i class="far fa-file"></i>
                                <p>No attachments found</p>
                            </div>
                            <%
                                        }
                                        rsAttachments.close();
                                        psAttachments.close();
                                    } else {
                                        // Table doesn't exist
                            %>
                            <div class="no-data">
                                <i class="far fa-file"></i>
                                <p>No attachments found</p>
                            </div>
                            <%
                                    }
                                    tables2.close();
                                    cn3.close();
                                } catch (Exception ex) {
                                    // Table might not exist, show appropriate message
                            %>
                            <div class="no-data">
                                <i class="far fa-file"></i>
                                <p>No attachments found</p>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>
        
        <script>
            // JavaScript for additional interactivity
            document.addEventListener('DOMContentLoaded', function() {
                // Add confirmation for reopening grievance
                const reopenBtn = document.querySelector('a[href*="reopen.jsp"]');
                if (reopenBtn) {
                    reopenBtn.addEventListener('click', function(e) {
                        if (!confirm('Are you sure you want to reopen this grievance? This will change its status back to "Assigned" and notify the concerned department.')) {
                            e.preventDefault();
                        }
                    });
                }
                
                // Print functionality
                const printBtn = document.querySelector('button[onclick*="print"]');
                if (printBtn) {
                    printBtn.addEventListener('click', function() {
                        window.print();
                    });
                }
                
                // Update page title with grievance ID
                const grievanceIdElement = document.querySelector('.detail-value strong');
                if (grievanceIdElement) {
                    document.title = 'Civic Pulse - Grievance: ' + grievanceIdElement.textContent;
                }
            });
        </script>
    </body>
</html>