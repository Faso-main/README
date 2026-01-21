# PostgreSQL на Ubuntu

## Установка PostgreSQL

### 1. Обновление пакетов и установка PostgreSQL
```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y postgresql postgresql-contrib postgresql-client
```

### 2. Проверка статуса службы
```bash
sudo systemctl status postgresql
sudo systemctl enable postgresql
```

## Базовая настройка PostgreSQL

### 3. Настройка параметров аутентификации (замени 16 на свою версию PG)
```bash
sudo nano /etc/postgresql/16/main/postgresql.conf
```

Найдите и измените следующие параметры:
```ini
# Слушать все интерфейсы (для внешних подключений)
listen_addresses = '*'

# Порт по умолчанию
port = 5432

# Метод шифрования паролей
password_encryption = scram-sha-256

# Логирование
log_statement = 'all'
log_directory = '/var/log/postgresql'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
```

### 4. Настройка доступа (pg_hba.conf) (замени 16 на свою версию PG)
```bash
sudo nano /etc/postgresql/16/main/pg_hba.conf
```

Добавьте в конец файла:
```ini
# Локальные подключения
local   all             all                                     scram-sha-256

# IPv4 локальные подключения
host    all             all             127.0.0.1/32            scram-sha-256

# IPv4 внешние подключения (настройте под вашу сеть)
host    all             all             0.0.0.0/0               scram-sha-256

# IPv6 подключения
host    all             all             ::1/128                 scram-sha-256
```

### 5. Перезапуск PostgreSQL
```bash
sudo systemctl restart postgresql
sudo systemctl status postgresql
```

## Создание пользователей и баз данных

### 6. Подключение к PostgreSQL как superuser
```bash
sudo -u postgres psql
```

### 7. Создание нового пользователя с паролем
```sql
-- Создание пользователя с паролем
CREATE USER faso_user WITH 
    LOGIN 
    PASSWORD 'secure_password_123'
    CREATEDB
    CREATEROLE;

-- Проверка создания пользователя
\du
```

### 8. Создание базы данных
```sql
-- Создание базы данных с владельцем
CREATE DATABASE faso_db 
    OWNER = faso_user
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE = template0;

-- Подключение к новой базе данных
\c faso_db faso_user

-- Проверка списка баз данных
\l
```

## Настройка прав доступа

### 9. Выдача привилегий пользователю
```sql
-- Подключение к системной базе данных
\c postgres

-- Выдача прав на создание баз данных
ALTER USER faso_user CREATEDB;

-- Выдача прав на подключение к базе данных
GRANT CONNECT ON DATABASE faso_db TO faso_user;

-- Выдача всех прав на базу данных
GRANT ALL PRIVILEGES ON DATABASE faso_db TO faso_user;

-- Выдача прав на создание схем
GRANT CREATE ON SCHEMA public TO faso_user;

-- Включение расширений для пользователя
ALTER USER faso_user WITH SUPERUSER;
```

### 10. Выход из psql
```sql
\q
```

## Создание таблиц и работа с данными

### 11. Подключение под новым пользователем
```bash
psql -h localhost -U faso_user -d faso_db -W
```

### 12. Создание таблиц
```sql
-- Включение расширения для UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Создание последовательности для ID
CREATE SEQUENCE IF NOT EXISTS users_id_seq START 1;
CREATE SEQUENCE IF NOT EXISTS products_id_seq START 1;

-- Таблица пользователей
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY DEFAULT nextval('users_id_seq'),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- Таблица продуктов
CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY DEFAULT nextval('products_id_seq'),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50),
    in_stock INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER REFERENCES users(id)
);

-- Таблица заказов
CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id INTEGER REFERENCES users(id),
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Таблица элементов заказа
CREATE TABLE IF NOT EXISTS order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL
);
```

### 13. Создание индексов для оптимизации
```sql
-- Индексы для пользователей
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- Индексы для продуктов
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_price ON products(price);
CREATE INDEX IF NOT EXISTS idx_products_created_at ON products(created_at);

-- Индексы для заказов
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);

-- Индексы для элементов заказа
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);
```

### 14. Создание триггеров для обновления временных меток
```sql
-- Функция для автоматического обновления updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Триггеры для таблиц
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at 
    BEFORE UPDATE ON products 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at 
    BEFORE UPDATE ON orders 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

## Вставка тестовых данных

### 15. Добавление демо-данных
```sql
-- Вставка пользователей
INSERT INTO users (username, email, password_hash, first_name, last_name) VALUES
('john_doe', 'john@example.com', 'hashed_password_1', 'John', 'Doe'),
('jane_smith', 'jane@example.com', 'hashed_password_2', 'Jane', 'Smith'),
('bob_wilson', 'bob@example.com', 'hashed_password_3', 'Bob', 'Wilson');

-- Вставка продуктов
INSERT INTO products (name, description, price, category, in_stock, created_by) VALUES
('Laptop', 'High-performance laptop', 999.99, 'Electronics', 10, 1),
('Smartphone', 'Latest smartphone model', 699.99, 'Electronics', 25, 1),
('Book', 'Programming guide', 29.99, 'Books', 100, 2),
('Headphones', 'Wireless headphones', 149.99, 'Electronics', 15, 3);

-- Вставка заказов
INSERT INTO orders (user_id, total_amount, status) VALUES
(1, 1049.98, 'completed'),
(2, 29.99, 'pending'),
(3, 849.98, 'processing');

-- Вставка элементов заказа
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES
((SELECT id FROM orders WHERE user_id = 1 LIMIT 1), 1, 1, 999.99, 999.99),
((SELECT id FROM orders WHERE user_id = 1 LIMIT 1), 4, 1, 149.99, 149.99),
((SELECT id FROM orders WHERE user_id = 2 LIMIT 1), 3, 1, 29.99, 29.99),
((SELECT id FROM orders WHERE user_id = 3 LIMIT 1), 2, 1, 699.99, 699.99),
((SELECT id FROM orders WHERE user_id = 3 LIMIT 1), 4, 1, 149.99, 149.99);
```

## Полезные команды для работы с PostgreSQL

### 16. Основные команды psql
```sql
-- Показать все базы данных
\l

-- Подключиться к базе данных
\c database_name

-- Показать все таблицы
\dt

-- Показать структуру таблицы
\d table_name

-- Показать индексы
\di

-- Показать пользователей и их права
\du

-- Выйти из psql
\q
```

### 17. Примеры запросов
```sql
-- Выборка данных с JOIN
SELECT 
    o.id as order_id,
    u.username,
    u.email,
    o.total_amount,
    o.status,
    o.created_at
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.status = 'completed'
ORDER BY o.created_at DESC;

-- Агрегатные функции
SELECT 
    u.username,
    COUNT(o.id) as total_orders,
    SUM(o.total_amount) as total_spent,
    AVG(o.total_amount) as avg_order_value
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.username
HAVING COUNT(o.id) > 0;

-- Обновление данных
UPDATE products 
SET price = price * 0.9 
WHERE category = 'Electronics' 
AND created_at < NOW() - INTERVAL '30 days';

-- Удаление данных с условием
DELETE FROM orders 
WHERE status = 'cancelled' 
AND created_at < NOW() - INTERVAL '90 days';
```

## Резервное копирование и восстановление

### 18. Создание резервной копии
```bash
# Резервное копирование всей базы данных
sudo -u postgres pg_dumpall > /var/backups/postgresql/full_backup_$(date +%Y%m%d).sql

# Резервное копирование конкретной базы данных
sudo -u postgres pg_dump faso_db > /var/backups/postgresql/faso_db_$(date +%Y%m%d).sql

# Сжатая резервная копия
sudo -u postgres pg_dump faso_db | gzip > /var/backups/postgresql/faso_db_$(date +%Y%m%d).sql.gz

# Контейнер
docker exec -it CONTAINER_ID psql -U postgres pg_dump DB_NAME | gzip > /var/backups/DB_NAME__$(date +%Y%m%d).sql.gz
```

### 19. Восстановление из резервной копии
```bash
# Восстановление всей базы данных
sudo -u postgres psql -f /var/backups/postgresql/full_backup_20231001.sql

# Восстановление конкретной базы данных
sudo -u postgres psql -d faso_db -f /var/backups/postgresql/faso_db_20231001.sql

# Восстановление из сжатого файла
gunzip -c /var/backups/postgresql/faso_db_20231001.sql.gz | sudo -u postgres psql -d faso_db
```

## Мониторинг и обслуживание

### 20. Команды для мониторинга
```bash
# Проверка подключений
sudo -u postgres psql -c "SELECT datname, numbackends, xact_commit, xact_rollback FROM pg_stat_database;"

# Размеры баз данных
sudo -u postgres psql -c "SELECT datname, pg_size_pretty(pg_database_size(datname)) as size FROM pg_database;"

# Активные запросы
sudo -u postgres psql -c "SELECT pid, usename, query, state, query_start FROM pg_stat_activity WHERE state = 'active';"
```

### 21. Обслуживание базы данных
```sql
-- Очистка и оптимизация базы данных
VACUUM FULL ANALYZE;

-- Переиндексация таблиц
REINDEX DATABASE faso_db;

-- Статистика использования таблиц
ANALYZE;
```
