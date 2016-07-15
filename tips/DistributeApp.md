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
　　スクリーンショットサイズ
　　　　　　　　　　　　　　iphone4 サイズの3.5インチ(640×920 pixel)
　　　　　　　　　　　　　　iphone5 サイズの  4インチ(640×1136 pixel)
　　　　　　　　　　　　　　iphone6 サイズの4.7インチ(650×1334 pixel)
　　　　　　　　　　　　　　iphone6sサイズの5.5インチ(1242×2208 pixel)
　　　　　　　　　　　　　　ipad    サイズの        (768×1024 pixel)
　　　　　　　　　　　　　　ipad proサイズの        (2048×2732 pixel)
　　の6サイズを最大5枚まで用意します(2016年6月現在)
　　　
　　アイコンも下記の11サイズ用意します　　　
　　　　　　　　　　　　　　29×29 pixe
　　　　　　　　　　　　　　40×40 pixel
　　　　　　　　　　　　　　58×58 pixel
　　　　　　　　　　　　　　76×76 pixel
　　　　　　　　　　　　　　80×80 pixel
　　　　　　　　　　　　　　87×87 pixel
　　　　　　　　　　　　　　120×120 pixel
　　　　　　　　　　　　　　152×152 pixel
　　　　　　　　　　　　　　160×160 pixel
　　　　　　　　　　　　　　167×167 pixel
　　　　　　　　　　　　　　180×180 pixel

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
