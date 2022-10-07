FROM debian:buster-20221004-slim AS base
LABEL maintainer="https://github.com/chrismeller"

EXPOSE 8754

ENV LAT=
ENV LON=
ENV ALT=
ENV FLIGHTRADAR_SHARING_KEY=
ENV RECEIVER_HOST=readsb
ENV RECEIVER_PORT=30005

ARG PERM_INSTALL="tini gettext-base ca-certificates"
RUN apt-get update && apt-get install -y ${PERM_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

FROM base AS buildstep

ARG TEMP_INSTALL="tar gzip wget curl"
RUN apt-get update && apt-get install -y ${TEMP_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

# The repo is a pain to work with, we're going to grab the binary ourselves
# We parse out the latest version from the repo's Packages file
WORKDIR /tmp
RUN FR_VERSION=$(curl --insecure https://repo.feed.flightradar24.com/dists/flightradar24/raspberrypi-stable/binary-armhf/Packages | grep Version | sed 's/Version: //') && \
    wget --no-check-certificate -O fr24feed.tgz https://repo.feed.flightradar24.com/rpi_binaries/fr24feed_${FR_VERSION}_armhf.tgz && \
    tar zxvf fr24feed.tgz --strip-components 1

# We have to set a specific (old) version, because otherwise it fails to download its configuration for some reason
#RUN FR_VERSION=1.0.25-3 && \
#    wget --no-check-certificate -O fr24feed.tgz https://repo.feed.flightradar24.com/rpi_binaries/fr24feed_${FR_VERSION}_$(dpkg --print-architecture).tgz && \
#    tar zxvf fr24feed.tgz --strip-components 1

# Install the key for the repo
#RUN apt-key adv --keyserver hkps://peegeepee.com --recv-key C969F07840C430F5
#RUN echo 'deb http://repo.feed.flightradar24.com flightradar24 raspberrypi-stable' >> /etc/apt/sources.list.d/flighradar.list
#RUN dpkg --add-architecture armhf
#RUN apt-get update && apt-get install -y fr24feed && apt-get clean && apt-get autoclean && apt-get autoremove

FROM base AS release

COPY --from=buildstep /tmp/fr24feed /usr/bin


COPY start.sh /
RUN chmod +x /start.sh

COPY fr24feed.ini.tpl /etc/fr24feed.ini.tpl

ENTRYPOINT [ "/usr/bin/tini", "--", "/start.sh" ]