# RaspberryPi + bme280
<h3>必要なもの</h3>
<ul>
  <li>Raspberry Pi 3</li>
  <li>BME280温度センサ</li>
  <li>インターネット接続</li>
</ul>
<p>
</p>
<h3>センサの有効化</h3>
<p>
  Raspberry Piには最新のRaspbianがインストールされ、BME280温度センサがGPIOに接続されていることを前提とします。
  結線方法については<a href="https://itunes.apple.com/jp/book/raspberrypi-ru-men/id1035076658?mt=11&ign-mpt=uo%3D4">拙著・RaspberriPi入門</a>や下記のURL(Qiita)を参照してください。</p>
<p>以下の手順でセンサを有効化します。</p>
<pre>
sudo rpi-update
sudo raspi-config Enable I2C

cat /etc/modules
# 下記が書いてあることを確認します。書いてなければ追記してください。
i2c-dev

sudo apt-get install python-smbus

i2cdetect -y 1
# 今回は76で設定しています。
</pre>
<p>うまくいかない場合は、以下のURL等も参考にしてください。</p>
<ul>
  <li><a href="http://qiita.com/masato/items/16bf8b17ee4881179462#bme280">http://qiita.com/masato/items/16bf8b17ee4881179462#bme280</a></li>
  <li><a href="https://github.com/lumbermill/takachiho/tree/master/raspi/04-bosch">https://github.com/lumbermill/takachiho/tree/master/raspi/04-bosch</a></li>
</ul>
