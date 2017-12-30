FROM ubuntu:16.04
ARG BUILD_DATE
ARG VERSION
LABEL build_version="ubuntu: ${VERSION} Build-date: ${BUILD_DATE}"
LABEL maintainer="gadpetrovich <gadpetrovich@gmail.com>"

RUN apt-get update -q && \
    apt-get install -qy net-tools software-properties-common && \
    add-apt-repository ppa:deluge-team/ppa && \
    apt-get update -q && \
    apt-get install -qy deluged deluge-web && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
COPY start.sh /start.sh

RUN chmod +x /start.sh


VOLUME /config /data

# Torrent ports
EXPOSE 53160 53160/udp
# WebUI
EXPOSE 8112
# Daemon
EXPOSE 58846

#CMD ["/start.sh"]
ENTRYPOINT ["/start.sh"]
