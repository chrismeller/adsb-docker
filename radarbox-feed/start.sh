#!/bin/bash

# Write out our config file
cat /etc/rbfeeder.ini.tpl | envsubst > /etc/rbfeeder.ini
chmod a+rw /etc/rbfeeder.ini

# start the feeder
/usr/bin/rbfeeder