# 辞書登録について
## 登録手順
- 詳しくはマニュアル参照のこと
 - http://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-manual-1.01.pdf

### ユーザ辞書の追加
ユーザが辞書を追加し、解析を行うには辞書のコンパイルを行う必要がある。辞書のコンパイルに必要なスクリプトは、配布アーカイブの展開先にある dict-buildディレクトリ内にある。

ユーザ辞書をシステムに追加するには、ユーザ辞書を 3.2.1 節に従って作成し、そのファイルをdict-build/userdic/ 以下に追加する。同ディレクトリ内に複数のユーザ辞書があってもよい。ユーザ辞書の作成はこのリポジトリの bin/make_entry.rb を使うと便利である。（後述）

その後 dict-build ディレクトリ内で以下の手順を実行し、辞書のコンパイルとインストールを行う。インストール先を指定する場合は、 install.sh に --prefix /path/to/somewhere/ オプションを付加する。
```
$ make
$ sudo ./install.sh
```

### 解析誤りの修正
JUMAN++の解析誤りのために辞書に登録した単語が分割されてしまうことがある。
- 例) コーポレート・ガバナンス （ユーザ辞書に登録した単語）
```
$ echo "コーポレート・ガバナンス" | jumanpp
コーポレート コーポレート コーポレート 名詞 6 普通名詞 1 * 0 * 0 "自動獲得:Wikipedia Wikipediaページ内一覧:コナミ"
・ ・ ・ 特殊 1 記号 5 * 0 * 0 NIL
ガバナンス ガバナンス ガバナンス 名詞 6 普通名詞 1 * 0 * 0 "自動獲得:Wikipedia Wikipedia上位語:プロセス/ぷろせす"
EOS
### 必ずしも誤りとは言えないが、辞書に登録したものと同じ結果が得られない。
```

このような場合は解析器の再学習を行うことによって解析誤りの修正を行う(JUMAN++マニュアル 「5.3 部分アノテーションを用いた訓練」に記載の手順に準拠)。
登録した単語がどのように分割されるかは単語数が多くなると確認が困難であるため、ユーザ辞書を登録した場合には毎回再学習が必要になってくる。

上記の例の場合は以下のようにする。

- 学習データ作成（part-sample.txtに大量の語彙を追加する場合にはこのリポジトリの bin/make_partial.rb を使うと便利である。（後述））
```
$ cat xxxx.knp ... yyyy.knp | ruby script/corpus2train.rb > train.fmrp
$ echo -e "\tコーポレート・ガバナンス\t" > part-sample.txt  # part-sample.txtには複数の単語を登録できる
$ cat part-sample.txt | jumanpp --partial | ruby script/corpus2train.rb > partial.fmrp
```
- 再学習（解析器の作成。part_trained.mdlが解析器ファイル。）
```
$ cat train.fmrp partial.fmrp > part_train.fmrp
$ jumanpp --train part_train.fmrp --outputmodel part_trained.mdl
```
- 解析器を配備
```
$ sudo mv /usr/local/share/jumanpp/weight.mdl.map /usr/local/share/jumanpp/weight.mdl.map.bak #古い訓練データを移動
$ sudo mv /usr/local/share/jumanpp/weight.mdl /usr/local/share/jumanpp/weight.mdl.bak         #古い訓練データを移動
$ sudo cp part_trained.mdl /usr/local/share/jumanpp/weight.mdl
$ sudo su
# echo "" | jumanpp #キャッシュ再作成
# exit
```

.knpファイルは京都大学テキストコーパス、京都大学ウェブ文書リードコーパスに含まれている。予めダウンロードする。
- [京都大学テキストコーパス](http://nlp.ist.i.kyoto-u.ac.jp/index.php?京都大学テキストコーパス) 別途有償のCD-ROMが必要
- [京都大学ウェブ文書リードコーパス](http://nlp.ist.i.kyoto-u.ac.jp/index.php?KWDLC)

詳しくはJUMAN++のマニュアル参照のこと。

#### 再学習の所要時間について
再学習にかかる時間は環境や学習するコーパスの規模にもよるが、他の処理と比較して長時間を要する。
参考のため、以下に複数の環境で所要時間を計測した結果を記載しておく。

いずれのケースも京都大学ウェブ文書リードコーパスとごく小規模な部分アノテーションを使用してさくらのクラウド上のUbuntu14.06サーバで実施した。
メモリ容量よりもCPUコア数の追加の方がより処理時間の短縮に寄与しているが、コア数が4コア以上になっても性能は頭打ちになっている。

|     |1GB|4GB|8GB|16GB|
|-----|---|---|---|----|
|1core|7.0|-- |-- |--  |
|4core|-- |2.5|2.2|--  |
|8core|-- |-- |-- |2.1 |
(単位：時間)

## マニュアルに記載されていない手順(上記手順の前に実施する)
### Makefileの修正
Ubuntuではデフォルトのシェルがdashであるため、bash前提で記述されたMakefileがエラーになる。
そこでdict-buid配下のMakefileの先頭に以下の1行を記載する。
```
SHELL=/bin/bash
```

### Perlスクリプトの修正
ユーザ辞書のコンパイルのために dict-build/scripts/jumandic2morphdic.perl というスクリプトを実行するが、
バグが残っている(使用しないモジュールの参照が残っている)ため以下の行をコメントアウトする。
- 4行目
```
#use Juman;
```

- 8行目
```
#use Inflection;
```

### zshのインストール
install.sh は zshで記述されているためzshのインストールが必要である。
```
apt-get install zsh
```

### install.shの修正
辞書のインストール先ディレクトリが間違っているため、25,28,29,31,32,38行目のjumanpp-resourceをjumanppにする。
```
25c25
< mkdir -p $PREFIX/jumanpp-resource
---
> mkdir -p $PREFIX/jumanpp
28,29c28,29
< echo cp $DICDIR/dic.base $DICDIR/dic.bin $DICDIR/dic.da $DICDIR/dic.form $DICDIR/dic.form_type $DICDIR/dic.imis $DICDIR/dic.pos $DICDIR/dic.read $DICDIR/dic.rep $DICDIR/dic.spos $PREFIX/jumanpp-resource/.
< cp $DICDIR/dic.base $DICDIR/dic.bin $DICDIR/dic.da $DICDIR/dic.form $DICDIR/dic.form_type $DICDIR/dic.imis $DICDIR/dic.pos $DICDIR/dic.read $DICDIR/dic.rep $DICDIR/dic.spos $PREFIX/jumanpp-resource/.
---
> echo cp $DICDIR/dic.base $DICDIR/dic.bin $DICDIR/dic.da $DICDIR/dic.form $DICDIR/dic.form_type $DICDIR/dic.imis $DICDIR/dic.pos $DICDIR/dic.read $DICDIR/dic.rep $DICDIR/dic.spos $PREFIX/jumanpp/.
> cp $DICDIR/dic.base $DICDIR/dic.bin $DICDIR/dic.da $DICDIR/dic.form $DICDIR/dic.form_type $DICDIR/dic.imis $DICDIR/dic.pos $DICDIR/dic.read $DICDIR/dic.rep $DICDIR/dic.spos $PREFIX/jumanpp/.
31,32c31,32
< echo cd $PREFIX/jumanpp-resource/
< cd $PREFIX/jumanpp-resource/
---
> echo cd $PREFIX/jumanpp/
> cd $PREFIX/jumanpp/
38c38
< echo "" | jumanpp -D $PREFIX/jumanpp-resource/
---
> echo "" | jumanpp -D $PREFIX/jumanpp/
```

## 辞書ファイル/学習データファイル作成スクリプト
このリポジトリには辞書ファイルと解析誤りの修正のために使用する学習データファイルを作成するためのスクリプトが存在する。（make_entry.rb, make_partial.rb）
これらのスクリプトを使用すると、一つのソースファイルから辞書ファイルと学習データファイルの両方を自動で生成できる。
以下でこれらの使い方を説明する。
### 下準備
以下のようなフォーマットのファイル(input.txt)を用意する。辞書の名前、見出し語、代表表記、読みがタブで区切られている。
```
地名	青森県	青森県	あおもりけん
地名	岩手県	岩手県	いわてけん
地名	秋田県	秋田県	あきたけん
地名	宮城県	宮城県	みやぎけん
地名	山形県	山形県	やまがたけん
地名	福島県	福島県	ふくしまけん
地名	茨城県	茨城県	いばらぎけん
```
Excel等の表計算ソフトを使うと簡単である。Excel上で上記フォーマットのデータを作成し、データの範囲をコピーして以下のコマンドを実行すると簡単に作ることができる。
```
pbpaste | tr "\r" "\n" > input.txt
```

### 辞書ファイルの作成（make_entry.rb）
input.txt をmake_entry.rbに渡すと標準出力に辞書ファイルの中身が出力される。出力された辞書ファイルはjuman++のソースディレクトリ配下の dict-build/userdicに配置し、辞書登録を行う。
```
ruby make_entry.rb input.txt > place-name.dic
```
### 学習データファイルの作成（make_partial.rb）
input.txt をmake_partial.rbに渡すと標準出力に学習データファイルの中身が出力される。解析誤りの修正に使用する。
```
ruby make_partial.rb input.txt > part-sample.txt
```
### 辞書ファイルから学習データファイルの作成（make_partial_from_dic.rb）
input.dic をmake_partial_from.rbに渡すと標準出力に学習データファイルの中身が出力される。解析誤りの修正に使用する。
既に辞書ファイルが存在する場合はこちらを使用したほうが便利。
```
cat input.txt | ruby make_partial.rb  > part-sample.txt
```
