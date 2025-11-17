-- Сумма выручки с доставленных заказов по каждому рестику в убывании
SELECT restaurant_id, SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'delivered'
GROUP BY restaurant_id
ORDER BY total_revenue DESC;

-- Количество заказов по каждому ресторану в убывании (включая рестораны без заказов)
SELECT r.name, COUNT(o.order_id) AS order_count
FROM restaurants r
LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.name
ORDER BY order_count DESC;

-- Пользователи, сделавшие не менее двух заказов, с общей суммой потраченных средств, в убывании по сумме
SELECT u.user_id, u.first_name, u.last_name, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS total_spent
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.first_name, u.last_name
HAVING COUNT(o.order_id) >= 2
ORDER BY total_spent DESC;

-- Курьеры с количеством доставленных заказов (даже если заказов нет) и средней стоимостью заказа, в убывании по количеству доставок
SELECT c.courier_id, c.first_name, c.last_name, COUNT(o.order_id) AS deliveries, AVG(o.total_amount) AS avg_order_value
FROM couriers c
LEFT JOIN orders o ON c.courier_id = o.courier_id AND o.status = 'delivered'
GROUP BY c.courier_id, c.first_name, c.last_name
ORDER BY deliveries DESC;

-- Статистика по категориям блюд: количество блюд, средняя, минимальная и максимальная цена, для доступных блюд, в убывании по средней цене
SELECT d.category, COUNT(d.dish_id) AS dish_count, AVG(d.price) AS avg_price, MIN(d.price) AS min_price, MAX(d.price) AS max_price
FROM dishes d
WHERE d.is_available = TRUE
GROUP BY d.category
ORDER BY avg_price DESC;

-- Выручка по категориям блюд для каждого ресторана, где выручка превышает 500, в убывании по ресторану и выручке
SELECT r.name, d.category, SUM(oi.quantity * oi.price) AS category_revenue
FROM order_items oi
JOIN dishes d ON oi.dish_id = d.dish_id
JOIN orders o ON oi.order_id = o.order_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'delivered'
GROUP BY r.restaurant_id, r.name, d.category
HAVING SUM(oi.quantity * oi.price) > 500
ORDER BY r.name, category_revenue DESC;

-- Топ-10 самых продаваемых блюд с указанием ресторана, в убывании по количеству проданных единиц
SELECT d.dish_id, d.name, r.name AS restaurant_name, SUM(oi.quantity) AS total_sold
FROM dishes d
JOIN order_items oi ON d.dish_id = oi.dish_id
JOIN orders o ON oi.order_id = o.order_id
JOIN restaurants r ON d.restaurant_id = r.restaurant_id
WHERE o.status = 'delivered'
GROUP BY d.dish_id, d.name, r.name
ORDER BY total_sold DESC
LIMIT 10;

-- Пользователи с средней стоимостью доставленных заказов выше 500, в убывании по средней стоимости
SELECT u.user_id, u.first_name, u.last_name, AVG(o.total_amount) AS avg_order_value
FROM users u
JOIN orders o ON u.user_id = o.user_id
WHERE o.status = 'delivered'
GROUP BY u.user_id, u.first_name, u.last_name
HAVING AVG(o.total_amount) > 500
ORDER BY avg_order_value DESC;

-- Ежедневная выручка с доставленных заказов, в убывании по дате
SELECT DATE(o.created_at) AS order_date, COUNT(o.order_id) AS orders_count, SUM(o.total_amount) AS daily_revenue
FROM orders o
WHERE o.status = 'delivered'
GROUP BY DATE(o.created_at)
ORDER BY order_date DESC;

-- Среднее количество и средняя стоимость доставленных заказов по типам кухни, для типов с не менее чем двумя заказами, в убывании по количеству заказов
SELECT r.type_of_cuisine, COUNT(o.order_id) AS order_count, AVG(o.total_amount) AS avg_order_value
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
WHERE o.status = 'delivered'
GROUP BY r.type_of_cuisine
HAVING COUNT(o.order_id) >= 2
ORDER BY order_count DESC;
