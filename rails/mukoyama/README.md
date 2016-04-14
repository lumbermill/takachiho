# mukoyama
Raspberry Piで測定した温度データを受け取り、データベース化します。
設定した閾値を超えた（下回った）際などに警告メールを送ります。

- 気温の変化のグラフ表示
  - 日間、月間、年間の三種類
  - 設定した閾値（上限、下限）に直線を表示
- 警告送信先アドレス（複数？）管理
- 閾値（上限、下限）管理
- メール送信履歴表示

* 管理 = 一覧表示、追加、更新、削除のCRUD機能

- メール配信
  - データの定期受信がなかった場合
  - 温度が閾値の外に出た場合

## 将来の展望
- ユーザ管理
  - 複数のRaspberry Piからの通知を一元管理
- 閾値の動的な設定

## ソフトウェア
- Ruby on Rails
- MySQL
- Highchart
- Bootstrap

温度測定とデータ送信部分は ../raspi/01-mukoyama を参照してください。

## データ読み込み&メール送信設定
crontabに以下を設定します。  
tmpr_check.rbの引数に`1`を指定していますが、これはraspberrypiIDです。  
監視したいraspiのIDを1つだけ指定することができます。  

```
1,11,21,31,41,51 * * * * ruby /var/www/mukoyama/current/lib/tasks/tmpr_insert.rb
2,12,22,32,42,52 * * * * cd /var/www/mukoyama/current && rails runner -e staging lib/tasks/tmpr_check.rb 1
```
