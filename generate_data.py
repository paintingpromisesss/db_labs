import random
from faker import Faker
import datetime

fake = Faker('ru_RU')

# КОНФИГ
NUM_USERS = 10000
NUM_RESTAURANTS = 10000
NUM_COURIERS = 500
NUM_DISHES_PER_RESTAURANT = 5
NUM_ORDERS = 100000

output_file = 'fill_db_massive.sql'


def escape_sql(text):
    return text.replace("'", "''")


print(f"Генерация {NUM_RESTAURANTS} ресторанов и данных в {output_file}...")

with open(output_file, 'w', encoding='utf-8') as f:
    f.write("TRUNCATE TABLE users, restaurants, couriers, dishes, orders, addresses CASCADE;\n")
    # Сброс счетчиков
    f.write("ALTER SEQUENCE users_user_id_seq RESTART WITH 1;\n")
    f.write("ALTER SEQUENCE restaurants_restaurant_id_seq RESTART WITH 1;\n")
    f.write("ALTER SEQUENCE couriers_courier_id_seq RESTART WITH 1;\n")
    f.write("ALTER SEQUENCE dishes_dish_id_seq RESTART WITH 1;\n")
    f.write("ALTER SEQUENCE orders_order_id_seq RESTART WITH 1;\n")
    f.write("ALTER SEQUENCE addresses_address_id_seq RESTART WITH 1;\n\n")

    # 1. USERS
    print("Юзеры...")
    f.write("-- USERS\n")
    for i in range(1, NUM_USERS + 1):
        gender = random.choice(['M', 'F'])
        fn = fake.first_name_male() if gender == 'M' else fake.first_name_female()
        ln = fake.last_name_male() if gender == 'M' else fake.last_name_female()
        email = f"user{i}_{fake.unique.random_number()}@example.com"
        phone = '+7' + fake.unique.msisdn()[3:]
        dob = fake.date_of_birth(minimum_age=18, maximum_age=70)
        f.write(
            f"INSERT INTO users (first_name, last_name, email, phone_number, date_of_birth) VALUES ('{fn}', '{ln}', '{email}', '{phone}', '{dob}');\n")

    # 2. ADDRESSES
    print("Адреса...")
    f.write("\n-- ADDRESSES\n")
    for user_id in range(1, NUM_USERS + 1):
        city = escape_sql(fake.city_name())
        street = escape_sql(fake.street_name())
        building = random.randint(1, 200)
        f.write(
            f"INSERT INTO addresses (user_id, city, street, building_number) VALUES ({user_id}, '{city}', '{street}', {building});\n")

    # 3. RESTAURANTS (10K штук!)
    print("Рестораны...")
    f.write("\n-- RESTAURANTS\n")

    # Списки для генерации названий без "Ресторан" в начале
    prefixes = ['Золотой', 'Вкусный', 'Старый', 'Новый',
                'Веселый', 'Грустный', 'Быстрый', 'Мамин', 'Папин', 'Дядя']
    roots = ['Дракон', 'Кабан', 'Повар', 'Бургер', 'Суши',
             'Пицца', 'Мангал', 'Терем', 'Двор', 'Сад', 'Лес']
    suffixes = ['Bar', 'Grill', 'House', 'Place',
                'Point', 'Food', 'Kitchen', 'Hall']

    for i in range(1, NUM_RESTAURANTS + 1):
        # Генерим название: Либо "Prefix Root", либо "Root Suffix", либо Faker Company
        strategy = random.randint(1, 3)
        if strategy == 1:
            name = f"{random.choice(prefixes)} {random.choice(roots)}"
        elif strategy == 2:
            name = f"{random.choice(roots)} {random.choice(suffixes)}"
        else:
            name = fake.company()  # Оставим немного рандома от фейкера

        name = escape_sql(name)
        cuisine = random.choice(
            ['Итальянская', 'Японская', 'Русская', 'Грузинская', 'Бургеры'])
        address = escape_sql(fake.address())
        phone = '+7' + fake.unique.msisdn()[3:]
        rating = round(random.uniform(3.0, 5.0), 1)
        f.write(
            f"INSERT INTO restaurants (name, type_of_cuisine, address, phone_number, rating) VALUES ('{name}', '{cuisine}', '{address}', '{phone}', {rating});\n")

    # 4. DISHES
    print("Блюда...")
    f.write("\n-- DISHES\n")
    for i in range(1, NUM_RESTAURANTS + 1):
        # Генерим меньше инсертов, чтобы файл не распух (по 1 строке с VALUES (...), (...))
        # Но для простоты оставим поштучно
        for _ in range(NUM_DISHES_PER_RESTAURANT):
            dname = f"Блюдо {fake.word()}"
            price = random.randint(200, 1000)
            f.write(
                f"INSERT INTO dishes (restaurant_id, name, price, category) VALUES ({i}, '{dname}', {price}, 'Еда');\n")

    # 5. COURIERS
    print("Курьеры...")
    f.write("\n-- COURIERS\n")
    for i in range(1, NUM_COURIERS + 1):
        fn = fake.first_name()
        ln = fake.last_name()
        phone = '+7' + fake.unique.msisdn()[3:]
        f.write(
            f"INSERT INTO couriers (first_name, last_name, phone_number) VALUES ('{fn}', '{ln}', '{phone}');\n")

    # 6. ORDERS
    print("Заказы...")
    f.write("\n-- ORDERS\n")
    for _ in range(NUM_ORDERS):
        uid = random.randint(1, NUM_USERS)
        rid = random.randint(1, NUM_RESTAURANTS)
        cid = random.randint(1, NUM_COURIERS)
        total = random.randint(500, 5000)
        status = random.choice(
            ['accepted', 'preparing', 'delivering', 'delivered'])
        # created_at упростим
        created_at = '2025-01-01 12:00:00'

        f.write(
            f"INSERT INTO orders (user_id, restaurant_id, courier_id, delivery_address_id, total_amount, status, created_at) VALUES ({uid}, {rid}, {cid}, (SELECT address_id FROM addresses WHERE user_id={uid} LIMIT 1), {total}, '{status}', '{created_at}');\n")


print("Готово!")
