package dao;

import model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Data access object (DAO) for performing CRUD operations on products.
 * This class uses JDBC with prepared statements to interact with MySQL.
 */
public class ProductDAO {

    /** Lấy tất cả sản phẩm **/
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products ORDER BY product_id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = extractProduct(rs);
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Lấy sản phẩm theo danh mục **/
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE category_id = ? ORDER BY product_id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = extractProduct(rs);
                    list.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Lấy 1 sản phẩm theo ID **/
    public Product getProductById(int id) {
        Product p = null;
        String sql = "SELECT * FROM Products WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = extractProduct(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }

    /** Lấy sản phẩm bán chạy nhất **/
    public List<Product> getBestSellingProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products ORDER BY sold_quantity DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = extractProduct(rs);
                    list.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 
     * Tìm kiếm sản phẩm theo tên (hỗ trợ tiếng Việt với proper collation)
     */
    public List<Product> searchProducts(String keyword) {
        List<Product> list = new ArrayList<>();

        if (keyword == null || keyword.trim().isEmpty()) {
            return list;
        }

        // Enhanced search with proper Vietnamese collation and ranking
        String sql = """
            SELECT * FROM Products 
            WHERE name LIKE ? COLLATE utf8mb4_unicode_520_ci 
               OR description LIKE ? COLLATE utf8mb4_vietnamese_ci
            ORDER BY 
                CASE 
                    WHEN name LIKE ? THEN 1
                    WHEN name LIKE ? THEN 2
                    WHEN description LIKE ? THEN 3
                    ELSE 4
                END,
                sold_quantity DESC,
                product_id DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword.trim() + "%";
            String exactPattern = keyword.trim() + "%";
            
            ps.setString(1, searchPattern);  // name LIKE
            ps.setString(2, searchPattern);  // description LIKE
            ps.setString(3, exactPattern);   // exact match priority
            ps.setString(4, searchPattern);  // partial match priority
            ps.setString(5, searchPattern);  // description match priority

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = extractProduct(rs);
                    list.add(p);
                }
            }

            System.out.println("✅ Found " + list.size() + " products for keyword: [" + keyword + "]");

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ Database search error for keyword: [" + keyword + "] - " + e.getMessage());
        }

        return list;
    }

    /** Tính doanh thu từng sản phẩm **/
    public List<String[]> getRevenueByProduct() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT name, price * sold_quantity AS revenue FROM Products";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String name = rs.getString("name");
                double revenue = rs.getDouble("revenue");
                list.add(new String[]{name, String.valueOf(revenue)});
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Cập nhật thông tin một sản phẩm hiện có. Trả về true nếu cập nhật thành công.
     */
    public boolean update(Product p) {
        String sql = "UPDATE Products SET category_id = ?, name = ?, description = ?, price = ?, image_path = ?, quantity = ?, sold_quantity = ?, manufacturer = ? WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getDescription());
            ps.setDouble(4, p.getPrice());
            ps.setString(5, p.getImagePath());
            ps.setInt(6, p.getQuantity());
            ps.setInt(7, p.getSoldQuantity());
            ps.setString(8, p.getManufacturer());
            ps.setInt(9, p.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thêm sản phẩm mới (đầy đủ các trường quantity, sold_quantity, manufacturer)
     */
    public boolean insertProduct(Product p) {
        String sql = """
            INSERT INTO Products (category_id, name, description, price, quantity, sold_quantity, manufacturer, image_path)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getDescription());
            ps.setDouble(4, p.getPrice());
            ps.setInt(5, p.getQuantity());
            ps.setInt(6, p.getSoldQuantity());
            ps.setString(7, p.getManufacturer());
            ps.setString(8, p.getImagePath());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật sản phẩm (admin)
     */
    public boolean updateProduct(Product p) {
        String sql = """
            UPDATE Products
            SET category_id = ?, name = ?, description = ?, price = ?, 
                quantity = ?, sold_quantity = ?, manufacturer = ?, image_path = ?
            WHERE product_id = ?
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getDescription());
            ps.setDouble(4, p.getPrice());
            ps.setInt(5, p.getQuantity());
            ps.setInt(6, p.getSoldQuantity());
            ps.setString(7, p.getManufacturer());
            ps.setString(8, p.getImagePath());
            ps.setInt(9, p.getId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xoá sản phẩm theo ID. Trả về true nếu xóa thành công.
     */
    public boolean delete(int productId) {
        String sql = "DELETE FROM Products WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Thêm sản phẩm mới (đơn giản) **/
    public boolean insert(Product product) {
        String sql = "INSERT INTO Products (category_id, name, description, price, image_path) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getName());
            ps.setString(3, product.getDescription());
            ps.setDouble(4, product.getPrice());
            ps.setString(5, product.getImagePath());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Lấy sản phẩm theo trang (phân trang) **/
    public List<Product> getProductsByPage(int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products ORDER BY product_id DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = extractProduct(rs);
                    list.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Đếm tổng số sản phẩm **/
    public int countProducts() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Products";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    /** 
     * Lấy tất cả sản phẩm thuộc một danh mục cha (bao gồm danh mục con của nó)
     */
    public List<Product> getProductsByParentCategory(int parentId) {
        List<Product> list = new ArrayList<>();
        String sql = """
            SELECT p.*
            FROM Products p
            JOIN Categories c ON p.category_id = c.category_id
            WHERE c.parent_id = ? OR p.category_id = ?
            ORDER BY p.product_id DESC
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, parentId);
            ps.setInt(2, parentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = extractProduct(rs);
                    list.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy sản phẩm dựa trên tên định danh (ví dụ: trongnha, ngoaitroi)
     */
    public List<Product> getProductsByAlias(String alias) {
        if (alias == null) return getAllProducts();
        if (alias.equalsIgnoreCase("trongnha")) return getProductsByParentCategory(1);
        if (alias.equalsIgnoreCase("ngoaitroi")) return getProductsByParentCategory(2);
        try {
            int id = Integer.parseInt(alias);
            return getProductsByCategory(id);
        } catch (NumberFormatException e) {
            return getAllProducts();
        }
    }

    // Lấy sản phẩm theo danh mục con có phân trang
    public List<Product> getProductsByCategoryPaged(int categoryId, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE category_id = ? ORDER BY product_id DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = extractProduct(rs);
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy sản phẩm theo danh mục cha có phân trang
    public List<Product> getProductsByParentCategoryPaged(int parentId, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        String sql = """
            SELECT p.* FROM Products p
            JOIN Categories c ON p.category_id = c.category_id
            WHERE c.parent_id = ? OR p.category_id = ?
            ORDER BY p.product_id DESC LIMIT ? OFFSET ?
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, parentId);
            ps.setInt(3, pageSize);
            ps.setInt(4, (page - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = extractProduct(rs);
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm sản phẩm theo danh mục con
    public int countProductsByCategory(int categoryId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Products WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // Đếm sản phẩm theo danh mục cha
    public int countProductsByParentCategory(int parentId) {
        int count = 0;
        String sql = """
            SELECT COUNT(*) FROM Products p
            JOIN Categories c ON p.category_id = c.category_id
            WHERE c.parent_id = ? OR p.category_id = ?
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, parentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    /**
     * Helper method to extract Product from ResultSet
     * Centralizes the product creation logic
     */
    private Product extractProduct(ResultSet rs) {
        Product p = new Product();
        try {
            p.setId(rs.getInt("product_id"));
            p.setCategoryId(rs.getInt("category_id"));
            p.setName(rs.getString("name"));
            p.setDescription(rs.getString("description"));
            p.setPrice(rs.getDouble("price"));
            p.setImagePath(rs.getString("image_path"));
            
            // Handle optional columns that might not exist
            try { 
                p.setSoldQuantity(rs.getInt("sold_quantity")); 
            } catch (Exception ignore) { 
                p.setSoldQuantity(0); 
            }
            
            try { 
                p.setManufacturer(rs.getString("manufacturer")); 
            } catch (Exception ignore) { 
                p.setManufacturer(""); 
            }
            
            try { 
                p.setQuantity(rs.getInt("quantity")); 
            } catch (Exception ignore) { 
                p.setQuantity(0); 
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error extracting product from ResultSet: " + e.getMessage());
        }
        return p;
    }
}