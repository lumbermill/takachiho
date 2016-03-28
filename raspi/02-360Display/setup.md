# raspberry pi ブラウザ全画面表示設定 #
epiphany-browserをインストールします。

<!-- libgcrypt11をwheezyリポジトリからインストールします。
```bash
sudo vi /etc/apt/source.list

#最下部に追加
deb http://mirrordirector.raspbian.org/raspbian/ wheezy main
``` -->

apt-getを更新します。  
unclutterをインストールすることで、マウスポインタを消せます。
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install epiphany-browser x11-xserver-utils xautomation unclutter
```

~/fullscreen.shを作成します。
```bash
vi ~/fullscreen.sh

# 下記を記入
sudo -u pi epiphany-browser -a -i --profile ~/.config http://360.lmlab.net --display=:0 &
sleep 15s;
xte "key F11" -x:0
```
下記のコマンドで、先ほど作ったshファイルに実行権限を付与します。
```
sudo chmod 755 /home/pi/fullscreen.sh
```

~/.config/lxsession/LXDE-pi/autostartを編集します。
すでに記載されているものは、削除、もしくはコメントアウトしてください。
```bash
sudo vi ~/.config/lxsession/LXDE-pi/autostart

# 下記に変更
@xset s off
@xset -dpms
@xset s noblank
@/home/pi/fullscreen.sh
```

１時間に１回ページをリロードするよう、crontabに設定します。
```bash
crontab -e

# 下記を追加
0 */1 * * * xte -x :0 "key F5"
```

画面が逆さまになる場合は、/boot/config.txtに以下を追加します（RaspberryPi財団の公式ディスプレイは逆さまになります）。
```
lcd_rotate=2
```

### 参考サイト ###
下記のサイトに他のブラウザでの設定方法も記載されています。
[Create Raspberry Pi Kiosk on Raspbian Debian Wheezy](https://github.com/elalemanyo/raspberry-pi-kiosk-screen)

# 日本語対応 #

mozcインストール
googleが作った、日本語入力システムです。
```
sudo apt-get install ibus-mozc
```

最新のraspberry piではデフォルトで日本語に対応していないため、日本語フォントをインストールします。
日本語フォントインストール
```
sudo apt-get install ttf-kochi-gothic ttf-kochi-mincho fonts-takao fonts-vlgothic fonts-ipafont xfonts-intl-japanese xfonts-intl-japanese-big xfonts-kaname
```
