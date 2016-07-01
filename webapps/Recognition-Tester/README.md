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

#### Linux (CentOS7)
```
# Java1.8 インストール
$ sudo yum install java-1.8.0-openjdk-devel

# OpenCV3.1インストール
$ sudo yum install cmake
$ sudo yum install gcc gcc-c++
$ wget https://github.com/Itseez/opencv/archive/3.1.0.zip
$ unzip 3.1.0.zip
$ cd opencv-3.1.0
$ mkdir release
$ cd release
$ cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..

# 8080ポートを開放
$ sudo firewall-cmd --add-port=8080/tcp

#開いているポートを確認(結果は割愛)
$ firewall-cmd --list-ports --zone=public 
```
- OpenCV3.1のインストール手順は以下を参考にしました。
 - https://blog.kevin-brown.com/programming/2014/09/27/building-and-installing-opencv-3.html

### ソースコードをcron

### OpenCVライブラリをシステムディレクトリにコピー
#### Mac
```
$ cd /path/to/Recognition-Tester
$ cp /usr/local/Cellar/opencv3/3.1.0_3/share/OpenCV/java/libopencv_java310.so ./libs/
$ cp /usr/local/Cellar/opencv3/3.1.0_3/share/OpenCV/java/opencv-310.jar ./libs/
$ mv ./libs/libopencv_java310.so ./libs/libopencv_java310.dylib
```

#### Linux (CentOS7)

### サーバ起動
プログラムが配置されたディレクトリ（build.gradleのあるディレクトリ）で
``` $ ./gradlew run& ``` すると
自動的にソースコードがコンパイルされ、httpサーバがポート番号8080で起動します。
