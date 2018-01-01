#!/bin/bash

#set -x
#set -e

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

USERNAME=torrent
UMASK=${UMASK:-002}
CONFIGDIR=/config
DATADIR=/data

NAME1="deluged"
NAME2="deluge-web"
PIDFILE1=/var/run/$NAME1.pid
PIDFILE2=/var/run/$NAME2.pid
DAEMON1=/usr/bin/deluged
DAEMON2=/usr/bin/deluge-web
DAEMON1_ARGS="-d -c $CONFIGDIR -l $CONFIGDIR/$NAME1.log"
DAEMON2_ARGS="-c $CONFIGDIR -l $CONFIGDIR/$NAME2.log"

# Запуск
echo "starting deluge"

echo "prepare user data"
mkdir -p /var/lib/torrent
groupadd --force --gid ${PGID} --non-unique $USERNAME
useradd --home-dir /var/lib/torrent --shell /usr/sbin/nologin --uid ${PUID} --gid ${PGID} --no-create-home --non-unique $USERNAME

#инициализацию взял из https://github.com/jordancrawfordnz/rpi-deluge-docker/blob/master/start.sh
if [ ! -f $CONFIGDIR/auth ]; then
  echo "configuring deluge"
  
  # Starting deluge
  su -s /bin/bash -c "deluged -c $CONFIGDIR" $USERNAME
  
  # Wait until auth file created.
  while [ ! -f $CONFIGDIR/auth ]; do
    sleep 1
  done
  
  
  su -s /bin/bash -c "deluge-console -c $CONFIGDIR \"config -s allow_remote True\"" $USERNAME
  su -s /bin/bash -c "deluge-console -c $CONFIGDIR \"config -s download_location $DATADIR\"" $USERNAME
  su -s /bin/bash -c "deluge-console -c $CONFIGDIR \"config -s torrentfiles_location $DATADIR\"" $USERNAME
  su -s /bin/bash -c "deluge-console -c $CONFIGDIR \"config -s move_completed_path $DATADIR\"" $USERNAME
  su -s /bin/bash -c "deluge-console -c $CONFIGDIR \"config -s autoadd_location $DATADIR\"" $USERNAME
  
  pkill deluged
fi

start-stop-daemon --start --background --quiet --make-pidfile --pidfile $PIDFILE1 --chuid $PUID:$PGID --user $PUID  --umask $UMASK --exec $DAEMON1 -- $DAEMON1_ARGS
start-stop-daemon --start --background --quiet --make-pidfile --pidfile $PIDFILE2 --chuid $PUID:$PGID --user $PUID  --umask $UMASK --exec $DAEMON2 -- $DAEMON2_ARGS

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
