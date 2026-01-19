<%-- 
    Document   : Fetch_Task
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
        <title>Civic Pulse - Operator Tasks</title>
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
                max-width: 1400px;
                margin: 0 auto;
                padding: 20px;
            }

            .header {
                background: linear-gradient(135deg, #2a5c82 0%, #3a7ca5 100%);
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

            .stats-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background-color: white;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                text-align: center;
                transition: all 0.3s ease;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
            }

            .stat-number {
                font-size: 36px;
                font-weight: 800;
                margin-bottom: 8px;
                color: var(--dark-color);
            }

            .stat-label {
                font-size: 15px;
                color: var(--gray-color);
                font-weight: 500;
            }

            .table-container {
                background-color: white;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                min-width: 1200px;
            }

            th {
                background-color: #f8fafc;
                padding: 18px 24px;
                text-align: left;
                font-weight: 700;
                color: var(--dark-color);
                border-bottom: 2px solid #e2e8f0;
                font-size: 14px;
                text-transform: uppercase;
            }

            td {
                padding: 18px 24px;
                border-bottom: 1px solid #f0f4f8;
                font-size: 14px;
                vertical-align: top;
            }

            tbody tr:hover {
                background-color: #f8fafc;
            }

            .status-badge {
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                display: inline-block;
            }

            .status-assigned {
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

            .status-pending {
                background-color: #fce8e6;
                color: var(--accent-color);
            }

            .priority-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                display: inline-block;
            }

            .priority-critical {
                background-color: #fce8e6;
                color: #d93025;
                border: 1px solid #f4c7c3;
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

            .action-btns {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            .action-btn {
                padding: 8px 16px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 5px;
                border: none;
                cursor: pointer;
            }

            .btn-view {
                background-color: #e8f0fe;
                color: var(--primary-color);
                border: 1px solid #d1e1f8;
            }

            .btn-view:hover {
                background-color: #d1e1f8;
            }

            .btn-resolve {
                background-color: #e6f4ea;
                color: var(--secondary-color);
                border: 1px solid #c6e7d2;
            }

            .btn-resolve:hover {
                background-color: #c6e7d2;
            }

            .btn-comment {
                background-color: #fef7e0;
                color: #b08c2c;
                border: 1px solid #f9e4b7;
            }

            .btn-comment:hover {
                background-color: #f9e4b7;
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: var(--gray-color);
            }

            .empty-state i {
                font-size: 64px;
                color: #e2e8f0;
                margin-bottom: 20px;
            }

            .empty-state h3 {
                font-size: 22px;
                margin-bottom: 10px;
                color: var(--dark-color);
            }

            .empty-state p {
                font-size: 16px;
                margin-bottom: 30px;
                max-width: 500px;
                margin: 0 auto 30px;
            }

            .filter-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
                flex-wrap: wrap;
                gap: 15px;
            }

            .filter-group {
                display: flex;
                gap: 15px;
                align-items: center;
                flex-wrap: wrap;
            }

            .filter-select {
                padding: 10px 15px;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                background-color: white;
                color: var(--dark-color);
                font-size: 14px;
                min-width: 150px;
            }

            .filter-select:focus {
                outline: none;
                border-color: var(--primary-light);
                box-shadow: 0 0 0 3px rgba(58, 124, 165, 0.1);
            }

            .refresh-btn {
                padding: 10px 20px;
                background-color: #f8fafc;
                color: var(--dark-color);
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .refresh-btn:hover {
                background-color: #e2e8f0;
            }

            .alert {
                padding: 15px 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .alert-success {
                background-color: #e6f4ea;
                color: var(--secondary-color);
                border-left: 4px solid var(--secondary-color);
            }

            .alert-error {
                background-color: #fce8e6;
                color: var(--accent-color);
                border-left: 4px solid var(--accent-color);
            }

            .alert-info {
                background-color: #e8f0fe;
                color: var(--primary-color);
                border-left: 4px solid var(--primary-color);
            }

            .modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                z-index: 1000;
                align-items: center;
                justify-content: center;
            }

            .modal-content {
                background-color: white;
                border-radius: 12px;
                width: 90%;
                max-width: 500px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                overflow: hidden;
            }

            .modal-header {
                padding: 25px 30px;
                background-color: #f8fafc;
                border-bottom: 1px solid #e2e8f0;
            }

            .modal-header h3 {
                color: var(--dark-color);
                font-size: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .modal-body {
                padding: 30px;
            }

            .modal-footer {
                padding: 20px 30px;
                background-color: #f8fafc;
                border-top: 1px solid #e2e8f0;
                display: flex;
                justify-content: flex-end;
                gap: 15px;
            }

            .form-group {
                margin-bottom: 20px;
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

            @media (max-width: 768px) {
                .container {
                    padding: 15px;
                }
                
                .header {
                    padding: 20px;
                }
                
                .header h1 {
                    font-size: 26px;
                }
                
                .stats-container {
                    grid-template-columns: 1fr;
                }
                
                .table-container {
                    padding: 15px;
                }
                
                .filter-container {
                    flex-direction: column;
                    align-items: flex-start;
                }
                
                .action-btns {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <%
            // Check if operator is logged in - CORRECTED SESSION VARIABLE NAMES
            HttpSession operatorSession = request.getSession(false);
            if (operatorSession == null || operatorSession.getAttribute("email") == null) {
                response.sendRedirect("Operator_Login.html");
                return;
            }
            
            // Get operator data from session - CORRECTED SESSION VARIABLE NAMES
            String operatorName = (String) operatorSession.getAttribute("full_name");
            String operatorEmail = (String) operatorSession.getAttribute("email");
            String operatorPhone = (String) operatorSession.getAttribute("phone");
            int operatorId = 0;
            
            if (operatorSession.getAttribute("operator_id") != null) {
                try {
                    operatorId = Integer.parseInt(operatorSession.getAttribute("operator_id").toString());
                } catch (Exception e) {
                    operatorId = 0;
                }
            }
            
            // Get success/error messages from parameters
            String successMsg = request.getParameter("success");
            String errorMsg = request.getParameter("error");
            
            // Calculate statistics
            int totalAssigned = 0;
            int totalResolved = 0;
            int pendingReports = 0;
            
            // Filter parameters
            String filterStatus = request.getParameter("status");
            String filterPriority = request.getParameter("priority");
        %>
        
        <div class="container">
            <!-- Header -->
            <div class="header">
                <h1><i class="fas fa-tasks"></i> Assigned Tasks</h1>
                <p>Welcome <%= operatorName %>! Here are all the reports assigned to you for resolution.</p>
                <a href="operator-Dashboard.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
            
            <!-- Success/Error Messages -->
            <% if (successMsg != null && !successMsg.isEmpty()) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span><%= successMsg %></span>
            </div>
            <% } %>
            
            <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= errorMsg %></span>
            </div>
            <% } %>
            
            <!-- Statistics -->
            <div class="stats-container">
                <%
                    try {
                        // Load the driver
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        
                        // Make the connection object
                        Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/civic_pulse_hub", "root", "Ashu@@3450");
                        
                        // Get total assigned count
                        PreparedStatement ps1 = cn.prepareStatement(
                            "SELECT COUNT(*) as total FROM report_assignments WHERE operator_id = ? AND assignment_status = 'assigned'"
                        );
                        ps1.setInt(1, operatorId);
                        ResultSet rs1 = ps1.executeQuery();
                        if (rs1.next()) {
                            totalAssigned = rs1.getInt("total");
                        }
                        rs1.close();
                        ps1.close();
                        
                        // Get total resolved count
                        PreparedStatement ps2 = cn.prepareStatement(
                            "SELECT COUNT(*) as total FROM report_assignments WHERE operator_id = ? AND assignment_status = 'resolved'"
                        );
                        ps2.setInt(1, operatorId);
                        ResultSet rs2 = ps2.executeQuery();
                        if (rs2.next()) {
                            totalResolved = rs2.getInt("total");
                        }
                        rs2.close();
                        ps2.close();
                        
                        // Get pending reports count from reports table assigned to this operator
                        PreparedStatement ps3 = cn.prepareStatement(
                            "SELECT COUNT(DISTINCT r.Report_id) as total " +
                            "FROM reports r " +
                            "INNER JOIN report_assignments ra ON r.Report_id = ra.report_id " +
                            "WHERE ra.operator_id = ? AND r.Status = 'assigned'"
                        );
                        ps3.setInt(1, operatorId);
                        ResultSet rs3 = ps3.executeQuery();
                        if (rs3.next()) {
                            pendingReports = rs3.getInt("total");
                        }
                        rs3.close();
                        ps3.close();
                        
                        cn.close();
                        
                %>
                <div class="stat-card">
                    <div class="stat-number"><%= totalAssigned %></div>
                    <div class="stat-label">Currently Assigned</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= pendingReports %></div>
                    <div class="stat-label">Pending Reports</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= totalResolved %></div>
                    <div class="stat-label">Resolved Tasks</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= totalAssigned + totalResolved %></div>
                    <div class="stat-label">Total Tasks</div>
                </div>
                <%
                    } catch (Exception ex) {
                        out.println("<div class='alert alert-error'><i class='fas fa-exclamation-circle'></i> Error loading statistics: " + ex.toString() + "</div>");
                    }
                %>
            </div>
            
            <!-- Tasks Table -->
            <div class="table-container">
                <div class="filter-container">
                    <h2 style="color: var(--dark-color);"><i class="fas fa-list"></i> Assigned Reports</h2>
                    
                    <div class="filter-group">
                        <form method="GET" action="Fetch_Task.jsp" id="filterForm" style="display: flex; gap: 10px; align-items: center;">
                            <select name="status" class="filter-select" onchange="document.getElementById('filterForm').submit()">
                                <option value="">All Status</option>
                                <option value="assigned" <%= "assigned".equals(filterStatus) ? "selected" : "" %>>Assigned</option>
                                <option value="resolved" <%= "resolved".equals(filterStatus) ? "selected" : "" %>>Resolved</option>
                            </select>
                            
                            <select name="priority" class="filter-select" onchange="document.getElementById('filterForm').submit()">
                                <option value="">All Priority</option>
                                <option value="critical" <%= "critical".equals(filterPriority) ? "selected" : "" %>>Critical</option>
                                <option value="high" <%= "high".equals(filterPriority) ? "selected" : "" %>>High</option>
                                <option value="medium" <%= "medium".equals(filterPriority) ? "selected" : "" %>>Medium</option>
                                <option value="low" <%= "low".equals(filterPriority) ? "selected" : "" %>>Low</option>
                            </select>
                            
                            <button type="button" class="refresh-btn" onclick="window.location.href='Fetch_Task.jsp'">
                                <i class="fas fa-sync-alt"></i> Clear Filters
                            </button>
                        </form>
                    </div>
                </div>
                
                <%
                    try {
                        // Load the driver
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        
                        // Make the connection object
                        Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/civic_pulse_hub", "root", "Ashu@@3450");
                        
                        // Build the query based on filters
                        StringBuilder query = new StringBuilder();
                        query.append("SELECT ra.*, r.title, r.description, r.Category_id, r.Location, ");
                        query.append("r.Status as report_status, r.Priority, r.Created_at, ");
                        query.append("u.Name as user_name, u.Email as user_email, u.Mobile as user_phone ");
                        query.append("FROM report_assignments ra ");
                        query.append("INNER JOIN reports r ON ra.report_id = r.Report_id ");
                        query.append("INNER JOIN user u ON r.User_id = u.user_id ");
                        query.append("WHERE ra.operator_id = ? ");
                        
                        // Add status filter if provided
                        if (filterStatus != null && !filterStatus.isEmpty()) {
                            query.append("AND ra.assignment_status = ? ");
                        } else {
                            query.append("AND ra.assignment_status = 'assigned' ");
                        }
                        
                        // Add priority filter if provided
                        if (filterPriority != null && !filterPriority.isEmpty()) {
                            query.append("AND r.Priority = ? ");
                        }
                        
                        query.append("ORDER BY ra.assigned_at DESC");
                        
                        PreparedStatement ps = cn.prepareStatement(query.toString());
                        
                        int paramIndex = 1;
                        ps.setInt(paramIndex++, operatorId);
                        
                        if (filterStatus != null && !filterStatus.isEmpty()) {
                            ps.setString(paramIndex++, filterStatus);
                        }
                        
                        if (filterPriority != null && !filterPriority.isEmpty()) {
                            ps.setString(paramIndex++, filterPriority);
                        }
                        
                        // Execute the query
                        ResultSet rs = ps.executeQuery();
                        
                        if (!rs.isBeforeFirst()) {
                            // No tasks found
                %>
                <div class="empty-state">
                    <i class="fas fa-clipboard-check"></i>
                    <h3>No Tasks Assigned</h3>
                    <p>You don't have any reports assigned to you at the moment. Check back later for new assignments.</p>
                </div>
                <%
                        } else {
                %>
                <table border="1">
                    <tr>
                        <th>Assignment ID</th>
                        <th>Report ID</th>
                        <th>Title</th>
                        <th>User Details</th>
                        <th>Assigned Date</th>
                        <th>Report Status</th>
                        <th>Priority</th>
                        <th>Assignment Status</th>
                        <th>Actions</th>
                    </tr>
                <%
                            while (rs.next()) {
                                int assignmentId = rs.getInt("assignment_id");
                                int reportId = rs.getInt("report_id");
                                String title = rs.getString("title");
                                String description = rs.getString("description");
                                String userName = rs.getString("user_name");
                                String userEmail = rs.getString("user_email");
                                String userPhone = rs.getString("user_phone");
                                Date assignedDate = rs.getDate("assigned_at");
                                String reportStatus = rs.getString("report_status");
                                String priority = rs.getString("Priority");
                                String assignmentStatus = rs.getString("assignment_status");
                                
                                // Format status for display
                                String reportStatusText = reportStatus != null ? reportStatus.toUpperCase() : "PENDING";
                                String reportStatusClass = "";
                                
                                if (reportStatus != null) {
                                    switch(reportStatus.toLowerCase()) {
                                        case "pending":
                                            reportStatusClass = "status-pending";
                                            break;
                                        case "assigned":
                                            reportStatusClass = "status-assigned";
                                            break;
                                        case "resolved":
                                            reportStatusClass = "status-resolved";
                                            break;
                                        default:
                                            reportStatusClass = "status-pending";
                                    }
                                }
                                
                                // Format assignment status
                                String assignmentStatusText = assignmentStatus != null ? assignmentStatus.toUpperCase() : "ASSIGNED";
                                String assignmentStatusClass = assignmentStatus != null && assignmentStatus.equals("resolved") ? "status-resolved" : "status-assigned";
                                
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
                    <tr>
                        <td><strong><%= assignmentId %></strong></td>
                        <td><strong>CP-<%= reportId %></strong></td>
                        <td>
                            <div style="font-weight: 600; margin-bottom: 5px;"><%= title %></div>
                            <div style="font-size: 12px; color: var(--gray-color);">
                                <%= description != null && description.length() > 80 ? description.substring(0, 80) + "..." : description %>
                            </div>
                        </td>
                        <td>
                            <div style="font-weight: 600; margin-bottom: 3px;"><%= userName %></div>
                            <div style="font-size: 12px; color: var(--gray-color); margin-bottom: 2px;">
                                <i class="fas fa-envelope"></i> <%= userEmail %>
                            </div>
                            <% if (userPhone != null && !userPhone.isEmpty()) { %>
                            <div style="font-size: 12px; color: var(--gray-color);">
                                <i class="fas fa-phone"></i> <%= userPhone %>
                            </div>
                            <% } %>
                        </td>
                        <td><%= assignedDate %></td>
                        <td>
                            <span class="status-badge <%= reportStatusClass %>">
                                <%= reportStatusText %>
                            </span>
                        </td>
                        <td>
                            <span class="priority-badge <%= priorityClass %>">
                                <%= priorityText %>
                            </span>
                        </td>
                        <td>
                            <span class="status-badge <%= assignmentStatusClass %>">
                                <%= assignmentStatusText %>
                            </span>
                        </td>
                        <td>
                            <div class="action-btns">
                                <button type="button" class="action-btn btn-view" onclick="viewReportDetails(<%= reportId %>)">
                                    <i class="fas fa-eye"></i> View
                                </button>
                                
                                <% if (!"resolved".equalsIgnoreCase(assignmentStatus) && !"resolved".equalsIgnoreCase(reportStatus)) { %>
                                <button type="button" class="action-btn btn-resolve" onclick="showResolveModal(<%= assignmentId %>, <%= reportId %>)">
                                    <i class="fas fa-check-circle"></i> Mark Resolved
                                </button>
                                
                                <button type="button" class="action-btn btn-comment" onclick="showCommentModal(<%= assignmentId %>, <%= reportId %>)">
                                    <i class="fas fa-comment"></i> Add Comment
                                </button>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                <%
                            }
                %>
                </table>
                <%
                        }
                        
                        rs.close();
                        ps.close();
                        cn.close();
                        
                    } catch (Exception ex) {
                        out.println("<div class='alert alert-error'><i class='fas fa-exclamation-circle'></i> Error fetching tasks: " + ex.toString() + "</div>");
                    }
                %>
            </div>
        </div>
        
        <!-- Resolve Report Modal -->
        <div id="resolveModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><i class="fas fa-check-circle"></i> Mark Report as Resolved</h3>
                </div>
                <form id="resolveForm" method="POST" action="Mark_Resolved.jsp">
                    <div class="modal-body">
                        <input type="hidden" id="resolveAssignmentId" name="assignment_id">
                        <input type="hidden" id="resolveReportId" name="report_id">
                        
                        <div class="form-group">
                            <label class="form-label">Resolution Details *</label>
                            <textarea class="form-control" name="resolution_details" placeholder="Please provide details about how the issue was resolved..." rows="5" required></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Time Taken (Hours)</label>
                            <input type="number" class="form-control" name="time_taken" placeholder="e.g., 2.5" min="0" step="0.5">
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Additional Notes</label>
                            <textarea class="form-control" name="additional_notes" placeholder="Any additional notes or comments..." rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeModal('resolveModal')">
                            Cancel
                        </button>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-check"></i> Mark as Resolved
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Add Comment Modal -->
        <div id="commentModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><i class="fas fa-comment"></i> Add Comment/Update</h3>
                </div>
                <form id="commentForm" method="POST" action="Add_Comment.jsp">
                    <div class="modal-body">
                        <input type="hidden" id="commentAssignmentId" name="assignment_id">
                        <input type="hidden" id="commentReportId" name="report_id">
                        
                        <div class="form-group">
                            <label class="form-label">Comment Type</label>
                            <select class="form-control" name="comment_type">
                                <option value="update">Status Update</option>
                                <option value="question">Question for User</option>
                                <option value="information">Additional Information</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Comment *</label>
                            <textarea class="form-control" name="comment" placeholder="Enter your comment or update here..." rows="6" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeModal('commentModal')">
                            Cancel
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane"></i> Submit Comment
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Report Details Modal -->
        <div id="detailsModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><i class="fas fa-file-alt"></i> Report Details</h3>
                </div>
                <div class="modal-body">
                    <div id="reportDetailsContent">
                        <!-- Content will be loaded via AJAX -->
                        <div style="text-align: center; padding: 40px;">
                            <i class="fas fa-spinner fa-spin fa-2x"></i>
                            <p style="margin-top: 20px;">Loading report details...</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('detailsModal')">
                        Close
                    </button>
                </div>
            </div>
        </div>
        
        <script>
            // Modal functions
            function showModal(modalId) {
                document.getElementById(modalId).style.display = 'flex';
                document.body.style.overflow = 'hidden';
            }
            
            function closeModal(modalId) {
                document.getElementById(modalId).style.display = 'none';
                document.body.style.overflow = 'auto';
            }
            
            // Show resolve modal
            function showResolveModal(assignmentId, reportId) {
                document.getElementById('resolveAssignmentId').value = assignmentId;
                document.getElementById('resolveReportId').value = reportId;
                showModal('resolveModal');
            }
            
            // Show comment modal
            function showCommentModal(assignmentId, reportId) {
                document.getElementById('commentAssignmentId').value = assignmentId;
                document.getElementById('commentReportId').value = reportId;
                showModal('commentModal');
            }
            
            // View report details via AJAX
            function viewReportDetails(reportId) {
                showModal('detailsModal');
                
                // Create AJAX request
                const xhr = new XMLHttpRequest();
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            document.getElementById('reportDetailsContent').innerHTML = xhr.responseText;
                        } else {
                            document.getElementById('reportDetailsContent').innerHTML = 
                                '<div style="text-align: center; padding: 40px; color: var(--accent-color);">' +
                                '<i class="fas fa-exclamation-triangle fa-2x"></i>' +
                                '<p style="margin-top: 20px;">Error loading report details. Please try again.</p>' +
                                '</div>';
                        }
                    }
                };
                
                xhr.open('GET', 'Get_Report_Details.jsp?report_id=' + reportId, true);
                xhr.send();
            }
            
            // Close modal when clicking outside
            window.onclick = function(event) {
                const modals = document.querySelectorAll('.modal');
                modals.forEach(modal => {
                    if (event.target === modal) {
                        modal.style.display = 'none';
                        document.body.style.overflow = 'auto';
                    }
                });
            };
            
            // Auto-hide alerts after 5 seconds
            document.addEventListener('DOMContentLoaded', function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    setTimeout(() => {
                        alert.style.opacity = '0';
                        alert.style.transition = 'opacity 0.5s ease';
                        setTimeout(() => {
                            if (alert.parentNode) {
                                alert.parentNode.removeChild(alert);
                            }
                        }, 500);
                    }, 5000);
                });
            });
            
            // Refresh page every 30 seconds to check for new assignments
            setInterval(() => {
                const refreshBtn = document.querySelector('.refresh-btn');
                if (refreshBtn) {
                    // Just reload the page
                    window.location.reload();
                }
            }, 30000);
        </script>
    </body>
</html>