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
Wifiに接続して、ソフトウェアのアップデートと導入を行う手順です。環境に応じて、必要な部分だけ実行してください。

```
wpa_passphrase "your-ssid" "your-pre-shared-key" >> /etc/wpa_supplicant/wpa_supplicant.conf
vi /etc/wpa_supplicant/wpa_supplicant.conf
  # 暗号化前のパスワードを隠したい場合、個別にコメント行を消してください
  # 接続を試行する場合: `service wpa_supplicant restart`
raspi-config
  # ssh,camera,i2cを有効化
  # keyboard layoutとtimezoneをJapanに
reboot
apt update
apt -y upgrade
apt install ruby git
reboot
```

piユーザのHOMEにbinディレクトリを作っておきます。
```
mkdir bin
```

Wifiに接続済みでsshが有効化されていれば、以下のコマンドで他の端末から接続可能です。
初期パスワードは `raspberry` です。

```
ssh pi@raspberrypi.local
```

不特定のマシンが接続可能な環境に設置する場合は、必ずパスワードを変更するか公開鍵認証など別の安全な方法を使用してください。

複数台のマシンを扱っていると、sshでの接続時に警告( `REMOTE HOST IDENTIFICATION HAS CHANGED! ` )が出ることがあります。
その場合、下記のコマンドを使用するなどしてknown_hostsから既存のホスト情報を削除してください。

```
ssh-keygen -R raspberrypi.local
```

- 必要なスクリプトは `curl -O` や `git` コマンドで取得して `$HOME/bin` に設置します。

## GPIO
ピンの配置については、以下のURLなどを参照してください。

<img src="/physical-pin-numbers.png" class="img img-responsive"/>

<https://www.raspberrypi.org/documentation/usage/gpio-plus-and-raspi2/>
