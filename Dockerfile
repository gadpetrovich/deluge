FROM ubuntu:16.04

ARG BUILD_DATE
ARG VERSION

LABEL build_version="ubuntu: ${VERSION} Build-date: ${BUILD_DATE}"
LABEL maintainer="gadpetrovich"

#COPY deluge-daemon.init.d /etc/init.d/deluge-daemon
#COPY deluge-daemon.default /etc/default/deluge-daemon

#RUN apt-get update && apt-get --yes install deluge deluged deluge-webui

#RUN adduser --home /var/lib/torrent --shell /usr/sbin/nologin --disabled-password -disabled-login torrent

#RUN usermod -a -G users torrent

#RUN chmod 755 /etc/init.d/deluge-daemon

#RUN update-rc.d deluge-daemon defaults

#RUN apt-get update && apt-get --yes install deluged deluge-webui
RUN apt-get update -q && \
    apt-get install -qy software-properties-common && \
    add-apt-repository ppa:deluge-team/ppa && \
    apt-get update -q && \
    apt-get install -qy deluged deluge-web

#тестирование
RUN apt-get --yes install net-tools

#RUN adduser --system --gecos "Deluge Service" --disabled-password --group --home /var/lib/deluge deluge

COPY start.sh /start.sh

RUN chmod +x /start.sh

#COPY deluged.service /etc/systemd/system/deluged.service
#COPY deluge-web.service /etc/systemd/system/deluge-web.service

#RUN systemctl enable deluged.service
#RUN systemctl enable deluge-web.service

#логгирование
#RUN mkdir -p /var/log/deluge
#RUN chown -R deluge:deluge /var/log/deluge
#RUN chmod -R 750 /var/log/deluge

VOLUME /config /data

# Torrent ports
EXPOSE 53160 53160/udp
# WebUI
EXPOSE 8112
# Daemon
EXPOSE 58846

#CMD ["service", "deluge-daemon", "start"]
#CMD ["sleep", "2000"]

#CMD ["deluged"]
#CMD ["deluged", "&&", "deluge-web"]
#CMD /bin/bash
#CMD systemd
CMD ["/start.sh"]
#ENTRYPOINT ["/start.sh"]
