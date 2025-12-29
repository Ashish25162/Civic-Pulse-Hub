<%@ page session="True" %>
<html>
<head>
    <title>Edit Profile</title>
</head>
<body>
<div>
    <h4>Edit Profile</h4>
    <form action="User_Profile_Edit" method="post">
        <div>
            <input type="text" name="name" value="<%= session.getAttribute("name") %>" 
                   placeholder="Enter your name" required>
        </div>
        <div>
            <input type="text" name="mobile" value="<%= session.getAttribute("mobile") %>" 
                   placeholder="Enter your mobile number" required>
        </div>
        <div>
            <input type="text" name="mail" value="<%= session.getAttribute("email") %>" 
                   placeholder="Enter your new email">
        </div>
        <div>
            <input type="text" name="password" value="<%= session.getAttribute("password") %>" 
                   placeholder="Enter your new password">
        </div>
                   <div>
            <input type="text" name="address" value="<%= session.getAttribute("address") %>" 
                   placeholder="Enter your new new full address">
        </div>
        <button type="submit">Save Changes</button>
        <a href="User_Profile.jsp">Cancel</a>
    </form>
</div>
</body>
</html>

