<%@ page isELIgnored="true" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Get admin name from session
    HttpSession gov_session = request.getSession(false);
    String adminName = "Admin User"; // default
    if (gov_session != null && gov_session.getAttribute("full_name") != null) {
        adminName = (String) gov_session.getAttribute("full_name");
    }
    
    // Get initials for avatar
    String initials = "AD";
    if (adminName != null && !adminName.trim().isEmpty()) {
        String[] nameParts = adminName.split(" ");
        if (nameParts.length >= 2) {
            initials = String.valueOf(nameParts[0].charAt(0)) + nameParts[1].charAt(0);
        } else if (nameParts.length == 1 && nameParts[0].length() >= 2) {
            initials = nameParts[0].substring(0, 2).toUpperCase();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            --header-height: 70px;
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

        .profile-section {
            position: absolute;
            bottom: 60px;
            width: 100%;
            padding: 20px;
            border-top: 1px solid #2a2e3e;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .profile-img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }

        .profile-info h4 {
            font-size: 0.9rem;
            color: white;
            margin-bottom: 3px;
        }

        .profile-info p {
            font-size: 0.8rem;
            color: #b0b3c1;
        }

        .logout-container {
            position: absolute;
            bottom: 0;
            width: 100%;
            padding: 15px 20px;
            border-top: 1px solid #2a2e3e;
        }

        .logout-btn {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            color: #e74c3c;
            text-decoration: none;
            transition: var(--transition);
            border-radius: 6px;
            background-color: rgba(231, 76, 60, 0.1);
            border: none;
            width: 100%;
            cursor: pointer;
            font-size: 1rem;
        }

        .logout-btn:hover {
            background-color: rgba(231, 76, 60, 0.2);
            color: #ff8a80;
        }

        .logout-btn i {
            margin-right: 12px;
            font-size: 1rem;
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

        .header-actions {
            display: flex;
            gap: 15px;
            align-items: center;
            position: relative;
        }

        .notification-btn {
            position: relative;
            background: none;
            border: none;
            font-size: 1.2rem;
            color: var(--gray);
            cursor: pointer;
        }

        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background-color: var(--danger);
            color: white;
            font-size: 0.7rem;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .profile-dropdown-container {
            position: relative;
        }

        .profile-dropdown-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 15px;
            background-color: white;
            border: 1px solid var(--light-gray);
            border-radius: 8px;
            cursor: pointer;
            transition: var(--transition);
        }

        .profile-dropdown-btn:hover {
            background-color: var(--light);
            border-color: var(--primary);
        }

        .profile-avatar-small {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background-color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 0.9rem;
        }

        .profile-info-small h4 {
            font-size: 0.9rem;
            color: var(--dark);
            margin-bottom: 2px;
        }

        .profile-info-small p {
            font-size: 0.75rem;
            color: var(--gray);
        }

        .dropdown-arrow {
            color: var(--gray);
            transition: var(--transition);
        }

        .profile-dropdown-btn.active .dropdown-arrow {
            transform: rotate(180deg);
        }

        .profile-dropdown-menu {
            position: absolute;
            top: calc(100% + 10px);
            right: 0;
            width: 300px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            z-index: 1000;
            display: none;
            overflow: hidden;
        }

        .profile-dropdown-menu.show {
            display: block;
            animation: fadeIn 0.2s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .dropdown-header {
            padding: 25px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .dropdown-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background-color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 15px;
            border: 4px solid rgba(255, 255, 255, 0.3);
        }

        .dropdown-header h3 {
            font-size: 1.3rem;
            margin-bottom: 5px;
        }

        .dropdown-header p {
            font-size: 0.85rem;
            opacity: 0.9;
        }

        .dropdown-body {
            padding: 20px;
        }

        .dropdown-info-item {
            display: flex;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid var(--light-gray);
        }

        .dropdown-info-item:last-child {
            border-bottom: none;
        }

        .dropdown-info-item i {
            width: 30px;
            color: var(--primary);
            font-size: 1.1rem;
        }

        .dropdown-info-item span {
            font-size: 0.9rem;
            color: var(--gray);
        }

        .dropdown-info-item strong {
            color: var(--dark);
            font-weight: 600;
        }

        .dropdown-actions {
            padding: 15px 20px;
            border-top: 1px solid var(--light-gray);
            display: flex;
            gap: 10px;
        }

        .dropdown-actions .btn {
            flex: 1;
            padding: 10px 15px;
            font-size: 0.85rem;
        }

        .btn-edit {
            background-color: var(--primary);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-edit:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background-color: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: var(--transition);
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        .stat-info h3 {
            font-size: 2rem;
            color: var(--dark);
            margin-bottom: 5px;
        }

        .stat-info p {
            color: var(--gray);
            font-size: 0.9rem;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }

        .stat-1 .stat-icon {
            background-color: var(--primary);
        }

        .stat-2 .stat-icon {
            background-color: var(--secondary);
        }

        .stat-3 .stat-icon {
            background-color: var(--accent);
        }

        .stat-4 .stat-icon {
            background-color: #8e44ad;
        }

        .features-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .feature-card {
            background-color: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: var(--shadow);
            transition: var(--transition);
            cursor: pointer;
            text-decoration: none;
            display: block;
            color: inherit;
        }

        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }

        .feature-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .feature-icon {
            width: 70px;
            height: 70px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: white;
            margin-right: 20px;
        }

        .feature-1 .feature-icon {
            background-color: var(--primary);
        }

        .feature-2 .feature-icon {
            background-color: var(--secondary);
        }

        .feature-3 .feature-icon {
            background-color: var(--accent);
        }

        .feature-4 .feature-icon {
            background-color: #8e44ad;
        }

        .feature-5 .feature-icon {
            background-color: #3498db;
        }

        .feature-6 .feature-icon {
            background-color: #1abc9c;
        }

        .feature-header h3 {
            font-size: 1.3rem;
            color: var(--dark);
        }

        .feature-card p {
            color: var(--gray);
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .feature-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .feature-stats {
            font-size: 0.9rem;
            color: var(--gray);
        }

        .feature-arrow {
            color: var(--primary);
            font-size: 1.2rem;
        }

        .charts-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .chart-container {
            background-color: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: var(--shadow);
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .chart-header h3 {
            font-size: 1.2rem;
            color: var(--dark);
        }

        .chart-wrapper {
            width: 100%;
            height: 300px;
            position: relative;
        }

        .quick-actions {
            background-color: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }

        .quick-actions h3 {
            font-size: 1.2rem;
            color: var(--dark);
            margin-bottom: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-size: 1rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
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

        .btn-success {
            background-color: var(--secondary);
            color: white;
        }

        .btn-success:hover {
            background-color: #009158;
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

        .recent-activity {
            background-color: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: var(--shadow);
        }

        .recent-activity h3 {
            font-size: 1.2rem;
            color: var(--dark);
            margin-bottom: 20px;
        }

        .activity-list {
            list-style: none;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            padding: 15px 0;
            border-bottom: 1px solid var(--light-gray);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: white;
            flex-shrink: 0;
        }

        .activity-add {
            background-color: var(--secondary);
        }

        .activity-update {
            background-color: var(--primary);
        }

        .activity-delete {
            background-color: var(--danger);
        }

        .activity-assign {
            background-color: var(--accent);
        }

        .activity-content h4 {
            font-size: 1rem;
            margin-bottom: 5px;
            color: var(--dark);
        }

        .activity-content p {
            color: var(--gray);
            font-size: 0.9rem;
        }

        .activity-time {
            font-size: 0.8rem;
            color: var(--gray);
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
            max-width: 600px;
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

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark);
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--light-gray);
            border-radius: 6px;
            font-size: 1rem;
            transition: var(--transition);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(42, 91, 215, 0.1);
        }

        .form-row {
            display: flex;
            gap: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        .modal-footer {
            padding: 20px 25px;
            border-top: 1px solid var(--light-gray);
            display: flex;
            justify-content: flex-end;
            gap: 15px;
        }

        .profile-modal .modal-content {
            max-width: 500px;
        }

        .profile-header {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 25px;
            text-align: center;
        }

        .profile-avatar-large {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2.5rem;
            margin-bottom: 15px;
            border: 4px solid rgba(42, 91, 215, 0.2);
        }

        .profile-header h3 {
            font-size: 1.5rem;
            margin-bottom: 5px;
        }

        .profile-header p {
            color: var(--gray);
        }

        @media (max-width: 1200px) {
            .charts-section {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 992px) {
            .sidebar {
                width: 70px;
                overflow: hidden;
            }
            
            .sidebar:hover {
                width: var(--sidebar-width);
            }
            
            .nav-text, .profile-info, .sidebar-header h2, .logout-btn span {
                display: none;
            }
            
            .sidebar:hover .nav-text,
            .sidebar:hover .profile-info,
            .sidebar:hover .sidebar-header h2,
            .sidebar:hover .logout-btn span {
                display: inline-block;
            }
            
            .main-content {
                margin-left: 70px;
            }
            
            .sidebar:hover ~ .main-content {
                margin-left: var(--sidebar-width);
            }
            
            .profile-dropdown-menu {
                right: -50px;
                width: 280px;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 15px;
            }
            
            .charts-section {
                grid-template-columns: 1fr;
            }
            
            .chart-container, .quick-actions, .recent-activity {
                padding: 20px;
            }
            
            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .features-container {
                grid-template-columns: 1fr;
            }
            
            .header h1 {
                font-size: 1.5rem;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
            
            .profile-dropdown-menu {
                position: fixed;
                top: 80px;
                right: 15px;
                left: 15px;
                width: auto;
            }
            
            .profile-info-small {
                display: none;
            }
        }

        @media (max-width: 576px) {
            .stats-container {
                grid-template-columns: 1fr;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .header-actions {
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-heartbeat"></i>
                <h2>Civic Pulse Hub</h2>
            </div>
            
            <div class="nav-menu">
    <a href="#" class="nav-item active">
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
    <!-- ADD THIS NEW LINK FOR REPORT MANAGEMENT -->
    <a href="Report_management.jsp" class="nav-item">
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
            <div class="profile-section">
                <div class="profile-img"><%= initials %></div>
                <div class="profile-info">
                    <h4><%= adminName %></h4>
                    <p>Super Administrator</p>
                </div>
            </div>
            
            <div class="logout-container">
                <form id="sidebarLogoutForm" action="LogoutServlet" method="POST">
                    <button type="submit" class="logout-btn">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
                    </button>
                </form>
            </div>
        </div>
        
        <div class="main-content">
            <div class="header">
                <h1>Admin Dashboard</h1>
                <div class="header-actions">
                    <button class="notification-btn">
                        <i class="fas fa-bell"></i>
                        <span class="notification-badge">3</span>
                    </button>
                    
                    <div class="profile-dropdown-container">
                        <div class="profile-dropdown-btn" id="profileDropdownBtn">
                            <div class="profile-avatar-small"><%= initials %></div>
                            <div class="profile-info-small">
                                <h4><%= adminName %></h4>
                                <p>Super Admin</p>
                            </div>
                            <i class="fas fa-chevron-down dropdown-arrow"></i>
                        </div>
                        
                        <!-- Profile Dropdown Menu -->
                        <div class="profile-dropdown-menu" id="profileDropdownMenu">
                            <div class="dropdown-header">
                                <div class="dropdown-avatar"><%= initials %></div>
                                <h3><%= adminName %></h3>
                                <p>Super Administrator</p>
                                <p style="margin-top: 5px; font-size: 0.8rem; background: rgba(255,255,255,0.2); padding: 3px 10px; border-radius: 20px;">System Administration</p>
                            </div>
                            
                            <div class="dropdown-body">
                                <div class="dropdown-info-item">
                                    <i class="fas fa-envelope"></i>
                                    <span><strong>Email:</strong> admin@civicpulsehub.gov</span>
                                </div>
                                <div class="dropdown-info-item">
                                    <i class="fas fa-phone"></i>
                                    <span><strong>Phone:</strong> +1 (555) 123-4567</span>
                                </div>
                                <div class="dropdown-info-item">
                                    <i class="fas fa-calendar-alt"></i>
                                    <span><strong>Member Since:</strong> January 15, 2023</span>
                                </div>
                                <div class="dropdown-info-item">
                                    <i class="fas fa-user-shield"></i>
                                    <span><strong>Role:</strong> Full System Access</span>
                                </div>
                                <div class="dropdown-info-item">
                                    <i class="fas fa-clock"></i>
                                    <span><strong>Last Login:</strong> Today, 09:42 AM</span>
                                </div>
                            </div>
                            
                            <div class="dropdown-actions">
                                <button class="btn btn-edit" id="editProfileBtn">
                                    <i class="fas fa-edit"></i> Edit Profile
                                </button>
                                <form id="dropdownLogoutForm" action="LogoutServlet" method="POST" style="flex: 1;">
                                    <button type="submit" class="btn btn-outline">
                                        <i class="fas fa-sign-out-alt"></i> Logout
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="stats-container">
                <a href="operators.jsp" class="stat-card stat-1">
                    <div class="stat-info">
                        <h3 id="operatorsCount">42</h3>
                        <p>Total Operators</p>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                </a>
                
                <a href="departments.jsp" class="stat-card stat-2">
                    <div class="stat-info">
                        <h3 id="departmentsCount">8</h3>
                        <p>Departments</p>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-building"></i>
                    </div>
                </a>
                
                <a href="analytics.jsp" class="stat-card stat-3">
                    <div class="stat-info">
                        <h3 id="issuesResolved">1258</h3>
                        <p>Issues Resolved</p>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </a>
                
                <a href="analytics.jsp" class="stat-card stat-4">
                    <div class="stat-info">
                        <h3 id="pendingIssues">87</h3>
                        <p>Pending Issues</p>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                </a>
            </div>
            
            <div class="features-container">
                <a href="operators.jsp" class="feature-card feature-1">
                    <div class="feature-header">
                        <div class="feature-icon">
                            <i class="fas fa-users-cog"></i>
                        </div>
                        <h3>Operator Management</h3>
                    </div>
                    <p>Manage all operators, assign departments, track performance, and monitor complaint resolution rates across different departments.</p>
                    <div class="feature-footer">
                        <div class="feature-stats">
                            <span id="activeOperators">36</span> active operators
                        </div>
                        <div class="feature-arrow">
                            <i class="fas fa-arrow-right"></i>
                        </div>
                    </div>
                </a>
                
                <a href="departments.jsp" class="feature-card feature-2">
                    <div class="feature-header">
                        <div class="feature-icon">
                            <i class="fas fa-sitemap"></i>
                        </div>
                        <h3>Department Management</h3>
                    </div>
                    <p>Organize departments, assign resources, set department-specific workflows, and monitor inter-department coordination.</p>
                    <div class="feature-footer">
                        <div class="feature-stats">
                            <span id="totalDepartments">8</span> departments
                        </div>
                        <div class="feature-arrow">
                            <i class="fas fa-arrow-right"></i>
                        </div>
                    </div>
                </a>
                
                <a href="Grievance_History.jsp" class="feature-card feature-3">
                    <div class="feature-header">
                        <div class="feature-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h3>Analytics & Reports</h3>
                    </div>
                    <p>Generate detailed reports, analyze performance metrics, track resolution times, and identify bottlenecks in the complaint resolution process.</p>
                    <div class="feature-footer">
                        <div class="feature-stats">
                            <span id="reportsGenerated">24</span> reports this month
                        </div>
                        <div class="feature-arrow">
                            <i class="fas fa-arrow-right"></i>
                        </div>
                    </div>
                </a>
                
                <a href="analytics.jsp" class="feature-card feature-4">
                    <div class="feature-header">
                        <div class="feature-icon">
                            <i class="fas fa-tasks"></i>
                        </div>
                        <h3>Task Management</h3>
                    </div>
                    <p>Assign and monitor tasks, track completion status, and ensure timely resolution of issues across all departments.</p>
                    <div class="feature-footer">
                        <div class="feature-stats">
                            <span id="activeTasks">156</span> active tasks
                        </div>
                        <div class="feature-arrow">
                            <i class="fas fa-arrow-right"></i>
                        </div>
                    </div>
                </a>
            </div>
            
            <div class="charts-section">
                <div class="chart-container">
                    <div class="chart-header">
                        <h3>Department Performance</h3>
                        <select id="performanceFilter" class="form-control" style="width: auto;">
                            <option value="monthly">This Month</option>
                            <option value="quarterly">This Quarter</option>
                            <option value="yearly">This Year</option>
                        </select>
                    </div>
                    <div class="chart-wrapper">
                        <canvas id="performanceChart"></canvas>
                    </div>
                </div>
                
                <div class="chart-container">
                    <div class="chart-header">
                        <h3>Complaint Resolution Time</h3>
                    </div>
                    <div class="chart-wrapper">
                        <canvas id="resolutionChart"></canvas>
                    </div>
                </div>
            </div>
            
            <div class="quick-actions">
                <h3>Quick Actions</h3>
                <div class="action-buttons">
                    <a href="operators.html" class="btn btn-primary">
                        <i class="fas fa-user-plus"></i> Add Operator
                    </a>
                    <a href="departments.jsp" class="btn btn-success">
                        <i class="fas fa-building"></i> Manage Departments
                    </a>
                    <button class="btn btn-warning" id="generateReportBtn">
                        <i class="fas fa-file-alt"></i> Generate Report
                    </button>
                    <a href="settings.jsp" class="btn btn-outline">
                        <i class="fas fa-cog"></i> System Settings
                    </a>
                </div>
            </div>
            
            <div class="recent-activity">
                <h3>Recent Activity</h3>
                <ul class="activity-list" id="activityList"></ul>
            </div>
        </div>
    </div>
    
    <div class="modal" id="operatorModal">
        <div class="modal-content">
            <!-- Operator modal content -->
        </div>
    </div>

    <script>
        function initializeCharts() {
            const performanceCtx = document.getElementById('performanceChart').getContext('2d');
            const departments = ['Roads', 'Water', 'Waste', 'Parks', 'Electricity', 'Health', 'Education', 'Housing'];
            const performanceData = {
                labels: departments,
                datasets: [{
                    label: 'Resolution Rate (%)',
                    data: [92, 88, 95, 85, 90, 87, 89, 91],
                    backgroundColor: 'rgba(42, 91, 215, 0.7)',
                    borderColor: '#2a5bd7',
                    borderWidth: 2
                }, {
                    label: 'Avg. Resolution Time (Days)',
                    data: [2.5, 3.2, 1.8, 4.1, 2.9, 3.5, 3.8, 2.7],
                    backgroundColor: 'rgba(0, 168, 107, 0.7)',
                    borderColor: '#00a86b',
                    borderWidth: 2
                }]
            };

            new Chart(performanceCtx, {
                type: 'bar',
                data: performanceData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            const resolutionCtx = document.getElementById('resolutionChart').getContext('2d');
            const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
            const resolutionData = {
                labels: months,
                datasets: [{
                    label: 'Avg. Resolution Time (Days)',
                    data: [4.2, 3.8, 3.5, 3.2, 2.9, 2.7, 2.5],
                    borderColor: '#ff6b35',
                    backgroundColor: 'rgba(255, 107, 53, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }]
            };

            new Chart(resolutionCtx, {
                type: 'line',
                data: resolutionData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Days'
                            }
                        }
                    }
                }
            });
        }

        const recentActivities = [
            {
                type: 'add',
                title: 'New Operator Added',
                description: 'John Smith added to Roads & Transportation department',
                time: '10 minutes ago'
            },
            {
                type: 'update',
                title: 'Operator Status Updated',
                description: 'Michael Brown assigned to Water Supply department',
                time: '2 hours ago'
            },
            {
                type: 'update',
                title: 'Department Updated',
                description: 'New workflow added to Sanitation department',
                time: '5 hours ago'
            }
        ];

        function populateRecentActivities() {
            const activityList = document.getElementById('activityList');
            activityList.innerHTML = '';

            recentActivities.forEach(activity => {
                const activityItem = document.createElement('li');
                activityItem.className = 'activity-item';
                
                let iconClass = '';
                switch(activity.type) {
                    case 'add': iconClass = 'activity-add'; break;
                    case 'update': iconClass = 'activity-update'; break;
                }

                let iconSymbol = '';
                switch(activity.type) {
                    case 'add': iconSymbol = 'fa-user-plus'; break;
                    case 'update': iconSymbol = 'fa-edit'; break;
                }

                activityItem.innerHTML = `
                    <div class="activity-icon ${iconClass}">
                        <i class="fas ${iconSymbol}"></i>
                    </div>
                    <div class="activity-content">
                        <h4>${activity.title}</h4>
                        <p>${activity.description}</p>
                        <div class="activity-time">${activity.time}</div>
                    </div>
                `;
                
                activityList.appendChild(activityItem);
            });
        }

        // Profile Dropdown Functionality
        function setupProfileDropdown() {
            const dropdownBtn = document.getElementById('profileDropdownBtn');
            const dropdownMenu = document.getElementById('profileDropdownMenu');
            const editProfileBtn = document.getElementById('editProfileBtn');
            
            if (dropdownBtn && dropdownMenu) {
                // Toggle dropdown
                dropdownBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    dropdownMenu.classList.toggle('show');
                    dropdownBtn.classList.toggle('active');
                });
                
                // Edit Profile button
                if (editProfileBtn) {
                    editProfileBtn.addEventListener('click', () => {
                        dropdownMenu.classList.remove('show');
                        dropdownBtn.classList.remove('active');
                        alert('Edit profile feature would open a modal in a real implementation.');
                    });
                }
                
                // Close dropdown when clicking outside
                document.addEventListener('click', (e) => {
                    if (!dropdownBtn.contains(e.target) && !dropdownMenu.contains(e.target)) {
                        dropdownMenu.classList.remove('show');
                        dropdownBtn.classList.remove('active');
                    }
                });
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            initializeCharts();
            populateRecentActivities();
            setupProfileDropdown();
            
            document.getElementById('generateReportBtn').addEventListener('click', () => {
                alert('Report generation started.');
            });
        });
    </script>
</body>
</html>