# JUMAN++辞書自動取得プログラム
url_listディレクトリ配下のリストからテキストを取得し、lebyrに渡して未知語の辞書を作成します。
## url_listの書式
以下の用にURLを改行で区切って記述します。
```
https://ja.wikipedia.org/wiki/%E5%9C%B0%E7%86%B1%E7%99%BA%E9%9B%BB
https://ja.wikipedia.org/wiki/%E7%99%BA%E9%9B%BB
https://ja.wikipedia.org/wiki/%E5%86%8D%E7%94%9F%E5%8F%AF%E8%83%BD%E3%82%A8%E3%83%8D%E3%83%AB%E3%82%AE%E3%83%BC
https://ja.wikipedia.org/wiki/%E5%9C%B0%E7%90%83%E6%B8%A9%E6%9A%96%E5%8C%96
```

## 実行方法
設定ファイルをLEBYR_PREFS環境変数に設定します。
```
LEBYR_PREFS=./lebyr_prefs ruby aggrigate.rb
```
