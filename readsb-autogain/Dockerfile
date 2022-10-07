FROM debian:buster-20221004-slim AS base
LABEL maintainer="https://github.com/chrismeller"

ARG PERM_INSTALL="cron jq"
RUN apt update && apt install -y ${PERM_INSTALL} && apt clean && apt autoclean && apt autoremove

COPY cron /etc/cron.d/autogain-cron
COPY defaults /etc/default/autogain1090
COPY autogain.sh /

ENTRYPOINT [ "cron" "-f" ]