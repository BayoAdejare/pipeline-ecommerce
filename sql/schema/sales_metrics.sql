-- sales_metrics - SQL Schema for Sales Metrics

-- Create schema if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'sales')
BEGIN
    EXEC('CREATE SCHEMA sales')
END
GO

-- Dimensions

-- Time dimension
CREATE TABLE sales.dim_time (
    time_id INT IDENTITY(1,1) PRIMARY KEY,
    date DATE NOT NULL,
    day_of_week TINYINT NOT NULL,
    day_name NVARCHAR(10) NOT NULL,
    week_of_year TINYINT NOT NULL,
    month TINYINT NOT NULL,
    month_name NVARCHAR(10) NOT NULL,
    quarter TINYINT NOT NULL,
    year INT NOT NULL
)

-- Product dimension (if not already created in previous schemas)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dim_product' AND schema_id = SCHEMA_ID('sales'))
BEGIN
    CREATE TABLE sales.dim_product (
        product_id INT PRIMARY KEY,
        product_name NVARCHAR(255) NOT NULL,
        category NVARCHAR(100),
        subcategory NVARCHAR(100),
        brand NVARCHAR(100),
        unit_cost DECIMAL(10, 2) NOT NULL,
        unit_price DECIMAL(10, 2) NOT NULL
    )
END

-- Customer dimension (if not already created in previous schemas)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dim_customer' AND schema_id = SCHEMA_ID('sales'))
BEGIN
    CREATE TABLE sales.dim_customer (
        customer_id INT PRIMARY KEY,
        first_name NVARCHAR(100),
        last_name NVARCHAR(100),
        email NVARCHAR(255) NOT NULL,
        city NVARCHAR(100),
        state NVARCHAR(100),
        country NVARCHAR(100),
        customer_segment NVARCHAR(50)
    )
END

-- Sales channel dimension
CREATE TABLE sales.dim_channel (
    channel_id INT IDENTITY(1,1) PRIMARY KEY,
    channel_name NVARCHAR(50) NOT NULL,
    channel_type NVARCHAR(50) NOT NULL
)

-- Fact tables

-- Sales fact table
CREATE TABLE sales.fact_sales (
    sale_id INT IDENTITY(1,1) PRIMARY KEY,
    time_id INT NOT NULL,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    channel_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) NOT NULL,
    sale_amount DECIMAL(10, 2) NOT NULL,
    cost_amount DECIMAL(10, 2) NOT NULL,
    gross_profit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (time_id) REFERENCES sales.dim_time(time_id),
    FOREIGN KEY (product_id) REFERENCES sales.dim_product(product_id),
    FOREIGN KEY (customer_id) REFERENCES sales.dim_customer(customer_id),
    FOREIGN KEY (channel_id) REFERENCES sales.dim_channel(channel_id)
)

-- Daily sales summary fact table
CREATE TABLE sales.fact_daily_sales_summary (
    summary_id INT IDENTITY(1,1) PRIMARY KEY,
    time_id INT NOT NULL,
    product_id INT NOT NULL,
    channel_id INT NOT NULL,
    total_quantity INT NOT NULL,
    total_sale_amount DECIMAL(10, 2) NOT NULL,
    total_cost_amount DECIMAL(10, 2) NOT NULL,
    total_gross_profit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (time_id) REFERENCES sales.dim_time(time_id),
    FOREIGN KEY (product_id) REFERENCES sales.dim_product(product_id),
    FOREIGN KEY (channel_id) REFERENCES sales.dim_channel(channel_id)
)

-- Indexes for performance optimization
CREATE INDEX idx_fact_sales_time_id ON sales.fact_sales(time_id)
CREATE INDEX idx_fact_sales_product_id ON sales.fact_sales(product_id)
CREATE INDEX idx_fact_sales_customer_id ON sales.fact_sales(customer_id)
CREATE INDEX idx_fact_sales_channel_id ON sales.fact_sales(channel_id)
CREATE INDEX idx_fact_daily_sales_summary_time_id ON sales.fact_daily_sales_summary(time_id)
CREATE INDEX idx_fact_daily_sales_summary_product_id ON sales.fact_daily_sales_summary(product_id)
CREATE INDEX idx_fact_daily_sales_summary_channel_id ON sales.fact_daily_sales_summary(channel_id)
