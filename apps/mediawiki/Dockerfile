FROM         --platform=$TARGETOS/$TARGETARCH mediawiki:1.42.4

LABEL        org.opencontainers.image.source="https://github.com/darksaid98/yolks"
LABEL        author="darksaid98" maintainer="darksaid9889@gmail.com"

ENV     DEBIAN_FRONTEND noninteractive

RUN     apt -y update && \
        apt -y upgrade && \
        apt -y install iproute2 && \
        useradd -d /home/container -m container -s /bin/bash

USER    container
ENV     USER=container HOME=/home/container
WORKDIR /home/container

COPY    ./entrypoint.sh /entrypoint.sh
CMD     ["/bin/bash", "/entrypoint.sh"]
