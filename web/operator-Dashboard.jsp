<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    // Get the session
    HttpSession gov_session = request.getSession(false);
    
    // Check if session exists and has required attributes
    if (gov_session == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String fullName = (String) gov_session.getAttribute("full_name");
    String email = (String) gov_session.getAttribute("email");
    String phone = (String) gov_session.getAttribute("phone");
    Object operatorIdObj = gov_session.getAttribute("operator_id");
    String operatorId = "";
    
    if (operatorIdObj != null) {
        operatorId = operatorIdObj.toString();
    }
    
    // Redirect to login if any required attribute is missing
    if (fullName == null || email == null || phone == null || operatorId.isEmpty()) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Format current date/time for display
    SimpleDateFormat sdf = new SimpleDateFormat("EEEE, MMMM dd, yyyy HH:mm:ss");
    String currentDateTime = sdf.format(new Date());
    
    // Get last login time from session or use current time
    String lastLogin = (String) gov_session.getAttribute("last_login");
    if (lastLogin == null) {
        lastLogin = currentDateTime;
        gov_session.setAttribute("last_login", lastLogin);
    }
    
    // URL encode full name for avatar
    String encodedName = java.net.URLEncoder.encode(fullName, "UTF-8");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Operator Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }
        
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar Styling */
        .sidebar {
            width: 250px;
            background: linear-gradient(180deg, #2c3e50, #1a2530);
            color: #fff;
            padding: 20px 0;
            box-shadow: 3px 0 15px rgba(0, 0, 0, 0.1);
            position: fixed;
            height: 100vh;
            z-index: 100;
        }
        
        .logo {
            text-align: center;
            padding: 0 20px 30px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .logo h2 {
            font-size: 1.8rem;
            font-weight: 600;
            color: #3498db;
        }
        
        .logo p {
            font-size: 0.9rem;
            color: #bdc3c7;
            margin-top: 5px;
        }
        
        .nav-menu {
            margin-top: 30px;
        }
        
        .nav-item {
            list-style: none;
            margin-bottom: 5px;
        }
        
        .nav-link {
            display: flex;
            align-items: center;
            padding: 15px 25px;
            color: #bdc3c7;
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }
        
        .nav-link:hover, .nav-link.active {
            background-color: rgba(52, 152, 219, 0.1);
            color: #fff;
            border-left-color: #3498db;
        }
        
        .nav-link i {
            font-size: 1.2rem;
            margin-right: 15px;
            width: 25px;
        }
        
        /* Main Content Area */
        .main-content {
            flex: 1;
            margin-left: 250px;
            padding: 20px;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0 30px;
        }
        
        .header h1 {
            color: #2c3e50;
            font-size: 1.8rem;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            background: white;
            padding: 10px 20px;
            border-radius: 50px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
        }
        
        .user-info img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            border: 2px solid #3498db;
        }
        
        /* Dashboard Cards */
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 10px;
        }
        
        .card {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            cursor: pointer;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        
        .card-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            font-size: 1.8rem;
        }
        
        .task-card .card-icon {
            background-color: rgba(52, 152, 219, 0.1);
            color: #3498db;
        }
        
        .history-card .card-icon {
            background-color: rgba(46, 204, 113, 0.1);
            color: #2ecc71;
        }
        
        .profile-card .card-icon {
            background-color: rgba(155, 89, 182, 0.1);
            color: #9b59b6;
        }
        
        .card h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: #2c3e50;
        }
        
        .card p {
            color: #7f8c8d;
            margin-bottom: 25px;
        }
        
        .card-btn {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            max-width: 200px;
        }
        
        .task-card .card-btn {
            background-color: #3498db;
        }
        
        .history-card .card-btn {
            background-color: #2ecc71;
        }
        
        .profile-card .card-btn {
            background-color: #9b59b6;
        }
        
        .card-btn:hover {
            opacity: 0.9;
        }
        
        .card-btn i {
            margin-left: 8px;
        }
        
        /* Operator Info Section */
        .operator-info {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-top: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }
        
        .operator-info h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            padding: 10px 0;
        }
        
        .info-item i {
            width: 40px;
            height: 40px;
            background: rgba(52, 152, 219, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #3498db;
            margin-right: 15px;
            font-size: 1.1rem;
        }
        
        .info-label {
            font-weight: 600;
            color: #2c3e50;
            display: block;
            margin-bottom: 5px;
        }
        
        .info-value {
            color: #7f8c8d;
        }
        
        /* Footer */
        .footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #eaeaea;
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        
        /* Responsive Design */
        @media (max-width: 992px) {
            .dashboard-cards {
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .sidebar {
                width: 70px;
                overflow: hidden;
            }
            
            .logo h2, .logo p, .nav-link span {
                display: none;
            }
            
            .nav-link {
                justify-content: center;
                padding: 20px 10px;
            }
            
            .nav-link i {
                margin-right: 0;
                font-size: 1.4rem;
            }
            
            .main-content {
                margin-left: 70px;
            }
            
            .dashboard-cards {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 576px) {
            .header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .user-info {
                margin-top: 15px;
                width: 100%;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
        
        /* Session Status */
        .session-status {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 0.85rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .session-status i {
            margin-right: 8px;
        }
        
        .session-id {
            font-family: monospace;
            background: #f8f9fa;
            padding: 2px 6px;
            border-radius: 3px;
            border: 1px solid #dee2e6;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="logo">
                <h2>OpsConsole</h2>
                <p>Operator Dashboard</p>
            </div>
            
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="operator-Dashboard.jsp" class="nav-link active">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="Fetch_Task.jsp" class="nav-link">
                        <i class="fas fa-tasks"></i>
                        <span>View Tasks</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="HistoryServlet" class="nav-link">
                        <i class="fas fa-history"></i>
                        <span>Task History</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="ProfileServlet" class="nav-link">
                        <i class="fas fa-user-circle"></i>
                        <span>Operator Profile</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="LogoutServlet" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
                    </a>
                </li>
            </ul>
        </aside>
        
        <!-- Main Content -->
        <main class="main-content">
            <!-- Session Status Bar -->
            <div class="session-status">
                <div>
                    <i class="fas fa-clock"></i>
                    Current Time: <%= currentDateTime %>
                </div>
            </div>
            
            <header class="header">
                <h1>Operator Dashboard</h1>
                <div class="user-info">
                    <img src="https://ui-avatars.com/api/?name=<%= encodedName %>&background=3498db&color=fff&bold=true&size=40" alt="<%= fullName %>">
                    <div>
                        <div class="user-name"><%= fullName %></div>
                        <div class="user-role">Operator ID: OP-<%= operatorId %></div>
                    </div>
                </div>
            </header>
            
            <div class="dashboard-cards">
                <!-- Task Card -->
                <div class="card task-card">
                    <div class="card-icon">
                        <i class="fas fa-tasks"></i>
                    </div>
                    <h3>View Tasks</h3>
                    <p>Access and manage your assigned tasks. View task details, update status, and complete task assignments.</p>
                    <button class="card-btn" onclick="window.location.href='Fetch_Task.jsp'">
                        Go to Tasks <i class="fas fa-arrow-right"></i>
                    </button>
                </div>
                
                <!-- History Card -->
                <div class="card history-card">
                    <div class="card-icon">
                        <i class="fas fa-history"></i>
                    </div>
                    <h3>Task History</h3>
                    <p>Review completed tasks, track performance metrics, and analyze historical task data.</p>
                    <button class="card-btn" onclick="window.location.href='HistoryServlet'">
                        View History <i class="fas fa-arrow-right"></i>
                    </button>
                </div>
                
                <!-- Profile Card -->
                <div class="card profile-card">
                    <div class="card-icon">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <h3>Operator Profile</h3>
                    <p>Manage your account details, update personal information, and change password or preferences.</p>
                    <button class="card-btn" onclick="window.location.href='ProfileServlet'">
                        View Profile <i class="fas fa-arrow-right"></i>
                    </button>
                </div>
            </div>
            
            <!-- Operator Information Section -->
            <div class="operator-info">
                <h3><i class="fas fa-user-tie"></i> Operator Details</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <i class="fas fa-id-card"></i>
                        <div>
                            <span class="info-label">Full Name</span>
                            <span class="info-value"><%= fullName %></span>
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-envelope"></i>
                        <div>
                            <span class="info-label">Email Address</span>
                            <span class="info-value"><%= email %></span>
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-phone"></i>
                        <div>
                            <span class="info-label">Phone Number</span>
                            <span class="info-value"><%= phone %></span>
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-fingerprint"></i>
                        <div>
                            <span class="info-label">Operator ID</span>
                            <span class="info-value">OP-<%= operatorId %></span>
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-calendar-alt"></i>
                        <div>
                            <span class="info-label">Last Login</span>
                            <span class="info-value"><%= lastLogin %></span>
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-user-shield"></i>
                        <div>
                            <span class="info-label">Account Status</span>
                            <span class="info-value" style="color: #2ecc71; font-weight: 600;">Active</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <footer class="footer">
                <p>Operator Dashboard v2.1 &copy; 2023 | All actions are logged for security purposes</p>
                <p>Session started: <span id="sessionTime"><%= currentDateTime %></span></p>
            </footer>
        </main>
    </div>
    
    <script>
        // Initialize when page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Set active navigation link
            const navLinks = document.querySelectorAll('.nav-link');
            navLinks.forEach(link => {
                link.classList.remove('active');
                if (link.href === window.location.href) {
                    link.classList.add('active');
                }
            });
            
            // Make cards clickable
            const cards = document.querySelectorAll('.card');
            cards.forEach(card => {
                card.addEventListener('click', function(e) {
                    if (!e.target.classList.contains('card-btn')) {
                        const btn = this.querySelector('.card-btn');
                        if (btn) {
                            window.location.href = btn.onclick.toString().match(/window\.location\.href='([^']+)'/)[1];
                        }
                    }
                });
            });
        });
        
        // Session timeout warning
        let idleTime = 0;
        setInterval(() => {
            idleTime++;
            if (idleTime > 25) { // 25 minutes
                showSessionWarning();
            }
        }, 60000);
        
        // Reset idle timer on user activity
        document.addEventListener('mousemove', resetIdleTimer);
        document.addEventListener('keypress', resetIdleTimer);
        
        function resetIdleTimer() {
            idleTime = 0;
        }
        
        function showSessionWarning() {
            alert('Your session will expire in 5 minutes due to inactivity. Please save your work.');
        }
    </script>
</body>
</html>