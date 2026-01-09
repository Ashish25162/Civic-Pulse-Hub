<%-- 
    Document   : Get_Report_Details
    Created on : [Current Date]
    Author     : administration
--%>

<%@page import="java.sql.*" %>
<%@page import="jakarta.servlet.http.HttpSession" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Check if operator is logged in - CORRECTED SESSION VARIABLE NAME
    HttpSession operatorSession = request.getSession(false);
    if (operatorSession == null || operatorSession.getAttribute("email") == null) {
        out.print("<div style='color: red; padding: 20px;'>Session expired. Please login again.</div>");
        return;
    }
    
    // Get report ID from parameter
    String reportIdStr = request.getParameter("report_id");
    int reportId = 0;
    
    if (reportIdStr != null && !reportIdStr.isEmpty()) {
        try {
            reportId = Integer.parseInt(reportIdStr);
        } catch (Exception e) {
            out.print("<div style='color: red; padding: 20px;'>Invalid report ID</div>");
            return;
        }
    } else {
        out.print("<div style='color: red; padding: 20px;'>Report ID is required</div>");
        return;
    }
    
    try {
        // Load the driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Make the connection object
        Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/civic_pulse_hub", "root", "Ashu@@3450");
        
        // Get report details
        PreparedStatement ps = cn.prepareStatement(
            "SELECT r.*, u.Name as user_name, u.Email as user_email, u.Mobile as user_phone, " +
            "u.address as user_address, ra.assigned_at, ra.assignment_status, " +
            "o.full_name as operator_name, o.department as operator_dept " +
            "FROM reports r " +
            "INNER JOIN user u ON r.User_id = u.user_id " +
            "LEFT JOIN report_assignments ra ON r.Report_id = ra.report_id " +
            "LEFT JOIN operator o ON ra.operator_id = o.operator_id " +
            "WHERE r.Report_id = ?"
        );
        ps.setInt(1, reportId);
        
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            String title = rs.getString("title");
            String description = rs.getString("description");
            String category = rs.getString("Category_id");
            String location = rs.getString("Location");
            String status = rs.getString("Status");
            String priority = rs.getString("Priority");
            Date createdAt = rs.getDate("Created_at");
            Date updatedAt = rs.getDate("Updated_at");
            String imagePath = rs.getString("Image_path");
            double latitude = rs.getDouble("Latitude");
            double longitude = rs.getDouble("Longitude");
            
            String userName = rs.getString("user_name");
            String userEmail = rs.getString("user_email");
            String userPhone = rs.getString("user_phone");
            String userAddress = rs.getString("user_address");
            
            Date assignedAt = rs.getDate("assigned_at");
            String assignmentStatus = rs.getString("assignment_status");
            String operatorName = rs.getString("operator_name");
            String operatorDept = rs.getString("operator_dept");
            
            // Format status for display
            String statusText = status != null ? status.toUpperCase() : "PENDING";
            String statusClass = "";
            
            if (status != null) {
                switch(status.toLowerCase()) {
                    case "pending":
                        statusClass = "status-pending";
                        break;
                    case "assigned":
                        statusClass = "status-assigned";
                        break;
                    case "resolved":
                        statusClass = "status-resolved";
                        break;
                    default:
                        statusClass = "status-pending";
                }
            }
            
            // Format priority for display
            String priorityText = priority != null ? priority.toUpperCase() : "MEDIUM";
            String priorityClass = "";
            
            if (priority != null) {
                switch(priority.toLowerCase()) {
                    case "critical":
                        priorityClass = "priority-critical";
                        break;
                    case "high":
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
        <style>
            .detail-section {
                margin-bottom: 25px;
            }
            .detail-title {
                font-size: 16px;
                font-weight: 600;
                color: #2d3748;
                margin-bottom: 10px;
                padding-bottom: 8px;
                border-bottom: 2px solid #f0f4f8;
            }
            .detail-row {
                display: flex;
                margin-bottom: 12px;
            }
            .detail-label {
                width: 140px;
                font-weight: 500;
                color: #718096;
                font-size: 14px;
            }
            .detail-value {
                flex: 1;
                color: #2d3748;
                font-size: 14px;
            }
            .badge {
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }
            .description-box {
                background-color: #f8fafc;
                padding: 15px;
                border-radius: 6px;
                border-left: 4px solid #3a7ca5;
                margin-top: 5px;
            }
        </style>
        
        <div class="detail-section">
            <div class="detail-title">Report Information</div>
            <div class="detail-row">
                <div class="detail-label">Report ID:</div>
                <div class="detail-value"><strong>CP-<%= reportId %></strong></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Title:</div>
                <div class="detail-value"><%= title %></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Description:</div>
                <div class="detail-value">
                    <div class="description-box"><%= description %></div>
                </div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Category:</div>
                <div class="detail-value"><%= category != null ? "Category " + category : "General" %></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Location:</div>
                <div class="detail-value"><%= location != null ? location : "Not specified" %></div>
            </div>
            <% if (imagePath != null && !imagePath.isEmpty()) { %>
            <div class="detail-row">
                <div class="detail-label">Image:</div>
                <div class="detail-value">
                    <a href="<%= imagePath %>" target="_blank" style="color: #3a7ca5; text-decoration: underline;">
                        <i class="fas fa-image"></i> View Attached Image
                    </a>
                </div>
            </div>
            <% } %>
        </div>
        
        <div class="detail-section">
            <div class="detail-title">Status Information</div>
            <div class="detail-row">
                <div class="detail-label">Current Status:</div>
                <div class="detail-value">
                    <span class="badge" style="background-color: 
                        <%= "resolved".equalsIgnoreCase(status) ? "#e6f4ea" : 
                           "assigned".equalsIgnoreCase(status) ? "#e8f0fe" : "#fce8e6" %>; 
                        color: <%= "resolved".equalsIgnoreCase(status) ? "#4a9c7d" : 
                                "assigned".equalsIgnoreCase(status) ? "#2a5c82" : "#e76f51" %>;">
                        <%= statusText %>
                    </span>
                </div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Priority:</div>
                <div class="detail-value">
                    <span class="badge" style="background-color: 
                        <%= "critical".equalsIgnoreCase(priority) ? "#fce8e6" : 
                           "high".equalsIgnoreCase(priority) ? "#fce8e6" : 
                           "medium".equalsIgnoreCase(priority) ? "#fef7e0" : "#e6f4ea" %>; 
                        color: <%= "critical".equalsIgnoreCase(priority) ? "#d93025" : 
                                "high".equalsIgnoreCase(priority) ? "#e76f51" : 
                                "medium".equalsIgnoreCase(priority) ? "#b08c2c" : "#4a9c7d" %>;">
                        <%= priorityText %>
                    </span>
                </div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Created Date:</div>
                <div class="detail-value"><%= createdAt %></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Last Updated:</div>
                <div class="detail-value"><%= updatedAt != null ? updatedAt : createdAt %></div>
            </div>
        </div>
        
        <div class="detail-section">
            <div class="detail-title">User Information</div>
            <div class="detail-row">
                <div class="detail-label">Name:</div>
                <div class="detail-value"><%= userName %></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Email:</div>
                <div class="detail-value"><%= userEmail %></div>
            </div>
            <% if (userPhone != null && !userPhone.isEmpty()) { %>
            <div class="detail-row">
                <div class="detail-label">Phone:</div>
                <div class="detail-value"><%= userPhone %></div>
            </div>
            <% } %>
            <% if (userAddress != null && !userAddress.isEmpty()) { %>
            <div class="detail-row">
                <div class="detail-label">Address:</div>
                <div class="detail-value"><%= userAddress %></div>
            </div>
            <% } %>
        </div>
        
        <% if (assignedAt != null) { %>
        <div class="detail-section">
            <div class="detail-title">Assignment Information</div>
            <div class="detail-row">
                <div class="detail-label">Assigned To:</div>
                <div class="detail-value"><%= operatorName != null ? operatorName : "Not assigned" %></div>
            </div>
            <% if (operatorDept != null) { %>
            <div class="detail-row">
                <div class="detail-label">Department:</div>
                <div class="detail-value"><%= operatorDept %></div>
            </div>
            <% } %>
            <div class="detail-row">
                <div class="detail-label">Assigned Date:</div>
                <div class="detail-value"><%= assignedAt %></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Assignment Status:</div>
                <div class="detail-value">
                    <span class="badge" style="background-color: 
                        <%= "resolved".equalsIgnoreCase(assignmentStatus) ? "#e6f4ea" : "#e8f0fe" %>; 
                        color: <%= "resolved".equalsIgnoreCase(assignmentStatus) ? "#4a9c7d" : "#2a5c82" %>;">
                        <%= assignmentStatus != null ? assignmentStatus.toUpperCase() : "ASSIGNED" %>
                    </span>
                </div>
            </div>
        </div>
        <% } %>
        
        <% if (latitude != 0 && longitude != 0) { %>
        <div class="detail-section">
            <div class="detail-title">Location Coordinates</div>
            <div class="detail-row">
                <div class="detail-label">Latitude:</div>
                <div class="detail-value"><%= latitude %></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Longitude:</div>
                <div class="detail-value"><%= longitude %></div>
            </div>
        </div>
        <% } %>
<%
        } else {
            out.print("<div style='color: red; padding: 20px;'>Report not found</div>");
        }
        
        rs.close();
        ps.close();
        cn.close();
        
    } catch (Exception ex) {
        out.print("<div style='color: red; padding: 20px;'>Error loading report details: " + ex.toString() + "</div>");
    }
%>