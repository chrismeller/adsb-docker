/usr/bin/piaware-config allow-auto-updates no
/usr/bin/piaware-config allow-manual-updates no
/usr/bin/piaware-config allow-mlat yes
/usr/bin/piaware-config mlat-results yes
/usr/bin/piaware-config mlat-results-format "beast,connect,${RECEIVER_HOST}:${RECEIVER_MLAT_PORT} beast,listen,30105 ext_basestation,listen,30106"
/usr/bin/piaware-config receiver-type other
/usr/bin/piaware-config receiver-host ${RECEIVER_HOST}
/usr/bin/piaware-config receiver-port ${RECEIVER_PORT}
/usr/bin/piaware-config feeder-id ${FLIGHTAWARE_FEEDER_ID}

# we don't support 978 right now
# /usr/bin/piaware-config uat-receiver-type other
# /usr/bin/piaware-config uat-receiver-host dump978-fa
# /usr/bin/piaware-config uat-receiver-port 30978

/usr/bin/piaware-config uat-receiver-type none

/usr/bin/piaware -plainlog