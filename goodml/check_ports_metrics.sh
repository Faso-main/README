#!/bin/bash
echo "ДИАГНОСТИКА MONITORING СИСТЕМЫ"
echo "Время: $(date)"
echo ""

# Проверка сервисов
echo "1. СТАТУС КОНТЕЙНЕРОВ:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(prometheus|grafana|face|sale|node|cadvisor)"

echo ""
echo "2. ДОСТУПНОСТЬ ПОРТОВ НА ХОСТЕ:"
PORTS="3000 9090 9142 9143 9100 8300"
for port in $PORTS; do
  if timeout 1 bash -c "cat < /dev/null > /dev/tcp/localhost/$port" 2>/dev/null; then
    echo "Порт $port открыт"
  else
    echo "Порт $port закрыт"
  fi
done

echo ""
echo "3. МЕТРИКИ (если доступны):"
for service in "Grafana:3000" "Prometheus:9090" "Face:9143" "Sale:9142" "Node:9100"; do
  name=${service%:*}
  port=${service#*:}
  if curl -s -f http://localhost:$port > /dev/null 2>&1; then
    echo "$name доступен на порту $port"
  else
    echo "$name недоступен на порту $port"
  fi
done