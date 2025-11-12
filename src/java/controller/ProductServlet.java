package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import model.Category;
import model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.Normalizer;
import java.util.List;

/**
 * Controller servlet hiển thị danh sách, chi tiết và tìm kiếm sản phẩm.
 * Hỗ trợ lọc theo danh mục cha/con, phân trang, và sản phẩm bán chạy.
 */
@WebServlet(name = "ProductServlet", urlPatterns = "/products")
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // CRITICAL: Set encoding FIRST before reading any parameters
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String action = req.getParameter("action");

        if (action == null || action.equals("list")) {
            handleListAction(req, resp);
        } else if ("search".equals(action)) {
            handleSearchAction(req, resp);
        } else if ("detail".equals(action)) {
            handleDetailAction(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/products?action=list");
        }
    }

    private void handleListAction(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String categoryParam = req.getParameter("category");
        int page = 1;
        int pageSize = 6;

        // Xác định trang hiện tại
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {}
        }

        List<Product> products;
        int totalProducts;

        if (categoryParam != null && !categoryParam.isEmpty()) {
            // Lọc theo loại "trongnha", "ngoaitroi", hoặc ID
            switch (categoryParam.toLowerCase()) {
                case "trongnha" -> {
                    products = productDAO.getProductsByParentCategoryPaged(1, page, pageSize);
                    totalProducts = productDAO.countProductsByParentCategory(1);
                }
                case "ngoaitroi" -> {
                    products = productDAO.getProductsByParentCategoryPaged(2, page, pageSize);
                    totalProducts = productDAO.countProductsByParentCategory(2);
                }
                default -> {
                    try {
                        int catId = Integer.parseInt(categoryParam);
                        products = productDAO.getProductsByCategoryPaged(catId, page, pageSize);
                        totalProducts = productDAO.countProductsByCategory(catId);
                    } catch (NumberFormatException e) {
                        products = productDAO.getProductsByPage(page, pageSize);
                        totalProducts = productDAO.countProducts();
                    }
                }
            }
        } else {
            products = productDAO.getProductsByPage(page, pageSize);
            totalProducts = productDAO.countProducts();
        }

        // Top 5 sản phẩm bán chạy
        List<Product> bestSellers = productDAO.getBestSellingProducts(5);
        List<Category> categories = categoryDAO.getAllCategories();

        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        req.setAttribute("products", products);
        req.setAttribute("bestSellers", bestSellers);
        req.setAttribute("categories", categories);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("selectedCategory", categoryParam);

        req.getRequestDispatcher("index.jsp").forward(req, resp);
    }

    /**
     * ✅ Fixed Vietnamese search handling - consolidated and cleaned up
     */
    private void handleSearchAction(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String keyword = req.getParameter("keyword");
        
        // Process Vietnamese text properly
        if (keyword != null && !keyword.isEmpty()) {
            keyword = normalizeVietnameseText(keyword);
            System.out.println("=== Processed search keyword: [" + keyword + "] ===");
        }

        // Search products
        List<Product> products = productDAO.searchProducts(keyword);
        List<Category> categories = categoryDAO.getAllCategories();

        req.setAttribute("products", products);
        req.setAttribute("categories", categories);
        req.setAttribute("searchKeyword", keyword);

        req.getRequestDispatcher("search.jsp").forward(req, resp);
    }

    private void handleDetailAction(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String idParam = req.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Product product = productDAO.getProductById(id);
                if (product != null) {
                    List<Product> relatedProducts = productDAO.getProductsByCategory(product.getCategoryId());
                    relatedProducts.removeIf(p -> p.getId() == product.getId());
                    if (relatedProducts.size() > 6)
                        relatedProducts = relatedProducts.subList(0, 6);

                    req.setAttribute("product", product);
                    req.setAttribute("relatedProducts", relatedProducts);
                    req.getRequestDispatcher("product_detail.jsp").forward(req, resp);
                    return;
                }
            } catch (NumberFormatException ignored) {}
        }
        resp.sendRedirect(req.getContextPath() + "/products?action=list");
    }

    /**
     * ✅ Consolidated Vietnamese text normalization
     * Uses Java's built-in Normalizer for proper Unicode handling
     */
    private String normalizeVietnameseText(String text) {
        if (text == null || text.isEmpty()) {
            return text;
        }
        
        // Step 1: Trim whitespace
        text = text.trim();
        
        // Step 2: Unicode normalization (NFC form for Vietnamese)
        text = Normalizer.normalize(text, Normalizer.Form.NFC);
        
        // Step 3: Remove clearly invalid characters while preserving Vietnamese
        // Keep letters, numbers, spaces, hyphens, underscores, dots
        text = text.replaceAll("[^\\p{L}\\p{N}\\s\\-_.]", "");
        
        // Step 4: Normalize whitespace
        text = text.replaceAll("\\s+", " ").trim();
        
        return text;
    }
}