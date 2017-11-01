# RaspberryPiのセットアップ

## SDカードの準備
以下はRaspbianのSDカードを作成するためのコマンドのメモ書きです。
ディスクイメージは<a href="https://www.raspberrypi.org/downloads/raspbian/">Raspberry Pi公式サイト</a>で入手可能です。
デバイスの番号は環境ごとに違います。***絶対にこのままコピーして利用しないでください。*** `diskutil list` でデバイス番号を確認してください。

```
diskutil umountDisk /dev/disk2
sudo dd bs=1m if=2017-07-05-raspbian-jessie-lite.img of=/dev/rdisk2
```

## Raspbianの初期設定
必要な部分だけ実行してください。

```
sudo apt update
sudo apt upgrade
sudo rpi-update
sudo apt install ruby git
sudo raspi-config
  # ssh,camera,i2cを有効化
  # keyboard layoutとtimezoneをJapanに
vi /etc/wpa_supplicant/wpa_supplicant.conf
  # network={ssid="your-ssid" psk="your-pre-shared-key"}
mkdir bin
```

Wifiに接続済みでsshが有効化されていれば、以下のコマンドで他の端末から接続可能です。
初期パスワードは `raspberry` です。

```
ssh pi@raspberrypi.local
```

不特定のマシンが接続可能な環境に設置する場合は、パスワードを変更するか公開鍵認証など別の方法を使用してください。

- 必要なスクリプトは `curl -O` コマンドで取得して `$HOME/bin` に設置します。


## GPIO
ピンの配置については、以下のURLなどを参照してください。

<https://www.raspberrypi.org/documentation/usage/gpio-plus-and-raspi2/>
