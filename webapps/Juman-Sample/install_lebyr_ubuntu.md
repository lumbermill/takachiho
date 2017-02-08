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
  - Class::Accessor::Fast
  - Parse::Yapp 
  - CDB_File Unicode::Japanese 
  - Class::Data::Inheritable 
  - IO::Scalar

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

### READMEのsetupに従う
https://github.com/murawaki/lebyr/blob/master/README.md#setup
### ソースコードの入手
```
$ git clone https://github.com/murawaki/lebyr.git
```

### Makefile.PLを修正
7行目
```
our $tx_prefix = '$(HOME)/local'; # bad hack
```
を
```
our $tx_prefix = '/usr/local/';
```
にする。

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

### JUMAN++辞書のコンパイル
perlのライブラリパスにJUMAN付属のperlライブラリのパス（juman-7.01/perl/blib/lib）を追加 
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
````

## prefs を編集して辞書、モデル等のパスを修正
（prefsの書式？） 

## 環境変数 JUMAN_PREFIX を設定 (JUMAN バイナリの prefix)
（juman++のフルパスを設定すれば良い？）

