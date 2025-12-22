# Документация по дашбордам Grafana

## Автоматическая загрузка

**Дашборды поднимаются автоматически** при старте Grafana через систему Provisioning. Все файлы из директории `provisioning/dashboards/` импортируются в папку "Gideone" без ручных действий.

### Структура автоматизации

```bash
grafana/provisioning/
├── dashboards.yaml          # Конфигурация загрузки
├── dashboards/              # JSON-файлы дашбордов
└── datasources/
    └── datasource.yaml     # Конфигурация Prometheus
```

### Требования для автоматической работы

1. Корректная настройка `datasource.yaml` с URL `http://prometheus:9090`
2. Наличие всех JSON-файлов в `provisioning/dashboards/`
3. Запуск Grafana через Docker с примонтированным volume `./grafana/provisioning:/etc/grafana/provisioning`

## Перезапуск контейнера

- происходит через файл restart_prometheus_grafana.sh

## Назначение файлов

- **`provisioning/dashboards/grafana-hardware.json`** - Мониторинг физических ресурсов сервера (CPU, RAM, диск, сеть).
- **`provisioning/dashboards/grafana-container-monitoring.json`** - Мониторинг состояния и ресурсов Docker-контейнеров.
- **`provisioning/dashboards/grafana-ml.json`** - Мониторинг метрик машинного обучения (детекции, активность воркеров).
- **`provisioning/dashboards/grafana-docker.json`** - Мониторинг метрик Docker Engine и состояния демона.

## Ручной импорт дашбордов (если нужно)

### Способ 1: Web-интерфейс Grafana

1. Перейдите в Grafana (`http://<сервер>:3000`)
2. Наведите курсор на иконку "Dashboard" (значок четырех квадратов)
3. Выберите "Import"
4. Нажмите "Upload JSON file"
5. Выберите нужный JSON-файл
6. Укажите источник данных (Prometheus)
7. Нажмите "Import"

### Способ 2: Принудительный перезапуск provisioning

1. Скопируйте JSON-файлы в `./provisioning/dashboards/`
2. Перезапустите Grafana: `docker restart prod-grafana-1`

### Способ 3: Через API Grafana

```bash
curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $API_TOKEN" --data @grafana-hardware.json http://localhost:3000/api/dashboards/db
```

## Требования

1. **Prometheus** как источник данных (UID: `PBFA97CFB590B2093`)
2. Экспортеры метрик:
   - Node Exporter для `hardware.json` (`http://prod-node-exporter-1:9100/metrics`)
   - cAdvisor для `container-monitoring.json` (`http://a87e0f5988ed:8080/metrics`)
   - Docker Daemon Metrics для `docker.json` (требует настройки)

## Примечания

- Для обновления существующих дашбордов увеличьте значение поля `"version"` в JSON.
- При конфликтах используйте опцию "Save with force overwrite".
- Источник данных в панелях должен ссылаться на корректный UID Prometheus.
- После импорта проверьте, что все панели отображают данные.
