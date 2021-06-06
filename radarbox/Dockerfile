FROM debian:buster-slim AS base
LABEL maintainer="https://github.com/chrismeller"

EXPOSE 32088

ENV RADARBOX_KEY=
ENV RADARBOX_USERNAME=
ENV LAT=
ENV LON=
ENV ALT=
ENV RADARBOX_UAT_ENABLED=false
ENV RECEIVER_HOST=readsb
ENV RECEIVER_PORT=30005

ARG PERM_INSTALL="tini gettext-base python3 gnupg ca-certificates netbase"
RUN apt-get update && apt-get install -y ${PERM_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

FROM base AS buildstep

ARG TEMP_INSTALL="build-essential git debhelper python3-dev apt-transport-https python"
RUN apt-get update && apt-get install -y ${TEMP_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

WORKDIR /tmp
RUN git clone https://github.com/adsbxchange/mlat-client.git
RUN  cd mlat-client && dpkg-buildpackage -b --no-sign

FROM base as release

# copy our build deb file from the build layer to the output layer
COPY --from=buildstep /tmp/mlat-client_*.deb /tmp/

RUN dpkg -i /tmp/mlat-client_*.deb

# Install the key for the RB24 repo
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 1D043681
RUN echo 'deb https://apt.rb24.com/ buster main' > /etc/apt/sources.list.d/rb24.list

RUN apt-get update && apt-get install -y rbfeeder && apt-get clean && apt-get autoclean && apt-get autoremove


COPY start.sh /
RUN chmod +x /start.sh

COPY rbfeeder.ini.tpl /etc/rbfeeder.ini.tpl

ENTRYPOINT [ "/usr/bin/tini", "--", "/start.sh" ]