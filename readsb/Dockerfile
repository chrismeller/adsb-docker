FROM debian:buster-slim as base
LABEL maintainer="https://github.com/chrismeller"

EXPOSE 30001 30002 30003 30004 30005 30102 30104 30105 30106 8080

ENV READSB_DEVICE=0
ENV READSB_GAIN=-10
ENV READSB_PPM=0
ENV READSB_MAX_RANGE=450

ARG PERM_INSTALL="tini lighttpd gettext-base libusb-1.0-0 libbladerf1 libhackrf0 liblimesuite18.06-1 librtlsdr0 rtl-sdr libncurses6"
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

COPY --from=buildstep /tmp/readsb/debian/lighttpd* /etc/lighttpd/conf-available

RUN dpkg -i /tmp/readsb_*.deb

COPY readsb-gain.sh /usr/local/bin/readsb-gain
COPY set-location.sh /usr/local/bin/set-location
COPY defaults /etc/default/readsb
COPY start.sh /

RUN chmod +x /start.sh
RUN chmod +x /usr/local/bin/readsb-gain
RUN chmod +x /usr/local/bin/set-location

ENTRYPOINT [ "/usr/bin/tini", "--", "/start.sh" ]