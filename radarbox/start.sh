#!/bin/bash

# Write out our config file
cat /etc/rbfeeder.ini.tpl | envsubst > /etc/rbfeeder.ini
chmod a+rw /etc/rbfeeder.ini

# start the feeder and put it in the background
/usr/bin/rbfeeder &

# Parse out the site name from our RB config
SN=$(grep -E "^sn=.*$" /etc/rbfeeder.ini)
SITE_NAME=$(echo "$SN" | cut -d "=" -f 2 | tr -d " ")

if [[ -z "$SITE_NAME" ]]; then
    echo "Delaying mlat-client startup until we receive the station name..."
    sleep 30
fi

# Parse it again
SN=$(grep -E "^sn=.*$" /etc/rbfeeder.ini)
SITE_NAME=$(echo "$SN" | cut -d "=" -f 2 | tr -d " ")

echo "MLAT Site Name ${SITE_NAME}"

# start mlat and put it in the background
/usr/bin/mlat-client \
    --input-type beast \
    --input-connect "${RECEIVER_HOST}:${RECEIVER_PORT}" \
    --results beast,listen,30105 \
    --lat "${LAT}" \
    --lon "${LON}" \
    --alt "${ALT}" \
    --user "${SITE_NAME}" \
    --server mlat1.rb24.com:40900