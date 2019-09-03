# 11-earthquake
Raspi + Pimoroni で地震計

---
2019.09.03 code4miyazakiのm-tsunami-iosプロジェクトにコードを移管しました。
https://github.com/codeformiyazaki/m-tsunami-ios
---

Installation:
```
sudo rasip-config  # Enable I2C interface.
sudo apt-get install pimoroni
pimoroni-dashboard
sudo apt-get install python3-envirophat
```

How to use the library:
```
from envirophat import weather
print(weather.temperature())
```

## リンク

[岡村土研 南海地震に備える(揺れの長さ)](http://sc1.cc.kochi-u.ac.jp/~mako-ok/nankai/11duration.html)
