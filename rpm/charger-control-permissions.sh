#!/bin/bash

CHARGER_CONTROL_GROUP=charger-control

set -e

for i in \
  /sys/class/power_supply/usb/charger_disable \
  /sys/module/pm8921_charger/parameters/disabled \
  ; do
    if [ -e $i ]; then
      chgrp $CHARGER_CONTROL_GROUP $i
      chmod 464 $i
    fi
done
