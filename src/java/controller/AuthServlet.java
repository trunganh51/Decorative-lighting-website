package controller;

import dao.UserDAO;
import dao.EmailOtpDAO;
import model.User;
import model.EmailOTP;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import util.EmailUtil;

/**
 * Handles user authentication including registration, login, and email OTP
 * verification.
 */
@WebServlet(name = "AuthServlet", urlPatterns = "/auth")
public class AuthServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    // ========================== DO GET ==========================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        // ✅ Gửi OTP qua GET để phù hợp với JavaScript hiện tại
        if ("sendOtp".equals(action)) {
            handleSendOtp(req, resp);
            return;
        }

        // Các action khác (login/register/logout)
        if ("register".equals(action)) {
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        } else if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
        } else {
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }

    // ========================== DO POST ==========================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("register".equals(action)) {
            handleRegister(req, resp);
        } else if ("login".equals(action)) {
            handleLogin(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
        }
    }

    // ========================== XỬ LÝ GỬI OTP ==========================
    private void handleSendOtp(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");
        resp.setContentType("text/plain;charset=UTF-8");

        if (email == null || email.isEmpty()) {
            resp.getWriter().write("❌ Email không hợp lệ!");
            return;
        }

        try {
            String otpCode = String.valueOf((int) (Math.random() * 900000) + 100000);
            LocalDateTime expireAt = LocalDateTime.now().plusMinutes(5);

            EmailOTP otp = new EmailOTP(email, otpCode, expireAt);
            EmailOtpDAO otpDAO = new EmailOtpDAO(userDAO.getConnection());
            otpDAO.saveOTP(otp);

            // ✅ In OTP ra console (sau này thay bằng gửi email thật)
            EmailUtil.sendEmail(
                    email,
                    "Mã xác thực OTP",
                    "Mã OTP của bạn là: " + otpCode + "\nMã có hiệu lực trong 5 phút."
            );

            resp.getWriter().write("✅ OTP đã gửi tới email " + email);
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("❌ Gửi OTP thất bại!");
        }
    }

    // ========================== XỬ LÝ ĐĂNG KÝ ==========================
    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String otpInput = req.getParameter("otp");

        try {
            EmailOtpDAO otpDAO = new EmailOtpDAO(userDAO.getConnection());

            if (!otpDAO.verifyOTP(email, otpInput)) {
                req.setAttribute("error", "❌ Mã OTP không hợp lệ hoặc đã hết hạn!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }

            User u = new User(fullName, email, password, "user");
            boolean success = userDAO.register(u);

            if (success) {
                otpDAO.deleteOTP(email);
                resp.sendRedirect(req.getContextPath() + "/auth?action=login");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }

    // ========================== XỬ LÝ ĐĂNG NHẬP ==========================
    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User user = userDAO.login(email, password);
        if (user != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);

            if ("admin".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/products?action=list");
            } else {
                resp.sendRedirect(req.getContextPath() + "/products?action=list");
            }
        } else {
            req.setAttribute("error", "❌ Sai email hoặc mật khẩu!");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
