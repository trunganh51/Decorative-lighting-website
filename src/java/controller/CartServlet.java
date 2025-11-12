package controller;

import dao.ProductDAO;
import model.CartItem;
import model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "CartServlet", urlPatterns = "/cart")
public class CartServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ✅ CRITICAL: Set encoding first
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        
        HttpSession session = req.getSession(true);

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        String action = req.getParameter("action");
        boolean success = false;
        String message = "";
        int cartCount = 0;

        try {
            if ("add".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                Product product = productDAO.getProductById(productId);

                if (product != null) {
                    CartItem item = cart.get(productId);
                    if (item == null) {
                        item = new CartItem(product, quantity);
                    } else {
                        item.setQuantity(item.getQuantity() + quantity);
                    }
                    cart.put(productId, item);
                    success = true;
                    message = "Đã thêm sản phẩm vào giỏ hàng";
                } else {
                    message = "Không tìm thấy sản phẩm";
                }

            } else if ("update".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                CartItem item = cart.get(productId);
                if (item != null) {
                    if (quantity <= 0) {
                        cart.remove(productId);
                        message = "Đã xóa sản phẩm khỏi giỏ hàng";
                    } else {
                        item.setQuantity(quantity);
                        message = "Đã cập nhật số lượng";
                    }
                    success = true;
                } else {
                    message = "Không tìm thấy sản phẩm trong giỏ hàng";
                }

            } else if ("remove".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                if (cart.containsKey(productId)) {
                    cart.remove(productId);
                    success = true;
                    message = "Đã xóa sản phẩm khỏi giỏ hàng";
                } else {
                    message = "Không tìm thấy sản phẩm trong giỏ hàng";
                }
            }

        } catch (NumberFormatException e) {
            message = "Dữ liệu không hợp lệ";
            e.printStackTrace();
        } catch (Exception e) {
            message = "Có lỗi xảy ra: " + e.getMessage();
            e.printStackTrace();
        }

        // Calculate cart count
        cartCount = cart.values().stream().mapToInt(CartItem::getQuantity).sum();

        // Update session
        session.setAttribute("cart", cart);
        session.setAttribute("cartSize", cartCount);

        // ✅ Enhanced AJAX response with more information
        if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
            resp.setContentType("application/json;charset=UTF-8");
            try (PrintWriter out = resp.getWriter()) {
                out.write(String.format(
                    "{\"success\": %s, \"message\": \"%s\", \"cartCount\": %d, \"cartSize\": %d}",
                    success, message, cartCount, cartCount
                ));
                out.flush();
            }
            return;
        }

        // ✅ Regular form submission - redirect back with success message
        String referer = req.getHeader("referer");
        if (referer != null && !referer.isEmpty()) {
            String redirectUrl = referer;
            if (success) {
                redirectUrl += (referer.contains("?") ? "&" : "?") + "added=true";
            }
            resp.sendRedirect(redirectUrl);
        } else {
            String redirectUrl = req.getContextPath() + "/products?action=list";
            if (success) {
                redirectUrl += "&added=true";
            }
            resp.sendRedirect(redirectUrl);
        }
    }
}