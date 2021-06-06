FROM debian:buster-slim AS base
LABEL maintainer="https://github.com/chrismeller"

EXPOSE 8754

ENV LAT=
ENV LON=
ENV ALT=
ENV OPENSKY_SERIAL=
ENV RECEIVER_HOST=readsb
ENV RECEIVER_PORT=30005

ARG PERM_INSTALL="tini gettext-base perl"
RUN apt-get update && apt-get install -y ${PERM_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

FROM base AS buildstep

ARG TEMP_INSTALL="wget"
RUN apt-get update && apt-get install -y ${TEMP_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

WORKDIR /tmp
RUN wget https://opensky-network.org/files/firmware/opensky-feeder_latest_armhf.deb
#RUN dpkg -i opensky-feeder_*.deb

# We can't just install the deb because it prompts for config values, so we extract its contents instead
RUN dpkg --unpack opensky-feeder_*.deb

FROM base AS release

COPY --from=buildstep /usr/bin/openskyd-dump1090 /usr/bin/openskyd-dump1090

RUN mkdir -p /var/lib/openskyd/conf.d/
COPY opensky.conf.tpl /var/lib/openskyd/conf.d/

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT [ "/usr/bin/tini", "--", "/start.sh" ]