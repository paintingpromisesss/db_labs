CALL register_user('test.user@mail.ru', '+79990000001', 'Тест', 'Тестов', '2000-01-01');

CALL register_user('test.user@mail.ru', '+79990000001', 'Тест', 'Тестов', '2000-01-01');

CALL register_user('test.user@mail.ru', NULL, 'Тест', 'Тестов', '2000-01-01');

CALL register_user('test.user@mail.ru', '+79990000001', NULL, 'Тестов', '2000-01-01');



SELECT 
    order_id, 
    total_amount as original_price, 
    calculate_final_order_price(order_id) as final_price
FROM orders 
WHERE order_id = 1;

SELECT calculate_final_order_price(94661236132);



SELECT updated_at FROM dishes WHERE dish_id = 2;

UPDATE dishes SET price = price + 10 WHERE dish_id = 2;

SELECT updated_at FROM dishes WHERE dish_id = 2;



UPDATE dishes SET is_available = FALSE WHERE dish_id = 1;

DO $$
BEGIN
    INSERT INTO order_items (order_id, dish_id, quantity, price)
    VALUES (1, 1, 1, 500.00);
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Сработал триггер проверки блюда: %', SQLERRM;
END;
$$;

UPDATE dishes SET is_available = TRUE WHERE dish_id = 1;




UPDATE orders SET status = 'delivering' WHERE order_id = 1;

SELECT * FROM order_status_logs WHERE order_id = 1;
