# Raspberry Pi


## 7inch touch screen

``` /boot/config.txt
lcd_rotate=2
```

https://raspberry-pi.ksyic.com/page/page/pgp.id/5

## Enviro pHat

```
sudo rasip-config  # Enable I2C interface.
sudo apt-get install pimoroni
pimoroni-dashboard
sudo apt-get install python3-envirophat
```

```
from envirophat import weather
print(weather.temperature())
```

## Sparkfun Qwiic

```
sudo pip3 install sparkfun-qwiic
```

```
import qwiic_bme280
qbme = qwiic_bme280.QwiicBme280()
qbme.begin()
print(qbme.temperature_celsius)
print(qbme.humidity)
print(qbme.pressure)
```

- https://www.sparkfun.com/news/2958
- https://github.com/sparkfun/Qwiic_Py


## Misc

```
vcgencmd measure_temp
```

https://qiita.com/kouhe1/items/5f3f0e6fdb55e7164deb
