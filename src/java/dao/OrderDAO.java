package dao;

import model.Order;
import model.OrderDetail;
import model.CartItem;

import java.sql.*;
import java.util.*;

public class OrderDAO {

    /** 🧾 Tạo đơn hàng mới cùng chi tiết sản phẩm */
    public boolean createOrder(int userId, String address, Map<Integer, CartItem> cart) {
        String insertOrderSQL = """
            INSERT INTO orders (user_id, shipping_address, total_price, status, order_date)
            VALUES (?, ?, ?, ?, ?)
        """;
        String insertDetailSQL = """
            INSERT INTO orderdetails (order_id, product_id, quantity, price)
            VALUES (?, ?, ?, ?)
        """;

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            double total = cart.values().stream()
                    .mapToDouble(item -> item.getProduct().getPrice() * item.getQuantity())
                    .sum();

            int orderId = -1;
            try (PreparedStatement ps = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setString(2, address);
                ps.setDouble(3, total);
                ps.setString(4, "Chờ duyệt");
                ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) orderId = rs.getInt(1);
                }
            }

            if (orderId <= 0) {
                conn.rollback();
                return false;
            }

            try (PreparedStatement psDetail = conn.prepareStatement(insertDetailSQL)) {
                for (CartItem item : cart.values()) {
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, item.getProduct().getId());
                    psDetail.setInt(3, item.getQuantity());
                    psDetail.setDouble(4, item.getProduct().getPrice());
                    psDetail.addBatch();
                }
                psDetail.executeBatch();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** 📦 Lấy danh sách đơn hàng theo người dùng */
    public List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = """
            SELECT o.*, u.full_name AS user_name
            FROM orders o
            JOIN users u ON o.user_id = u.user_id
            WHERE o.user_id = ?
            ORDER BY o.order_date DESC
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapOrder(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 📋 Lấy tất cả đơn hàng (cho admin) */
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = """
            SELECT o.*, u.full_name AS user_name
            FROM orders o
            JOIN users u ON o.user_id = u.user_id
            ORDER BY o.order_date DESC
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapOrder(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 🧩 Lấy chi tiết sản phẩm trong 1 đơn hàng */
    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM orderdetails WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetail d = new OrderDetail();
                d.setDetailId(rs.getInt("detail_id"));
                d.setOrderId(rs.getInt("order_id"));
                d.setProductId(rs.getInt("product_id"));
                d.setQuantity(rs.getInt("quantity"));
                d.setPrice(rs.getDouble("price"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 🔄 Admin duyệt đơn hàng — chuyển 'Chờ duyệt' → 'Đang giao' */
    public boolean approveOrderByAdmin(int orderId) {
        String sql = "UPDATE orders SET status = 'Đang giao' WHERE order_id = ? AND LOWER(status) LIKE 'chờ duyệt'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** 🧠 Ánh xạ dữ liệu đơn hàng */
    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        try {
            o.setUserName(rs.getString("user_name"));
        } catch (SQLException ignored) {}
        o.setShippingAddress(rs.getString("shipping_address"));
        o.setTotalPrice(rs.getDouble("total_price"));
        o.setStatus(rs.getString("status"));
        o.setOrderDate(rs.getTimestamp("order_date"));
        return o;
    }

    /** 🔍 Lấy thông tin 1 đơn hàng theo ID */
    public Order getOrderById(int orderId) {
        String sql = """
            SELECT o.*, u.full_name AS user_name
            FROM orders o
            JOIN users u ON o.user_id = u.user_id
            WHERE o.order_id = ?
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapOrder(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /** 🔹 Thêm một đơn hàng (hàm cần cho reorder) */
    public int insert(Order order) {
        String sql = """
            INSERT INTO orders (user_id, shipping_address, total_price, status, order_date)
            VALUES (?, ?, ?, ?, ?)
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, order.getUserId());
            ps.setString(2, order.getShippingAddress());
            ps.setDouble(3, order.getTotalPrice());
            ps.setString(4, order.getStatus());
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /** ❌ Xóa đơn hàng */
    public boolean deleteOrder(int orderId) {
        String sql = "DELETE FROM orders WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** 📊 Lấy 5 tuần gần nhất có doanh thu (chỉ tính đơn 'Đã giao') */
    public List<String[]> getWeeklyRevenue() {
    List<String[]> list = new ArrayList<>();
    String sql = """
        WITH weeks AS (
            SELECT CAST(YEARWEEK(DATE_SUB(CURDATE(), INTERVAL seq WEEK), 1) AS CHAR) AS week_code
            FROM (
                SELECT 0 AS seq UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
            ) AS t
        )
        SELECT w.week_code,
               COALESCE(SUM(d.quantity * d.price), 0) AS revenue
        FROM weeks w
        LEFT JOIN orders o ON CAST(YEARWEEK(o.order_date, 1) AS CHAR) = w.week_code AND o.status = 'Đã giao'
        LEFT JOIN orderdetails d ON o.order_id = d.order_id
        GROUP BY w.week_code
        ORDER BY w.week_code ASC
    """;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            String weekCode = rs.getString("week_code").trim(); // ✅ chuẩn hóa chuỗi tuần
            double revenue = rs.getDouble("revenue");

            String weekLabel;
            try {
                int weekNum = Integer.parseInt(weekCode.substring(4));
                weekLabel = "Tuần " + weekNum;
            } catch (Exception e) {
                weekLabel = weekCode;
            }

            list.add(new String[]{weekLabel, String.valueOf(revenue), weekCode});
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}


  public Map<String, List<String[]>> getWeeklyRevenueDetails() {
    Map<String, List<String[]>> map = new LinkedHashMap<>();

    String sql = """
        SELECT 
            CAST(YEARWEEK(o.order_date, 1) AS CHAR) AS week_code,   -- ✅ ép sang chuỗi
            p.name AS product_name,
            SUM(d.quantity) AS total_qty,
            SUM(d.quantity * d.price) AS total_revenue
        FROM orders o
        INNER JOIN orderdetails d ON o.order_id = d.order_id
        INNER JOIN products p ON p.product_id = d.product_id
        WHERE o.status = 'Đã giao'
        GROUP BY week_code, p.name
        ORDER BY week_code DESC
        LIMIT 100
    """;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            String weekCode = rs.getString("week_code").trim(); // ✅ bỏ khoảng trắng dư
            String productName = rs.getString("product_name");
            int qty = rs.getInt("total_qty");
            double revenue = rs.getDouble("total_revenue");

            // gom nhóm theo tuần
            map.computeIfAbsent(weekCode, k -> new ArrayList<>())
               .add(new String[]{
                   productName,
                   String.valueOf(qty),
                   String.format("%.0f", revenue)
               });
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return map;
}


    /** 💰 Tổng doanh thu (chỉ tính đơn 'Đã giao') */
    public double getTotalRevenue() {
        String sql = "SELECT SUM(total_price) FROM orders WHERE status = 'Đã giao'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 🔄 Cập nhật trạng thái đơn hàng */
    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<String[]> getRevenueDetailByWeek(String weekCode) {
    List<String[]> list = new ArrayList<>();
    String sql = """
        SELECT p.name, SUM(d.quantity) AS qty, SUM(d.quantity * d.price) AS revenue
        FROM orders o
        JOIN orderdetails d ON o.order_id = d.order_id
        JOIN products p ON p.product_id = d.product_id
        WHERE o.status = 'Đã giao' AND YEARWEEK(o.order_date, 1) = ?
        GROUP BY p.name
    """;
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, weekCode);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    rs.getString("name"),
                    rs.getString("qty"),
                    String.format("%.0f", rs.getDouble("revenue"))
                });
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

}
