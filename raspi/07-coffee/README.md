# Tensorflowで珈琲豆選別計画

## Goal
- コンベア上に豆を流す、あるいはシュートを落下させて一粒ずつ写真を撮ります。
- 撮影した画像を分類し、良品と不良品に選別します。

市販の卓上選別機に近いことを「普通のカメラ + Tensorflow」で実現することが目的です。

- 参考: 超小型卓上選別機L(エル)ファントBSー01 安西製作所

## TODOs
- 分類器の作成
　- 豆の写真を撮る(32x32 3000枚 cifar-10 datasetと揃える)
　- きゅうりの画像でも試してみる(CUCUMBER-9)
- 分類アプリの作成
  - 何らかのトリガ(通過センサ?一定間隔?)で写真を撮影し、分類結果を返す
  - 返された結果を電気信号に出力する(不良の場合LEDが点灯するなど)
  - その信号を使って、豆を仕分ける機構を考える

参考URL:
http://www.cs.toronto.edu/~kriz/cifar.html
https://github.com/workpiles/CUCUMBER-9


http://qiita.com/lumbermill/items/767ef1420dabffc776af - TensorflowをiOS向けにビルド
http://qiita.com/lumbermill/items/010920d264806b903e5f - cifarから画像を取り出す(extract.py)
