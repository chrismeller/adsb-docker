FROM debian:buster-slim as base
LABEL maintainer="https://github.com/chrismeller"

ENV ADSB_EXCHANGE_UUID=
ENV RECEIVER_HOST=readsb
ENV RECEIVER_PORT=30005

ARG PERM_INSTALL="tini gettext-base libusb-1.0-0 libbladerf1 libhackrf0 liblimesuite18.06-1 librtlsdr0 rtl-sdr libncurses6"
RUN apt-get update && apt-get install -y ${PERM_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

FROM base AS buildstep

# the rest of the build process is based on the install script: https://github.com/wiedehopf/adsb-scripts/blob/master/readsb-install.sh
ARG TEMP_INSTALL="git build-essential debhelper libusb-1.0-0-dev librtlsdr-dev librtlsdr0 pkg-config dh-systemd zlib1g-dev zlib1g unzip libncurses5-dev"
RUN apt-get update && apt-get install -y ${TEMP_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

WORKDIR /tmp
RUN git clone https://github.com/wiedehopf/readsb.git
#RUN dpkg-buildpackage -b -Prtlsdr -ui -uc -us
RUN  cd readsb && dpkg-buildpackage -b --build-profiles=rtlsdr --no-sign
#RUN cd readsb && make -j2 AIRCRAFT_HASH_BITS=12

FROM base as release

# copy our build deb file from the build layer to the output layer
COPY --from=buildstep /tmp/readsb_*.deb /tmp/
#COPY --from=buildstep /tmp/readsb/readsb /usr/bin/readsb

RUN dpkg -i /tmp/readsb_*.deb

COPY start.sh /
RUN chmod +x /start.sh

ENTRYPOINT [ "/usr/bin/tini", "--", "/start.sh" ]