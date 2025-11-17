-- Пользователи и их адреса
SELECT u.first_name, u.last_name, u.email, a.city, a.street, a.building_number
FROM users u
INNER JOIN addresses a ON u.user_id = a.user_id;

-- Заказы с информацией о пользователе и ресторане
SELECT o.order_id, u.first_name, u.last_name, r.name AS restaurant_name, o.total_amount, o.status, o.created_at
FROM orders o
INNER JOIN users u ON o.user_id = u.user_id
INNER JOIN restaurants r ON o.restaurant_id = r.restaurant_id
ORDER BY o.created_at DESC;

-- Детали заказа по конкретному номеру с информацией о блюдах и ресторане
SELECT o.order_id, d.name AS dish_name, oi.quantity, oi.price, r.name AS restaurant_name
FROM order_items oi
INNER JOIN dishes d ON oi.dish_id = d.dish_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN restaurants r ON d.restaurant_id = r.restaurant_id
WHERE o.order_id = 1;

-- Текущие заказы с информацией о курьере и пользователе
SELECT o.order_id, u.first_name AS customer_name, c.first_name AS courier_name, c.phone_number AS courier_phone, o.status
FROM orders o
INNER JOIN users u ON o.user_id = u.user_id
LEFT JOIN couriers c ON o.courier_id = c.courier_id
WHERE o.status IN ('delivering', 'preparing');

-- Доступные блюда с информацией о ресторане, цене и категории
SELECT r.name AS restaurant_name, d.name AS dish_name, d.price, d.category, d.is_available
FROM dishes d
INNER JOIN restaurants r ON d.restaurant_id = r.restaurant_id
WHERE d.is_available = TRUE
ORDER BY r.name, d.category;

-- Пользователь по id с его заказами и адресом доставки
SELECT u.first_name, u.last_name, o.order_id, o.total_amount, a.city, a.street, a.building_number, a.apartment_number, a.floor, a.entrance
FROM users u
INNER JOIN orders o ON u.user_id = o.user_id
INNER JOIN addresses a ON o.delivery_address_id = a.address_id
WHERE u.user_id = 1;

-- Курьер по id с его доставленными заказами и информацией о ресторане
SELECT c.first_name, c.last_name, c.vehicle_type, o.order_id, o.total_amount, r.name AS restaurant_name
FROM couriers c
INNER JOIN orders o ON c.courier_id = o.courier_id
INNER JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE c.courier_id = 1 AND o.status = 'delivered';
