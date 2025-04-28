# Руководство по использованию PyInstaller

Этот документ представляет собой краткое руководство по использованию PyInstaller для упаковки Python приложений в standalone исполняемые файлы.

## Что такое PyInstaller?

[PyInstaller](https://www.pyinstaller.org/) - это инструмент, который преобразует Python скрипты в standalone исполняемые файлы для Windows, Linux, macOS, FreeBSD, Solaris и AIX. Он "замораживает" ваше приложение (включая все зависимости) в исполняемый файл, который может быть запущен без необходимости установки Python на машине пользователя.

## Установка

Установка PyInstaller проста и выполняется через pip:

```bash
pip install pyinstaller