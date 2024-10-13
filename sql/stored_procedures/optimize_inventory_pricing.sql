-- Stored procedure for identifying low stock items
CREATE PROCEDURE inventory.IdentifyLowStockItems
AS
BEGIN
    SELECT 
        p.product_id,
        p.product_name,
        s.quantity_on_hand,
        s.reorder_point,
        sup.supplier_name,
        ps.lead_time
    FROM inventory.stock_levels s
    JOIN inventory.products p ON s.product_id = p.product_id
    JOIN inventory.product_suppliers ps ON p.product_id = ps.product_id
    JOIN inventory.suppliers sup ON ps.supplier_id = sup.supplier_id
    WHERE s.quantity_on_hand <= s.reorder_point
    ORDER BY (s.quantity_on_hand - s.reorder_point) ASC;
END
GO