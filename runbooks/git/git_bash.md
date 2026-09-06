# Шпаргалка по Git командам

## Базовая настройка

```bash
# Настройка имени пользователя
git config --global user.name "Ваше Имя"

# Настройка email
git config --global user.email "your.email@example.com"

# Просмотр текущих настроек
git config --list
```

## Работа с репозиторием

```bash
# Клонирование репозитория
git clone https://github.com/username/repository.git

# Инициализация нового репозитория
git init

# Добавление удаленного репозитория
git remote add origin https://github.com/username/repository.git

# Просмотр подключенных репозиториев
git remote -v
```

## Основные команды

```bash
# Проверка статуса репозитория
git status

# Добавление всех измененных файлов
git add .

# Добавление конкретного файла
git add filename.txt

# Создание коммита
git commit -m "Описание изменений"

# Отправка изменений на сервер
git push origin main

# Загрузка изменений с сервера
git pull origin main
```

## Ветки (Branches)

```bash
# Просмотр всех веток
git branch

# Создание новой ветки
git branch new-branch

# Переключение на ветку
git checkout branch-name

# Создание и переключение на новую ветку
git checkout -b new-branch

# Удаление ветки
git branch -d branch-name

# Отправка ветки на сервер
git push origin branch-name
```

## Просмотр истории и изменений

```bash
# Просмотр истории коммитов
git log

# Просмотр изменений в файлах
git diff

# Просмотр изменений в конкретном файле
git diff filename.txt
```

## Отмена изменений

```bash
# Отмена изменений в файле (до добавления в stage)
git checkout -- filename.txt

# Отмена добавления файла в stage
git reset HEAD filename.txt

# Отмена последнего коммита
git reset HEAD~

# Изменение последнего коммита
git commit --amend -m "Новое описание"
```

## Временное сохранение изменений

```bash
# Временное сохранение изменений
git stash

# Восстановление сохраненных изменений
git stash pop
```

## Дополнительные команды

```bash
# Проверка версии Git
git --version

# Получение справки по команде
git help command

# Принудительная отправка изменений (использовать осторожно!)
git push --force origin branch-name
```

## Типовой рабочий процесс

```bash
# Ежедневная работа
git status
git add .
git commit -m "Описание выполненной работы"
git pull origin main
git push origin main

# Создание новой функциональности
git checkout -b new-feature
# ... работа над кодом ...
git add .
git commit -m "Добавлена новая функциональность"
git push origin new-feature
```