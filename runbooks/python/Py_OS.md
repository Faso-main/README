# Работа с модулем OS в Python

Модуль `os` предоставляет функции для взаимодействия с операционной системой. Это один из самых полезных стандартных модулей Python для работы с файловой системой и окружением.

## Основные функции

### Работа с файлами и директориями

```python
import os

# Получить текущую рабочую директорию
current_dir = os.getcwd()

# Сменить директорию
os.chdir('/path/to/new/dir')

# Список файлов в директории
files = os.listdir('.')

# Создать директорию
os.mkdir('new_folder')

# Рекурсивное создание директорий
os.makedirs('path/to/new/folder')

# Удалить файл
os.remove('file.txt')

# Удалить пустую директорию
os.rmdir('empty_folder')

# Рекурсивное удаление директории
import shutil
shutil.rmtree('folder_with_content')
```

### Работа с путями

```python
# Объединение путей
full_path = os.path.join('folder', 'subfolder', 'file.txt')

# Разделение пути на компоненты
dirname, filename = os.path.split('/path/to/file.txt')
basename = os.path.basename('/path/to/file.txt')
dirname = os.path.dirname('/path/to/file.txt')

# Получение абсолютного пути
abs_path = os.path.abspath('relative/path')

# Проверка существования
os.path.exists('some_path')  # True/False
os.path.isfile('file.txt')  # Проверка что это файл
os.path.isdir('folder')     # Проверка что это директория
```

### Работа с окружением

```python
# Получить переменные окружения
env_var = os.environ.get('HOME')

# Установить переменную окружения
os.environ['MY_VAR'] = 'value'

# Выполнить системную команду
os.system('ls -l')
```

### Полезные функции

```python
# Размер файла в байтах
size = os.path.getsize('file.txt')

# Время последнего изменения
mtime = os.path.getmtime('file.txt')  # timestamp

# Переименование файла
os.rename('old.txt', 'new.txt')

# Получить информацию о пользователе
user = os.getlogin()
```

## Примеры использования

## 1. Рекурсивный обход директории

```python
for root, dirs, files in os.walk('.'):
    print(f"В директории {root}:")
    print(f"Поддиректории: {dirs}")
    print(f"Файлы: {files}")
```

## 2. Обработка путей кросс-платформенно

```python
config_path = os.path.join(os.environ['HOME'], 'config', 'settings.ini')
```

## 3. Проверка доступности файла

```python
if os.path.isfile('data.csv'):
    with open('data.csv') as f:
        # обработка файла
else:
    print("Файл не найден")
```

## Примечания

1. Для сложных операций с файлами (копирование, архивирование) используйте модуль `shutil`
2. Для работы с путями рекомендуется использовать `os.path` вместо ручного соединения строк
3. Будьте осторожны с функциями удаления - они не спрашивают подтверждения

Документация: [https://docs.python.org/3/library/os.html](https://docs.python.org/3/library/os.html)
