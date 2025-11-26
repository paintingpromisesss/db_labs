CREATE OR REPLACE FUNCTION update_timestamp_func()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_update_timestamp_dishes
BEFORE UPDATE ON dishes
FOR EACH ROW
EXECUTE FUNCTION update_timestamp_func();



CREATE OR REPLACE FUNCTION check_dish_availability_func()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_is_available BOOLEAN;
BEGIN
    SELECT is_available INTO v_is_available
    FROM dishes
    WHERE dish_id = NEW.dish_id;

    IF v_is_available IS FALSE THEN
        RAISE EXCEPTION 'Ошибка: Блюдо (ID %) временно недоступно для заказа', NEW.dish_id;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_dish_availability
BEFORE INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION check_dish_availability_func();



CREATE OR REPLACE FUNCTION log_order_status_change_func()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO order_status_logs (order_id, old_status, new_status)
        VALUES (NEW.order_id, OLD.status, NEW.status);
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_log_order_status
AFTER UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION log_order_status_change_func();
