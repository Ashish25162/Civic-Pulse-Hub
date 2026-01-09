<%-- 
    Document   : user_feedback
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
        <title>Civic Pulse - Provide Feedback</title>
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
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                padding: 20px;
            }

            .container {
                max-width: 800px;
                width: 100%;
            }

            .header {
                background: linear-gradient(135deg, var(--secondary-color) 0%, #5cb487 100%);
                color: white;
                padding: 30px;
                border-radius: 15px 15px 0 0;
                box-shadow: 0 4px 15px rgba(74, 156, 125, 0.2);
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

            .feedback-form {
                background-color: white;
                padding: 40px;
                border-radius: 0 0 15px 15px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            }

            .form-group {
                margin-bottom: 25px;
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

            .rating-container {
                display: flex;
                gap: 10px;
                margin-bottom: 15px;
            }

            .rating-star {
                font-size: 32px;
                color: #e2e8f0;
                cursor: pointer;
                transition: color 0.3s ease;
            }

            .rating-star:hover,
            .rating-star.active {
                color: #f4a261;
            }

            .rating-labels {
                display: flex;
                justify-content: space-between;
                font-size: 14px;
                color: var(--gray-color);
            }

            .btn {
                padding: 12px 30px;
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
                font-size: 16px;
                margin-right: 15px;
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

            .alert {
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .alert-info {
                background-color: #e8f0fe;
                color: var(--primary-color);
                border-left: 4px solid var(--primary-color);
            }

            .alert-warning {
                background-color: #fef7e0;
                color: #b08c2c;
                border-left: 4px solid #e9c46a;
            }

            .grievance-info {
                background-color: #f8fafc;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 30px;
                border-left: 4px solid var(--secondary-color);
            }

            .grievance-info h3 {
                margin-bottom: 10px;
                color: var(--dark-color);
            }

            .grievance-info p {
                color: var(--gray-color);
                margin-bottom: 5px;
            }

            .back-link {
                display: inline-block;
                margin-top: 20px;
                color: var(--primary-color);
                text-decoration: none;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .back-link:hover {
                text-decoration: underline;
            }

            .checkbox-group {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 10px;
            }

            .checkbox-group input {
                width: 18px;
                height: 18px;
            }

            .success-message {
                text-align: center;
                padding: 40px;
            }

            .success-message i {
                font-size: 64px;
                color: var(--secondary-color);
                margin-bottom: 20px;
            }

            .success-message h2 {
                color: var(--dark-color);
                margin-bottom: 15px;
            }

            .success-message p {
                color: var(--gray-color);
                margin-bottom: 30px;
                max-width: 500px;
                margin-left: auto;
                margin-right: auto;
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
            int userId = 0;
            
            if (userSession.getAttribute("user_id") != null) {
                try {
                    userId = Integer.parseInt(userSession.getAttribute("user_id").toString());
                } catch (Exception e) {
                    userId = 0;
                }
            }
            
            // Get grievance ID from request parameter
            String grievanceIdParam = request.getParameter("id");
            int grievanceId = 0;
            String grievanceTitle = "";
            boolean isResolved = false;
            boolean feedbackSubmitted = false;
            
            if (grievanceIdParam != null && !grievanceIdParam.isEmpty()) {
                try {
                    grievanceId = Integer.parseInt(grievanceIdParam);
                } catch (Exception e) {
                    response.sendRedirect("Grievance_History.jsp");
                    return;
                }
            } else {
                response.sendRedirect("Grievance_History.jsp");
                return;
            }
            
            // Check if grievance exists and is resolved
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/civic_pulse_hub", "root", "Ashu@@3450");
                
                // USING CORRECT COLUMN NAMES
                PreparedStatement ps = cn.prepareStatement(
                    "SELECT title, Status FROM reports WHERE Report_id = ? AND User_id = ?"
                );
                ps.setInt(1, grievanceId);
                ps.setInt(2, userId);
                
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    grievanceTitle = rs.getString("title");
                    isResolved = "resolved".equalsIgnoreCase(rs.getString("Status"));
                } else {
                    response.sendRedirect("Grievance_History.jsp");
                    return;
                }
                
                rs.close();
                ps.close();
                
                // Check if feedback already submitted
                DatabaseMetaData meta = cn.getMetaData();
                ResultSet tables = meta.getTables(null, null, "feedback", null);
                
                if (tables.next()) {
                    // Table exists, check for feedback
                    PreparedStatement psFeedback = cn.prepareStatement(
                        "SELECT COUNT(*) as count FROM feedback WHERE report_id = ? AND user_id = ?"
                    );
                    psFeedback.setInt(1, grievanceId);
                    psFeedback.setInt(2, userId);
                    
                    ResultSet rsFeedback = psFeedback.executeQuery();
                    if (rsFeedback.next()) {
                        feedbackSubmitted = rsFeedback.getInt("count") > 0;
                    }
                    
                    rsFeedback.close();
                    psFeedback.close();
                }
                
                tables.close();
                cn.close();
                
            } catch (Exception ex) {
                out.println("<div class='alert alert-info'><i class='fas fa-exclamation-circle'></i> Error: " + ex.toString() + "</div>");
            }
            
            // Check if form was submitted
            boolean formSubmitted = "POST".equalsIgnoreCase(request.getMethod());
            boolean success = false;
            
            if (formSubmitted && !feedbackSubmitted && isResolved) {
                String ratingStr = request.getParameter("rating");
                String comments = request.getParameter("comments");
                String satisfaction = request.getParameter("satisfaction");
                String timeliness = request.getParameter("timeliness");
                String communication = request.getParameter("communication");
                String allowPublic = request.getParameter("allow_public");
                
                try {
                    int rating = Integer.parseInt(ratingStr);
                    
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/civic_pulse_hub", "root", "Ashu@@3450");
                    
                    // Check if feedback table exists, create if not
                    DatabaseMetaData meta = cn.getMetaData();
                    ResultSet tables = meta.getTables(null, null, "feedback", null);
                    
                    if (!tables.next()) {
                        // Create feedback table
                        Statement stmt = cn.createStatement();
                        String createTableSQL = "CREATE TABLE IF NOT EXISTS feedback (" +
                            "id INT AUTO_INCREMENT PRIMARY KEY, " +
                            "report_id INT NOT NULL, " +
                            "user_id INT NOT NULL, " +
                            "rating INT NOT NULL, " +
                            "comments TEXT, " +
                            "satisfaction_level ENUM('very_satisfied', 'satisfied', 'neutral', 'dissatisfied', 'very_dissatisfied'), " +
                            "timeliness ENUM('excellent', 'good', 'average', 'poor', 'very_poor'), " +
                            "communication ENUM('excellent', 'good', 'average', 'poor', 'very_poor'), " +
                            "is_public BOOLEAN DEFAULT FALSE, " +
                            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
                        stmt.execute(createTableSQL);
                        stmt.close();
                    }
                    tables.close();
                    
                    // Insert feedback
                    PreparedStatement ps = cn.prepareStatement(
                        "INSERT INTO feedback (report_id, user_id, rating, comments, satisfaction_level, timeliness, communication, is_public) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
                    );
                    
                    ps.setInt(1, grievanceId);
                    ps.setInt(2, userId);
                    ps.setInt(3, rating);
                    ps.setString(4, comments);
                    ps.setString(5, satisfaction);
                    ps.setString(6, timeliness);
                    ps.setString(7, communication);
                    ps.setBoolean(8, "on".equals(allowPublic));
                    
                    int rows = ps.executeUpdate();
                    success = rows > 0;
                    
                    ps.close();
                    
                    if (success) {
                        feedbackSubmitted = true;
                    }
                    
                    cn.close();
                    
                } catch (Exception ex) {
                    out.println("<div class='alert alert-info'><i class='fas fa-exclamation-circle'></i> Error submitting feedback: " + ex.toString() + "</div>");
                }
            }
        %>
        
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-star"></i> Provide Feedback</h1>
                <p>Share your experience regarding the resolution of your grievance.</p>
            </div>
            
            <div class="feedback-form">
                <% if (!isResolved) { %>
                <div class="alert alert-info">
                    <i class="fas fa-exclamation-circle"></i>
                    <div>
                        <strong>Feedback cannot be submitted.</strong>
                        <p>Feedback can only be provided for resolved grievances. The selected grievance is not yet resolved.</p>
                    </div>
                </div>
                
                <div style="text-align: center; margin-top: 30px;">
                    <a href="Grievance_Details.jsp?id=<%= grievanceId %>" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Grievance Details
                    </a>
                </div>
                
                <% } else if (feedbackSubmitted && !formSubmitted) { %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i>
                    <h2>Feedback Already Submitted</h2>
                    <p>You have already submitted feedback for this grievance. Thank you for your valuable input!</p>
                    <div style="display: flex; justify-content: center; gap: 15px;">
                        <a href="Grievance_Details.jsp?id=<%= grievanceId %>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Details
                        </a>
                        <a href="Grievance_History.jsp" class="btn btn-primary">
                            <i class="fas fa-history"></i> View History
                        </a>
                    </div>
                </div>
                
                <% } else if (success) { %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i>
                    <h2>Thank You for Your Feedback!</h2>
                    <p>Your feedback has been successfully submitted. Your input helps us improve our services.</p>
                    <div style="display: flex; justify-content: center; gap: 15px;">
                        <a href="Grievance_Details.jsp?id=<%= grievanceId %>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Details
                        </a>
                        <a href="Grievance_History.jsp" class="btn btn-primary">
                            <i class="fas fa-history"></i> View History
                        </a>
                    </div>
                </div>
                
                <% } else { %>
                <div class="grievance-info">
                    <h3><i class="fas fa-file-alt"></i> <%= grievanceTitle %></h3>
                    <p><strong>Grievance ID:</strong> CP-<%= grievanceId %></p>
                    <p>Please share your experience regarding the resolution of this grievance.</p>
                </div>
                
                <form method="POST" action="user_feedback.jsp?id=<%= grievanceId %>">
                    <div class="form-group">
                        <label class="form-label">Overall Rating</label>
                        <div class="rating-container">
                            <span class="rating-star" data-value="1">★</span>
                            <span class="rating-star" data-value="2">★</span>
                            <span class="rating-star" data-value="3">★</span>
                            <span class="rating-star" data-value="4">★</span>
                            <span class="rating-star" data-value="5">★</span>
                        </div>
                        <div class="rating-labels">
                            <span>Very Poor</span>
                            <span>Excellent</span>
                        </div>
                        <input type="hidden" name="rating" id="rating" value="5" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Satisfaction with Resolution</label>
                        <select class="form-control" name="satisfaction" required>
                            <option value="">Select satisfaction level</option>
                            <option value="very_satisfied">Very Satisfied</option>
                            <option value="satisfied">Satisfied</option>
                            <option value="neutral">Neutral</option>
                            <option value="dissatisfied">Dissatisfied</option>
                            <option value="very_dissatisfied">Very Dissatisfied</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Timeliness of Resolution</label>
                        <select class="form-control" name="timeliness" required>
                            <option value="">Select timeliness rating</option>
                            <option value="excellent">Excellent - Resolved quickly</option>
                            <option value="good">Good - Resolved within reasonable time</option>
                            <option value="average">Average - Took longer than expected</option>
                            <option value="poor">Poor - Took too long to resolve</option>
                            <option value="very_poor">Very Poor - Unacceptable delay</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Communication & Updates</label>
                        <select class="form-control" name="communication" required>
                            <option value="">Select communication rating</option>
                            <option value="excellent">Excellent - Regular updates provided</option>
                            <option value="good">Good - Adequate communication</option>
                            <option value="average">Average - Minimal updates</option>
                            <option value="poor">Poor - Poor communication</option>
                            <option value="very_poor">Very Poor - No communication</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Additional Comments</label>
                        <textarea class="form-control" name="comments" placeholder="Please provide any additional comments or suggestions..." rows="4"></textarea>
                    </div>
                    
                    <div class="form-group">
                        <div class="checkbox-group">
                            <input type="checkbox" id="allow_public" name="allow_public">
                            <label for="allow_public">Allow my feedback to be displayed publicly (anonymously)</label>
                        </div>
                    </div>
                    
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 30px;">
                        <a href="Grievance_Details.jsp?id=<%= grievanceId %>" class="back-link">
                            <i class="fas fa-arrow-left"></i> Back to Grievance Details
                        </a>
                        
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane"></i> Submit Feedback
                        </button>
                    </div>
                </form>
                <% } %>
            </div>
        </div>
        
        <script>
            // Rating stars functionality
            document.addEventListener('DOMContentLoaded', function() {
                const stars = document.querySelectorAll('.rating-star');
                const ratingInput = document.getElementById('rating');
                
                stars.forEach(star => {
                    star.addEventListener('click', function() {
                        const value = this.getAttribute('data-value');
                        ratingInput.value = value;
                        
                        // Update star display
                        stars.forEach(s => {
                            if (parseInt(s.getAttribute('data-value')) <= parseInt(value)) {
                                s.classList.add('active');
                            } else {
                                s.classList.remove('active');
                            }
                        });
                    });
                    
                    // Initialize with 5 stars active
                    if (parseInt(star.getAttribute('data-value')) <= 5) {
                        star.classList.add('active');
                    }
                });
                
                // Form validation
                const form = document.querySelector('form');
                if (form) {
                    form.addEventListener('submit', function(e) {
                        const rating = ratingInput.value;
                        const satisfaction = document.querySelector('[name="satisfaction"]').value;
                        const timeliness = document.querySelector('[name="timeliness"]').value;
                        const communication = document.querySelector('[name="communication"]').value;
                        
                        if (!rating || !satisfaction || !timeliness || !communication) {
                            e.preventDefault();
                            alert('Please complete all required fields before submitting.');
                        }
                    });
                }
            });
        </script>
    </body>
</html>