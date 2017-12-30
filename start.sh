#! /bin/bash

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap "echo TRAPed signal" HUP INT QUIT TERM

#set -e
UMASK=${UMASK:-002}

DAEMON1=/usr/bin/deluged
DAEMON2=/usr/bin/deluge-web
DAEMON1_ARGS="-d -c /config -l /config/deluged.log"
DAEMON2_ARGS="-c /config -l /config/deluge-web.log"

# Запуск
echo "starting deluge"

mkdir -p /var/lib/torrent
groupadd --force --gid ${PGID} --non-unique torrent
useradd --home-dir /var/lib/torrent --shell /usr/sbin/nologin --uid ${PUID} --gid ${PGID} --no-create-home --non-unique torrent

start-stop-daemon --start --background --quiet --chuid $PUID:$PGID --user $PUID  --umask $UMASK --exec $DAEMON1 -- $DAEMON1_ARGS
start-stop-daemon --start --background --quiet --chuid $PUID:$PGID --user $PUID  --umask $UMASK --exec $DAEMON2 -- $DAEMON2_ARGS

  
echo "[hit enter key to exit] or run 'docker stop <container>'"
read

# Остановка
echo "stopping deluge"


echo "exited $0"
