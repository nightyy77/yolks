FROM --platform=$TARGETOS/$TARGETARCH golang:1.23.3 AS builder

ENV         DEBIAN_FRONTEND noninteractive


WORKDIR /appbuild/yagpdb

RUN apt update -y \
	&& apt upgrade -y \
	&& apt install -y apt-transport-https wget curl git tar

RUN git clone https://github.com/botlabs-gg/yagpdb.git .

RUN go mod download

COPY . .

WORKDIR /appbuild/yagpdb/cmd/yagpdb
RUN CGO_ENABLED=0 GOOS=linux go build -v -ldflags "-X github.com/botlabs-gg/yagpdb/v2/common.VERSION=$(git describe --tags)"



FROM --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

ENV         DEBIAN_FRONTEND noninteractive

# Dependencies: ca-certificates for client TLS, tzdata for timezone and ffmpeg for soundboard support
RUN apt update -y \
	&& apt upgrade -y \
	&& apt install -y ca-certificates tini ffmpeg tzdata

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN         useradd -m -d /home/container -s /bin/bash container
USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY --from=builder /appbuild/yagpdb/cmd/yagpdb/yagpdb yagpdb

STOPSIGNAL SIGINT

COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT    ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
