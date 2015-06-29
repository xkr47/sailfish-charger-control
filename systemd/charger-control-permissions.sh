#!/bin/bash

CHARGER_CONTROL_GROUP=charger-control
CHARGER_CONTROL_STATEFILE=/tmp/charger-control.state

set -ex

echo 2 > $CHARGER_CONTROL_STATEFILE

for i in \
  /sys/class/power_supply/usb/charger_disable \
  /sys/module/pm8921_charger/parameters/disabled \
  $CHARGER_CONTROL_STATEFILE \
  ; do
    if [ -e $i ]; then
      chgrp $CHARGER_CONTROL_GROUP $i
      chmod 464 $i
    fi
done
