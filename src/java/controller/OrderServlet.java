package controller;

import dao.OrderDAO;
import dao.OrderDetailDAO;
import model.Order;
import model.OrderDetail;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OrderServlet", urlPatterns = "/orders")
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        if (action == null || action.equals("list")) {
            List<Order> orders = orderDAO.getOrdersByUser(user.getId());
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("order_list.jsp").forward(req, resp);
        } else if (action.equals("detail")) {
            int orderId = Integer.parseInt(req.getParameter("id"));
            Order order = orderDAO.getOrderById(orderId);
            List<OrderDetail> details = orderDetailDAO.getDetailsByOrderId(orderId);

            req.setAttribute("order", order);
            req.setAttribute("details", details);
            req.getRequestDispatcher("order_detail.jsp").forward(req, resp);
        } else if (action.equals("admin")) {
            List<Order> orders = orderDAO.getAllOrders();
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("admin_orders.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        if ("checkout".equals(action)) {
            @SuppressWarnings("unchecked")
            Map<Integer, OrderDetail> cart = (Map<Integer, OrderDetail>) session.getAttribute("cart");

            String receiverName = param(req, "receiverName", user.getFullName() != null ? user.getFullName() : "");
            String phone = param(req, "phone", "");
            int provinceId = parseIntOrDefault(req.getParameter("provinceId"), 1);
            String address = param(req, "address", "");
            String shippingMethod = param(req, "shippingMethod", "standard");
            int paymentId = parseIntOrDefault(req.getParameter("paymentId"), 2); // 2 = COD
            String note = param(req, "note", "");
            String couponCode = param(req, "couponCode", "");

            if (cart == null || cart.isEmpty()) {
                req.setAttribute("error", "Giỏ hàng của bạn đang trống!");
                req.getRequestDispatcher("cart.jsp").forward(req, resp);
                return;
            }

            Order order = new Order();
            order.setUserId(user.getId());
            order.setPaymentId(paymentId);
            order.setReceiverName(receiverName);
            order.setPhone(phone);
            order.setProvinceId(provinceId);
            order.setAddress(address);
            order.setShippingMethod(shippingMethod);
            order.setNote(note);
            order.setCouponCode(couponCode);
            order.setStatus("Chờ duyệt");

            // NEW: Tạo đơn + chi tiết trong 1 transaction
            int orderId = orderDAO.insertWithDetails(order, cart);

            if (orderId > 0) {
                // Xoá giỏ hàng và chuyển về danh sách
                session.removeAttribute("cart");
                session.setAttribute("cartSize", 0);

                resp.sendRedirect(req.getContextPath() + "/orders?action=list&success=1");
            } else {
                req.setAttribute("error", "Đặt hàng thất bại, vui lòng thử lại!");
                req.getRequestDispatcher("cart.jsp").forward(req, resp);
            }
        } else if ("confirm".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            orderDAO.updateOrderStatus(orderId, "Đã giao");
            resp.sendRedirect(req.getContextPath() + "/orders?action=list");
        } else if ("cancel".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            orderDAO.updateOrderStatus(orderId, "Đã hủy");
            resp.sendRedirect(req.getContextPath() + "/orders?action=list&msg=cancelled");
        } else if ("reorder".equals(action)) {
            int oldOrderId = Integer.parseInt(req.getParameter("orderId"));
            Order oldOrder = orderDAO.getOrderById(oldOrderId);
            List<OrderDetail> oldDetails = orderDetailDAO.getDetailsByOrderId(oldOrderId);

            if (oldOrder != null && oldDetails != null && !oldDetails.isEmpty()) {
                orderDetailDAO.deleteDetailsByOrderId(oldOrderId);
                orderDAO.deleteOrder(oldOrderId);

                Order newOrder = new Order();
                newOrder.setUserId(user.getId());
                newOrder.setPaymentId(oldOrder.getPaymentId() > 0 ? oldOrder.getPaymentId() : 2);
                newOrder.setReceiverName(oldOrder.getReceiverName());
                newOrder.setPhone(oldOrder.getPhone());
                newOrder.setProvinceId(oldOrder.getProvinceId());
                newOrder.setAddress(oldOrder.getAddress());
                newOrder.setShippingMethod(oldOrder.getShippingMethod() != null ? oldOrder.getShippingMethod() : "standard");
                newOrder.setNote(oldOrder.getNote());
                newOrder.setCouponCode(oldOrder.getCouponCode());
                newOrder.setStatus("Chờ duyệt");

                int newOrderId = orderDAO.insert(newOrder);

                if (newOrderId > 0) {
                    for (OrderDetail d : oldDetails) {
                        orderDetailDAO.insertOrderDetail(
                                newOrderId,
                                d.getProductId(),
                                d.getQuantity(),
                                d.getPrice()
                        );
                    }
                    resp.sendRedirect(req.getContextPath() + "/orders?action=list&reordered=1");
                } else {
                    req.setAttribute("error", "Không thể đặt lại đơn hàng này.");
                    req.getRequestDispatcher("order_list.jsp").forward(req, resp);
                }
            } else {
                req.setAttribute("error", "Đơn hàng không tồn tại hoặc rỗng.");
                req.getRequestDispatcher("order_list.jsp").forward(req, resp);
            }
        } else if ("delete".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            orderDetailDAO.deleteDetailsByOrderId(orderId);
            orderDAO.deleteOrder(orderId);
            resp.sendRedirect(req.getContextPath() + "/orders?action=list&deleted=1");
        }
    }

    private static String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v == null || v.trim().isEmpty()) ? def : v.trim();
    }

    private static int parseIntOrDefault(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }
}
