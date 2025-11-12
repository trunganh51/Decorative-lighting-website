package controller;

import dao.OrderDAO;
import dao.UserDAO;
import model.Order;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet để quản lý khách hàng. Liệt kê tất cả người dùng và các đơn hàng của họ.
 */
@WebServlet(name = "AdminCustomerServlet", urlPatterns = "/admin/customers")
public class AdminCustomerServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        Map<Integer, List<Order>> ordersByUser = new HashMap<>();
        for (User u : users) {
            ordersByUser.put(u.getId(), orderDAO.getOrdersByUser(u.getId()));
        }
        req.setAttribute("users", users);
        req.setAttribute("ordersByUser", ordersByUser);
        req.getRequestDispatcher("/admin/admin_customers.jsp").forward(req, resp);
    }
}