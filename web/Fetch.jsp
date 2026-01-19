<%-- 
    Document   : fetch
    Created on : 12-Jul-2025, 6:22:36 pm
    Author     : administration
--%>
<%@page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Employee Details</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            h2 {
                color: #333;
                margin-top: 30px;
                padding-bottom: 10px;
                border-bottom: 2px solid #4CAF50;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
            }
            table, th, td {
                border: 1px solid #ddd;
            }
            th, td {
                padding: 12px;
                text-align: left;
            }
            th {
                background-color: #4CAF50;
                color: white;
            }
            tr:nth-child(even) {
                background-color: #f2f2f2;
            }
            tr:hover {
                background-color: #ddd;
            }
            .category-label {
                background-color: #2196F3;
                color: white;
                padding: 8px 15px;
                border-radius: 5px;
                font-weight: bold;
                margin-top: 40px;
                display: inline-block;
            }
        </style>
    </head>
    <body>
        <h1>Employee Management System</h1>
        
        <%
            try {
                // Load the driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                // Make the connection object
                Connection cn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/civic_pulse_hub", 
                    "root", 
                    "Ashu@@3450"
                );
                
        %>
        
       
        
        <%
                // ========== OPERATORS SECTION ==========
        %>
        
        <div class="category-label">Operators</div>
        <h2>All Operators</h2>
        <table>
            <tr>
                <th>Operator ID</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Department</th>
                <th>Created At</th>
            </tr>
            
        <%
                // Make preparedstatement object for operators
                PreparedStatement psOperators = cn.prepareStatement("SELECT operator_id, full_name, email, phone, department, created_at FROM operator");
                
                // Execute the query for operators
                ResultSet rsOperators = psOperators.executeQuery();
                
                while(rsOperators.next()) {
                    String operator_id = rsOperators.getString("operator_id");
                    String full_name = rsOperators.getString("full_name");
                    String email = rsOperators.getString("email");
                    String phone = rsOperators.getString("phone");
                    String department = rsOperators.getString("department");
                    String created_at = rsOperators.getString("created_at");
        %>
                <tr>
                    <td><%= operator_id %></td>
                    <td><%= full_name %></td>
                    <td><%= email %></td>
                    <td><%= phone %></td>
                    <td><%= department %></td>
                    <td><%= created_at %></td>
                </tr>
        <%
                }
                
                // Close operators result set and statement
                rsOperators.close();
                psOperators.close();
                cn.close();
                
            } catch (Exception ex) {
                out.println("<div style='color: red; padding: 10px; background-color: #ffe6e6; border: 1px solid red;'>");
                out.println("Error: " + ex.toString());
                out.println("</div>");
            }
        %>
        </table>
    </body>
</html>