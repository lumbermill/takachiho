# iOSアプリ申請手順
1. iTunes connectで新規Appを作成します。
  - バンドルIDには逆ドメインを使用するのが一般的なようです。
  - SKUはバンドルIDと同じで構いません。
  - カテゴリを選択します。
  - 保存ボタンの押し忘れに注意してください。
1. 価格及び配信状況を入力します。
  - 価格を選択します。
  - 「配信可否」はデフォルトでは全世界になっています。
  - 保存ボタンの押し忘れに注意してください。
1. スクリーンショット・概要文を登録します。
1. Xcodeを開き、Product->Archiveを選択します。
  - Archiveを選択できない場合、Deviceを「Generic iOS Device」にしてください。
1. 「Upload to App Store」をクリックします。その後、流れに沿うとアップロードできます。
  - 失敗する場合、「validate...」をした後、もう一度「Upload to App Store」をクリックしてみてください。

# 資料
- [アプリケーションの配布に関するガイド](https://developer.apple.com/jp/documentation/AppDistributionGuide.pdf)
- [Next
About App Distribution Workflows](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/Introduction/Introduction.html)
- [iOS Developer Enterpriseで社内向けiPhoneアプリを作る方法 [完全版]](https://iritec.jp/iphone/3355/)
- [iOSアプリ申請・公開手順まとめ 〜2016年3月版〜](http://kinsentansa.blogspot.jp/2016/03/ios-20163.html)
#
- 2016/06/24 初版
