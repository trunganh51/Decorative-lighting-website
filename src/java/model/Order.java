package model;

import java.util.Date;
import java.util.List;

/**
 * Đại diện cho một đơn hàng của người dùng.
 */
public class Order {
    private int orderId;
    private int userId;
    private String userName; // 🔹 Thêm: tên người đặt
    private String shippingAddress;
    private double totalPrice;
    private String status;
    private Date orderDate;
    private List<OrderDetail> orderDetails; // danh sách chi tiết sản phẩm

    // ===== Constructors =====
    public Order() {
    }

    public Order(int orderId, int userId, String shippingAddress, double totalPrice, String status, Date orderDate) {
        this.orderId = orderId;
        this.userId = userId;
        this.shippingAddress = shippingAddress;
        this.totalPrice = totalPrice;
        this.status = status;
        this.orderDate = orderDate;
    }

    // ===== Getter & Setter =====
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }
}
