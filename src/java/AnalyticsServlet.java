
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import org.json.*;
import org.json.JSONObject;
import org.json.JSONArray;

@WebServlet("/analytics")
public class AnalyticsServlet extends HttpServlet {
    
    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/civic_pulse_hub", 
            "root", 
            "Ashu@@3450"
        );
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String type = request.getParameter("type");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try (Connection conn = getConnection()) {
            JSONObject result = new JSONObject();
            
            switch(type) {
                case "category":
                    result = getCategoryData(conn);
                    break;
                case "zone":
                    result = getZoneData(conn);
                    break;
                case "sla":
                    result = getSLAData(conn);
                    break;
                case "stats":
                    result = getDashboardStats(conn);
                    break;
                case "redzones":
                    result = getRedZones(conn);
                    break;
                default:
                    result.put("error", "Invalid analytics type");
            }
            
            out.print(result.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject error = new JSONObject();
            error.put("error", e.getMessage());
            out.print(error.toString());
        }
    }
    
    // 1. Category-wise complaints (Pie Chart)
 // 1. Category-wise complaints - Alternative dynamic approach
private JSONObject getCategoryData(Connection conn) throws SQLException {
    JSONObject result = new JSONObject();
    JSONArray categories = new JSONArray();
    JSONArray counts = new JSONArray();
    JSONArray colors = new JSONArray();
    
    // Get all unique titles as categories
    String sql = "SELECT " +
                "  title as complaint_title, " +
                "  COUNT(*) as count " +
                "FROM reports " +
                "WHERE title IS NOT NULL AND title != '' " +
                "GROUP BY title " +
                "ORDER BY count DESC " +
                "LIMIT 15"; // Limit to top 15 complaint types
    
    try (PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        String[] colorPalette = {
            "#FF6384", "#36A2EB", "#FFCE56", "#4BC0C0", 
            "#9966FF", "#FF9F40", "#8AC926", "#1982C4",
            "#6A0572", "#AB83A1", "#FF6B6B", "#4ECDC4",
            "#95E1D3", "#FCE38A", "#F38181"
        };
        
        int i = 0;
        int otherCount = 0;
        int totalRecords = 0;
        
        // First pass: count total records
        List<String> titleList = new ArrayList<>();
        List<Integer> countList = new ArrayList<>();
        
        while (rs.next()) {
            String title = rs.getString("complaint_title");
            int count = rs.getInt("count");
            
            if (title != null && !title.trim().isEmpty()) {
                titleList.add(title);
                countList.add(count);
                totalRecords += count;
            }
        }
        
        // Second pass: group small categories as "Others"
        for (int j = 0; j < titleList.size(); j++) {
            String title = titleList.get(j);
            int count = countList.get(j);
            double percentage = (count * 100.0) / totalRecords;
            
            // If category has less than 5% of total OR we're beyond 8 main categories
            if (percentage < 5.0 || j >= 8) {
                otherCount += count;
            } else {
                categories.put(title);
                counts.put(count);
                colors.put(colorPalette[i % colorPalette.length]);
                i++;
            }
        }
        
        // Add "Others" category if there are small groups
        if (otherCount > 0) {
            categories.put("Other Complaints");
            counts.put(otherCount);
            colors.put("#CCCCCC");
        }
        
        // If no categories found
        if (categories.length() == 0 && totalRecords > 0) {
            categories.put("All Complaints");
            counts.put(totalRecords);
            colors.put("#FF6384");
        } else if (categories.length() == 0) {
            categories.put("No Complaint Data");
            counts.put(1);
            colors.put("#CCCCCC");
        }
    }
    
    result.put("categories", categories);
    result.put("counts", counts);
    result.put("colors", colors);
    return result;
}
    
    // 2. Zone-wise complaints (Heat Map)
    private JSONObject getZoneData(Connection conn) throws SQLException {
        JSONObject result = new JSONObject();
        JSONArray zones = new JSONArray();
        JSONArray complaints = new JSONArray();
        JSONArray intensities = new JSONArray();
        
        String sql = "SELECT " +
                    "  CASE " +
                    "    WHEN Location LIKE '%Zone A%' OR Location LIKE '%Downtown%' THEN 'Zone A' " +
                    "    WHEN Location LIKE '%Zone B%' OR Location LIKE '%Suburbs%' THEN 'Zone B' " +
                    "    WHEN Location LIKE '%Zone C%' OR Location LIKE '%Residential%' THEN 'Zone C' " +
                    "    WHEN Location LIKE '%Zone D%' OR Location LIKE '%Industrial%' THEN 'Zone D' " +
                    "    WHEN Location LIKE '%Zone E%' OR Location LIKE '%Rural%' THEN 'Zone E' " +
                    "    ELSE 'Other Areas' " +
                    "  END as zone, " +
                    "  COUNT(*) as complaint_count " +
                    "FROM reports " +
                    "WHERE Location IS NOT NULL " +
                    "GROUP BY zone " +
                    "ORDER BY complaint_count DESC";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            int maxComplaints = 0;
            List<String> zoneList = new ArrayList<>();
            List<Integer> countList = new ArrayList<>();
            
            while (rs.next()) {
                zoneList.add(rs.getString("zone"));
                int count = rs.getInt("complaint_count");
                countList.add(count);
                if (count > maxComplaints) maxComplaints = count;
            }
            
            // Calculate intensity (0 to 1)
            for (int i = 0; i < zoneList.size(); i++) {
                zones.put(zoneList.get(i));
                complaints.put(countList.get(i));
                intensities.put(maxComplaints > 0 ? (double) countList.get(i) / maxComplaints : 0);
            }
        }
        
        result.put("zones", zones);
        result.put("complaints", complaints);
        result.put("intensities", intensities);
        return result;
    }
    
    // 3. SLA Performance (Bar Chart)
    private JSONObject getSLAData(Connection conn) throws SQLException {
        JSONObject result = new JSONObject();
        
        // Define SLA: 3 days for High, 5 days for Medium, 7 days for Low
        String sql = "SELECT " +
                    "  Priority, " +
                    "  COUNT(*) as total, " +
                    "  SUM(CASE " +
                    "    WHEN Status = 'resolved' AND " +
                    "      ( (Priority = 'high' OR Priority = 'critical') AND TIMESTAMPDIFF(HOUR, Created_at, Updated_at) <= 72 ) OR " +
                    "      ( Priority = 'medium' AND TIMESTAMPDIFF(HOUR, Created_at, Updated_at) <= 120 ) OR " +
                    "      ( Priority = 'low' AND TIMESTAMPDIFF(HOUR, Created_at, Updated_at) <= 168 ) " +
                    "    THEN 1 ELSE 0 END) as sla_met, " +
                    "  SUM(CASE " +
                    "    WHEN Status = 'resolved' AND " +
                    "      ( (Priority = 'high' OR Priority = 'critical') AND TIMESTAMPDIFF(HOUR, Created_at, Updated_at) > 72 ) OR " +
                    "      ( Priority = 'medium' AND TIMESTAMPDIFF(HOUR, Created_at, Updated_at) > 120 ) OR " +
                    "      ( Priority = 'low' AND TIMESTAMPDIFF(HOUR, Created_at, Updated_at) > 168 ) " +
                    "    THEN 1 ELSE 0 END) as sla_violated " +
                    "FROM reports " +
                    "WHERE Status = 'resolved' " +
                    "GROUP BY Priority " +
                    "ORDER BY FIELD(Priority, 'critical', 'high', 'medium', 'low')";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            JSONArray priorities = new JSONArray();
            JSONArray met = new JSONArray();
            JSONArray violated = new JSONArray();
            
            while (rs.next()) {
                String priority = rs.getString("Priority");
                if (priority == null) continue;
                
                priorities.put(priority.toUpperCase());
                met.put(rs.getInt("sla_met"));
                violated.put(rs.getInt("sla_violated"));
            }
            
            result.put("priorities", priorities);
            result.put("sla_met", met);
            result.put("sla_violated", violated);
        }
        
        return result;
    }
    
    // 4. Dashboard Statistics
    private JSONObject getDashboardStats(Connection conn) throws SQLException {
        JSONObject result = new JSONObject();
        
        // Total complaints
        String sql1 = "SELECT COUNT(*) as total FROM reports";
        try (PreparedStatement ps = conn.prepareStatement(sql1);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) result.put("total_complaints", rs.getInt("total"));
        }
        
        // Pending complaints
        String sql2 = "SELECT COUNT(*) as pending FROM reports WHERE Status = 'pending' OR Status = 'assigned'";
        try (PreparedStatement ps = conn.prepareStatement(sql2);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) result.put("pending_complaints", rs.getInt("pending"));
        }
        
        // Resolved complaints
        String sql3 = "SELECT COUNT(*) as resolved FROM reports WHERE Status = 'resolved'";
        try (PreparedStatement ps = conn.prepareStatement(sql3);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) result.put("resolved_complaints", rs.getInt("resolved"));
        }
        
        // Total operators
        String sql4 = "SELECT COUNT(*) as operators FROM operator";
        try (PreparedStatement ps = conn.prepareStatement(sql4);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) result.put("total_operators", rs.getInt("operators"));
        }
        
        // SLA compliance rate
        String sql5 = "SELECT " +
                     "  COUNT(*) as total_resolved, " +
                     "  SUM(CASE " +
                     "    WHEN (Priority = 'high' OR Priority = 'critical') AND TIMESTAMPDIFF(HOUR, Created_at, Updated_at) <= 72 THEN 1 " +
                     "    WHEN Priority = 'medium' AND TIMESTAMPDIFF(HOUR, Created_at, Updated_at) <= 120 THEN 1 " +
                     "    WHEN Priority = 'low' AND TIMESTAMPDIFF(HOUR, Created_at, Updated_at) <= 168 THEN 1 " +
                     "    ELSE 0 " +
                     "  END) as sla_met " +
                     "FROM reports WHERE Status = 'resolved'";
        
        try (PreparedStatement ps = conn.prepareStatement(sql5);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int total = rs.getInt("total_resolved");
                int met = rs.getInt("sla_met");
                result.put("sla_compliance_rate", total > 0 ? (met * 100.0 / total) : 100);
            }
        }
        
        return result;
    }
    
    // 5. Red Zones (Areas with repeated complaints)
    private JSONObject getRedZones(Connection conn) throws SQLException {
        JSONObject result = new JSONObject();
        JSONArray redZones = new JSONArray();
        
        String sql = "SELECT " +
                    "  Location as zone, " +
                    "  COUNT(*) as complaint_count, " +
                    "  GROUP_CONCAT(DISTINCT Category_id) as categories, " +
                    "  MAX(Created_at) as last_complaint " +
                    "FROM reports " +
                    "WHERE Location IS NOT NULL AND Location != '' " +
                    "GROUP BY Location " +
                    "HAVING complaint_count >= 3 " +  // Red zone threshold: 3+ complaints
                    "ORDER BY complaint_count DESC " +
                    "LIMIT 10";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                JSONObject zone = new JSONObject();
                zone.put("zone", rs.getString("zone"));
                zone.put("complaint_count", rs.getInt("complaint_count"));
                zone.put("categories", rs.getString("categories"));
                zone.put("last_complaint", rs.getDate("last_complaint").toString());
                zone.put("status", "red");  // red, orange, yellow based on count
                
                redZones.put(zone);
            }
        }
        
        result.put("red_zones", redZones);
        return result;
    }
}