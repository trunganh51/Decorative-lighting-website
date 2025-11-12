package model;

/**
 * Represents a single product in the shop. Products belong to a category
 * and have a name, description, price and image path. For simplicity
 * this model does not store stock levels or other advanced attributes.
 */
public class Product {
    private int id;
    private int categoryId;
    private String name;
    private String description;
    private double price;
    private String imagePath;
private String categoryName;

public String getCategoryName() {
    return categoryName;
}

public void setCategoryName(String categoryName) {
    this.categoryName = categoryName;
}

    /**
     * The quantity of this product that has been sold. This field is used to
     * compute best-selling products and to derive revenue figures. It is not
     * persisted by the original schema; you will need to add a
     * {@code sold_quantity} column to your Products table to enable this
     * functionality.
     */
    private int soldQuantity;

    /**
     * Manufacturer or brand of the product. Adding this field allows the
     * advanced search form to filter by manufacturer. You should add a
     * corresponding {@code manufacturer} column to your database for this
     * attribute to be stored.
     */
    private String manufacturer;

    /**
     * The number of units currently in stock. This field enables filtering
     * products by availability (in stock or out of stock). A new
     * {@code quantity} column should be added to your database for this to
     * work.
     */
    private int quantity;

    public Product() {
    }

    public Product(int id, int categoryId, String name, String description, double price, String imagePath) {
        this.id = id;
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.imagePath = imagePath;
        this.soldQuantity = 0;
        this.manufacturer = null;
        this.quantity = 0;
    }

    public Product(int categoryId, String name, String description, double price, String imagePath) {
        this(0, categoryId, name, description, price, imagePath);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public int getSoldQuantity() {
        return soldQuantity;
    }

    public void setSoldQuantity(int soldQuantity) {
        this.soldQuantity = soldQuantity;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}