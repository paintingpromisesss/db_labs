EXPLAIN ANALYZE
SELECT o.order_id,
       o.created_at,
       u.last_name as user_name,
       r.name      as restaurant_name,
       c.last_name as courier_name,
       o.total_amount as total_order_price
FROM orders o
         JOIN users u ON o.user_id = u.user_id
         JOIN restaurants r ON o.restaurant_id = r.restaurant_id
         LEFT JOIN couriers c ON o.courier_id = c.courier_id
WHERE u.last_name = 'Волков';

CREATE INDEX idx_users_last_name ON users(last_name);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_restaurant_id ON orders(restaurant_id);

DROP INDEX IF EXISTS idx_users_last_name;
DROP INDEX IF EXISTS idx_orders_user_id;
DROP INDEX IF EXISTS idx_orders_restaurant_id;


EXPLAIN ANALYZE
SELECT r.name,
       SUM(o.total_amount) AS revenue
FROM orders o
         JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.created_at >= '2025-11-25'
GROUP BY r.name
ORDER BY revenue DESC
LIMIT 5;

CREATE INDEX idx_orders_created_at_amount ON orders(created_at, total_amount);
DROP INDEX IF EXISTS idx_orders_created_at_amount;


EXPLAIN ANALYZE
SELECT * FROM orders 
WHERE status = 'delivered' 
ORDER BY created_at DESC 
LIMIT 10;

CREATE INDEX idx_orders_status_date ON orders(status, created_at DESC);
DROP INDEX IF EXISTS idx_orders_status_date;