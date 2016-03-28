#! /bin/bash
cd /opt/bosch-bme280 || exit 1
. etc/record.conf || exit 2
mkdir -p logs/$ID || exit 3
echo "$ID -> $DST"
sudo i2cdetect -y 1
sudo python bin/bosch-bme280.py >> logs/$ID/$(date +%y%m%d).log
rsync -avz logs/ $DST:$PROJECT_PATH
