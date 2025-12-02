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
import java.util.stream.Collectors;

/**
 * Servlet để quản lý khách hàng. Liệt kê tất cả người dùng (chỉ role 'user') và các đơn hàng của họ.
 */
@WebServlet(name = "AdminCustomerServlet", urlPatterns = "/admin/customers")
public class AdminCustomerServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy tất cả users
        List<User> allUsers = userDAO.getAllUsers();
        
        // Lọc chỉ lấy những user có role = 'user' (loại bỏ admin)
        List<User> customers = allUsers.stream()
                .filter(u -> "user".equalsIgnoreCase(u.getRole()))
                .collect(Collectors.toList());
        
        // Lấy đơn hàng của từng khách hàng
        Map<Integer, List<Order>> ordersByUser = new HashMap<>();
        for (User u : customers) {
            ordersByUser.put(u.getId(), orderDAO.getOrdersByUser(u.getId()));
        }
        
        req.setAttribute("users", customers);
        req.setAttribute("ordersByUser", ordersByUser);
        req.getRequestDispatcher("/admin/admin_customers.jsp").forward(req, resp);
    }
}