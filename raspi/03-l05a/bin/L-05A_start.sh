#!/bin/sh
/usr/bin/test -e /dev/sr0 && /usr/bin/eject
/usr/bin/wvdial &
sleep 10
if [ -z $(pgrep wvdial) ]; then
  /usr/bin/wvdial &
fi