# save the UUID to the file it's expected in
echo ${ADSB_EXCHANGE_UUID} > /boot/adsbx-uuid

while sleep 30
do
    echo "Connected to feeds.adsbexchange.com:30005"
    echo "Local connection: ${RECEIVER_HOST}:${RECEIVER_PORT}"
    echo "Lat/Lon: ${LAT}/${LON}"
    /usr/bin/readsb \
        --db-file=none \
        --max-range 450 \
        --net-beast-reduce-interval 0.5 \
        --net-connector feed.adsbexchange.com,30005,beast_reduce_out \
        --net-connector ${RECEIVER_HOST},${RECEIVER_PORT},beast_in \
        --net-ro-interval 0.5 \
        --net-ri-port 0 \
        --net-ro-port 0 \
        --net-sbs-port 0 \
        --net-bi-port 30154 \
        --net-bo-port 0 \
        --net-only \
        --json-location-accuracy 2 \
        --write-json /run/adsbexchange-feed \
        --lat "$LAT" \
        --lon "$LON" \
        --quiet
    echo "Disconnected"
done