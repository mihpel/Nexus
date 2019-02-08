FROM ubuntu:18.04

ARG NEXUS_VERSION=master
ARG UNAME=nexus
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID $UNAME
RUN useradd -m -u $UID -g $GID -s /bin/bash $UNAME

RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common
#    && add-apt-repository ppa:bitcoin/bitcoin

RUN apt-get update -qy &&\
    apt-get -qy install --no-install-recommends \
    git\
    bzip2\
    wget\
    gconf2 \
    gconf-service \
    libnotify4 \
    libappindicator1 \
    libxtst6 \
    libnss3 \
    libxss1 \
    && rm -rf /var/lib/apt/lists/*

USER root
WORKDIR /tmp/
RUN wget https://github.com/Nexusoft/NexusInterface/releases/download/Release-0.8.6/nexus_wallet-0.8.6.deb \
    && dpkg -i nexus_wallet-0.8.6.deb \
    && rm nexus_wallet-0.8.6.deb

RUN apt-get update -qy &&\
    apt-get -qy install --no-install-recommends \
    libgtk-3-0 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

USER $UNAME
WORKDIR /home/${UNAME}/
#VOLUME ["/home/${UNAME}/.TAO"]
#EXPOSE 17298 17299
ENTRYPOINT ["nexus_wallet"]


#RUN wget https://github.com/Nexusoft/NexusInterface/releases/download/Release-0.8.6/nexus_wallet-0.8.6.deb
