import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.UUID;

@WebServlet(urlPatterns = {"/Submit_Grievance"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1MB
    maxFileSize = 1024 * 1024 * 5,    // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class Submit_Grievance extends HttpServlet {

    // Directory where uploaded files will be saved
    private static final String UPLOAD_DIR = "uploads";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect("User_Login.html");
                return;
            }
            
            int user_id = (Integer) session.getAttribute("user_id");
            
            // Get form parameters
            String department = request.getParameter("Department"); 
            String description = request.getParameter("Desc");
            String location = request.getParameter("Location");
            String latitude = request.getParameter("latitude");
            String longitude = request.getParameter("longitude");
            
            // Handle file upload
            Part filePart = request.getPart("img");
            String fileName = null;
            String imagePath = null;
            
            if (filePart != null && filePart.getSize() > 0) {
                // Get the application path
                String appPath = request.getServletContext().getRealPath("");
                String uploadPath = appPath + File.separator + UPLOAD_DIR;
                
                // Create upload directory if it doesn't exist
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // Generate unique file name to prevent overwriting
                String originalFileName = getFileName(filePart);
                String fileExtension = "";
                
                // Extract file extension
                int i = originalFileName.lastIndexOf('.');
                if (i > 0) {
                    fileExtension = originalFileName.substring(i);
                }
                
                // Generate unique name
                String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                
                // Save file
                Path filePath = Paths.get(uploadPath + File.separator + uniqueFileName);
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
                }
                
                // Store relative path in database
                imagePath = UPLOAD_DIR + File.separator + uniqueFileName;
                fileName = uniqueFileName;
            }
            
            Connection cn = Database.getConnection();
            
            // Use the correct column names from your reports table
            PreparedStatement ps = cn.prepareStatement(
                "INSERT INTO reports(User_id, title, description, Image_path, Location, Status, Priority, latitude, longitude) VALUES(?, ?, ?, ?, ?, ?, ?,?,?)"
            );
            
            // Set parameters
            ps.setInt(1, user_id);
            ps.setString(2, department); // Using department as title
            ps.setString(3, description);
            ps.setString(4, imagePath);
            ps.setString(5, location);
            ps.setString(6, "pending"); // Default status
            ps.setString(7, "medium");  // Default priority
            ps.setString(8, latitude); // Set latitude
            ps.setString(9, longitude);// Set longitude
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                out.println("<script>alert('Grievance submitted successfully!');</script>");
                // You might want to redirect to a success page instead
                RequestDispatcher rd = request.getRequestDispatcher("User_Dashboard.jsp");
                rd.include(request, response);
            } else {
                out.println("<script>alert('Failed to submit grievance!');</script>");
                RequestDispatcher rd = request.getRequestDispatcher("submit_grievance.html");
                rd.include(request, response);
            }
            
            cn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
            RequestDispatcher rd = request.getRequestDispatcher("submit_grievance.html");
            rd.include(request, response);
        }
    }

    // Helper method to get file name from Part
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles grievance submission with file upload";
    }
}
