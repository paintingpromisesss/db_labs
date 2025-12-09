-- Dirty Read (невозможен в postgresql)
-- Console 1
BEGIN;
UPDATE dishes SET price = 99999 WHERE dish_id = 1;
--
-- Console 2
BEGIN ISOLATION LEVEL READ UNCOMMITTED;
SELECT price FROM dishes WHERE dish_id = 1;
--
-- Console 1
ROLLBACK;
--





-- Non-Repeatable Read
-- Демонстрация проблемы
-- Console 1
BEGIN;
SELECT price FROM dishes WHERE dish_id = 1;
--
-- Console 2
BEGIN;
UPDATE dishes SET price = 777 WHERE dish_id = 1;
COMMIT;
--
-- Console 1
SELECT price FROM dishes WHERE dish_id = 1;
COMMIT;
--



-- Лечение
-- Используем уровень изоляции
-- Console 1
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT price FROM dishes WHERE dish_id = 1;
--
-- Console 2
BEGIN;
UPDATE dishes SET price = 888 WHERE dish_id = 1;
COMMIT;
--
-- Console 1
SELECT price FROM dishes WHERE dish_id = 1;
COMMIT;
--





-- Phantom Read
-- Демонстрация проблемы
-- Console 1
BEGIN;
SELECT count(*) FROM dishes WHERE price > 5000;
--
-- Console 2
BEGIN;
INSERT INTO dishes (restaurant_id, name, price, category, is_available)
VALUES (1, 'Фантом', 9999, 'Еда', true);
COMMIT;
--
-- Console 1
SELECT count(*) FROM dishes WHERE price > 5000;
COMMIT;
--



-- Лечение
-- Используем уровен изоляции
-- Console 1
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT count(*) FROM dishes WHERE price > 5000;
--
-- Console 2
BEGIN;
INSERT INTO dishes (restaurant_id, name, price, category, is_available)
VALUES (1, 'Фантом2', 9999, 'Еда', true);
COMMIT;
--
-- Console 1
SELECT count(*) FROM dishes WHERE price > 5000;
COMMIT;
--