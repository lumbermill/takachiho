# lebyrインストール関係メモ
https://github.com/murawaki/lebyr
## 依存ライブラリ
- JUMAN++ 
  - http://nlp.ist.i.kyoto-u.ac.jp/index.php?JUMAN++
- JUMAN
　JUMAN++を使用する場合でも、辞書を lebyr 向けにコンパイルするために必要
  - http://nlp.ist.i.kyoto-u.ac.jp/index.php?JUMAN
- KNP
  - http://nlp.ist.i.kyoto-u.ac.jp/?KNP
- tynycdb
  - http://www.corpit.ru/mjt/tinycdb.html
  - ```$ sudo apt install tinycdb```
- tx
  - https://code.google.com/archive/p/tx-trie/
  - https://github.com/hillbig/tx-trie
- CPANモジュール
  - CDB_File 
  - Parse::Yapp 
  - Unicode::Japanese 
  - Class::Accessor::Fast
  - Class::Data::Inheritable 
  - IO::Scalar

### JUMAN++インストール
- https://github.com/lumbermill/takachiho/blob/master/webapps/Juman-Sample/README_Ubuntu.md

### JUMANインストール
```
$ wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/juman/juman-7.01.tar.bz2
$ tar xvjf juman-7.01.tar.bz2
$ cd juman-7.01
$ ./configure
$ make
$ sudo make install
$ ldconfig
```

### KNPインストール
```
$ wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/knp-4.16.tar.bz2
$ tar xvjf knp-4.16.tar.bz2
$ cd knp-4.16/
$ ./configure
$ make
$ sudo make install
```

### txインストール
```
$ sudo apt install automake libtool zlib1g-dev
$ git clone https://github.com/hillbig/tx-trie
$ cd tx-trie
$ ./autogen.sh
$ ./configure
$ make 
$ sudo make install
```

### CPANモジュールインストール
```
$ sudo cpan install Class::Accessor::Fast Parse::Yapp CDB_File Unicode::Japanese Class::Data::Inheritable IO::Scalar
```
## lebyrインストール

### ソースコードの入手
本家リポジトリは上手く動作しなかったためForkされた修正版を使用する。
```
$ git clone https://github.com/koki-h/lebyr.git
```

### コンパイル
```
$ cd $LEBYR-ROOT-DIR/tx
$ perl Makefile.PL
$ make
$ make install
```

### 各種モデルのダウンロード
```
$ cd $LEBYR-ROOT-DIR
$ wget http://lotus.kuee.kyoto-u.ac.jp/~murawaki/lebyr/lebyr-model-20160407.tar.bz2
$ tar jxvf lebyr-model-20160407.tar.bz2
```

### JUMAN辞書のコンパイル
perlのライブラリパスにJUMAN付属のperlライブラリのパス（juman-7.01/perl/blib/lib）を追加 
```
$ cd $LEBYR-ROOT-DIR
$ mkdir -p data/dic
$ perl -Ilib -I../juman-7.01/perl/blib/lib unknown/makedic.pl --inputdir $JUMAN_SOURCE_PATH/dic --outputdir data/dic
$ mkdir -p data/autodic
$ perl -Ilib -I../juman-7.01/perl/blib/lib unknown/makedic.pl --inputdir $JUMAN_SOURCE_PATH/autodic --outputdir data/autodic
$ mkdir -p data/wikipediadic
$ perl -Ilib -I../juman-7.01/perl/blib/lib unknown/makedic.pl --inputdir $JUMAN_SOURCE_PATH/wikipediadic --outputdir data/wikipediadic
```
<!--
###JUMAN++辞書のコンパイル
```
$ mkdir -p data/dic
$ perl -Ilib -I../juman-7.01/perl/blib/lib unknown/makedic.pl --inputdir ../jumanpp-1.01/dict-build/dic/  --outputdir data/dic
$ mkdir -p data/webdic
$ perl -Ilib -I../juman-7.01/perl/blib/lib unknown/makedic.pl --inputdir ../jumanpp-1.01/dict-build/webdic/  --outputdir data/webdic
$ mkdir -p data/wikipediadic
$ perl -Ilib -I../juman-7.01/perl/blib/lib unknown/makedic.pl --inputdir ../jumanpp-1.01/dict-build/wikipediadic/  --outputdir data/wikipediadic
$ mkdir -p data/wiktionarydic
$ perl -Ilib -I../juman-7.01/perl/blib/lib unknown/makedic.pl --inputdir ../jumanpp-1.01/dict-build/wiktionarydic/  --outputdir data/wiktionarydic
$ mkdir -p data/onomatopedic
$ perl -Ilib -I../juman-7.01/perl/blib/lib unknown/makedic.pl --inputdir ../jumanpp-1.01/dict-build/onomatopedic/  --outputdir data/onomatopedic
```
-->

### prefs を編集して辞書、モデル等のパスを修正
```
$ cp /usr/local/etc/jumanrc ~/.jumanrc
```

- /home/murawaki/reserch/lebyrをlebyrのソースディレクトリ(ex:/home/ubuntu/src/lebyer)に変更
- main-dictionary.db-pathをJUMAN辞書のコンパイルで--outputdirに指定したパスに変更
- juman.rcfileとmain-dictionary.rc-pathを/home/murawaki/.jumanrcから現在ユーザのホームディレクトリ(ex:/home/ubuntu/.jumanrc)に変更
- analyzer-juman.jumanrc-autodicを/home/murawaki/.jumanrc.autodicから現在ユーザのホームディレクトリ(ex:/home/ubuntu/.jumanrc.autodic)に変更

```
$ diff prefs_orig prefs
3c3
<     'juman.rcfile' => '/home/murawaki/.jumanrc', # must be overridden
---
>     'juman.rcfile' => '/home/ubuntu/.jumanrc', # must be overridden
6,9c6,9
<     'unknown-word-detector.rule-file' => '/home/murawaki/research/lebyr/data/undefRule.storable',
<     'unknown-word-detector.decomposition-rule-file' => '/home/murawaki/research/lebyr/data/decomposition.storable',
<     'unknown-word-detector.repname-list' => '/home/murawaki/research/lebyr/data/cfRepname.storable',
<     'unknown-word-detector.repname-ngram' => '/home/murawaki/research/lebyr/data/repnameNgram.storable',
---
>     'unknown-word-detector.rule-file' => '/home/ubuntu/src/lebyr/data/undefRule.storable',
>     'unknown-word-detector.decomposition-rule-file' => '/home/ubuntu/src/lebyr/data/decomposition.storable',
>     'unknown-word-detector.repname-list' => '/home/ubuntu/src/lebyr/data/cfRepname.storable',
>     'unknown-word-detector.repname-ngram' => '/home/ubuntu/src/lebyr/data/repnameNgram.storable',
11,16c11,16
<     'suffix-list.path' => '/home/murawaki/research/lebyr/data',
<     'main-dictionary.rc-path' => '/home/murawaki/.jumanrc',
<     'main-dictionary.db-path' => ['/home/murawaki/research/lebyr/data/dic', '/home/murawaki/research/lebyr/data/autodic', '/home/murawaki/research/lebyr/data/wikipediadic'],
<     'morpheme-variant-checker.unihan-db' => '/home/murawaki/research/lebyr/data/unihan.storable',
<     'analyzer-juman.jumanrc-autodic' => '/home/murawaki/.jumanrc.autodic',
<     'morpheme-usage-monitor.fusana-model' => '/home/murawaki/research/lebyr/data/fusana.model',
---
>     'suffix-list.path' => '/home/ubuntu/src/lebyr/data',
>     'main-dictionary.rc-path' => '/home/ubuntu/.jumanrc',
>     'main-dictionary.db-path' => ['/home/ubuntu/src/lebyr/data/dic', '/home/ubuntu/src/lebyr/data/autodic', '/home/ubuntu/src/lebyr/data/wikipediadic'],
>     'morpheme-variant-checker.unihan-db' => '/home/ubuntu/src/lebyr/data/unihan.storable',
>     'analyzer-juman.jumanrc-autodic' => '/home/ubuntu/.jumanrc.autodic',
>     'morpheme-usage-monitor.fusana-model' => '/home/ubuntu/src/lebyr/data/fusana.model',
```

### テスト
unknown/sequential.plを使ってtest/sample.txtを解析し、未知語辞書を作成する。
juman-perl、knp-perl(JUMAN,KNPのソースコードに付属)のライブラリパスを@INCに入れる必要がある。
```
cd $LEBYR-ROOT-DIR
JUMAN_PREFIX=/usr/local perl -Ilib  -I../juman-7.01/perl/blib/lib -I../knp-4.16/perl/lib unknown/sequential.pl --conf=prefs --monitor --dicdir=/tmp/adic --raw test/sample.txt --debug
```
/tmp/adic/output.dic にラ行動詞「ファボる」が登録されていれば成功。

