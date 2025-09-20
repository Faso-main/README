# Руководство по работе с PostgreSQL в проекте TenderHack

## Содержание
1. [Установка и настройка PostgreSQL](#установка-и-настройка-postgresql)
2. [Создание базы данных и пользователя](#создание-базы-данных-и-пользователя)
3. [Создание таблиц](#создание-таблиц)
4. [Импорт данных](#импорт-данных)
5. [Настройка прав доступа](#настройка-прав-доступа)
6. [Проверка данных](#проверка-данных)
7. [Устранение常见 ошибок](#устранение-常见-ошибок)

## Установка и настройка PostgreSQL

### Установка PostgreSQL
```bash
# Обновление пакетов
sudo apt update

# Установка PostgreSQL
sudo apt install postgresql postgresql-contrib

# Запуск службы
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### Проверка установки
```bash
# Проверка статуса службы
sudo systemctl status postgresql

# Проверка версии PostgreSQL
sudo -u postgres psql -c "SELECT version();"
```

## Создание базы данных и пользователя

### Создание пользователя
```bash
# Создание пользователя
sudo -u postgres createuser kb_user

# Установка пароля пользователю
sudo -u postgres psql -c "ALTER USER kb_user WITH PASSWORD 'your_secure_password';"
```

### Создание базы данных
```bash
# Создание базы данных
sudo -u postgres createdb knowledge_base

# Предоставление прав пользователю на базу данных
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE knowledge_base TO kb_user;"
```

## Создание таблиц

### Таблица contracts (контракты)
```sql
CREATE TABLE contracts (
    id SERIAL PRIMARY KEY,
    contract_name TEXT NOT NULL,
    contract_id VARCHAR(100) NOT NULL UNIQUE,
    contract_amount DECIMAL(15, 5) NOT NULL,
    contract_date TIMESTAMP NOT NULL,
    category TEXT,
    customer_name TEXT NOT NULL,
    customer_inn VARCHAR(20) NOT NULL,
    supplier_name TEXT NOT NULL,
    supplier_inn VARCHAR(20) NOT NULL,
    law_basis VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Таблица quotation_sessions (котировочные сессии)
```sql
CREATE TABLE quotation_sessions (
    id SERIAL PRIMARY KEY,
    session_name TEXT NOT NULL,
    session_id VARCHAR(100) NOT NULL UNIQUE,
    session_amount DECIMAL(15, 5) NOT NULL,
    creation_date TIMESTAMP NOT NULL,
    completion_date TIMESTAMP NOT NULL,
    category TEXT,
    customer_name TEXT NOT NULL,
    customer_inn VARCHAR(20) NOT NULL,
    supplier_name TEXT NOT NULL,
    supplier_inn VARCHAR(20) NOT NULL,
    law_basis VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Создание индексов
```sql
-- Индексы для таблицы contracts
CREATE INDEX idx_contracts_contract_id ON contracts(contract_id);
CREATE INDEX idx_contracts_customer_inn ON contracts(customer_inn);
CREATE INDEX idx_contracts_supplier_inn ON contracts(supplier_inn);
CREATE INDEX idx_contracts_date ON contracts(contract_date);
CREATE INDEX idx_contracts_amount ON contracts(contract_amount);

-- Индексы для таблицы quotation_sessions
CREATE INDEX idx_sessions_session_id ON quotation_sessions(session_id);
CREATE INDEX idx_sessions_customer_inn ON quotation_sessions(customer_inn);
CREATE INDEX idx_sessions_supplier_inn ON quotation_sessions(supplier_inn);
CREATE INDEX idx_sessions_creation_date ON quotation_sessions(creation_date);
CREATE INDEX idx_sessions_completion_date ON quotation_sessions(completion_date);
CREATE INDEX idx_sessions_amount ON quotation_sessions(session_amount);

-- Полнотекстовые индексы для поиска
CREATE INDEX idx_contracts_search ON contracts USING gin (
    to_tsvector('russian', 
        contract_name || ' ' || 
        customer_name || ' ' || 
        supplier_name || ' ' ||
        contract_id || ' ' ||
        customer_inn || ' ' ||
        supplier_inn
    )
);

CREATE INDEX idx_sessions_search ON quotation_sessions USING gin (
    to_tsvector('russian', 
        session_name || ' ' || 
        customer_name || ' ' || 
        supplier_name || ' ' ||
        session_id || ' ' ||
        customer_inn || ' ' ||
        supplier_inn
    )
);
```

## Импорт данных

### Подготовка CSV файлов
1. Сохраните данные контрактов в файл `contracts.csv`
2. Сохраните данные котировочных сессий в файл `sessions.csv`
3. Убедитесь, что файлы находятся в корневой директории проекта

### Установка зависимостей
```bash
npm install pg csv-parser
```

### Скрипт импорта контрактов (import-contracts.js)
```javascript
const { Pool } = require('pg');
const fs = require('fs');
const csv = require('csv-parser');

const pool = new Pool({
    user: 'kb_user',
    host: 'localhost',
    database: 'knowledge_base',
    password: 'your_secure_password',
    port: 5432,
});

async function importContracts() {
    const results = [];
    
    fs.createReadStream('contracts.csv')
        .pipe(csv({
            headers: [
                'contract_name', 'contract_id', 'contract_amount', 'contract_date',
                'category', 'customer_name', 'customer_inn', 'supplier_name',
                'supplier_inn', 'law_basis'
            ],
            skipLines: 1
        }))
        .on('data', (data) => results.push(data))
        .on('end', async () => {
            const client = await pool.connect();
            
            try {
                for (const item of results) {
                    await client.query(
                        `INSERT INTO contracts (
                            contract_name, contract_id, contract_amount, contract_date,
                            category, customer_name, customer_inn, supplier_name,
                            supplier_inn, law_basis
                        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`,
                        [
                            item.contract_name,
                            item.contract_id,
                            parseFloat(item.contract_amount),
                            item.contract_date,
                            item.category === 'NULL' ? null : item.category,
                            item.customer_name,
                            item.customer_inn,
                            item.supplier_name,
                            item.supplier_inn,
                            item.law_basis
                        ]
                    );
                }
                console.log('Импорт контрактов завершен успешно');
            } catch (error) {
                console.error('Ошибка импорта:', error);
            } finally {
                client.release();
                await pool.end();
            }
        });
}

importContracts();
```

### Запуск импорта
```bash
node import-contracts.js
node import-sessions.js
```

## Настройка прав доступа

### Предоставление прав пользователю
```bash
sudo -u postgres psql -d knowledge_base -c "
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO kb_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO kb_user;
GRANT USAGE ON SCHEMA public TO kb_user;
"
```

### Проверка прав доступа
```bash
sudo -u postgres psql -d knowledge_base -c "
SELECT 
    grantee, 
    table_name, 
    privilege_type 
FROM information_schema.table_privileges 
WHERE grantee = 'kb_user';
"
```

## Проверка данных

### Проверка импортированных данных
```sql
-- Проверка количества записей
SELECT COUNT(*) FROM contracts;
SELECT COUNT(*) FROM quotation_sessions;

-- Проверка примеров данных
SELECT * FROM contracts LIMIT 5;
SELECT * FROM quotation_sessions LIMIT 5;

-- Проверка уникальности идентификаторов
SELECT contract_id, COUNT(*) 
FROM contracts 
GROUP BY contract_id 
HAVING COUNT(*) > 1;

SELECT session_id, COUNT(*) 
FROM quotation_sessions 
GROUP BY session_id 
HAVING COUNT(*) > 1;

-- Проверка статистики
SELECT 
    MIN(contract_date) as earliest_contract,
    MAX(contract_date) as latest_contract,
    AVG(contract_amount) as avg_amount,
    SUM(contract_amount) as total_amount
FROM contracts;

SELECT 
    MIN(creation_date) as earliest_session,
    MAX(creation_date) as latest_session,
    AVG(session_amount) as avg_amount,
    SUM(session_amount) as total_amount
FROM quotation_sessions;
```

## Устранение常见 ошибок

### Ошибка: "permission denied for table"
```bash
# Решение: предоставить права пользователю
sudo -u postgres psql -d knowledge_base -c "
GRANT ALL PRIVILEGES ON TABLE table_name TO kb_user;
"
```

### Ошибка: "value too long for type character varying"
```bash
# Решение: увеличить размер поля
sudo -u postgres psql -d knowledge_base -c "
ALTER TABLE table_name ALTER COLUMN column_name TYPE TEXT;
"
```

### Ошибка: "relation does not exist"
```bash
# Решение: проверить существование таблицы
sudo -u postgres psql -d knowledge_base -c "\dt"

# Создать таблицу если отсутствует
sudo -u postgres psql -d knowledge_base -c "CREATE TABLE ..."
```

### Ошибка: "password authentication failed"
```bash
# Решение: проверить пароль пользователя
sudo -u postgres psql -c "ALTER USER kb_user WITH PASSWORD 'new_password';"

# Или использовать пользователя postgres
const pool = new Pool({
    user: 'postgres',
    password: 'postgres_password',
    // ...
});
```

### Проверка подключения к базе данных
```javascript
// test-connection.js
const { Pool } = require('pg');

const pool = new Pool({
    user: 'kb_user',
    host: 'localhost',
    database: 'knowledge_base',
    password: 'your_secure_password',
    port: 5432,
});

async function testConnection() {
    try {
        const client = await pool.connect();
        console.log('Подключение к PostgreSQL успешно');
        const result = await client.query('SELECT version()');
        console.log('Версия PostgreSQL:', result.rows[0].version);
        client.release();
    } catch (error) {
        console.error('Ошибка подключения:', error.message);
    }
    await pool.end();
}

testConnection();
```

## Полезные команды PostgreSQL

### Мониторинг базы данных
```bash
# Подключение к базе данных
sudo -u postgres psql -d knowledge_base

# Просмотр списка таблиц
\dt

# Просмотр структуры таблицы
\d table_name

# Просмотр списка пользователей
\du

# Выход из psql
\q
```

### Резервное копирование и восстановление
```bash
# Создание резервной копии
sudo -u postgres pg_dump knowledge_base > backup.sql

# Восстановление из резервной копии
sudo -u postgres psql -d knowledge_base < backup.sql
```

Это руководство охватывает полный цикл работы с PostgreSQL в проекте TenderHack, от установки до импорта данных и устранения ошибок.