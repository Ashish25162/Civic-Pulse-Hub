<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="jakarta.servlet.http.HttpSession"%>
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
    String userPhone = (String) userSession.getAttribute("phone");
    String address = (String) userSession.getAttribute("address");
    String registrationDate = (String) userSession.getAttribute("registration_date");
    
    // Set default values if null
    if (userName == null) userName = "User";
    if (userEmail == null) userEmail = "Not provided";
    if (userPhone == null) userPhone = "Not provided";
    if (address == null) address = "Not provided";
    if (registrationDate == null) registrationDate = "Not available";
    
    // Get user initials for avatar
    String userInitials = "";
    if (userName != null && !userName.trim().isEmpty()) {
        String[] nameParts = userName.split(" ");
        if (nameParts.length >= 2) {
            userInitials = (nameParts[0].substring(0, 1) + nameParts[1].substring(0, 1)).toUpperCase();
        } else {
            userInitials = userName.substring(0, Math.min(2, userName.length())).toUpperCase();
        }
    } else {
        userInitials = "U";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Civic Pulse - User Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2a5c82;
            --primary-light: #3a7ca5;
            --primary-dark: #1c3b5a;
            --secondary-color: #4a9c7d;
            --accent-color: #e76f51;
            --warning-color: #e9c46a;
            --info-color: #5a86c2;
            --light-color: #f8f9fa;
            --dark-color: #2d3748;
            --gray-color: #718096;
            --gray-light: #e2e8f0;
            --card-bg: #ffffff;
            --sidebar-bg: #1a202c;
            --sidebar-light: #2d3748;
            --shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            --shadow-hover: 0 8px 25px rgba(0, 0, 0, 0.12);
            --gradient-primary: linear-gradient(135deg, #2a5c82 0%, #3a7ca5 100%);
            --gradient-secondary: linear-gradient(135deg, #4a9c7d 0%, #3a8369 100%);
            --gradient-warning: linear-gradient(135deg, #e9c46a 0%, #d4a95a 100%);
            --gradient-accent: linear-gradient(135deg, #e76f51 0%, #d45f41 100%);
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
        }

        .container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styles - Elegant Dark Theme */
        .sidebar {
            width: 280px;
            background: var(--sidebar-bg);
            padding: 0;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: fixed;
            height: 100%;
            z-index: 100;
            box-shadow: 3px 0 15px rgba(0, 0, 0, 0.1);
            overflow-y: auto;
            transform: translateX(-100%);
        }

        .sidebar.active {
            transform: translateX(0);
        }

        .logo {
            padding: 25px 20px;
            background: rgba(255, 255, 255, 0.03);
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logo-icon {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            box-shadow: 0 4px 12px rgba(42, 92, 130, 0.3);
        }

        .logo-text h1 {
            font-size: 22px;
            color: white;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .logo-text p {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.7);
            margin-top: 2px;
            font-weight: 400;
        }

        .nav-menu {
            list-style: none;
            padding: 25px 0;
        }

        .nav-menu li {
            margin-bottom: 5px;
        }

        .nav-menu a {
            display: flex;
            align-items: center;
            padding: 16px 24px;
            color: rgba(255, 255, 255, 0.85);
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 500;
            font-size: 15px;
            position: relative;
            margin: 0 8px;
            border-radius: 8px;
        }

        /* Hover Effects for Sidebar */
        .nav-menu a:hover {
            background: linear-gradient(90deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.05) 100%);
            color: white;
            transform: translateX(8px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .nav-menu a:hover i {
            transform: scale(1.1);
            color: #8ab4f8;
        }

        .nav-menu a:hover .nav-badge {
            background-color: var(--accent-color);
            transform: scale(1.1);
        }

        .nav-menu a.active {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .nav-menu a.active::before {
            content: '';
            position: absolute;
            left: -8px;
            top: 50%;
            transform: translateY(-50%);
            height: 60%;
            width: 4px;
            background: var(--accent-color);
            border-radius: 0 4px 4px 0;
        }

        .nav-menu a i {
            margin-right: 14px;
            font-size: 18px;
            width: 24px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .nav-menu a .nav-badge {
            margin-left: auto;
            background: var(--accent-color);
            color: white;
            font-size: 11px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .user-info {
            padding: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            margin-top: auto;
            position: absolute;
            bottom: 0;
            width: 100%;
            background: rgba(0, 0, 0, 0.1);
        }

        .user-avatar {
            display: flex;
            align-items: center;
            color: white;
        }

        .avatar-icon {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: var(--gradient-secondary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-right: 12px;
            font-size: 18px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
        }

        .avatar-icon:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.3);
        }

        .user-details h4 {
            font-size: 15px;
            margin-bottom: 4px;
            color: white;
        }

        .user-details p {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.7);
        }

        /* Hamburger Menu Button */
        .hamburger-menu {
            position: fixed;
            top: 25px;
            left: 25px;
            z-index: 99;
            background: var(--gradient-primary);
            color: white;
            border: none;
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(42, 92, 130, 0.3);
            transition: all 0.3s ease;
        }

        .hamburger-menu:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 20px rgba(42, 92, 130, 0.4);
        }

        .hamburger-menu .line {
            width: 24px;
            height: 2px;
            background-color: white;
            margin: 3px 0;
            border-radius: 2px;
            transition: all 0.3s ease;
        }

        .hamburger-menu.active .line:nth-child(1) {
            transform: rotate(45deg) translate(5px, 5px);
        }

        .hamburger-menu.active .line:nth-child(2) {
            opacity: 0;
        }

        .hamburger-menu.active .line:nth-child(3) {
            transform: rotate(-45deg) translate(7px, -6px);
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
            padding: 30px 35px;
            transition: all 0.3s ease;
            background-color: #f8fafc;
            margin-left: 0;
            width: 100%;
        }

        .main-content.shifted {
            margin-left: 280px;
            width: calc(100% - 280px);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 25px;
            margin-bottom: 30px;
            border-bottom: 1px solid var(--gray-light);
            padding-top: 10px;
        }

        .header-left h1 {
            color: var(--dark-color);
            font-size: 30px;
            font-weight: 700;
            margin-bottom: 8px;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            display: inline-block;
        }

        .header-left p {
            color: var(--gray-color);
            font-size: 15px;
            max-width: 600px;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .notification-btn {
            position: relative;
            background: none;
            border: none;
            font-size: 20px;
            color: var(--gray-color);
            cursor: pointer;
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: white;
            box-shadow: var(--shadow);
            transition: all 0.2s;
        }

        .notification-btn:hover {
            background-color: var(--light-color);
            color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        }

        .notification-count {
            position: absolute;
            top: -6px;
            right: -6px;
            background-color: var(--accent-color);
            color: white;
            font-size: 11px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            box-shadow: 0 2px 5px rgba(231, 111, 81, 0.3);
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 14px;
            cursor: pointer;
            padding: 10px 16px;
            border-radius: 12px;
            transition: all 0.2s;
            background: white;
            box-shadow: var(--shadow);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .user-menu:hover {
            background-color: var(--light-color);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        .user-menu-avatar {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 18px;
            box-shadow: 0 4px 10px rgba(42, 92, 130, 0.2);
            transition: all 0.3s ease;
        }

        .user-menu-avatar:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 15px rgba(42, 92, 130, 0.3);
        }

        .user-menu-text h4 {
            font-size: 15px;
            font-weight: 700;
            margin-bottom: 4px;
            color: var(--dark-color);
        }

        .user-menu-text p {
            font-size: 13px;
            color: var(--gray-color);
        }

        /* Dashboard Stats Cards */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .stat-card {
            background-color: var(--card-bg);
            border-radius: 16px;
            padding: 28px;
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(0, 0, 0, 0.03);
            cursor: pointer;
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-hover);
            border-color: var(--primary-light);
        }

        .stat-card:hover .stat-icon {
            transform: scale(1.05);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 6px;
            height: 100%;
            background: var(--gradient-primary);
        }

        .stat-card.submitted::before {
            background: var(--gradient-primary);
        }

        .stat-card.in-progress::before {
            background: var(--gradient-warning);
        }

        .stat-card.resolved::before {
            background: var(--gradient-secondary);
        }

        .stat-card.escalated::before {
            background: var(--gradient-accent);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .stat-card.submitted .stat-icon {
            background: var(--gradient-primary);
        }

        .stat-card.in-progress .stat-icon {
            background: var(--gradient-warning);
        }

        .stat-card.resolved .stat-icon {
            background: var(--gradient-secondary);
        }

        .stat-card.escalated .stat-icon {
            background: var(--gradient-accent);
        }

        .stat-value {
            font-size: 36px;
            font-weight: 800;
            color: var(--dark-color);
            line-height: 1;
        }

        .stat-label {
            color: var(--gray-color);
            font-size: 15px;
            margin-top: 8px;
            font-weight: 500;
        }

        .stat-trend {
            font-size: 14px;
            margin-top: 12px;
            display: flex;
            align-items: center;
            font-weight: 600;
        }

        /* Quick Actions */
        .quick-actions {
            background-color: var(--card-bg);
            border-radius: 16px;
            padding: 30px;
            box-shadow: var(--shadow);
            margin-bottom: 40px;
            border: 1px solid rgba(0, 0, 0, 0.03);
        }

        .section-title {
            font-size: 22px;
            font-weight: 700;
            color: var(--dark-color);
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f4f8;
        }

        .section-title i {
            margin-right: 12px;
            color: var(--primary-color);
            background: rgba(42, 92, 130, 0.1);
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .action-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 130px;
            height: 110px;
            background-color: white;
            border-radius: 12px;
            border: 1px solid #eef2f7;
            cursor: pointer;
            transition: all 0.3s ease;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.03);
        }

        .action-btn:hover {
            background-color: #f8fafc;
            border-color: var(--primary-light);
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(42, 92, 130, 0.12);
        }

        .action-btn:hover i {
            transform: scale(1.1);
            color: var(--accent-color);
        }

        .action-btn i {
            font-size: 26px;
            color: var(--primary-color);
            margin-bottom: 12px;
            transition: all 0.3s ease;
        }

        .action-btn span {
            font-size: 14px;
            font-weight: 600;
            color: var(--dark-color);
            text-align: center;
        }

        /* Recent Grievances Table */
        .recent-grievances {
            background-color: var(--card-bg);
            border-radius: 16px;
            padding: 30px;
            box-shadow: var(--shadow);
            margin-bottom: 40px;
            border: 1px solid rgba(0, 0, 0, 0.03);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .table-container {
            overflow-x: auto;
            border-radius: 12px;
            border: 1px solid #eef2f7;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.03);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 850px;
        }

        thead {
            background: linear-gradient(to right, #f8fafc, #f1f5f9);
        }

        th {
            padding: 18px 24px;
            text-align: left;
            font-weight: 700;
            color: var(--dark-color);
            border-bottom: 2px solid var(--gray-light);
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 18px 24px;
            border-bottom: 1px solid #f0f4f8;
            font-size: 14px;
        }

        tbody tr {
            transition: all 0.2s;
        }

        tbody tr:hover {
            background-color: #f8fafc;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            display: inline-block;
            letter-spacing: 0.3px;
            transition: all 0.3s ease;
        }

        .status-badge:hover {
            transform: scale(1.05);
        }

        .status-submitted {
            background-color: #e8f0fe;
            color: var(--primary-color);
            border: 1px solid rgba(42, 92, 130, 0.2);
        }

        .status-in-progress {
            background-color: #fef7e0;
            color: #b08c2c;
            border: 1px solid rgba(233, 196, 106, 0.2);
        }

        .status-under-review {
            background-color: #f3e8fd;
            color: #7c3aed;
            border: 1px solid rgba(124, 58, 237, 0.2);
        }

        .status-resolved {
            background-color: #e6f4ea;
            color: var(--secondary-color);
            border: 1px solid rgba(74, 156, 125, 0.2);
        }

        .status-escalated {
            background-color: #fce8e6;
            color: var(--accent-color);
            border: 1px solid rgba(231, 111, 81, 0.2);
        }

        .action-btns {
            display: flex;
            gap: 10px;
        }

        .action-icon {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8fafc;
            color: var(--gray-color);
            border: 1px solid #eef2f7;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .action-icon:hover {
            background-color: var(--primary-light);
            color: white;
            border-color: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(42, 92, 130, 0.2);
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #1c3b5a 0%, #2a5c82 100%);
            box-shadow: 0 6px 18px rgba(42, 92, 130, 0.3);
        }

        .btn-outline {
            background-color: transparent;
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
        }

        .btn-outline:hover {
            background-color: rgba(42, 92, 130, 0.05);
            box-shadow: 0 4px 12px rgba(42, 92, 130, 0.1);
        }

        /* Form Styles */
        .form-container {
            background-color: var(--card-bg);
            border-radius: 16px;
            padding: 35px;
            box-shadow: var(--shadow);
            border: 1px solid rgba(0, 0, 0, 0.03);
        }

        .form-section {
            margin-bottom: 35px;
        }

        .form-section h3 {
            font-size: 20px;
            font-weight: 700;
            color: var(--dark-color);
            margin-bottom: 25px;
            padding-bottom: 12px;
            border-bottom: 2px solid #f0f4f8;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 25px;
            margin-bottom: 25px;
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
        }

        .form-control {
            width: 100%;
            padding: 14px 18px;
            border: 1px solid var(--gray-light);
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            background-color: white;
        }

        .form-control:hover {
            border-color: var(--primary-light);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(42, 92, 130, 0.2);
        }

        textarea.form-control {
            min-height: 140px;
            resize: vertical;
        }

        /* Tracking Timeline */
        .timeline {
            position: relative;
            padding-left: 35px;
            margin-top: 25px;
        }

        .timeline::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 3px;
            background: linear-gradient(to bottom, var(--primary-color), var(--secondary-color));
        }

        .timeline-item {
            position: relative;
            margin-bottom: 28px;
        }

        .timeline-item:last-child {
            margin-bottom: 0;
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: -38px;
            top: 5px;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background-color: white;
            border: 4px solid var(--primary-color);
            box-shadow: 0 0 0 4px rgba(42, 92, 130, 0.1);
        }

        .timeline-item.current::before {
            background-color: var(--accent-color);
            border-color: var(--accent-color);
            box-shadow: 0 0 0 4px rgba(231, 111, 81, 0.2);
        }

        .timeline-date {
            font-size: 14px;
            color: var(--gray-color);
            margin-bottom: 6px;
            font-weight: 600;
        }

        .timeline-title {
            font-weight: 700;
            margin-bottom: 6px;
            color: var(--dark-color);
            font-size: 16px;
        }

        .timeline-desc {
            font-size: 14px;
            color: var(--gray-color);
            line-height: 1.6;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            padding: 20px;
            backdrop-filter: blur(4px);
        }

        .modal-content {
            background-color: white;
            border-radius: 16px;
            width: 100%;
            max-width: 750px;
            max-height: 90vh;
            overflow-y: auto;
            padding: 35px;
            position: relative;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .close-modal {
            position: absolute;
            top: 20px;
            right: 20px;
            font-size: 26px;
            background: none;
            border: none;
            cursor: pointer;
            color: var(--gray-color);
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            transition: all 0.2s;
            background: #f8fafc;
        }

        .close-modal:hover {
            background-color: var(--accent-color);
            color: white;
        }

        /* Add this additional CSS for feature under development popup */
        .feature-popup {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            z-index: 10000;
            align-items: center;
            justify-content: center;
            padding: 20px;
            backdrop-filter: blur(4px);
        }
        
        .feature-popup-content {
            background-color: white;
            border-radius: 16px;
            width: 90%;
            max-width: 450px;
            padding: 30px;
            position: relative;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(0, 0, 0, 0.05);
            text-align: center;
        }
        
        .feature-icon {
            font-size: 50px;
            color: #e9c46a;
            margin-bottom: 20px;
        }
        
        .feature-title {
            font-size: 24px;
            font-weight: 700;
            color: #2a5c82;
            margin-bottom: 15px;
        }
        
        .feature-message {
            font-size: 16px;
            color: #718096;
            line-height: 1.6;
            margin-bottom: 25px;
        }
        
        .close-popup {
            background: linear-gradient(135deg, #2a5c82 0%, #3a7ca5 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .close-popup:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(42, 92, 130, 0.3);
        }
        
        .logout-btn {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: linear-gradient(135deg, #e76f51 0%, #d45f41 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            z-index: 100;
            box-shadow: 0 4px 12px rgba(231, 111, 81, 0.3);
        }

        /* Profile Redirect Link Styles */
        .profile-redirect-link {
            text-decoration: none;
            display: block;
            color: inherit;
            transition: all 0.3s ease;
        }

        .profile-redirect-link:hover .section-title {
            background-color: rgba(42, 92, 130, 0.05);
            color: var(--primary-color);
            border-radius: 10px;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .profile-redirect-link:hover .section-title i {
            background: rgba(42, 92, 130, 0.2);
            transform: scale(1.1);
        }

        .profile-redirect-link .section-title {
            cursor: pointer;
            position: relative;
            transition: all 0.3s ease;
        }

        .profile-redirect-link .section-title::after {
            content: "→ View Full Profile";
            font-size: 14px;
            color: var(--primary-color);
            margin-left: 15px;
            font-weight: 600;
            opacity: 0;
            transition: all 0.3s ease;
        }

        .profile-redirect-link:hover .section-title::after {
            opacity: 1;
        }

        /* Responsive Styles */
        @media (max-width: 992px) {
            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .action-buttons {
                justify-content: center;
            }
            
            .header-left h1 {
                font-size: 26px;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 25px;
            }
            
            .stats-container {
                grid-template-columns: 1fr;
            }
            
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 20px;
            }
            
            .header-actions {
                width: 100%;
                justify-content: space-between;
            }
            
            .user-menu-text {
                display: none;
            }
            
            .action-btn {
                width: calc(50% - 10px);
            }
            
            .profile-redirect-link .section-title::after {
                font-size: 12px;
            }
        }

        @media (max-width: 576px) {
            .main-content {
                padding: 20px;
            }
            
            .action-btn {
                width: 100%;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .profile-redirect-link .section-title::after {
                content: "→";
                font-size: 16px;
            }
        }

        /* Animation for page transitions */
        .dashboard-section {
            animation: fadeIn 0.4s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Custom Scrollbar */
        .sidebar::-webkit-scrollbar {
            width: 6px;
        }
        
        .sidebar::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.05);
        }
        
        .sidebar::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 3px;
        }
        
        .sidebar::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        
        .table-container::-webkit-scrollbar {
            height: 8px;
        }
        
        .table-container::-webkit-scrollbar-track {
            background: #f1f5f9;
            border-radius: 4px;
        }
        
        .table-container::-webkit-scrollbar-thumb {
            background: #cbd5e0;
            border-radius: 4px;
        }
        
        .table-container::-webkit-scrollbar-thumb:hover {
            background: #a0aec0;
        }

        /* Overlay for mobile */
        .sidebar-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 99;
            display: none;
            backdrop-filter: blur(3px);
        }

        .sidebar-overlay.active {
            display: block;
        }
        
        
        
        
    </style>
</head>
<body>
    <!-- Feature Under Development Popup -->
    <div class="feature-popup" id="featurePopup">
        <div class="feature-popup-content">
            <div class="feature-icon">
                <i class="fas fa-tools"></i>
            </div>
            <div class="feature-title">🚧 Feature Under Development</div>
            <div class="feature-message">
                This feature is currently being developed and will be available soon!<br><br>
                Expected Release: Q2 2024
            </div>
            <button class="close-popup" onclick="closeFeaturePopup()">OK</button>
        </div>
    </div>
    
    <!-- Logout Button -->
    <button class="logout-btn" onclick="location.href='User_Logout'">
        <i class="fas fa-sign-out-alt"></i> Logout
    </button>
    
    <!-- Hamburger Menu Button -->
    <button class="hamburger-menu" id="hamburgerMenu">
        <div class="line"></div>
        <div class="line"></div>
        <div class="line"></div>
    </button>
    
    <!-- Sidebar Overlay for Mobile -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>
    
    <div class="container">
        <!-- Sidebar -->
        <aside class="sidebar" id="sidebar">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fas fa-heartbeat"></i>
                </div>
                <div class="logo-text">
                    <h1>CIVIC PULSE</h1>
                    <p>Smart City Feedback System</p>
                </div>
            </div>
            
            <ul class="nav-menu">
                <li>
                    <a href="#" class="active" data-section="dashboard">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="Submit_Grievance.html">
                        <i class="fas fa-plus-circle"></i>
                        <span>Submit Grievance</span>
                        <span class="nav-badge">New</span>
                    </a>
                </li>
                <li>
                    <a href="#" data-section="track-status">
                        <i class="fas fa-search-location"></i>
                        <span>Track Status</span>
                    </a>
                </li>
                <li>
                    <a href="Grievance_History.jsp"> <!-- Changed from data-section -->
                        <i class="fas fa-history"></i>
                        <span>Grievance History</span>
                    </a>
                </li>
                <li>
                    <a href="User_Profile.jsp">
                        <i class="fas fa-user-cog"></i>
                        <span>My Profile</span>
                    </a>
                </li>
                <li>
                    <a href="#" data-section="notifications">
                        <i class="fas fa-bell"></i>
                        <span>Notifications</span>
                        <span class="nav-badge">3</span>
                    </a>
                </li>
                <li>
                    <a href="#">
                        <i class="fas fa-question-circle"></i>
                        <span>Help Center</span>
                    </a>
                </li>
                <li>
    <a href="User_Logout">
        <i class="fas fa-sign-out-alt"></i>
        <span>Logout</span>
    </a>
</li>
            </ul>
            
            <div class="user-info">
                <div class="user-avatar">
                    <div class="avatar-icon"><%= userInitials %></div>
                    <div class="user-details">
                        <h4><%= userName %></h4>
                        <p>Smart City Citizen</p>
                    </div>
                </div>
            </div>
        </aside>
        
        <!-- Main Content -->
        <main class="main-content" id="mainContent">
            <!-- Header -->
            <div class="header">
                <div class="header-left"><br>
                    <h1 id="pageTitle">Smart City Dashboard</h1>
                    <p>Welcome back <%=userName%>! Monitor your civic engagements and track feedback resolutions.</p>
                </div>
                
                <div class="header-actions">
                    <button class="notification-btn">
                        <i class="fas fa-bell"></i>
                        <span class="notification-count">3</span>
                    </button>
                    
                    <a href="User_Profile.jsp" class="user-menu" id="userMenu" style="text-decoration: none;">
                        <div class="user-menu-avatar"><%=userInitials %></div>
                        <div class="user-menu-text">
                            <h4><%=userName %></h4>
                            <p>User ID: <%=userSession.getAttribute("user_id") %></p>
                        </div>
                        <i class="fas fa-chevron-down"></i>
                    </a>
                </div>
            </div>
            
            <!-- Dashboard Section (Default View) -->
            <section id="dashboard" class="dashboard-section active">
                <!-- Stats Cards -->
                <div class="stats-container">
                    <div class="stat-card submitted">
                        <div class="stat-header">
                            <div>
                                <div class="stat-value">12</div>
                                <div class="stat-label">Submitted Grievances</div>
                            </div>
                            <div class="stat-icon">
                                <i class="fas fa-paper-plane"></i>
                            </div>
                        </div>
                        <div class="stat-trend">
                            <span style="color: var(--secondary-color);">
                                <i class="fas fa-arrow-up"></i> 2 new this week
                            </span>
                        </div>
                    </div>
                    
                    <div class="stat-card in-progress">
                        <div class="stat-header">
                            <div>
                                <div class="stat-value">5</div>
                                <div class="stat-label">In Progress</div>
                            </div>
                            <div class="stat-icon">
                                <i class="fas fa-spinner fa-pulse"></i>
                            </div>
                        </div>
                        <div class="stat-trend">
                            <span style="color: #b08c2c;">
                                Avg. resolution time: 14 days
                            </span>
                        </div>
                    </div>
                    
                    <div class="stat-card resolved">
                        <div class="stat-header">
                            <div>
                                <div class="stat-value">6</div>
                                <div class="stat-label">Resolved</div>
                            </div>
                            <div class="stat-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                        </div>
                        <div class="stat-trend">
                            <span style="color: var(--secondary-color);">
                                <i class="fas fa-star"></i> 92% satisfaction
                            </span>
                        </div>
                    </div>
                    
                    <div class="stat-card escalated">
                        <div class="stat-header">
                            <div>
                                <div class="stat-value">1</div>
                                <div class="stat-label">Escalated</div>
                            </div>
                            <div class="stat-icon">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                        </div>
                        <div class="stat-trend">
                            <span style="color: var(--accent-color);">
                                Requires attention
                            </span>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="quick-actions">
                    <div class="section-title">
                        <i class="fas fa-bolt"></i> Quick Actions
                    </div>
                    <div class="action-buttons">
                        <a href="Submit_Grievance.html" class="action-btn" id="quickSubmit" style="text-decoration: none;">
                            <i class="fas fa-plus-circle"></i>
                            <span>Submit Grievance</span>
                        </a>
                        <button class="action-btn" id="quickTrack">
                            <i class="fas fa-search-location"></i>
                            <span>Track Status</span>
                        </button>
                        <a href="Grievance_History.jsp" class="action-btn" id="quickHistory" style="text-decoration: none;">
                           <i class="fas fa-history"></i>
                           <span>View History</span>
                        </a>
                        <button class="action-btn" id="quickNotifications">
                            <i class="fas fa-bell"></i>
                            <span>Notifications</span>
                        </button>
                        <button class="action-btn" id="quickHelp">
                            <i class="fas fa-question-circle"></i>
                            <span>Help Center</span>
                        </button>
                        <a href="User_Profile.jsp" class="action-btn" id="quickProfile" style="text-decoration: none;">
                            <i class="fas fa-user-cog"></i>
                            <span>My Profile</span>
                        </a>
                    </div>
                </div>
                
                <!-- Recent Grievances -->
                <div class="recent-grievances">
                    <div class="table-header">
                        <div class="section-title">
                            <i class="fas fa-list"></i> Recent Grievances
                        </div>
                        <a href="Grievance_History.jsp" class="btn btn-outline" id="viewAllBtn" style="text-decoration: none;">
                        <i class="fas fa-eye"></i> View All
                       </a>
                    </div>
                    
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Category</th>
                                    <th>Date Submitted</th>
                                    <th>Status</th>
                                    <th>Last Updated</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><strong>CP-2023-0456</strong></td>
                                    <td>Road & Infrastructure</td>
                                    <td>Oct 12, 2023</td>
                                    <td><span class="status-badge status-in-progress">In Progress</span></td>
                                    <td>Oct 18, 2023</td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-icon view-btn" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="action-icon track-btn" title="Track">
                                                <i class="fas fa-search"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>CP-2023-0412</strong></td>
                                    <td>Sanitation</td>
                                    <td>Sep 28, 2023</td>
                                    <td><span class="status-badge status-resolved">Resolved</span></td>
                                    <td>Oct 15, 2023</td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-icon view-btn" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="action-icon feedback-btn" title="Provide Feedback">
                                                <i class="fas fa-star"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>CP-2023-0389</strong></td>
                                    <td>Water Supply</td>
                                    <td>Sep 15, 2023</td>
                                    <td><span class="status-badge status-under-review">Under Review</span></td>
                                    <td>Oct 10, 2023</td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-icon view-btn" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="action-icon track-btn" title="Track">
                                                <i class="fas fa-search"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>CP-2023-0321</strong></td>
                                    <td>Electricity</td>
                                    <td>Aug 22, 2023</td>
                                    <td><span class="status-badge status-escalated">Escalated</span></td>
                                    <td>Oct 5, 2023</td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-icon view-btn" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="action-icon contact-btn" title="Contact Officer">
                                                <i class="fas fa-phone"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
            
            <!-- Track Status Section -->
            <section id="track-status" class="dashboard-section">
                <div class="section-title">
                    <i class="fas fa-search-location"></i> Track Grievance Status
                </div>
                
                <div class="form-container">
                    <div class="form-group">
                        <label for="trackingId">Enter Grievance ID</label>
                        <div style="display: flex; gap: 10px; max-width: 500px;">
                            <input type="text" id="trackingId" class="form-control" placeholder="e.g., CP-2023-0456">
                            <button class="btn btn-primary" id="trackBtn">
                                <i class="fas fa-search"></i> Track
                            </button>
                        </div>
                        <small style="color: var(--gray-color); font-size: 13px; display: block; margin-top: 5px;">
                            You can find your Grievance ID in your email confirmation or in the Grievance History section.
                        </small>
                    </div>
                    
                    <div id="trackingResult" style="display: none; margin-top: 30px;">
                        <div class="form-section">
                            <h3>Grievance Details</h3>
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Grievance ID</label>
                                    <input type="text" class="form-control" value="CP-2023-0456" readonly style="font-weight: bold;">
                                </div>
                                
                                <div class="form-group">
                                    <label>Status</label>
                                    <input type="text" class="form-control" value="In Progress" readonly style="font-weight: bold; color: #b08c2c;">
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Category</label>
                                    <input type="text" class="form-control" value="Road & Infrastructure" readonly>
                                </div>
                                
                                <div class="form-group">
                                    <label>Submitted On</label>
                                    <input type="text" class="form-control" value="October 12, 2023" readonly>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Description</label>
                                <textarea class="form-control" readonly>Large pothole on Oak Street between 5th and 6th Avenue, causing traffic disruption and vehicle damage. Approximately 2 feet wide and 6 inches deep.</textarea>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h3>Status Timeline</h3>
                            <div class="timeline">
                                <div class="timeline-item">
                                    <div class="timeline-date">October 12, 2023</div>
                                    <div class="timeline-title">Grievance Submitted</div>
                                    <div class="timeline-desc">Your grievance has been registered successfully and assigned to the Road Department.</div>
                                </div>
                                
                                <div class="timeline-item">
                                    <div class="timeline-date">October 14, 2023</div>
                                    <div class="timeline-title">Under Review</div>
                                    <div class="timeline-desc">Officer John Smith has been assigned to review your grievance.</div>
                                </div>
                                
                                <div class="timeline-item">
                                    <div class="timeline-date">October 16, 2023</div>
                                    <div class="timeline-title">Site Inspection Scheduled</div>
                                    <div class="timeline-desc">A site inspection has been scheduled for October 20, 2023.</div>
                                </div>
                                
                                <div class="timeline-item current">
                                    <div class="timeline-date">October 18, 2023</div>
                                    <div class="timeline-title">In Progress</div>
                                    <div class="timeline-desc">Repair work has been initiated. Expected completion date: October 25, 2023.</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            
            <!-- Grievance History Section -->
            <section id="grievance-history" class="dashboard-section">
                <div class="section-title">
                    <i class="fas fa-history"></i> Grievance History
                </div>
                
                <div class="form-container">
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Title</th>
                                    <th>Category</th>
                                    <th>Submitted</th>
                                    <th>Status</th>
                                    <th>Resolved</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><strong>CP-2023-0412</strong></td>
                                    <td>Garbage not collected</td>
                                    <td>Sanitation</td>
                                    <td>Sep 28, 2023</td>
                                    <td><span class="status-badge status-resolved">Resolved</span></td>
                                    <td>Oct 15, 2023</td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-icon view-btn" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="action-icon feedback-btn" title="Provide Feedback">
                                                <i class="fas fa-star"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>CP-2023-0389</strong></td>
                                    <td>Water pipeline leakage</td>
                                    <td>Water Supply</td>
                                    <td>Sep 15, 2023</td>
                                    <td><span class="status-badge status-resolved">Resolved</span></td>
                                    <td>Oct 5, 2023</td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-icon view-btn" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="action-icon feedback-btn" title="Provide Feedback">
                                                <i class="fas fa-star"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>CP-2023-0321</strong></td>
                                    <td>Street light not working</td>
                                    <td>Electricity</td>
                                    <td>Aug 22, 2023</td>
                                    <td><span class="status-badge status-resolved">Resolved</span></td>
                                    <td>Sep 10, 2023</td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-icon view-btn" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>CP-2023-0287</strong></td>
                                    <td>Park maintenance needed</td>
                                    <td>Parks & Recreation</td>
                                    <td>Aug 5, 2023</td>
                                    <td><span class="status-badge status-resolved">Resolved</span></td>
                                    <td>Aug 25, 2023</td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-icon view-btn" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
            
            <!-- Profile Section -->
            <section id="profile" class="dashboard-section">
                <a href="User_Profile.jsp" class="profile-redirect-link">
                    <div class="section-title">
                        <i class="fas fa-user-cog"></i> My Profile
                    </div>
                </a>
                
                <div class="form-container">
                    <div class="form-section">
                        <h3>Personal Information</h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="fullName">Full Name</label>
                                <input type="text" id="fullName" class="form-control" value="<%= userName %>" readonly>
                            </div>
                            
                            <div class="form-group">
                                <label for="email">Email Address</label>
                                <input type="email" id="email" class="form-control" value="<%= userEmail %>" readonly>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="text" id="phone" class="form-control" value="<%= userPhone %>" readonly>
                            </div>
                            
                            <div class="form-group">
                                <label for="address">Address</label>
                                <input type="text" id="address" class="form-control" value="<%= address %>" readonly>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="registrationDate">Registration Date</label>
                                <input type="text" id="registrationDate" class="form-control" value="<%= registrationDate %>" readonly>
                            </div>
                        </div>
                        
                        <div class="form-group" style="margin-top: 30px;">
                            <a href="User_Profile.jsp" class="btn btn-primary" id="editProfileBtn" style="text-decoration: none;">
                                <i class="fas fa-edit"></i> Edit Profile
                            </a>
                            <button class="btn" style="background-color: #f8fafc; color: var(--dark-color); border: 1px solid #eef2f7; margin-left: 10px;">
                                <i class="fas fa-key"></i> Change Password
                            </button>
                        </div>
                    </div>
                </div>
            </section>
            
            <!-- Notifications Section -->
            <section id="notifications" class="dashboard-section">
                <div class="section-title">
                    <i class="fas fa-bell"></i> Notifications
                </div>
                
                <div class="form-container">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h3 style="font-size: 20px; font-weight: 700; color: var(--dark-color);">Recent Notifications</h3>
                        <button class="btn" style="background-color: #f8fafc; color: var(--dark-color); border: 1px solid #eef2f7; font-size: 14px;">
                            <i class="fas fa-check-circle"></i> Mark All as Read
                        </button>
                    </div>
                    
                    <div style="border: 1px solid #eef2f7; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.03);">
                        <div style="padding: 22px; border-bottom: 1px solid #eef2f7; background-color: #f8fafc;">
                            <div style="display: flex; align-items: flex-start;">
                                <div style="background: var(--gradient-primary); color: white; width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; margin-right: 16px; flex-shrink: 0;">
                                    <i class="fas fa-info-circle"></i>
                                </div>
                                <div>
                                    <div style="font-weight: 700; margin-bottom: 6px; color: var(--dark-color);">Status Update: CP-2023-0456</div>
                                    <div style="font-size: 14px; color: var(--gray-color); line-height: 1.6;">Your grievance regarding "Pothole on Oak Street" is now In Progress. Repair work has been initiated.</div>
                                    <div style="font-size: 13px; color: var(--gray-color); margin-top: 8px;"><i class="far fa-clock"></i> October 18, 2023 · 2 hours ago</div>
                                </div>
                            </div>
                        </div>
                        
                        <div style="padding: 22px; border-bottom: 1px solid #eef2f7;">
                            <div style="display: flex; align-items: flex-start;">
                                <div style="background: var(--gradient-secondary); color: white; width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; margin-right: 16px; flex-shrink: 0;">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div>
                                    <div style="font-weight: 700; margin-bottom: 6px; color: var(--dark-color);">Grievance Resolved: CP-2023-0412</div>
                                    <div style="font-size: 14px; color: var(--gray-color); line-height: 1.6;">Your grievance regarding "Garbage not collected" has been resolved. Please provide your feedback.</div>
                                    <div style="font-size: 13px; color: var(--gray-color); margin-top: 8px;"><i class="far fa-clock"></i> October 15, 2023 · 3 days ago</div>
                                </div>
                            </div>
                        </div>
                        
                        <div style="padding: 22px;">
                            <div style="display: flex; align-items: flex-start;">
                                <div style="background: var(--gradient-warning); color: white; width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; margin-right: 16px; flex-shrink: 0;">
                                    <i class="fas fa-exclamation-circle"></i>
                                </div>
                                <div>
                                    <div style="font-weight: 700; margin-bottom: 6px; color: var(--dark-color);">New Response: CP-2023-0389</div>
                                    <div style="font-size: 14px; color: var(--gray-color); line-height: 1.6;">Officer John Smith has added a comment to your grievance regarding "Water pipeline leakage".</div>
                                    <div style="font-size: 13px; color: var(--gray-color); margin-top: 8px;"><i class="far fa-clock"></i> October 10, 2023 · 1 week ago</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
    </div>
    
    <!-- Modal for Grievance Details -->
    <div class="modal" id="grievanceModal">
        <div class="modal-content">
            <button class="close-modal" id="closeModal">&times;</button>
            <h2 style="margin-bottom: 20px; color: var(--dark-color);">Grievance Details</h2>
            <div id="modalContent">
                <!-- Modal content will be loaded here -->
            </div>
        </div>
    </div>
    
  <script>
    // JavaScript to show feature under development popup
    function showFeaturePopup() {
        document.getElementById('featurePopup').style.display = 'flex';
    }
    
    function closeFeaturePopup() {
        document.getElementById('featurePopup').style.display = 'none';
    }
    
    // DOM Elements
    const sidebar = document.getElementById('sidebar');
    const hamburgerMenu = document.getElementById('hamburgerMenu');
    const sidebarOverlay = document.getElementById('sidebarOverlay');
    const mainContent = document.getElementById('mainContent');
    const navLinks = document.querySelectorAll('.nav-menu a');
    const pageTitle = document.getElementById('pageTitle');
    const sections = document.querySelectorAll('.dashboard-section');
    const quickSubmit = document.getElementById('quickSubmit');
    const quickTrack = document.getElementById('quickTrack');
    const quickHistory = document.getElementById('quickHistory');
    const quickNotifications = document.getElementById('quickNotifications');
    const quickHelp = document.getElementById('quickHelp');
    const viewAllBtn = document.getElementById('viewAllBtn');
    const trackBtn = document.getElementById('trackBtn');
    const trackingResult = document.getElementById('trackingResult');
    const grievanceModal = document.getElementById('grievanceModal');
    const closeModal = document.getElementById('closeModal');
    const viewButtons = document.querySelectorAll('.view-btn');
    
    // Toggle Sidebar Function
    function toggleSidebar() {
        sidebar.classList.toggle('active');
        hamburgerMenu.classList.toggle('active');
        sidebarOverlay.classList.toggle('active');
        mainContent.classList.toggle('shifted');
    }
    
    // Close Sidebar Function
    function closeSidebar() {
        sidebar.classList.remove('active');
        hamburgerMenu.classList.remove('active');
        sidebarOverlay.classList.remove('active');
        mainContent.classList.remove('shifted');
    }
    
    // Hamburger Menu Toggle
    hamburgerMenu.addEventListener('click', toggleSidebar);
    
    // Close sidebar when clicking on overlay
    sidebarOverlay.addEventListener('click', closeSidebar);
    
    // Navigation handling - ONLY for data-section links
    navLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            // Get href and data-section
            const href = link.getAttribute('href');
            const sectionId = link.getAttribute('data-section');
            
            // If it's a data-section link (for in-page navigation)
            if (sectionId && !href) {
                e.preventDefault();
                
                // Remove active class from all links
                navLinks.forEach(item => item.classList.remove('active'));
                
                // Add active class to clicked link
                link.classList.add('active');
                
                // Update page title
                const sectionName = link.querySelector('span').textContent;
                pageTitle.textContent = sectionName;
                
                // Hide all sections
                sections.forEach(section => {
                    section.classList.remove('active');
                });
                
                // Show selected section
                document.getElementById(sectionId).classList.add('active');
                
                // Close sidebar on mobile after selection
                if (window.innerWidth <= 768) {
                    closeSidebar();
                }
            }
            // If it's a logout link, let it navigate normally
            else if (href && href.includes('Logout')) {
                // Let the browser handle logout navigation
                return true;
            }
            // If it has href (external link), let it navigate normally
            else if (href && (href === '#' || href.startsWith('http') || href.endsWith('.jsp') || href.endsWith('.html'))) {
                // Let the browser handle the navigation
                // No need for preventDefault()
            }
            // For links without href but also without data-section
            else {
                e.preventDefault();
                showFeaturePopup();
            }
        });
    });
    
    // Quick Actions navigation
    quickTrack.addEventListener('click', (e) => {
        // Only show popup for track status (since it's not a separate page)
        e.preventDefault();
        showFeaturePopup();
    });
    
    // quickHistory is now an <a> tag with href, so it will redirect automatically
    // No need for click handler
    
    quickNotifications.addEventListener('click', (e) => {
        // This is a button, not a link, so show popup
        e.preventDefault();
        showFeaturePopup();
    });
    
    quickHelp.addEventListener('click', (e) => {
        e.preventDefault();
        showFeaturePopup();
    });
    
    // View All button - FIXED (now it's an <a> tag, will redirect automatically)
    // No need for click handler
    
    // Track Grievance
    trackBtn.addEventListener('click', (e) => {
        e.preventDefault();
        
        const trackingId = document.getElementById('trackingId').value.trim();
        
        if (!trackingId) {
            showNotification('Please enter a grievance ID to track.', 'error');
            return;
        }
        
        // Validate the format (simple validation)
        if (!trackingId.startsWith('CP-')) {
            showNotification('Please enter a valid Grievance ID (format: CP-YYYY-XXXX)', 'error');
            return;
        }
        
        // Show tracking result (simulated)
        trackingResult.style.display = 'block';
        
        // Scroll to result
        trackingResult.scrollIntoView({ behavior: 'smooth', block: 'start' });
        
        // Show success notification
        showNotification(`Tracking grievance: ${trackingId}`, 'info');
    });
    
    // View Details buttons
    viewButtons.forEach(button => {
        button.addEventListener('click', () => {
            // Set modal content
            document.getElementById('modalContent').innerHTML = `
                <div class="form-section">
                    <h3>Grievance Details</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Grievance ID</label>
                            <input type="text" class="form-control" value="CP-2023-0456" readonly>
                        </div>
                        
                        <div class="form-group">
                            <label>Status</label>
                            <input type="text" class="form-control" value="In Progress" readonly style="font-weight: bold; color: #b08c2c;">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Category</label>
                            <input type="text" class="form-control" value="Road & Infrastructure" readonly>
                        </div>
                        
                        <div class="form-group">
                            <label>Priority</label>
                            <input type="text" class="form-control" value="High" readonly>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Title</label>
                        <input type="text" class="form-control" value="Pothole on Oak Street" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>Location</label>
                        <input type="text" class="form-control" value="Oak Street between 5th and 6th Avenue" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>Description</label>
                        <textarea class="form-control" readonly>Large pothole on Oak Street between 5th and 6th Avenue, causing traffic disruption and vehicle damage. Approximately 2 feet wide and 6 inches deep. Reported after a car suffered tire damage.</textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Submitted On</label>
                            <input type="text" class="form-control" value="October 12, 2023" readonly>
                        </div>
                        
                        <div class="form-group">
                            <label>Last Updated</label>
                            <input type="text" class="form-control" value="October 18, 2023" readonly>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Assigned Officer</label>
                        <input type="text" class="form-control" value="John Smith, Road Department" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>Officer Comments</label>
                        <textarea class="form-control" readonly>Site inspection completed. Repair work scheduled for October 20-25, 2023. Temporary signage has been placed to alert drivers.</textarea>
                    </div>
                </div>
                
                <div style="display: flex; gap: 10px; margin-top: 30px;">
                    <button class="btn btn-primary" onclick="document.getElementById('grievanceModal').style.display='none'">
                        Close
                    </button>
                    <button class="btn" style="background-color: #f8fafc; color: var(--dark-color); border: 1px solid #eef2f7;">
                        <i class="fas fa-print"></i> Print Details
                    </button>
                </div>
            `;
            
            // Show modal
            grievanceModal.style.display = 'flex';
        });
    });
    
    // Close modal
    closeModal.addEventListener('click', () => {
        grievanceModal.style.display = 'none';
    });
    
    // Close modal when clicking outside
    window.addEventListener('click', (e) => {
        if (e.target === grievanceModal) {
            grievanceModal.style.display = 'none';
        }
    });
    
    // Utility function to show notifications
    function showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div');
        
        // Set base styles
        notification.style.position = 'fixed';
        notification.style.top = '25px';
        notification.style.right = '25px';
        notification.style.padding = '18px 22px';
        notification.style.color = 'white';
        notification.style.borderRadius = '12px';
        notification.style.boxShadow = '0 8px 25px rgba(0,0,0,0.15)';
        notification.style.zIndex = '10000';
        notification.style.fontWeight = '600';
        notification.style.display = 'flex';
        notification.style.alignItems = 'center';
        notification.style.gap = '12px';
        notification.style.animation = 'slideIn 0.3s ease';
        notification.style.maxWidth = '400px';
        
        // Set type-specific styles
        if (type === 'success') {
            notification.style.backgroundColor = 'var(--secondary-color)';
            notification.style.borderLeft = '5px solid #3a8369';
        } else if (type === 'error') {
            notification.style.backgroundColor = 'var(--accent-color)';
            notification.style.borderLeft = '5px solid #d45f41';
        } else {
            notification.style.backgroundColor = 'var(--primary-color)';
            notification.style.borderLeft = '5px solid #1c3b5a';
        }
        
        // Add icon based on type
        let icon = 'info-circle';
        if (type === 'success') icon = 'check-circle';
        if (type === 'error') icon = 'exclamation-circle';
        
        notification.innerHTML = `<i class="fas fa-${icon}"></i> ${message}`;
        
        // Add to body
        document.body.appendChild(notification);
        
        // Remove after 5 seconds
        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease';
            setTimeout(() => {
                document.body.removeChild(notification);
            }, 300);
        }, 5000);
    }
    
    // Add CSS for notification animations
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        @keyframes slideOut {
            from { transform: translateX(0); opacity: 1; }
            to { transform: translateX(100%); opacity: 0; }
        }
    `;
    document.head.appendChild(style);
    
    // Initialize when page loads
    document.addEventListener('DOMContentLoaded', function() {
        // Only add popup to buttons that don't have href (are not links)
        const popupButtons = ['quickTrack', 'quickNotifications', 'quickHelp'];
        popupButtons.forEach(btnId => {
            const btn = document.getElementById(btnId);
            if (btn && !btn.hasAttribute('href')) {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    showFeaturePopup();
                });
            }
        });
        
        // Add to action buttons in table (these should show popup)
        document.querySelectorAll('.action-icon').forEach(btn => {
            // Don't add to logout buttons
            if (!btn.closest('.logout-btn') && !btn.closest('a[href*="Logout"]')) {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    showFeaturePopup();
                });
            }
        });
        
        // Prevent feature popup on logout button click
        const logoutButton = document.querySelector('.logout-btn');
        if (logoutButton) {
            logoutButton.addEventListener('click', function(e) {
                // Don't prevent default - let it navigate to logout
                // Don't show feature popup
            });
        }
        
        // Initialize with user greeting
        const hour = new Date().getHours();
        let greeting = 'Good morning';
        if (hour >= 12 && hour < 17) greeting = 'Good afternoon';
        if (hour >= 17) greeting = 'Good evening';
        
        document.querySelector('.header-left p').textContent = 
            `${greeting} <%= userName %>! Monitor your civic engagements and track grievance resolutions.`;
        
        // Add some subtle animations to cards on load
        const cards = document.querySelectorAll('.stat-card');
        cards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.1}s`;
        });
        
        // Set current date in dashboard
        const today = new Date();
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        const dateString = today.toLocaleDateString('en-US', options);
        
        // Update dashboard greeting
        document.querySelector('.header-left p').textContent = `${greeting} <%= userName %>! Monitor your civic engagements and track grievance resolutions. Today is ${dateString}.`;
        
        // Auto-close sidebar on larger screens
        if (window.innerWidth > 768) {
            setTimeout(() => {
                toggleSidebar();
            }, 500);
        }
        
        // Add interactivity to action buttons in table
        document.querySelectorAll('.track-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const row = this.closest('tr');
                const grievanceId = row.querySelector('td:first-child strong').textContent;
                document.getElementById('trackingId').value = grievanceId;
                document.querySelector('a[data-section="track-status"]').click();
                
                // Trigger track after a short delay
                setTimeout(() => {
                    document.getElementById('trackBtn').click();
                }, 300);
            });
        });
        
        document.querySelectorAll('.feedback-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                showNotification('Feedback feature will be available soon!', 'info');
            });
        });
        
        document.querySelectorAll('.contact-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                showNotification('Contact officer feature will be available soon!', 'info');
            });
        });
        
        // Close sidebar when clicking outside on mobile
        document.addEventListener('click', (e) => {
            if (window.innerWidth <= 768 && 
                sidebar.classList.contains('active') && 
                !sidebar.contains(e.target) && 
                !hamburgerMenu.contains(e.target)) {
                closeSidebar();
            }
        });
        
        // Handle window resize
        window.addEventListener('resize', () => {
            if (window.innerWidth > 768) {
                // On larger screens, keep sidebar open
                if (!sidebar.classList.contains('active')) {
                    toggleSidebar();
                }
            } else {
                // On smaller screens, ensure sidebar is closed initially
                if (sidebar.classList.contains('active')) {
                    closeSidebar();
                }
            }
        });
    });
</script>
</body>
</html> 