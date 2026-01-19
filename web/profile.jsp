<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Check session
    HttpSession gov_session = request.getSession(false);
    if (gov_session == null || gov_session.getAttribute("operator_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get data from request attributes (set by servlet)
    String fullName = (String) request.getAttribute("fullName");
    String email = (String) request.getAttribute("email");
    String phone = (String) request.getAttribute("phone");
    String department = (String) request.getAttribute("department");
    String createdAt = (String) request.getAttribute("createdAt");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    Integer operatorId = (Integer) request.getAttribute("operatorId");
    
    // Fallback to session data if request attributes are null
    if (fullName == null) fullName = (String) gov_session.getAttribute("full_name");
    if (email == null) email = (String) gov_session.getAttribute("email");
    if (phone == null) phone = (String) gov_session.getAttribute("phone");
    if (operatorId == null) operatorId = (Integer) gov_session.getAttribute("operator_id");
    
    // Default values
    if (fullName == null) fullName = "";
    if (email == null) email = "";
    if (phone == null) phone = "";
    if (department == null) department = "";
    if (createdAt == null) createdAt = "";
    if (successMessage == null) successMessage = "";
    if (errorMessage == null) errorMessage = "";
    if (operatorId == null) operatorId = 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Operator Profile</title>
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
        
        .profile-container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        /* Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #eaeaea;
        }
        
        .header h1 {
            color: #2c3e50;
            font-size: 2rem;
        }
        
        .back-btn {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
        }
        
        .back-btn:hover {
            background-color: #2980b9;
        }
        
        /* Messages */
        .message {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        
        .error {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        
        /* Profile Card */
        .profile-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .profile-header {
            background: linear-gradient(135deg, #3498db, #2c3e50);
            padding: 40px;
            text-align: center;
            color: white;
            position: relative;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: white;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: #3498db;
            border: 5px solid rgba(255, 255, 255, 0.2);
        }
        
        .profile-name {
            font-size: 1.8rem;
            margin-bottom: 5px;
        }
        
        .profile-id {
            font-size: 1rem;
            opacity: 0.9;
        }
        
        /* Tabs */
        .profile-tabs {
            display: flex;
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        
        .tab-btn {
            padding: 15px 30px;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            color: #6c757d;
            border-bottom: 3px solid transparent;
            transition: all 0.3s ease;
        }
        
        .tab-btn.active {
            color: #3498db;
            border-bottom-color: #3498db;
            background: white;
        }
        
        .tab-btn:hover:not(.active) {
            color: #495057;
            background: #e9ecef;
        }
        
        /* Tab Content */
        .tab-content {
            padding: 30px;
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        /* Profile Details */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }
        
        .info-item {
            margin-bottom: 20px;
        }
        
        .info-label {
            font-weight: 600;
            color: #2c3e50;
            display: block;
            margin-bottom: 8px;
            font-size: 0.95rem;
        }
        
        .info-value {
            padding: 12px 15px;
            background: #f8f9fa;
            border-radius: 5px;
            border: 1px solid #dee2e6;
            color: #495057;
            min-height: 46px;
            display: flex;
            align-items: center;
        }
        
        .info-value.empty {
            color: #6c757d;
            font-style: italic;
        }
        
        /* Edit Form */
        .edit-form {
            max-width: 600px;
            margin: 0 auto;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }
        
        .form-text {
            font-size: 0.85rem;
            color: #6c757d;
            margin-top: 5px;
        }
        
        /* Buttons */
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background-color: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #2980b9;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background-color: #218838;
        }
        
        /* Password Strength */
        .password-strength {
            margin-top: 10px;
        }
        
        .strength-bar {
            height: 5px;
            background: #e9ecef;
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: 5px;
        }
        
        .strength-fill {
            height: 100%;
            width: 0%;
            transition: width 0.3s ease, background-color 0.3s ease;
        }
        
        .strength-text {
            font-size: 0.85rem;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .profile-container {
                padding: 0 15px;
            }
            
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .back-btn {
                width: 100%;
                justify-content: center;
            }
            
            .profile-header {
                padding: 30px 20px;
            }
            
            .profile-tabs {
                flex-direction: column;
            }
            
            .tab-btn {
                text-align: left;
                border-bottom: 1px solid #dee2e6;
            }
            
            .btn-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <!-- Header -->
        <div class="header">
            <h1><i class="fas fa-user-circle"></i> Operator Profile</h1>
            <a href="operator-Dashboard.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
        
        <!-- Messages -->
        <% if (successMessage != null && !successMessage.isEmpty()) { %>
            <div class="message success">
                <i class="fas fa-check-circle"></i> <%= successMessage %>
            </div>
        <% } %>
        
        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="message error">
                <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
            </div>
        <% } %>
        
        <!-- Profile Card -->
        <div class="profile-card">
            <!-- Profile Header -->
            <div class="profile-header">
                <div class="profile-avatar">
                    <i class="fas fa-user-tie"></i>
                </div>
                <h2 class="profile-name"><%= fullName %></h2>
                <p class="profile-id">Operator ID: OP-<%= operatorId %></p>
            </div>
            
            <!-- Tabs -->
            <div class="profile-tabs">
                <button class="tab-btn active" onclick="switchTab('view')">
                    <i class="fas fa-eye"></i> View Profile
                </button>
                <button class="tab-btn" onclick="switchTab('edit')">
                    <i class="fas fa-edit"></i> Edit Profile
                </button>
                <button class="tab-btn" onclick="switchTab('password')">
                    <i class="fas fa-key"></i> Change Password
                </button>
            </div>
            
            <!-- View Profile Tab -->
            <div id="view-tab" class="tab-content active">
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Full Name</span>
                        <div class="info-value"><%= fullName %></div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Email Address</span>
                        <div class="info-value"><%= email %></div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Phone Number</span>
                        <div class="info-value <%= (phone == null || phone.isEmpty()) ? "empty" : "" %>">
                            <%= (phone == null || phone.isEmpty()) ? "Not provided" : phone %>
                        </div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Department</span>
                        <div class="info-value"><%= department %></div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Operator ID</span>
                        <div class="info-value">OP-<%= operatorId %></div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Account Created</span>
                        <div class="info-value"><%= createdAt %></div>
                    </div>
                </div>
                
                <div class="btn-group">
                    <button class="btn btn-primary" onclick="switchTab('edit')">
                        <i class="fas fa-edit"></i> Edit Profile
                    </button>
                </div>
            </div>
            
            <!-- Edit Profile Tab -->
            <div id="edit-tab" class="tab-content">
                <form id="editForm" action="ProfileServlet" method="POST" class="edit-form">
                    <input type="hidden" name="action" value="updateProfile">
                    
                    <div class="form-group">
                        <label class="form-label" for="full_name">Full Name *</label>
                        <input type="text" id="full_name" name="full_name" class="form-control" 
                               value="<%= fullName %>" 
                               required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="email">Email Address *</label>
                        <input type="email" id="email" name="email" class="form-control" 
                               value="<%= email %>" 
                               required>
                        <div class="form-text">This is your login email</div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" class="form-control" 
                               value="<%= phone %>" 
                               pattern="[0-9]{10}" maxlength="10">
                        <div class="form-text">10-digit phone number without country code</div>
                    </div>
                    
                    
                    
                    <div class="btn-group">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="switchTab('view')">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Change Password Tab -->
            <div id="password-tab" class="tab-content">
                <form id="passwordForm" action="ProfileServlet" method="POST" class="edit-form">
                    <input type="hidden" name="action" value="changePassword">
                    
                    <div class="form-group">
                        <label class="form-label" for="current_password">Current Password *</label>
                        <input type="password" id="current_password" name="current_password" 
                               class="form-control" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="new_password">New Password *</label>
                        <input type="password" id="new_password" name="new_password" 
                               class="form-control" required minlength="8">
                        <div class="form-text">Minimum 8 characters</div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="confirm_password">Confirm New Password *</label>
                        <input type="password" id="confirm_password" name="confirm_password" 
                               class="form-control" required>
                    </div>
                    
                    <div class="btn-group">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-key"></i> Change Password
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="switchTab('view')">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Tab switching functionality
        function switchTab(tabName) {
            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Remove active class from all tab buttons
            document.querySelectorAll('.tab-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            
            // Show selected tab
            document.getElementById(tabName + '-tab').classList.add('active');
            
            // Activate corresponding button
            document.querySelectorAll('.tab-btn').forEach(btn => {
                if (btn.textContent.includes(tabName.charAt(0).toUpperCase() + tabName.slice(1))) {
                    btn.classList.add('active');
                }
            });
        }
        
        // Form validation
        document.getElementById('editForm').addEventListener('submit', function(e) {
            const phone = document.getElementById('phone').value;
            if (phone && !/^\d{10}$/.test(phone)) {
                e.preventDefault();
                alert('Please enter a valid 10-digit phone number');
                document.getElementById('phone').focus();
                return false;
            }
            return true;
        });
        
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('new_password').value;
            const confirmPassword = document.getElementById('confirm_password').value;
            
            // Password validation
            if (newPassword.length < 8) {
                e.preventDefault();
                alert('Password must be at least 8 characters long');
                return false;
            }
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html>