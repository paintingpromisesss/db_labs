EXPLAIN ANALYZE
SELECT * FROM orders
WHERE created_at BETWEEN '2025-11-18' AND '2025-11-25';

CREATE INDEX idx_orders_created_at ON orders(created_at);
DROP INDEX IF EXISTS idx_orders_created_at;



EXPLAIN ANALYZE
SELECT * FROM dishes
WHERE category = 'Пицца';

CREATE INDEX idx_dishes_category ON dishes(category);
DROP INDEX IF EXISTS idx_dishes_category;



EXPLAIN ANALYZE
SELECT * FROM restaurants
WHERE name LIKE 'Пицца%';

CREATE INDEX idx_restaurants_name ON restaurants(name varchar_pattern_ops);
DROP INDEX IF EXISTS idx_restaurants_name;