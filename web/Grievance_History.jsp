<%-- 
    Document   : Grievance_History
    Created on : 12-Jul-2025, 6:22:36 pm
    Author     : administration
--%>

<%@page import="java.sql.*" %>
<%@page import="jakarta.servlet.http.HttpSession" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Civic Pulse - Grievance History</title>
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
                min-width: 1000px;
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

            .action-btns {
                display: flex;
                gap: 10px;
            }

            .action-btn {
                padding: 8px 16px;
                background-color: #f8fafc;
                color: var(--dark-color);
                border: 1px solid #e2e8f0;
                border-radius: 6px;
                text-decoration: none;
                font-size: 13px;
                font-weight: 600;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }

            .action-btn:hover {
                background-color: var(--primary-light);
                color: white;
                border-color: var(--primary-light);
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

            .new-grievance-btn {
                display: inline-block;
                padding: 12px 24px;
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
                color: white;
                text-decoration: none;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .new-grievance-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 18px rgba(42, 92, 130, 0.3);
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
                
                .action-btns {
                    flex-direction: column;
                }
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
            
            // Calculate statistics
            int total = 0, pending = 0, assigned = 0, resolved = 0;
        %>
        
        <div class="container">
            <!-- Header -->
            <div class="header">
                <h1><i class="fas fa-history"></i> Grievance History</h1>
                <p>Welcome <%= userName %>! View all your submitted grievances below.</p>
                <a href="User_Dashboard.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
            
            <!-- Statistics -->
            <div class="stats-container">
                <%
                    try {
                        // Load the driver
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        
                        // Make the connection object
                        Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/civic_pulse_hub", "root", "Ashu@@3450");
                        
                        // Get total count
                        PreparedStatement ps1 = cn.prepareStatement("SELECT COUNT(*) as total FROM reports WHERE User_id = ?");
                        ps1.setInt(1, userId);
                        ResultSet rs1 = ps1.executeQuery();
                        if (rs1.next()) {
                            total = rs1.getInt("total");
                        }
                        rs1.close();
                        ps1.close();
                        
                        // Get status counts
                        String[] statuses = {"pending", "assigned", "resolved"};
                        int[] counts = new int[3];
                        
                        for (int i = 0; i < statuses.length; i++) {
                            PreparedStatement ps2 = cn.prepareStatement("SELECT COUNT(*) as count FROM reports WHERE User_id = ? AND Status = ?");
                            ps2.setInt(1, userId);
                            ps2.setString(2, statuses[i]);
                            ResultSet rs2 = ps2.executeQuery();
                            if (rs2.next()) {
                                counts[i] = rs2.getInt("count");
                            }
                            rs2.close();
                            ps2.close();
                        }
                        
                        pending = counts[0];
                        assigned = counts[1];
                        resolved = counts[2];
                        
                        cn.close();
                        
                %>
                <div class="stat-card">
                    <div class="stat-number"><%= total %></div>
                    <div class="stat-label">Total Grievances</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= pending %></div>
                    <div class="stat-label">Pending</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= assigned %></div>
                    <div class="stat-label">In Progress</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= resolved %></div>
                    <div class="stat-label">Resolved</div>
                </div>
                <%
                    } catch (Exception ex) {
                        out.println("<div style='color: red; padding: 20px; background: white; border-radius: 8px; margin-bottom: 20px;'>Error: " + ex.toString() + "</div>");
                    }
                %>
            </div>
            
            <!-- Grievances Table -->
            <div class="table-container">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
                    <h2 style="color: var(--dark-color);"><i class="fas fa-list"></i> All Grievances</h2>
                    <a href="Submit_Grievance.html" class="new-grievance-btn">
                        <i class="fas fa-plus"></i> Submit New Grievance
                    </a>
                </div>
                
                <%
                    try {
                        // Load the driver
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        
                        // Make the connection object
                        Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/civic_pulse_hub", "root", "Ashu@@3450");
                        
                        // Make preparedstatement object
                        PreparedStatement ps = cn.prepareStatement("SELECT * FROM reports WHERE User_id = ? ORDER BY Created_at DESC");
                        ps.setInt(1, userId);
                        
                        // Execute the query
                        ResultSet rs = ps.executeQuery();
                        
                        if (!rs.isBeforeFirst()) {
                            // No grievances found
                %>
                <div class="empty-state">
                    <i class="fas fa-clipboard-list"></i>
                    <h3>No grievances found</h3>
                    <p>You haven't submitted any grievances yet. Submit your first grievance to get started!</p>
                    <a href="Submit_Grievance.html" class="new-grievance-btn">
                        <i class="fas fa-plus"></i> Submit Your First Grievance
                    </a>
                </div>
                <%
                        } else {
                %>
                <table border="1">
                    <tr>
                        <th>Grievance ID</th>
                        <th>Title</th>
                        <th>Description</th>
                        <th>Submitted Date</th>
                        <th>Status</th>
                        <th>Priority</th>
                        <th>Actions</th>
                    </tr>
                <%
                            while (rs.next()) {
                                int reportId = rs.getInt("Report_id");
                                String title = rs.getString("title");
                                String desc = rs.getString("description");
                                String status = rs.getString("Status");
                                String priority = rs.getString("Priority");
                                Date createdDate = rs.getDate("Created_at");
                                
                                // Format status for display
                                String statusText = status != null ? status.toUpperCase() : "PENDING";
                                String statusClass = "";
                                
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
                                
                                // Format priority for display
                                String priorityText = priority != null ? priority.toUpperCase() : "MEDIUM";
                %>
                    <tr>
                        <td><strong>CP-<%= reportId %></strong></td>
                        <td><%= title %></td>
                        <td><%= desc != null && desc.length() > 100 ? desc.substring(0, 100) + "..." : desc %></td>
                        <td><%= createdDate %></td>
                        <td>
                            <span class="status-badge <%= statusClass %>">
                                <%= statusText %>
                            </span>
                        </td>
                        <td>
                            <span style="font-weight: 600; color: 
                                <%= "high".equalsIgnoreCase(priority) || "critical".equalsIgnoreCase(priority) ? "#e76f51" : 
                                   "medium".equalsIgnoreCase(priority) ? "#e9c46a" : "#4a9c7d" %>">
                                <%= priorityText %>
                            </span>
                        </td>
                        <td>
                            <div class="action-btns">
                                <a href="Grievance_Details.jsp?id=<%= reportId %>" class="action-btn">
                                    <i class="fas fa-eye"></i> View
                                </a>
                                <% if ("resolved".equalsIgnoreCase(status)) { %>
                                <a href="user_feedback.jsp?id=<%= reportId %>" class="action-btn">
                                    <i class="fas fa-star"></i> Feedback
                                </a>
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
                        out.println("<div style='color: red; padding: 20px; background: white; border-radius: 8px;'>Error fetching grievances: " + ex.toString() + "</div>");
                    }
                %>
            </div>
        </div>
        
        <script>
            // Simple JavaScript for interactivity
            document.addEventListener('DOMContentLoaded', function() {
                // Add click effect to table rows
                const tableRows = document.querySelectorAll('tbody tr');
                tableRows.forEach(row => {
                    row.addEventListener('click', function(e) {
                        if (!e.target.closest('.action-btn')) {
                            const id = this.querySelector('td:first-child strong').textContent.replace('CP-', '');
                            window.location.href = 'Grievance_Details.jsp?id=' + id;
                        }
                    });
                });
                
                // Update statistics display
                const totalElement = document.querySelector('.stat-card:first-child .stat-number');
                if (totalElement) {
                    const total = parseInt(totalElement.textContent);
                    const summaryElement = document.querySelector('.header p');
                    if (summaryElement) {
                        summaryElement.textContent = `Welcome <%= userName %>! You have submitted ${total} grievances.`;
                    }
                }
            });
        </script>
    </body>
</html>