# Развертывание Node.js на Ubuntu VPS

## Подготовка сервера

### 1. Обновление системы
```bash
sudo apt update && sudo apt -y upgrade
```

### 2. Установка базового программного обеспечения
```bash
sudo apt install -y nodejs npm nginx
```

### 3. Установка NVM (Node Version Manager)
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
source ~/.bashrc
```

### 4. Установка конкретной версии Node.js
```bash
nvm install 20.18.0
nvm use 20.18.0
```

## Настройка брандмауэра

```bash
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw enable
sudo ufw status
```

## Развертывание приложения

### 1. Клонирование проекта
```bash
ssh-keygen
cat ~/.ssh/id_ed25519.pub
добавьте публичный ключ в ваш репозиторий на GitHub.
cd /root
git clone -b YOUR_BRANCH LINK_TO_REPO
cd REPO_NAME
```

### 2. Установка зависимостей и сборка
```bash
npm ci
npm run build
```

### 3. Создание рабочей директории
```bash
sudo mkdir -p /var/www/faso312
sudo rm -rf /var/www/faso312/*
sudo cp -r dist/* /var/www/faso312/
```

### 4. Настройка прав доступа
```bash
sudo chown -R www-data:www-data /var/www/faso312
sudo chmod -R 755 /var/www/faso312
```

## Настройка PostgreSQL

### 1. Установка PostgreSQL
```bash
sudo apt update
sudo apt -y install postgresql postgresql-contrib
sudo systemctl status postgresql
```

### 2. Создание пользователя и базы данных
```bash
sudo -i -u postgres
createuser --interactive --pwprompt faso_user
createdb -O faso_user faso_db
exit
```

### 3. Настройка аутентификации
```bash
sudo nano /etc/postgresql/14/main/postgresql.conf
```
Установить:
```
password_encryption = scram-sha-256
```

### 4. Настройка доступа
```bash
sudo nano /etc/postgresql/14/main/pg_hba.conf
```
Добавить/изменить строки:
```
local   all             all                                     scram-sha-256
host    all             all             0.0.0.0/0               scram-sha-256
```

### 5. Перезапуск PostgreSQL
```bash
sudo systemctl restart postgresql
```

## Настройка подключения к базе данных

В файле конфигурации приложения используйте следующие параметры:

```javascript
import pkg from 'pg';
const { Pool } = pkg;

const pool = new Pool({
  user: 'faso_user',
  host: 'localhost',
  database: 'faso_db',
  password: 'ваш_пароль',
  port: 5432,
});
```

## Настройка PM2 для управления процессами

### 1. Установка PM2
```bash
sudo npm i pm2 -g
```

### 2. Запуск приложения
```bash
pm2 start ваш_скрипт.js --name TenderHack
pm2 startup ubuntu
pm2 save
```

### 3. Управление приложением
```bash
pm2 status
pm2 restart TenderHack
pm2 logs TenderHack --lines 100 --timeline
pm2 flush
```

## Настройка NGINX

### 1. Базовая конфигурация HTTP
```bash
sudo nano /etc/nginx/sites-available/default
```

```nginx
server {
    listen 80;
    server_name faso312.ru www.faso312.ru;

    root /var/www/faso312;
    index index.html;

    location /api/ {
        proxy_pass http://127.0.0.1:3001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location / {
        try_files $uri /index.html;
    }
}
```

### 2. Проверка и применение конфигурации
```bash
sudo nginx -t
sudo systemctl reload nginx
```

## Настройка SSL с Let's Encrypt

### 1. Установка Certbot
```bash
sudo apt -y install certbot python3-certbot-nginx
```

### 2. Получение SSL-сертификата
```bash
sudo certbot --nginx -d faso312.ru -d www.faso312.ru
```

### 3. Финальная конфигурация NGINX
```bash
sudo nano /etc/nginx/sites-available/default
```

```nginx
# Перенаправление HTTP -> HTTPS
server {
    listen 80;
    server_name faso312.ru www.faso312.ru;
    return 301 https://$host$request_uri;
}

# Основной сервер HTTPS
server {
    listen 443 ssl http2;
    server_name faso312.ru www.faso312.ru;

    # SSL-сертификаты Let's Encrypt
    ssl_certificate /etc/letsencrypt/live/faso312.ru/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/faso312.ru/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    root /var/www/faso312;
    index index.html;

    # Прокси для API-запросов
    location /api/ {
        proxy_pass http://127.0.0.1:3001;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Раздача статических ресурсов с кэшированием
    location ~* \.(?:js|css|png|jpg|jpeg|gif|svg|ico|woff2?)$ {
        expires 7d;
        access_log off;
        try_files $uri =404;
    }

    # Маршруты SPA
    location / {
        try_files $uri /index.html;
    }
}
```

### 4. Применение изменений
```bash
sudo nginx -t
sudo systemctl reload nginx
```

## Проверка работоспособности

### 1. Проверка статических файлов
```bash
ls -l /var/www/faso312
curl -I https://faso312.ru/
curl -I https://faso312.ru/index.html
curl -I https://faso312.ru/assets/ваш_файл.js
```

### 2. Проверка API
```bash
curl -s https://faso312.ru/api/health
```

### 3. Проверка логов
```bash
sudo tail -n 100 /var/log/nginx/error.log
pm2 logs TenderHack --lines 100 --timeline
```

### 4. Проверка подключения к базе данных
```bash
psql -h localhost -U faso_user -d faso_db
```

## Автоматическое обновление SSL-сертификатов

```bash
sudo certbot renew --dry-run
```

## Примечания

- Замените `faso312.ru` на ваш домен
- Убедитесь, что DNS-записи домена указывают на IP-адрес вашего сервера
- Регулярно обновляйте систему и зависимости
- Настройте мониторинг и логирование для production-окружения
- Регулярно создавайте резервные копии базы данных