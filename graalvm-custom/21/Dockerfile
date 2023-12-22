# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java
# Minimum Panel Version: 1.7.0
# ----------------------------------
FROM ubuntu:22.04

ARG TARGETPLATFORM
ARG JAVA_VERSION=21

LABEL author="darksaid98" maintainer="kontakt@riko.dev"

LABEL org.opencontainers.image.source="https://github.com/darksaid98/pterodactyl-graalvm"

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME /opt/java/graalvm
ENV PATH $JAVA_HOME/bin:$PATH

# Default to UTF-8 file.encoding
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# Environment Setup
RUN apt update -y \
	&& apt install -y --no-install-recommends \
		curl \
		wget \
		fontconfig \
		ca-certificates \
		p11-kit \
		binutils \
		tzdata \
		locales \
		lsof \
		openssl \
		git \
		git-lfs \
		tar \
		sqlite3 \
		iproute2 \
		libfreetype6 \
		tini \
		ripgrep \
	&& echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.UTF-8 \
	&& rm -rf /var/lib/apt/lists/*

# GraalVM Install
RUN case ${TARGETPLATFORM} in \
		"linux/amd64")  ARCH=x64  ;; \
		"linux/arm64")  ARCH=aarch64  ;; \
	esac \
	&& wget --progress=dot:giga -O /tmp/graalvm.tar.gz https://download.oracle.com/graalvm/${JAVA_VERSION}/latest/graalvm-jdk-${JAVA_VERSION}_linux-${ARCH}_bin.tar.gz \
	&& mkdir -p "${JAVA_HOME}" \
	&& tar --extract \
		--file /tmp/graalvm.tar.gz \
		--directory "${JAVA_HOME}" \
		--strip-components 1 \
		--no-same-owner \
	&& rm -rf /tmp/graalvm.tar.gz

# Java info
RUN echo "javac --version"; javac --version \
	&& echo "java --version"; java --version

## Setup user and working directory
RUN         useradd -m -d /home/container -s /bin/bash container
USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL SIGINT

COPY        --chown=container:container ./../entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT    ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
