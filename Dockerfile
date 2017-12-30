FROM ubuntu:16.04
ARG BUILD_DATE
ARG VERSION
LABEL build_version="ubuntu: ${VERSION} Build-date: ${BUILD_DATE}"
LABEL maintainer="gadpetrovich"

RUN apt-get update -q && \
    apt-get install -qy software-properties-common && \
    add-apt-repository ppa:deluge-team/ppa && \
    apt-get update -q && \
    apt-get install -qy deluged deluge-web

#тестирование
RUN apt-get --yes install net-tools

COPY start.sh /start.sh

RUN chmod +x /start.sh


VOLUME /config /data

# Torrent ports
EXPOSE 53160 53160/udp
# WebUI
EXPOSE 8112
# Daemon
EXPOSE 58846

CMD ["/start.sh"]
