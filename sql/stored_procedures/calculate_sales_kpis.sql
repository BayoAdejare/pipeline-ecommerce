-- Stored procedure for identifying top-selling products
CREATE PROCEDURE sales.GetTopSellingProducts
    @start_date DATE,
    @end_date DATE,
    @top_n INT = 10
AS
BEGIN
    SELECT TOP (@top_n)
        dp.product_id,
        dp.product_name,
        dp.category,
        SUM(fs.quantity) AS total_quantity_sold,
        SUM(fs.sale_amount) AS total_revenue,
        SUM(fs.gross_profit) AS total_gross_profit
    FROM 
        sales.fact_sales fs
        JOIN sales.dim_time dt ON fs.time_id = dt.time_id
        JOIN sales.dim_product dp ON fs.product_id = dp.product_id
    WHERE 
        dt.date BETWEEN @start_date AND @end_date
    GROUP BY 
        dp.product_id, dp.product_name, dp.category
    ORDER BY 
        total_revenue DESC;
END
GO