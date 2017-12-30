#! /bin/bash

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap "echo TRAPed signal" HUP INT QUIT TERM

#set -e
UMASK=${UMASK:-002}

#NAME1="deluged"
#NAME2="deluge"
#PIDFILE1=/var/run/$NAME1.pid
#PIDFILE2=/var/run/$NAME2.pid
DAEMON1=/usr/bin/deluged
DAEMON2=/usr/bin/deluge-web
DAEMON1_ARGS="-d -c /config -l /config/deluged.log"
DAEMON2_ARGS="-c /config -l /config/deluge-web.log"

# Запуск
echo "starting deluge"
#umask "$UMASK"

#adduser --home /var/lib/torrent --shell /usr/sbin/nologin --disabled-password -disabled-login --uid ${PUID} --gid ${PGID} --quiet torrent
mkdir -p /var/lib/torrent
groupadd --force --gid ${PGID} --non-unique torrent
useradd --home-dir /var/lib/torrent --shell /usr/sbin/nologin --uid ${PUID} --gid ${PGID} --no-create-home --non-unique torrent

#rm -f /config/deluged.pid

#deluged -d -c /config -L info -l /config/deluged.log &
start-stop-daemon --start --background --quiet --chuid $PUID:$PGID --user $PUID  --umask $UMASK --exec $DAEMON1 -- $DAEMON1_ARGS
#deluge-web -c /config &
start-stop-daemon --start --background --quiet --chuid $PUID:$PGID --user $PUID  --umask $UMASK --exec $DAEMON2 -- $DAEMON2_ARGS

  
echo "[hit enter key to exit] or run 'docker stop <container>'"
read

# Остановка
echo "stopping deluge"

#start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --user $PUID --pidfile $PIDFILE2
#start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --user $PUID --pidfile $PIDFILE1

echo "exited $0"

#wait
