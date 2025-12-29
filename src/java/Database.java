import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
public class Database {
 static private  String URL="jdbc:mysql://localhost:3306/Civic_Pulse_Hub";
    private static HikariDataSource dataSource;
    static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			HikariConfig config = new HikariConfig();
			
			config.setJdbcUrl(URL);
			config.setUsername("root");
			config.setPassword("Ashu@@3450");
			dataSource = new HikariDataSource(config);
			System.out.println("HikariCP Connection Pool Initialized.");
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("Failed to initialize HikariCP", e);
		}
	}
	
	public static Connection getConnection() throws SQLException {
		return dataSource.getConnection();
	}
}