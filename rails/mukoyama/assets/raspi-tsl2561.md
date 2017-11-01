# RaspberryPi + tsl2561
Raspberry PiのGPIOに照度センサを接続する手順です。

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
- [tsl2561(照度センサ)](https://www.switch-science.com/catalog/2498/)

※商品の改廃によってリンク切れする場合があります。下記のサイトなどから同等品を探してください。

- [KSY](https://raspberry-pi.ksyic.com/)
- [Switch science](https://www.switch-science.com/)

## セットアップ
以下の手順でi2cを有効化します。

```
sudo gem install i2c
sudo raspi-config # Enable I2C
sudo i2cdetect -y 1
```


## 参考URL

- <https://github.com/iotfes/tsl2561-sensor>
- <https://gist.github.com/jvalencia80/b947bd23cf9b1025531bc41a81658d15>
