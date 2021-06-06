FROM debian:buster-slim AS base
LABEL maintainer="https://github.com/chrismeller"

EXPOSE 30053 30054

ENV PLANEFINDER_SHARECODE=
ENV LAT=
ENV LON=
ENV ALT=
ENV RECEIVER_HOST=readsb
ENV RECEIVER_PORT=30005

ARG PERM_INSTALL="tini gettext-base libc6 lsb-base"
RUN apt-get update && apt-get install -y ${PERM_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

FROM base AS buildstep

ARG TEMP_INSTALL="wget"
RUN apt-get update && apt-get install -y ${TEMP_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

WORKDIR /tmp
# Cloudflare blocks all attempts to parse this automatically, so we have to manually specify it
RUN wget http://client.planefinder.net/pfclient_5.0.161_armhf.deb
RUN dpkg -i pfclient_*.deb

FROM base as release

# copy our build deb file from the build layer to the output layer
COPY --from=buildstep /tmp/pfclient_*.deb /tmp/

RUN dpkg -i /tmp/pfclient_*.deb

COPY start.sh /
RUN chmod +x /start.sh

ENTRYPOINT [ "/usr/bin/tini", "--", "/start.sh" ]