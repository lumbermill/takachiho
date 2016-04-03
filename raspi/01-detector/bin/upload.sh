#!/bin/sh
LOCK=/tmp/upload.lock
echo -n "start at "
date

trap "echo 'Aborting..'; rm $LOCK" 1 2 3 15

if [ -f $LOCK ]; then
# It doesn't work on crontab.
# if [ $$ -ne $(pgrep -fo "$0") ]; then
  echo "Lock file($LOCK) remains. Abort."
  exit 1
fi
touch $LOCK

rsync -avz /opt/lmlab.net/01-detector/storage/picture/ lmuser@sakura16:/opt/webcamlogs/raspi1/

echo -n "end at "
date
rm $LOCK
