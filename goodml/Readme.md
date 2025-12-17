# Goodml notes

- наладить отображение данных в графане
- организовать процесс внесения правок в контейнеры
- грамотно выкинуть возможность просматривать логи в сети
- как и нужно ли логировать face-worker-1
- вникнуть в инфру МЛки

```bash
ssh mercury                                                           # prod server(конфиги sh на машине)
```

## Docker

```bash
docker logs prod-face-worker-1 --tail 500                               # last X container logs
docker ps                                                               # list all running containers 
docker logs -f NAME_OF_SERVICE -n 1000 -t                               # last X container logs 
docker restart prod-prometheus-1                                        # перезапуск конкретного контейнера
docker exec prod-prometheus-1 cat /etc/prometheus/prometheus.yml        # 468c00934d97
docker stats NAME_OF_SERVICE                                            # статистика контейнеров(мало пользы)
docker inspect NAME_OF_SERVICE                                          # информация о контейнере(мало пользы)
```

## Мониторинг IT-инфраструктуры

Grafana: <http://localhost:13000>
Prometheus: <http://localhost:19090>

```bash
ssh -N -R 13000:localhost:3000 -R 19090:localhost:9090 ml2@ml-gooddelo          # тунель с сервера на ноутбук
ssh -L 13000:localhost:3000 -L 19090:localhost:9090 ml@mercury                  # тунель с ноутбука на сервер (более разумно)

ssh -L 0.0.0.0:13000:localhost:3000 -L 0.0.0.0:19090:localhost:9090 ml@mercury              # рабочий тунель

docker exec -it prod-grafana-1 grafana-cli admin reset-admin-password NEW_PASSWORD          # сбросить пароль у графаны

sudo ss -tlnp | grep -E ':13000|:19090'               # проверить порты на локальной машине

curl -s -o /dev/null -w "HTTP статус: %{http_code}\n" http://localhost:3000 # curl GRAFANA
```

## Git

```bash
find . -type f -size +50M -exec du -h {} + | sort -r        # all files size more 50mb
```
