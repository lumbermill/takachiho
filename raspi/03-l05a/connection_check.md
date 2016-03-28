#2016/2/28 L-05A + ZeroSIM + Raspberry Pi (model A) 動作確認
## 状況
- Raspberry PiでUSBハブを経由するとネット接続できるのに直挿しするとできない
- wvdialコマンドをシェルから実行すると接続できるが、rc.localから自動実行すると失敗する。

## ゴール
Raspberry Piに直挿しして正しく通信できるようにする。
もしくは、できない理由を明らかにするか、回避策を見つける。（最悪でもUSBハブ経由で確実にネット接続できるようにする）

##まずは L-05A + 0 SIM動作確認
L-05A + ZeroSIMが壊れていないことを確認。ドライバをMacにインストールして接続できるか試す。

- 以下のページからドライバ（Mac OS X 10.9～10.9.3用 L05A_CM_Driver_for_Mac_V1.05.zip）をダウンロード
　https://www.nttdocomo.co.jp/support/utilization/application/foma/utility/card/l05a/#p05
- インストーラを起動し、画面の指示にしたがってインストール
- MacのUSBポートに挿すと外部ディスクとして認識される。
- L-05Aの電源・Wifiランプはグリーン
- L-05A接続ソフトを起動するが、アプリの画面に「FOMA端末初期化中..」の表示が出たまま変化なし。
- Macのバージョン（10.11.3）と合っていないせいかも。確認できず。

##0 SIM開通確認
手持ちのiPhone6に0 SIMを挿し、以下のURLの手順に従い構成プロファイルをインストールすると普通に通信できる。0SIM自体の通信は問題なし。
http://docomosmart.net/0simiphoneandroid/

##Raspberry Piに接続して確認
- ハブ無しの状態でRaspberryPiの中身を見るためにシリアルコンソールを使用して確認
- 設定し、wvdialコマンドを実行すると接続できる。
- Raspberry Piの電源を落とし、rc.localから起動させると接続できない。
- しばらく待って再度wvdialコマンドを実行すると接続できる。
- 実行中のwvdialのプロセスをkillすると通信を切断する旨のメッセージが表示される
- 電源ONからだと初回は接続に失敗する。2回めはOK

##対策
- 起動スクリプトを工夫して起動に失敗した時はもう1度接続するようにした→別紙