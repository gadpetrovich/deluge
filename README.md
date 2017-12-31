# docker-deluge

## Используемые приложения
* [Deluge](http://deluge-torrent.org/)
* [Docker](https://www.docker.com/)

## Настройка
Для сборки используется образ ubuntu:16.04.

### Построение образа
```bash
docker build -t deluge .
```

### Создание контейнера
```bash
docker create --name <container name> \
  --network <net> \
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
### Параметры

* ```--network <net>``` - сеть, с которой будет работать созданный контейнер.
* ```-p 53160:53160``` - порты торрент-клиента.
* ```-p 58846:58846``` - порт демона deluged.
* ```-p 8112:8112``` - вэб-интерфейс.
* ```-v <config dir>:/config``` - каталог настроек deluge.
* ```-v <data dir>:/data``` - каталог скачиваемых файлов.
* ```-e UMASK=<umask>``` - установка маски файлов, по умолчанию = 002.
* ```-e PUID=<uid>``` - UID создаваемых файлов.
* ```-e PGID=<gid>``` - GID создаваемых файлов.

### Доступ к вэб-интерфейсу

> <ip-адрес>:8112

Пароль по умолчанию: docker.
Замените каталог загрузки на /data после первого входа.

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
