package controller;

import dao.ProductDAO;
import dao.OrderDAO;
import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        OrderDAO orderDAO = new OrderDAO();
        UserDAO userDAO = new UserDAO();

        request.setAttribute("totalProducts", productDAO.countProducts());
        request.setAttribute("totalRevenue", orderDAO.getTotalRevenue());
        request.setAttribute("lowStockProducts", productDAO.getLowStockProducts());
        request.setAttribute("inStockProducts", productDAO.getInStockProducts());

        // Sửa DAO: dùng LEFT JOIN để lấy đủ top 5 user dù chưa có đơn
        List<Map<String, Object>> topUsers = userDAO.getTopUsers(5);
        request.setAttribute("topUsers", topUsers);

        RequestDispatcher rd = request.getRequestDispatcher("/admin/admin_dashboard.jsp");
        rd.forward(request, response);
    }
}