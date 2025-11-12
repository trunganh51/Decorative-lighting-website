package controller;

import dao.OrderDAO;
import dao.OrderDetailDAO;
import model.CartItem;
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

        // 🧾 Danh sách đơn hàng của người dùng
        if (action == null || action.equals("list")) {
            List<Order> orders = orderDAO.getOrdersByUser(user.getId());
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("order_list.jsp").forward(req, resp);
        }

        // 🔍 Xem chi tiết đơn hàng
        else if (action.equals("detail")) {
            int orderId = Integer.parseInt(req.getParameter("id"));
            Order order = orderDAO.getOrderById(orderId);
            List<OrderDetail> details = orderDetailDAO.getDetailsByOrderId(orderId);

            req.setAttribute("order", order);
            req.setAttribute("details", details);
            req.getRequestDispatcher("order_detail.jsp").forward(req, resp);
        }

        // 👑 Admin xem toàn bộ đơn hàng
        else if (action.equals("admin")) {
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

        // 🛒 Đặt hàng từ giỏ hàng
        if ("checkout".equals(action)) {
            @SuppressWarnings("unchecked")
            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
            String address = req.getParameter("address");

            if (cart == null || cart.isEmpty()) {
                req.setAttribute("error", "Giỏ hàng của bạn đang trống!");
                req.getRequestDispatcher("cart.jsp").forward(req, resp);
                return;
            }

            double total = cart.values().stream().mapToDouble(CartItem::getSubtotal).sum();
            Order order = new Order();
            order.setUserId(user.getId());
            order.setTotalPrice(total);
            order.setStatus("Chờ duyệt");
            order.setShippingAddress(address);

            int orderId = orderDAO.insert(order);

            if (orderId > 0) {
                for (CartItem item : cart.values()) {
                    orderDetailDAO.insertOrderDetail(orderId,
                            item.getProduct().getId(),
                            item.getQuantity(),
                            item.getProduct().getPrice());
                }

                session.removeAttribute("cart");
                session.setAttribute("cartSize", 0);

                resp.sendRedirect(req.getContextPath() + "/orders?action=list&success=1");
            } else {
                req.setAttribute("error", "Đặt hàng thất bại, vui lòng thử lại!");
                req.getRequestDispatcher("cart.jsp").forward(req, resp);
            }
        }

      

        // ✅ Người dùng xác nhận đã nhận hàng
        else if ("confirm".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            orderDAO.updateOrderStatus(orderId, "Đã giao");
            resp.sendRedirect(req.getContextPath() + "/orders?action=list");
        }

        // ❌ Người dùng huỷ đơn hàng → chỉ cập nhật trạng thái
        else if ("cancel".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            orderDAO.updateOrderStatus(orderId, "Đã huỷ");
            resp.sendRedirect(req.getContextPath() + "/orders?action=list&msg=cancelled");
        }

        // 🔁 Đặt lại đơn hàng: XÓA ĐƠN CŨ + TẠO LẠI ĐƠN MỚI
        else if ("reorder".equals(action)) {
            int oldOrderId = Integer.parseInt(req.getParameter("orderId"));
            Order oldOrder = orderDAO.getOrderById(oldOrderId);
            List<OrderDetail> oldDetails = orderDetailDAO.getDetailsByOrderId(oldOrderId);

            if (oldOrder != null && !oldDetails.isEmpty()) {
                // Xóa đơn cũ trước
                orderDetailDAO.deleteDetailsByOrderId(oldOrderId);
                orderDAO.deleteOrder(oldOrderId);

                // Tạo đơn mới
                Order newOrder = new Order();
                newOrder.setUserId(user.getId());
                newOrder.setShippingAddress(oldOrder.getShippingAddress());
                newOrder.setTotalPrice(oldOrder.getTotalPrice());
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
        }

        // 🗑 Xóa triệt để đơn (tùy chọn)
        else if ("delete".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            orderDetailDAO.deleteDetailsByOrderId(orderId);
            orderDAO.deleteOrder(orderId);
            resp.sendRedirect(req.getContextPath() + "/orders?action=list&deleted=1");
        }
    }
}
