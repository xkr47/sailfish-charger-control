#!/bin/bash

CHARGER_CONTROL_GID=charger-control

for i in \
  /sys/class/power_supply/usb/charger_disable \
  /sys/module/pm8921_charger/parameters/disabled \
  ; do
    chgrp $CHARGER_CONTROL_GID $i
    chmod g+w $i
done
