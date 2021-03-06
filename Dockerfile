FROM debian:8

MAINTAINER Ozzy Johnson <docker@ozzy.io>

ENV DEBIAN_FRONTEND noninteractive

ENV MININET_REPO https://github.com/mininet/mininet.git
ENV MININET_INSTALLER mininet/util/install.sh
ENV INSTALLER_SWITCHES -fbinptvwyx

WORKDIR /tmp

# Update and install minimal.
RUN \
    apt-get update \
        --quiet \
    && apt-get install \
        --yes \
        --no-install-recommends \
        --no-install-suggests \
    autoconf \
    automake \
    ca-certificates \
    git \
    libtool \
    net-tools \
    openssh-client \
    patch \
    vim \

# Clone and install.
    && git clone $MININET_REPO \

# A few changes to make the install script behave.
    && sed -e 's/sudo //g' \
    	-e 's/~\//\//g' \
    	-e 's/\(apt-get -y install\)/\1 --no-install-recommends --no-install-suggests/g' \
    	-i $MININET_INSTALLER \

# Install script expects to find this. Easier than patching that part of the script.
    && touch /.bashrc \

# Proceed with the install.
    && chmod +x $MININET_INSTALLER \
    && ./$MININET_INSTALLER -a \

# Clean up source.
    && rm -rf /tmp/mininet \
              /tmp/openflow \

# Clean up packages.
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

VOLUME ["/data"]

WORKDIR /data

# Default command.
CMD ["bash"]
