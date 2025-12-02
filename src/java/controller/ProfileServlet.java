package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Pattern;

@WebServlet(name = "ProfileServlet", urlPatterns = "/profile")
public class ProfileServlet extends HttpServlet {

    private static final Pattern EMAIL_RE =
            Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", Pattern.CASE_INSENSITIVE);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        request.setAttribute("user", user);
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        User sessionUser = (User) request.getSession().getAttribute("user");
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        String fullName = safeTrim(request.getParameter("fullName"));
        String email = safeTrim(request.getParameter("email"));
        String password = safeTrim(request.getParameter("password"));
        String confirmPassword = safeTrim(request.getParameter("confirmPassword"));

        // Đưa dữ liệu người dùng (đã nhập) về request để giữ lại form khi có lỗi
        User viewUser = new User(
                sessionUser.getId(),
                fullName != null ? fullName : sessionUser.getFullName(),
                email != null ? email : sessionUser.getEmail(),
                sessionUser.getPassword(),
                sessionUser.getRole(),
                sessionUser.getPhoneNumber()
        );

        // Validate cơ bản
        if (isBlank(fullName)) {
            request.setAttribute("error", "Vui lòng nhập tên hiển thị.");
            request.setAttribute("user", viewUser);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }
        if (isBlank(email) || !EMAIL_RE.matcher(email).matches()) {
            request.setAttribute("error", "Email không hợp lệ.");
            request.setAttribute("user", viewUser);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }
        boolean changePassword = !isBlank(password) || !isBlank(confirmPassword);
        if (changePassword) {
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu nhập lại không khớp.");
                request.setAttribute("user", viewUser);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
            if (password.length() < 6 || password.length() > 32) {
                request.setAttribute("error", "Mật khẩu phải từ 6 đến 32 ký tự.");
                request.setAttribute("user", viewUser);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
        }

        UserDAO dao = new UserDAO();
        try {
            // Kiểm tra email đã tồn tại cho user khác hay chưa
            if (dao.emailExistsForOther(sessionUser.getId(), email)) {
                request.setAttribute("error", "Email đã được sử dụng bởi tài khoản khác.");
                request.setAttribute("user", viewUser);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            boolean ok = dao.updateUserProfile(
                    sessionUser.getId(),
                    fullName,
                    email,
                    changePassword ? password : null
            );

            if (!ok) {
                request.setAttribute("error", "Cập nhật không thành công. Vui lòng thử lại.");
                request.setAttribute("user", viewUser);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            // Cập nhật lại session user
            sessionUser.setFullName(fullName);
            sessionUser.setEmail(email);
            if (changePassword) {
                sessionUser.setPassword(password);
            }
            request.getSession().setAttribute("user", sessionUser);

            request.setAttribute("success", "Cập nhật thành công!");
            request.setAttribute("user", sessionUser);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        } catch (SQLException e) {
            // Trường hợp hiếm: đụng unique email ở DB hoặc lỗi khác
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật: " + e.getMessage());
            request.setAttribute("user", viewUser);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        }
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private static String safeTrim(String s) {
        return s == null ? null : s.trim();
    }
}