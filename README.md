# docker-deluge

## Используемые приложения
* [Deluge](http://deluge-torrent.org/)
* [Docker](https://www.docker.com/)

## Настройка
Для сборки используется образ ubuntu:16.04.

### Построение
```bash
docker build -t deluge .
```

### Запуск
```bash
docker run -d --name <container name> \
  -p 53160:53160 \
  -p 58846:58846 \
  -p 8112:8112 \
  -v <config dir>:/config \
  -v <data dir>:/data \
  -e UMASK=<umask> \
  -e PUID=<uid> \
  -e PGID=<gid> \
  deluge
```

### Доступ к вэб-интерфейсу

> <ip-адрес>:8112

Пароль по умолчанию: docker.

### Пример
```bash
docker run -d --name deluge1 \
  -p 8112:8112 \
  -v /var/lib/torrent/DelugeConfig:/config \
  -v /var/lib/torrent/DelugeData:/data \
  -e UMASK=002 \
  -e PUID=`id -u torrent` \
  -e PGID=`getent group users  | cut -d: -f3` \
  deluge:latest
```
