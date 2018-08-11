# RaspberryPi + am2320
Raspberry PiのGPIOに温湿度センサ(AM2320)を接続する手順です。

## 部品リスト
- RaspberryPi
  - 本体
  - ケース
  - MicroUSBケーブル
  - USB ACアダプタ
  - MicroSD 8GB(Raspbian)
  - ジャンパ線(オス - メス) 4本
- [ブレッドボード](https://www.switch-science.com/catalog/2282/)
- [ピンヘッダ](https://www.switch-science.com/catalog/92/)
- [AM2320](http://akizukidenshi.com/catalog/g/gM-08663/)

※商品の改廃によってリンク切れする場合があります。下記のサイトなどから同等品を探してください。

- [KSY](https://raspberry-pi.ksyic.com/)
- [Switch science](https://www.switch-science.com/)

## セットアップ
以下の手順でi2cを有効化します。

```
sudo raspi-config # Enable I2C
sudo apt-get install -y python-smbus
sudo i2cdetect -y 1 # 5c
```

以下の手順でセンサを接続します。網目を手前に置いた時に左端がVDDです。
右辺の括弧内の数値がGPIOのPhysical number(通し番号)です。

```
VDD -> 3.3v(1)
SDA -> 2(3)
GND - > GND(6)
SCL -> 3(5)
```

ここが少しトリッキー（筆者にとって意味が分からない、の意）です。
この設定を追記した後、 `reboot` が必要です。

``` /etc/modprobe.d/i2c.conf
options i2c_bcm2708 combined=1
```


## 参考URL

- <http://wizqro.net/%E6%B8%A9%E6%B9%BF%E5%BA%A6%E3%82%BB%E3%83%B3%E3%82%B5am2320%E3%82%92raspberry-pi-3%E3%81%A7%E4%BD%BF%E7%94%A8%E3%81%99%E3%82%8B/>
