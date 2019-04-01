# RaspberryPiをキオスク端末にする
02-360Displayの続編です。
Raspbian Desktopをインストールした状態から開始します。まずは不要なパッケージを消して、必要なパッケージの準備をします。
日本語フォントはnotoを入れていますが、好みで変更してください。

```
sudo apt remove -y wolfram-engine sonic-pi scratch scratch2 bluej libreoffice idle
sudo apt update
sudo apt upgrade -y
sudo apt install -y unclutter fonts-noto xdotool
```

`.config/lxsession/LXDE-pi/autostart` を下記の内容で書き換えます。
上2行でディスプレイが省エネモードに入らないように設定し、unclutterでマウスカーソルを隠しています。
使用したのはchromiumブラウザのkioskモードです。

```
@xset s off
@xset -dpms
@unclutter
@chromium-browser --kiosk --incognito https://places.lmlab.net/ensemble/signage?size=720p
```

crontabを以下のように設定します。この例では1日に1回画面をリロードしています。

```
1 0 * * * export DISPLAY=":0" && xdotool key F5
```

すべての設定が終わったら、端末を再起動します。

```
sudo reboot
```

## その他のTips
### Pimoroni 公式7インチディスプレイを使用する
そのままだと上下逆に表示されてしまうので、 `/boot/config.txt` に以下の設定を追加します。

```
lcd_rotate=2
```

- 参考 [Pimoroni 7インチ タッチ・スクリーン フレームの取り付け・設定方法](https://raspberry-pi.ksyic.com/page/page/pgp.id/5)

### ブラウザを強制終了する
フルスクリーンでマウスカーソルも消えてしまっているので、「Ctrl + Alt + F2」などで
別のコンソールを立ち上げてから、以下のコマンドで強制停止します。（もっとマシな方法あるかも…）

```
killall chromium-browser
```

### ディスプレイ外周の余白を無くす
`raspi-config` を起動して、OverscanをDisableに設定し、再起動します。

```
$ sudo raspi-config
```

```
9 Advanced Options -> A2 Overscan
```

- 参考 [参考リンク](https://qiita.com/KaiShoya/items/5c6e6313d0b3842dfbee)

### 動画を再生する
chromium-browserの代わりにomxplayerを使うと動画を再生することが出来ます。
autostartを書き換えずに最後尾に以下を追加するのみです。

```
@omxplayer --refresh --loop -o both /home/pi/demo.mov
```
