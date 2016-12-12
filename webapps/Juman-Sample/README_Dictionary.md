# 辞書登録について
## 登録手順
- マニュアルより引用
 - http://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-manual-1.01.pdf

### ユーザ辞書の追加
ユーザが辞書を追加し，解析を行うには辞書のコンパイルを行う必要がある．辞書のコンパイル
に必要なスクリプトは，配布アーカイブの展開先にある dict-build
ディレクトリ内にある．
ユーザ辞書をシステムに追加するには，ユーザ辞書を 3.2.1 節に従って作成し，そのファイルを
dict-build/userdic/ 以下に追加する．同ディレクトリ内に複数のユーザ辞書があってもよい．
その後 dict-build ディレクトリ内で以下の手順を実行し，辞書のコンパイルとインストールを行
う．インストール先を指定する場合は， install.sh に --prefix /path/to/somewhere/ オプションを付加する．
```
% make
% sudo ./install.sh
```

## 解析誤りの修正
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

このような場合は解析誤りの修正を行う。(JUMAN++マニュアル 5.3 部分アノテーションを用いた訓練に記載の手順に準拠)
上記の例の場合は以下のようにする。
```
$ echo -e "\tコーポレート・ガバナンス\t" > part-sample.txt  # part-sample.txtには複数の単語を登録できる
$ cat part-sample.txt | jumanpp --partial | ruby script/corpus2train.rb > partial.fmrp
$ cat train.fmrp partial.fmrp > part_train.fmrp
$ jumanpp --train part_train.fmrp --outputmodel part_trained.mdl
```
詳しくはJUMAN++のマニュアル参照のこと。

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

