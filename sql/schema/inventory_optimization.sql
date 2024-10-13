-- inventory_optimization - SQL Schema for Inventory Optimization (Azure SQL Database)

-- Create schema if it doesn't exist
IF NOT EXISTS(SELECT * FROM sys.schemas WHERE name = 'inventory')
BEGIN
    EXEC('CREATE SCHEMA inventory')
END

-- Products table (if not already created in the previous schema)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'products' AND schema_id = SCHEMA_ID('inventory'))
BEGIN
    CREATE TABLE inventory.products (
        product_id INT PRIMARY KEY,
        product_name NVARCHAR(255) NOT NULL, 
        category NVARCHAR(100),
        unit_cost DECIMAL(10, 2) NOT NULL, 
        unit_price DECIMAL(10, 2) NOT NULL
    )
END

-- Inventory table
CREATE TABLE inventory.stock_levels (
    stock_id INT IDENTITY(1, 1) PRIMARY KEY,
    product_id INT NOT NULL, 
    quantity_on_hand INT NOT NULL, 
    reorder_point INT NOT NULL, 
    reorder_quantity INT NOT NULL, 
    last_restock_date DATE,
    FOREIGN_KEY (product_id) REFERENCES inventory.products(product_id)
)

-- Suppliers table 
CREATE TABLE inventory.suppliers (
    supplier_id INT IDENTITY(1, 1) PRIMARY KEY, 
    supplier_name NVARCHAR(255) NOT NULL, 
    contact_person NVARCHAR(100),
    email NVARCHAR(255), 
    phone NVARCHAR(20),
    [address] NVARCHAR(MAX)
)

-- Product Suppliers table (for many-to-many relationships)
CREATE TABLE inventory.product_suppliers
(
    product_id INT NOT NULL, 
    supplier_id INT NOT NULL, 
    lead_time INT NOT NULL, --in days
    minimum_order_quantity INT NOT NULL, 
    PRIMARY KEY (product_id, supplier_id),
    FOREIGN KEY (product_id) REFERENCES inventory.products(product_id),
    FOREIGN KEY (supplier_id) REFERENCES inventory.suppliers(supplier_id)
)

-- Sales History table 
CREATE TABLE inventory.sales_history (
    sale_id INT IDENTITY(1, 1) PRIMARY KEY, 
    product_id INT NOT NULL, 
    sale_date DATE NOT NULL, 
    quantity_sold INT NOT NULL, 
    sale_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES inventory.products(product_id)
)

-- Purchase Orders table
CREATE TABLE inventory.purchase_orders (
    po_id INT IDENTITY(1, 1) PRIMARY KEY, 
    supplier_id INT NOT NULL, 
    order_date DATE NOT NULL, 
    expected_delivery_date DATE,
    [status] NVARCHAR(50) NOT NULL, 
    FOREIGN KEY (supplier_id) REFERENCES inventory.suppliers(supplier_id)
)

-- Purchase Order Items table 
CREATE TABLE inventory.po_items (
    po_item_id INT IDENTITY(1, 1) PRIMARY KEY, 
    po_id INT NOT NULL, 
    product_id INT NOT NULL, 
    quantity INT NOT NULL, 
    unit_cost DECIMAL(10, 2) NOT NULL, 
    FOREIGN KEY (po_id) REFERENCES inventory.purchase_orders(po_id),
    FOREIGN KEY (product_id) REFERENCES inventory.products(product_id)
)

-- Indexes for performance optimization 
CREATE INDEX idx_stock_levels_product_id ON inventory.stock_levels(product_id); 
CREATE INDEX idx_product_suppliers_supplier_id ON inventory.product_suppliers(supplier_id);
CREATE INDEX idx_sales_history_product_id ON inventory.sales_history(product_id);
CREATE INDEX idx_sales_history_sale_date ON inventory.sales_history(sale_date);
CREATE INDEX idx_purchase_orders_supplier_id ON inventory.purchase_orders(supplier_id);
CREATE INDEX idx_po_items_po_id ON inventory.po_items(po_id);
CREATE INDEX idx_po_items_product_id ON inventory.po_items(product_id);
