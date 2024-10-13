-- customer_segments - SQL Schema for E-commerce Customer Segmentation

-- Create schema
CREATE SCHEMA shopify;
GO

-- Customers table
CREATE TABLE shopify.customers (
    customer_id INT PRIMARY KEY,
    email NVARCHAR(255) NOT NULL,
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL
);

-- Orders table
CREATE TABLE shopify.orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME2 NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status NVARCHAR(50) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES shopify.customers(customer_id)
);

-- Products table
CREATE TABLE shopify.products (
    product_id INT PRIMARY KEY,
    product_name NVARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category NVARCHAR(100)
);

-- Order Items table
CREATE TABLE shopify.order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES shopify.orders(order_id),
    FOREIGN KEY (product_id) REFERENCES shopify.products(product_id)
);

-- Customer Segments table
CREATE TABLE shopify.customer_segments (
    segment_id INT PRIMARY KEY,
    segment_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX)
);

-- Customer Segment Assignments table
CREATE TABLE shopify.customer_segment_assignments (
    assignment_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    segment_id INT NOT NULL,
    assigned_date DATETIME2 NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES shopify.customers(customer_id),
    FOREIGN KEY (segment_id) REFERENCES shopify.customer_segments(segment_id)
);

-- Indexes for performance optimization
CREATE INDEX idx_customers_email ON shopify.customers(email);
CREATE INDEX idx_orders_customer_id ON shopify.orders(customer_id);
CREATE INDEX idx_orders_order_date ON shopify.orders(order_date);
CREATE INDEX idx_order_items_order_id ON shopify.order_items(order_id);
CREATE INDEX idx_order_items_product_id ON shopify.order_items(product_id);
CREATE INDEX idx_customer_segment_assignments_customer_id ON shopify.customer_segment_assignments(customer_id);
CREATE INDEX idx_customer_segment_assignments_segment_id ON shopify.customer_segment_assignments(segment_id);
