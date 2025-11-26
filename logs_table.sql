CREATE TABLE order_status_logs (
    log_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL FOREIGN KEY REFERENCES orders(order_id) ON DELETE CASCADE,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
