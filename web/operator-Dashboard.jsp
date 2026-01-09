<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Operator Dashboard | Civic Pulse Hub</title>
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
            --info: #3498db;
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

        /* Layout */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
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
            font-size: 1rem;
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

        /* Logout Button */
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
        }

        .logout-btn:hover {
            background-color: rgba(231, 76, 60, 0.2);
            color: #ff8a80;
        }

        .logout-btn i {
            margin-right: 12px;
            font-size: 1rem;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 20px;
            transition: var(--transition);
        }

        /* Header */
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

        .header-subtitle {
            color: var(--gray);
            font-size: 1rem;
            margin-top: 5px;
        }

        .header-actions {
            display: flex;
            gap: 15px;
            align-items: center;
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

        /* Profile Dropdown */
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

        /* Stats Cards */
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

        /* Buttons */
        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-size: 0.95rem;
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

        .btn-danger {
            background-color: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
        }

        .btn-info {
            background-color: var(--info);
            color: white;
        }

        .btn-info:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
        }

        /* Table Styling */
        .tasks-table-section {
            background-color: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .section-header h2 {
            font-size: 1.5rem;
            color: var(--dark);
        }

        .section-actions {
            display: flex;
            gap: 15px;
        }

        .table-responsive {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        thead {
            background-color: #f8f9fa;
            border-bottom: 2px solid var(--light-gray);
        }

        th {
            padding: 15px;
            text-align: left;
            color: var(--gray);
            font-weight: 600;
            font-size: 0.9rem;
            white-space: nowrap;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid var(--light-gray);
            color: var(--dark);
            vertical-align: middle;
        }

        tr:hover {
            background-color: #f8fafc;
        }

        /* Status Badges */
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }

        .status-pending {
            background-color: rgba(243, 156, 18, 0.1);
            color: var(--warning);
        }

        .status-in-progress {
            background-color: rgba(52, 152, 219, 0.1);
            color: var(--info);
        }

        .status-completed {
            background-color: rgba(0, 168, 107, 0.1);
            color: var(--secondary);
        }

        .status-rejected {
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--danger);
        }

        /* Priority Badge */
        .priority-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }

        .priority-high {
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--danger);
        }

        .priority-medium {
            background-color: rgba(243, 156, 18, 0.1);
            color: var(--warning);
        }

        .priority-low {
            background-color: rgba(52, 152, 219, 0.1);
            color: var(--info);
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .action-btn {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .action-btn-view {
            background-color: rgba(52, 152, 219, 0.1);
            color: var(--info);
        }

        .action-btn-view:hover {
            background-color: rgba(52, 152, 219, 0.2);
        }

        .action-btn-assign {
            background-color: rgba(0, 168, 107, 0.1);
            color: var(--secondary);
        }

        .action-btn-assign:hover {
            background-color: rgba(0, 168, 107, 0.2);
        }

        .action-btn-update {
            background-color: rgba(155, 89, 182, 0.1);
            color: #8e44ad;
        }

        .action-btn-update:hover {
            background-color: rgba(155, 89, 182, 0.2);
        }

        /* Modal Styling */
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
            padding: 20px;
        }

        .modal-content {
            background-color: white;
            border-radius: 10px;
            width: 100%;
            max-width: 700px;
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

        /* Loading Spinner */
        .loading-spinner {
            display: none;
            text-align: center;
            padding: 40px;
        }

        .spinner {
            width: 40px;
            height: 40px;
            border: 4px solid var(--light-gray);
            border-top: 4px solid var(--primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Form Elements */
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

        /* Task Details Card */
        .task-details-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
        }

        .task-details-card h4 {
            font-size: 1.1rem;
            color: var(--dark);
            margin-bottom: 10px;
        }

        .task-details-row {
            display: flex;
            gap: 30px;
            margin-bottom: 10px;
        }

        .task-detail-item {
            flex: 1;
        }

        .task-detail-item label {
            font-size: 0.85rem;
            color: var(--gray);
            display: block;
            margin-bottom: 5px;
        }

        .task-detail-item span {
            font-weight: 500;
            color: var(--dark);
        }

        /* Responsive */
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
            
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .header-actions {
                width: 100%;
                justify-content: space-between;
            }
            
            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .section-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .section-actions {
                width: 100%;
                flex-wrap: wrap;
            }
            
            .task-details-row {
                flex-direction: column;
                gap: 15px;
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
            
            .action-buttons {
                flex-direction: column;
                align-items: stretch;
            }
            
            .action-btn {
                justify-content: center;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .modal-footer {
                flex-direction: column;
            }
            
            .modal-footer .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <%
        // Get session data
        String fullName = (String) session.getAttribute("full_name");
        String email = (String) session.getAttribute("email");
        String phone = (String) session.getAttribute("phone");
        Integer operatorId = (Integer) session.getAttribute("operator_id");
        
        // Check if operator is logged in
        if (fullName == null || email == null || operatorId == null) {
            response.sendRedirect("operator_login.html");
            return;
        }
        
        // Get initials for avatar
        String initials = "OP";
        if (fullName != null && !fullName.trim().isEmpty()) {
            String[] nameParts = fullName.split(" ");
            if (nameParts.length >= 2) {
                initials = nameParts[0].substring(0, 1) + nameParts[nameParts.length - 1].substring(0, 1);
            } else if (nameParts.length == 1) {
                initials = nameParts[0].substring(0, Math.min(2, nameParts[0].length()));
            }
        }
        initials = initials.toUpperCase();
        
        // Format operator ID
        String formattedOperatorId = String.format("OP-%03d", operatorId);
    %>
    
    <div class="dashboard-container">
        <!-- Sidebar -->
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
                <a href="Fetch_Task.jsp" class="nav-item">
                    <i class="fas fa-tasks"></i>
                    <span class="nav-text">Tasks</span>
                </a>
                <a href="profile.jsp" class="nav-item">
                    <i class="fas fa-user"></i>
                    <span class="nav-text">Profile</span>
                </a>
            </div>
            
            <div class="profile-section">
                <div class="profile-img"><%= initials %></div>
                <div class="profile-info">
                    <h4><%= fullName %></h4>
                    <p>Operator ID: <%= formattedOperatorId %></p>
                </div>
            </div>
            
            <!-- Logout Button -->
            <div class="logout-container">
                <a href="logout.jsp" class="logout-btn" id="logoutBtn">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <div class="header">
                <div>
                    <h1>Operator Dashboard</h1>
                    <div class="header-subtitle">Welcome back, <%= fullName %>! Manage tasks and complaint resolution</div>
                </div>
                <div class="header-actions">
                    <button class="notification-btn">
                        <i class="fas fa-bell"></i>
                        <span class="notification-badge">3</span>
                    </button>
                    
                    <!-- Profile Dropdown -->
                    <div class="profile-dropdown-container">
                        <div class="profile-dropdown-btn" id="profileDropdownBtn">
                            <div class="profile-avatar-small"><%= initials %></div>
                            <div class="profile-info-small">
                                <h4><%= fullName %></h4>
                                <p>Operator ID: <%= formattedOperatorId %></p>
                            </div>
                            <i class="fas fa-chevron-down dropdown-arrow"></i>
                        </div>
                        
                        <div class="profile-dropdown-menu" id="profileDropdownMenu">
                            <div class="dropdown-header">
                                <div class="dropdown-avatar"><%= initials %></div>
                                <h3><%= fullName %></h3>
                                <p>Operator - Civic Pulse Hub</p>
                                <p style="margin-top: 5px; font-size: 0.8rem; background: rgba(255,255,255,0.2); padding: 3px 10px; border-radius: 20px;">Operator ID: <%= formattedOperatorId %></p>
                            </div>
                            
                            <div class="dropdown-body">
                                <div class="dropdown-info-item">
                                    <i class="fas fa-envelope"></i>
                                    <span><strong>Email:</strong> <%= email %></span>
                                </div>
                                <div class="dropdown-info-item">
                                    <i class="fas fa-phone"></i>
                                    <span><strong>Phone:</strong> <%= (phone != null && !phone.isEmpty()) ? phone : "Not provided" %></span>
                                </div>
                                <div class="dropdown-info-item">
                                    <i class="fas fa-calendar-alt"></i>
                                    <span><strong>Member Since:</strong> <%= new java.text.SimpleDateFormat("MMMM d, yyyy").format(new java.util.Date()) %></span>
                                </div>
                                <div class="dropdown-info-item">
                                    <i class="fas fa-user-shield"></i>
                                    <span><strong>Role:</strong> Department Operator</span>
                                </div>
                                <div class="dropdown-info-item">
                                    <i class="fas fa-clock"></i>
                                    <span><strong>Last Login:</strong> Today, <%= new java.text.SimpleDateFormat("hh:mm a").format(new java.util.Date()) %></span>
                                </div>
                            </div>
                            
                            <div class="dropdown-actions">
                                <a href="edit_profile.jsp" class="btn btn-edit">
                                    <i class="fas fa-edit"></i> Edit Profile
                                </a>
                                <a href="logout.jsp" class="btn btn-outline" id="dropdownLogoutBtn">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Stats Cards -->
            <div class="stats-container">
                <div class="stat-card stat-1">
                    <div class="stat-info">
                        <h3 id="totalTasks">0</h3>
                        <p>Total Tasks</p>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-tasks"></i>
                    </div>
                </div>
                
                <div class="stat-card stat-2">
                    <div class="stat-info">
                        <h3 id="pendingTasks">0</h3>
                        <p>Pending Tasks</p>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                </div>
                
                <div class="stat-card stat-3">
                    <div class="stat-info">
                        <h3 id="inProgressTasks">0</h3>
                        <p>In Progress</p>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-spinner"></i>
                    </div>
                </div>
                
                <div class="stat-card stat-4">
                    <div class="stat-info">
                        <h3 id="completedTasks">0</h3>
                        <p>Completed</p>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
            </div>
            
            <!-- Tasks Table Section -->
            <div class="tasks-table-section">
                <div class="section-header">
                    <h2>Task Management</h2>
                    <div class="section-actions">
                        <button class="btn btn-primary" id="fetchTasksBtn">
                            <i class="fas fa-sync-alt"></i> Fetch Tasks
                        </button>
                        <button class="btn btn-outline" id="refreshBtn">
                            <i class="fas fa-redo"></i> Refresh
                        </button>
                    </div>
                </div>
                
                <!-- Loading Spinner -->
                <div class="loading-spinner" id="tasksLoading">
                    <div class="spinner"></div>
                    <p>Loading tasks data...</p>
                </div>
                
                <div class="table-responsive">
                    <table id="tasksTable">
                        <thead>
                            <tr>
                                <th>Task ID</th>
                                <th>Complaint ID</th>
                                <th>Description</th>
                                <th>Department</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th>Created Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="tasksTableBody">
                            <!-- Tasks data will be loaded dynamically -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Task Details Modal -->
    <div class="modal" id="taskDetailsModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Task Details</h3>
                <button class="close-btn" id="closeDetailsModal">&times;</button>
            </div>
            <div class="modal-body">
                <div class="task-details-card">
                    <div class="task-details-row">
                        <div class="task-detail-item">
                            <label>Task ID</label>
                            <span id="detailTaskId">Loading...</span>
                        </div>
                        <div class="task-detail-item">
                            <label>Complaint ID</label>
                            <span id="detailComplaintId">Loading...</span>
                        </div>
                        <div class="task-detail-item">
                            <label>Priority</label>
                            <span id="detailTaskPriority" class="priority-badge priority-high">High</span>
                        </div>
                    </div>
                    <div class="task-details-row">
                        <div class="task-detail-item">
                            <label>Department</label>
                            <span id="detailDepartment">Loading...</span>
                        </div>
                        <div class="task-detail-item">
                            <label>Status</label>
                            <span id="detailStatus" class="status-badge status-pending">Pending</span>
                        </div>
                        <div class="task-detail-item">
                            <label>Created Date</label>
                            <span id="detailCreatedDate">Loading...</span>
                        </div>
                    </div>
                    <div class="task-details-row">
                        <div class="task-detail-item" style="flex: 2;">
                            <label>Location</label>
                            <span id="detailLocation">Loading...</span>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Description</label>
                    <div class="form-control" style="background-color: #f8f9fa; min-height: 80px;" id="detailDescription">
                        Loading...
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Additional Notes</label>
                    <textarea id="taskNotes" class="form-control" rows="3" placeholder="Add notes about this task..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="statusUpdate">Update Status</label>
                    <select id="statusUpdate" class="form-control">
                        <option value="pending">Pending</option>
                        <option value="in-progress">In Progress</option>
                        <option value="completed">Completed</option>
                        <option value="rejected">Rejected</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-outline" id="closeDetailsBtn">Close</button>
                <button class="btn btn-primary" id="saveTaskChanges">Save Changes</button>
            </div>
        </div>
    </div>

    <script>
        // DOM Elements
        const tasksTableBody = document.getElementById('tasksTableBody');

        // Global variables
        let tasksData = [];
        let selectedTask = null;

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            setupEventListeners();
            loadTasksData();
        });

        // Setup Event Listeners
        function setupEventListeners() {
            // Profile Dropdown
            setupProfileDropdown();

            // Refresh Button
            document.getElementById('refreshBtn').addEventListener('click', loadTasksData);

            // Fetch Tasks Button
            document.getElementById('fetchTasksBtn').addEventListener('click', fetchTasksFromServer);

            // Close Details Modal
            document.getElementById('closeDetailsModal').addEventListener('click', () => {
                document.getElementById('taskDetailsModal').style.display = 'none';
            });

            document.getElementById('closeDetailsBtn').addEventListener('click', () => {
                document.getElementById('taskDetailsModal').style.display = 'none';
            });

            // Save Task Changes
            document.getElementById('saveTaskChanges').addEventListener('click', saveTaskChanges);

            // Close modal when clicking outside
            window.addEventListener('click', (event) => {
                if (event.target === document.getElementById('taskDetailsModal')) {
                    document.getElementById('taskDetailsModal').style.display = 'none';
                }
            });
        }

        // Profile Dropdown Functionality
        function setupProfileDropdown() {
            const dropdownBtn = document.getElementById('profileDropdownBtn');
            const dropdownMenu = document.getElementById('profileDropdownMenu');
            
            // Toggle dropdown
            dropdownBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                dropdownMenu.classList.toggle('show');
                dropdownBtn.classList.toggle('active');
            });
            
            // Close dropdown when clicking outside
            document.addEventListener('click', (e) => {
                if (!dropdownBtn.contains(e.target) && !dropdownMenu.contains(e.target)) {
                    dropdownMenu.classList.remove('show');
                    dropdownBtn.classList.remove('active');
                }
            });
        }

        // Load Tasks Data
        async function loadTasksData() {
            showLoading('tasksLoading', true);
            
            try {
                // In a real application, this would be an API call to fetch tasks for this operator
                // We'll use the operator ID from session
                const operatorId = <%= operatorId %>;
                
                // Simulate API call with delay
                await new Promise(resolve => setTimeout(resolve, 800));
                
                // Simulated tasks data - in real app, fetch from server based on operatorId
                tasksData = [
                    { 
                        id: "T-00123", 
                        complaintId: "CP-00456", 
                        description: "Repair pothole on Main Street near City Hall", 
                        location: "Main Street, Downtown",
                        department: "Roads & Transportation", 
                        priority: "high", 
                        status: "pending", 
                        createdDate: "2023-10-15",
                        notes: "",
                        assignedTo: <%= operatorId %>
                    },
                    { 
                        id: "T-00124", 
                        complaintId: "CP-00457", 
                        description: "Fix water leakage on Oak Avenue", 
                        location: "Oak Avenue, Suburbs",
                        department: "Water Supply", 
                        priority: "medium", 
                        status: "in-progress", 
                        createdDate: "2023-10-14",
                        notes: "Worker assigned, in progress",
                        assignedTo: <%= operatorId %>
                    },
                    { 
                        id: "T-00125", 
                        complaintId: "CP-00458", 
                        description: "Collect garbage from Park Street", 
                        location: "Park Street, Residential",
                        department: "Waste Management", 
                        priority: "low", 
                        status: "completed", 
                        createdDate: "2023-10-13",
                        notes: "Task completed successfully",
                        assignedTo: <%= operatorId %>
                    },
                    { 
                        id: "T-00126", 
                        complaintId: "CP-00459", 
                        description: "Repair broken street light on 5th Avenue", 
                        location: "5th Avenue, Downtown",
                        department: "Electricity", 
                        priority: "high", 
                        status: "pending", 
                        createdDate: "2023-10-15",
                        notes: "",
                        assignedTo: <%= operatorId %>
                    },
                    { 
                        id: "T-00127", 
                        complaintId: "CP-00460", 
                        description: "Clear drainage clog on Maple Road", 
                        location: "Maple Road, Suburbs",
                        department: "Water Supply", 
                        priority: "medium", 
                        status: "in-progress", 
                        createdDate: "2023-10-14",
                        notes: "Drainage team on site",
                        assignedTo: <%= operatorId %>
                    }
                ];
                
                populateTasksTable();
                updateStats();
                
            } catch (error) {
                console.error('Error loading tasks:', error);
                showNotification('Failed to load tasks. Please try again.', 'error');
            } finally {
                showLoading('tasksLoading', false);
            }
        }

        // Fetch Tasks from Server
        async function fetchTasksFromServer() {
            showLoading('tasksLoading', true);
            showNotification('Fetching new tasks from server...', 'info');
            
            try {
                // In a real application, this would be an API call to fetch new tasks
                // Use operatorId from session to fetch relevant tasks
                const operatorId = <%= operatorId %>;
                
                await new Promise(resolve => setTimeout(resolve, 1200));
                
                // Simulate adding new tasks
                const newTasks = [
                    { 
                        id: "T-00128", 
                        complaintId: "CP-00461", 
                        description: "Trim overgrown trees on Elm Street", 
                        location: "Elm Street, Residential",
                        department: "Parks & Public Spaces", 
                        priority: "medium", 
                        status: "pending", 
                        createdDate: new Date().toISOString().split('T')[0],
                        notes: "",
                        assignedTo: <%= operatorId %>
                    },
                    { 
                        id: "T-00129", 
                        complaintId: "CP-00462", 
                        description: "Repair damaged sidewalk on Pine Avenue", 
                        location: "Pine Avenue, Downtown",
                        department: "Roads & Transportation", 
                        priority: "low", 
                        status: "pending", 
                        createdDate: new Date().toISOString().split('T')[0],
                        notes: "",
                        assignedTo: <%= operatorId %>
                    }
                ];
                
                // Add new tasks to existing data
                tasksData = [...newTasks, ...tasksData];
                
                populateTasksTable();
                updateStats();
                
                showNotification(`${newTasks.length} new tasks fetched successfully!`, 'success');
                
            } catch (error) {
                console.error('Error fetching tasks:', error);
                showNotification('Failed to fetch tasks. Please try again.', 'error');
            } finally {
                showLoading('tasksLoading', false);
            }
        }

        // Populate Tasks Table
        function populateTasksTable() {
            tasksTableBody.innerHTML = '';
            
            if (tasksData.length === 0) {
                tasksTableBody.innerHTML = `
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 30px; color: var(--gray);">
                            No tasks available. Click "Fetch Tasks" to get tasks.
                        </td>
                    </tr>
                `;
                return;
            }
            
            tasksData.forEach(task => {
                const row = document.createElement('tr');
                
                // Status badge
                let statusClass, statusText;
                switch(task.status) {
                    case 'pending': statusClass = 'status-pending'; statusText = 'Pending'; break;
                    case 'in-progress': statusClass = 'status-in-progress'; statusText = 'In Progress'; break;
                    case 'completed': statusClass = 'status-completed'; statusText = 'Completed'; break;
                    case 'rejected': statusClass = 'status-rejected'; statusText = 'Rejected'; break;
                    default: statusClass = 'status-pending'; statusText = 'Pending';
                }
                
                // Priority badge
                let priorityClass, priorityText;
                switch(task.priority) {
                    case 'high': priorityClass = 'priority-high'; priorityText = 'High'; break;
                    case 'medium': priorityClass = 'priority-medium'; priorityText = 'Medium'; break;
                    case 'low': priorityClass = 'priority-low'; priorityText = 'Low'; break;
                    default: priorityClass = 'priority-medium'; priorityText = 'Medium';
                }
                
                row.innerHTML = `
                    <td><strong>${task.id}</strong></td>
                    <td>${task.complaintId}</td>
                    <td>${task.description}</td>
                    <td><span style="background-color: rgba(42, 91, 215, 0.1); color: var(--primary); padding: 3px 8px; border-radius: 4px; font-size: 0.85rem;">${task.department}</span></td>
                    <td><span class="priority-badge ${priorityClass}">${priorityText}</span></td>
                    <td><span class="status-badge ${statusClass}">${statusText}</span></td>
                    <td>${formatDate(task.createdDate)}</td>
                    <td>
                        <div class="action-buttons">
                            <button class="action-btn action-btn-view" onclick="viewTaskDetails('${task.id}')">
                                <i class="fas fa-eye"></i> View
                            </button>
                            <button class="action-btn action-btn-update" onclick="updateTaskStatus('${task.id}')">
                                <i class="fas fa-edit"></i> Update
                            </button>
                        </div>
                    </td>
                `;
                
                tasksTableBody.appendChild(row);
            });
        }

        // View Task Details
        function viewTaskDetails(taskId) {
            selectedTask = tasksData.find(t => t.id === taskId);
            
            if (!selectedTask) {
                showNotification('Task not found.', 'error');
                return;
            }
            
            // Update modal with task details
            document.getElementById('detailTaskId').textContent = selectedTask.id;
            document.getElementById('detailComplaintId').textContent = selectedTask.complaintId;
            document.getElementById('detailDescription').textContent = selectedTask.description;
            document.getElementById('detailDepartment').textContent = selectedTask.department;
            document.getElementById('detailLocation').textContent = selectedTask.location;
            document.getElementById('detailCreatedDate').textContent = formatDate(selectedTask.createdDate);
            document.getElementById('taskNotes').value = selectedTask.notes || '';
            document.getElementById('statusUpdate').value = selectedTask.status;
            
            // Update priority badge
            const priorityElement = document.getElementById('detailTaskPriority');
            priorityElement.textContent = selectedTask.priority.charAt(0).toUpperCase() + selectedTask.priority.slice(1);
            priorityElement.className = `priority-badge priority-${selectedTask.priority}`;
            
            // Update status badge
            const statusElement = document.getElementById('detailStatus');
            let statusClass, statusText;
            switch(selectedTask.status) {
                case 'pending': statusClass = 'status-pending'; statusText = 'Pending'; break;
                case 'in-progress': statusClass = 'status-in-progress'; statusText = 'In Progress'; break;
                case 'completed': statusClass = 'status-completed'; statusText = 'Completed'; break;
                case 'rejected': statusClass = 'status-rejected'; statusText = 'Rejected'; break;
                default: statusClass = 'status-pending'; statusText = 'Pending';
            }
            statusElement.textContent = statusText;
            statusElement.className = `status-badge ${statusClass}`;
            
            document.getElementById('taskDetailsModal').style.display = 'flex';
        }

        // Update Task Status (quick action)
        function updateTaskStatus(taskId) {
            const task = tasksData.find(t => t.id === taskId);
            
            if (!task) {
                showNotification('Task not found.', 'error');
                return;
            }
            
            // Simple status update
            const currentStatus = task.status;
            let newStatus;
            
            switch(currentStatus) {
                case 'pending':
                    newStatus = 'in-progress';
                    break;
                case 'in-progress':
                    newStatus = 'completed';
                    break;
                case 'completed':
                    newStatus = 'pending';
                    break;
                default:
                    newStatus = 'in-progress';
            }
            
            task.status = newStatus;
            populateTasksTable();
            updateStats();
            
            showNotification(`Task ${taskId} status updated to ${newStatus}`, 'success');
        }

        // Save Task Changes from Modal
        async function saveTaskChanges() {
            if (!selectedTask) return;
            
            const newStatus = document.getElementById('statusUpdate').value;
            const notes = document.getElementById('taskNotes').value;
            
            try {
                // In a real application, send this to server
                const operatorId = <%= operatorId %>;
                
                // Simulate API call
                showNotification('Saving changes...', 'info');
                await new Promise(resolve => setTimeout(resolve, 600));
                
                // Update task
                selectedTask.status = newStatus;
                selectedTask.notes = notes;
                selectedTask.lastUpdatedBy = operatorId;
                selectedTask.lastUpdatedDate = new Date().toISOString().split('T')[0];
                
                // Update UI
                populateTasksTable();
                updateStats();
                
                // Close modal
                document.getElementById('taskDetailsModal').style.display = 'none';
                
                showNotification('Task updated successfully!', 'success');
                
            } catch (error) {
                console.error('Error saving task:', error);
                showNotification('Failed to save changes. Please try again.', 'error');
            }
        }

        // Update Stats
        function updateStats() {
            // Update total tasks count
            document.getElementById('totalTasks').textContent = tasksData.length;
            
            // Update pending tasks count
            const pendingTasks = tasksData.filter(task => task.status === 'pending').length;
            document.getElementById('pendingTasks').textContent = pendingTasks;
            
            // Update in-progress tasks count
            const inProgressTasks = tasksData.filter(task => task.status === 'in-progress').length;
            document.getElementById('inProgressTasks').textContent = inProgressTasks;
            
            // Update completed tasks count
            const completedTasks = tasksData.filter(task => task.status === 'completed').length;
            document.getElementById('completedTasks').textContent = completedTasks;
        }

        // Helper Functions
        function formatDate(dateString) {
            try {
                const options = { year: 'numeric', month: 'short', day: 'numeric' };
                return new Date(dateString).toLocaleDateString('en-US', options);
            } catch (e) {
                return dateString;
            }
        }

        function showNotification(message, type = 'info') {
            // Remove existing notifications
            document.querySelectorAll('.notification').forEach(n => n.remove());
            
            // Create notification element
            const notification = document.createElement('div');
            notification.className = `notification notification-${type}`;
            notification.innerHTML = `
                <div>${message}</div>
                <button onclick="this.parentElement.remove()">&times;</button>
            `;
            
            // Add styles for notification
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                background-color: ${getNotificationColor(type)};
                color: white;
                padding: 15px 20px;
                border-radius: 6px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                z-index: 10000;
                display: flex;
                justify-content: space-between;
                align-items: center;
                min-width: 300px;
                animation: slideIn 0.3s ease;
            `;
            
            // Add keyframes for animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes slideIn {
                    from { transform: translateX(100%); opacity: 0; }
                    to { transform: translateX(0); opacity: 1; }
                }
            `;
            document.head.appendChild(style);
            
            document.body.appendChild(notification);
            
            // Auto-remove after 5 seconds
            setTimeout(() => {
                if (notification.parentElement) {
                    notification.remove();
                }
            }, 5000);
        }

        function getNotificationColor(type) {
            switch(type) {
                case 'success': return '#00a86b';
                case 'error': return '#e74c3c';
                case 'warning': return '#f39c12';
                case 'info': 
                default: return '#3498db';
            }
        }

        function showLoading(elementId, show) {
            const element = document.getElementById(elementId);
            if (element) {
                element.style.display = show ? 'block' : 'none';
            }
        }
    </script>
</body>
</html>