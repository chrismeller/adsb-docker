FROM debian:buster-slim as base
LABEL maintainer="https://github.com/chrismeller"

ENV ADSB_EXCHANGE_SITENAME=
ENV ADSB_EXCHANGE_UUID=
ENV RECEIVER_HOST=readsb
ENV RECEIVER_PORT=30005

ARG PERM_INSTALL="tini gettext-base netcat python3-dev"
RUN apt-get update && apt-get install -y ${PERM_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

FROM base AS buildstep

# the rest of the build process is based on the install script: https://github.com/adsbxchange/adsb-exchange/blob/master/update.sh#L100
ARG TEMP_INSTALL="git build-essential debhelper curl socat python3-venv libncurses5-dev netcat python zlib1g zlib1g-dev"
RUN apt-get update && apt-get install -y ${TEMP_INSTALL} && apt-get clean && apt-get autoclean && apt-get autoremove

WORKDIR /tmp
RUN git clone https://github.com/adsbxchange/mlat-client.git
RUN  cd mlat-client && dpkg-buildpackage -b --no-sign
# alternately, we could try and build the whole thing manually, but then we have to keep all of our build dependencies around
# RUN cd mlat-client && python3 setup.py build && python3 setup.py install

FROM base as release

# copy our build deb file from the build layer to the output layer
COPY --from=buildstep /tmp/mlat-client_*.deb /tmp/

RUN dpkg -i /tmp/mlat-client_*.deb

COPY start.sh /
RUN chmod +x /start.sh

ENTRYPOINT [ "/usr/bin/tini", "--", "/start.sh" ]