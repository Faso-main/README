#!/bin/bash

#  Проверка статуса
echo -e "\n2. Простая проверка (grep):"
curl -s "http://localhost:9090/api/v1/targets" | grep -o '"scrapePool":"[^"]*"' | head -10

# Проверка метрики up
echo -e "\n3. Статус сервисов:"
curl -s "http://localhost:9090/api/v1/query?query=up" | grep -o '"__name__":"[^"]*"' | head -10