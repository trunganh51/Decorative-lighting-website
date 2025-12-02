package controller;

import dao.CouponDAO;
import model.Coupon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@WebServlet(name = "AdminCouponServlet", urlPatterns = "/admin/coupons")
public class AdminCouponServlet extends HttpServlet {

    private final CouponDAO couponDAO = new CouponDAO();
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // quyền admin
        HttpSession session = req.getSession();
        model.User user = (model.User) session.getAttribute("user");

        if (user == null || !"admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null || action.isEmpty()) action = "list";

        switch (action) {
            case "list":
            default: {
                List<Coupon> coupons = couponDAO.getAllCoupons();
                req.setAttribute("coupons", coupons);
                req.getRequestDispatcher("/admin/admin_coupons.jsp").forward(req, resp);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        model.User user = (model.User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            // ===========================
            // ADD NEW COUPON
            // ===========================
            case "add": {

                String code = nvl(req.getParameter("code")).toUpperCase();
                String description = nvl(req.getParameter("description"));
                String discountType = req.getParameter("discountType"); // percent | fixed
                Double value = parseDoubleOrNull(req.getParameter("value"));
                boolean active = "on".equals(req.getParameter("active"));

                // Parse date theo đầu-ngày/cuối-ngày
                Date startDate = parseDateStartOfDayOrNull(req.getParameter("startDate"));
                Date endDate = parseDateEndOfDayOrNull(req.getParameter("endDate"));

                // Nếu bỏ trống -> set mặc định an toàn để không vi phạm NOT NULL trong DB
                Date now = new Date();
                if (startDate == null) startDate = startOfDay(now);
                if (endDate == null) endDate = endOfDay(addDays(startDate, 365));

                // Nếu end < start -> chỉnh lại end
                if (endDate.before(startDate)) {
                    endDate = endOfDay(startDate);
                }

                Coupon c = new Coupon();
                c.setCode(code);
                c.setDescription(description);
                c.setDiscountType(discountType);
                c.setValue(value);
                c.setActive(active);

                // optional + đã chuẩn hoá
                c.setStartDate(startDate);
                c.setEndDate(endDate);
                c.setMinSubtotal(parseDoubleOrNull(req.getParameter("minSubtotal")));
                c.setMaxDiscount(parseDoubleOrNull(req.getParameter("maxDiscount")));
                c.setUsageLimit(parseIntOrNull(req.getParameter("usageLimit")));

                if (!couponDAO.existsByCode(code)) {
                    boolean ok = couponDAO.insert(c);
                    // Có thể bổ sung flash message nếu cần
                } else {
                    // Có thể set flash vào session để hiển thị sau redirect nếu muốn
                    // session.setAttribute("flash", "Mã coupon đã tồn tại!");
                }

                resp.sendRedirect(req.getContextPath() + "/admin/coupons?action=list");
                return;
            }

            // ===========================
            // TOGGLE ACTIVE
            // ===========================
            case "toggle": {
                int id = parseIntOrDefault(req.getParameter("id"), 0);
                boolean active = "1".equals(req.getParameter("active"));
                couponDAO.updateActive(id, active);
                resp.sendRedirect(req.getContextPath() + "/admin/coupons?action=list");
                return;
            }

            // ===========================
            // DELETE
            // ===========================
            case "delete": {
                int id = parseIntOrDefault(req.getParameter("id"), 0);
                couponDAO.deleteById(id);
                resp.sendRedirect(req.getContextPath() + "/admin/coupons?action=list");
                return;
            }

            default:
                resp.sendRedirect(req.getContextPath() + "/admin/coupons?action=list");
        }
    }

    // ===========================
    // UTILS
    // ===========================
    private static String nvl(String s) { return (s == null) ? "" : s.trim(); }
    private static Double parseDoubleOrNull(String s) { try { return (s == null || s.isEmpty()) ? null : Double.valueOf(s); } catch(Exception e){ return null; } }
    private Integer parseIntOrNull(String s) { try { return (s == null || s.isEmpty()) ? null : Integer.valueOf(s); } catch(Exception e){return null;} }
    private int parseIntOrDefault(String s, int def) { try { return (s == null || s.isEmpty()) ? def : Integer.parseInt(s); } catch(Exception e){ return def; } }
    private java.util.Date parseDateOrNull(String s) { try { return (s == null || s.isEmpty()) ? null : sdf.parse(s); } catch(Exception e){ return null; } }

    private Date parseDateStartOfDayOrNull(String s) {
        Date d = parseDateOrNull(s);
        return d == null ? null : startOfDay(d);
        }

    private Date parseDateEndOfDayOrNull(String s) {
        Date d = parseDateOrNull(s);
        return d == null ? null : endOfDay(d);
    }

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