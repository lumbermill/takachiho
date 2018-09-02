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

