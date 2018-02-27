# インストール手順 #

```bash
$ sudo raspi-config Enable I2C

$ cat /etc/modules
# 下記が書いてあることを確認する。書いてなければ追加
i2c-dev

$ sudo apt-get install python-smbus

$ i2cdetect -y 1
# 今回は76で設定しています。
# 下記を参考にしてください。
# http://qiita.com/masato/items/16bf8b17ee4881179462#bme280
```

下記はテストコードです。  
pythonのコードを実行した時IOErrorが出ますが、`sudo i2cdetect -y 1`実行後すぐにpythonを実行すれば、回避できます。  

```
$ wget https://raw.githubusercontent.com/SWITCHSCIENCE/BME280/master/Python27/bme280_sample.py
$ sudo i2cdetect -y 1
$ sudo python bme280_sample.py
temp : 26.84  ℃
pressure :  974.36 hPa
hum :  72.45 ％
```

rsyncでraspiにプログラムを送信します。  
送信後、record.confを移動します。

```
$ mv /opt/bosch-bme280/bin/record.conf /opt/bosch-bme280/etc/
```

10分おきにrecord.shを実行するようcrontabを設定します。

```
$ crontab -e
*/10 * * * * /opt/bosch-bme280/bin/record.sh
```

record.confを作成します。record.shを実行するのに必要なファイルです。  

```
$ vi ./record.conf

export ID=PROJECT_NAME
export DST=HOST_NAME
```
