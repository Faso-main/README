# Командная строка Windows: основные команды

## Файлы и папки

- `dir` - список файлов и папок в текущей директории
- `cd <путь>` - перейти в указанную папку
- `cd ..` - перейти в родительскую папку
- `mkdir <имя>` - создать новую папку
- `del <файл>` - удалить файл
- `rmdir /s <папка>` - удалить папку и все содержимое

## Работа с текстом

- `type <файл>` - вывести содержимое текстового файла
- `find "текст" <файл>` - поиск текста в файле
- `echo текст > файл.txt` - создать файл с текстом
- `copy <исходный> <целевой>` - копировать файл

## Система

- `systeminfo` - информация о системе
- `tasklist` - список запущенных процессов
- `taskkill /PID <номер>` - завершить процесс по ID
- `shutdown /s /t 0` - немедленное выключение
- `shutdown /r /t 0` - немедленная перезагрузка

## Сеть

- `ipconfig` - информация о сетевых подключениях
- `ping <адрес>` - проверить соединение с узлом
- `tracert <адрес>` - трассировка маршрута
- `netstat -ano` - список активных подключений

## Права и учетные записи

- `whoami` - текущий пользователь
- `net user` - список пользователей
- `net localgroup administrators` - список администраторов

## Дополнительно

- `help` - список доступных команд
- `<команда> /?` - справка по конкретной команде
- `cls` - очистить экран консоли
- `exit` - закрыть командную строку
