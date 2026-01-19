<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Check session
     session = request.getSession(false);
    
    // If no session, redirect to login
    if (session == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get operator details for display
    String fullName = (String) request.getAttribute("fullName");
    String operatorId = request.getAttribute("operatorId") != null ? 
                       request.getAttribute("operatorId").toString() : "";
    
    // Fallback to session attributes if request attributes are null
    if (fullName == null) {
        fullName = (String) session.getAttribute("full_name");
    }
    if (operatorId == null || operatorId.isEmpty()) {
        operatorId = session.getAttribute("operator_id") != null ? 
                    session.getAttribute("operator_id").toString() : "";
    }
    
    // Format current time
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy HH:mm:ss");
    String currentTime = sdf.format(new java.util.Date());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout Confirmation</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .logout-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            overflow: hidden;
            animation: slideIn 0.5s ease-out;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .logout-header {
            background: linear-gradient(135deg, #3498db, #2c3e50);
            padding: 40px 30px;
            text-align: center;
            color: white;
        }
        
        .logout-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            color: rgba(255, 255, 255, 0.9);
        }
        
        .logout-header h1 {
            font-size: 2.2rem;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .logout-header p {
            font-size: 1rem;
            opacity: 0.9;
        }
        
        .logout-content {
            padding: 40px 30px;
        }
        
        .user-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 30px;
            border-left: 4px solid #3498db;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 15px;
            align-items: center;
        }
        
        .info-row:last-child {
            margin-bottom: 0;
        }
        
        .info-label {
            font-weight: 600;
            color: #2c3e50;
            width: 120px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-label i {
            width: 20px;
            color: #3498db;
        }
        
        .info-value {
            color: #495057;
            flex: 1;
        }
        
        .logout-time {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .logout-time i {
            color: #f39c12;
        }
        
        .confirmation-message {
            text-align: center;
            margin-bottom: 30px;
            color: #6c757d;
            line-height: 1.6;
        }
        
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }
        
        .btn {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-logout {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }
        
        .btn-logout:hover {
            background: linear-gradient(135deg, #c0392b, #a93226);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
        }
        
        .btn-cancel {
            background: #6c757d;
            color: white;
        }
        
        .btn-cancel:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.3);
        }
        
        .security-note {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #eaeaea;
            color: #6c757d;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .security-note i {
            color: #2ecc71;
        }
        
        /* Responsive Design */
        @media (max-width: 576px) {
            body {
                padding: 15px;
            }
            
            .logout-header {
                padding: 30px 20px;
            }
            
            .logout-content {
                padding: 30px 20px;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .info-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 5px;
            }
            
            .info-label {
                width: 100%;
            }
        }
        
        /* Animation for logout */
        @keyframes fadeOut {
            from {
                opacity: 1;
                transform: scale(1);
            }
            to {
                opacity: 0;
                transform: scale(0.9);
            }
        }
        
        .logging-out {
            animation: fadeOut 0.5s ease-out forwards;
        }
    </style>
</head>
<body>
    <div class="logout-container" id="logoutContainer">
        <div class="logout-header">
            <div class="logout-icon">
                <i class="fas fa-sign-out-alt"></i>
            </div>
            <h1>Logout Confirmation</h1>
            <p>Please confirm your logout request</p>
        </div>
        
        <div class="logout-content">
            <div class="user-info">
                <div class="info-row">
                    <div class="info-label">
                        <i class="fas fa-user"></i> Operator Name
                    </div>
                    <div class="info-value"><%= fullName %></div>
                </div>
                <div class="info-row">
                    <div class="info-label">
                        <i class="fas fa-id-card"></i> Operator ID
                    </div>
                    <div class="info-value">OP-<%= operatorId %></div>
                </div>
                <div class="info-row">
                    <div class="info-label">
                        <i class="fas fa-clock"></i> Session Started
                    </div>
                    <div class="info-value">
                        <%
                            Long creationTime = session.getCreationTime();
                            if (creationTime > 0) {
                                java.text.SimpleDateFormat sessionSdf = new java.text.SimpleDateFormat("HH:mm:ss");
                                out.print(sessionSdf.format(new java.util.Date(creationTime)));
                            } else {
                                out.print("N/A");
                            }
                        %>
                    </div>
                </div>
            </div>
            
            <div class="logout-time">
                <i class="fas fa-clock"></i>
                <span>Current Time: <%= currentTime %></span>
            </div>
            
            <div class="confirmation-message">
                <p>Are you sure you want to logout from the Operator Dashboard?</p>
                <p><strong>Note:</strong> You will need to login again to access your tasks and profile.</p>
            </div>
            
            <form id="logoutForm" action="LogoutServlet" method="POST">
                <div class="button-group">
                    <button type="submit" class="btn btn-logout" id="logoutBtn">
                        <i class="fas fa-sign-out-alt"></i> Confirm Logout
                    </button>
                    <button type="button" class="btn btn-cancel" onclick="cancelLogout()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                </div>
            </form>
            
            <div class="security-note">
                <i class="fas fa-shield-alt"></i>
                <span>For security reasons, please logout when you're done with your session.</span>
            </div>
        </div>
    </div>
    
    <script>
        // Handle logout form submission
        document.getElementById('logoutForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const logoutBtn = document.getElementById('logoutBtn');
            const originalText = logoutBtn.innerHTML;
            
            // Change button to loading state
            logoutBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Logging out...';
            logoutBtn.disabled = true;
            
            // Add fade out animation
            document.getElementById('logoutContainer').classList.add('logging-out');
            
            // Submit form after animation
            setTimeout(() => {
                this.submit();
            }, 500);
        });
        
        // Cancel logout and go back to dashboard
        function cancelLogout() {
            window.history.back();
        }
        
        // Auto-redirect to dashboard if user presses browser back button
        window.addEventListener('pageshow', function(event) {
            if (event.persisted) {
                window.location.href = 'operator-Dashboard.jsp';
            }
        });
        
        // Prevent form resubmission on page refresh
        if (window.history.replaceState) {
            window.history.replaceState(null, null, window.location.href);
        }
        
        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl + L for logout
            if (e.ctrlKey && e.key === 'l') {
                e.preventDefault();
                document.getElementById('logoutBtn').click();
            }
            
            // Escape key to cancel
            if (e.key === 'Escape') {
                cancelLogout();
            }
        });
        
        // Show session timeout warning if applicable
        <% 
            Long lastAccessedTime = session.getLastAccessedTime();
            Long currentTimeMillis = System.currentTimeMillis();
            int maxInactiveInterval = session.getMaxInactiveInterval();
            
            if (maxInactiveInterval > 0) {
                long inactiveTime = (currentTimeMillis - lastAccessedTime) / 1000;
                long remainingTime = maxInactiveInterval - inactiveTime;
                
                if (remainingTime < 300) { // Less than 5 minutes remaining
        %>
                    setTimeout(() => {
                        alert('Your session will expire in ' + <%= remainingTime %> + ' seconds. Please save your work.');
                    }, 1000);
        <%
                }
            }
        %>
    </script>
</body>
</html>