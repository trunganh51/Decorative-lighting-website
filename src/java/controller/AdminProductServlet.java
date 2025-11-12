package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import model.Category;
import model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminProductServlet", urlPatterns = "/admin/products")
@MultipartConfig
public class AdminProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final dao.OrderDAO orderDAO = new dao.OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // ✅ Kiểm tra quyền admin
        HttpSession session = req.getSession();
        model.User user = (model.User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        String action = req.getParameter("action");

        if (action == null || action.equals("list")) {
            List<Product> products = productDAO.getAllProducts();
            List<Category> categories = categoryDAO.getAllCategories();
            req.setAttribute("products", products);
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/admin/admin_products.jsp").forward(req, resp);

        } else if (action.equals("new") || action.equals("add")) {
            List<Category> categories = categoryDAO.getAllCategories();
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/admin/add_product.jsp").forward(req, resp);

        } else if (action.equals("edit")) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                Product product = productDAO.getProductById(id);
                List<Category> categories = categoryDAO.getAllCategories();
                req.setAttribute("product", product);
                req.setAttribute("categories", categories);
                req.getRequestDispatcher("/admin/edit_product.jsp").forward(req, resp);
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/admin/products?action=list");
            }

        } else if (action.equals("delete")) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                productDAO.delete(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/products?action=list");

        } else if (action.equals("revenue")) {
            // ✅ Trang biểu đồ doanh thu
            List<String[]> weeklyRevenue = orderDAO.getWeeklyRevenue();
            Map<String, List<String[]>> weeklyDetails = orderDAO.getWeeklyRevenueDetails();
            req.setAttribute("weeklyRevenue", weeklyRevenue);
            req.setAttribute("weeklyDetails", weeklyDetails);
            req.getRequestDispatcher("/admin/revenue.jsp").forward(req, resp);

        } else if (action.equals("revenueDetail")) {
            // ✅ Trang chi tiết doanh thu theo tuần
            String weekCode = req.getParameter("week");
            if (weekCode == null || weekCode.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/products?action=revenue");
                return;
            }

            List<String[]> details = orderDAO.getRevenueDetailByWeek(weekCode);
            req.setAttribute("weekCode", weekCode);
            req.setAttribute("details", details);
            req.getRequestDispatcher("/admin/revenue_detail.jsp").forward(req, resp);

        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/products?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        model.User user = (model.User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/products?action=list");
            return;
        }

        switch (action) {
            case "add":
            case "create":
                handleAddOrUpdate(req, resp, false);
                break;
            case "update":
                handleAddOrUpdate(req, resp, true);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/products?action=list");
                break;
        }
    }

    // ✅ Hàm xử lý thêm / cập nhật sản phẩm
    private void handleAddOrUpdate(HttpServletRequest req, HttpServletResponse resp, boolean isUpdate)
            throws IOException, ServletException {

        try {
            int categoryId = parseIntOrDefault(req.getParameter("categoryId"), 0);
            String name = nvl(req.getParameter("name"));
            String description = nvl(req.getParameter("description"));
            double price = parseDoubleOrDefault(req.getParameter("price"), 0d);
            int quantity = parseIntOrDefault(req.getParameter("quantity"), 0);
            int sold = parseIntOrDefault(req.getParameter("soldQuantity"), 0);
            String manufacturer = nvl(req.getParameter("manufacturer"));
            String imagePath = nvl(req.getParameter("imagePath"));

            Part filePart = req.getPart("imageFile");
            boolean hasNewImage = (filePart != null && filePart.getSize() > 0);

            if (hasNewImage) {
                String fileName = java.nio.file.Paths.get(filePart.getSubmittedFileName())
                        .getFileName().toString();

                File webInfDir = new File(req.getServletContext().getRealPath("/WEB-INF"));
                File buildDir = webInfDir.getParentFile();
                File projectDir = buildDir.getParentFile().getParentFile();
                File imageDir = new File(projectDir, "web/images");

                if (!imageDir.exists()) imageDir.mkdirs();

                if (imagePath != null && !imagePath.isEmpty()) {
                    File oldFile = new File(imageDir, new File(imagePath).getName());
                    if (oldFile.exists()) oldFile.delete();
                }

                File savedFile = new File(imageDir, fileName);
                try (var input = filePart.getInputStream()) {
                    Files.copy(input, savedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                imagePath = "images/" + fileName;
            }

            boolean ok;
            if (!isUpdate) {
                Product p = new Product(categoryId, name, description, price, imagePath);
                p.setQuantity(quantity);
                p.setSoldQuantity(sold);
                p.setManufacturer(manufacturer);
                ok = productDAO.insertProduct(p);
            } else {
                int id = parseIntOrDefault(req.getParameter("id"), 0);
                Product p = new Product(id, categoryId, name, description, price, imagePath);
                p.setQuantity(quantity);
                p.setSoldQuantity(sold);
                p.setManufacturer(manufacturer);
                ok = productDAO.updateProduct(p);
            }

            if (!ok) System.err.println("⚠️ Không thể lưu vào CSDL.");

        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin/products?action=list");
    }

    private static String nvl(String s) {
        return (s == null) ? "" : s.trim();
    }

    private static int parseIntOrDefault(String s, int def) {
        try {
            return (s == null || s.isEmpty()) ? def : Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private static double parseDoubleOrDefault(String s, double def) {
        try {
            return (s == null || s.isEmpty()) ? def : Double.parseDouble(s);
        } catch (Exception e) {
            return def;
        }
    }
}
