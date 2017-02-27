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
```
# 未知語の取得＆辞書作成＆辞書配備
$ ruby aggrigate.rb

# 解析誤りの修正
$ cat ~/src/jumanpp-1.01/dict-build/userdic/* | ruby ./bin/make_partial_from_dic.rb > ~/src/jumanpp-1.01/part-sample.txt
$ cat part-sample.txt | jumanpp --partial | ruby script/corpus2train.rb > partial.fmrp
$ cat train.fmrp partial.fmrp > part_train.fmrp
$ nohup jumanpp --train part_train.fmrp --outputmodel part_trained.mdl &

# 修正済み解析機を配備
$ sudo mv /usr/local/share/jumanpp/weight.mdl.map /usr/local/share/jumanpp/weight.mdl.map.bak #古い訓練データを移動
$ sudo mv /usr/local/share/jumanpp/weight.mdl /usr/local/share/jumanpp/weight.mdl.bak         #古い訓練データを移動
$ sudo cp part_trained.mdl /usr/local/share/jumanpp/weight.mdl
$ sudo su
# echo "" | jumanpp #キャッシュ再作成
# exit
```
