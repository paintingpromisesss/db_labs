CREATE OR REPLACE PROCEDURE register_user(
    p_email VARCHAR,
    p_phone VARCHAR,
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_birth_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO users (email, phone_number, first_name, last_name, date_of_birth)
    VALUES (p_email, p_phone, p_first_name, p_last_name, p_birth_date);
    
    RAISE NOTICE 'Пользователь % успешно зарегистрирован', p_email;

EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Ошибка: Пользователь с email % или телефоном % уже существует', p_email, p_phone;
    WHEN not_null_violation THEN
        RAISE NOTICE 'Ошибка: попытка вставить NULL в обязательное поле';
    WHEN OTHERS THEN
        RAISE NOTICE 'Неизвестная ошибка: %', SQLERRM;
END;
$$;


CREATE OR REPLACE FUNCTION calculate_final_order_price(p_order_id INTEGER)
RETURNS DECIMAL(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total DECIMAL(10, 2);
BEGIN
    SELECT total_amount INTO v_total
    FROM orders
    WHERE order_id = p_order_id;

    IF v_total IS NULL THEN
        RAISE EXCEPTION 'Заказ с ID % не найден', p_order_id;
    END IF;

    IF v_total > 2000 THEN
        v_total := v_total * 0.90;
    END IF;

    RETURN v_total;
END;
$$;
