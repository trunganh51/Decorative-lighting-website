package dao;

import model.Coupon;

import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class CouponDAO {

    public static class Preview {
        public boolean valid;
        public String message;
        public String code;
        public String type; // percent|fixed
        public Double value;
        public Double maxDiscount;
        public Double minSubtotal;
        public Double discount;
        public Double discountedTotal;
    }

    public List<Coupon> getAllCoupons() {
        List<Coupon> list = new ArrayList<>();
        String sql = "SELECT coupon_id, code, description, discount_type, value, max_discount, start_at, end_at, usage_limit, used_count, min_subtotal, active FROM coupons ORDER BY coupon_id DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Coupon cp = new Coupon();
                cp.setId(rs.getInt("coupon_id"));
                cp.setCode(rs.getString("code"));
                cp.setDescription(rs.getString("description"));
                cp.setDiscountType(rs.getString("discount_type"));
                cp.setValue(rs.getDouble("value"));
                java.math.BigDecimal md = rs.getBigDecimal("max_discount");
                cp.setMaxDiscount(md != null ? md.doubleValue() : null);
                cp.setStartDate(rs.getTimestamp("start_at"));
                cp.setEndDate(rs.getTimestamp("end_at"));
                Number ul = (Number) rs.getObject("usage_limit");
                cp.setUsageLimit(ul != null ? ul.intValue() : null);
                cp.setUsedCount(rs.getInt("used_count"));
                cp.setMinSubtotal(rs.getDouble("min_subtotal"));
                cp.setActive(rs.getBoolean("active"));
                list.add(cp);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean existsByCode(String code) {
        String sql = "SELECT 1 FROM coupons WHERE code = ? LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean insert(Coupon cpn) {
        String sql = "INSERT INTO coupons (code, description, discount_type, value, max_discount, start_at, end_at, usage_limit, min_subtotal, active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            // Chuẩn hoá thời gian để không vi phạm NOT NULL và đảm bảo hiệu lực đến hết ngày
            Date start = cpn.getStartDate();
            Date end = cpn.getEndDate();
            Date now = new Date();
            if (start == null) start = startOfDay(now);
            else start = startOfDay(start);

            if (end == null) end = endOfDay(addDays(start, 365));
            else end = endOfDay(end);

            if (end.before(start)) end = endOfDay(start);

            ps.setString(1, cpn.getCode());
            ps.setString(2, cpn.getDescription());
            ps.setString(3, cpn.getDiscountType());
            ps.setDouble(4, cpn.getValue() != null ? cpn.getValue() : 0d);

            if (cpn.getMaxDiscount() == null) ps.setNull(5, Types.DECIMAL);
            else ps.setBigDecimal(5, java.math.BigDecimal.valueOf(cpn.getMaxDiscount()));

            ps.setTimestamp(6, new Timestamp(start.getTime()));
            ps.setTimestamp(7, new Timestamp(end.getTime()));

            if (cpn.getUsageLimit() == null) ps.setNull(8, Types.INTEGER);
            else ps.setInt(8, cpn.getUsageLimit());

            if (cpn.getMinSubtotal() == null) ps.setNull(9, Types.DECIMAL);
            else ps.setBigDecimal(9, java.math.BigDecimal.valueOf(cpn.getMinSubtotal()));

            ps.setBoolean(10, cpn.isActive());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateActive(int id, boolean active) {
        String sql = "UPDATE coupons SET active = ? WHERE coupon_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteById(int id) {
        String sql = "DELETE FROM coupons WHERE coupon_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // Validate/preview giảm trừ theo code + subtotal (dùng cho cart/payment)
    public Preview validatePreview(String code, double subtotal) {
        Preview p = new Preview();
        p.code = code;
        if (code == null || code.trim().isEmpty() || subtotal <= 0) {
            p.valid = false; p.message = "Thiếu mã hoặc tổng tiền không hợp lệ";
            return p;
        }
        String sql = "SELECT code, discount_type, value, max_discount, start_at, end_at, usage_limit, used_count, min_subtotal, active FROM coupons WHERE code = ? LIMIT 1";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, code.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) { p.valid = false; p.message = "Mã không tồn tại"; return p; }

                boolean active = rs.getBoolean("active");
                Timestamp startAt = rs.getTimestamp("start_at");
                Timestamp endAt = rs.getTimestamp("end_at");
                Number ul = (Number) rs.getObject("usage_limit");
                Integer usageLimit = ul != null ? ul.intValue() : null;
                int usedCount = rs.getInt("used_count");
                double minSubtotal = rs.getDouble("min_subtotal");
                String type = rs.getString("discount_type");
                double value = rs.getDouble("value");
                java.math.BigDecimal md = (java.math.BigDecimal) rs.getObject("max_discount");
                Double maxDiscount = (md != null ? md.doubleValue() : null);

                long now = System.currentTimeMillis();
                if (!active) { p.valid=false; p.message="Mã đang tắt"; return p; }
                if (startAt != null && now < startAt.getTime()) { p.valid=false; p.message="Mã chưa hiệu lực"; return p; }
                if (endAt != null && now > endAt.getTime()) { p.valid=false; p.message="Mã đã hết hạn"; return p; }
                if (usageLimit != null && usedCount >= usageLimit) { p.valid=false; p.message="Mã đã hết lượt dùng"; return p; }
                if (subtotal < (minSubtotal <= 0 ? 0 : minSubtotal)) { p.valid=false; p.message="Chưa đạt tối thiểu " + (long)minSubtotal; return p; }

                double discount;
                if ("percent".equalsIgnoreCase(type)) {
                    // ROUND 2 chữ số như DB
                    java.math.BigDecimal bdSubtotal = java.math.BigDecimal.valueOf(subtotal);
                    java.math.BigDecimal bdRate = java.math.BigDecimal.valueOf(value).divide(java.math.BigDecimal.valueOf(100));
                    double d = bdSubtotal.multiply(bdRate).setScale(2, java.math.RoundingMode.HALF_UP).doubleValue();
                    discount = d;
                    if (maxDiscount != null) discount = Math.min(discount, maxDiscount);
                } else {
                    discount = Math.min(value, subtotal);
                    discount = java.math.BigDecimal.valueOf(discount).setScale(2, java.math.RoundingMode.HALF_UP).doubleValue();
                }

                p.valid = true;
                p.message = "Áp dụng thành công";
                p.type = type;
                p.value = value;
                p.maxDiscount = maxDiscount;
                p.minSubtotal = minSubtotal;
                p.discount = discount;
                p.discountedTotal = Math.max(0, subtotal - discount);
            }
        } catch (Exception e) {
            e.printStackTrace();
            p.valid = false; p.message = "Lỗi máy chủ";
        }
        return p;
    }

    // ===== helpers =====
    private static Date startOfDay(Date d) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(d);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return cal.getTime();
    }
    private static Date endOfDay(Date d) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(d);
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        cal.set(Calendar.MILLISECOND, 999);
        return cal.getTime();
    }
    private static Date addDays(Date d, int days) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(d);
        cal.add(Calendar.DAY_OF_MONTH, days);
        return cal.getTime();
    }
}