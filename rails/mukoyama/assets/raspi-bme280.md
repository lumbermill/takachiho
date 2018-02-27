# RaspberryPi + bme280
## 部品リスト
<ul>
  <li>Raspberry Pi 3</li>
  <li>BME280温度センサ</li>
  <li>インターネット接続</li>
</ul>

## センサの有効化
Raspberry Piには最新のRaspbianがインストールされ、BME280温度センサがGPIOに接続されていることを前提とします。
結線方法については<a href="https://itunes.apple.com/jp/book/raspberrypi-ru-men/id1035076658?mt=11&ign-mpt=uo%3D4">拙著・RaspberriPi入門</a>や下記のURL(Qiita)なども参照してください。

```
SDI -> 2
SCK -> 3
GND,SDO -> GND
Vio,CSB -> 3.3v
```

以下の手順でセンサを有効化します。

```
sudo raspi-config Enable I2C
```

`/etc/modules` に下記行があることを確認します。書いてなければ追記してください。

```
i2c-dev
```

```
sudo apt-get install python-smbus

i2cdetect -y 1  # 76
```

うまくいかない場合は、以下のURL等も参考にしてください。

- <http://qiita.com/masato/items/16bf8b17ee4881179462#bme280">http://qiita.com/masato/items/16bf8b17ee4881179462#bme280>
- <https://github.com/lumbermill/takachiho/tree/master/raspi/04-bosch">https://github.com/lumbermill/takachiho/tree/master/raspi/04-bosch>
