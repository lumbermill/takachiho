# Raspberry PiとMacをシリアルコンソールで接続する手順
- Raspberry PiのGPIOピンはシリアル通信に使用できるため、シリアルコンソールをつかってログインできる。

## Raspberry Piのログインシェルの設定
 - 事前にSSH等で接続して設定しておく。（設定無しでシリアル接続するとエディタの表示が崩れるため）
 - シリアルコンソールで接続しても表示が正しくなるように、シェル側で設定が必要。以下の設定を~/.profileに書いておく(一番下が無難,sttyの数値は接続する側の環境に合わせて設定しておく)
```
export TERM=xterm
stty rows 45 columns 150
```

## SparkFun FTDI Basic Breakout - 5Vを使用して接続
  - 他にもGPIOを使用した接続用の機器は存在するが今回は手持ちのものを使用した。
  - アダプタを接続する前にRaspberry Piの電源を入れておく
  - 参考
   - FT232RL搭載小型USB-シリアルアダプタ 5V - スイッチサイエンス: https://www.switch-science.com/catalog/342/
   - パソコンとシリアル通信する方法: http://www.hiramine.com/physicalcomputing/raspberrypi/serial_howtoconnectpc.html

| USB・シリアル変換ケーブル側    | Raspberry Pi側 |
|--------------------------------|----------------|
| ピン名称                       | ピン番号       |
| GND                            | GND            |
| CTS                            | 無接続         |
| VCC                            | 無接続(USBバスパワーを使う場合は5V)|
| RXI                            | GPIO15 (RXD)   |
| TXD                            | GPIO14 (TXD)   |
| RTS                            | 無接続         |

## Macから接続するためにminicomを使用
  - homebrewでインストール
  - minicom -s で設定
    - 「Screen and keyboadのCommand key」を ^Q(Ctrl+Q) とする
    - 「Serial Port SettingsのSerial Device」 を /dev/tty.usbserial-A6007CIj とする。（デバイスファイル名はアダプタの種類によって異なる。tty.usbserail* となることが多いようである）
    - 「Exit」を選択すると接続。
    - 何も出てこない時は数秒待ってEnterキーを何回か叩いてみる。
    - 接続するとログインプロンプトが出てくるはず。普通にユーザ名・パスワードを入力するとログインできる。
   - 通信を切断する場合はCtrl+qを押してからxを押す（ログアウトしなくても切断できてしまう。その場合次の接続時には認証無しで接続できてしまうのでセキュリティを考慮すると必ずログアウトしてから切断するのが無難。）
   - 参考：
     - Mac OS X (Snow Leopard)でSerial Console (シリアルコンソール) | ytsuboi's blog: http://www.ytsuboi.org/wp/archives/1219
     - ねこのしっぽ: Mac OS X Mountain Lion で RaspberryPi とシリアル接続する: http://cat-s-tail.blogspot.jp/2013/10/Mac-OS-X-Mountain-Lion-RaspberryPi-serial.html

#### シリアルコンソールの接続コマンドについて追記 ####
screenコマンドで接続できたため、方法を載せます。
viでファイルを開いた時など、表示がかなり崩れます。

```bash
screen /dev/tty.usbserial*
# もしくは
screen /dev/tty.usbserial* 115200
```
115200は、ボーレート(bps)です。  
Enterを押していると、文字化けした文字が表示されますが、何度かEnterを入力することで`raspberrypi login:`が表示されます。
画面を終了する場合、^a+k(Ctrl+a+k)でyを入力してください。
