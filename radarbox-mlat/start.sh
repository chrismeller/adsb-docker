#!/bin/bash

site_name() {
    SN=$(grep -E "^sn=.*$" /etc/rbfeeder.ini)
    SITE_NAME=$(echo "$SN" | cut -d "=" -f 2 | tr -d " ")
}

site_name
while [[ -z "$SITE_NAME" ]]; do
    echo "Delaying mlat-client startup until we receive the station name..."
    sleep 1
    site_name
done

echo "MLAT Site Name ${SITE_NAME}"

# start mlat and put it in the background
/usr/bin/mlat-client \
    --input-type auto \
    --input-connect ${RECEIVER_HOST}:${RECEIVER_PORT} \
    --lat "${LAT}" \
    --lon "${LON}" \
    --alt "${ALT}" \
    --user "${SITE_NAME}" \
    --server mlat1.rb24.com:40900