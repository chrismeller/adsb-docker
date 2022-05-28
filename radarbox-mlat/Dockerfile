FROM debian:10.12-slim AS base
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


COPY start.sh /
RUN chmod +x /start.sh

ENTRYPOINT [ "/usr/bin/tini", "--", "/start.sh" ]