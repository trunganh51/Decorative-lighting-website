package dao;

import model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * ProductDAO chuẩn hoá cho schema 'products'. Bao gồm: CRUD, phân trang + sort,
 * lọc theo danh mục cha/con, tìm kiếm nâng cao, tồn kho, bán chạy.
 * ĐÃ BỔ SUNG: getProductsByIdsPreserveOrder(List<Integer>)
 */
public class ProductDAO {

    /* ========== CRUD cơ bản ========== */
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY product_id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractProduct(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Version chuẩn
    public boolean insertProduct(Product p) {
        String sql = """
            INSERT INTO products (category_id, name, description, price, quantity, sold_quantity, manufacturer, image_path)
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

    // Tương thích ngược
    public boolean insert(Product product) {
        String sql = "INSERT INTO products (category_id, name, description, price, image_path) VALUES (?, ?, ?, ?, ?)";
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

    // Version chuẩn
    public boolean updateProduct(Product p) {
        String sql = """
            UPDATE products
            SET category_id=?, name=?, description=?, price=?,
                quantity=?, sold_quantity=?, manufacturer=?, image_path=?
            WHERE product_id=?
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

    // Tương thích ngược
    public boolean update(Product p) {
        return updateProduct(p);
    }

    public boolean delete(int productId) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ========== Phân trang + sắp xếp ========== */
    private String buildOrderClause(String sortBy) {
        if ("price_asc".equalsIgnoreCase(sortBy)) {
            return "ORDER BY price ASC";
        }
        if ("price_desc".equalsIgnoreCase(sortBy)) {
            return "ORDER BY price DESC";
        }
        if ("name_asc".equalsIgnoreCase(sortBy)) {
            return "ORDER BY name ASC";
        }
        if ("name_desc".equalsIgnoreCase(sortBy)) {
            return "ORDER BY name DESC";
        }
        return "ORDER BY product_id DESC";
    }

    public List<Product> getProductsByPageSorted(int page, int pageSize, String sortBy) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products " + buildOrderClause(sortBy) + " LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractProduct(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /* ========== Theo danh mục con (category) ========== */
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category_id = ? ORDER BY product_id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractProduct(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getProductsByCategoryPagedSorted(int categoryId, int page, int pageSize, String sortBy) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category_id = ? " + buildOrderClause(sortBy) + " LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractProduct(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countProductsByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM products WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /* ========== Theo danh mục cha (parent category) ========== */
    public List<Product> getProductsByParentCategory(int parentId) {
        List<Product> list = new ArrayList<>();
        String sql = """
            SELECT p.*
            FROM products p
            JOIN categories c ON p.category_id = c.category_id
            WHERE c.parent_id = ? OR p.category_id = ?
            ORDER BY p.product_id DESC
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, parentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractProduct(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getProductsByParentCategoryPagedSorted(int parentId, int page, int pageSize, String sortBy) {
        List<Product> list = new ArrayList<>();
        String sql = """
            SELECT p.*
            FROM products p
            JOIN categories c ON p.category_id = c.category_id
            WHERE c.parent_id = ? OR p.category_id = ?
        """ + buildOrderClause(sortBy) + " LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, parentId);
            ps.setInt(3, pageSize);
            ps.setInt(4, (page - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractProduct(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countProductsByParentCategory(int parentId) {
        String sql = """
            SELECT COUNT(*)
            FROM products p
            JOIN categories c ON p.category_id = c.category_id
            WHERE c.parent_id = ? OR p.category_id = ?
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, parentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /* ========== Tìm kiếm nâng cao ========== */
    public List<Product> searchProductsAdvanced(String keyword, Double minPrice, Double maxPrice,
                                                Integer categoryId, int page, int pageSize, String sortBy) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (LOWER(name) LIKE ? OR LOWER(description) LIKE ?)");
            String kw = "%" + keyword.toLowerCase().trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (minPrice != null) {
            sql.append(" AND price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
            params.add(maxPrice);
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND category_id = ?");
            params.add(categoryId);
        }
        sql.append(" ").append(buildOrderClause(sortBy)).append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractProduct(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countProductsAdvanced(String keyword, Double minPrice, Double maxPrice, Integer categoryId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(product_id) FROM products WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (LOWER(name) LIKE ? OR LOWER(description) LIKE ?)");
            String kw = "%" + keyword.toLowerCase().trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (minPrice != null) {
            sql.append(" AND price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
            params.add(maxPrice);
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND category_id = ?");
            params.add(categoryId);
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /* ========== Doanh thu & bán chạy ========== */
    public List<String[]> getRevenueByProduct() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT name, price * sold_quantity AS revenue FROM products";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{rs.getString("name"), String.valueOf(rs.getDouble("revenue"))});
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getBestSellingProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY sold_quantity DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractProduct(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /* ========== Tồn kho ========== */
    public List<Product> getLowStockProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE quantity <= 20 ORDER BY quantity ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getInStockProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE quantity > 20 ORDER BY quantity ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateQuantity(int productId, int quantityToAdd) {
        String sql = "UPDATE products SET quantity = quantity + ? WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantityToAdd);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean decreaseQuantity(int productId, int amount) {
        String sql = "UPDATE products SET quantity = quantity - ? WHERE product_id = ? AND quantity >= ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, amount);
            ps.setInt(2, productId);
            ps.setInt(3, amount);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ========== Lấy theo list ID (giữ thứ tự) ========== */
    public List<Product> getProductsByIdsPreserveOrder(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) {
            return new ArrayList<>();
        }
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE product_id IN (");
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) sql.append(",");
            sql.append("?");
        }
        sql.append(")");

        Map<Integer, Product> map = new LinkedHashMap<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = extractProduct(rs);
                    map.put(p.getId(), p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        List<Product> result = new ArrayList<>();
        for (Integer id : ids) {
            Product p = map.get(id);
            if (p != null) {
                result.add(p);
            }
        }
        return result;
    }

    /* ========== Helper ========== */
    private Product extractProduct(ResultSet rs) {
        Product p = new Product();
        try {
            p.setId(rs.getInt("product_id"));
            p.setCategoryId(rs.getInt("category_id"));
            p.setName(rs.getString("name"));
            p.setDescription(rs.getString("description"));
            p.setPrice(rs.getDouble("price"));
            p.setImagePath(rs.getString("image_path"));
            try { p.setSoldQuantity(rs.getInt("sold_quantity")); } catch (Exception ignore) {}
            try { p.setManufacturer(rs.getString("manufacturer")); } catch (Exception ignore) {}
            try { p.setQuantity(rs.getInt("quantity")); } catch (Exception ignore) {}
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }
}