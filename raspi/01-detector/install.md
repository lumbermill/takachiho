## 設定 ##
下記のディレクトリにこのフォルダをコピーします。  

```
rsync -avz ./ pi@id:/opt/lmlab.net/01-detector
```

`/etc/rc.local`に下記を追加します。PROJECT_PATHは任意に設定してください。
```
PROJECT_PATH=/opt/lmlab.net/01-detector
python ${PROJECT_PATH}/01-detector/bin/slack.py  
python ${PROJECT_PATH}/01-detector/bin/start_rec.py
```

ファイルを外部に定期送信する場合は、`upload.sh`を参考にしてください（現在の値は環境に依存します）。
`crontab -e`コマンドを実行し、下記を追加します。
```
*/5 * * * * /opt/lmlab.net/01-detector/bin/disk_management.py
*/1 * * * * /bin/sh /opt/lmlab.net/01-detector/bin/upload.sh &>> /tmp/upload.log
```

公開鍵をsakura15に登録します。


## ホスト名の変更 ##
slack通知をする場合、ホスト名を変更しておくと便利です。
```bash
sudo vi /etc/hostname

raspberrypi #ここを任意の名前に変更します。
```
```bash
sudo vi /etc/hosts


127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback
fe00::0         ip6-localnet
ff00::0         ip6-mcastprefix
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters

127.0.1.1       raspberrypi  #ここを任意の名前に変更します。
```

## raspberry pi 無線LAN接続設定 ##
まず、無線LANの設定をします。
```bash
sudo vi /etc/wpa_supplicant/wpa_supplicant.conf

# 下記を追加
network={
  ssid="your-ssid"
  key_mgmt=WPA-PSK
  psk="your-pass"
}
```

下記で無線LANをネットワークにつなぐことができます。
```bash
wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf
```

追記:無線LANの機器を物理的に再接続すると繋がることが判明しました。
