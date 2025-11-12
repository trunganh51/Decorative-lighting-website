package util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.UnsupportedEncodingException;

public class EmailUtil {

    // ✅ Email người gửi (phải trùng với tài khoản đã bật App Password)
    private static final String FROM_EMAIL = "ttanh.dhti16a2hn@sv.uneti.edu.vn";
    private static final String APP_PASSWORD = "larmmpkuwvdc zvyt".replace(" ", ""); // Xóa khoảng trắng cho chắc

    public static void sendEmail(String toEmail, String subject, String messageText) throws MessagingException, UnsupportedEncodingException {

        // ✅ Cấu hình Gmail SMTP (chuẩn)
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        // ✅ Tạo session có xác thực Gmail
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        // ✅ Soạn email
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL, "UNETI Shop")); // tên hiển thị
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);

        // ✅ Cho phép gửi email HTML đẹp hơn
        String htmlContent = """
                <html>
                  <body style='font-family:Arial, sans-serif;'>
                    <h3>Mã xác thực OTP của bạn:</h3>
                    <p style='font-size:18px;color:#2c3e50;'><b>%s</b></p>
                    <p>Mã này có hiệu lực trong 5 phút.</p>
                    <p>Trân trọng,<br>UNETI Shop</p>
                  </body>
                </html>
                """.formatted(messageText);

        message.setContent(htmlContent, "text/html; charset=UTF-8");

        // ✅ Gửi email
        Transport.send(message);
        System.out.println("✅ OTP đã gửi thành công tới: " + toEmail);
    }
}
