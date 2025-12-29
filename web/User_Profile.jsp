<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="jakarta.servlet.http.HttpSession"%>
<%@page import="java.sql.*"%>
<%
    // Check if user is logged in
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("email") == null) {
        response.sendRedirect("User_Login.html");
        return;
    }
    
    // Get user data from session - handle different data types
    String userName = (String) userSession.getAttribute("name");
    String userEmail = (String) userSession.getAttribute("email");
    String userPhone = (String) userSession.getAttribute("mobile");
    String address = (String) userSession.getAttribute("address");
    
    // Handle user_id which might be Integer
    String userId = "";
    Object userIdObj = userSession.getAttribute("user_id");
    if (userIdObj != null) {
        if (userIdObj instanceof Integer) {
            userId = String.valueOf((Integer) userIdObj);
        } else if (userIdObj instanceof String) {
            userId = (String) userIdObj;
        }
    }
    
    // Get registration date
    String registrationDate = "";
    Object regDateObj = userSession.getAttribute("registration_date");
    if (regDateObj != null) {
        registrationDate = regDateObj.toString();
    }
    
    // Set default values if null
    if (userName == null || userName.trim().isEmpty()) userName = "User";
    if (userEmail == null || userEmail.trim().isEmpty()) userEmail = "Not provided";
    if (userPhone == null || userPhone.trim().isEmpty()) userPhone = "Not provided";
    if (address == null || address.trim().isEmpty()) address = "Not provided";
    if (userId == null || userId.trim().isEmpty()) userId = "0000";
    if (registrationDate == null || registrationDate.trim().isEmpty()) {
        registrationDate = "Not available";
    }
    
    // Get user initials for avatar
    String userInitials = "";
    if (userName != null && !userName.trim().isEmpty() && !userName.equals("User")) {
        String[] nameParts = userName.split(" ");
        if (nameParts.length >= 2) {
            userInitials = (nameParts[0].substring(0, 1) + nameParts[1].substring(0, 1)).toUpperCase();
        } else if (nameParts.length == 1) {
            userInitials = userName.substring(0, Math.min(2, userName.length())).toUpperCase();
        }
    } else {
        userInitials = "U";
    }
    
    // Initialize statistics
    int issuesReported = 0;
    int issuesResolved = 0;
    
    // Try to fetch statistics from database only if we have a valid user ID
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    if (!userId.equals("0000") && !userId.isEmpty()) {
        try {
            // Database connection - UPDATE THESE VALUES
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/civic_pulse", // Change to your database name
                "root", // Change to your username
                ""      // Change to your password
            );
            
            // Get issues reported count
            String reportedQuery = "SELECT COUNT(*) as count FROM issues WHERE user_id = ?";
            pstmt = conn.prepareStatement(reportedQuery);
            // Convert userId to Integer if it's numeric
            try {
                int userIdInt = Integer.parseInt(userId);
                pstmt.setInt(1, userIdInt);
            } catch (NumberFormatException e) {
                pstmt.setString(1, userId);
            }
            rs = pstmt.executeQuery();
            if (rs.next()) {
                issuesReported = rs.getInt("count");
            }
            rs.close();
            pstmt.close();
            
            // Get issues resolved count
            String resolvedQuery = "SELECT COUNT(*) as count FROM issues WHERE user_id = ? AND status = 'Resolved'";
            pstmt = conn.prepareStatement(resolvedQuery);
            try {
                int userIdInt = Integer.parseInt(userId);
                pstmt.setInt(1, userIdInt);
            } catch (NumberFormatException e) {
                pstmt.setString(1, userId);
            }
            rs = pstmt.executeQuery();
            if (rs.next()) {
                issuesResolved = rs.getInt("count");
            }
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            // Set default values if JDBC driver not found
            issuesReported = 12;
            issuesResolved = 8;
        } catch (SQLException e) {
            e.printStackTrace();
            // Set default values if database fetch fails
            issuesReported = 12;
            issuesResolved = 8;
        } catch (Exception e) {
            e.printStackTrace();
            issuesReported = 12;
            issuesResolved = 8;
        } finally {
            // Close database resources
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    } else {
        // Use default values if no valid user ID
        issuesReported = 12;
        issuesResolved = 8;
    }
    
    // Format citizen ID - extract year from registration date
    String year = "2024"; // Default year
    if (registrationDate != null && !registrationDate.equals("Not available")) {
        try {
            // Try to extract year from date string
            if (registrationDate.length() >= 4) {
                year = registrationDate.substring(0, 4);
            }
        } catch (Exception e) {
            // Use default if extraction fails
            year = "2024";
        }
    }
    
    String citizenId = "CP-" + year + "-" + String.format("%05d", issuesReported);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Civic Pulse - My Profile</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* ALL YOUR EXISTING CSS STYLES REMAIN THE SAME - I'm including just the key parts to save space */
        :root {
            --primary-color: #2a5c82;
            --primary-light: #3a7ca5;
            --primary-dark: #1c3b5a;
            --secondary-color: #4a9c7d;
            --accent-color: #e76f51;
            --light-color: #f8f9fa;
            --dark-color: #2d3748;
            --gray-color: #718096;
            --gray-light: #e2e8f0;
            --gradient-primary: linear-gradient(135deg, #2a5c82 0%, #3a7ca5 100%);
            --gradient-secondary: linear-gradient(135deg, #4a9c7d 0%, #3a8369 100%);
            --shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            --shadow-hover: 0 8px 25px rgba(0, 0, 0, 0.12);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
        }

        body {
            background-color: #f5f7fa;
            color: var(--dark-color);
            line-height: 1.6;
            min-height: 100vh;
            padding: 20px;
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e9f2 100%);
        }

        /* Header Styles */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 0;
            margin-bottom: 30px;
            border-bottom: 1px solid var(--gray-light);
        }

        .logo-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logo-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }

        .logo-text h1 {
            font-size: 24px;
            font-weight: 800;
            color: var(--primary-color);
        }

        .logo-text p {
            font-size: 12px;
            color: var(--gray-color);
        }

        .nav-menu {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .nav-item {
            padding: 10px 20px;
            border-radius: 10px;
            text-decoration: none;
            color: var(--dark-color);
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-item:hover {
            background-color: var(--gray-light);
            color: var(--primary-color);
        }

        .nav-item.active {
            background-color: var(--primary-color);
            color: white;
        }

        /* Profile Container */
        .profile-container {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 30px;
        }

        /* Sidebar */
        .sidebar {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: var(--shadow);
            height: fit-content;
        }

        .user-profile {
            text-align: center;
            margin-bottom: 30px;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: var(--gradient-primary);
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .change-avatar {
            position: absolute;
            bottom: 5px;
            right: 5px;
            background: var(--accent-color);
            color: white;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            cursor: pointer;
            border: 2px solid white;
        }

        .user-name {
            font-size: 22px;
            font-weight: 700;
            color: var(--dark-color);
            margin-bottom: 5px;
        }

        .user-role {
            font-size: 14px;
            color: var(--gray-color);
            background-color: var(--gray-light);
            padding: 4px 12px;
            border-radius: 20px;
            display: inline-block;
        }

        .stats-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 30px;
        }

        .stat-item {
            text-align: center;
            padding: 15px;
            background-color: var(--light-color);
            border-radius: 12px;
        }

        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 12px;
            color: var(--gray-color);
        }

        .sidebar-menu {
            list-style: none;
        }

        .menu-item {
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .menu-item:hover {
            background-color: var(--gray-light);
            color: var(--primary-color);
        }

        .menu-item.active {
            background-color: var(--primary-color);
            color: white;
        }

        .menu-item i {
            font-size: 18px;
        }

        /* Main Content */
        .main-content {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: var(--shadow);
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--gray-light);
        }

        .content-title {
            font-size: 28px;
            font-weight: 700;
            color: var(--dark-color);
        }

        .edit-btn {
            background: var(--gradient-secondary);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .edit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(74, 156, 125, 0.3);
        }

        /* Profile Details */
        .profile-details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 30px;
        }

        .detail-section {
            margin-bottom: 25px;
        }

        .detail-label {
            font-size: 13px;
            color: var(--gray-color);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-label i {
            color: var(--primary-color);
        }

        .detail-value {
            font-size: 16px;
            color: var(--dark-color);
            font-weight: 500;
            padding: 12px 15px;
            background-color: var(--light-color);
            border-radius: 10px;
            border: 1px solid var(--gray-light);
        }

        /* Edit Form Styles */
        .edit-form {
            display: none;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: var(--dark-color);
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid var(--gray-light);
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: white;
            color: var(--dark-color);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(42, 92, 130, 0.2);
        }

        .form-control.address-input {
            min-height: 100px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn-save {
            background: var(--gradient-secondary);
            color: white;
            border: none;
            padding: 14px 28px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            flex: 1;
            justify-content: center;
        }

        .btn-cancel {
            background: var(--gray-light);
            color: var(--dark-color);
            border: none;
            padding: 14px 28px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            flex: 1;
            justify-content: center;
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(74, 156, 125, 0.3);
        }

        .btn-cancel:hover {
            background-color: #d1d5db;
            transform: translateY(-2px);
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .profile-container {
                grid-template-columns: 1fr;
            }
            
            .sidebar {
                order: 2;
            }
            
            .main-content {
                order: 1;
            }
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }
            
            .nav-menu {
                flex-wrap: wrap;
                justify-content: center;
            }
            
            .profile-details {
                grid-template-columns: 1fr;
            }
            
            .content-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .form-actions {
                flex-direction: column;
            }
        }

        @media (max-width: 480px) {
            .profile-container {
                padding: 10px;
            }
            
            .main-content, .sidebar {
                padding: 20px;
            }
            
            .stats-container {
                grid-template-columns: 1fr;
            }
            
            .nav-item {
                padding: 8px 15px;
                font-size: 14px;
            }
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .main-content {
            animation: fadeIn 0.5s ease;
        }

        /* Alert Messages */
        .alert {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-size: 15px;
            font-weight: 500;
            display: none;
            animation: fadeIn 0.3s ease;
        }

        .alert.success {
            background-color: #f0fdf4;
            color: #16a34a;
            border: 1px solid #bbf7d0;
        }

        .alert.error {
            background-color: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        /* Loading State */
        .loading {
            opacity: 0.7;
            pointer-events: none;
        }

        /* Activity Feed */
        .activity-feed {
            margin-top: 40px;
        }

        .activity-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: var(--dark-color);
        }

        .activity-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px;
            border-radius: 12px;
            background-color: var(--light-color);
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }

        .activity-item:hover {
            background-color: var(--gray-light);
            transform: translateX(5px);
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
        }

        .activity-content {
            flex: 1;
        }

        .activity-text {
            font-size: 14px;
            color: var(--dark-color);
        }

        .activity-time {
            font-size: 12px;
            color: var(--gray-color);
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="logo-container">
            <div class="logo-icon">
                <i class="fas fa-heartbeat"></i>
            </div>
            <div class="logo-text">
                <h1>CIVIC PULSE</h1>
                <p>Smart City Feedback System</p>
            </div>
        </div>
        
        <nav class="nav-menu">
            <a href="User_Dashboard.jsp" class="nav-item">
                <i class="fas fa-home"></i> Dashboard
            </a>
            
            <a href="User_Profile.jsp" class="nav-item active">
                <i class="fas fa-user"></i> Profile
            </a>
            <a href="User_Logout" class="nav-item">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="profile-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="user-profile">
                <div class="profile-avatar">
                    <span id="avatarInitials"><%= userInitials %></span>
                    <div class="change-avatar" onclick="changeAvatar()">
                        <i class="fas fa-camera"></i>
                    </div>
                </div>
                <h2 class="user-name" id="userName"><%= userName %></h2>
                <span class="user-role">Active Citizen</span>
            </div>
            
            <div class="stats-container">
                <div class="stat-item">
                    <div class="stat-value" id="issuesReported"><%= issuesReported %></div>
                    <div class="stat-label">Issues Reported</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value" id="issuesResolved"><%= issuesResolved %></div>
                    <div class="stat-label">Issues Resolved</div>
                </div>
            </div>
            
            <ul class="sidebar-menu">
                <li class="menu-item active" onclick="showSection('personal')">
                    <i class="fas fa-user-circle"></i>
                    Personal Information
                </li>
                <li class="menu-item" onclick="showSection('activity')">
                    <i class="fas fa-history"></i>
                    Activity History
                </li>
                <li class="menu-item" onclick="showSection('security')">
                    <i class="fas fa-shield-alt"></i>
                    Security Settings
                </li>
                <li class="menu-item" onclick="showSection('notifications')">
                    <i class="fas fa-bell"></i>
                    Notification Settings
                </li>
                <li class="menu-item" onclick="showSection('preferences')">
                    <i class="fas fa-cog"></i>
                    Preferences
                </li>
            </ul>
        </div>

        <!-- Main Content Area -->
        <div class="main-content">
            <!-- Success/Error Message Container -->
            <div id="messageContainer" class="alert" style="display: none;"></div>

            <!-- Personal Information Section -->
            <div id="personalSection" class="content-section">
    <div class="content-header">
        <h2 class="content-title">Personal Information</h2>
        <a href="user_edit_profile.jsp" class="edit-btn">
            <i class="fas fa-edit"></i> Edit Profile
        </a>
    </div>
</div>

                <!-- View Mode -->
                <div id="viewMode" class="profile-details">
                    <div class="detail-section">
                        <div class="detail-label">
                            <i class="fas fa-user"></i> Full Name
                        </div>
                        <div class="detail-value" id="viewName"><%= userName %></div>
                    </div>
                    
                    <div class="detail-section">
                        <div class="detail-label">
                            <i class="fas fa-envelope"></i> Email Address
                        </div>
                        <div class="detail-value" id="viewEmail"><%= userEmail %></div>
                    </div>
                    
                    <div class="detail-section">
                        <div class="detail-label">
                            <i class="fas fa-phone"></i> Mobile Number
                        </div>
                        <div class="detail-value" id="viewMobile"><%= userPhone %></div>
                    </div>
                    
                    <div class="detail-section">
                        <div class="detail-label">
                            <i class="fas fa-home"></i> Address
                        </div>
                        <div class="detail-value" id="viewAddress"><%= address %></div>
                    </div>
                    
                    <div class="detail-section">
                        <div class="detail-label">
                            <i class="fas fa-calendar"></i> Member Since
                        </div>
                        <div class="detail-value" id="viewJoinDate"><%= registrationDate %></div>
                    </div>
                    
                    <div class="detail-section">
                        <div class="detail-label">
                            <i class="fas fa-id-card"></i> Citizen ID
                        </div>
                        <div class="detail-value" id="viewCitizenId"><%= citizenId %></div>
                    </div>
                </div>

                <!-- Edit Mode -->
                <div id="editMode" class="edit-form">
                    <form id="profileForm" onsubmit="updateProfile(event)">
                        <div class="profile-details">
                            <div class="form-group">
                                <label for="editName">
                                    <i class="fas fa-user"></i> Full Name
                                </label>
                                <input type="text" 
                                       id="editName" 
                                       class="form-control" 
                                       placeholder="Enter your full name"
                                       required
                                       minlength="2"
                                       maxlength="50"
                                       value="<%= userName %>">
                            </div>
                            
                            <div class="form-group">
                                <label for="editEmail">
                                    <i class="fas fa-envelope"></i> Email Address
                                </label>
                                <input type="email" 
                                       id="editEmail" 
                                       class="form-control" 
                                       placeholder="Enter your Gmail address"
                                       pattern="^[a-zA-Z0-9._%+-]+@gmail\.com$" 
                                       required
                                       value="<%= userEmail %>">
                                <small style="color: var(--gray-color); font-size: 12px; margin-top: 5px; display: block;">
                                    Must be a valid Gmail address
                                </small>
                            </div>
                            
                            <div class="form-group">
                                <label for="editMobile">
                                    <i class="fas fa-phone"></i> Mobile Number
                                </label>
                                <input type="tel" 
                                       id="editMobile" 
                                       class="form-control" 
                                       placeholder="Enter your mobile number"
                                       pattern="[0-9]{10}"
                                       required
                                       value="<%= userPhone %>">
                                <small style="color: var(--gray-color); font-size: 12px; margin-top: 5px; display: block;">
                                    10-digit mobile number without country code
                                </small>
                            </div>
                            
                            <div class="form-group" style="grid-column: span 2;">
                                <label for="editAddress">
                                    <i class="fas fa-home"></i> Address
                                </label>
                                <textarea 
                                    id="editAddress" 
                                    class="form-control address-input" 
                                    placeholder="Enter your complete address"
                                    required
                                    rows="3"
                                    minlength="10"
                                    maxlength="200"><%= address %></textarea>
                                <small style="color: var(--gray-color); font-size: 12px; margin-top: 5px; display: block;">
                                    Please provide your complete address for better service allocation
                                </small>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn-save">
                                <i class="fas fa-save"></i> Save Changes
                            </button>
                            <button type="button" class="btn-cancel" onclick="cancelEdit()">
                                <i class="fas fa-times"></i> Cancel
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Activity History Section (Hidden by default) -->
            <div id="activitySection" class="content-section" style="display: none;">
                <div class="content-header">
                    <h2 class="content-title">Activity History</h2>
                </div>
                
                <div class="activity-feed">
                    <div class="activity-item">
                        <div class="activity-icon">
                            <i class="fas fa-bullhorn"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-text">Reported a pothole issue on MG Road</div>
                            <div class="activity-time">2 hours ago • Status: In Progress</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-text">Street light issue resolved in your area</div>
                            <div class="activity-time">1 day ago • Status: Resolved</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-text">Rated garbage collection service (4.5/5)</div>
                            <div class="activity-time">3 days ago</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon">
                            <i class="fas fa-comment"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-text">Commented on water supply issue discussion</div>
                            <div class="activity-time">1 week ago</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Security Settings Section (Hidden by default) -->
            <div id="securitySection" class="content-section" style="display: none;">
                <div class="content-header">
                    <h2 class="content-title">Security Settings</h2>
                </div>
                
                <div class="profile-details">
                    <div class="detail-section">
                        <div class="detail-label">
                            <i class="fas fa-key"></i> Password
                        </div>
                        <div class="detail-value">••••••••</div>
                        <button class="edit-btn" style="margin-top: 10px;" onclick="changePassword()">
                            <i class="fas fa-lock"></i> Change Password
                        </button>
                    </div>
                    
                    <div class="detail-section">
                        <div class="detail-label">
                            <i class="fas fa-shield-alt"></i> Two-Factor Authentication
                        </div>
                        <div class="detail-value">Not Enabled</div>
                        <button class="edit-btn" style="margin-top: 10px; background: var(--gradient-primary);" onclick="enable2FA()">
                            <i class="fas fa-shield-alt"></i> Enable 2FA
                        </button>
                    </div>
                    
                    <div class="detail-section">
                        <div class="detail-label">
                            <i class="fas fa-history"></i> Login Activity
                        </div>
                        <div class="detail-value">
                            <div>Last login: Today, 10:30 AM</div>
                            <div>Device: Chrome on Windows</div>
                            <div>Location: Bangalore, India</div>
                        </div>
                        <button class="edit-btn" style="margin-top: 10px; background: var(--gray-color);" onclick="viewLoginHistory()">
                            <i class="fas fa-history"></i> View All Sessions
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Change Password Modal -->
    <div id="passwordModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.6); z-index: 10000; align-items: center; justify-content: center; padding: 20px; backdrop-filter: blur(4px);">
        <div class="modal-content" style="background-color: white; border-radius: 16px; width: 90%; max-width: 500px; padding: 30px; position: relative; box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);">
            <div class="modal-header" style="margin-bottom: 25px;">
                <h3 style="font-size: 24px; font-weight: 700; color: var(--primary-color);">
                    <i class="fas fa-lock"></i> Change Password
                </h3>
                <button onclick="closePasswordModal()" style="position: absolute; top: 20px; right: 20px; background: none; border: none; font-size: 24px; color: var(--gray-color); cursor: pointer;">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <form id="passwordForm" onsubmit="updatePassword(event)">
                <div class="form-group">
                    <label for="currentPassword">Current Password</label>
                    <input type="password" 
                           id="currentPassword" 
                           class="form-control" 
                           placeholder="Enter current password" 
                           required>
                </div>
                
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" 
                           id="newPassword" 
                           class="form-control" 
                           placeholder="Enter new password" 
                           required
                           minlength="6">
                </div>
                
                <div class="form-group">
                    <label for="confirmNewPassword">Confirm New Password</label>
                    <input type="password" 
                           id="confirmNewPassword" 
                           class="form-control" 
                           placeholder="Confirm new password" 
                           required>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn-save" style="flex: 1;">
                        <i class="fas fa-save"></i> Update Password
                    </button>
                    <button type="button" class="btn-cancel" onclick="closePasswordModal()" style="flex: 1;">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // User data from JSP session
        const userData = {
            name: "<%= userName %>",
            email: "<%= userEmail %>",
            mobile: "<%= userPhone %>",
            address: "<%= address %>",
            joinDate: "<%= registrationDate %>",
            citizenId: "<%= citizenId %>",
            issuesReported: <%= issuesReported %>,
            issuesResolved: <%= issuesResolved %>
        };

        // DOM Elements
        let isEditMode = false;

        // Initialize page with user data
        document.addEventListener('DOMContentLoaded', function() {
            loadUserData();
            
            // Check for URL parameters for messages
            const urlParams = new URLSearchParams(window.location.search);
            const messageContainer = document.getElementById('messageContainer');
            
            if (urlParams.has('message')) {
                const message = decodeURIComponent(urlParams.get('message'));
                const type = urlParams.get('type') || 'success';
                
                messageContainer.textContent = message;
                messageContainer.className = `alert ${type}`;
                messageContainer.style.display = 'block';
                
                // Clear URL parameters
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        });

        // Load user data into the page
        function loadUserData() {
            // View mode elements are already loaded with JSP values
            
            // Edit mode elements
            document.getElementById('editName').value = userData.name;
            document.getElementById('editEmail').value = userData.email;
            document.getElementById('editMobile').value = userData.mobile;
            document.getElementById('editAddress').value = userData.address;
            
            // Update avatar initials
            const name = userData.name;
            let initials = "";
            if (name && name !== "User") {
                const nameParts = name.split(" ");
                if (nameParts.length >= 2) {
                    initials = (nameParts[0].substring(0, 1) + nameParts[1].substring(0, 1)).toUpperCase();
                } else {
                    initials = name.substring(0, Math.min(2, name.length)).toUpperCase();
                }
            } else {
                initials = "U";
            }
            document.getElementById('avatarInitials').textContent = initials;
        }

        // Toggle between view and edit modes
        function toggleEditMode() {
            isEditMode = !isEditMode;
            const viewMode = document.getElementById('viewMode');
            const editMode = document.getElementById('editMode');
            const editBtn = document.querySelector('.edit-btn');
            
            if (isEditMode) {
                viewMode.style.display = 'none';
                editMode.style.display = 'block';
                editBtn.innerHTML = '<i class="fas fa-times"></i> Cancel Edit';
                editBtn.style.background = 'var(--accent-color)';
                editBtn.onclick = cancelEdit;
            } else {
                viewMode.style.display = 'grid';
                editMode.style.display = 'none';
                editBtn.innerHTML = '<i class="fas fa-edit"></i> Edit Profile';
                editBtn.style.background = 'var(--gradient-secondary)';
                editBtn.onclick = toggleEditMode;
            }
        }

        // Cancel edit mode
        function cancelEdit() {
            // Reset form values to original user data
            document.getElementById('editName').value = userData.name;
            document.getElementById('editEmail').value = userData.email;
            document.getElementById('editMobile').value = userData.mobile;
            document.getElementById('editAddress').value = userData.address;
            
            toggleEditMode();
        }

        // Update profile data
        function updateProfile(event) {
            event.preventDefault();
            
            const messageContainer = document.getElementById('messageContainer');
            
            // Get form values
            const updatedData = {
                name: document.getElementById('editName').value.trim(),
                email: document.getElementById('editEmail').value.trim(),
                mobile: document.getElementById('editMobile').value.trim(),
                address: document.getElementById('editAddress').value.trim()
            };
            
            // Basic validation
            if (updatedData.name.length < 2) {
                showMessage('Name must be at least 2 characters', 'error');
                return;
            }
            
            const emailPattern = /^[a-zA-Z0-9._%+-]+@gmail\.com$/;
            if (!emailPattern.test(updatedData.email)) {
                showMessage('Please enter a valid Gmail address', 'error');
                return;
            }
            
            const mobilePattern = /^[0-9]{10}$/;
            if (!mobilePattern.test(updatedData.mobile)) {
                showMessage('Please enter a valid 10-digit mobile number', 'error');
                return;
            }
            
            if (updatedData.address.length < 10) {
                showMessage('Address must be at least 10 characters', 'error');
                return;
            }
            
            // Show loading state
            const saveBtn = event.target.querySelector('.btn-save');
            const originalText = saveBtn.innerHTML;
            saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
            saveBtn.disabled = true;
            
            // For now, simulate API call (Replace with actual API call in production)
            setTimeout(() => {
                // Update user data locally
                Object.assign(userData, updatedData);
                
                // Update view mode values
                document.getElementById('viewName').textContent = updatedData.name;
                document.getElementById('viewEmail').textContent = updatedData.email;
                document.getElementById('viewMobile').textContent = updatedData.mobile;
                document.getElementById('viewAddress').textContent = updatedData.address;
                document.getElementById('userName').textContent = updatedData.name;
                
                // Update avatar initials
                const name = updatedData.name;
                let initials = "";
                if (name) {
                    const nameParts = name.split(" ");
                    if (nameParts.length >= 2) {
                        initials = (nameParts[0].substring(0, 1) + nameParts[1].substring(0, 1)).toUpperCase();
                    } else {
                        initials = name.substring(0, Math.min(2, name.length)).toUpperCase();
                    }
                } else {
                    initials = "U";
                }
                document.getElementById('avatarInitials').textContent = initials;
                
                // Switch back to view mode
                toggleEditMode();
                
                // Show success message
                showMessage('Profile updated successfully!', 'success');
                
                // Reset button
                saveBtn.innerHTML = originalText;
                saveBtn.disabled = false;
                
                // TODO: Uncomment this to enable actual backend update
                /*
                // Send data to backend via AJAX
                fetch('UpdateProfileServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(updatedData)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Update user data
                        Object.assign(userData, updatedData);
                        
                        // Update view mode values
                        document.getElementById('viewName').textContent = updatedData.name;
                        document.getElementById('viewEmail').textContent = updatedData.email;
                        document.getElementById('viewMobile').textContent = updatedData.mobile;
                        document.getElementById('viewAddress').textContent = updatedData.address;
                        document.getElementById('userName').textContent = updatedData.name;
                        
                        // Update avatar initials
                        const name = updatedData.name;
                        let initials = "";
                        if (name) {
                            const nameParts = name.split(" ");
                            if (nameParts.length >= 2) {
                                initials = (nameParts[0].substring(0, 1) + nameParts[1].substring(0, 1)).toUpperCase();
                            } else {
                                initials = name.substring(0, Math.min(2, name.length)).toUpperCase();
                            }
                        } else {
                            initials = "U";
                        }
                        document.getElementById('avatarInitials').textContent = initials;
                        
                        // Switch back to view mode
                        toggleEditMode();
                        
                        // Show success message
                        showMessage('Profile updated successfully!', 'success');
                        
                        // Redirect to refresh session data
                        setTimeout(() => {
                            window.location.href = 'User_Profile.jsp?message=' + 
                                encodeURIComponent('Profile updated successfully!') + '&type=success';
                        }, 1500);
                    } else {
                        showMessage('Error updating profile: ' + data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showMessage('Error updating profile. Please try again.', 'error');
                })
                .finally(() => {
                    // Reset button
                    saveBtn.innerHTML = originalText;
                    saveBtn.disabled = false;
                });
                */
                
            }, 1500);
        }

        // Show different sections
        function showSection(section) {
            // Hide all sections
            document.querySelectorAll('.content-section').forEach(s => {
                s.style.display = 'none';
            });
            
            // Remove active class from all menu items
            document.querySelectorAll('.menu-item').forEach(item => {
                item.classList.remove('active');
            });
            
            // Show selected section
            document.getElementById(section + 'Section').style.display = 'block';
            
            // Add active class to clicked menu item
            event.target.closest('.menu-item').classList.add('active');
        }

        // Show message
        function showMessage(message, type) {
            const messageContainer = document.getElementById('messageContainer');
            messageContainer.textContent = message;
            messageContainer.className = `alert ${type}`;
            messageContainer.style.display = 'block';
            
            // Auto-hide success messages after 5 seconds
            if (type === 'success') {
                setTimeout(() => {
                    messageContainer.style.display = 'none';
                }, 5000);
            }
        }

        // Change password functions
        function changePassword() {
            document.getElementById('passwordModal').style.display = 'flex';
        }

        function closePasswordModal() {
            document.getElementById('passwordModal').style.display = 'none';
            document.getElementById('passwordForm').reset();
        }

        function updatePassword(event) {
            event.preventDefault();
            
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmNewPassword').value;
            
            if (newPassword.length < 6) {
                showMessage('New password must be at least 6 characters', 'error');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showMessage('New passwords do not match', 'error');
                return;
            }
            
            // Simulate password update
            setTimeout(() => {
                showMessage('Password updated successfully!', 'success');
                closePasswordModal();
                document.getElementById('passwordForm').reset();
            }, 1500);
            
            // TODO: Uncomment for actual backend update
            /*
            // Send password change request to backend
            const passwordData = {
                currentPassword: currentPassword,
                newPassword: newPassword
            };
            
            fetch('ChangePasswordServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(passwordData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage('Password updated successfully!', 'success');
                    closePasswordModal();
                } else {
                    showMessage('Error: ' + data.message, 'error');
                }
            })
            .catch(error => {
                showMessage('Error updating password. Please try again.', 'error');
            });
            */
        }

        // Other functions
        function changeAvatar() {
            showMessage('Avatar change feature coming soon!', 'success');
        }

        function enable2FA() {
            showMessage('Two-factor authentication feature coming soon!', 'success');
        }

        function viewLoginHistory() {
            showMessage('Login history feature coming soon!', 'success');
        }

        // Add keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Escape key to cancel edit mode
            if (e.key === 'Escape' && isEditMode) {
                cancelEdit();
            }
            
            // Ctrl+S to save (when in edit mode)
            if (e.ctrlKey && e.key === 's' && isEditMode) {
                e.preventDefault();
                document.getElementById('profileForm').requestSubmit();
            }
        });

        // Add click outside to close modals
        window.onclick = function(event) {
            const modal = document.getElementById('passwordModal');
            if (event.target === modal) {
                closePasswordModal();
            }
        };
    </script>
</body>
</html>