#!/bin/bash

# Write out our config file
cat /var/lib/openskyd/conf.d/opensky.conf.tpl | envsubst > /var/lib/openskyd/conf.d/10-opensky.conf
chmod a+rw /var/lib/openskyd/conf.d/opensky.conf

/usr/bin/openskyd-dump1090