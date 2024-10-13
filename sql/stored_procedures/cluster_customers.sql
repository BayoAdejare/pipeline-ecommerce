
-- Stored procedure for customer segmentation
CREATE PROCEDURE shopify.SegmentCustomers
AS
BEGIN
    -- Clear existing segment assignments
    TRUNCATE TABLE shopify.customer_segment_assignments;

    -- Assign high-value customers
    INSERT INTO shopify.customer_segment_assignments (customer_id, segment_id, assigned_date)
    SELECT c.customer_id, 1, GETDATE()
    FROM shopify.customers c
    INNER JOIN (
        SELECT customer_id, SUM(total_amount) as total_spent
        FROM shopify.orders
        WHERE order_date >= DATEADD(YEAR, -1, GETDATE())
        GROUP BY customer_id
        HAVING SUM(total_amount) > 1000
    ) high_value ON c.customer_id = high_value.customer_id;

    -- Assign inactive customers
    INSERT INTO shopify.customer_segment_assignments (customer_id, segment_id, assigned_date)
    SELECT c.customer_id, 2, GETDATE()
    FROM shopify.customers c
    LEFT JOIN shopify.orders o ON c.customer_id = o.customer_id
    WHERE o.order_id IS NULL OR MAX(o.order_date) < DATEADD(YEAR, -1, GETDATE());

    -- CALL notebook & add more segmentation logic as needed
END;
GO