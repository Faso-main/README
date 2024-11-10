# Установка и настройка Python в Ubuntu

Этот документ описывает шаги для установки Python, создания виртуального окружения и установки зависимостей в Ubuntu.

## Шаги

1. **Проверьте установленную версию Python:**
   `python3 -V`

2. **Обновите список пакетов:**
   `sudo apt update`

3. **Обновите установленные пакеты:**
   `sudo apt -y upgrade`

4. **Установите необходимые пакеты для работы с виртуальными окружениями:**
   `sudo apt install python3-venv`

5. **Создайте новое виртуальное окружение:**
   `python3 -m venv my_venv`

6. **Проверьте список файлов в текущей директории:**
   `ls -la`

7. **Активируйте виртуальное окружение:**
   `source my_venv/bin/activate`

8. **Установите необходимые зависимости с помощью pip:**
   `pip install <package_name>`
   Замените `<package_name>` на имя нужной библиотеки.

9. **Проверьте установленные пакеты:**
   `pip freeze`

10. **Деактивируйте виртуальное окружение:**
    `deactivate`

## Примечания
- Не забудьте активировать ваше виртуальное окружение (`source my_venv/bin/activate`) каждый раз, когда вы хотите работать над проектом.
- Для установки дополнительных пакетов используйте `pip install <package_name>` в активированном окружении.

Удачи в вашем проекте! 🚀