FROM debian:buster-20221004-slim AS base
LABEL maintainer="https://github.com/chrismeller"

ENV ADSB_EXCHANGE_UUID=
ENV ADSB_EXCHANGE_STATS_ENDPOINT=https://adsbexchange.com/api/receive/

ARG PERM_INSTALL="tini gettext curl jq gzip"
RUN apt-get update && apt-get install -y ${PERM_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

FROM base AS release

COPY start.sh /
RUN chmod +x /start.sh

RUN mkdir -p /run/adsbexchange-stats

ENTRYPOINT [ "/usr/bin/tini", "--", "/start.sh" ]