# L05A

## 履歴
- 2016.02.25 USBハブ経由ならつながるが、肝心の単体での接続確立ができない。設定詳細はURLを参照。
- 2016.03.03 ハブ無し、モニターなしの状態での接続に成功。手順をまとめた。
## 参考URL
http://www.lumber-mill.co.jp/notes/tips/160225_raspi.html
http://lte.so-net.ne.jp/sim/0sim/
http://qiita.com/hiroyasu55/items/e0ad9d04a9d8feb5c654

#Raspberry Pi L-05A設定手順
##ディスプレイ・キーボード・マウスを接続して設定 (Wifi設定後はsshから設定してもよい。)
- Wifi（SSID/PASS）の設定（設定作業メンテナンス用）
- 時刻の設定
 - Menu>Preference>Raspberry Pi Configurationの画面からLocalisation>Set TimezoneでAsia/Tokyoを選択
- 起動設定
 - Menu>Preference>Raspberry Pi Configurationの画面からSystem>BootでTo CLIを選択
 - Menu>Preference>Raspberry Pi Configurationの画面からSystem>Auto LoginでLogin as user 'pi'のチェックを外す
- 再起動する
- パッケージ最新化(コンソールより)
```
$ sudo apt-get update
$ sudo apt-get upgrade ＃2時間位かかるかも。。。
```
- ファームウェア最新化(コンソールより)
```
$ sudo rpi-update
　　　:
$ sudo reboot #再起動して新ファームを有効化
```
- L-05Aで通信するために必要なパッケージをインストール
```
$ sudo apt-get install -y eject wvdial dnsutils
```
- /etc/wvdial.conf を編集
```
$ sudo vi /etc/wvdial.conf
[Dialer Defaults]
Phone = *99***1#
Username = nuro
Password = nuro
New PPPD = yes
Modem = /dev/ttyACM0
APN = so-net.jp
Init1 = ATZ
# Init2 = ATQ0 V1 E1 S0=0 &C1 &D2
# Init3 = AT+CGDCONT=1,"IP","so-net.jp"
Dial Attempts = 3
Modem Type = Analog Modem
Dial Command = ATD
Stupid Mode = yes
Baud = 460800
New PPPD = yes
ISDN = 0
Carrier Check = no
Auto DNS = 1
Check Def Route = 1
```

- L-05AのPPP接続スクリプトを作成
  追記) 下記のファイルをbinフォルダに入れました。それを使ってください。
```
$ vi /home/pi/bin/L-05A_start.sh
#!/bin/sh
/usr/bin/test -e /dev/sr0 && /usr/bin/eject  #アンマウント
/usr/bin/wvdial &               #接続
sleep 10                            #10秒待つ
if [ -z $(pgrep wvdial) ]; then
    /usr/bin/wvdial &          #接続できていなかった時はリトライ
fi
```
- 接続確認
```
$ sudo /home/pi/bin/L-05A_start.sh
```
  - L-05AのWifiマークのランプが緑→青に変化すれば成功
  - 念のためpsでも確認
```
$ ps af
  PID TTY      STAT   TIME COMMAND
  896 pts/0    Ss     0:01 -bash
 1691 pts/0    R+     0:00  \_ ps af
 1595 pts/0    S      0:00 /usr/bin/wvdial #　←　wvdialが起動しているはず
 1597 pts/0    S      0:00  \_ /usr/sbin/pppd 460800 modem crtscts defaultroute usehostname -detach user nuro noipdefault call wvdial usepeer
  511 ?        Ss+    0:00 /sbin/agetty --keep-baud 115200 38400 9600 ttyAMA0 vt102
  507 tty1     Ss     0:00 /bin/login --
  789 tty1     S+     0:01  \_ -bash
```
- Raspberry Piの起動時に接続スクリプトが実行されるようにする
```
$ sudo vi /etc/rc.local
#!/bin/sh -e
　　：
（途中省略）
　　：
# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
    printf "My IP address is %s\n" "$_IP"
fi
/home/pi/L-05A_start.sh &  # ← ここを追加
exit 0
```
- 一旦シャットダウンして、再度電源ONしてL-05Aが接続できることを確認
- シリアルコンソールの設定（別ファイル参照）をしてシャットダウン後、ハブを取り外し、L-05AのみをUSBポートに挿して起動
- シリアルコンソールからログインし、ping等で接続を確認


## L-05Aの状態を定期的にチェック
L-05Aの接続が途切れることがある。  
1度接続が切れると自動で再接続してくれないため、ホーム（/home/pi）にbin/フォルダを設置後、crontabで定期的に確認する。
```bash
$ crontab -e

*/10 * * * * $PROJECT_PATH/03-l05a/bin/record.sh
1,11,21,31,41,51 * * * * bash /home/pi/bin/L-05A_restart.sh
```
