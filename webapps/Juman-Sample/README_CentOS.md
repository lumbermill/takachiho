## 環境構築

### 事前準備
gcc (4.9 以降)
Boost C++ Libraries (1.57 以降)
が必須なのだが、CentOS7の標準リポジトリではこれらのバージョンが古いため環境構築を断念。
上記の導入ができれば下記の手順でJUMAN++が導入できるはず。

### JUMAN++インストール
```
$ wget http://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-1.01.tar.xz
$ tar xJvf jumanpp-1.01.tar.xz
$ cd jumanpp-1.01
$ ./configure
$ make
$ sudo make install
```

### KNPインストール
```
$ sudo yum install zlib zlib-devel
$ wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/knp-4.16.tar.bz2
$ tar jxvf knp-4.16.tar.bz2
$ cd knp-4.16
$ ./configure
$ make
$ sudo make install
$ knp -v #確認
knp 4.16
```

### PyKNPインストール
```
$ sudo yum install epel-release
$ sudo yum install python-pip
$ sudo pip install pip --upgrade
$ sudo pip install six
$ wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/pyknp-0.3.tar.gz
$ tar xvf pyknp-0.3.tar.gz
$ cd pyknp-0.3
$ sudo pytho setup.py install
```

### 環境構築の注意
- 依存ライブラリが存在しない等の理由でコンパイルエラーになった場合は問題を解決した後、
```
$ make clean
$ sudo ldconfig
```
した後に./configureからやり直して下さい。
