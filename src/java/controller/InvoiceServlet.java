package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.OrderDetail;

import java.io.IOException;
import java.util.*;

@WebServlet(name="InvoiceServlet", urlPatterns={"/invoice/print"})
public class InvoiceServlet extends HttpServlet {

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { render(req,resp); }
    @Override protected void doGet (HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { render(req,resp); }

    private void render(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendError(400,"Session không tồn tại"); return; }

        @SuppressWarnings("unchecked")
        Map<Integer, OrderDetail> cart = (Map<Integer, OrderDetail>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) { resp.sendError(400,"Giỏ hàng trống"); return; }

        req.setAttribute("inv_receiver", param(req,"receiverName","buyer_name"));
        req.setAttribute("inv_phone",    param(req,"phone","buyer_tel"));
        req.setAttribute("inv_address",  param(req,"address","buyer_address"));
        req.setAttribute("inv_note",     param(req,"note"));
        req.setAttribute("inv_coupon",   param(req,"couponCode"));
        req.setAttribute("inv_method",   param(req,"shippingMethod","shippingMethodHidden","shippingMethodSelect"));

        List<OrderDetail> lines = new ArrayList<>();
        double subtotal = 0;
        for (OrderDetail c : cart.values()) {
            OrderDetail d = new OrderDetail();
            d.setProductId(c.getProduct() != null ? c.getProduct().getId() : c.getProductId());
            d.setQuantity(c.getQuantity());
            d.setPrice(c.getPrice());
            d.setProduct(c.getProduct());
            subtotal += d.getSubtotal();
            lines.add(d);
        }
        req.setAttribute("inv_items", lines);
        req.setAttribute("inv_subtotal", subtotal);

        double tax = Math.round(subtotal * 0.10 * 100.0)/100.0;
        double shipFee;
        String sm = (String) req.getAttribute("inv_method");
        if (sm == null) sm = "standard";
        shipFee = switch (sm) {
            case "express" -> 60000;
            case "overnight" -> 120000;
            default -> 30000;
        };
        req.setAttribute("inv_tax", tax);
        req.setAttribute("inv_ship", shipFee);
        double total = subtotal + tax + shipFee;
        req.setAttribute("inv_total", total);

        req.getRequestDispatcher("/WEB-INF/views/invoice_print.jsp").forward(req, resp);
    }

    private String param(HttpServletRequest r, String... names){
        for(String n: names){
            String v = r.getParameter(n);
            if(v!=null && !v.trim().isEmpty()) return v.trim();
        }
        return "";
    }
}