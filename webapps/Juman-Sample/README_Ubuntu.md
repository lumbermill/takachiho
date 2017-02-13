## 環境構築
さくらのクラウド上のUbuntu16.04.1 LTSにインストール
- JUMAN++マニュアル：http://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-manual-1.01.pdf

### 事前準備
```
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt install libboost-dev
$ sudo apt install make gcc g++
$ sudo apt install python-pip
$ sudo apt install ruby
$ sudo apt install xz-utils #xz形式のアーカイブを展開するために必要
$ mkdir ~/src
```

### JUMAN++インストール
```
$ cd ~/src
$ wget http://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-1.01.tar.xz
$ tar xJfv jumanpp-1.01.tar.xz
$ cd jumanpp-1.01/
$ ./configure
$ make
$ sudo make install
```

### PyKNP(Pythonバインディング)インストール
```
$ cd ~/src
$ sudo pip install --upgrade pip
$ sudo pip install prettyprint six
$ wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/pyknp-0.3.tar.gz
$ tar xvf pyknp-0.3.tar.gz
$ cd pyknp-0.3
$ sudo python setup.py install
```

### 環境構築の注意
- 依存ライブラリが存在しない等の理由でコンパイルエラーになった場合は問題を解決した後、
```
$ make clean
$ sudo ldconfig
```
した後に./configureからやり直して下さい。

- ネット上の記事にはpyKNPを動作させるためにJUMANとKNPが必要と記載しているものもあるが、実際には不要。

### その他
```
$ sudo apt-get install apache2 php libapache2-mod-php php-mbstring
```
