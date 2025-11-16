package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/admin/account")
public class AccountServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String search = req.getParameter("search");
        List<User> users;

        if (search != null && !search.trim().isEmpty()) {
            users = userDAO.searchUsers(search);
        } else {
            users = userDAO.getAllUsers();
        }

        req.setAttribute("users", users);

        // 🔥 Forward đúng tới file JSP
        req.getRequestDispatcher("/admin/admin_account.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String message = "";

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                boolean ok = userDAO.deleteUser(id);
                message = ok ? "Xóa thành công" : "Xóa thất bại";
            } catch (Exception e) {
                message = "Lỗi xóa tài khoản!";
            }
        }
        else if ("toggleRole".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                User user = userDAO.getUserById(id);

                if (user != null) {
                    String newRole = user.getRole().equals("admin") ? "user" : "admin";
                    boolean ok = userDAO.changeUserRole(id, newRole);
                    message = ok ? "Đổi vai trò thành công" : "Không đổi được vai trò";
                } else {
                    message = "Không tìm thấy tài khoản!";
                }
            } catch (Exception e) {
                message = "Lỗi đổi vai trò!";
            }
        }

        String search = req.getParameter("search");
        List<User> users;

        if (search != null && !search.trim().isEmpty()) {
            users = userDAO.searchUsers(search);
        } else {
            users = userDAO.getAllUsers();
        }

        req.setAttribute("message", message);
        req.setAttribute("users", users);

        // 🔥 Forward đúng file JSP
        req.getRequestDispatcher("/admin/admin_account.jsp").forward(req, resp);
    }
}
