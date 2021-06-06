#!/bin/bash

/usr/bin/pfclient \
    --connection_type=1 \
    --address=${RECEIVER_HOST} \
    --port=${RECEIVER_PORT} \
    --data_format=1 \
    --sharecode=${PLANEFINDER_SHARECODE} \
    --lat=${LAT} \
    --lon=${LON} \
    --pid_file=/run/pfclient.pid \
    --config_path=/config/pfclient-config.json \
    --log_path=/dev/stdout