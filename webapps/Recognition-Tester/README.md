# Recognition-Tester
## このプログラムについて
このプログラムは 「WEB+DB PRESS Vol83」の特集記事「[実践]画像認識」のサンプルコードをベースとした画像認識システムです。

作者様((有)来栖川電算 山口陽平様)の許諾を得て開発を開始しました。

オリジナルは以下よりダウンロードできます。

http://gihyo.jp/magazine/wdpress/archive/2014/vol83/support

## 使い方
### 必要なソフトウェア
- Java1.8
- OpenCV3.1

### 必要なソフトウェアをインストール
#### Mac
```
$ brew opencv3 --with-java
```

#### Linux (Ubuntu)
```
$ sudo apt-get update

# Javaインストール
$ sudo apt-get install default-jdk
$ sudo apt-get install ant

# OpenCV3.1インストール
$ sudo apt-get install build-essential
$ sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
$ sudo apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
$ sudo apt-get install unzip

$ mkdir ~/src
$ cd  ~/src
$ wget https://github.com/Itseez/opencv/archive/3.1.0.zip
$ unzip 3.1.0.zip
$ cd opencv-3.1.0/
$ mkdir release
$ cd release
$ export JAVA_HOME=/usr/lib/jvm/default-java/
$ cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..
$ make
$ sudo make install
```

### ソースコードをclone
```
$ git clone https://github.com/lumbermill/takachiho.git
$ cd takachiho/webapps/Recognition-Tester # ここがシステムディレクトリになります
```

### OpenCVライブラリをシステムディレクトリにコピー
#### Mac
```
$ cp /usr/local/Cellar/opencv3/3.1.0_3/share/OpenCV/java/* ./libs/
$ mv ./libs/libopencv_java310.so ./libs/libopencv_java310.dylib
```

#### Linux (Ubuntu)
```
$ cp /usr/local/share/OpenCV/java/* libs/
```

### 訓練画像とラベル画像を配置
訓練画像は以下のように (商品ID)/(連番).jpg という形式で配置します。
```
data/train-image/
├── 1
│   ├── 0.jpg
│   ├── 1.jpg
│   ├── 2.jpg
│   ├── 3.jpg
│   ├── 4.jpg
│   ├── 5.jpg
│   ├── 6.jpg
│   └── 7.jpg
├── 2
│   ├── 0.jpg
│   ├── 1.jpg
│   ├── 2.jpg
│   ├── 3.jpg
│   ├── 4.jpg
│   ├── 5.jpg
│   ├── 6.jpg
│   └── 7.jpg
      :
      :
```

商品のラベル情報を data/train-image/item_list.txt に以下の形式で記述します。
カンマ区切りで、(商品ID),(JANコード),(商品名)の順になります。
```
1,JANCODE_1,C.C.レモン
2,JANCODE_2,Gokuriグレープフルーツ
3,JANCODE_3,オランジーナ
4,JANCODE_4,ボス贅沢微糖
5,JANCODE_5,サントリーウーロン茶
6,JANCODE_6,ボス無糖ブラック
```

ラベル画像は以下のように (商品ID).jpg という形式で配置します。
訓練画像の商品IDと一致するように注意してください。
```
webapp/label-image/
├── 1.jpg
├── 2.jpg
├── 3.jpg
├── 4.jpg
├── 5.jpg
└── 6.jpg
```

### サーバ起動
プログラムが配置されたディレクトリ（build.gradleのあるディレクトリ）で
以下のコマンドを実行すると自動的にソースコードがコンパイルされ、httpサーバがポート番号8080で起動します。
```
$ ./gradlew run&
```

ログアウトするとプロセス終了してしまう場合は
```
$ nohup ./gradlew run&
```
として下さい。
