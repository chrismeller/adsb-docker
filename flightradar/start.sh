#!/bin/bash

# Write out our config file
cat /etc/fr24feed.ini.tpl | envsubst > /etc/fr24feed.ini
chmod a+rw /etc/fr24feed.ini

/usr/bin/fr24feed