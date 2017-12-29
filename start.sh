#! /bin/sh

#set -e
UMASK=${UMASK:-002}

umask "$UMASK"

rm -f /config/deluged.pid

deluged -d -c /config -L info -l /config/deluged.log &
deluge-web -c /config &
wait
