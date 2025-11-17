INSERT INTO users (email, phone_number, first_name, last_name, date_of_birth)
VALUES ('new.user@gmail.com', '+79991112233', 'Алексей', 'Новиков', '1996-07-20');

INSERT INTO restaurants (name, description, address, phone_number, email, type_of_cuisine, opening_time, closing_time, rating)
VALUES ('Суши Wok', 'Азиатская кухня с доставкой', 'Москва, ул. Пушкина, 45', '+74959998877', 'contact@sushiwok.ru', 'Азиатская', '10:00:00', '23:00:00', 4.4);

INSERT INTO dishes (restaurant_id, name, description, price, is_available, category)
VALUES (1, 'Пицца Гавайская', 'Пицца с ананасами и курицей', 500.00, TRUE, 'Пицца');

INSERT INTO orders (user_id, restaurant_id, delivery_address_id, courier_id, total_amount, status)
VALUES (1, 2, 1, 3, 1250.00, 'accepted');

INSERT INTO order_items (order_id, dish_id, quantity, price)
VALUES 
    (currval('orders_order_id_seq'), 5, 2, 380.00), 
    (currval('orders_order_id_seq'), 7, 1, 150.00);




UPDATE orders
SET status = 'delivered', updated_at = NOW()
WHERE order_id = 4;

UPDATE orders
SET courier_id = 5
WHERE order_id = 10 AND status = 'accepted';

UPDATE dishes
SET price = 480.00, updated_at = NOW()
WHERE dish_id = 1;

UPDATE dishes
SET is_available = FALSE
WHERE dish_id = 19;

UPDATE restaurants
SET rating = 4.8
WHERE restaurant_id = 2;

UPDATE couriers
SET is_available = FALSE
WHERE courier_id = 1;

UPDATE users
SET email = 'ivan.new@mail.ru', updated_at = NOW()
WHERE user_id = 1;




DELETE FROM otp
WHERE expires_at < NOW();

DELETE FROM otp
WHERE phone_number = '+79163456789' AND is_verified = TRUE;

DELETE FROM orders
WHERE order_id = 11;

DELETE FROM dishes
WHERE dish_id = 26 AND is_available = FALSE;

DELETE FROM users
WHERE user_id = 11;

DELETE FROM addresses
WHERE user_id = 3 AND address_id = 12;