
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.Connection;



@WebServlet("/User_Profile_Edit")
public class User_Profile_Edit extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        int user_id = (Integer) session.getAttribute("user_id");
        String email = request.getParameter("mail");
        String password = request.getParameter("password");
        String address = request.getParameter("address");
        
                boolean updated = false;


        try {
            Connection cn = Database.getConnection();
            String sql = "UPDATE user SET email=?, password=?,address=? WHERE user_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, address);
            ps.setInt(4, user_id);

            int rowsUpdated=ps.executeUpdate();
            updated = rowsUpdated > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
if(updated){
        response.sendRedirect("User_Profile.jsp");
}
else{
      response.sendRedirect("user_edit_profile.jsp?error=Profile+not+updated+try+again");
}
    }
}
