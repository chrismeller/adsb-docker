#!/bin/bash
source /etc/default/readsb

# start lighthttpd and put it in the background
#/usr/sbin/lighthttpd -D -f /etc/lighthttpd/lighthttpd.conf &

# start readsb
# $RECEIVER_OPTIONS is --gain, for compatability with some scripts like auto-gain
/usr/bin/readsb \
    --device-type rtlsdr \
    --device "$READSB_DEVICE" \
    --lat "$LAT" \
    --lon "$LON" \
    --fix \
    --ppm "$READSB_PPM" \
    --max-range "$READSB_MAX_RANGE" \
    --modeac-auto \
    --net \
    --net-heartbeat 60 \
    --net-ro-size 1000 \
    --net-ro-interval 1 \
    --net-ri-port 0 \
    --net-ro-port 30002,30102 \
    --net-sbs-port 30003 \
    --net-bi-port 30004,30104 \
    --net-bo-port 30005,30105 \
    --raw \
    --json-location-accuracy 2 \
    --write-json /run/readsb \
    --quiet \
    $RECEIVER_OPTIONS


# /usr/bin/readsb \
#     --device-type rtlsdr \
#     --device "$READSB_DEVICE" \         # Index or serial of the device to read from
#     --lat "$LAT" \
#     --lon "$LON" \
#     --fix \                             # Enable CRC single-bit error correction
#     --gain "$RECEIVER_OPTIONS" \        # Set the gain. Default: max, -10 for auto-gain
#     --ppm "$READSB_PPM" \               # Oscillator frequency correction in PPM
#     --max-range "$READSB_MAX_RANGE" \   # Max range for position decoding (in nm)
#     --net \                             # Enable networking
#     --net-heartbeat 60 \                # TCP heartbeat rate (seconds)
#     --net-ro-size 1000 \                # TCP output flush size
#     --net-ro-interval 1 \               # TCP output flush interval (seconds)
#     --net-ri-port 0 \                   # TCP raw input listen ports
#     --net-ro-port 30002,30102 \         # TCP raw output listen ports
#     --net-sbs-port 30003 \              # TCP BaseStation output listen ports
#     --net-bi-port 30004,30104 \         # TCP Beast input listen ports
#     --net-bo-port 30005,30105 \         # TCP Beast output listen ports
#     --raw \                             # Only show message hex values
#     --json-location-accuracy 2 \        # Accuracy of receiver location in json metadata - 0=none, 1=approx, 2=exact
#     --write-json /run/readsb \          # Duh
#     --quiet