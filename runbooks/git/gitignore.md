# Работа с .gitignore

Файл `.gitignore` определяет, какие файлы и папки Git должен игнорировать. Это важно для исключения из репозитория временных файлов, конфиденциальных данных и файлов, специфичных для окружения.

## Основные правила синтаксиса

### Базовые шаблоны

```bash
# Игнорировать конкретный файл
config.ini

# Игнорировать все файлы с расширением
*.log

# Игнорировать папку
temp/
```

### Специальные символы

```bash
# Игнорировать во всех подпапках
**/cache/

# Исключение из игнорирования
!important.log

# Комментарии (начинаются с #)
# Игнорировать временные файлы
```

## Типичные шаблоны для разных языков

### Python

```bash
# Byte-compiled files
__pycache__/
*.py[cod]

# Virtual environment
venv/
.env/

# Build and distribution
build/
dist/
*.egg-info/
```

### JavaScript/Node.js

```bash
# Dependencies
node_modules/

# Environment variables
.env
.env.local

# Build files
dist/
build/
```

### Java

```bash
# Compiled class files
*.class

# Log files
*.log

# Package files
*.jar
*.war
```

## Лучшие практики

1. **Специфичные для IDE**:

```bash
# VS Code
.vscode/
*.code-workspace

# IntelliJ
.idea/
*.iml
```

2. **Системные файлы**:

```bash
# macOS
.DS_Store

# Windows
Thumbs.db
```

3. **Конфиденциальные данные**:

```bash
# Ключи и пароли
*.key
*.pem
secrets.yml
```

## Пример полного .gitignore для Python проекта

```bash
# Virtual environment
venv/
.env/

# Python files
__pycache__/
*.pyc
*.pyo
*.pyd

# Jupyter Notebook
.ipynb_checkpoints/

# Testing
.coverage
htmlcov/

# IDE
.vscode/
.idea/

# System files
.DS_Store
Thumbs.db

# Build and distribution
build/
dist/
*.egg-info/
```

## Примечания

1. Файл `.gitignore` должен находиться в корне репозитория
2. Изменения в `.gitignore` не влияют на уже отслеживаемые файлы
3. Для удаления уже добавленных файлов используйте:

```bash
git rm --cached <file>
```

Документация: [https://git-scm.com/docs/gitignore](https://git-scm.com/docs/gitignore)
```
