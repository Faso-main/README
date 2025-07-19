# Pytest Automation Framework

## Описание

Этот проект использует `pytest` - фреймворк для написания и выполнения тестов на Python. Pytest предоставляет удобные возможности для создания unit, интеграционных и функциональных тестов.

## Требования

- Python 3.7+
- Установленные зависимости из `requirements.txt`

## Установка

1. Установите зависимости:
`pip install -r requirements.txt`

2. Установите pytest (если не в requirements.txt):
`pip install pytest`

## Запуск тестов

### Основной способ

`pytest`

### С опциями

- Запуск с подробным выводом:
`pytest -v`

- Запуск конкретного тестового файла:
`pytest tests/test_module.py`

- Запуск тестов по маркеру:
`pytest -m "smoke"`

- Запуск с генерацией отчета:
`pytest --html=report.html`
