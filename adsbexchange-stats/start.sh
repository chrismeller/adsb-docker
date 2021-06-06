#!/bin/bash

# This file is a very barebones version of the real json-status: https://github.com/adsbxchange/adsbexchange-stats/blob/master/json-status

JSON_DIR="/run/adsbexchange-feed"

# the file we actually parse
JSON_FILE="${JSON_DIR}/aircraft.json"

TEMP_DIR="/run/adsbexchange-stats"
TMP_FILE="${TEMP_DIR}/tmp.json"
NEW_FILE="${TEMP_DIR}/new.json"

# how long we'll wait between uploads (seconds)
WAIT_TIME=60

# the timeout for our curl request (seconds)
MAX_CURL_TIME=10

# how many seconds should we wait since the file was updated to send it?
NEXT_JSON_READ=1

# When was the json file last updated (in unix timestamp format)
JSON_LAST_UPDATE=$(stat --printf="%Y" $JSON_FILE)

# If this is too old, we'll bail
NOW=$(date +%s)
DIFF=$(( $NOW - $JSON_LAST_UPDATE ))
if [ $DIFF -gt 60 ]; then
    echo "Warning: ${JSON_FILE} seems old, are you using the right path?"
fi

while true; do
    JSON_LAST_UPDATE=$(stat --printf="%Y" $JSON_FILE)

    # If the file isn't old enough yet, we'll just wait
    if [ $JSON_LAST_UPDATE -lt $NEXT_JSON_READ ]; then
        echo "File is not old enough, sleeping..."
        sleep 1
        continue
    fi

    echo "Starting..."

    # Now that it is old enough, set the next timestamp we'll update at
    NEXT_JSON_READ=$(( $JSON_LAST_UPDATE + $WAIT_TIME ))
    
    echo "It is ${NOW}. Next read will be at ${NEXT_JSON_READ}"

    # we want to force the loop to take at least WAIT_TIME seconds
    # so we'll start sleeping and then wait for any excess at the end if uploading takes less than WAIT_TIME
    sleep $WAIT_TIME &

    # copy the file we're reading so we're sure it doesn't change mid-read
    cp $JSON_FILE $TMP_FILE

    UUID=$ADSB_EXCHANGE_UUID
    STATUS=""

    # generate the new file with the parts we need from temp file
    cat $TMP_FILE | jq -c \
        --arg STATUS "$STATUS" \
        --arg UUID "$UUID" \
        ' .
            | ."uuid"=$UUID
            | ."v"=$STATUS
            | ."rssi"=(if (.aircraft | length <= 0) then 0 else ([.aircraft[].rssi] | select(. >=0) | add / length | floor) end)
            | ."rssi-min"=(if (.aircraft | length <= 0) then 0 else ([.aircraft[].rssi] | select(. >=0) | min | floor) end)
            | ."rssi-max"=(if (.aircraft | length <= 0) then 0 else ([.aircraft[].rssi] | select(. >=0) | max | floor) end)
        ' > $NEW_FILE

        cat $NEW_FILE

        echo "Uploading..."

        # do the actual upload
        cat $NEW_FILE | gzip | curl \
            -m $MAX_CURL_TIME \
            --silent \
            --show-error \
            -X POST \
            -H "adsbx-uuid: ${ADSB_EXCHANGE_UUID}" \
            -H "Content-Encoding: gzip" \
            --data-binary @- $ADSB_EXCHANGE_STATS_ENDPOINT

        echo "Done"

    # wait for the earlier sleep to make sure we always wait WAIT_TIME seconds, even if the curl request didn't take that long
    wait

    # clean up our temp files
    rm -f $TMP_FILE $NEW_FILE

    echo "Done"
done