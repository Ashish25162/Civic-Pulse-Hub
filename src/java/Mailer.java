import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Random;

class Mailer {
    static String from = "avanirathore10@gmail.com";
    static String password = "vdxp xgjz mmad xzav";

    public static void send(String to, String sub, String msg) {
        // Setup mail server properties
        Properties props = new Properties();
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // STARTTLS

        // Create session object
        Session session = Session.getInstance(props,
                new javax.mail.Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(from, password);
                    }
                });

        // Compose message
        try {
            MimeMessage message = new MimeMessage(session);
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setSubject(sub);
            message.setText(msg);

            // Send message
            Transport.send(message);
            System.out.println("message sent successfully");

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}