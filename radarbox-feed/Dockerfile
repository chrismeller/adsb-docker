FROM debian:buster-20221004-slim AS base
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

FROM base as release

# Install the key for the RB24 repo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 1D043681
RUN echo 'deb https://apt.rb24.com/ buster main' > /etc/apt/sources.list.d/rb24.list

RUN apt-get update && apt-get install -y rbfeeder && apt-get clean && apt-get autoclean && apt-get autoremove


COPY start.sh /
RUN chmod +x /start.sh

COPY rbfeeder.ini.tpl /etc/rbfeeder.ini.tpl

ENTRYPOINT [ "/usr/bin/tini", "--", "/start.sh" ]