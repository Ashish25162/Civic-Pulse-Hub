package com.mycompany.mail;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Random;

public class mailer {
    static String from = "ashishsingh3808@gmail.com";
    static String password = "mquv nyxn jlor lcwh"; // App Password
    // Add these 2 lines after your existing static variables
    private static final int OTP_VALIDITY_MINUTES = 10;
    private static final Map<String, OTPData> otpStore = new ConcurrentHashMap<>();

    // Inner class to store OTP data
    private static class OTPData {
        String otp;
        LocalDateTime expiryTime;
        
        OTPData(String otp, int validityMinutes) {
            this.otp = otp;
            this.expiryTime = LocalDateTime.now().plusMinutes(validityMinutes);
        }
        
        boolean isExpired() {
            return LocalDateTime.now().isAfter(expiryTime);
        }
    }

    // Method 1: Generate OTP
    public static String generateOTP() {
        Random random = new Random();
        return String.valueOf(100000 + random.nextInt(900000));
    }
    
    // Method 2: Send OTP with expiry
    public static void sendOTP(String to, String sub) {
        String otp = generateOTP();
        
        // Store OTP with expiry time
        otpStore.put(to, new OTPData(otp, OTP_VALIDITY_MINUTES));
        
        // Create message with expiry info
        String messageBody = "Your OTP is: " + otp + 
                           "\nThis OTP is valid for " + OTP_VALIDITY_MINUTES + " minutes.";
        
        // Send email using your existing send method
        send(to, sub, messageBody);
    }
    
    // Method 3: Verify OTP with expiry check
    public static boolean verifyOTP(String email, String userOTP) {
        OTPData otpData = otpStore.get(email);
        
        if (otpData == null) {
            return false; // No OTP found
        }
        
        if (otpData.isExpired()) {
            otpStore.remove(email); // Clean up expired OTP
            return false;
        }
        
        if (otpData.otp.equals(userOTP)) {
            otpStore.remove(email); // Remove after successful verification
            return true;
        }
        
        return false;
    }

    // Your original send method (unchanged)
    public static void send(String to, String sub, String messageBody) {
        // Setup mail server properties
        Properties props = new Properties();
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // STARTTLS

        // Create session object
        Session session = Session.getInstance(props,
            new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(from, password);
                }
            });

        // Compose message
        try {
            MimeMessage message = new MimeMessage(session);
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setSubject(sub);
            message.setText(messageBody); // This is the email content

            // Send message
            Transport.send(message);
            System.out.println("Email send to"+to);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}