<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/Civic_Pulse_Hub";
    String username = "root";
    String password = "Ashu@@3450";
    
    // Department mapping
    Map<String, Integer> departmentMap = new HashMap<>();
    departmentMap.put("Transportation", 1);
    departmentMap.put("Water department", 2);
    departmentMap.put("Waste Management", 3);
    departmentMap.put("Electricity", 4);
    
    Connection conn = null;
    List<Map<String, String>> reports = new ArrayList<>();
    List<Map<String, String>> allOperators = new ArrayList<>();
    
    // Get admin info from session
    HttpSession sessionObj = request.getSession(false);
    String adminName = "Admin";
    int adminId = 1; // Default admin ID
    if (sessionObj != null) {
        if (sessionObj.getAttribute("full_name") != null) {
            adminName = (String) sessionObj.getAttribute("full_name");
        }
        if (sessionObj.getAttribute("admin_id") != null) {
            adminId = (Integer) sessionObj.getAttribute("admin_id");
        }
    }
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);
        
        // Fetch all reports with department info
        String reportsQuery = "SELECT r.*, " +
                              "CASE r.Category_id " +
                              "  WHEN 1 THEN 'Transportation' " +
                              "  WHEN 2 THEN 'Water department' " +
                              "  WHEN 3 THEN 'Waste Management' " +
                              "  WHEN 4 THEN 'Electricity' " +
                              "  ELSE 'Other' " +
                              "END as department_name " +
                              "FROM reports r " +
                              "WHERE r.Status = ? " +
                              "ORDER BY r.Created_at DESC";
        PreparedStatement reportsStmt = conn.prepareStatement(reportsQuery);
        reportsStmt.setString(1, "pending");
        ResultSet rs = reportsStmt.executeQuery();
        
        while (rs.next()) {
            Map<String, String> report = new HashMap<>();
            report.put("report_id", rs.getString("Report_id"));
            report.put("user_id", rs.getString("User_id"));
            report.put("category_id", rs.getString("Category_id"));
            report.put("title", rs.getString("title"));
            report.put("description", rs.getString("description"));
            report.put("location", rs.getString("Location"));
            report.put("status", rs.getString("Status"));
            report.put("priority", rs.getString("Priority"));
            report.put("created_at", rs.getString("Created_at"));
            report.put("department_name", rs.getString("department_name"));
            reports.add(report);
            
        }
       


        rs.close();
        reportsStmt.close();
        
        // Fetch all operators
        String operatorsQuery = "SELECT operator_id, full_name, email, phone, department FROM operator ORDER BY department, full_name";
        PreparedStatement operatorsStmt = conn.prepareStatement(operatorsQuery);
        ResultSet operatorsRs = operatorsStmt.executeQuery();
        
        while (operatorsRs.next()) {
            Map<String, String> operator = new HashMap<>();
            operator.put("id", operatorsRs.getString("operator_id"));
            operator.put("name", operatorsRs.getString("full_name"));
            operator.put("email", operatorsRs.getString("email"));
            operator.put("phone", operatorsRs.getString("phone"));
            operator.put("department", operatorsRs.getString("department"));
            allOperators.add(operator);
        }
         

        
        
        
        
        operatorsRs.close();
        operatorsStmt.close();
        
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div style='color: red; padding: 20px;'>Database Error: " + e.getMessage() + "</div>");
    } finally {
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    
    // Count pending reports
    int pendingCount = 0;
    for (Map<String, String> report : reports) {
        if ("pending".equals(report.get("status"))) {
            pendingCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Management - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', system-ui, sans-serif;
        }

        :root {
            --primary: #2a5bd7;
            --primary-dark: #1e3f9c;
            --secondary: #00a86b;
            --accent: #ff6b35;
            --danger: #e74c3c;
            --warning: #f39c12;
            --light: #f8f9fa;
            --dark: #202124;
            --gray: #5f6368;
            --light-gray: #e8eaed;
            --sidebar-bg: #1a1d29;
            --sidebar-width: 250px;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --transition: all 0.3s ease;
        }

        body {
            background-color: #f5f7fb;
            color: var(--dark);
            line-height: 1.6;
            overflow-x: hidden;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--sidebar-bg);
            color: white;
            position: fixed;
            height: 100vh;
            transition: var(--transition);
            z-index: 100;
        }

        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid #2a2e3e;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .sidebar-header h2 {
            font-size: 1.3rem;
            color: white;
        }

        .sidebar-header i {
            color: var(--secondary);
            font-size: 1.5rem;
        }

        .nav-menu {
            padding: 20px 0;
            height: calc(100vh - 180px);
            overflow-y: auto;
        }

        .nav-item {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            color: #b0b3c1;
            text-decoration: none;
            transition: var(--transition);
            border-left: 4px solid transparent;
        }

        .nav-item:hover, .nav-item.active {
            background-color: #252837;
            color: white;
            border-left-color: var(--primary);
        }

        .nav-item i {
            margin-right: 15px;
            width: 20px;
            text-align: center;
        }

        .nav-text {
            font-size: 0.95rem;
            font-weight: 500;
        }

        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 20px;
            transition: var(--transition);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            margin-bottom: 30px;
            border-bottom: 1px solid var(--light-gray);
        }

        .header h1 {
            font-size: 1.8rem;
            color: var(--dark);
        }

        .header h1 i {
            color: var(--primary);
            margin-right: 10px;
        }

        .header-stats {
            display: flex;
            gap: 20px;
        }

        .stat-badge {
            background-color: var(--primary);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .filters-container {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: var(--shadow);
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: center;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            min-width: 180px;
        }

        .filter-group label {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--dark);
            font-size: 0.9rem;
        }

        .filter-select {
            padding: 10px 15px;
            border: 1px solid var(--light-gray);
            border-radius: 6px;
            background-color: white;
            font-size: 0.9rem;
            color: var(--dark);
            cursor: pointer;
            transition: var(--transition);
        }

        .filter-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(42, 91, 215, 0.1);
        }

        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-size: 0.9rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: var(--secondary);
            color: white;
        }

        .btn-secondary:hover {
            background-color: #009158;
            transform: translateY(-2px);
        }

        .btn-danger {
            background-color: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
        }

        .btn-warning {
            background-color: var(--warning);
            color: white;
        }

        .btn-warning:hover {
            background-color: #e67e22;
            transform: translateY(-2px);
        }

        .btn-outline {
            background-color: transparent;
            color: var(--primary);
            border: 2px solid var(--primary);
        }

        .btn-outline:hover {
            background-color: rgba(42, 91, 215, 0.05);
        }

        .reports-table-container {
            background-color: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: var(--shadow);
            overflow-x: auto;
        }

        .reports-table {
            width: 100%;
            border-collapse: collapse;
        }

        .reports-table th {
            background-color: var(--light);
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: var(--dark);
            border-bottom: 2px solid var(--light-gray);
            font-size: 0.9rem;
        }

        .reports-table td {
            padding: 15px;
            border-bottom: 1px solid var(--light-gray);
            vertical-align: top;
        }

        .reports-table tr:hover {
            background-color: rgba(42, 91, 215, 0.02);
        }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-pending {
            background-color: rgba(243, 156, 18, 0.1);
            color: #e67e22;
        }

        .status-in_progress {
            background-color: rgba(42, 91, 215, 0.1);
            color: var(--primary);
        }

        .status-resolved {
            background-color: rgba(0, 168, 107, 0.1);
            color: var(--secondary);
        }

        .status-closed {
            background-color: rgba(108, 117, 125, 0.1);
            color: #6c757d;
        }

        .priority-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .priority-low {
            background-color: rgba(0, 168, 107, 0.1);
            color: var(--secondary);
        }

        .priority-medium {
            background-color: rgba(243, 156, 18, 0.1);
            color: #e67e22;
        }

        .priority-high {
            background-color: rgba(255, 107, 53, 0.1);
            color: var(--accent);
        }

        .priority-critical {
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--danger);
        }

        .report-title {
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 5px;
        }

        .report-description {
            color: var(--gray);
            font-size: 0.9rem;
            line-height: 1.4;
            max-width: 300px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .action-btn {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 0.8rem;
            border: none;
            cursor: pointer;
            transition: var(--transition);
        }

        .assign-btn {
            background-color: var(--primary);
            color: white;
        }

        .assign-btn:hover {
            background-color: var(--primary-dark);
        }

        .block-btn {
            background-color: var(--danger);
            color: white;
        }

        .block-btn:hover {
            background-color: #c0392b;
        }

        .view-btn {
            background-color: var(--secondary);
            color: white;
        }

        .view-btn:hover {
            background-color: #009158;
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
            border-radius: 10px;
            width: 90%;
            max-width: 800px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 25px;
            border-bottom: 1px solid var(--light-gray);
        }

        .modal-header h3 {
            font-size: 1.3rem;
            color: var(--dark);
        }

        .close-btn {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: var(--gray);
            cursor: pointer;
            transition: var(--transition);
        }

        .close-btn:hover {
            color: var(--danger);
        }

        .modal-body {
            padding: 25px;
        }

        .modal-footer {
            padding: 20px 25px;
            border-top: 1px solid var(--light-gray);
            display: flex;
            justify-content: flex-end;
            gap: 15px;
        }

        .operators-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .operator-card {
            background-color: var(--light);
            border-radius: 8px;
            padding: 15px;
            border: 2px solid transparent;
            transition: var(--transition);
            cursor: pointer;
        }

        .operator-card:hover {
            border-color: var(--primary);
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .operator-card.selected {
            border-color: var(--primary);
            background-color: rgba(42, 91, 215, 0.05);
        }

        .operator-name {
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 5px;
        }

        .operator-info {
            color: var(--gray);
            font-size: 0.9rem;
            margin-bottom: 3px;
        }

        .department-badge {
            display: inline-block;
            padding: 3px 10px;
            background-color: rgba(42, 91, 215, 0.1);
            color: var(--primary);
            border-radius: 15px;
            font-size: 0.8rem;
            margin-top: 8px;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: var(--gray);
        }

        .no-data i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: var(--light-gray);
        }

        @media (max-width: 992px) {
            .sidebar {
                width: 70px;
                overflow: hidden;
            }
            
            .sidebar:hover {
                width: var(--sidebar-width);
            }
            
            .nav-text {
                display: none;
            }
            
            .sidebar:hover .nav-text {
                display: inline-block;
            }
            
            .main-content {
                margin-left: 70px;
            }
            
            .sidebar:hover ~ .main-content {
                margin-left: var(--sidebar-width);
            }
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 15px;
            }
            
            .filters-container {
                flex-direction: column;
                align-items: stretch;
            }
            
            .filter-group {
                width: 100%;
            }
            
            .reports-table-container {
                padding: 15px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .modal-content {
                width: 95%;
                max-width: 95%;
            }
        }

        @media (max-width: 576px) {
            .operators-list {
                grid-template-columns: 1fr;
            }
            
            .header h1 {
                font-size: 1.5rem;
            }
            
            .header-stats {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-heartbeat"></i>
                <h2>Civic Pulse Hub</h2>
            </div>
            
            <div class="nav-menu">
                <a href="dashboard.jsp" class="nav-item">
                    <i class="fas fa-tachometer-alt"></i>
                    <span class="nav-text">Dashboard</span>
                </a>
                <a href="operators.html" class="nav-item">
                    <i class="fas fa-users"></i>
                    <span class="nav-text">Operators</span>
                </a>
                <a href="departments.jsp" class="nav-item">
                    <i class="fas fa-building"></i>
                    <span class="nav-text">Departments</span>
                </a>
                <a href="Report_management.jsp" class="nav-item active">
                    <i class="fas fa-file-alt"></i>
                    <span class="nav-text">Report Management</span>
                </a>
                <a href="Grievance_History.jsp" class="nav-item">
                    <i class="fas fa-chart-bar"></i>
                    <span class="nav-text">Analytics</span>
                </a>
                <a href="settings.jsp" class="nav-item">
                    <i class="fas fa-cog"></i>
                    <span class="nav-text">Settings</span>
                </a>
            </div>
        </div>
        
        <div class="main-content">
            <div class="header">
                <h1><i class="fas fa-file-alt"></i> Report Management</h1>
                <div class="header-stats">
                    <span class="stat-badge">Total Reports: <%= reports.size() %></span>
                    <span class="stat-badge" style="background-color: var(--secondary);">Pending: <%= pendingCount %></span>
                </div>
            </div>
            
            <div class="filters-container">
                <div class="filter-group">
                    <label for="statusFilter">Status</label>
                    <select id="statusFilter" class="filter-select">
                        <option value="all">All Statuses</option>
                        <option value="pending">Pending</option>
                        <option value="in_progress">In Progress</option>
                        <option value="resolved">Resolved</option>
                        <option value="closed">Closed</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="priorityFilter">Priority</label>
                    <select id="priorityFilter" class="filter-select">
                        <option value="all">All Priorities</option>
                        <option value="critical">Critical</option>
                        <option value="high">High</option>
                        <option value="medium">Medium</option>
                        <option value="low">Low</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="departmentFilter">Department</label>
                    <select id="departmentFilter" class="filter-select">
                        <option value="all">All Departments</option>
                        <option value="Roads & Transportation">Roads & Transportation</option>
                        <option value="Water department">Water Department</option>
                        <option value="Waste Management">Waste Management</option>
                        <option value="Electricity">Electricity</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="dateFilter">Date Range</label>
                    <select id="dateFilter" class="filter-select">
                        <option value="all">All Time</option>
                        <option value="today">Today</option>
                        <option value="week">This Week</option>
                        <option value="month">This Month</option>
                    </select>
                </div>
                
                <button class="btn btn-primary" id="applyFilters">
                    <i class="fas fa-filter"></i> Apply Filters
                </button>
                
                <button class="btn btn-outline" id="resetFilters">
                    <i class="fas fa-redo"></i> Reset
                </button>
            </div>
            
            <div class="reports-table-container">
                <% if (reports.isEmpty()) { %>
                    <div class="no-data">
                        <i class="fas fa-file-alt"></i>
                        <h3>No Reports Found</h3>
                        <p>There are currently no reports in the system.</p>
                    </div>
                <% } else { %>
                    <table class="reports-table">
                        <thead>
                            <tr>
                                <th>Report ID</th>
                                <th>Title & Description</th>
                                <th>Department</th>
                                <th>Status</th>
                                <th>Priority</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="reportsTableBody">
                            <% 
                            for (Map<String, String> report : reports) { 
                                String status = report.get("status");
                                String priority = report.get("priority");
                                String statusClass = "status-" + (status != null ? status : "pending");
                                String priorityClass = "priority-" + (priority != null ? priority : "medium");
                                String department = report.get("department_name");
                            %>
                            <tr data-report-id="<%= report.get("report_id") %>" 
                                data-department="<%= department != null ? department : "Unassigned" %>"
                                data-status="<%= status %>"
                                data-priority="<%= priority %>">
                                <td><strong><%= report.get("report_id") %></strong></td>
                                <td>
                                    <div class="report-title"><%= report.get("title") != null ? report.get("title") : "No Title" %></div>
                                    <div class="report-description"><%= report.get("description") != null ? report.get("description") : "No description provided" %></div>
                                </td>
                                <td>
                                    <%= department != null ? department : "Unassigned" %>
                                </td>
                                <td>
                                    <span class="status-badge <%= statusClass %>">
                                        <%= status != null ? status : "pending" %>
                                    </span>
                                </td>
                                <td>
                                    <span class="priority-badge <%= priorityClass %>">
                                        <%= priority != null ? priority : "medium" %>
                                    </span>
                                </td>
                                <td><%= report.get("created_at") %></td>
                                <td>
                                    <div class="action-buttons">
<!--                                        <a href="fetch_operator.jsp?Department=<%=report.get("title")%>&report_id=<%=report.get("report_id")%>" class="action-btn assign-btn">
                                           
                                        <i class="fas fa-user-plus"></i> Assign</a>-->
<%
    String title = report.get("title") != null ? 
                   java.net.URLEncoder.encode(report.get("title").toString(), "UTF-8") : "";
    String reportId = report.get("report_id") != null ? 
                      report.get("report_id").toString() : "";
%>

<a href="fetch_operator.jsp?Department=<%= title %>&report_id=<%= reportId %>" 
   class="action-btn assign-btn"><i class="fas fa-user-plus"></i> Assign</a>

                                        <button class="action-btn block-btn" 
                                                onclick="blockReport(<%= report.get("report_id") %>)">
                                            <i class="fas fa-ban"></i> Block
                                        </button>
                                        <button class="action-btn view-btn" 
                                                onclick="viewReportDetails(<%= report.get("report_id") %>)">
                                            <i class="fas fa-eye"></i> View
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </div>
    </div>
                <%


                    %>
    <!-- Assign Operator Modal -->
    <div class="modal" id="assignOperatorModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">Assign Operator to Report</h3>
                <button class="close-btn" id="closeAssignModal">&times;</button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="selectedReportId">
                <div id="selectedDepartment"></div>
                <div class="operators-list" id="operatorsList">
                    <!-- Operators will be populated here dynamically -->
                </div>
                <div id="noOperatorsMessage" style="display: none; text-align: center; padding: 40px; color: var(--gray);">
                    <i class="fas fa-users-slash" style="font-size: 3rem; margin-bottom: 15px;"></i>
                    <h3>No Operators Available</h3>
                    <p>There are no operators in this department. Please add operators first.</p>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-outline" id="cancelAssign">Cancel</button>
                <button class="btn btn-primary" id="confirmAssign" disabled>Assign Selected Operator</button>
            </div>
        </div>
    </div>
    
    <!-- Report Details Modal -->
    <div class="modal" id="reportDetailsModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Report Details</h3>
                <button class="close-btn" id="closeDetailsModal">&times;</button>
            </div>
            <div class="modal-body" id="reportDetailsContent">
                <!-- Report details will be populated here -->
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" id="closeDetailsBtn">Close</button>
            </div>
        </div>
    </div>

     <script>
    let currentPage = 1;
    const rowsPerPage = 10;
    let filteredReports = [];
    let selectedOperatorId = null;
    let currentOperators = []; // Store current operators for the modal
    
    // Store all operators from JSP - FIXED VERSION
    const allOperatorsData = [
        <% 
        for (int i = 0; i < allOperators.size(); i++) { 
            Map<String, String> operator = allOperators.get(i);
        %>
        {
            id: <%= operator.get("id") %>,
            name: '<%= operator.get("name").replace("'", "\\'") %>',
            email: '<%= operator.get("email").replace("'", "\\'") %>',
            phone: '<%= operator.get("phone") != null ? operator.get("phone").replace("'", "\\'") : "" %>',
            department: '<%= operator.get("department").replace("'", "\\'") %>'
        }<%= (i < allOperators.size() - 1) ? "," : "" %>
        <% } %>
    ];
    
    console.log('All operators data loaded:', allOperatorsData);
    
    // Initialize page
    document.addEventListener('DOMContentLoaded', function() {
        filteredReports = Array.from(document.querySelectorAll('#reportsTableBody tr'));
        updatePagination();
        setupEventListeners();
        console.log('Total operators loaded:', allOperatorsData.length);
        
        // Debug: Log all operators
        allOperatorsData.forEach(op => {
            console.log('Operator:', op.name, '- Department:', op.department);
        });
    });
    
    function setupEventListeners() {
        // Filter buttons
        document.getElementById('applyFilters').addEventListener('click', applyFilters);
        document.getElementById('resetFilters').addEventListener('click', resetFilters);
        
        // Modal close buttons
        document.getElementById('closeAssignModal').addEventListener('click', closeAssignModal);
        document.getElementById('cancelAssign').addEventListener('click', closeAssignModal);
        document.getElementById('closeDetailsModal').addEventListener('click', closeDetailsModal);
        document.getElementById('closeDetailsBtn').addEventListener('click', closeDetailsModal);
        
        // Confirm assignment
        document.getElementById('confirmAssign').addEventListener('click', assignOperatorToReport);
        
        // Close modals when clicking outside
        window.addEventListener('click', function(event) {
            const assignModal = document.getElementById('assignOperatorModal');
            const detailsModal = document.getElementById('reportDetailsModal');
            
            if (event.target === assignModal) {
                closeAssignModal();
            }
            if (event.target === detailsModal) {
                closeDetailsModal();
            }
        });
    }
    
    function showAssignOperatorModal(reportId, departmentName) {
        console.log('Opening modal for report', reportId, 'department:', departmentName);
        document.getElementById('selectedReportId').value = reportId;
        document.getElementById('modalTitle').textContent = `Assign Operator to Report #${reportId}`;
        
        // Escape department name for display
        const displayDepartment = departmentName.replace(/\\'/g, "'");
        document.getElementById('selectedDepartment').innerHTML = `
            <p><strong>Department:</strong> ${displayDepartment || 'Unassigned'}</p>
            <p>Select an operator from the list below:</p>
            <div style="margin: 10px 0; padding: 10px; background-color: #f0f8ff; border-radius: 5px;">
                <i class="fas fa-info-circle" style="color: var(--primary); margin-right: 5px;"></i>
                Showing operators from ${displayDepartment} department
            </div>
        `;
        
        // Get operators for this department
        const operatorsList = document.getElementById('operatorsList');
        operatorsList.innerHTML = '';
        
        // Filter operators by department
        const filteredOperators = allOperatorsData.filter(operator => 
            operator.department === departmentName
        );
        
        console.log('Filtered operators for', departmentName, ':', filteredOperators);
        
        currentOperators = filteredOperators;
        
        if (filteredOperators.length > 0) {
            document.getElementById('noOperatorsMessage').style.display = 'none';
            
            filteredOperators.forEach(operator => {
                const operatorCard = document.createElement('div');
                operatorCard.className = 'operator-card';
                operatorCard.dataset.operatorId = operator.id;
                operatorCard.innerHTML = `
                    <div class="operator-name">${operator.name}</div>
                    <div class="operator-info"><i class="fas fa-envelope"></i> ${operator.email}</div>
                    <div class="operator-info"><i class="fas fa-phone"></i> ${operator.phone || 'N/A'}</div>
                    <div class="department-badge">${operator.department}</div>
                `;
                operatorCard.addEventListener('click', function() {
                    selectOperator(operator.id, operatorCard);
                });
                operatorsList.appendChild(operatorCard);
            });
        } else {
            operatorsList.innerHTML = '';
            document.getElementById('noOperatorsMessage').style.display = 'block';
            document.getElementById('noOperatorsMessage').querySelector('p').textContent = 
                'There are no operators in the ' + displayDepartment + ' department. Please add operators first.';
        }
        
        // Reset selection
        selectedOperatorId = null;
        document.getElementById('confirmAssign').disabled = true;
        
        // Show modal
        document.getElementById('assignOperatorModal').style.display = 'flex';
    }
    
    function selectOperator(operatorId, operatorCard) {
        // Remove selection from all cards
        document.querySelectorAll('.operator-card').forEach(card => {
            card.classList.remove('selected');
        });
        
        // Add selection to clicked card
        operatorCard.classList.add('selected');
        selectedOperatorId = operatorId;
        document.getElementById('confirmAssign').disabled = false;
    }
    
    function assignOperatorToReport() {
        const reportId = document.getElementById('selectedReportId').value;
        
        if (!selectedOperatorId) {
            alert('Please select an operator first.');
            return;
        }
        
        // Get the selected operator
        const operator = currentOperators.find(op => op.id == selectedOperatorId);
        if (!operator) {
            alert('Operator not found. Please try again.');
            return;
        }
        
        // Get admin ID from JSP
        const adminId = <%= adminId %>;
        
        // Show loading on button
        const confirmBtn = document.getElementById('confirmAssign');
        const originalText = confirmBtn.innerHTML;
        confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Assigning...';
        confirmBtn.disabled = true;
        
        // Send to servlet
        const formData = new FormData();
        formData.append('reportId', reportId);
        formData.append('operatorId', selectedOperatorId);
        formData.append('adminId', adminId);
        
        fetch('AssignReportServlet', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert(`Operator "${operator.name}" assigned successfully to Report #${reportId}!`);
                
                // Update the UI
                const reportRow = document.querySelector(`tr[data-report-id="${reportId}"]`);
                if (reportRow) {
                    const statusCell = reportRow.querySelector('.status-badge');
                    if (statusCell) {
                        statusCell.textContent = 'in_progress';
                        statusCell.className = 'status-badge status-in_progress';
                    }
                    
                    // Update department cell to show assigned operator
                    reportRow.cells[2].innerHTML = `
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span>${operator.name}</span>
                            <span style="color: var(--secondary); font-size: 0.8rem; background: rgba(0, 168, 107, 0.1); padding: 2px 8px; border-radius: 10px;">
                                <i class="fas fa-check-circle"></i> Assigned
                            </span>
                        </div>
                    `;
                    
                    // Disable assign button
                    const assignBtn = reportRow.querySelector('.assign-btn');
                    if (assignBtn) {
                        assignBtn.disabled = true;
                        assignBtn.innerHTML = '<i class="fas fa-user-check"></i> Assigned';
                        assignBtn.style.backgroundColor = 'var(--secondary)';
                    }
                }
                
                closeAssignModal();
            } else {
                alert('Error: ' + data.message);
                confirmBtn.innerHTML = originalText;
                confirmBtn.disabled = false;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error assigning operator. Please try again.');
            confirmBtn.innerHTML = originalText;
            confirmBtn.disabled = false;
        });
    }
    
    function applyFilters() {
        const statusFilter = document.getElementById('statusFilter').value;
        const priorityFilter = document.getElementById('priorityFilter').value;
        const departmentFilter = document.getElementById('departmentFilter').value;
        
        filteredReports.forEach(row => {
            let showRow = true;
            
            // Apply status filter
            if (statusFilter !== 'all') {
                const rowStatus = row.getAttribute('data-status');
                if (rowStatus !== statusFilter) {
                    showRow = false;
                }
            }
            
            // Apply priority filter
            if (priorityFilter !== 'all') {
                const rowPriority = row.getAttribute('data-priority');
                if (rowPriority !== priorityFilter) {
                    showRow = false;
                }
            }
            
            // Apply department filter
            if (departmentFilter !== 'all') {
                const rowDepartment = row.getAttribute('data-department');
                if (rowDepartment !== departmentFilter) {
                    showRow = false;
                }
            }
            
            row.style.display = showRow ? '' : 'none';
        });
    }
    
    function resetFilters() {
        document.getElementById('statusFilter').value = 'all';
        document.getElementById('priorityFilter').value = 'all';
        document.getElementById('departmentFilter').value = 'all';
        document.getElementById('dateFilter').value = 'all';
        
        filteredReports.forEach(row => {
            row.style.display = '';
        });
    }
    
    function blockReport(reportId) {
        if (confirm(`Are you sure you want to block Report #${reportId}? This will prevent any further action on this report.`)) {
            // In a real application, send this to servlet
            console.log(`Blocking report ${reportId}`);
            
            // Update UI
            const reportRow = document.querySelector(`tr[data-report-id="${reportId}"]`);
            if (reportRow) {
                reportRow.style.opacity = '0.6';
                reportRow.style.backgroundColor = 'rgba(231, 76, 60, 0.05)';
                
                // Disable buttons
                const buttons = reportRow.querySelectorAll('.action-btn');
                buttons.forEach(btn => {
                    if (btn) {
                        btn.disabled = true;
                        btn.style.opacity = '0.5';
                        btn.style.cursor = 'not-allowed';
                    }
                });
                
                alert(`Report #${reportId} has been blocked.`);
            } else {
                alert('Could not find report #' + reportId);
            }
        }
    }
    
    function viewReportDetails(reportId) {
        // Find the report in the data
        const reportRow = document.querySelector(`tr[data-report-id="${reportId}"]`);
        if (!reportRow) {
            alert('Report not found');
            return;
        }
        
        const title = reportRow.querySelector('.report-title').textContent;
        const description = reportRow.querySelector('.report-description').textContent;
        const department = reportRow.getAttribute('data-department');
        const status = reportRow.getAttribute('data-status');
        const priority = reportRow.getAttribute('data-priority');
        const date = reportRow.cells[5].textContent;
        const location = reportRow.cells[2].textContent;
        
        document.getElementById('reportDetailsContent').innerHTML = `
            <div style="margin-bottom: 15px;">
                <strong>Report ID:</strong> #${reportId}
            </div>
            <div style="margin-bottom: 15px;">
                <strong>Title:</strong> ${title}
            </div>
            <div style="margin-bottom: 15px;">
                <strong>Description:</strong> 
                <p style="margin-top: 5px; padding: 10px; background-color: var(--light); border-radius: 5px;">${description}</p>
            </div>
            <div style="margin-bottom: 15px;">
                <strong>Department:</strong> ${department}
            </div>
            <div style="margin-bottom: 15px;">
                <strong>Status:</strong> 
                <span class="status-badge status-${status}">${status}</span>
            </div>
            <div style="margin-bottom: 15px;">
                <strong>Priority:</strong> 
                <span class="priority-badge priority-${priority}">${priority}</span>
            </div>
            <div style="margin-bottom: 15px;">
                <strong>Reported On:</strong> ${date}
            </div>
            <div style="margin-bottom: 15px;">
                <strong>Location:</strong> ${location}
            </div>
        `;
        
        document.getElementById('reportDetailsModal').style.display = 'flex';
    }
    
    function closeAssignModal() {
        const modal = document.getElementById('assignOperatorModal');
        if (modal) {
            modal.style.display = 'none';
        }
        selectedOperatorId = null;
        document.getElementById('confirmAssign').disabled = true;
    }
    
    function closeDetailsModal() {
        const modal = document.getElementById('reportDetailsModal');
        if (modal) {
            modal.style.display = 'none';
        }
    }
    
    function updatePagination() {
        // Simple pagination logic
        const visibleRows = filteredReports.filter(row => row.style.display !== 'none');
        // You can implement full pagination here if needed
    }
    
    // Add a test function to check if operators are loaded
    function testOperators() {
        console.log('Testing operators...');
        console.log('Total operators in allOperatorsData:', allOperatorsData.length);
        allOperatorsData.forEach((op, index) => {
            console.log(`Operator ${index + 1}:`, op.name, '- Dept:', op.department);
        });
        
        // Test filtering
        const testDept = 'Roads & Transportation';
        const filtered = allOperatorsData.filter(op => op.department === testDept);
        console.log(`Operators in ${testDept}:`, filtered.length);
    }
    
    // Call test function after page loads
    setTimeout(testOperators, 1000);
</script>
</body>
</html>