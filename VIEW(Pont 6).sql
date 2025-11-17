-- View с топом ресторанов по выручке и статистикой по заказам,
CREATE VIEW top_restaurants AS
SELECT 
    r.restaurant_id,
    r.name,
    r.type_of_cuisine,
    r.rating,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS avg_order_value,
    MAX(o.created_at) AS last_order_date
FROM restaurants r
INNER JOIN orders o ON r.restaurant_id = o.restaurant_id AND o.status = 'delivered'
GROUP BY r.restaurant_id, r.name, r.type_of_cuisine, r.rating
ORDER BY total_revenue DESC;

-- View со статистикой по клиентам,
CREATE VIEW customer_statistics AS
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value,
    MAX(o.created_at) AS last_order_date,
    MIN(o.created_at) AS first_order_date
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id AND o.status = 'delivered'
GROUP BY u.user_id, u.first_name, u.last_name, u.email, u.phone_number
ORDER BY total_spent DESC;

-- View с популярными блюдами и их статистикой по заказам.
CREATE VIEW popular_dishes AS
SELECT 
    d.dish_id,
    d.name,
    d.category,
    d.price,
    r.name AS restaurant_name,
    COUNT(oi.order_item_id) AS times_ordered,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.price) AS total_revenue
FROM dishes d
JOIN restaurants r ON d.restaurant_id = r.restaurant_id
JOIN order_items oi ON d.dish_id = oi.dish_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status = 'delivered'
GROUP BY d.dish_id, d.name, d.category, d.price, r.name
ORDER BY total_quantity_sold DESC;
