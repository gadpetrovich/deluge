#!/bin/bash

# SIGTERM-handler
term_handler() {
  if [ `cat $PIDFILE1` -ne 0 ]; then
    echo "stopping deluge"
    start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --user $PUID --pidfile $PIDFILE2 --remove-pidfile
    start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --user $PUID --pidfile $PIDFILE1 --remove-pidfile

    wait `cat $PIDFILE1`
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

trap 'kill ${!}; term_handler' SIGTERM

#set -e
UMASK=${UMASK:-002}

NAME1="deluged"
NAME2="deluge"
PIDFILE1=/var/run/$NAME1.pid
PIDFILE2=/var/run/$NAME2.pid
DAEMON1=/usr/bin/deluged
DAEMON2=/usr/bin/deluge-web
DAEMON1_ARGS="-d -c /config -l /config/deluged.log"
DAEMON2_ARGS="-c /config -l /config/deluge-web.log"

# Запуск
echo "starting deluge"

mkdir -p /var/lib/torrent
groupadd --force --gid ${PGID} --non-unique torrent
useradd --home-dir /var/lib/torrent --shell /usr/sbin/nologin --uid ${PUID} --gid ${PGID} --no-create-home --non-unique torrent

start-stop-daemon --start --background --quiet --make-pidfile --pidfile $PIDFILE1 --chuid $PUID:$PGID --user $PUID  --umask $UMASK --exec $DAEMON1 -- $DAEMON1_ARGS
start-stop-daemon --start --background --quiet --make-pidfile --pidfile $PIDFILE2 --chuid $PUID:$PGID --user $PUID  --umask $UMASK --exec $DAEMON2 -- $DAEMON2_ARGS

#wait

# Остановка
#echo "stopping deluge"


#echo "exited $0"
# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
