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

