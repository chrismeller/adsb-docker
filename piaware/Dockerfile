FROM debian:buster-slim AS base
LABEL maintainer="https://github.com/chrismeller"

EXPOSE 30105 30106 8080

ENV FLIGHTAWARE_FEEDER_ID=
ENV RECEIVER_HOST=readsb
ENV RECEIVER_PORT=30005
ENV RECEIVER_MLAT_PORT=30104
ENV DUMP978_ENABLED=false

ARG PERM_INSTALL="tini net-tools tcllib tclx8.4 tcl8.6 itcl3 libssl1.1 libboost-filesystem1.67.0 libboost-program-options1.67.0 libboost-regex1.67.0 libboost-system1.67.0 libexpat1 libreadline7"
RUN apt-get update && apt-get install -y ${PERM_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

FROM base AS buildstep

ARG TEMP_INSTALL="wget build-essential git debhelper autoconf python3-dev tcl8.6-dev tcl-dev python3-venv libz-dev dh-systemd openssl libssl-dev libboost-system-dev libboost-program-options-dev libboost-regex-dev libboost-filesystem-dev"
RUN apt-get update && apt-get install -y ${TEMP_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

RUN apt-get install -y chrpath

WORKDIR /tmp
RUN git clone https://github.com/flightaware/tcltls-rebuild.git
RUN cd tcltls-rebuild && ./prepare-build.sh buster
RUN cd tcltls-rebuild/package-buster && dpkg-buildpackage -b --no-sign
RUN cd tcltls-rebuild && dpkg -i tcl-tls_*.deb

WORKDIR /tmp
RUN git clone https://github.com/flightaware/piaware_builder.git
RUN cd piaware_builder && ./sensible-build.sh buster
RUN cd piaware_builder/package-buster && dpkg-buildpackage -b --no-sign

FROM base AS release

COPY --from=buildstep /tmp/tcltls-rebuild/tcl-tls_*.deb /tmp/
COPY --from=buildstep /tmp/piaware_builder/piaware_*.deb /tmp/

WORKDIR /tmp
RUN dpkg -i tcl-tls_*.deb
RUN dpkg -i piaware_*.deb

COPY start.sh /
RUN chmod +x /start.sh

ENTRYPOINT [ "/usr/bin/tini", "--", "/start.sh" ]