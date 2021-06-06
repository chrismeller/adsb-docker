#!/bin/bash

/usr/bin/mlat-client \
    --input-type beast \
    --input-connect $RECEIVER_HOST:$RECEIVER_PORT \
    --server feed.adsbexchange.com:31090 \
    --user $ADSB_EXCHANGE_SITENAME \
    --lat $LAT \
    --lon $LON \
    --alt $ALT \
    --results beast,connect,readsb:30104 \
    --results beast,connect,adsbexchange-feed:30154 \
    --results basestation,listen,31003